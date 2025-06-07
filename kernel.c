#include <stdint.h>

#define VGA_ADDRESS 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

volatile uint16_t* vga_buffer = (volatile uint16_t*)VGA_ADDRESS;
uint8_t current_color = 0x0F; // Белый на чёрном
uint8_t need_redraw = 1;      // Флаг перерисовки

void clear_screen() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = ' ' | (current_color << 8);
    }
}

void print_str(const char* str, int x, int y) {
    int pos = y * VGA_WIDTH + x;
    while (*str) {
        vga_buffer[pos++] = *str++ | (current_color << 8);
    }
}

void keyboard_handler() {
    // Меняем цвет только при реальном нажатии
    static uint8_t last_key = 0;
    uint8_t key = inb(0x60); // Читаем скан-код
    
    if (key != last_key) {
        current_color = (current_color + 1) % 16;
        need_redraw = 1;
        last_key = key;
    }
    
    // Отправляем сигнал EOI контроллеру прерываний
    outb(0x20, 0x20);
}

void kernel_main() {
    clear_screen();
    print_str("Hello, Kernel World! Press any key!", 0, 0);
    
    while (1) {
        if (need_redraw) {
            clear_screen();
            print_str("Hello, Kernel World! Press any key!", 0, 0);
            need_redraw = 0;
        }
        asm volatile ("hlt");
    }
}