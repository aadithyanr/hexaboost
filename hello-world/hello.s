.global _main
.align 2

_main:
    bl _printf       // call printf
    b _reboot        // then reboot
    b _terminate     // never reached

_printf:
    mov X0, #1              // stdout
    adr X1, helloworld      // address of "hello world\n"
    mov X2, #12             // length
    mov X16, #4             // syscall: write
    svc 0

_reboot:
    mov X0, #1              // argument: reboot mode
    mov X16, #55            // syscall: reboot
    svc 0

_terminate:
    mov X0, #0              // return 0
    mov X16, #1             // syscall: exit
    svc 0

helloworld:
    .ascii "hello world\n"
