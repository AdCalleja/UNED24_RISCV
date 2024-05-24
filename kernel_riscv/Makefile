# Build
CC=riscv64-unknown-elf-gcc
CFLAGS=-ffreestanding -nostartfiles -nostdlib -nodefaultlibs
CFLAGS+=-g -Wl,--gc-sections -mcmodel=medany -march=rv64g
#CFLAGS+=-Wl,--no-warn-rwx-segments
RUNTIME=src/asm/crt0.s
LINKER_SCRIPT=src/lds/riscv64-virt.ld
KERNEL_IMAGE=kernel

# QEMU
QEMU=qemu-system-riscv64
MACH=virt
RUN=$(QEMU) -machine $(MACH) #-nographic 
RUN+=-bios none -kernel $(KERNEL_IMAGE)

# GDB
GDB := riscv64-elf-gdb
CMDNEWSCREEN := cmd.exe /c start cmd /c wsl -e
GDBFLAGS ?=  --nx --command=debug.gdb

# Format
INDENT_FLAGS=-linux -brf -i2

all: uart kernel
	$(CC) *.o $(RUNTIME) $(CFLAGS) -T $(LINKER_SCRIPT) -o $(KERNEL_IMAGE)

uart:
	$(CC) -c src/drivers/uart/uart.c $(CFLAGS) -o uart.o

kernel:
	$(CC) -c src/kernel.c $(CFLAGS) -o kernel.o

run: all
	$(RUN)

# Comando bueno, pero hace falta lo de losetup
# $(CMDNEWSCREEN) $(GDB) $(GDBFLAGS) & $(RUN) -s -S
# De momento ejecutar esto en terminal a parte
# riscv64-elf-gdb --nx --command=debug.gdb
debug: all
	$(RUN) -s -S
clean:
	rm -vf *.o
	rm -vf $(KERNEL_IMAGE)
	find . -name '*~' -exec rm -vf '{}' \;
	