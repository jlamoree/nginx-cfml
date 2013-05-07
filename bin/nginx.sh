#!/bin/bash 

NGINX_PROJECT=
NGINX_CONF=${1:-_}
NGINX_BIN=/usr/sbin/nginx
NGINX_PREFIX=
NGINX_PID=

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

if [ "$NGINX_CONF" == "_" -o ! -f "$NGINX_CONF" ]; then
  error "A configuration file required"
fi
NGINX_CONF="$NGINX_PROJECT/$NGINX_CONF"

if [ ! -x "$NGINX_BIN" ]; then
  error "Nginx executable is not valid"
fi

if [ "_$NGINX_PREFIX" == "_" ]; then
  NGINX_PREFIX="$NGINX_PROJECT/common/"
fi

sudo $NGINX_BIN -p $NGINX_PREFIX -c $NGINX_CONF -t
if [ $? != 0 ]; then
  exit 1
fi

if [ -f "${NGINX_PREFIX}logs/nginx.pid" ]; then
  NGINX_PID=`cat "${NGINX_PREFIX}logs/nginx.pid"`
  sudo kill -s 0 $NGINX_PID 2>&1 > /dev/null
  if [ $? == 0 ]; then
    sudo $NGINX_BIN -p $NGINX_PREFIX -c $NGINX_CONF -s stop
  fi
fi
sudo $NGINX_BIN -p $NGINX_PREFIX -c $NGINX_CONF
