#!/bin/bash
###
### golang multiarch build script
### Adapted from: https://itnext.io/create-go-based-docker-multiarch-images-the-easy-way-74a35cf62c0
###

echo "Building multiarch binaries..."

# Set application name
name=hostpath-provisioner

# Make sure upx is installed with apt
if ! command -v upx &> /dev/null
then
    echo "upx could not be found, installing..."
    apt update
    apt install -y upx
fi

# Build binaries
echo "Building amd64 binary..."
GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o linux/amd64/"$name"
echo "Building arm64 binary..."
GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o linux/arm64/"$name"

# Compress binaries
echo "Compressing binaries..."
upx --best --lzma linux/amd64/"$name"
upx --best --lzma linux/arm64/"$name"
