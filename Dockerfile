FROM golang:1.16-alpine AS builder

# Install Go from golang:1.16-alpine
COPY --from=golang:1.16-alpine /usr/local/go/ /usr/local/go/

# Set up Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

# Set up build arguments
ARG srcpath="/build/hostpath-provisioner"

# Install git
RUN apk --no-cache add git; \
    mkdir -p "$srcpath/amd64"; \
    mkdir -p "$srcpath/arm64"

# Copy source code into container $srcpath/amd64
ADD . "$srcpath/amd64"

# Copy source code into container $srcpath/arm64
ADD . "$srcpath/arm64"

# Build binaries for arm64 and amd64
RUN cd "$srcpath/amd64" && \
    GO111MODULE=on \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -ldflags '-extldflags "-static"' -o /hostpath-provisioner-amd64; \
    cd "$srcpath/arm64" && \
    GO111MODULE=on \
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 \
    go build -a -ldflags '-extldflags "-static"' -o /hostpath-provisioner-arm64

# Path: Dockerfile
FROM scratch

# Copy binaries into container
COPY --from=builder /hostpath-provisioner-* /usr/local/bin/

# Copy startup.sh script into container
COPY startup.sh /startup.sh

# Set up startup.sh script as entrypoint
CMD ["/startup.sh"]
