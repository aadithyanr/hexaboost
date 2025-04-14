; hexaboost bootloader
; commented every line, bc i struggled
; ----------------------------------

[BITS 16]       ; 16-bit code mode
[ORG 0x7C00]    ; where the bios loads us

; setup time
init:
    cli             ; kill interrupts for a sec
    xor ax, ax      ; zero out ax
    mov ds, ax      ; data segment = 0
    mov es, ax      ; extra segment = 0
    mov ss, ax      ; stack segment = 0
    mov sp, 0x7C00  ; stack pointer at the bottom
    sti             ; interrupts back on

; clear the screen for aesthetics
    mov ah, 0x00    ; video mode function
    mov al, 0x03    ; text mode 80x25
    int 0x10        ; bios video interrupt

; make text look cooler
    mov ah, 0x0B    ; color palette function
    mov bh, 0x00    ; bg color
    mov bl, 0x0A    ; green cuz hackermode
    int 0x10

; show our cool splash
    mov si, splash_msg
    call print_string
    
; personal touch
    mov si, aadi_msg
    call print_string
    
; ask for input
    mov si, prompt_msg
    call print_string

; wait for any key
    mov ah, 0x00    ; wait for keypress
    int 0x16        ; keyboard interrupt
    
; restart the system
    mov si, reboot_msg
    call print_string
    xor ax, ax      ; zero ax
    int 0x19        ; reboot

; prints a string (input: si = string address)
print_string:
    pusha           ; save registers
    mov ah, 0x0E    ; teletype mode
.loop:
    lodsb           ; get char and move to next
    cmp al, 0       ; check if end of string
    je .done        ; if zero, we're done
    int 0x10        ; print it
    jmp .loop       ; next char
.done:
    popa            ; restore registers
    ret             ; go back

; all our text data
splash_msg:    db "================================", 0x0D, 0x0A
                db "       hexaboost loader v1.0      ", 0x0D, 0x0A
                db "================================", 0x0D, 0x0A, 0

aadi_msg:       db "yo this is aadi in your boot sector!", 0x0D, 0x0A
                db "booting from scratch is kinda lit", 0x0D, 0x0A, 0

prompt_msg:     db 0x0D, 0x0A, "press any key to reboot...", 0x0D, 0x0A, 0

reboot_msg:     db 0x0D, 0x0A, "rebooting now...", 0x0D, 0x0A, 0

; fill and boot signature
times 510 - ($ - $$) db 0  ; zero padding
dw 0xAA55                  ; magic boot number