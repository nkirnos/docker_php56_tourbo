FROM php:5.6-fpm
COPY sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y git zlibc zlib1g-dev zlib1g libmemcached-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libicu-dev pkg-config openssl libssl-dev libfontconfig fontconfig ttf-mscorefonts-installer fondu\
    && pecl install memcached\
    && docker-php-ext-enable memcached\
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd zip mbstring mysqli pdo pdo_mysql intl
COPY phantomjs /usr/local/bin/phantomjs
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
COPY Fonts /tmp/macfonts
RUN cd /tmp/macfonts && fondu -f *.dfont && mkdir -p /usr/share/fonts/truetype/macfonts/ && mv *.ttf /usr/share/fonts/truetype/macfonts/ && /usr/bin/fc-cache -fv && rm -rf /tmp/macfonts
COPY php.ini-production /usr/local/etc/php/php.ini
RUN \
    sed -i 's/max_input_time = 30/max_input_time = 60/g' /usr/local/etc/php/php.ini && \
    sed -i 's/max_execution_time = 30/max_execution_time = 60/g' /usr/local/etc/php/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /usr/local/etc/php/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /usr/local/etc/php/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /usr/local/etc/php/php.ini
    
