FROM debian:jessie

RUN apt-get update && apt-get install -y \
    nginx

ADD nginx.conf /etc/nginx/
ADD flex-spa.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/flex-spa.conf /etc/nginx/sites-enabled/flex-spa
RUN rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server backend_web:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
