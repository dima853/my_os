CC = gcc
LD = ld
ASM = nasm
CFLAGS = -m32 -nostdlib -ffreestanding -Wall -Wextra
LDFLAGS = -m elf_i386 -T linker.ld

OBJS = boot.o interrupts.o kernel.o

.PHONY: all clean run

all: myos.bin

boot.o: boot.asm
	$(ASM) -f elf32 $< -o $@

interrupts.o: interrupts.asm
	$(ASM) -f elf32 $< -o $@

kernel.o: kernel.c io.h
	$(CC) $(CFLAGS) -c $< -o $@

myos.bin: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

run: myos.bin
	qemu-system-x86_64 -kernel myos.bin

clean:
	rm -f *.o myos.bin