#!/usr/bin/env bash
####################
set -e
####################
readonly IMG_NAME=bitcoin101
readonly CT_NAME=bitcoin101
####################
case ${1} in
	build) 
		podman build \
		-f Containerfile \
		--tag="${IMG_NAME}" \
		.
	;;
	up) 
		podman run --rm \
			-p=4000:4000 \
			-v="$(pwd):/site" \
			--name="${CT_NAME}" \
			"localhost/${IMG_NAME}" &
		;;
	down) 
		podman stop "${CT_NAME}" || true
	;;
	reload)
		podman exec "${CT_NAME}" bash -c "echo 1 >> dummy"
	;;
	*) printf "usage: [ build | up | down ]\n" ;;
esac
