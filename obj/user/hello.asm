
obj/__user_hello.out：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  800020:	bd 00 00 00 00       	mov    $0x0,%ebp

    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  800025:	83 ec 20             	sub    $0x20,%esp

    # call user-program function
    call umain
  800028:	e8 a3 03 00 00       	call   8003d0 <umain>
1:  jmp 1b
  80002d:	eb fe                	jmp    80002d <_start+0xd>
  80002f:	90                   	nop

00800030 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800030:	55                   	push   %ebp
  800031:	89 e5                	mov    %esp,%ebp
  800033:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  800036:	8d 45 14             	lea    0x14(%ebp),%eax
  800039:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80003c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80003f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 20 11 80 00 	movl   $0x801120,(%esp)
  800051:	e8 c5 00 00 00       	call   80011b <cprintf>
    vcprintf(fmt, ap);
  800056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800059:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005d:	8b 45 10             	mov    0x10(%ebp),%eax
  800060:	89 04 24             	mov    %eax,(%esp)
  800063:	e8 80 00 00 00       	call   8000e8 <vcprintf>
    cprintf("\n");
  800068:	c7 04 24 3a 11 80 00 	movl   $0x80113a,(%esp)
  80006f:	e8 a7 00 00 00       	call   80011b <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800074:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80007b:	e8 80 02 00 00       	call   800300 <exit>

00800080 <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  800086:	8d 45 14             	lea    0x14(%ebp),%eax
  800089:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user warning at %s:%d:\n    ", file, line);
  80008c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80008f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800093:	8b 45 08             	mov    0x8(%ebp),%eax
  800096:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009a:	c7 04 24 3c 11 80 00 	movl   $0x80113c,(%esp)
  8000a1:	e8 75 00 00 00       	call   80011b <cprintf>
    vcprintf(fmt, ap);
  8000a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8000b0:	89 04 24             	mov    %eax,(%esp)
  8000b3:	e8 30 00 00 00       	call   8000e8 <vcprintf>
    cprintf("\n");
  8000b8:	c7 04 24 3a 11 80 00 	movl   $0x80113a,(%esp)
  8000bf:	e8 57 00 00 00       	call   80011b <cprintf>
    va_end(ap);
}
  8000c4:	c9                   	leave  
  8000c5:	c3                   	ret    
  8000c6:	66 90                	xchg   %ax,%ax

008000c8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
    sys_putc(c);
  8000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d1:	89 04 24             	mov    %eax,(%esp)
  8000d4:	e8 ad 01 00 00       	call   800286 <sys_putc>
    (*cnt) ++;
  8000d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000dc:	8b 00                	mov    (%eax),%eax
  8000de:	8d 50 01             	lea    0x1(%eax),%edx
  8000e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e4:	89 10                	mov    %edx,(%eax)
}
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    

008000e8 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  8000ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800103:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800106:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010a:	c7 04 24 c8 00 80 00 	movl   $0x8000c8,(%esp)
  800111:	e8 06 05 00 00       	call   80061c <vprintfmt>
    return cnt;
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800119:	c9                   	leave  
  80011a:	c3                   	ret    

0080011b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  800121:	8d 45 0c             	lea    0xc(%ebp),%eax
  800124:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int cnt = vcprintf(fmt, ap);
  800127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012e:	8b 45 08             	mov    0x8(%ebp),%eax
  800131:	89 04 24             	mov    %eax,(%esp)
  800134:	e8 af ff ff ff       	call   8000e8 <vcprintf>
  800139:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  80013c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  800147:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  80014e:	eb 13                	jmp    800163 <cputs+0x22>
        cputch(c, &cnt);
  800150:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800154:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800157:	89 54 24 04          	mov    %edx,0x4(%esp)
  80015b:	89 04 24             	mov    %eax,(%esp)
  80015e:	e8 65 ff ff ff       	call   8000c8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	0f b6 00             	movzbl (%eax),%eax
  800169:	88 45 f7             	mov    %al,-0x9(%ebp)
  80016c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800170:	0f 95 c0             	setne  %al
  800173:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800177:	84 c0                	test   %al,%al
  800179:	75 d5                	jne    800150 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  80017b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80017e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800182:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800189:	e8 3a ff ff ff       	call   8000c8 <cputch>
    return cnt;
  80018e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800191:	c9                   	leave  
  800192:	c3                   	ret    
  800193:	90                   	nop

00800194 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 24             	sub    $0x24,%esp
    va_list ap;
    va_start(ap, num);
  80019d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8001a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8001a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001aa:	eb 16                	jmp    8001c2 <syscall+0x2e>
        a[i] = va_arg(ap, uint32_t);
  8001ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001af:	8d 50 04             	lea    0x4(%eax),%edx
  8001b2:	89 55 e8             	mov    %edx,-0x18(%ebp)
  8001b5:	8b 10                	mov    (%eax),%edx
  8001b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ba:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8001be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8001c2:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8001c6:	7e e4                	jle    8001ac <syscall+0x18>
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
          "a" (num),
          "d" (a[0]),
  8001c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          "c" (a[1]),
  8001cb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          "b" (a[2]),
  8001ce:	8b 5d dc             	mov    -0x24(%ebp),%ebx
          "D" (a[3]),
  8001d1:	8b 7d e0             	mov    -0x20(%ebp),%edi
          "S" (a[4])
  8001d4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    asm volatile (
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001e0:	cd 80                	int    $0x80
  8001e2:	89 c3                	mov    %eax,%ebx
  8001e4:	89 5d ec             	mov    %ebx,-0x14(%ebp)
          "c" (a[1]),
          "b" (a[2]),
          "D" (a[3]),
          "S" (a[4])
        : "cc", "memory");
    return ret;
  8001e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8001ea:	83 c4 24             	add    $0x24,%esp
  8001ed:	5b                   	pop    %ebx
  8001ee:	5e                   	pop    %esi
  8001ef:	5f                   	pop    %edi
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    

008001f2 <sys_exit>:

