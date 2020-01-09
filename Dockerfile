FROM ubuntu as builder

ARG NETHACK_TAR=nethack4-4.3-beta2.tar.gz

COPY ${NETHACK_TAR} /

RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
RUN apt update
RUN apt-get build-dep -y nethack
RUN apt install -y zlib1g-dev
RUN useradd nethack -m

RUN tar xf nethack4-4.3-beta2.tar.gz && \
    mkdir nethack4-4.3-beta2/build && \
    chown -R nethack:nethack nethack4-4.3-beta2 && \
    chown nethack:nethack /opt

WORKDIR nethack4-4.3-beta2/build
USER nethack
RUN ../aimake -i /opt/ --without=gui || true # This always fails, so ignore

FROM ubuntu

COPY --from=builder /opt /opt
RUN useradd nethack -m

USER nethack
WORKDIR /home/nethack
ENTRYPOINT ["/opt/nethack4"]
