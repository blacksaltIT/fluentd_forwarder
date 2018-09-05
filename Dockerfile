FROM fluent/fluentd:v1.1.3-debian

RUN apt-get -y update && apt-get -y install \
        libnss-wrapper \
        ruby-dev \
        gcc \
        make \
        curl
RUN gem install fluent-plugin-http-heartbeat:0.0.5

ENV FLUENTD_FORWARDER_HOST=localhost
ENV FLUENTD_FORWARDER_PORT=24224
ENV HEARTBEAT_HOST=localhost
ENV HEARTBEAT_PORT=24280

ENV FLUENTD_AGGREG_HOST=setme
ENV FLUENTD_AGGREG_PORT=setme

COPY fluent.conf /fluentd/etc/${FLUENTD_CONF}
COPY sources /fluentd/etc/sources
COPY filters /fluentd/etc/filters
COPY matches /fluentd/etc/matches
RUN chmod 777 -vR /fluentd

COPY entrypoint_nss.sh /usr/bin/
ENTRYPOINT [ "/usr/bin/entrypoint_nss.sh" ]
CMD [ "/bin/sh", "-c", "exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT" ]
EXPOSE 8080 24224
USER 123456
