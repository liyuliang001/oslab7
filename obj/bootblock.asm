
obj/bootblock.o：     文件格式 elf32-i386


Disassembly of section .startup:

00007c00 <start>:

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    7c00:	fa                   	cli    
    cld                                             # String operations increment
    7c01:	fc                   	cld    

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
    movw %ax, %ds                                   # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
    movw %ax, %ss                                   # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c0a:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
    jnz seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c14:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c16:	a8 02                	test   $0x2,%al
    jnz seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
    7c1c:	e6 60                	out    %al,$0x60

00007c1e <probe_memory>:

probe_memory:
    movl $0, 0x8000
    7c1e:	66 c7 06 00 80       	movw   $0x8000,(%esi)
    7c23:	00 00                	add    %al,(%eax)
    7c25:	00 00                	add    %al,(%eax)
    xorl %ebx, %ebx
    7c27:	66 31 db             	xor    %bx,%bx
    movw $0x8004, %di
    7c2a:	bf 04 80 66 b8       	mov    $0xb8668004,%edi

00007c2d <start_probe>:
start_probe:
    movl $0xE820, %eax
    7c2d:	66 b8 20 e8          	mov    $0xe820,%ax
    7c31:	00 00                	add    %al,(%eax)
    movl $20, %ecx
    7c33:	66 b9 14 00          	mov    $0x14,%cx
    7c37:	00 00                	add    %al,(%eax)
    movl $SMAP, %edx
    7c39:	66 ba 50 41          	mov    $0x4150,%dx
    7c3d:	4d                   	dec    %ebp
    7c3e:	53                   	push   %ebx
    int $0x15
    7c3f:	cd 15                	int    $0x15
    jnc cont
    7c41:	73 08                	jae    7c4b <cont>
    movw $12345, 0x8000
    7c43:	c7 06 00 80 39 30    	movl   $0x30398000,(%esi)
    jmp finish_probe
    7c49:	eb 0e                	jmp    7c59 <finish_probe>

00007c4b <cont>:
cont:
    addw $20, %di
    7c4b:	83 c7 14             	add    $0x14,%edi
    incl 0x8000
    7c4e:	66 ff 06             	incw   (%esi)
    7c51:	00 80 66 83 fb 00    	add    %al,0xfb8366(%eax)
    cmpl $0, %ebx
    jnz start_probe
    7c57:	75 d4                	jne    7c2d <start_probe>

00007c59 <finish_probe>:

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    7c59:	0f 01 16             	lgdtl  (%esi)
    7c5c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    7c5d:	7d 0f                	jge    7c6e <protcseg+0x1>
    movl %cr0, %eax
    7c5f:	20 c0                	and    %al,%al
    orl $CR0_PE_ON, %eax
    7c61:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c65:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c68:	ea 6d 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c6d

00007c6d <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    7c6d:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds                                   # -> DS: Data Segment
    7c71:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> ES: Extra Segment
    7c73:	8e c0                	mov    %eax,%es
    movw %ax, %fs                                   # -> FS
    7c75:	8e e0                	mov    %eax,%fs
    movw %ax, %gs                                   # -> GS
    7c77:	8e e8                	mov    %eax,%gs
    movw %ax, %ss                                   # -> SS: Stack Segment
    7c79:	8e d0                	mov    %eax,%ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    7c7b:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl $start, %esp
    7c80:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    call bootmain
    7c85:	e8 8d 00 00 00       	call   7d17 <bootmain>

00007c8a <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c8a:	eb fe                	jmp    7c8a <spin>

Disassembly of section .text:

