FROM alpine:3.20.1
# Замена дефолтной конфигурации nginx, отдающую всегда "404"
COPY default.conf /etc/nginx/http.d/
# Страница приветствия сайта
COPY index.html /var/www/default/html/
# Установка
RUN apk add nginx
# Запуск nginx не в режиме демона, чтоб не было Exit(0)
CMD ["nginx", "-g", "daemon off;"]
