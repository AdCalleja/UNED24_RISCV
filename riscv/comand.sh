riscv64-unknown-elf-as -c entry.S -o entry.o
riscv64-unknown-elf-gcc -Wall -Wextra -c -mcmodel=medany kernel.c -o kernel.o -ffreestanding
riscv64-linux-gnu-ld -T linker.ld  -nostdlib kernel.o entry.o -o kernel.elf
qemu-system-riscv64 -machine virt -bios fw_payload.elf  -kernel kernel.elf -serial stdio -drive if=pflash,format=raw,unit=0,file=./OVMFbin/OVMF_CODE-pure-efi.fd,readonly=on -drive if=pflash,format=raw,unit=1,file=./OVMFbin/OVMF_VARS-pure-efi.fd 


riscv64-unknown-elf-gcc -Wall -Wextra -c -mcmodel=medany kernel.c -o kernel.o -ffreestanding && riscv64-linux-gnu-ld -T linker.ld  -nostdlib *.o -o kernel.elf && qemu-system-riscv64 -machine virt -bios none -kernel kernel.elf -serial stdio

 riscv64-linux-gnu-ld -T linker.ld  -nostdlib *.o -o kernel.elf

 riscv64-unknown-elf-as -c entry.S -o entry.o
 riscv64-unknown-elf-ld -T linker.ld -lgcc -nostdlib kernel.o entry.o -o kernel.elf

 qemu-system-riscv64 -M virt -m 256M -nographic \
	-bios build/platform/generic/firmware/fw_payload.bin \
	-gdb tcp::1234 \
	-S
gdb build/platform/generic/firmware/fw_payload.elf \
	-ex 'target remote localhost:1234'
