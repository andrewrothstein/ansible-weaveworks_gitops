#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/weaveworks/weave-gitops/releases/download

# https://github.com/weaveworks/weave-gitops/releases/download/v0.3.0/gitops-linux-x86_64

dl() {
    local ver=$1
    local app=$2
    local lchecksums=$3
    local os=$4
    local arch=$5
    local archive_type=${6:-tar.gz}
    local platform="${os}-${arch}"
    local file="${app}-${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local app=$2
    # https://github.com/weaveworks/weave-gitops/releases/download/v0.6.0/gitops_checksums.txt
    local url="$MIRROR/v$ver/${app}_checksums.txt"
    local lchecksums="$DIR/${app}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $app $lchecksums darwin arm64
    dl $ver $app $lchecksums darwin x86_64
    dl $ver $app $lchecksums linux arm64
    dl $ver $app $lchecksums linux arm
    dl $ver $app $lchecksums linux x86_64
}

dl_ver ${1:-0.13.0} gitops
