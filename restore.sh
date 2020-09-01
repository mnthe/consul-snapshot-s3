#!/bin/bash
source ./utils.sh
set -e

function get_full_object_key() {
    if [ -z $SNAPSHOT_KEY ]
    then
        PREFIX=$(echo $PATH_PREFIX | sed "s/^\///") # Remove starting '/' if exists
        SNAPSHOT_KEY=$(
            aws s3api list-objects-v2 \
                --bucket "$S3_BUCKET" \
                --prefix "$PREFIX" \
                --query 'sort_by(Contents, &LastModified)[-1].Key'\
                --output=text
        )
    elif [[ "$SNAPSHOT_KEY" =~ ([0-9]{4}\-[0-9]{2}\-[0-9]{2})_[0-9]{2}\:[0-9]{2}\:[0-9]{2}.snap ]]
    # if SNAPSHOT_KEY like 2020-09-01_05:56:08.snap
    then
        PREFIX=$(echo $PATH_PREFIX | sed "s/^\///" | sed "s/\/$//") # Remove starting, ending '/' if exists
        DATE=${BASH_REMATCH[1]}
        SNAPSHOT_KEY="$PREFIX/$DATE/$SNAPSHOT_KEY"
    fi
    echo "$SNAPSHOT_KEY"
}

function download_consul_snapshot_from_s3() {
    echo "Start download_consul_snapshot_from_s3"
    FULL_KEY=$(get_full_object_key)
    aws s3 cp s3://$S3_BUCKET/$FULL_KEY snapshot
    echo ""
}

function restore_consul_snapshot() {
    echo "Start restore_consul_snapshot"
    echo ""
    echo "Snapshot"
    ENDPOINT=$(consul_endpoint)
    consul snapshot inspect snapshot
    consul snapshot restore -http-addr=$ENDPOINT snapshot
    echo ""
}

function clean_local_files() {
    echo "Start clean_local_files"
    rm snapshot2
    echo ""
}

function main() {
    validate_s3_requirements
    download_consul_snapshot_from_s3
    restore_consul_snapshot
    clean_local_files
}

main $@