int
sys_exit(int error_code) {
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_exit, error_code);
  8001f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800206:	e8 89 ff ff ff       	call   800194 <syscall>
}
  80020b:	c9                   	leave  
  80020c:	c3                   	ret    

0080020d <sys_fork>:

int
sys_fork(void) {
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_fork);
  800213:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80021a:	e8 75 ff ff ff       	call   800194 <syscall>
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <sys_wait>:

int
sys_wait(int pid, int *store) {
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_wait, pid, store);
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 44 24 04          	mov    %eax,0x4(%esp)
  800235:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80023c:	e8 53 ff ff ff       	call   800194 <syscall>
}
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <sys_yield>:

int
sys_yield(void) {
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_yield);
  800249:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800250:	e8 3f ff ff ff       	call   800194 <syscall>
}
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <sys_kill>:

int
sys_kill(int pid) {
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_kill, pid);
  80025d:	8b 45 08             	mov    0x8(%ebp),%eax
  800260:	89 44 24 04          	mov    %eax,0x4(%esp)
  800264:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  80026b:	e8 24 ff ff ff       	call   800194 <syscall>
}
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <sys_getpid>:

int
sys_getpid(void) {
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_getpid);
  800278:	c7 04 24 12 00 00 00 	movl   $0x12,(%esp)
  80027f:	e8 10 ff ff ff       	call   800194 <syscall>
}
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <sys_putc>:

int
sys_putc(int c) {
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_putc, c);
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800293:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  80029a:	e8 f5 fe ff ff       	call   800194 <syscall>
}
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <sys_pgdir>:

int
sys_pgdir(void) {
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_pgdir);
  8002a7:	c7 04 24 1f 00 00 00 	movl   $0x1f,(%esp)
  8002ae:	e8 e1 fe ff ff       	call   800194 <syscall>
}
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <sys_gettime>:

int
sys_gettime(void) {
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_gettime);
  8002bb:	c7 04 24 11 00 00 00 	movl   $0x11,(%esp)
  8002c2:	e8 cd fe ff ff       	call   800194 <syscall>
}
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 08             	sub    $0x8,%esp
    syscall(SYS_lab6_set_priority, priority);
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d6:	c7 04 24 ff 00 00 00 	movl   $0xff,(%esp)
  8002dd:	e8 b2 fe ff ff       	call   800194 <syscall>
}
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <sys_sleep>:

int
sys_sleep(unsigned int time) {
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_sleep, time);
  8002ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8002f8:	e8 97 fe ff ff       	call   800194 <syscall>
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    
  8002ff:	90                   	nop

00800300 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  800306:	8b 45 08             	mov    0x8(%ebp),%eax
  800309:	89 04 24             	mov    %eax,(%esp)
  80030c:	e8 e1 fe ff ff       	call   8001f2 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800311:	c7 04 24 58 11 80 00 	movl   $0x801158,(%esp)
  800318:	e8 fe fd ff ff       	call   80011b <cprintf>
    while (1);
  80031d:	eb fe                	jmp    80031d <exit+0x1d>

0080031f <fork>:
}

int
fork(void) {
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  800325:	e8 e3 fe ff ff       	call   80020d <sys_fork>
}
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <wait>:

int
wait(void) {
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  800332:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800339:	00 
  80033a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800341:	e8 db fe ff ff       	call   800221 <sys_wait>
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <waitpid>:

int
waitpid(int pid, int *store) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	89 44 24 04          	mov    %eax,0x4(%esp)
  800355:	8b 45 08             	mov    0x8(%ebp),%eax
  800358:	89 04 24             	mov    %eax,(%esp)
  80035b:	e8 c1 fe ff ff       	call   800221 <sys_wait>
}
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <yield>:

void
yield(void) {
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  800368:	e8 d6 fe ff ff       	call   800243 <sys_yield>
}
  80036d:	c9                   	leave  
  80036e:	c3                   	ret    

0080036f <kill>:

int
kill(int pid) {
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	89 04 24             	mov    %eax,(%esp)
  80037b:	e8 d7 fe ff ff       	call   800257 <sys_kill>
}
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <getpid>:

int
getpid(void) {
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800388:	e8 e5 fe ff ff       	call   800272 <sys_getpid>
}
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  800395:	e8 07 ff ff ff       	call   8002a1 <sys_pgdir>
}
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    

0080039c <gettime_msec>:

unsigned int
gettime_msec(void) {
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  8003a2:	e8 0e ff ff ff       	call   8002b5 <sys_gettime>
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
    sys_lab6_set_priority(priority);
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	89 04 24             	mov    %eax,(%esp)
  8003b5:	e8 0f ff ff ff       	call   8002c9 <sys_lab6_set_priority>
}
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    

008003bc <sleep>:

int
sleep(unsigned int time) {
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	83 ec 18             	sub    $0x18,%esp
    return sys_sleep(time);
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	e8 17 ff ff ff       	call   8002e4 <sys_sleep>
}
  8003cd:	c9                   	leave  
  8003ce:	c3                   	ret    
  8003cf:	90                   	nop

008003d0 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 28             	sub    $0x28,%esp
    int ret = main();
  8003d6:	e8 05 0d 00 00       	call   8010e0 <main>
  8003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    exit(ret);
  8003de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e1:	89 04 24             	mov    %eax,(%esp)
  8003e4:	e8 17 ff ff ff       	call   800300 <exit>
  8003e9:	66 90                	xchg   %ax,%ax
  8003eb:	90                   	nop

