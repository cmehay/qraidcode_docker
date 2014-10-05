FROM	debian:wheezy

MAINTAINER Goldy

ADD	apt-no-recommends /etc/apt/apt.conf.d/apt-no-recommends
RUN	apt-get update
RUN	apt-get install nginx php5-fpm qrencode mercurial patch git qrencode poppler-utils
WORKDIR	/var/www/
RUN	mkdir qraidcode
RUN	mkdir bin
RUN	chmod -r www-data:www-data .
USER	www-data

# Clone repositories
RUN	git clone https://github.com/cmehay/qraidcode_php.git qraidcode
RUN	hg clone http://hg.code.sf.net/p/zbar/code bin/zbarimg
RUN	git clone -b "pngcrush" git://git.code.sf.net/p/pmt/code bin/pngcrush

# Build