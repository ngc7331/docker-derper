# Build derper
FROM --platform=${TARGETPLATFORM} golang:latest AS build
RUN go install tailscale.com/cmd/derper@main

# Build image
FROM --platform=${TARGETPLATFORM} lscr.io/linuxserver/baseimage-ubuntu:jammy

# install acme.sh
COPY acme.sh /app/acme.sh

# install derper
COPY --from=build /go/bin/derper /bin/derper

# Copy root filesystem
COPY root /

# Common Envs
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Shanghai

# Derper Envs
ENV DERP_CERTMODE=acme.sh
ENV DERP_HOSTNAME=
ENV DERP_ENABLE_HTTP=true
ENV DERP_ENABLE_STUN=true
ENV DERP_VERIFY_CLIENTS=false

# acme.sh Envs
ENV ACME_SH_EMAIL=
ENV ACME_SH_DNSAPI=
# ... other dnsapi envs

VOLUME [ "/data" ]

EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 3478/udp
