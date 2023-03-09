FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="HY.com"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./uwsgi_params /etc/nginx/uwsgi_params
COPY ./run.sh /run.sh
# default.conf.tpl에 설정됨. 8000번 포트를 통해 외부 클라이언트(web)로부터 들어오는 요청을 해당 블록의 내용에 맞게 처리함.
ENV LISTEN_PORT=8000 
# uwsgi의 호스트 이름: app 
ENV APP_HOST=app
# uwsgi와 9000번 포트로 통신함
ENV APP_PORT=9000 

USER root

RUN mkdir -p /vol/static && \
    chmod 755 /vol/static && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    chmod +x /run.sh

VOLUME /vol/static

USER nginx

CMD ["/run.sh"]