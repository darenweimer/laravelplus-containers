ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS production

RUN \
    #---------------------------------------------------------------------------
    # Upgrade System Packages
    #---------------------------------------------------------------------------
        apk upgrade --no-cache \
    #---------------------------------------------------------------------------
    # Add Laravel User/Group
    #---------------------------------------------------------------------------
        && addgroup -g 1000 laravel \
        && adduser -u 1000 -H -D -G laravel laravel \
    #---------------------------------------------------------------------------
    # Install Nginx
    #---------------------------------------------------------------------------
        && apk add --no-cache nginx \
        && sed -i 's/^\(\s*user\s\).*;/\1laravel;/' /etc/nginx/nginx.conf \
        && sed -i 's/^\(\s*\)#\s*gzip\(\s\|_\)/\1gzip\2/' /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/http.d/

WORKDIR /var/www

EXPOSE 80/tcp

CMD nginx -g 'daemon off;'
