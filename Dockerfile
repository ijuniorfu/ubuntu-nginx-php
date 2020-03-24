FROM ijuniorfu/ubuntu-base as staging

RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.4-cli php7.4-dev

ADD mcrypt-1.0.3.tgz /tmp
WORKDIR /tmp/mcrypt-1.0.3
RUN phpize  &&  ./configure &&  make  && make install

ADD swoole-4.4.16.tgz /tmp
WORKDIR /tmp/swoole-4.4.16
RUN phpize  &&  ./configure &&  make  && make install

FROM ijuniorfu/ubuntu-base

MAINTAINER junior <ijuniorfu@gmail.com>

RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y mcrypt libmcrypt-dev php7.4-fpm php7.4-cli php7.4-readline php7.4-mbstring php7.4-zip php7.4-intl php7.4-json php7.4-xml php7.4-curl php7.4-gd php7.4-pdo php7.4-mysql php-imagick php-redis php-mongodb php-memcache \
    && apt-get install -y nginx

COPY --from=staging /usr/lib/php/20190902/mcrypt.so /usr/lib/php/20190902/mcrypt.so
RUN touch /etc/php/7.4/mods-available/mcrypt.ini \
&& echo "extension=mcrypt.so" >> /etc/php/7.4/mods-available/mcrypt.ini \
&& ln -s /etc/php/7.4/mods-available/mcrypt.ini /etc/php/7.4/cli/conf.d/20-mcrypt.ini \
&& ln -s /etc/php/7.4/mods-available/mcrypt.ini /etc/php/7.4/fpm/conf.d/20-mcrypt.ini


COPY --from=staging /usr/lib/php/20190902/swoole.so /usr/lib/php/20190902/swoole.so
RUN touch /etc/php/7.4/mods-available/swoole.ini \
&& echo "extension=swoole.so" >> /etc/php/7.4/mods-available/swoole.ini \
&& ln -s /etc/php/7.4/mods-available/swoole.ini /etc/php/7.4/cli/conf.d/20-swoole.ini \
&& ln -s /etc/php/7.4/mods-available/swoole.ini /etc/php/7.4/fpm/conf.d/20-swoole.ini