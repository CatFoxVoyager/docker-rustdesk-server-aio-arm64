# RustDesk Server AiO (self-hosted version) in Docker for ARM64/Raspberry Pi

Self-host your own RustDesk Server on ARM64 devices like Raspberry Pi, it is free and open source.

This container includes both the RustDesk Server and the RustDesk Relay in one and starts it (self-hosted version).

**Note:** This Docker image is based on the original work by [ich777](https://github.com/ich777/docker-rustdesk-server-aio). Thank you for creating the foundation! This version has been modified specifically for ARM64 architecture (Raspberry Pi) and is no longer optimized for Unraid.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| HBBS_ENABLED | Enable/disable the RustDesk signal server (hbbs). TCP: 21115, 21116, 21118 UDP: 21116 | true |
| HBBR_ENABLED | Enable/disable the RustDesk relay server (hbbr). TCP: 21117, 21119 | true |
| RELAY_SERVER | IP address or hostname of the relay server (automatically configures hbbs with -r parameter) | 192.168.1.100 or relay.example.com |
| KEY | Shared key for encryption (automatically configures both hbbs and hbbr with -k parameter). Use "_" to generate a random key. | _ |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| DATA_PERM | Data permissions | 770 |
| UMASK | Set permissions for newly created files | 000 |

## Run example

### Using Docker Compose (recommended)

1. Create a `docker-compose.yml` file (or use the provided one):
```yaml
version: '3.8'

services:
  rustdesk-server:
    image: splendid3002/rustdesk-server-aio-arm64:latest
    container_name: rustdesk-server-aio
    ports:
      - "21115:21115"
      - "21116:21116"
      - "21116:21116/udp"
      - "21117:21117"
      - "21118:21118"
      - "21119:21119"
    environment:
      - RELAY_SERVER=192.168.1.100  # Change to your server's IP
      - KEY=_                        # Auto-generate key
    volumes:
      - ./data:/rustdesk-server
    restart: unless-stopped
```

2. Start the container:
```bash
docker-compose up -d
```

### Using Docker CLI

#### Basic setup (simple configuration)
```bash
docker run --name RustDeskServer-AiO -d \
    -p 21115-21119:21115-21119 -p 21116:21116/udp \
    --env 'RELAY_SERVER=192.168.1.100' \
    --env 'KEY=_' \
    --volume /path/to/rustdesk-server:/rustdesk-server \
    --restart=unless-stopped \
    splendid3002/rustdesk-server-aio-arm64:latest
```

#### Advanced setup (with all options)
```bash
docker run --name RustDeskServer-AiO -d \
    -p 21115-21119:21115-21119 -p 21116:21116/udp \
    --env 'HBBS_ENABLED=true' \
    --env 'HBBR_ENABLED=true' \
    --env 'RELAY_SERVER=relay.example.com' \
    --env 'KEY=your-secret-key' \
    --env 'UID=99' \
    --env 'GID=100' \
    --env 'DATA_PERM=770' \
    --env 'UMASK=000' \
    --volume /path/to/rustdesk-server:/rustdesk-server \
    --restart=unless-stopped \
    splendid3002/rustdesk-server-aio-arm64:latest
```

## Configuration

### Relay and Rendezvous Server

This container runs both the **hbbs** (rendezvous/signal server) and **hbbr** (relay server) in a single container.

- **RELAY_SERVER**: Set this to the IP or hostname where clients can reach your relay server. This is automatically passed to hbbs with the `-r` parameter.
  - If running on the same machine: use your server's public IP or hostname
  - Example: `RELAY_SERVER=192.168.1.100` or `RELAY_SERVER=relay.example.com`

- **KEY**: Set to `_` to auto-generate a random key, or provide your own key for encryption. The key is shared between hbbs and hbbr.
  - Auto-generate: `KEY=_`
  - Custom key: `KEY=your-secret-key-here`

The configuration is now simpler - just set the `RELAY_SERVER` and `KEY` environment variables and the container will handle the rest!

### Automatic Updates

The Docker image automatically downloads and installs the **latest version** of RustDesk Server from GitHub releases when building. This means you always get the most recent version without having to manually update version numbers.

## ARM64/Raspberry Pi Compatibility

This Docker image has been specifically modified for ARM64 architecture:
- Uses ARM64 packages from RustDesk releases
- Based on `debian:bookworm-slim` for better ARM64 support
- Tested on Raspberry Pi 4/5

## Changes from Original

- **Architecture**: Modified to support ARM64 instead of AMD64
- **Base Image**: Changed from `ich777/debian-baseimage` to `debian:bookworm-slim`
- **Package URLs**: Updated to download ARM64 versions of RustDesk binaries
- **Target Platform**: Optimized for Raspberry Pi/ARM64 devices instead of Unraid

## Credits

Original Docker image created by [ich777](https://github.com/ich777/docker-rustdesk-server-aio). This is a community modification for ARM64 support.[1]
