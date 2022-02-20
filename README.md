# docker-webdav
![GitHub Repo stars](https://img.shields.io/github/stars/paolobasso99/docker-webdav?label=GITHUB%20STARS&style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/paolobasso/webdav?style=for-the-badge)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/paolobasso/webdav/latest?style=for-the-badge)

A simple [Caddy](https://caddyserver.com/) WebDAV docker image. The image, and resulting container, is designed to run behind a reverse proxy to handle SSL and authentication.

Links:
- [Source code on GitHub](https://github.com/paolobasso99/docker-webdav)
- [Repository on DockerHub](https://hub.docker.com/r/paolobasso/webdav)

## Settings
Mount the `/data` volume, for example `./path/to/dir:/data`, which is the root folder that Caddy will serve for WebDAV content (`/data`).

## Set up
There are a few ways to set up this image:

- Pull and run my docker image [paolobasso/webdav](https://hub.docker.com/r/paolobasso/webdav) and use it with `docker-compose` or `docker run`. An example `docker-compose.yml`:

```yaml
version: '3.8'

services:
  webdav:
    container_name: webdav
    image: paolobasso/webdav
    volumes:
      - ./data:/data
    ports:
      - 80:80
    restart: unless-stopped
```

- Clone this repository, copy `.env.example` to `.env`, edit the `.env` and run `docker-compose build && docker-compose up` to build and run the container. Access it from http://localhost:80;
- Build the Dockerfile and run the container with docker.

## SSL and authentication
No SSL and authentication is provided. For these features you should put the container behind a reverse proxy. 
