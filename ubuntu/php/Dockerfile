ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION} AS production

ARG PHP_VERSION

ENV PHP_VERSION=${PHP_VERSION}

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
        && useradd -u 1000 -g 1000 -m laravel \
        && usermod -L laravel \
    #---------------------------------------------------------------------------
    # Install PHP
    #---------------------------------------------------------------------------
        && apt install -y software-properties-common \
        && add-apt-repository -y ppa:ondrej/php \
        && apt update \
        && apt install -y \
            php${PHP_VERSION} \
            php${PHP_VERSION}-fpm \
        && sed -i 's/^\(\s*user\s*=\s*\).*/\1laravel/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
        && sed -i 's/^\(\s*group\s*=\s*\).*/\1laravel/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
        && sed -i 's/^\(\s*listen\s*=\s*\).*/\10.0.0.0:9000/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
        && mkdir -p /run/php \
        && touch /run/php/php8.2-fpm.sock \
    #---------------------------------------------------------------------------
    # Install PHP Extensions
    #---------------------------------------------------------------------------
        && apt install -y \
            php${PHP_VERSION}-bcmath \
            php${PHP_VERSION}-cli \
            php${PHP_VERSION}-ctype \
            php${PHP_VERSION}-curl \
            php${PHP_VERSION}-fileinfo \
            php${PHP_VERSION}-gd \
            php${PHP_VERSION}-igbinary \
            php${PHP_VERSION}-imagick \
            php${PHP_VERSION}-imap \
            php${PHP_VERSION}-intl \
            php${PHP_VERSION}-ldap \
            php${PHP_VERSION}-mbstring \
            php${PHP_VERSION}-memcached \
            php${PHP_VERSION}-msgpack \
            php${PHP_VERSION}-mysql \
            php${PHP_VERSION}-pdo \
            php${PHP_VERSION}-pgsql \
            php${PHP_VERSION}-readline \
            php${PHP_VERSION}-redis \
            php${PHP_VERSION}-soap \
            php${PHP_VERSION}-sqlite3 \
            php${PHP_VERSION}-tokenizer \
            php${PHP_VERSION}-xml \
            php${PHP_VERSION}-zip \
    #---------------------------------------------------------------------------
    # Install Composer
    #---------------------------------------------------------------------------
        && apt install -y \
            curl \
            unzip \
        && curl -sS https://getcomposer.org/installer -o composer-setup.php \
        && apt remove -y curl \
        && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
        && rm composer-setup.php \
    #---------------------------------------------------------------------------
    # Setup Task Scheduler
    #---------------------------------------------------------------------------
        && apt install -y cron \
        && echo '* * * * * cd /var/www && php artisan schedule:run >> /dev/null 2>&1' | crontab -u laravel - \
    #---------------------------------------------------------------------------
    # Post-Installation Cleanup
    #---------------------------------------------------------------------------
        && apt autoremove --purge -y \
        && apt clean \
        && rm -rf /var/lib/apt/lists/* /var/tmp/*

COPY php-custom.ini /etc/php/${PHP_VERSION}/fpm/conf.d/
COPY php-custom.ini /etc/php/${PHP_VERSION}/cli/conf.d/

WORKDIR /var/www

CMD /usr/sbin/php-fpm${PHP_VERSION} --nodaemonize

FROM production AS development

RUN \
    #---------------------------------------------------------------------------
    # Install System Packages
    #---------------------------------------------------------------------------
        apt update \
        && apt install -y \
            curl \
            htop \
            nano \
    #---------------------------------------------------------------------------
    # Install PHP Extensions
    #---------------------------------------------------------------------------
        && apt install -y \
            php${PHP_VERSION}-dev \
            php${PHP_VERSION}-xdebug \
    #---------------------------------------------------------------------------
    # Post-Installation Cleanup
    #---------------------------------------------------------------------------
        && apt autoremove --purge -y \
        && apt clean \
        && rm -rf /var/lib/apt/lists/* /var/tmp/*

COPY xdebug.ini /etc/php/${PHP_VERSION}/mods-available/
