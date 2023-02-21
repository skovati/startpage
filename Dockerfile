from docker.io/alpine:latest as minifier

workdir /public

copy index.html style.css .

run apk update && apk add --no-cache minify

run echo "size before minify:" && \
    stat -c "%n %s" index.html style.css

run minify -o min/ *

run echo "size after minify:" && \
    stat -c "%n %s" min/index.html min/style.css

from docker.io/nginx:alpine-slim

copy --from=minifier /public/min/* /var/www/start.skovati.dev/
copy nginx.conf /etc/nginx