00007c8c <readseg>:
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c8c:	55                   	push   %ebp
    uintptr_t end_va = va + count;
    7c8d:	01 c2                	add    %eax,%edx
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c8f:	89 e5                	mov    %esp,%ebp
    7c91:	57                   	push   %edi
    7c92:	56                   	push   %esi
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c93:	89 c6                	mov    %eax,%esi
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c95:	53                   	push   %ebx
    7c96:	53                   	push   %ebx
    uintptr_t end_va = va + count;
    7c97:	89 55 f0             	mov    %edx,-0x10(%ebp)

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7c9a:	89 ca                	mov    %ecx,%edx
    7c9c:	81 e2 ff 01 00 00    	and    $0x1ff,%edx

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7ca2:	c1 e9 09             	shr    $0x9,%ecx
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;
    7ca5:	29 d6                	sub    %edx,%esi

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7ca7:	8d 59 01             	lea    0x1(%ecx),%ebx

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7caa:	eb 60                	jmp    7d0c <readseg+0x80>
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
    7cac:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cb1:	ec                   	in     (%dx),%al
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7cb2:	83 e0 c0             	and    $0xffffffc0,%eax
    7cb5:	3c 40                	cmp    $0x40,%al
    7cb7:	75 f3                	jne    7cac <readseg+0x20>
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
    7cb9:	b2 f2                	mov    $0xf2,%dl
    7cbb:	b0 01                	mov    $0x1,%al
    7cbd:	ee                   	out    %al,(%dx)
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
    7cbe:	0f b6 c3             	movzbl %bl,%eax
    7cc1:	b2 f3                	mov    $0xf3,%dl
    7cc3:	ee                   	out    %al,(%dx)
    7cc4:	0f b6 c7             	movzbl %bh,%eax
    7cc7:	b2 f4                	mov    $0xf4,%dl
    7cc9:	ee                   	out    %al,(%dx)
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    7cca:	89 d8                	mov    %ebx,%eax
    7ccc:	b2 f5                	mov    $0xf5,%dl
    7cce:	c1 e8 10             	shr    $0x10,%eax
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
    7cd1:	25 ff 00 00 00       	and    $0xff,%eax
    7cd6:	ee                   	out    %al,(%dx)

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7cd7:	89 d8                	mov    %ebx,%eax
    7cd9:	b2 f6                	mov    $0xf6,%dl
    7cdb:	c1 e8 18             	shr    $0x18,%eax
    7cde:	83 e0 0f             	and    $0xf,%eax
    7ce1:	0c e0                	or     $0xe0,%al
    7ce3:	ee                   	out    %al,(%dx)
    7ce4:	b0 20                	mov    $0x20,%al
    7ce6:	b2 f7                	mov    $0xf7,%dl
    7ce8:	ee                   	out    %al,(%dx)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
    7ce9:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cee:	ec                   	in     (%dx),%al
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/* waitdisk - wait for disk ready */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7cef:	83 e0 c0             	and    $0xffffffc0,%eax
    7cf2:	3c 40                	cmp    $0x40,%al
    7cf4:	75 f3                	jne    7ce9 <readseg+0x5d>
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
    7cf6:	89 f7                	mov    %esi,%edi
    7cf8:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cfd:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d02:	fc                   	cld    
    7d03:	f2 6d                	repnz insl (%dx),%es:(%edi)
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d05:	81 c6 00 02 00 00    	add    $0x200,%esi
    7d0b:	43                   	inc    %ebx
    7d0c:	3b 75 f0             	cmp    -0x10(%ebp),%esi
    7d0f:	72 9b                	jb     7cac <readseg+0x20>
        readsect((void *)va, secno);
    }
}
    7d11:	58                   	pop    %eax
    7d12:	5b                   	pop    %ebx
    7d13:	5e                   	pop    %esi
    7d14:	5f                   	pop    %edi
    7d15:	5d                   	pop    %ebp
    7d16:	c3                   	ret    

00007d17 <bootmain>:

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d17:	55                   	push   %ebp
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d18:	31 c9                	xor    %ecx,%ecx
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d1a:	89 e5                	mov    %esp,%ebp
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d1c:	ba 00 10 00 00       	mov    $0x1000,%edx
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d21:	56                   	push   %esi
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d22:	b8 00 00 01 00       	mov    $0x10000,%eax
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d27:	53                   	push   %ebx
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d28:	e8 5f ff ff ff       	call   7c8c <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7d2d:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d34:	45 4c 46 
    7d37:	75 41                	jne    7d7a <bootmain+0x63>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d39:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
    eph = ph + ELFHDR->e_phnum;
    7d3f:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d46:	81 c3 00 00 01 00    	add    $0x10000,%ebx
    eph = ph + ELFHDR->e_phnum;
    7d4c:	c1 e0 05             	shl    $0x5,%eax
    7d4f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
    for (; ph < eph; ph ++) {
    7d52:	eb 16                	jmp    7d6a <bootmain+0x53>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d54:	8b 43 08             	mov    0x8(%ebx),%eax
    7d57:	8b 4b 04             	mov    0x4(%ebx),%ecx
    7d5a:	8b 53 14             	mov    0x14(%ebx),%edx
    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
    7d5d:	83 c3 20             	add    $0x20,%ebx
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d60:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d65:	e8 22 ff ff ff       	call   7c8c <readseg>
    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
    7d6a:	39 f3                	cmp    %esi,%ebx
    7d6c:	72 e6                	jb     7d54 <bootmain+0x3d>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d6e:	a1 18 00 01 00       	mov    0x10018,%eax
    7d73:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d78:	ff d0                	call   *%eax
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
    7d7a:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
    7d7f:	89 d0                	mov    %edx,%eax
    7d81:	66 ef                	out    %ax,(%dx)
    7d83:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d88:	66 ef                	out    %ax,(%dx)
    7d8a:	eb fe                	jmp    7d8a <bootmain+0x73>
