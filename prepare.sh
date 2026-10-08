#!/usr/bin/env bash

(cd openssl-build && podman build -t osslcon26-openssl-build:latest .)
podman run \
	-v "$(readlink -f openssl):/work:z" \
	--rm \
	-it \
	osslcon26-openssl-build:latest

(cd crypto-auditing-build && podman build -t osslcon26-crypto-auditing-build:latest .)
podman run \
	-v "$(readlink -f crypto-auditing):/work:z" \
	--rm \
	-it \
	osslcon26-crypto-auditing-build:latest
