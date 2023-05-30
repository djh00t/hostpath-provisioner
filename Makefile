.DEFAULT_GOAL := default

IMAGE ?= hostpath-provisioner:latest

export DOCKER_CLI_EXPERIMENTAL=enabled

.PHONY: build # Build the container image
build:
	@docker buildx create --use --name=crossplat --bootstrap && \
	docker buildx build \
		--output "type=docker,push=false" \
		--tag $(IMAGE) \
		.

.PHONY: publish # Push the image to the remote registry
publish:
	@docker buildx create --use --name=crossplat --bootstrap && \
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--output "type=image,push=true" \
		--tag $(IMAGE) \
		.

###publish:
###	@docker buildx create --use --name=crossplat --bootstrap && \
###	docker buildx build \
###		--platform linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/s390x \
###		--output "type=image,push=true" \
###		--tag $(IMAGE) \
###		.