#!/usr/bin/env bash

PLATFORM=linux/amd64,linux/arm64

title()
{
    echo
    echo -e "\033[34;44m  ----- $1 -----  \033[0m"
    echo -e "\033[36;44m  ----- $1 -----  \033[0m"
    echo -e "\033[34;44m  ----- $1 -----  \033[0m"
    echo
}

create_builder()
{
    title "Create Temporary Buildx Builder"

    docker buildx create \
        --name bob_the_buildx \
        --driver docker-container \
        --bootstrap \
        --use
}

delete_builder()
{
    title "Delete Temporary Buildx Builder"

    docker buildx rm bob_the_buildx
}

container()
{
    local context="$1/$2"
    local target=$3
    local tag=$4
    local build_args=(${@:5})

    title "Build Container: $tag"

    build_args=${build_args[@]/#/--build-arg }

    docker buildx build \
        --target $target \
        --platform $PLATFORM \
        --tag $tag \
        $build_args \
        --push \
        $context
}

create_builder

container  alpine  nginx  production   laravelplus/nginx:alpine3.18        ALPINE_VERSION=3.18
container  alpine  php    production   laravelplus/php:8.2-alpine3.18      ALPINE_VERSION=3.18  PHP_VERSION=82
container  alpine  php    development  laravelplus/php:8.2-alpine3.18-dev  ALPINE_VERSION=3.18  PHP_VERSION=82
container  alpine  node   production   laravelplus/node:18-alpine3.18      ALPINE_VERSION=3.18  NODE_PACKAGE=nodejs

container  ubuntu  nginx  production   laravelplus/nginx:ubuntu22.04        UBUNTU_VERSION=22.04
container  ubuntu  php    production   laravelplus/php:8.2-ubuntu22.04      UBUNTU_VERSION=22.04  PHP_VERSION=8.2
container  ubuntu  php    development  laravelplus/php:8.2-ubuntu22.04-dev  UBUNTU_VERSION=22.04  PHP_VERSION=8.2
container  ubuntu  node   production   laravelplus/node:18-ubuntu22.04      UBUNTU_VERSION=22.04  NODE_VERSION=18

delete_builder
