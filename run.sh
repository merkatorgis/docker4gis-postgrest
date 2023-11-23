#!/bin/bash
set -e

IMAGE=$IMAGE
CONTAINER=$CONTAINER
DOCKER_ENV=$DOCKER_ENV
RESTART=$RESTART
NETWORK=$NETWORK
FILEPORT=$FILEPORT
VOLUME=$VOLUME

PGRST_JWT_SECRET=$(docker container exec "$DOCKER_USER-postgis" pg.sh force -Atc "select current_setting('app.jwt_secret')")

proxy=$PROXY_HOST
[ "$PROXY_PORT" ] && proxy=$proxy:$PROXY_PORT
PGRST_OPENAPI_SERVER_PROXY_URI=${PGRST_OPENAPI_SERVER_PROXY_URI:-https://$proxy/$DOCKER_USER/api}

docker container run --restart "$RESTART" --name "$CONTAINER" \
	-e DOCKER_ENV="$DOCKER_ENV" \
	--mount type=bind,source="$FILEPORT",target=/fileport \
	--mount source="$VOLUME",target=/volume \
	--network "$NETWORK" \
	-e PGRST_DB_URI="postgresql://web_authenticator:postgrest@$DOCKER_USER-postgis/$POSTGRES_DB" \
	-e PGRST_DB_SCHEMA="$PGRST_DB_SCHEMA" \
	-e PGRST_JWT_SECRET="$PGRST_JWT_SECRET" \
	-e PGRST_PRE_REQUEST="public.pre_request" \
	-e PGRST_DB_ANON_ROLE="web_anon" \
	-e PGRST_OPENAPI_SERVER_PROXY_URI="$PGRST_OPENAPI_SERVER_PROXY_URI" \
	-e PGRST_SERVER_PORT="8080" \
	-d "$IMAGE" postgrest "$@"
