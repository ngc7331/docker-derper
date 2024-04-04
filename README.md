# Docker-derper
An unofficial s6-overlay based Docker image for custom [Tailscale Derp server](https://tailscale.com/kb/1118/custom-derp-servers) with built-in [acme.sh](https://github.com/acmesh-official/acme.sh)

**THIS IS STILL WIP**

## Usage
```bash
docker run -d --name=derper \
    -p 80:80/tcp \ # Optional, see Note 2
    -p 443:443/tcp \
    -p 3478:3478/udp \ # Optional, see Note 2
    -e DERPER_HOSTNAME=derp.example.com \
    -e DERPER_CERTMODE=letsencrypt \
    -v /path/to/data:/data:rw \
    -v /path/to/cert:/data/cert:rw \ # Optional, see Note 1
    ngc7331/derper:latest
```
Notes:
1. A standalone `/data/cert` mapping is not necessary, but recommended if you want to use the `DERPER_CERTMODE=manual`, by which you can provide your own certificate and key files.
2. If you want to disable HTTP or STUN server, you can remove the corresponding port mapping. Also don't forget to set `DERPER_ENABLE_HTTP` or `DERPER_ENABLE_STUN` to `false`.

### Derp Environment Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `DERP_HOSTNAME` |  | The hostname of the Derp server (**MUST BE SET**) |
| `DERP_CERTMODE` | `acme.sh` | The mode of certificate management, should be `letsencrypt`, `acme.sh` or `manual` |
| `DERP_PORT_HTTP` | `80` | The port of HTTP server |
| `DERP_PORT_HTTPS` | `443` | The port of HTTPS server |
| `DERP_PORT_STUN` | `3478` | The port of STUN server |
| `DERP_ENABLE_HTTP` | `true` | Enable HTTP server |
| `DERP_ENABLE_STUN` | `true` | Enable [STUN](https://en.wikipedia.org/wiki/STUN) server |
| `DERP_VERIFY_CLIENTS` | `false` | Verify client certificate, see [official docs](https://tailscale.com/kb/1118/custom-derp-servers#optional-restricting-client-access-to-your-derp-node) |

### Acme.sh Environment Variables
If `DERP_CERTMODE` is set to `acme.sh`, the following environment variables are also required:
| Variable | Default | Description |
|----------|---------|-------------|
| `ACME_SH_EMAIL` |  | The email address for ZeroSSL registration |
| `ACME_SH_DNSAPI` |  | The API used to pass DNS challenge, see [official docs](https://github.com/acmesh-official/acme.sh/wiki/dnsapi) |
| `ACME_SH_CA` | letsencrypt | The ACME server, see [official docs](https://github.com/acmesh-official/acme.sh/wiki/Server) |
| `ACME_SH_FORCE_RENEW` | `false` | Force renew certificate |
| Other variables required by API |  | See [official docs](https://github.com/acmesh-official/acme.sh/wiki/dnsapi) |

Example using Cloudflare:
```bash
docker run ... \
    -e DERP_CERTMODE=acme.sh \
    -e ACME_SH_EMAIL=email@example.com \
    -e ACME_SH_DNSAPI=dns_cf \
    -e CF_Email=email@example.com \
    -e CF_Zone_ID=0123456 \
    -e CF_Token=abcdefg \
    ...
```

Note that `DERP_CERTMODE=acme.sh` can be used only with a DNS API to handle DNS chanllenge automatically.

Use `DERP_CERTMODE=letsencrypt` if you want to use HTTP challenge (as the standalone mode of acme.sh does).
