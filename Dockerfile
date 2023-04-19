FROM rundeck/rundeck:4.11.0
LABEL maintainer="Salvoxia <salvoxia@blindfish.info>"

# copy the custom entrypoint
COPY --chown=rundeck:root lib docker-lib

# launch custom entrypoint
ENTRYPOINT [ "/tini", "--", "docker-lib/custom-entry.sh" ]
