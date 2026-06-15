# Pin the base image to a specific Alpine version + digest instead of the
# floating "alpine:latest" tag. This makes builds reproducible and prevents
# silently picking up a changed/compromised upstream image.
# alpine:3.21 (multi-arch index digest, resolved 2026-06-15)
FROM --platform=linux/amd64 alpine:3.21@sha256:48b0309ca019d89d40f670aa1bc06e426dc0931948452e8491e3d65087abc07d

# --no-cache always pulls the current package index, so security updates for
# bind/supervisor are still picked up at build time despite the pinned base.
#RUN apk --no-cache add bind dnscrypt-proxy supervisor && \
RUN apk --no-cache upgrade && \
    apk --no-cache add bind supervisor && \
    mkdir -p /var/bind/log

# COPY bind /etc/bind/
COPY bind /config/
COPY entrypoint.sh /usr/bin/

COPY supervisord.conf .
# COPY dnscrypt-proxy.toml .

EXPOSE 53/udp

ENTRYPOINT [ "entrypoint.sh" ]