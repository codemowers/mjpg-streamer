FROM alpine:3 as build
RUN apk --no-cache add build-base
RUN apk --no-cache add cmake
RUN apk --no-cache add libjpeg-turbo-dev
RUN apk --no-cache add linux-headers
RUN apk --no-cache add openssl
RUN wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz
WORKDIR /mjpg-streamer-master/mjpg-streamer-experimental
RUN make
RUN make install

FROM alpine:3
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /usr/local/share /usr/local/share
RUN apk --no-cache add libjpeg v4l-utils
EXPOSE 8080
ENTRYPOINT ["mjpg_streamer"]
CMD ["-i", "input_uvc.so", "-o", "output_http.so"]
