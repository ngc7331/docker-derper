#!/bin/bash

PLATFORMS=linux/amd64,linux/arm64

DOCKER_USER=ngc7331
DOCKER_REPO=derper

docker buildx build \
    --platform ${PLATFORMS} \
    -t ${DOCKER_USER}/${DOCKER_REPO}:latest \
    --push .
