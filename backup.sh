#!/bin/bash
source ./utils.sh
set -e

function backup_consul_snapshot() {
    echo "Start backup_consul_snapshot"
    ENDPOINT=$(consul_endpoint)
    consul snapshot save -http-addr=$ENDPOINT snapshot
    echo ""
}

function upload_snapshot_to_s3() {
    echo "Start backup_consul_snapshot"
    DATE=$(date -u +%Y-%m-%d)
    TIME=$(date -u +%H:%M:%S)
    UPLOAD_PATH="s3:/$(realpath -m //$S3_BUCKET/$PATH_PREFIX/$DATE/$DATE\_$TIME.snap)"
    aws s3 cp ./snapshot $UPLOAD_PATH | indent
    echo ""
}

function clean_local_files() {
    echo "Start clean_local_files"
    rm snapshot
    echo ""
}

function main() {
    validate_s3_requirements
    backup_consul_snapshot
    upload_snapshot_to_s3
    clean_local_files
}

main $@