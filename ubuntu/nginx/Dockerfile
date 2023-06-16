ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION} AS production

RUN \
    #---------------------------------------------------------------------------
    # Upgrade System Packages
    #---------------------------------------------------------------------------
        apt update \
        && apt upgrade -y \
    #---------------------------------------------------------------------------
    # Add Laravel User/Group
    #---------------------------------------------------------------------------
        && groupadd -g 1000 laravel \
        && useradd -u 1000 -g 1000 -M laravel \
        && usermod -L laravel \
    #---------------------------------------------------------------------------
    # Install Nginx
    #---------------------------------------------------------------------------
        && apt install -y nginx \
        && sed -i 's/user .*;/user laravel;/' /etc/nginx/nginx.conf \
        && sed -i 's/#\s*gzip/gzip/' /etc/nginx/nginx.conf \
    #---------------------------------------------------------------------------
    # Post-Installation Cleanup
    #---------------------------------------------------------------------------
        && apt autoremove --purge -y \
        && apt clean \
        && rm -rf /var/lib/apt/lists/* /var/tmp/*

COPY default.conf /etc/nginx/sites-available/default

WORKDIR /var/www

EXPOSE 80/tcp

CMD nginx -g 'daemon off;'
