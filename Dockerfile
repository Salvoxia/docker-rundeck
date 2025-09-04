FROM rundeck/rundeck:5.15.0
LABEL maintainer="Salvoxia <salvoxia@blindfish.info>"

# Prevent Timezone prompt when installing python
ARG DEBIAN_FRONTEND=noninteractive \
    PYVER=3.12
RUN sudo apt -y update \
  && sudo apt -y --no-install-recommends install tzdata ca-certificates sshpass zip unzip software-properties-common \
  # Install python with pip
  && sudo add-apt-repository -y ppa:deadsnakes/ppa \
  && sudo apt install -y python$PYVER-full \
  && wget https://bootstrap.pypa.io/get-pip.py \
  && sudo python$PYVER get-pip.py \
  # https://pypi.org/project/ansible/#history
  && sudo -H pip$PYVER --no-cache-dir install ansible \
  && sudo -H pip$PYVER --no-cache-dir install jmespath \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo mkdir /etc/ansible

# copy the custom entrypoint
COPY --chown=rundeck:root lib docker-lib

HEALTHCHECK --interval=30s --retries=3 --timeout=5s --start-period=120s CMD curl --fail http://localhost:4440 || exit 1

# launch custom entrypoint
ENTRYPOINT [ "/tini", "--", "docker-lib/custom-entry.sh" ]