008003ec <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	53                   	push   %ebx
  8003f0:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  8003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
  8003ff:	b8 20 00 00 00       	mov    $0x20,%eax
  800404:	2b 45 0c             	sub    0xc(%ebp),%eax
  800407:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80040a:	89 d3                	mov    %edx,%ebx
  80040c:	89 c1                	mov    %eax,%ecx
  80040e:	d3 eb                	shr    %cl,%ebx
  800410:	89 d8                	mov    %ebx,%eax
}
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	5b                   	pop    %ebx
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	56                   	push   %esi
  80041c:	53                   	push   %ebx
  80041d:	83 ec 60             	sub    $0x60,%esp
  800420:	8b 45 10             	mov    0x10(%ebp),%eax
  800423:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  80042c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80042f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800432:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800435:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  800438:	8b 45 18             	mov    0x18(%ebp),%eax
  80043b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800441:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800444:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800447:	89 55 cc             	mov    %edx,-0x34(%ebp)
  80044a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800450:	89 d3                	mov    %edx,%ebx
  800452:	89 c6                	mov    %eax,%esi
  800454:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800457:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  80045a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800460:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800464:	74 1c                	je     800482 <printnum+0x6a>
  800466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800469:	ba 00 00 00 00       	mov    $0x0,%edx
  80046e:	f7 75 e4             	divl   -0x1c(%ebp)
  800471:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800477:	ba 00 00 00 00       	mov    $0x0,%edx
  80047c:	f7 75 e4             	divl   -0x1c(%ebp)
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800482:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	89 d6                	mov    %edx,%esi
  80048a:	89 c3                	mov    %eax,%ebx
  80048c:	89 f0                	mov    %esi,%eax
  80048e:	89 da                	mov    %ebx,%edx
  800490:	f7 75 e4             	divl   -0x1c(%ebp)
  800493:	89 d3                	mov    %edx,%ebx
  800495:	89 c6                	mov    %eax,%esi
  800497:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80049a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  80049d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004a6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ac:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004af:	89 c3                	mov    %eax,%ebx
  8004b1:	89 d6                	mov    %edx,%esi
  8004b3:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  8004b6:	89 75 ec             	mov    %esi,-0x14(%ebp)
  8004b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bc:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  8004bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  8004ca:	77 56                	ja     800522 <printnum+0x10a>
  8004cc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  8004cf:	72 05                	jb     8004d6 <printnum+0xbe>
  8004d1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004d4:	77 4c                	ja     800522 <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8004d6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004dc:	8b 45 20             	mov    0x20(%ebp),%eax
  8004df:	89 44 24 18          	mov    %eax,0x18(%esp)
  8004e3:	89 54 24 14          	mov    %edx,0x14(%esp)
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	89 04 24             	mov    %eax,(%esp)
  800509:	e8 0a ff ff ff       	call   800418 <printnum>
  80050e:	eb 1c                	jmp    80052c <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  800510:	8b 45 0c             	mov    0xc(%ebp),%eax
  800513:	89 44 24 04          	mov    %eax,0x4(%esp)
  800517:	8b 45 20             	mov    0x20(%ebp),%eax
  80051a:	89 04 24             	mov    %eax,(%esp)
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800522:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800526:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80052a:	7f e4                	jg     800510 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80052c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80052f:	05 84 12 80 00       	add    $0x801284,%eax
  800534:	0f b6 00             	movzbl (%eax),%eax
  800537:	0f be c0             	movsbl %al,%eax
  80053a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800541:	89 04 24             	mov    %eax,(%esp)
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	ff d0                	call   *%eax
}
  800549:	83 c4 60             	add    $0x60,%esp
  80054c:	5b                   	pop    %ebx
  80054d:	5e                   	pop    %esi
  80054e:	5d                   	pop    %ebp
  80054f:	c3                   	ret    

00800550 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800553:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800557:	7e 14                	jle    80056d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	8d 48 08             	lea    0x8(%eax),%ecx
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	89 0a                	mov    %ecx,(%edx)
  800566:	8b 50 04             	mov    0x4(%eax),%edx
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	eb 30                	jmp    80059d <getuint+0x4d>
    }
    else if (lflag) {
  80056d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800571:	74 16                	je     800589 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	8d 48 04             	lea    0x4(%eax),%ecx
  80057b:	8b 55 08             	mov    0x8(%ebp),%edx
  80057e:	89 0a                	mov    %ecx,(%edx)
  800580:	8b 00                	mov    (%eax),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	eb 14                	jmp    80059d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	8d 48 04             	lea    0x4(%eax),%ecx
  800591:	8b 55 08             	mov    0x8(%ebp),%edx
  800594:	89 0a                	mov    %ecx,(%edx)
  800596:	8b 00                	mov    (%eax),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  8005a2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a6:	7e 14                	jle    8005bc <getint+0x1d>
        return va_arg(*ap, long long);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	8d 48 08             	lea    0x8(%eax),%ecx
  8005b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b3:	89 0a                	mov    %ecx,(%edx)
  8005b5:	8b 50 04             	mov    0x4(%eax),%edx
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	eb 30                	jmp    8005ec <getint+0x4d>
    }
    else if (lflag) {
  8005bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c0:	74 16                	je     8005d8 <getint+0x39>
        return va_arg(*ap, long);
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	8d 48 04             	lea    0x4(%eax),%ecx
  8005ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8005cd:	89 0a                	mov    %ecx,(%edx)
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 c2                	mov    %eax,%edx
  8005d3:	c1 fa 1f             	sar    $0x1f,%edx
  8005d6:	eb 14                	jmp    8005ec <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	8d 48 04             	lea    0x4(%eax),%ecx
  8005e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e3:	89 0a                	mov    %ecx,(%edx)
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 c2                	mov    %eax,%edx
  8005e9:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  8005ec:	5d                   	pop    %ebp
  8005ed:	c3                   	ret    

008005ee <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8005ee:	55                   	push   %ebp
  8005ef:	89 e5                	mov    %esp,%ebp
  8005f1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  8005f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 44 24 08          	mov    %eax,0x8(%esp)
  800608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	89 04 24             	mov    %eax,(%esp)
  800615:	e8 02 00 00 00       	call   80061c <vprintfmt>
    va_end(ap);
}
  80061a:	c9                   	leave  
  80061b:	c3                   	ret    

