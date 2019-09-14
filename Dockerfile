FROM lsiobase/alpine:3.9

ENV IPADDR 192.168.1.5
ENV GAMEDIR /data/games

WORKDIR /config

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
  autoconf \
  automake \
  freetype-dev \
  g++ \
  gcc \
  jpeg-dev \
  lcms2-dev \
  libffi-dev \
  libpng-dev \
  libwebp-dev \
  linux-headers \
  make \
  openjpeg-dev \
  openssl-dev \
  python3-dev \
  tiff-dev \
  zlib-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
  curl \
  freetype \
  git \
  jq \
  lcms2 \
  libjpeg-turbo \
  libwebp \
  openjpeg \
  openssl \
  p7zip \
  py3-lxml \
  python3 \
  py3-qt5 \
  tar \
  tiff \
  unrar \
  unzip \
  vnstat \
  wget \
  xz \
  zlib && \
 echo "**** use ensure to check for pip and link /usr/bin/pip3 to /usr/bin/pip ****" && \
 python3 -m ensurepip && \
 rm -r /usr/lib/python*/ensurepip && \
 if \
  [ ! -e /usr/bin/pip ]; then \
  ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
  pip \
  setuptools && \
 pip install -U \
  configparser \
  ndg-httpsclient \
  notify \
  paramiko \
  pillow \
  psutil \
  pyopenssl \
  colorama \
  tqdm \
  unidecode \
  beautifulsoup4 \
  urllib3 \
  google-api-python-client \
  google-auth-oauthlib \
  flask \
  pyusb \
  requests \
  setuptools \
  urllib3 \
  virtualenv && \
 echo "**** clean up ****" && \
 apk del --purge \
  build-dependencies && \
 rm -rf \
  /root/.cache \
  /tmp/*
RUN git clone https://github.com/blawar/nut.git

WORKDIR /config/nut/conf
RUN jq --arg v1 $GAMEDIR '.paths.scan = $v1' < nut.default.conf | jq --arg v2 $IPADDR '.server.hostname = $v2' | tee setup.conf && \
mv setup.conf nut.default.conf
