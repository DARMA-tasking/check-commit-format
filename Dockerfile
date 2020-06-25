FROM alpine/git:v2.24.1

RUN apk add bash

COPY . /action
ENTRYPOINT ["/action/entrypoint.sh"]