0080061c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80061c:	55                   	push   %ebp
  80061d:	89 e5                	mov    %esp,%ebp
  80061f:	56                   	push   %esi
  800620:	53                   	push   %ebx
  800621:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800624:	eb 17                	jmp    80063d <vprintfmt+0x21>
            if (ch == '\0') {
  800626:	85 db                	test   %ebx,%ebx
  800628:	0f 84 db 03 00 00    	je     800a09 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	89 44 24 04          	mov    %eax,0x4(%esp)
  800635:	89 1c 24             	mov    %ebx,(%esp)
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80063d:	8b 45 10             	mov    0x10(%ebp),%eax
  800640:	0f b6 00             	movzbl (%eax),%eax
  800643:	0f b6 d8             	movzbl %al,%ebx
  800646:	83 fb 25             	cmp    $0x25,%ebx
  800649:	0f 95 c0             	setne  %al
  80064c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800650:	84 c0                	test   %al,%al
  800652:	75 d2                	jne    800626 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  800654:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  800658:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80065f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800662:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  800665:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80066c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80066f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800672:	eb 04                	jmp    800678 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  800674:	90                   	nop
  800675:	eb 01                	jmp    800678 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  800677:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800678:	8b 45 10             	mov    0x10(%ebp),%eax
  80067b:	0f b6 00             	movzbl (%eax),%eax
  80067e:	0f b6 d8             	movzbl %al,%ebx
  800681:	89 d8                	mov    %ebx,%eax
  800683:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800687:	83 e8 23             	sub    $0x23,%eax
  80068a:	83 f8 55             	cmp    $0x55,%eax
  80068d:	0f 87 45 03 00 00    	ja     8009d8 <vprintfmt+0x3bc>
  800693:	8b 04 85 a8 12 80 00 	mov    0x8012a8(,%eax,4),%eax
  80069a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  80069c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  8006a0:	eb d6                	jmp    800678 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  8006a2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  8006a6:	eb d0                	jmp    800678 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8006a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  8006af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006b2:	89 d0                	mov    %edx,%eax
  8006b4:	c1 e0 02             	shl    $0x2,%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	01 c0                	add    %eax,%eax
  8006bb:	01 d8                	add    %ebx,%eax
  8006bd:	83 e8 30             	sub    $0x30,%eax
  8006c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  8006c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c6:	0f b6 00             	movzbl (%eax),%eax
  8006c9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  8006cc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006cf:	7e 39                	jle    80070a <vprintfmt+0xee>
  8006d1:	83 fb 39             	cmp    $0x39,%ebx
  8006d4:	7f 34                	jg     80070a <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8006d6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  8006da:	eb d3                	jmp    8006af <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  8006ea:	eb 1f                	jmp    80070b <vprintfmt+0xef>

        case '.':
            if (width < 0)
  8006ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8006f0:	79 82                	jns    800674 <vprintfmt+0x58>
                width = 0;
  8006f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  8006f9:	e9 76 ff ff ff       	jmp    800674 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  8006fe:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  800705:	e9 6e ff ff ff       	jmp    800678 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  80070a:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  80070b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80070f:	0f 89 62 ff ff ff    	jns    800677 <vprintfmt+0x5b>
                width = precision, precision = -1;
  800715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800718:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80071b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  800722:	e9 50 ff ff ff       	jmp    800677 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  800727:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  80072b:	e9 48 ff ff ff       	jmp    800678 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 50 04             	lea    0x4(%eax),%edx
  800736:	89 55 14             	mov    %edx,0x14(%ebp)
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800742:	89 04 24             	mov    %eax,(%esp)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
            break;
  80074a:	e9 b4 02 00 00       	jmp    800a03 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	89 55 14             	mov    %edx,0x14(%ebp)
  800758:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  80075a:	85 db                	test   %ebx,%ebx
  80075c:	79 02                	jns    800760 <vprintfmt+0x144>
                err = -err;
  80075e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800760:	83 fb 18             	cmp    $0x18,%ebx
  800763:	7f 0b                	jg     800770 <vprintfmt+0x154>
  800765:	8b 34 9d 20 12 80 00 	mov    0x801220(,%ebx,4),%esi
  80076c:	85 f6                	test   %esi,%esi
  80076e:	75 23                	jne    800793 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  800770:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800774:	c7 44 24 08 95 12 80 	movl   $0x801295,0x8(%esp)
  80077b:	00 
  80077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 04 24             	mov    %eax,(%esp)
  800789:	e8 60 fe ff ff       	call   8005ee <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  80078e:	e9 70 02 00 00       	jmp    800a03 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  800793:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800797:	c7 44 24 08 9e 12 80 	movl   $0x80129e,0x8(%esp)
  80079e:	00 
  80079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	89 04 24             	mov    %eax,(%esp)
  8007ac:	e8 3d fe ff ff       	call   8005ee <printfmt>
            }
            break;
  8007b1:	e9 4d 02 00 00       	jmp    800a03 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 50 04             	lea    0x4(%eax),%edx
  8007bc:	89 55 14             	mov    %edx,0x14(%ebp)
  8007bf:	8b 30                	mov    (%eax),%esi
  8007c1:	85 f6                	test   %esi,%esi
  8007c3:	75 05                	jne    8007ca <vprintfmt+0x1ae>
                p = "(null)";
  8007c5:	be a1 12 80 00       	mov    $0x8012a1,%esi
            }
            if (width > 0 && padc != '-') {
  8007ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8007ce:	7e 7c                	jle    80084c <vprintfmt+0x230>
  8007d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d4:	74 76                	je     80084c <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8007d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8007d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e0:	89 34 24             	mov    %esi,(%esp)
  8007e3:	e8 27 04 00 00       	call   800c0f <strnlen>
  8007e8:	89 da                	mov    %ebx,%edx
  8007ea:	29 c2                	sub    %eax,%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8007f1:	eb 17                	jmp    80080a <vprintfmt+0x1ee>
                    putch(padc, putdat);
  8007f3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007fe:	89 04 24             	mov    %eax,(%esp)
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  800806:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  80080a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80080e:	7f e3                	jg     8007f3 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800810:	eb 3a                	jmp    80084c <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  800812:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800816:	74 1f                	je     800837 <vprintfmt+0x21b>
  800818:	83 fb 1f             	cmp    $0x1f,%ebx
  80081b:	7e 05                	jle    800822 <vprintfmt+0x206>
  80081d:	83 fb 7e             	cmp    $0x7e,%ebx
  800820:	7e 15                	jle    800837 <vprintfmt+0x21b>
                    putch('?', putdat);
  800822:	8b 45 0c             	mov    0xc(%ebp),%eax
  800825:	89 44 24 04          	mov    %eax,0x4(%esp)
  800829:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	eb 0f                	jmp    800846 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083e:	89 1c 24             	mov    %ebx,(%esp)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800846:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  80084a:	eb 01                	jmp    80084d <vprintfmt+0x231>
  80084c:	90                   	nop
  80084d:	0f b6 06             	movzbl (%esi),%eax
  800850:	0f be d8             	movsbl %al,%ebx
  800853:	85 db                	test   %ebx,%ebx
  800855:	0f 95 c0             	setne  %al
  800858:	83 c6 01             	add    $0x1,%esi
  80085b:	84 c0                	test   %al,%al
  80085d:	74 29                	je     800888 <vprintfmt+0x26c>
  80085f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800863:	78 ad                	js     800812 <vprintfmt+0x1f6>
  800865:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800869:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086d:	79 a3                	jns    800812 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  80086f:	eb 17                	jmp    800888 <vprintfmt+0x26c>
                putch(' ', putdat);
  800871:	8b 45 0c             	mov    0xc(%ebp),%eax
  800874:	89 44 24 04          	mov    %eax,0x4(%esp)
  800878:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800884:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80088c:	7f e3                	jg     800871 <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  80088e:	e9 70 01 00 00       	jmp    800a03 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  800893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089a:	8d 45 14             	lea    0x14(%ebp),%eax
  80089d:	89 04 24             	mov    %eax,(%esp)
  8008a0:	e8 fa fc ff ff       	call   80059f <getint>
  8008a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  8008ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	79 26                	jns    8008db <vprintfmt+0x2bf>
                putch('-', putdat);
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
                num = -(long long)num;
  8008c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ce:	f7 d8                	neg    %eax
  8008d0:	83 d2 00             	adc    $0x0,%edx
  8008d3:	f7 da                	neg    %edx
  8008d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  8008db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  8008e2:	e9 a8 00 00 00       	jmp    80098f <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  8008e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f1:	89 04 24             	mov    %eax,(%esp)
  8008f4:	e8 57 fc ff ff       	call   800550 <getuint>
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  8008ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  800906:	e9 84 00 00 00       	jmp    80098f <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  80090b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800912:	8d 45 14             	lea    0x14(%ebp),%eax
  800915:	89 04 24             	mov    %eax,(%esp)
  800918:	e8 33 fc ff ff       	call   800550 <getuint>
  80091d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800920:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  800923:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  80092a:	eb 63                	jmp    80098f <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800933:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
            putch('x', putdat);
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	89 44 24 04          	mov    %eax,0x4(%esp)
  800946:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8d 50 04             	lea    0x4(%eax),%edx
  800958:	89 55 14             	mov    %edx,0x14(%ebp)
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  800967:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  80096e:	eb 1f                	jmp    80098f <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  800970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800973:	89 44 24 04          	mov    %eax,0x4(%esp)
  800977:	8d 45 14             	lea    0x14(%ebp),%eax
  80097a:	89 04 24             	mov    %eax,(%esp)
  80097d:	e8 ce fb ff ff       	call   800550 <getuint>
  800982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800985:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  800988:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  80098f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	89 54 24 18          	mov    %edx,0x18(%esp)
  80099a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80099d:	89 54 24 14          	mov    %edx,0x14(%esp)
  8009a1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 04 24             	mov    %eax,(%esp)
  8009c0:	e8 53 fa ff ff       	call   800418 <printnum>
            break;
  8009c5:	eb 3c                	jmp    800a03 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  8009c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ce:	89 1c 24             	mov    %ebx,(%esp)
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
            break;
  8009d6:	eb 2b                	jmp    800a03 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009df:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  8009eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009ef:	eb 04                	jmp    8009f5 <vprintfmt+0x3d9>
  8009f1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f8:	83 e8 01             	sub    $0x1,%eax
  8009fb:	0f b6 00             	movzbl (%eax),%eax
  8009fe:	3c 25                	cmp    $0x25,%al
  800a00:	75 ef                	jne    8009f1 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  800a02:	90                   	nop
        }
    }
  800a03:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800a04:	e9 34 fc ff ff       	jmp    80063d <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  800a09:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800a0a:	83 c4 40             	add    $0x40,%esp
  800a0d:	5b                   	pop    %ebx
  800a0e:	5e                   	pop    %esi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	8b 40 08             	mov    0x8(%eax),%eax
  800a1a:	8d 50 01             	lea    0x1(%eax),%edx
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a26:	8b 10                	mov    (%eax),%edx
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	8b 40 04             	mov    0x4(%eax),%eax
  800a2e:	39 c2                	cmp    %eax,%edx
  800a30:	73 12                	jae    800a44 <sprintputch+0x33>
        *b->buf ++ = ch;
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8d 50 01             	lea    0x1(%eax),%edx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	89 10                	mov    %edx,(%eax)
    }
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  800a4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  800a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a59:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	89 04 24             	mov    %eax,(%esp)
  800a6d:	e8 08 00 00 00       	call   800a7a <vsnprintf>
  800a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  800a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  800a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9f:	74 0a                	je     800aab <vsnprintf+0x31>
  800aa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa7:	39 c2                	cmp    %eax,%edx
  800aa9:	76 07                	jbe    800ab2 <vsnprintf+0x38>
        return -E_INVAL;
  800aab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab0:	eb 2a                	jmp    800adc <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  800abc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ac0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac7:	c7 04 24 11 0a 80 00 	movl   $0x800a11,(%esp)
  800ace:	e8 49 fb ff ff       	call   80061c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  800ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  800ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    
  800ade:	66 90                	xchg   %ax,%ax

