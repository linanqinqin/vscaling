#!/bin/bash

set -e

# Path to the Unix socket used by QEMU for the monitor
MONITOR_SOCKET="./u20s.sock"

# Use socat to interact with the QEMU monitor 
SOCAT_CMD="sudo socat - UNIX-CONNECT:$MONITOR_SOCKET"

# Commands to send to the QEMU monitor
# Get the status on the current migration
INFO_CMD="info migrate"
# Enable postcopy
ENABLE_POSTCOPY_CMD="migrate_set_capability postcopy-ram on"
# set migration speed
SET_BW_CMD="migrate_set_parameter max-bandwidth 40g"
SET_POSTCOPY_BW_CMD="migrate_set_parameter max-postcopy-bandwidth 40g"
# Start a migration
MIGRATE_CMD="migrate -d rdma:192.168.1.2:4444"
# Switch migration to postcopy
SWITCH_POSTCOPY_CMD="migrate_start_postcopy"


echo "$ENABLE_POSTCOPY_CMD" | $SOCAT_CMD 
echo "$SET_BW_CMD" | $SOCAT_CMD 
echo "$SET_POSTCOPY_BW_CMD" | $SOCAT_CMD 

# Sending the command to the QEMU monitor
echo "$MIGRATE_CMD" | $SOCAT_CMD 
echo "$SWITCH_POSTCOPY_CMD" | $SOCAT_CMD

# Additional commands can be sent in a similar manner
# Example: Check migration status
echo "$INFO_CMD" | $SOCAT_CMD

echo 

