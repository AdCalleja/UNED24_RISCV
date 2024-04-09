#ifndef _FIFO_DD_H
#define _FIFO_DD_H

#include <stdint.h>

#define IOCTL_FIFO_FLUSH        0x01
#define IOCTL_FIFO_VALIDATE     0x02
#define IOCTL_FIFO_GET_SIZE     0x03

#define FIFO_DRIVER_MAJOR       0x8e
#define FIFO_DRIVER_NAME        "FIFO DRIVER\0"

void init_fifo_dd();

#endif