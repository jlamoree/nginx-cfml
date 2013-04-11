#!/bin/bash

NGINX_PROJECT=
NGINX_CONF=${1:-_}
NGINX_BIN=/opt/local/sbin/nginx
NGINX_PREFIX=

function usage {
	echo "Usage: `basename $0` configfile"
}

function error {
	echo "Error: $@"
	usage
	echo
	exit 1
}

if [ "_$NGINX_PROJECT" == "_" ]; then
	NGINX_PROJECT=$(cd `dirname $0`; cd ..; pwd -P)
fi

if [ "_$NGINX_CONF" == "_" ]; then
	error "A configuration file required"
fi
NGINX_CONF="$NGINX_PROJECT/$NGINX_CONF"

if [ ! -x "$NGINX_BIN" ]; then
	error "Nginx executable is not valid"
fi

if [ "_$NGINX_PREFIX" == "_" ]; then
	NGINX_PREFIX="$NGINX_PROJECT/common/"
fi

if [ -f "$NGINX_PREFIX/logs/nginx.pid" ]; then
	sudo $NGINX_BIN -p $NGINX_PREFIX -c $NGINX_CONF -s stop
fi
sudo $NGINX_BIN -p $NGINX_PREFIX -c $NGINX_CONF
