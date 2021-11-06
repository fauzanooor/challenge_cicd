FROM nginx

RUN \
  sed -i 's/usr\/share\/nginx\/html/var\/www/g' /etc/nginx/conf.d/default.conf && \
  sed -i '6i autoindex on;' /etc/nginx/conf.d/default.conf && \
  mkdir /var/www

COPY hello.txt /var/www
WORKDIR /var/www

EXPOSE 80
EXPOSE 443