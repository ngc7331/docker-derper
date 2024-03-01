#!/bin/bash

PLATFORMS=linux/amd64,linux/arm64

DOCKER_USER=ngc7331
DOCKER_REPO=derper

VERSION=$(cd tailscale && git describe)
VERSION=${VERSION#v}

docker buildx build \
    --platform ${PLATFORMS} \
    -t ${DOCKER_USER}/${DOCKER_REPO}:latest \
    -t ${DOCKER_USER}/${DOCKER_REPO}:${VERSION} \
    --push .
