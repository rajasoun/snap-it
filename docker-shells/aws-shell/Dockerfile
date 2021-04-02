#
## Base builder image
##

#FROM alpine:3.12.0 as builder
FROM python:3.10.0a5-alpine3.13 as builder

RUN apk --update add --no-cache --virtual \
    .build-deps build-base automake autoconf \
    libtool git linux-pam-dev openssl-dev wget bash bash-completion \
    libffi-dev gcc linux-headers musl-dev make \
    && mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##
## Duo builder image
##
FROM builder as duo-builder

ARG DUO_VERSION=latest
RUN wget https://dl.duosecurity.com/duo_unix-${DUO_VERSION}.tar.gz && \
    mkdir -p src && \
    tar -zxf duo_unix-${DUO_VERSION}.tar.gz --strip-components=1 -C src

RUN cd src && \
    ./configure \
        --with-pam=/dist/lib64/security \
        --prefix=/dist/usr && \
    make && \
    make install

##
## AWS VAULT
##

FROM alpine:3.13.0 as aws-vault-builder
ENV AWS_VAULT_VERSION=v6.2.0

RUN set -ex \
    && apk add --no-cache curl \
    && curl -L -o /usr/local/bin/aws-vault \
        https://github.com/99designs/aws-vault/releases/download/${AWS_VAULT_VERSION}/aws-vault-linux-amd64 \
    && chmod 755 /usr/local/bin/aws-vault \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apk del curl

##
## snap shell image
##

FROM builder
LABEL Vendor="Alpine"
LABEL distro="alpine" distro_version="3.13.0" architecture="x86_64"

## Install Python Packages
RUN set -ex \
    && pip3 install awscli secretcli pipenv --no-warn-script-location \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install AWS Vault
COPY --from=aws-vault-builder /usr/ /usr/

## Install Duo
COPY --from=duo-builder dist/ /

## System
ENV TIMEZONE="Etc/UTC" \
    TERM="xterm" \
    HOSTNAME="bastion"

ENV MFA_PROVIDER="duo"

ENV UMASK="0022"

## Duo
ENV DUO_IKEY="" \
    DUO_SKEY="" \
    DUO_HOST="" \
    DUO_FAILMODE="secure" \
    DUO_AUTOPUSH="yes" \
    DUO_PROMPTS="1"
