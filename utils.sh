#!/bin/bash

function consul_endpoint() {
    if [ -z $CONSUL_HTTP_ENDPOINT ]
    then
        if [ -z $CONSUL_SCHEME ]
        then
            CONSUL_SCHEME="http"
        fi

        if [ -z $CONSUL_HOST ]
        then
            CONSUL_HOST="127.0.0.1"
        fi

        if [ -z $CONSUL_PORT ]
        then
            CONSUL_PORT="8500"
        fi
        CONSUL_HTTP_ENDPOINT="$CONSUL_SCHEME://$CONSUL_HOST:$CONSUL_PORT"
    fi
    echo "$CONSUL_HTTP_ENDPOINT"
}

function validate_s3_requirements() {
    if [ -z $S3_BUCKET ]
    then
        echo "Error: S3_BUCKET is unset. Please provide S3_BUCKET via environment variable."
        exit 1
    fi
    if [ -z $S3_REGION ]
    then
        echo "Error: S3_REGION is unset. Please provide S3_REGION via environment variable."
        exit 1
    fi
}

indent() { sed 's/^/    /'; }