00800ae0 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800ae9:	a1 00 20 80 00       	mov    0x802000,%eax
  800aee:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800af4:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  800afa:	6b f0 05             	imul   $0x5,%eax,%esi
  800afd:	01 f7                	add    %esi,%edi
  800aff:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
  800b04:	f7 e6                	mul    %esi
  800b06:	8d 34 17             	lea    (%edi,%edx,1),%esi
  800b09:	89 f2                	mov    %esi,%edx
  800b0b:	83 c0 0b             	add    $0xb,%eax
  800b0e:	83 d2 00             	adc    $0x0,%edx
  800b11:	89 c1                	mov    %eax,%ecx
  800b13:	80 e5 ff             	and    $0xff,%ch
  800b16:	0f b7 da             	movzwl %dx,%ebx
  800b19:	89 0d 00 20 80 00    	mov    %ecx,0x802000
  800b1f:	89 1d 04 20 80 00    	mov    %ebx,0x802004
    unsigned long long result = (next >> 12);
  800b25:	a1 00 20 80 00       	mov    0x802000,%eax
  800b2a:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800b30:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  800b34:	c1 ea 0c             	shr    $0xc,%edx
  800b37:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  800b3d:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  800b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b4d:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800b50:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b53:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800b56:	89 d3                	mov    %edx,%ebx
  800b58:	89 c6                	mov    %eax,%esi
  800b5a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b5d:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800b6a:	74 1c                	je     800b88 <rand+0xa8>
  800b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	f7 75 dc             	divl   -0x24(%ebp)
  800b77:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b82:	f7 75 dc             	divl   -0x24(%ebp)
  800b85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800b88:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8e:	89 d6                	mov    %edx,%esi
  800b90:	89 c3                	mov    %eax,%ebx
  800b92:	89 f0                	mov    %esi,%eax
  800b94:	89 da                	mov    %ebx,%edx
  800b96:	f7 75 dc             	divl   -0x24(%ebp)
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	89 c6                	mov    %eax,%esi
  800b9d:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800ba0:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800ba3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ba6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800ba9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bac:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bb2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800bb5:	89 c3                	mov    %eax,%ebx
  800bb7:	89 d6                	mov    %edx,%esi
  800bb9:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800bbc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800bbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800bc2:	83 c4 34             	add    $0x34,%esp
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
    next = seed;
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	a3 00 20 80 00       	mov    %eax,0x802000
  800bda:	89 15 04 20 80 00    	mov    %edx,0x802004
}
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    
  800be2:	66 90                	xchg   %ax,%ax

