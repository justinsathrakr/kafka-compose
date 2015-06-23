#!/bin/bash

: ${KAFKA_REST_ID:=kafka-rest-server-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 7 | head -n 1)}
: ${KAFKA_REST_SCHEMA_REGISTRY_URL:=http://$SCHEMAREGISTRY_PORT_8081_TCP_ADDR:$SCHEMAREGISTRY_PORT_8081_TCP_PORT}
: ${KAFKA_REST_ZOOKEEPER_CONNECT:=$ZOOKEEPER_PORT_2181_TCP_ADDR:$ZOOKEEPER_PORT_2181_TCP_PORT}

export KAFKA_REST_ID
export KAFKA_REST_SCHEMA_REGISTRY_URL
export KAFKA_REST_ZOOKEEPER_CONNECT

echo '# Generated by kafka-rest-docker.sh' > /etc/kafka-rest/kafka-rest.properties

for var in $(env | sort | grep '^KAFKA_REST_'); do
    key=$(echo $var | sed -r 's/KAFKA_REST_(.*)=.*/\1/g' | tr A-Z a-z | tr _ .)
    value=$(echo $var | sed -r 's/.*=(.*)/\1/g')
    echo "${key}=${value}" >> /etc/kafka-rest/kafka-rest.properties
done

exec /usr/bin/kafka-rest-start /etc/kafka-rest/kafka-rest.properties
