ENTRY(_start)

PHDRS {
    headers PT_PHDR PHDRS ;
    text PT_LOAD FILEHDR PHDRS ;
    data PT_LOAD ;
    bss PT_LOAD ;
}

SECTIONS {
    . = 1M;
    .text : {
        *(.multiboot)
        *(.text)
    } :text
    .data : { *(.data) } :data
    .bss : { *(.bss) } :bss
}