00800be4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800bea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800bf1:	eb 04                	jmp    800bf7 <strlen+0x13>
        cnt ++;
  800bf3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	0f b6 00             	movzbl (%eax),%eax
  800bfd:	84 c0                	test   %al,%al
  800bff:	0f 95 c0             	setne  %al
  800c02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c06:	84 c0                	test   %al,%al
  800c08:	75 e9                	jne    800bf3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800c1c:	eb 04                	jmp    800c22 <strnlen+0x13>
        cnt ++;
  800c1e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c25:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c28:	73 13                	jae    800c3d <strnlen+0x2e>
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	0f b6 00             	movzbl (%eax),%eax
  800c30:	84 c0                	test   %al,%al
  800c32:	0f 95 c0             	setne  %al
  800c35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e1                	jne    800c1e <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	83 ec 24             	sub    $0x24,%esp
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800c57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5d:	89 d6                	mov    %edx,%esi
  800c5f:	89 c3                	mov    %eax,%ebx
  800c61:	89 df                	mov    %ebx,%edi
  800c63:	ac                   	lods   %ds:(%esi),%al
  800c64:	aa                   	stos   %al,%es:(%edi)
  800c65:	84 c0                	test   %al,%al
  800c67:	75 fa                	jne    800c63 <strcpy+0x21>
  800c69:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c6c:	89 fb                	mov    %edi,%ebx
  800c6e:	89 75 e8             	mov    %esi,-0x18(%ebp)
  800c71:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800c74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c77:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800c7d:	83 c4 24             	add    $0x24,%esp
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800c91:	eb 21                	jmp    800cb4 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	0f b6 10             	movzbl (%eax),%edx
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	88 10                	mov    %dl,(%eax)
  800c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca1:	0f b6 00             	movzbl (%eax),%eax
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 04                	je     800cac <strncpy+0x27>
            src ++;
  800ca8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800cac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800cb0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800cb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb8:	75 d9                	jne    800c93 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbd:	c9                   	leave  
  800cbe:	c3                   	ret    

