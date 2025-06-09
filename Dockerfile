FROM ruby:2.6-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NOWARNINGS="yes" \
    LANG=en_US.UTF-8 \
    BUNDLE_PATH=/bundle_cache \
    GEM_HOME=/bundle_cache \
    GEM_PATH=/bundle_cache
ARG INSTALL_DEVELOPMENT_DEPENDENCIES=false

RUN sed -e '/bullseye-updates/ s/^#*/#/' -i /etc/apt/sources.list && \
    apt-get clean && \
    apt-get update && \
    apt-get install -qq -y wget && \
    wget -qO- https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev git-core imagemagick \
      default-libmysqlclient-dev default-mysql-client netcat shared-mime-info \
      libqt5webkit5 libqt5webkit5-dev xvfb \
      libvips-dev libvips-tools \
      cmake pkg-config file \
      sudo postgresql-client-13 curl vim-tiny && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    corepack enable

RUN echo "alias m='make'\n\
  alias ms='make start'\n\
  alias mss='make start_no_async'\n\
  alias mc='make console'\n\
  alias mcs='make console_no_async'\n\
  alias r='bundle exec rspec'\n\
  alias ra='bundle exec rubocop -a'\n\
  alias raa='bundle exec rubocop -A'\n\
  alias cred='bin/rails credentials:edit --environment development'\n\
  alias crsd='bin/rails credentials:show --environment development'\n\
  alias cres='bin/rails credentials:edit --environment staging'\n\
  alias crss='bin/rails credentials:show --environment staging'\n\
  alias crep='bin/rails credentials:edit --environment production'\n\
  alias crsp='bin/rails credentials:show --environment production'\n\
  alias cret='bin/rails credentials:edit --environment test'\n\
  alias crst='bin/rails credentials:show --environment test'\n\
  alias sw='bundle exec rake rswag:specs:swaggerize'\n\
  export EDITOR=vi\n\
  export PATH=\$PATH:/bundle_cache/bin:/app/bin" >> ~/.bashrc
