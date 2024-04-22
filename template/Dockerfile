FROM docker4gis/postgrest:v0.0.6

ENV PGDATABASE=postgres
ENV PGRST_DB_SCHEMAS=$DOCKER_USER
ENV PGHOST=$DOCKER_USER-postgis

# Only startup and db connection recovery messages are logged
# ENV PGRST_LOG_LEVEL=crit
# All the "crit" level events plus server errors (status 5xx) are logged
ENV PGRST_LOG_LEVEL=error
# All the "error" level events plus request errors (status 4xx) are logged
# ENV PGRST_LOG_LEVEL=warn
# All the "warn" level events plus all requests (every status code) are logged
# ENV PGRST_LOG_LEVEL=info
# Because currently there’s no buffering for logging, the levels with minimal
# logging(crit/error) will increase throughput.
