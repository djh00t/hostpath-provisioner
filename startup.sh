#!/bin/bash
###
### Container startup script
###
# Set variables
export HS_ARCH=$(uname -m)
export HS_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
export APP="hostpath-provisioner"
export LOCATION="/usr/local/bin"
export BASENAME=$(ls /usr/local/bin/$APP-*|head -n 1|sed 's/.....$//')

# Alpine specific architecture check
if [ $HS_ARCH = aarch64 ]; then 
    export HS_ARCH="arm64"
fi

# Set correct binary name
export BINARY="${BASENAME}${HS_ARCH}"

# Create symlink for architecure
ln -s ${BINARY} $LOCATION/$APP

# Ensure that the binary is executable
chmod +x $LOCATION/$APP

# Start hostpath-provisioner
$LOCATION/$APP