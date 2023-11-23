FROM postgrest/postgrest:v7.0.1

ENV PGRST_DB_POOL=100 \
    PGRST_DB_EXTRA_SEARCH_PATH=public \
    PGRST_SERVER_HOST=*4 \
    PGRST_SECRET_IS_BASE64=false \
    PGRST_JWT_AUD= \
    PGRST_MAX_ROWS= \
    PGRST_ROLE_CLAIM_KEY=".role" \
    PGRST_ROOT_SPEC= \
    PGRST_RAW_MEDIA_TYPES=

# Allow configuration before things start up.
COPY conf/entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["postgrest"]

# Example plugin use.
# COPY conf/.plugins/bats /tmp/bats
# RUN /tmp/bats/install.sh

# This may come in handy.
ONBUILD ARG DOCKER_USER
ONBUILD ENV DOCKER_USER=$DOCKER_USER

# Extension template, as required by `dg component`.
COPY template /template/
# Make this an extensible base component; see
# https://github.com/merkatorgis/docker4gis/tree/npm-package/docs#extending-base-components.
COPY conf/.docker4gis /.docker4gis
COPY build.sh /.docker4gis/build.sh
COPY run.sh /.docker4gis/run.sh
ONBUILD COPY conf /tmp/conf
ONBUILD RUN touch /tmp/conf/args
ONBUILD RUN cp /tmp/conf/args /.docker4gis
