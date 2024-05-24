#include "drivers/uart/uart.h"

void kmain(void) {
  uart_init();
  kprintf("Initializing the process scheduler ...\n");
}