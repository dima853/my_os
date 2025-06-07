global load_idt
extern keyboard_handler

load_idt:
    lidt [idt_descriptor]
    ret

keyboard_interrupt:
    pusha
    call keyboard_handler
    popa
    iretd

section .data
idt_descriptor:
    dw 256 * 8 - 1
    dd idt_table

section .bss
idt_table:
    resb 256 * 8