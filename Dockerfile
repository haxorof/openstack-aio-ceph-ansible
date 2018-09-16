FROM ubuntu:xenial

ENV VENVS "default"
ENV HOME "/root"

COPY docker/docker-entrypoint.sh /bin/docker-entrypoint.sh
COPY hosts /etc/ansible/hosts
COPY scripts/setup_venvs.sh /root/

RUN chmod +x /bin/docker-entrypoint.sh && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install openssh-client python-pip vim && \
    apt-get clean all

RUN /root/setup_venvs.sh

WORKDIR /root

ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["/bin/bash"]
