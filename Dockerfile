FROM lsiobase/alpine:3.10

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
  bs4 \
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

ENV PYTHONIOENCODING="UTF-8"

# Copy s6 overlay files
COPY root/ /

ENV GAMEDIR /data/games

RUN \
 echo "**** Fetching and configuring nut. ****" && \
 wget --no-check-certificate -O nut-master.zip https://github.com/blawar/nut/archive/master.zip &&\
 wget --no-check-certificate -O titledb.zip https://github.com/blawar/titledb/archive/master.zip &&\
 unzip nut-master.zip && \
 unzip titledb.zip && \
 cd /nut-master/conf && \
 jq --arg v1 $GAMEDIR '.paths.scan = $v1' < nut.default.conf | tee setup.conf && \
 mv setup.conf nut.default.conf && \
 cp /titledb-master/* /nut-master/titledb/ && \
 echo "**** Cleaning up ****" && \
 mkdir -p /app/nut && \
 cp -r /nut-master/* /app/nut && \
 rm -rf \
 /nut-master* \
 /titledb*

EXPOSE 9000
volume config/ data/
