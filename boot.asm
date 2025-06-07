
bits 32
section .multiboot
    dd 0x1BADB002 
    dd 0x00   
    dd - (0x1BADB002 + 0x00)   

section .text
global _start
extern kernel_main
extern load_idt            

_start:
    cli                        
    mov esp, stack_top 
    call load_idt
    sti       
    call kernel_main          
    hlt                        

section .note.GNU-stack noalloc noexec nowrite progbits

section .bss
align 16
stack_bottom:
    resb 16384  
stack_top: