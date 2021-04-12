#
## Base builder image
##

FROM debian:buster-slim as dev-shell-builder

RUN set -ex \
  && apt-get update \
  && apt-get install --yes --no-install-recommends \
  ca-certificates wget git zsh lsof vim\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.deb

ENV APP_USER=ubuntu
ENV APP_USER_GROUP=root
ARG APP_USER_HOME=/home/$APP_USER

RUN useradd -rm -d /home/$APP_USER -s /bin/zsh -g root -G sudo -u 1001 $APP_USER

USER $APP_USER
WORKDIR $APP_USER_HOME

##
## dev-shell
##

FROM dev-shell-builder
LABEL Vendor="Alpine"
LABEL distro="alpine" distro_version="3.13.0" architecture="x86_64"

# install oh-my-zsh
RUN wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true
ARG ZSH_CUSTOM=$APP_USER_HOME/.oh-my-zsh/custom

## Copy dotfiles
COPY --chown=$APP_USER:$APP_USER_GROUP dotfiles/.zshrc $APP_USER_HOME/.zshrc
COPY --chown=$APP_USER:$APP_USER_GROUP dotfiles/.zprofile $APP_USER_HOME/.zprofile
COPY --chown=$APP_USER:$APP_USER_GROUP dotfiles/.alias.sh $APP_USER_HOME/.alias.sh

CMD ["/usr/bin/zsh"]
