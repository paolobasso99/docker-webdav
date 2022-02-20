FROM caddy:2-builder-alpine AS builder

RUN xcaddy build --with github.com/mholt/caddy-webdav

FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

COPY Caddyfile /etc/caddy/Caddyfile
VOLUME /data

EXPOSE 80
