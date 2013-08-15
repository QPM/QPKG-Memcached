#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="memcached"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
WEB_SHARENAME=$(/sbin/getcfg SHARE_DEF defWeb -d Web -f /etc/config/def_share.info)
WEB_PATH=$(/sbin/getcfg $WEB_SHARENAME path -f /etc/config/smb.conf)
BIN_PATH=/bin

case "$1" in
  start)
    chmod -R 755 $QPKG_DIR/bin
    chmod -R 755 $QPKG_DIR/phpmem

    LD_LIBRARY_PATH=$QPKG_DIR/bin /usr/sbin/screen -dmS 'Memcached' $QPKG_DIR/bin/memcached -u admin

    cp -rf $QPKG_DIR/phpmem $WEB_PATH/phpmem

    : ADD START ACTIONS HERE
    ;;

  stop)
    rm -rf $WEB_PATH/phpmem

    kill `ps|grep 'Memcached'|grep 'grep' -v|awk '{print$1}'`

    : ADD STOP ACTIONS HERE
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
