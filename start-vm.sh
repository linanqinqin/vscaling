#!/bin/bash

set -e 

# start the vm
sudo qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 16 \
    -m 64G \
    -device virtio-scsi-pci,id=scsi0 \
    -device scsi-hd,drive=hd0,id=disk0 \
    -drive file=/nfs/u20s.qcow2,if=none,aio=native,cache=none,format=qcow2,id=hd0 \
    -net user,hostfwd=tcp::8080-:22 \
    -net nic,model=virtio \
    -daemonize \
    -monitor unix:./u20s.sock,server,nowait \
    -vnc localhost:0

# prepare migration on the destination machine
ssh node1 "/users/lnqq/start-vm.sh"

