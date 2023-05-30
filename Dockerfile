FROM scratch

# Set up build arguments
ARG TARGETOS
ARG TARGETARCH

# Copy binaries into container
ADD /${TARGETOS}/${TARGETARCH} /

# Create entrypoint
ENTRYPOINT ["/hostpath-provisioner"]
