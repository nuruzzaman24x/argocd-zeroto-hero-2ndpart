# FROM alpine:latest
# RUN apk add --no-cache bash curl
# workdir /devops-bangla
# COPY app-success-rate.sh .

FROM alpine:latest

RUN apk add --no-cache bash curl

WORKDIR /devops-bangla

COPY app-success-rate.sh .

RUN chmod +x app-success-rate.sh