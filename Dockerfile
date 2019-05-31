FROM fluent/fluentd:v1.3.3-debian-1.0

USER root

RUN apt-get -y update && apt-get -y install \
        libnss-wrapper \
        ruby-dev \
        gcc \
        make \
        curl

ENV FLUENTD_FORWARDER_HOST=localhost
ENV FLUENTD_FORWARDER_PORT=24224
ENV FLUENTD_FLUSH_INTERVAL=1s

ENV FLUENTD_AGGREG_HOST=setme
ENV FLUENTD_AGGREG_PORT=setme

COPY fluent.conf /fluentd/etc/${FLUENTD_CONF}
COPY sources /fluentd/etc/sources
COPY filters /fluentd/etc/filters
COPY matches /fluentd/etc/matches
RUN chmod 777 -vR /fluentd

COPY entrypoint_nss.sh /usr/bin/
ENTRYPOINT [ "/usr/bin/entrypoint_nss.sh", "/bin/entrypoint.sh" ]
CMD ["fluentd"]
EXPOSE 8080 24224
USER 123456
