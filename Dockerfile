FROM php:5.6-fpm
COPY sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y git zlibc zlib1g-dev zlib1g libmemcached-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libicu-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd zip mbstring mysqli pdo pdo_mysql intl
RUN apt-get install -y libfontconfig fontconfig
COPY phantomjs /usr/local/bin/phantomjs
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt-get install -y ttf-mscorefonts-installer fondu
COPY Fonts /tmp/macfonts
RUN cd /tmp/macfonts && fondu -f *.dfont && mkdir -p /usr/share/fonts/truetype/macfonts/ && mv *.ttf /usr/share/fonts/truetype/macfonts/ && fc-cache -fv && rm -rf /tmp/macfonts