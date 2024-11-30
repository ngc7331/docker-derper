# Build derper
FROM golang:alpine AS build
COPY . /tmp
RUN cd /tmp/tailscale/cmd/derper && \
    go build -o /go/bin/derper

# Build image
FROM ghcr.io/ngc7331/linuxserver-baseimage-alpine:3.20

# install acme.sh
RUN apk add --no-cache \
        openssl
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
ENV DERP_HOSTNAME=derp.example.com
ENV DERP_PORT_HTTP=80
ENV DERP_PORT_HTTPS=443
ENV DERP_PORT_STUN=3478
ENV DERP_ENABLE_HTTP=true
ENV DERP_ENABLE_STUN=true
ENV DERP_VERIFY_CLIENTS=false

# acme.sh Envs
ENV ACME_SH_EMAIL=admin@example.com
ENV ACME_SH_DNSAPI=dns_cf
ENV ACME_SH_CA=letsencrypt
ENV ACME_SH_FORCE_RENEW=false
# ... other dnsapi envs

VOLUME [ "/data" ]

EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 3478/udp
