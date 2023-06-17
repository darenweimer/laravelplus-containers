ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS production

ARG PHP_VERSION

ENV PHP_VERSION=${PHP_VERSION}

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
    # Install PHP
    #---------------------------------------------------------------------------
        && apk add --no-cache \
            php${PHP_VERSION} \
            php${PHP_VERSION}-fpm \
        && sed -i 's/^\(\s*user\s*=\s*\).*/\1laravel/' /etc/php${PHP_VERSION}/php-fpm.d/www.conf \
        && sed -i 's/^\(\s*group\s*=\s*\).*/\1laravel/' /etc/php${PHP_VERSION}/php-fpm.d/www.conf \
        && sed -i 's/^\(\s*listen\s*=\s*\).*/\10.0.0.0:9000/' /etc/php${PHP_VERSION}/php-fpm.d/www.conf \
        && ln -sf /usr/bin/php${PHP_VERSION} /usr/bin/php \
    #---------------------------------------------------------------------------
    # Install PHP Extensions
    #---------------------------------------------------------------------------
        && apk add --no-cache \
            php${PHP_VERSION}-bcmath \
            php${PHP_VERSION}-cli \
            php${PHP_VERSION}-ctype \
            php${PHP_VERSION}-curl \
            php${PHP_VERSION}-fileinfo \
            php${PHP_VERSION}-gd \
            php${PHP_VERSION}-imap \
            php${PHP_VERSION}-intl \
            php${PHP_VERSION}-ldap \
            php${PHP_VERSION}-mbstring \
            php${PHP_VERSION}-pdo \
            php${PHP_VERSION}-pdo_mysql \
            php${PHP_VERSION}-pdo_pgsql \
            php${PHP_VERSION}-pdo_sqlite \
            php${PHP_VERSION}-pecl-igbinary \
            php${PHP_VERSION}-pecl-imagick \
            php${PHP_VERSION}-pecl-memcached \
            php${PHP_VERSION}-pecl-msgpack \
            php${PHP_VERSION}-pecl-redis \
            php${PHP_VERSION}-phar \
            php${PHP_VERSION}-soap \
            php${PHP_VERSION}-tokenizer \
            php${PHP_VERSION}-xml \
            php${PHP_VERSION}-zip \
    #---------------------------------------------------------------------------
    # Install Composer
    #---------------------------------------------------------------------------
        && apk add --no-cache \
            curl \
            unzip \
        && curl -sS https://getcomposer.org/installer -o composer-setup.php \
        && apk del --no-cache curl \
        && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
        && rm composer-setup.php \
    #---------------------------------------------------------------------------
    # Setup Task Scheduler
    #---------------------------------------------------------------------------
        && echo '* * * * * cd /var/www && php artisan schedule:run >> /dev/null 2>&1' | crontab -u laravel -

COPY php-custom.ini /etc/php${PHP_VERSION}/conf.d/

WORKDIR /var/www

CMD /usr/sbin/php-fpm${PHP_VERSION} --nodaemonize

FROM production AS development

RUN \
    #---------------------------------------------------------------------------
    # Install System Packages
    #---------------------------------------------------------------------------
        apk add --no-cache \
            curl \
            htop \
            nano \
    #---------------------------------------------------------------------------
    # Install PHP Extensions
    #---------------------------------------------------------------------------
        && apk add --no-cache \
            php${PHP_VERSION}-dev \
            php${PHP_VERSION}-xdebug

COPY 50_xdebug.ini /etc/php${PHP_VERSION}/conf.d/
