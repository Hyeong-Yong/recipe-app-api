FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

# python /py에 가상환경 설치
RUN python -m venv /py && \
    #pip 최신버전으로 업그레이드
    /py/bin/pip install --upgrade pip && \
    #alpine패키지 apk add 명령어를 통해 postgresql-clinent와 jpeg-dev 설치
    apk add --update --no-cache postgresql-client jpeg-dev && \
    #tmp-build-deps(임의의 파일)에 가상환경에 설치하고 다음줄에 해당되는 패키지들 설치 
    apk add --update --no-cache --virtual .tmp-build-deps \
    # 리눅스 툴(build-base, zlib), 커널(linux-headers, musl) 및 DB (postgresql) 관련 의존성 패키지들 설치
    build-base zlib zlib-dev musl-dev linux-headers postgresql-dev && \
    # requirements.txt에 있는 python 패키지 설치
    /py/bin/pip install -r /tmp/requirements.txt && \
    #디버그모드에서 flake8 작동시키기
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    #if 끝나는 지점
    fi && \
    # -r: 하위 디렉토리를 포함하여 모든내용을 삭제, -f: 강제로 삭제 
    rm -rf /tmp && \
    #가상환경 비우기
    apk del .tmp-build-deps && \
    # 리눅스 유저등록 
    adduser \
    #--disabled-password : --disable-login과 비슷하지만, SSH(:12) RSA(:12) 키등을 이용한 로그인은 가능하다.
    --disabled-password \
    #홈 디렉토리를 생성하지않음
    --no-create-home \
    django-user && \
    #-p : 존재하지 않는 중간의 디렉토리를 자동을 생성해 준다.
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    #chown: 소유권을 변경, -R: 경로와 하위 파일들을 모두, 소유권:그룹, 마지막 파일(/vol)  
    chown -R django-user:django-user /vol && \
    #chmod: 파일의 접근 권한을 변경 
    chmod -R 755 /vol && \
    chmod -R +x /scripts

USER django-user

# ENV로 설정한 환경 변수는 RUN, CMD, ENTRYPOINT에 적용됨
ENV PATH="/scripts:/py/bin:$PATH"

# scripts에 있는 run.sh 실행
CMD ["run.sh"] 
