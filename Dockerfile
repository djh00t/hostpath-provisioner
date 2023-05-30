FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.16 AS builder

# Install Go from golang:1.16-alpine
#COPY --from=golang:1.16-alpine /usr/local/go/ /usr/local/go/

# Set up Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

# Set up build arguments
ARG srcpath="/build/hostpath-provisioner"

# Install git
RUN apk --no-cache add git; \
    mkdir -p "$srcpath"

WORKDIR "$srcpath"

ADD . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o hostpath-provisioner hostpath-provisioner.go

FROM --platform=${TARGETPLATFORM:-linux/amd64} scratch
WORKDIR "$srcpath"
COPY --from=builder "$srcpath/hostpath-provisioner" $srcpath/hostpath-provisioner
ENTRYPOINT ["$srcpath/hostpath-provisioner"]