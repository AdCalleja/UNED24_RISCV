#include "drivers/uart/uart.h"
#include "bootservices/bootservices.h"

// void m_mode_trap_handler() {
//   kprintf("Machine mode trap handler\n");
// }

void _start(void) {
  uart_init();
  kprintf("Initializing the process scheduler ...\n");
}