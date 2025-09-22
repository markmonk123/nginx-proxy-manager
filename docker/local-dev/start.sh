#!/bin/sh

echo "Starting Nginx Proxy Manager - Local Development"
echo "================================================="
echo ""
echo "This is a simplified reverse proxy for local development"
echo "- HTTP only (no SSL/encryption)"
echo "- Port 80: Reverse proxy"
echo "- Port 81: Admin/status interface"
echo ""
echo "To add proxy configurations:"
echo "1. Create configuration files in /etc/nginx/conf.d/"
echo "2. Reload nginx: nginx -s reload"
echo ""

# Start nginx in foreground
exec nginx -g "daemon off;"