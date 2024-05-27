# Build
CC=riscv64-unknown-elf-gcc
CFLAGS=-ffreestanding -nostartfiles -nostdlib -nodefaultlibs
CFLAGS+=-g -Wl,--gc-sections -mcmodel=medany -march=rv64g
#CFLAGS+=-Wl,--no-warn-rwx-segments
RUNTIME=src/asm/crt0.s
LINKER_SCRIPT=src/lds/riscv64-virt.ld
KERNEL=kernel.elf

ABSDIR := $(shell pwd)
LMNDIR := $(ABSDIR)/limine
SRCDIR := $(ABSDIR)/src
BUILDHOME := $(ABSDIR)/build
BUILDDIR := $(ABSDIR)/build/bin
OBJDIR := $(ABSDIR)/build/lib
ISOBUILDDIR := $(ABSDIR)/build/iso_root
ISODIR := $(ABSDIR)/build/image
ISO := limine-cd.iso
PROGSDIR := $(ABSDIR)/progs/sources
PROGSBUILDDIR := $(ABSDIR)/progs/export
PROGSDATADIR := $(ABSDIR)/progs/data
KERNEL := kernel.elf

LMNREPO := https://github.com/limine-bootloader/limine.git
LMNBRCH := v3.0-branch-binary
LIMINECFG := limine.cfg
LMN := limine/limine-deploy
OVMF_FILE := OVMF_riscv_virt.fd

# QEMU
QEMU=qemu-system-riscv64
QFLAGS = -machine virt \
	-cpu rv64 -smp 4 -m 512M \
	-drive id=cd0,format=raw,file=$(ISODIR)/$(ISO) \
	-drive if=pflash,format=raw,file=./OVMFbin/OVMF_riscv_virt.fd,readonly=on,unit=1 \
	#-serial mon:stdio \
	-device ramfb -device qemu-xhci -device usb-kbd \
	-device virtio-scsi-pci,id=scsi -device scsi-cd,drive=cd0 \
	#-M aia=aplic-imsic 
MACH=virt
RUN=$(QEMU) $(QFLAGS) #-nographic 

# GDB
GDB := riscv64-elf-gdb
CMDNEWSCREEN := cmd.exe /c start cmd /c wsl -e
GDBFLAGS ?=  --nx --command=debug.gdb

# Format
INDENT_FLAGS=-linux -brf -i2

link: uart kernel
	$(CC) *.o $(RUNTIME) $(CFLAGS) -T $(LINKER_SCRIPT) -o $(BUILDDIR)/$(KERNEL)

uart:
	$(CC) -c src/drivers/uart/uart.c $(CFLAGS) -o uart.o

kernel:
	$(CC) -c src/kernel.c $(CFLAGS) -o kernel.o

setup:
	@mkdir -p $(BUILDDIR)
	@mkdir -p $(OBJDIR)
	@mkdir -p $(ISOBUILDDIR)
	@mkdir -p $(PROGSBUILDDIR)
	@mkdir -p $(ISODIR)
	@dd if=/dev/zero of=./OVMFbin/OVMF_riscv_virt.fd bs=1 count=0 seek=33554432
	@git clone $(LMNREPO) --branch=$(LMNBRCH) --depth=1
	@cp -v $(LMNDIR)/limine.sys $(LMNDIR)/limine-cd.bin $(LMNDIR)/limine-cd-efi.bin $(ISOBUILDDIR)
	@cd limine && make
# Formateo de la BIOS para que no de error: dd if=/dev/zero of=./OVMFbin/OVMF_riscv_virt.fd bs=1 count=0 seek=33554432
# Crear Limine-cd-efi.bin: cd limine && make
cleansetup:
	@rm -rf $(ISOBUILDDIR)
	@rm -rf $(LMNDIR)
	@rm -rf /mnt/c/Users/$(WINUSER)/$(WDIR)
	@rm -rf $(ISODIR)
	@rm -rf $(PROGSBUILDDIR)
	@rm -rf $(ISOBUILDDIR)
	@rm -rf $(OBJDIR)
	@rm -rf $(BUILDDIR)


buildimg: link
	@cp -v limine.cfg $(BUILDDIR)/$(KERNEL) $(ISOBUILDDIR)
	$(LOUD)xorriso -as mkisofs --efi-boot limine-cd-efi.bin -efi-boot-part \
		--efi-boot-image --protective-msdos-label $(ISOBUILDDIR) -o \
		$(ISODIR)/$(ISO) $(LOUD_REDIRECT)
# @xorriso -as mkisofs -b limine-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --efi-boot limine-cd-efi.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        $(ISOBUILDDIR) -o $(ISODIR)/$(ISO)
	$(LMN) $(ISODIR)/$(ISO)


run: buildimg
	$(RUN)

# Comando bueno, pero hace falta lo de losetup
# $(CMDNEWSCREEN) $(GDB) $(GDBFLAGS) & $(RUN) -s -S
# De momento ejecutar esto en terminal a parte
# riscv64-elf-gdb --nx --command=debug.gdb
# target extended-remote localhost:1234
debug: buildimg
	$(RUN) -s -S

clean:
	rm -vf *.o
	rm -vf $(KERNEL)
	find . -name '*~' -exec rm -vf '{}' \;
	@rm -rf $(OBJDIR)/*
	@rm -rf $(OBJS)
	@rm -f $(ISOBUILDDIR)/$(KERNEL)
	@rm -f $(ISOBUILDDIR)/$(LIMINECFG)
	@rm -f $(BUILDDIR)/$(KERNEL)
#@rm -f $(ISODIR)/$(IMG) 
	@rm -f $(ISODIR)/$(ISO)
#@rm -f $(ISODIR)/$(VDI)
	