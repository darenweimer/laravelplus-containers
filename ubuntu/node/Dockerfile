ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION} AS production

ARG NODE_VERSION

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
    # Install Node.js
    #---------------------------------------------------------------------------
        && apt install -y curl \
        && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
        && apt remove -y curl \
        && apt install -y nodejs \
    #---------------------------------------------------------------------------
    # Post-Installation Cleanup
    #---------------------------------------------------------------------------
        && apt autoremove --purge -y \
        && apt clean \
        && rm -rf /var/lib/apt/lists/* /var/tmp/*

WORKDIR /var/www

CMD tail -f /dev/null
