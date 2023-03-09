#!/bin/sh

set -e
# envsubst 명령어는 파일 내에 "$VALUE" 형태로 표시된 변수를 환경 변수에서 찾아서 치환해 주는 기능.
# /etc/nginx/default.conf.tpl에 있는 환경변수를 /etc/nginx/conf.d/default.conf로 덮어씌움.
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf


# nginx.conf에 daemon off;를 설정
# Nginx 웹 서버를 foreground로 실행시킴
# nginx 서버를 foreground로 돌리지 않으면 컨테이너를 background로 실행해도 
# 컨테이너 안의 서버가 실행이 안된 상태이기 때문에 컨테이너가 상태가 exited가 된다.
# 도커는 background & nginx 는 foreground로...
# -g : 글로벌 명령 설정, 지정한 global 명령의 설정으로 nginx를 기동 (부하실험등...)
nginx -g 'daemon off;'
