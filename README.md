# RustDesk Server AiO (self-hosted version) in Docker for ARM64/Raspberry Pi

Self-host your own RustDesk Server on ARM64 devices like Raspberry Pi, it is free and open source.

This container includes both the RustDesk Server and the RustDesk Relay in one and starts it (self-hosted version).

**Note:** This Docker image is based on the original work by [ich777](https://github.com/ich777/docker-rustdesk-server-aio). Thank you for creating the foundation! This version has been modified specifically for ARM64 architecture (Raspberry Pi) and is no longer optimized for Unraid.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| HBBS_ENABLED | The server needs by default the following ports to work properly: TCP: 21115, 21116, 21118 UDP: 21116 | true |
| HBBS_PARAMS | Enter your extra start up parameters for the server here if necessary. | --key _ |
| HBBR_ENABLED | The relay needs by default the following ports to work properly: TCP: 21117, 21119 | true |
| HBBR_PARAMS | Enter your extra start up parameters for the relay here if necessary. | --key _ |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| DATA_PERM | Data permissions | 770 |
| UMASK | Set permissions for newly created files | 000 |

## Run example
```bash
docker run --name RustDeskServer-AiO -d \
    -p 21115-21119:21115-21119 -p 21116:21116/udp \
    --env 'HBBS_ENABLED=true' \
    --env 'HBBS_PARAMS=--key _' \
    --env 'HBBR_ENABLED=true' \
    --env 'HBBR_PARAMS=--key _' \
    --env 'UID=99' \
    --env 'GID=100' \
    --env 'DATA_PERM=770' \
    --env 'UMASK=000' \
    --volume /path/to/rustdesk-server:/rustdesk-server \
    --restart=unless-stopped \
    splendid3002/rustdesk-server-aio-arm64:latest
```

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
