#!/sbin/busybox sh

# Nazar.78 custom boot animation support script injection

if [ ! -e /system/bin/samsungani.Nazar78 ];
then
	/sbin/busybox mount /system -oremount,rw
	/sbin/busybox mv -f /system/bin/samsungani /system/bin/samsungani.Nazar78
	/sbin/busybox cp /res/misc/samsungani.Nazar78 /system/bin/samsungani
	/sbin/busybox chown 0.2000 /system/bin/samsungani
	/sbin/busybox chmod 755 /system/bin/samsungani
	/sbin/busybox mount /system -oremount,ro
fi
