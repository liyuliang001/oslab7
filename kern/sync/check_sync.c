#include <stdio.h>
#include <proc.h>
#include <sem.h>
#include <monitor.h>
#include <assert.h>

#define N 3 // The number of different films 
#define SLEEP_TIME 100
#define USER_NUM 10

uint32_t seed1 = 12;  //RNG seeds
uint32_t seed2 = 12345;
int id_num; //variable for allocate id for an user
semaphore_t id_num_s;

//---------- cinema problem using semaphore -----------------------
semaphore_t film_s[N];  // semaphore for each film
semaphore_t cinema_s;   // semaphore for the cinema
semaphore_t current_s;  // semaphore for the current playing film
semaphore_t wait_num_s[N]; // semaphore for the number of waiting users
semaphore_t rand_s;     // semaphore for RNG
int current_sema;         // current playing film
struct proc_struct *user_proc_sema[USER_NUM];
struct proc_struct *cinema_proc_sema;

volatile int wait_num[N];     // the number of users waiting for film i

uint32_t myrand() {  //A simple random number generator
   down(&rand_s);
   seed1 = 36969 * (seed1 & 65535) + (seed1 >> 16);
   seed2 = 18000 * (seed2 & 65535) + (seed2 >> 16);
   uint32_t re = (seed1 << 16) + seed2;
   up(&rand_s);
   return re; 
}

int switch_film_sema(int arg) {
     int j;
     int tmp[N];          // A temporary array
     while (1) {
        down(&current_s);           //Lock the variable current

        int tot = 0;
        int pre = current_sema;
        for (j = 0; j < N; j++)
           if (wait_num[j] > 0)
              tmp[tot++] = j;      //Find all films for which there is someone waiting.
        if (tot == 0) {            //No body is waiting.
           current_sema = -1;
           cprintf("Semaphore: The cinema stops to play film since there is no waiting user.\n");
           up(&current_s);
        }
        else {
          current_sema = tmp[myrand() % tot];  //Choose a random film for which there is users waiting.
                                        //The reason to do this is to avoid the situation that 
                                        //there is a film never playing.
                                        //A better solution is choose a film according to some
                                        //workload balance principle. 
          cprintf("Semaphore: The cinema starts to play film %d from film %d.\n", current_sema, pre);
          up(&current_s);
          up(&film_s[current_sema]);
        }
        if (pre != -1)
           up(&wait_num_s[pre]);
        cprintf("Semaphore: The cinema is waiting for the next switch\n");
        down(&cinema_s);
    }
    return 0;
}

void try_to_watch_sema(int i) {
     down(&wait_num_s[i]);
     wait_num[i]++;
     down(&current_s);
     if (current_sema == -1) {
         cprintf("Semaphore: wake the cinema to switch the film.\n");
        up(&current_s);
        up(&cinema_s);
     }
     else up(&current_s);
     while (1) {
        down(&current_s);
        if (current_sema == i) {
           up(&current_s); 
           break;
        }
        up(&current_s);
        down(&film_s[i]); //If the current playing film is not i, then waiting.
     }   
     up(&wait_num_s[i]);
}

void quit_watch_sema(int i) {
     down(&wait_num_s[i]);
     wait_num[i]--;
     if (wait_num[i] == 0) {
        cprintf("Semaphore: No user watching film %d, wake cinema to switch.\n", i);
        up(&cinema_s);
        down(&wait_num_s[i]);   //Lock the film i to avoid there is no switching occurs
                                //And unlock it when a switching is done.
     }
     else up(&film_s[i]);
     up(&wait_num_s[i]);
}

void watch_film_sema(int i)  {  // The process of the user id to watch film i
     down(&id_num_s);
     int id = id_num++;
     up(&id_num_s);
     try_to_watch_sema(i);

     cprintf("Semaphore: The user %d is watching film %d.\n", id, i);
     do_sleep(SLEEP_TIME);
     cprintf("Semaphore: The user %d finishes watching film %d\n", id, i);

     quit_watch_sema(i);
}

//-----------------cinema problem using monitor ------------
monitor_t mt, *mtp=&mt;                          // monitor
int current_monitor;
int num_waiting_monitor[N];
struct proc_struct *user_proc_monitor[USER_NUM];
struct proc_struct *cinema_proc_monitor;

