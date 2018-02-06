#
# Dockerfile for nginx php sqlite
#

FROM easypi/alpine-arm
MAINTAINER codeideal <kanniu@163.com>

# 安装包源切到中科大, 国内访问加速
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \

# 设置默认时区为亚洲/上海 (没有北京可选)
	apk add --no-cache tzdata && \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	apk del tzdata
	
# 安装typecho环境
RUN	apk add --no-cache nginx sqlite php5-fpm php5-pdo_sqlite php5-ctype php5-iconv php5-xmlrpc php5-mcrypt php5-sockets php5-curl && \
	rm -rf /var/cache/apk/*

ADD ./nginx.conf /app/
ADD ./nginx.ssl.conf /app/
ADD ./php-fpm.conf /app/
ADD ./run.sh /app/
RUN cp /app/nginx.conf /etc/nginx/ && \
	cp /app/php-fpm.conf /etc/php5/ && \
	chmod +x /app/run.sh

EXPOSE 80
EXPOSE 443
VOLUME ["/data"]

CMD ["/app/run.sh"]