FROM	maxexcloo/nginx-php:latest

MAINTAINER Goldy

ENV	LD_LIBRARY_PATH /usr/local/lib
ADD	apt-no-recommends /etc/apt/apt.conf.d/10-no-recommends
ADD	backport.list /etc/apt/sources.list.d/backport.list
RUN	apt-get update && apt-get -y dist-upgrade
RUN	apt-get install -y qrencode mercurial patch git qrencode poppler-utils pngcrush php5-mcrypt php5-imagick php5-gd supervisor ghostscript graphicsmagick-imagemagick-compat ca-certificates emacs23-nox

# Build zbarimg
WORKDIR /root
RUN	hg clone http://hg.code.sf.net/p/zbar/code zbarimg
ADD	qrdectxt.c.patch /root/qrdectxt.c.patch
RUN	patch zbarimg/zbar/qrcode/qrdectxt.c < qrdectxt.c.patch
WORKDIR zbarimg
RUN	apt-get install -y build-essential libmagick++-dev gettext libtool autoconf automake
RUN	autoreconf --install
RUN	./configure --with-x=no --with-jpeg=no --enable-video=no --with-python=no --with-gtk=no --with-qt=no
RUN	make && make install-exec

# Conf nginx
RUN    /bin/sed -i 's/\/data\/http/\/var\/www\/qraidcode\/public/g' /etc/nginx/host.d/default.conf

WORKDIR	/var/www/
RUN	mkdir qraidcode
RUN	chown -R www-data:www-data .
RUN	chown -R www-data:www-data /var/lib/php5
USER	www-data

# Clone repository
RUN	git clone https://github.com/cmehay/qraidcode_php.git qraidcode
RUN	rm -rf qraidcode/.git

# Install tFPDF
RUN	git clone https://github.com/rev42/tfpdf.git tfpdf

# Switch to user root for initialisation
USER	root
