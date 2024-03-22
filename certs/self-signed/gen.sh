#!/bin/bash

set -eo pipefail

usage() {
    echo "Usage: $(basename $0) <cn> [-a <subjectAltNames>] [-u <extendedKeyUsage>]"
}

if [ -z "$1" -o "${1:0:1}" = "-" ] ; then
    usage
    exit 1
fi
CN=$1
shift

while getopts 'a:u:h' opt; do
    case "$opt" in
    a)
        a=$OPTARG
        ;;
    u)
        u=$OPTARG
        ;;
    h)
        usage
        exit 0
        ;;
    :)
        usage
        exit 1
        ;;
    ?)
        usage
        exit 1
        ;;
    esac
done

if [ -n "$a" -a -n "$u" ] ; then
    openssl req -x509 -newkey rsa:4096 -sha256 -days 10950 \
                -nodes -keyout $CN.key -out $CN.crt -subj "/CN=$CN" \
                -addext "subjectAltName=$a" \
                -addext "extendedKeyUsage=$u"
elif [ -n "$a" ] ; then
    openssl req -x509 -newkey rsa:4096 -sha256 -days 10950 \
                -nodes -keyout $CN.key -out $CN.crt -subj "/CN=$CN" \
                -addext "subjectAltName=$a"
elif [ -n "$u" ] ; then
    openssl req -x509 -newkey rsa:4096 -sha256 -days 10950 \
                -nodes -keyout $CN.key -out $CN.crt -subj "/CN=$CN" \
                -addext "extendedKeyUsage=$u"
else
    openssl req -x509 -newkey rsa:4096 -sha256 -days 10950 \
                -nodes -keyout $CN.key -out $CN.crt -subj "/CN=$CN"
fi
