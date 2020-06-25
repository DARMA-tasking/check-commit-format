FROM alpine/git:v2.24.1

RUN apk add bash

COPY check-commits.sh .
ENTRYPOINT ["./check-commits.sh"]
