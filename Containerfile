# Custom Caddy build with Cloudflare and PowerDNS DNS providers.
# CADDY_VERSION is set by the CI workflow; "2" is a fallback for local builds.
ARG CADDY_VERSION=2

FROM docker.io/library/caddy:${CADDY_VERSION}-builder AS builder

# Pin module versions (e.g. @v0.2.1) if you want builds to be fully reproducible.
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    xcaddy build \
      --with github.com/caddy-dns/cloudflare \
      --with github.com/caddy-dns/powerdns

FROM docker.io/library/caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
