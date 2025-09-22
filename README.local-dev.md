# Nginx Proxy Manager - Local Development Setup

This is a simplified HTTP-only reverse proxy container for local development environments.

## Features

- HTTP-only (no SSL/encryption) - perfect for local development
- Simple nginx-based reverse proxy
- Easy configuration through docker-compose
- No database dependencies
- Minimal resource usage

## Quick Start

1. **Build and run the container:**
   ```bash
   docker-compose -f docker-compose.local-dev.yml up -d
   ```

2. **Access the services:**
   - Reverse Proxy: http://localhost:80
   - Admin Interface: http://localhost:81
   - Example App (direct): http://localhost:8080 (if example-app service is running)

3. **Test the example proxy:**
   ```bash
   # Copy example configuration
   cp docker/local-dev/example-proxy.conf docker/local-dev/proxy-configs/
   
   # Reload nginx
   docker exec nginx-proxy-local-dev nginx -s reload
   
   # Test the proxy
   curl http://localhost/app
   ```

## Configuration

### Adding New Proxy Rules

1. Create a new `.conf` file in `docker/local-dev/proxy-configs/`
2. Add your server configuration, for example:

   ```nginx
   server {
       listen 80;
       server_name myapp.local;
       
       location / {
           proxy_pass http://host.docker.internal:3000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto http;
       }
   }
   ```

3. Reload nginx configuration:
   ```bash
   docker exec nginx-proxy-local-dev nginx -s reload
   ```

### Proxying to Host Services

To proxy to services running on your host machine, use `host.docker.internal`:

```nginx
proxy_pass http://host.docker.internal:3000;
```

### Proxying to Other Docker Containers

For containers in the same docker-compose network:

```nginx
proxy_pass http://container-name:port;
```

## Examples

### Proxy to Local Development Server
```nginx
server {
    listen 80;
    server_name dev.local;
    
    location / {
        proxy_pass http://host.docker.internal:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
    }
}
```

### Proxy with Path Prefix
```nginx
server {
    listen 80;
    server_name localhost;
    
    location /api/ {
        proxy_pass http://host.docker.internal:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
    }
}
```

## Logs

Nginx logs are stored in the `logs/` directory:
- `logs/access.log` - Access logs
- `logs/error.log` - Error logs

## Managing the Container

```bash
# Start the stack
docker-compose -f docker-compose.local-dev.yml up -d

# Stop the stack
docker-compose -f docker-compose.local-dev.yml down

# View logs
docker-compose -f docker-compose.local-dev.yml logs -f

# Reload nginx configuration
docker exec nginx-proxy-local-dev nginx -s reload

# Test nginx configuration
docker exec nginx-proxy-local-dev nginx -t
```

## Host File Configuration

For easier testing, add entries to your `/etc/hosts` file:

```
127.0.0.1 app.local
127.0.0.1 myapp.local
127.0.0.1 dev.local
```

## Differences from Full Nginx Proxy Manager

This local development version:
- ✅ Simple HTTP reverse proxy
- ✅ Easy configuration via files
- ✅ Minimal resource usage
- ❌ No web-based admin interface
- ❌ No SSL/TLS support
- ❌ No Let's Encrypt integration
- ❌ No user management
- ❌ No database

For production use, consider the full Nginx Proxy Manager with SSL support.