00800cbf <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
  800cc5:	83 ec 24             	sub    $0x24,%esp
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800cd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	89 c3                	mov    %eax,%ebx
  800cde:	89 df                	mov    %ebx,%edi
  800ce0:	ac                   	lods   %ds:(%esi),%al
  800ce1:	ae                   	scas   %es:(%edi),%al
  800ce2:	75 08                	jne    800cec <strcmp+0x2d>
  800ce4:	84 c0                	test   %al,%al
  800ce6:	75 f8                	jne    800ce0 <strcmp+0x21>
  800ce8:	31 c0                	xor    %eax,%eax
  800cea:	eb 04                	jmp    800cf0 <strcmp+0x31>
  800cec:	19 c0                	sbb    %eax,%eax
  800cee:	0c 01                	or     $0x1,%al
  800cf0:	89 fb                	mov    %edi,%ebx
  800cf2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800cf5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cf8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800cfb:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800cfe:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800d04:	83 c4 24             	add    $0x24,%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800d0f:	eb 0c                	jmp    800d1d <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800d11:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d19:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d21:	74 1a                	je     800d3d <strncmp+0x31>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	0f b6 00             	movzbl (%eax),%eax
  800d29:	84 c0                	test   %al,%al
  800d2b:	74 10                	je     800d3d <strncmp+0x31>
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	0f b6 10             	movzbl (%eax),%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	0f b6 00             	movzbl (%eax),%eax
  800d39:	38 c2                	cmp    %al,%dl
  800d3b:	74 d4                	je     800d11 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800d3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d41:	74 1a                	je     800d5d <strncmp+0x51>
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	0f b6 00             	movzbl (%eax),%eax
  800d49:	0f b6 d0             	movzbl %al,%edx
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	0f b6 00             	movzbl (%eax),%eax
  800d52:	0f b6 c0             	movzbl %al,%eax
  800d55:	89 d1                	mov    %edx,%ecx
  800d57:	29 c1                	sub    %eax,%ecx
  800d59:	89 c8                	mov    %ecx,%eax
  800d5b:	eb 05                	jmp    800d62 <strncmp+0x56>
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 04             	sub    $0x4,%esp
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800d70:	eb 14                	jmp    800d86 <strchr+0x22>
        if (*s == c) {
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	0f b6 00             	movzbl (%eax),%eax
  800d78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7b:	75 05                	jne    800d82 <strchr+0x1e>
            return (char *)s;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	eb 13                	jmp    800d95 <strchr+0x31>
        }
        s ++;
  800d82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	0f b6 00             	movzbl (%eax),%eax
  800d8c:	84 c0                	test   %al,%al
  800d8e:	75 e2                	jne    800d72 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 04             	sub    $0x4,%esp
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800da3:	eb 0f                	jmp    800db4 <strfind+0x1d>
        if (*s == c) {
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	0f b6 00             	movzbl (%eax),%eax
  800dab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dae:	74 10                	je     800dc0 <strfind+0x29>
            break;
        }
        s ++;
  800db0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	0f b6 00             	movzbl (%eax),%eax
  800dba:	84 c0                	test   %al,%al
  800dbc:	75 e7                	jne    800da5 <strfind+0xe>
  800dbe:	eb 01                	jmp    800dc1 <strfind+0x2a>
        if (*s == c) {
            break;
  800dc0:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800dcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800dd3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800dda:	eb 04                	jmp    800de0 <strtol+0x1a>
        s ++;
  800ddc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	0f b6 00             	movzbl (%eax),%eax
  800de6:	3c 20                	cmp    $0x20,%al
  800de8:	74 f2                	je     800ddc <strtol+0x16>
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	0f b6 00             	movzbl (%eax),%eax
  800df0:	3c 09                	cmp    $0x9,%al
  800df2:	74 e8                	je     800ddc <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	0f b6 00             	movzbl (%eax),%eax
  800dfa:	3c 2b                	cmp    $0x2b,%al
  800dfc:	75 06                	jne    800e04 <strtol+0x3e>
        s ++;
  800dfe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e02:	eb 15                	jmp    800e19 <strtol+0x53>
    }
    else if (*s == '-') {
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	0f b6 00             	movzbl (%eax),%eax
  800e0a:	3c 2d                	cmp    $0x2d,%al
  800e0c:	75 0b                	jne    800e19 <strtol+0x53>
        s ++, neg = 1;
  800e0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e12:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1d:	74 06                	je     800e25 <strtol+0x5f>
  800e1f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e23:	75 24                	jne    800e49 <strtol+0x83>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	0f b6 00             	movzbl (%eax),%eax
  800e2b:	3c 30                	cmp    $0x30,%al
  800e2d:	75 1a                	jne    800e49 <strtol+0x83>
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	83 c0 01             	add    $0x1,%eax
  800e35:	0f b6 00             	movzbl (%eax),%eax
  800e38:	3c 78                	cmp    $0x78,%al
  800e3a:	75 0d                	jne    800e49 <strtol+0x83>
        s += 2, base = 16;
  800e3c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e40:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e47:	eb 2a                	jmp    800e73 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800e49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4d:	75 17                	jne    800e66 <strtol+0xa0>
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	0f b6 00             	movzbl (%eax),%eax
  800e55:	3c 30                	cmp    $0x30,%al
  800e57:	75 0d                	jne    800e66 <strtol+0xa0>
        s ++, base = 8;
  800e59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e5d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e64:	eb 0d                	jmp    800e73 <strtol+0xad>
    }
    else if (base == 0) {
  800e66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6a:	75 07                	jne    800e73 <strtol+0xad>
        base = 10;
  800e6c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	0f b6 00             	movzbl (%eax),%eax
  800e79:	3c 2f                	cmp    $0x2f,%al
  800e7b:	7e 1b                	jle    800e98 <strtol+0xd2>
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	0f b6 00             	movzbl (%eax),%eax
  800e83:	3c 39                	cmp    $0x39,%al
  800e85:	7f 11                	jg     800e98 <strtol+0xd2>
            dig = *s - '0';
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	0f b6 00             	movzbl (%eax),%eax
  800e8d:	0f be c0             	movsbl %al,%eax
  800e90:	83 e8 30             	sub    $0x30,%eax
  800e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e96:	eb 48                	jmp    800ee0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	0f b6 00             	movzbl (%eax),%eax
  800e9e:	3c 60                	cmp    $0x60,%al
  800ea0:	7e 1b                	jle    800ebd <strtol+0xf7>
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	0f b6 00             	movzbl (%eax),%eax
  800ea8:	3c 7a                	cmp    $0x7a,%al
  800eaa:	7f 11                	jg     800ebd <strtol+0xf7>
            dig = *s - 'a' + 10;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	0f b6 00             	movzbl (%eax),%eax
  800eb2:	0f be c0             	movsbl %al,%eax
  800eb5:	83 e8 57             	sub    $0x57,%eax
  800eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ebb:	eb 23                	jmp    800ee0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	0f b6 00             	movzbl (%eax),%eax
  800ec3:	3c 40                	cmp    $0x40,%al
  800ec5:	7e 3c                	jle    800f03 <strtol+0x13d>
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	0f b6 00             	movzbl (%eax),%eax
  800ecd:	3c 5a                	cmp    $0x5a,%al
  800ecf:	7f 32                	jg     800f03 <strtol+0x13d>
            dig = *s - 'A' + 10;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	0f b6 00             	movzbl (%eax),%eax
  800ed7:	0f be c0             	movsbl %al,%eax
  800eda:	83 e8 37             	sub    $0x37,%eax
  800edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee6:	7d 1a                	jge    800f02 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  800ee8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	0f af 55 10          	imul   0x10(%ebp),%edx
  800ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800efd:	e9 71 ff ff ff       	jmp    800e73 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  800f02:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  800f03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f07:	74 08                	je     800f11 <strtol+0x14b>
        *endptr = (char *) s;
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800f11:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f15:	74 07                	je     800f1e <strtol+0x158>
  800f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1a:	f7 d8                	neg    %eax
  800f1c:	eb 03                	jmp    800f21 <strtol+0x15b>
  800f1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 24             	sub    $0x24,%esp
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800f32:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f3c:	88 45 ef             	mov    %al,-0x11(%ebp)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800f45:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800f48:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  800f4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f4f:	89 ce                	mov    %ecx,%esi
  800f51:	89 d3                	mov    %edx,%ebx
  800f53:	89 f1                	mov    %esi,%ecx
  800f55:	89 df                	mov    %ebx,%edi
  800f57:	f3 aa                	rep stos %al,%es:(%edi)
  800f59:	89 fb                	mov    %edi,%ebx
  800f5b:	89 ce                	mov    %ecx,%esi
  800f5d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800f60:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800f66:	83 c4 24             	add    $0x24,%esp
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 38             	sub    $0x38,%esp
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f83:	8b 45 10             	mov    0x10(%ebp),%eax
  800f86:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800f8f:	73 4e                	jae    800fdf <memmove+0x71>
  800f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fa0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800fa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fa6:	89 c1                	mov    %eax,%ecx
  800fa8:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800fab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800fb4:	89 d7                	mov    %edx,%edi
  800fb6:	89 c3                	mov    %eax,%ebx
  800fb8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800fbb:	89 de                	mov    %ebx,%esi
  800fbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fbf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800fc2:	83 e1 03             	and    $0x3,%ecx
  800fc5:	74 02                	je     800fc9 <memmove+0x5b>
  800fc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800fc9:	89 f3                	mov    %esi,%ebx
  800fcb:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800fce:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800fd1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800fd4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800fd7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fdd:	eb 3e                	jmp    80101d <memmove+0xaf>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff4:	01 c2                	add    %eax,%edx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ff9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800ffc:	89 ce                	mov    %ecx,%esi
  800ffe:	89 d3                	mov    %edx,%ebx
  801000:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801003:	89 df                	mov    %ebx,%edi
  801005:	fd                   	std    
  801006:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801008:	fc                   	cld    
  801009:	89 fb                	mov    %edi,%ebx
  80100b:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  80100e:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801011:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  801014:	89 75 c8             	mov    %esi,-0x38(%ebp)
  801017:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  80101a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  80101d:	83 c4 38             	add    $0x38,%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
  80102b:	83 ec 24             	sub    $0x24,%esp
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  801040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801043:	89 c1                	mov    %eax,%ecx
  801045:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  801048:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80104b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80104e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801051:	89 d7                	mov    %edx,%edi
  801053:	89 c3                	mov    %eax,%ebx
  801055:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801058:	89 de                	mov    %ebx,%esi
  80105a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80105c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80105f:	83 e1 03             	and    $0x3,%ecx
  801062:	74 02                	je     801066 <memcpy+0x41>
  801064:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801066:	89 f3                	mov    %esi,%ebx
  801068:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80106b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80106e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  801071:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801074:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  801077:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  80107a:	83 c4 24             	add    $0x24,%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  801094:	eb 32                	jmp    8010c8 <memcmp+0x46>
        if (*s1 != *s2) {
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801099:	0f b6 10             	movzbl (%eax),%edx
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	0f b6 00             	movzbl (%eax),%eax
  8010a2:	38 c2                	cmp    %al,%dl
  8010a4:	74 1a                	je     8010c0 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  8010a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a9:	0f b6 00             	movzbl (%eax),%eax
  8010ac:	0f b6 d0             	movzbl %al,%edx
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	0f b6 00             	movzbl (%eax),%eax
  8010b5:	0f b6 c0             	movzbl %al,%eax
  8010b8:	89 d1                	mov    %edx,%ecx
  8010ba:	29 c1                	sub    %eax,%ecx
  8010bc:	89 c8                	mov    %ecx,%eax
  8010be:	eb 1c                	jmp    8010dc <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  8010c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8010c4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  8010c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cc:	0f 95 c0             	setne  %al
  8010cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8010d3:	84 c0                	test   %al,%al
  8010d5:	75 bf                	jne    801096 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  8010d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    
  8010de:	66 90                	xchg   %ax,%ax

008010e0 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 e4 f0             	and    $0xfffffff0,%esp
  8010e6:	83 ec 10             	sub    $0x10,%esp
    cprintf("Hello world!!.\n");
  8010e9:	c7 04 24 00 14 80 00 	movl   $0x801400,(%esp)
  8010f0:	e8 26 f0 ff ff       	call   80011b <cprintf>
    cprintf("I am process %d.\n", getpid());
  8010f5:	e8 88 f2 ff ff       	call   800382 <getpid>
  8010fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fe:	c7 04 24 10 14 80 00 	movl   $0x801410,(%esp)
  801105:	e8 11 f0 ff ff       	call   80011b <cprintf>
    cprintf("hello pass.\n");
  80110a:	c7 04 24 22 14 80 00 	movl   $0x801422,(%esp)
  801111:	e8 05 f0 ff ff       	call   80011b <cprintf>
    return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    
