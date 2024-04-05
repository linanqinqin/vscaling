#!/bin/bash

VM_NAME="u20s"
DEST_HOST="qemu+ssh://lnqq@10.10.1.2/system"
SLEEP_TIME=1

# Start migration in a detached screen session
screen -dmS migrate_session virsh migrate --live --postcopy ${VM_NAME} ${DEST_HOST}

# Wait for some time to ensure migration starts
sleep 2  # Adjust this duration as necessary

# Attempt to switch to post-copy in a loop until successful
while true; do
    virsh migrate-postcopy ${VM_NAME}
    if [ $? -eq 0 ]; then
        echo "Migration switched to post-copy successfully."
        break
    else
        echo "Attempting to switch to post-copy again..."
        sleep 0.1  # Wait a bit before retrying
    fi
done

# Check if the migration has completed
while true; do
    if ! screen -ls | grep -q "migrate_session"; then
        echo "Migration has completed."
        break
    else
        sleep 1 
    fi
done

