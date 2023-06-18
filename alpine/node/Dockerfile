ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS production

ARG NODE_PACKAGE=nodejs

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
    # Install Node.js
    #---------------------------------------------------------------------------
        && apk add --no-cache \
            ${NODE_PACKAGE} \
            npm

WORKDIR /var/www

CMD tail -f /dev/null
