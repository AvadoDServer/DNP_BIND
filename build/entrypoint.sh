#!/bin/sh

# Clean up old files
rm -f /etc/bind/*.hosts
rm -f /etc/bind/*.jnl
 
# Persistent RFC 5011 trust-anchor state (see managed-keys-directory in named.conf)
mkdir -p /etc/bind/managed-keys

echo "copying hosts/config"
cp /config/*.hosts /etc/bind/
cp /config/named.conf /etc/bind/named.conf

supervisord -c /supervisord.conf