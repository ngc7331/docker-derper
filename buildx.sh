#!/bin/bash

PLATFORMS=linux/amd64,linux/arm64

DOCKER_USER=ngc7331
DOCKER_REPO=derper

VERSION=$(cat ./tailscale/VERSION.txt)

docker buildx build \
    --platform ${PLATFORMS} \
    -t ${DOCKER_USER}/${DOCKER_REPO}:latest \
    -t ${DOCKER_USER}/${DOCKER_REPO}:${VERSION} \
    --push .

docker buildx build \
    --platform ${PLATFORMS} \
    -f Dockerfile.unsafe \
    -t ${DOCKER_USER}/${DOCKER_REPO}:latest-unsafe \
    -t ${DOCKER_USER}/${DOCKER_REPO}:${VERSION}-unsafe \
    --push .
