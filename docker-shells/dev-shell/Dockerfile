#
## Base builder image
##

FROM alpine:latest as builder

## Install base packages
RUN apk --update add --no-cache --virtual \
    git openssl-dev wget bash bash-completion make neovim\
    zsh tmux openssh-client zsh ncurses \
    curl less man \
    && mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install zsh 
RUN RUN set -ex \
    && curl -L \
    https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# Install Vim Plug for plugin management
RUN RUN set -ex \
    && curl -fLo ~/.config/nvim/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
RUN RUN set -ex \
    && nvim +PlugInstall +qall >> /dev/null# Install Tmux Plugin Manager \
    && git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm \
    && .tmux/plugins/tpm/bin/install_plugins

## Copy dotfiles
COPY dotfiles/.zshrc .zshrc
COPY dotfiles/.zprofile .zprofile
COPY dotfiles/.alias.sh .alias.sh

# COPY vimrc .config/nvim/init.vim
# COPY tmux.conf .tmux.conf


##
## Node.js
##

FROM node:15.10.0-alpine3.13 as nodejs-builder

## Install Node Packages
RUN set -ex \
    && npm install sfdx-cli --global \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##
## snap shell image
##

FROM builder
LABEL Vendor="Alpine"
LABEL distro="alpine" distro_version="3.13.0" architecture="x86_64"



# Install Nodejs
COPY --from=nodejs-builder /usr/ /usr/

## System
ENV TIMEZONE="Etc/UTC" \
    TERM="xterm" \
    HOSTNAME="sfdc-snapit"

ENV UMASK="0022"
