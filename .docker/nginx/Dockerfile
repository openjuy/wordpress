FROM nginx:1.21.6-alpine
RUN apk --no-cache add shadow && \
    usermod -u 1100 nginx && \
    groupmod -g 1100 nginx