int switch_film_monitor(int arg) {
int j;
int tmp[N];          // A temporary array
while (1) {
     down(&(mtp->mutex));    //Enter a monitor routine
     int tot = 0;
     int pre = current_monitor;
     for (j = 0; j < N; j++)
         if (num_waiting_monitor[j] > 0)
            tmp[tot++] = j;      //Find all films for which there is someone wait
     if (tot == 0) {            //No body is waiting.
         current_monitor = -1;
         cprintf("Monitor: The cinema stops to play film since there is no waiting user.\n");
     }
     else {
         current_monitor = tmp[myrand() % tot];  //Choose a random film for which there is users waiting.
                                        //The reason to do this is to avoid the situation that 
                                        //there is a film never playing.
                                        //A better solution is choose a film according to some
                                        //workload balance principle. 
         cprintf("Monitor: The cinema starts to play film %d from film %d.\n", current_monitor, pre);
         cond_signal(&mtp->cv[current_monitor]);
     }
     cprintf("Monitor: The cinema is waiting for the next switch\n");
     cond_wait(&mtp->cv[N]);
     if(mtp->next_count>0)   //Leave a monitor routine
        up(&(mtp->next));
     else
        up(&(mtp->mutex));
}
return 0;
}

void try_to_watch_monitor(int id, int i)  {  // The user id want to watch film i
cprintf("monitor %d %d\n", id, i);
     down(&(mtp->mutex));    //Enter a monitor routine
     
     num_waiting_monitor[i]++;

     if (current_monitor == -1)     //No film is playing
        cond_signal(&mtp->cv[N]); //Wake the cinema process to allocate a new film

     if (current_monitor != i)     
        cond_wait(&mtp->cv[i]);  //Wait if the current playing movie is not i
    
     if(mtp->next_count>0)   //Leave a monitor routine
        up(&(mtp->next));
     else
        up(&(mtp->mutex));
}

void quit_watch_monitor(int i) {
    down(&(mtp->mutex));    //Enter a monitor routine
    
    num_waiting_monitor[i]--; 
    if (num_waiting_monitor[i] == 0)  { //Nobody is watching the current film 
       cprintf("Monitor: Try to wake the cinema\n");
       cond_signal(&mtp->cv[N]); //Wake the cinema process to allocate a new film
    }
    else cond_signal(&mtp->cv[i]);  //Wake the another guy is wathing the same film

    if(mtp->next_count>0)   //Leave a monitor routine
       up(&(mtp->next));
    else
       up(&(mtp->mutex));
}

void watch_film_monitor(int i)  {  // The process of the user id to watch film i
     down(&id_num_s);
     int id = id_num++;
     up(&id_num_s);

     try_to_watch_monitor(id, i);

     cprintf("Monitor: The user %d is watching film %d.\n", id, i);
     do_sleep(SLEEP_TIME);
     cprintf("Monitor: The user %d finishes watching film %d\n", id, i);

     quit_watch_monitor(i);
}

void check_sync(void){
    int i;

    cprintf("Start to check semaphore!\n");
    sem_init(&id_num_s, 1);
    //check semaphore
    id_num = 0;
    sem_init(&cinema_s, 0);
    sem_init(&current_s, 1);
    sem_init(&rand_s, 1);
    for (i = 0; i < N; i++) {
       sem_init(&film_s[i], 1);
       sem_init(&wait_num_s[i], 1);
       wait_num[i] = 0;
    }
    current_sema = -1;

    int pid = kernel_thread(switch_film_sema, NULL, 0);
    if (pid <= 0)
       panic("create the cinema process with sema failed.\n");
    cinema_proc_sema = find_proc(pid); 
    set_proc_name(cinema_proc_sema, "cinema_sema_proc");
    do_sleep(500);  //Wait the cinema process to prepare
    for (i = 0; i < USER_NUM; i++) {  
        uint32_t t = myrand() % N;  //a random film to watch
        cprintf("Semaphore: Create a user want to watch film %d.\n", t);
        int pid = kernel_thread(watch_film_sema, (void *) t, 0);
        if (pid <= 0) {
            panic("create No.%d user with sema failed.\n", i);
        }
        user_proc_sema[i] = find_proc(pid);
        set_proc_name(user_proc_sema[i], "user_sema_proc");
    }

   // do_sleep(5000);

    cprintf("Start to check monitor!\n");
    //check monitor
    monitor_init(&mt, N + 1);
    for (i = 0; i < N; i++)
       num_waiting_monitor[i] = 0;
    current_monitor = -1;

    pid = kernel_thread(switch_film_monitor, NULL, 0);
    if (pid <= 0)
       panic("create the cinema process with monitor failed.\n");
    cinema_proc_monitor = find_proc(pid); 
    set_proc_name(cinema_proc_monitor, "cinema_monitor_proc");
    do_sleep(500);    //Wait the cinema process to prepare
    for(i=0;i<USER_NUM;i++){
        uint32_t t = rand() % N;  //a random film to watch
        cprintf("Monitor: Create a user want to watch film %d.\n", t);
        int pid = kernel_thread(watch_film_monitor, (void *) t, 0);
        if (pid <= 0) {
            panic("create No.%d user with monitor failed.\n", i);
        }
        user_proc_monitor[i] = find_proc(pid);
        set_proc_name(user_proc_monitor[i], "user_monitor_proc");
    }

    cprintf("End of Test\n");
}
