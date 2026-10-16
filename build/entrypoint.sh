#!/bin/sh

# Clean up old files
rm -f /etc/bind/*.hosts
rm -f /etc/bind/*.jnl
 
# Persistent RFC 5011 trust-anchor state (see managed-keys-directory in named.conf)
mkdir -p /etc/bind/managed-keys

echo "copying hosts/config"
cp /config/*.hosts /etc/bind/
cp /config/named.conf /etc/bind/named.conf

# exec: supervisord replaces this shell as PID 1 and handles SIGTERM (stops
# named, then exits). A shell PID 1 ignored SIGTERM, so every bind update
# waited the full docker stop timeout (180 s) before the container was killed.
exec supervisord -c /supervisord.conf