#!/bin/bash

set -e

# Path to the Unix socket used by QEMU for the monitor
MONITOR_SOCKET="./u20s.sock"
# Use socat to interact with the QEMU monitor
SOCAT_CMD="sudo socat - UNIX-CONNECT:$MONITOR_SOCKET"
# Enable postcopy
ENABLE_POSTCOPY_CMD="migrate_set_capability postcopy-ram on"

# Start the QEMU process waiting for incoming migration
sudo qemu-system-x86_64 \
    -serial file:./output \
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
    -vnc localhost:0 \
    -incoming rdma:0.0.0.0:4444 

# enable postcopy to prepare for the migration 
echo "$ENABLE_POSTCOPY_CMD" | $SOCAT_CMD 

