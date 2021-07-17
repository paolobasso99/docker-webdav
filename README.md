# docker-webdav

A Nginx WebDAV docker container personalized to my needs.

The image, and resulting container, is designed to run behind a reverse proxy to handle SSL and authentication.

# Settings

Mount the `/data` volume, for example `./path/to/dir:/data`, which is the root folder that nginx will serve for WebDAV content (`/data`).

These are environment variables you can set, and what they do.

- `PUID=1000` user id with read/write access to `./path/to/dir:/data` volume. Nginx will use the same to be able to read/write to the folder.
- `PGID=1000` group id with read/write access to `./path/to/dir:/data` volume. Nginx will use the same to be able to read/write to the folder.
- `TZ=Europe/Berlin` specifies timezone for the underlying GNU/Linux system.
- `TIMEOUTS_S=1200` expressed as seconds, sets at the same time various nginx timeouts: `send_timeout`, `client_body_timeout`, `keepalive_timeout`, `lingering_timeout`.
- `CLIENT_MAX_BODY_SIZE=120M` limits file upload size to the expressed value, which must end wither with `M`(egabytes) or `G`(igabytes).

to find your `PUID` and `PGID` use `id username` as below:

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

# Set up

There are a few ways to set up this image:

- Clone this repository, copy `.env.example` to `.env`, edit the `.env` and run `docker-compose build && docker-compose up` to build and run the container. Access it from http://localhost:80;
- Build the Dockerfile and run the container with docker;
- Pull and run my docker image and use it with docker-compose or docker.

# SSL and authentication

No SSL and authentication is provided. For these features you should put the container behind a reverse proxy. 
