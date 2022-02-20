FROM lscr.io/linuxserver/baseimage-ubuntu:focal AS builder

LABEL maintainer="Paolo Basso"

ARG NGINX_VER_ARG=1.21.6
ENV NGINX_VER=$NGINX_VER_ARG
ENV NGINX_DAV_EXT_VER 3.0.0
ENV HEADERS_MORE_VER 0.33

ENV MAKE_THREADS 4
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV APT_LISTCHANGES_FRONTEND none

RUN apt-get update && \
  apt-get -y install --no-install-recommends \
  apache2-utils \
  automake \
  build-essential \
  libcurl4-openssl-dev \
  libgd-dev \
  libgeoip-dev \
  libpcre3-dev \
  libperl-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  mime-support \
  wget \
  zlib1g-dev

RUN apt-get -y autoclean

WORKDIR /usr/src
RUN wget https://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /usr/src/nginx-${NGINX_VER}.tar.gz && \
    wget https://github.com/arut/nginx-dav-ext-module/archive/v${NGINX_DAV_EXT_VER}.tar.gz \
      -O /usr/src/nginx-dav-ext-module-v${NGINX_DAV_EXT_VER}.tar.gz && \
    wget https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VER}.tar.gz \
      -O /usr/src/headers-more-nginx-module-v${HEADERS_MORE_VER}.tar.gz && \
    /bin/bash -c "set -o pipefail && ls *.gz | xargs -n1 tar -xzf"

WORKDIR /usr/src/nginx-${NGINX_VER}
RUN ./configure --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --user=nginx \
  --group=nginx \
  --build=Ubuntu \
  --builddir=nginx-${NGINX_VER} \
  --with-select_module \
  --with-poll_module \
  --with-threads \
  --with-file-aio \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module=dynamic \
  --with-http_image_filter_module=dynamic \
  --with-http_geoip_module=dynamic \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-http_perl_module=dynamic \
  --with-perl_modules_path=/usr/share/perl/5.26.1 \
  --with-perl=/usr/bin/perl \
  --http-log-path=/var/log/nginx/access.log \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --with-mail=dynamic \
  --with-mail_ssl_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_geoip_module=dynamic \
  --with-stream_ssl_preread_module \
  --with-compat \
  --with-pcre \
  --with-pcre-jit \
  --with-openssl-opt=no-nextprotoneg \
  --with-debug \
  --add-module=/usr/src/nginx-dav-ext-module-${NGINX_DAV_EXT_VER} 

RUN make -j${MAKE_THREADS} && \
  make install

FROM lscr.io/linuxserver/baseimage-ubuntu:focal
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/lib/nginx/modules/ /usr/lib/nginx/modules/
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /var/log/nginx /var/log/nginx

RUN apt-get update && \
  apt-get -y install --no-install-recommends \
  apache2-utils \
  automake \
  build-essential \
  libcurl4-openssl-dev \
  libgd-dev \
  libgeoip-dev \
  libpcre3-dev \
  libperl-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  mime-support \
  zlib1g-dev

RUN apt-get -y autoclean

VOLUME /data
VOLUME /config

EXPOSE 80

COPY nginx.conf /etc/nginx/

RUN mkdir -p /etc/nginx/logs \
  /var/cache/nginx/client_temp \
  /var/cache/nginx/fastcgi_temp \
  /var/cache/nginx/proxy_temp \
  /var/cache/nginx/scgi_temp \
  /var/cache/nginx/uwsgi_temp \
  && chmod 700 /var/cache/nginx/* \
  && chown abc:abc /var/cache/nginx/* \
  # from https://github.com/nginxinc/docker-nginx
  # forward request and error logs to docker log collector
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

COPY /root /
WORKDIR /data
CMD ["/usr/sbin/nginx"]