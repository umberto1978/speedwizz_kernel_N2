#!/sbin/busybox sh
# Logging
/sbin/busybox cp /data/user.log /data/user.log.bak
/sbin/busybox rm /data/user.log
exec >>/data/user.log
exec 2>&1

echo $(date) START of post-init.sh

# Remount rootfs rw
  /sbin/busybox mount rootfs -o remount,rw

# IPv6 privacy tweak
#if /sbin/busybox [ "`/sbin/busybox grep IPV6PRIVACY /system/etc/tweaks.conf`" ]; then
  echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr
#fi

# Remount all partitions with noatime
  for k in $(/sbin/busybox mount | /sbin/busybox grep relatime | /sbin/busybox cut -d " " -f3)
  do
        sync
        /sbin/busybox mount -o remount,noatime $k
  done

# Remount ext4 partitions with optimizations
  for k in $(/sbin/busybox mount | /sbin/busybox grep ext4 | /sbin/busybox cut -d " " -f3)
  do
        sync
        /sbin/busybox mount -o remount,commit=15 $k
  done

# Speedwizz Tweaks
/sbin/busybox sh /sbin/speedwizz_tweaks.sh

#disable cpuidle log
echo 0 > /sys/module/cpuidle_exynos4/parameters/log_en
  
# pegasusq tweaks
echo 20000 > /sys/devices/system/cpu/cpufreq/pegasusq/sampling_rate
echo 20 > /sys/devices/system/cpu/cpufreq/pegasusq/cpu_up_rate
echo 40 > /sys/devices/system/cpu/cpufreq/pegasusq/cpu_down_rate
echo 500000 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_freq_1_1
echo 200000 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_freq_2_0
echo 600000 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_freq_2_1
echo 300000 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_freq_3_0
echo 700000 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_freq_3_1
echo 400000 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_freq_4_0
echo 150 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_rq_1_1
echo 150 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_rq_2_0
echo 300 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_rq_2_1
echo 300 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_rq_3_0
echo 400 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_rq_3_1
echo 400 > /sys/devices/system/cpu/cpufreq/pegasusq/hotplug_rq_4_0
echo 2 > /sys/devices/system/cpu/cpufreq/pegasusq/sampling_down_factor
echo 37 > /sys/devices/system/cpu/cpufreq/pegasusq/freq_step

# Turn off debugging for certain modules
  echo "0" > /sys/module/wakelock/parameters/debug_mask
  echo "0" > /sys/module/userwakelock/parameters/debug_mask
  echo "0" > /sys/module/earlysuspend/parameters/debug_mask
  echo "0" > /sys/module/alarm/parameters/debug_mask
  echo "0" > /sys/module/alarm_dev/parameters/debug_mask
  echo "0" > /sys/module/binder/parameters/debug_mask

  echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
  echo "0" > /sys/module/mali/parameters/mali_debug_level
  echo "0" > /sys/module/ump/parameters/ump_debug_level

/sbin/busybox mount -o noatime,remount,rw,discard,barrier=0,commit=60,noauto_da_alloc,delalloc /cache /cache;
/sbin/busybox mount -o noatime,remount,rw,discard,barrier=0,commit=60,noauto_da_alloc,delalloc /data /data;

# Install Boeffla Sound
if [ -f /system/app/*near.boefflasound* ] || [ -f /data/app/*near.boefflasound* ];
then
	echo "Boeffla sound already exists"
else
	echo "Copying Boeffla sound"
	/sbin/busybox mount /system -o remount,rw
	/sbin/busybox cp /res/misc/com.near.boefflasound-1.apk /system/app/com.near.boefflasound-1.apk
	/sbin/busybox chown 0.0 /system/app/com.near.boefflasound-1.apk
	/sbin/busybox chmod 644 /system/app/com.near.boefflasound-1.apk
fi

# Install Script manager application
if [ -f /system/app/*SpeedWizz_Manager* ] || [ -f /data/app/*SpeedWizz_Manager* ];
then
	echo "SpeedWizz_Manager already exists"
else
	echo "Copying SpeedWizz_Manager"
	/sbin/busybox mount /system -o remount,rw
	/sbin/busybox cp /res/misc/SpeedWizz_Manager.apk /system/app/SpeedWizz_Manager.apk
	/sbin/busybox chown 0.0 /system/app/SpeedWizz_Manager.apk
	/sbin/busybox chmod 644 /system/app/SpeedWizz_Manager.apk
fi

/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

##### Root section #####
if [ ! -e /storage/sdcard0/noroot ]; then
        
        if [ -f /system/app/Superuser.apk ]; then
	echo "Superuser.apk already exists"
        else
	echo "Copying Superuser.apk"
	/sbin/busybox mount /system -o remount,rw
	/sbin/busybox rm /system/app/Superuser.apk
	/sbin/busybox rm /data/app/Superuser.apk
	/sbin/busybox cp /res/misc/Superuser.apk /system/app/Superuser.apk
	/sbin/busybox chown 0.0 /system/app/Superuser.apk
	/sbin/busybox chmod 644 /system/app/Superuser.apk

	echo "Copying su binary"
	/sbin/busybox rm /system/bin/su
	/sbin/busybox rm /system/xbin/su
	/sbin/busybox cp /res/misc/su /system/xbin/su
	/sbin/busybox chown 0.0 /system/xbin/su
	/sbin/busybox chmod 6755 /system/xbin/su
	/sbin/busybox mount /system -o remount,ro
        fi
else
        /sbin/busybox mount /system -o remount,rw
	/sbin/busybox rm -f /system/app/*uper?ser.apk 
	/sbin/busybox rm -f /system/app/?uper?u.apk 
	/sbin/busybox rm -f /system/app/*chainfire?supersu*.apk 
	/sbin/busybox rm -f /data/app/*uper?ser.apk 
	/sbin/busybox rm -f /data/app/?uper?u.apk
	/sbin/busybox rm -f /data/app/*chainfire?supersu*.apk 
	/sbin/busybox rm -rf /data/dalvik-cache/*uper?ser.apk* 
	/sbin/busybox rm -rf /data/dalvik-cache/*chainfire?supersu*.apk*	
	/sbin/busybox rm /system/bin/su
	/sbin/busybox rm /system/xbin/su
        /sbin/busybox mount /system -o remount,ro
fi

if [ ! -f /system/xbin/busybox ]; then
/sbin/busybox mount /system -o remount,rw
cp /sbin/busybox /system/xbin/busybox
chown 0.0 /system/xbin/busybox
chmod 0755 /system/xbin/busybox
ln -s /sbin/busybox /system/xbin/pkill
/sbin/busybox mount /system -o remount,ro
fi
# End of auto-root section

# Zero dumpstate files
cat /dev/null > /data/log/dumpstate_app_error.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_app_native.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_sys_watchdog.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_app_anr.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_app_error.txt.gz

# Change permissions to read-only for key dumpstate files
chmod 400 /data/log/dumpstate_app_error.txt.gz.tmp
chmod 400 /data/log/dumpstate_app_native.txt.gz.tmp
chmod 400 /data/log/dumpstate_sys_watchdog.txt.gz.tmp
chmod 400 /data/log/dumpstate_app_anr.txt.gz.tmp
chmod 400 /data/log/dumpstate_app_error.txt.gz

# End of dumpstate cleanup

echo $(date) PRE-INIT DONE of post-init.sh
##### Post-init phase #####
sleep 12

# Cleanup busybox
  #/sbin/busybox rm /sbin/busybox
  #/sbin/busybox mount rootfs -o remount,ro


# init.d support
if [ -d /system/etc/init.d ]; then
        /sbin/busybox mount -o remount,rw /system;
        /sbin/busybox chmod -R 755 /system/etc/init.d;
	/sbin/busybox mount -o remount,ro /system;
else
	/sbin/busybox mount -o remount,rw /system;	
        /sbin/busybox mkdir /system/etc/init.d;
	/sbin/busybox chmod -R 755 /system/etc/init.d;
	/sbin/busybox mount -o remount,ro /system;
fi;

# install zipallign files

echo "Checking if zipallign files are installed"
if [ -f /system/.speedwizz/zipallign_installed ]; then
          echo "ZipAllign files already in"
else
	  /sbin/busybox mount -o remount,rw /system;
          /sbin/busybox cp /res/misc/S70zipalign /system/etc/init.d/S70zipalign;
	  /sbin/busybox chmod -R 755 /system/etc/init.d;
	  /sbin/busybox cp /res/misc/zipalign /system/xbin/zipalign;
	  /sbin/busybox chmod -R 755 /system/xbin/zipalign;
	  /sbin/busybox mkdir /system/.speedwizz;
	  /sbin/busybox chmod 755 /system/.speedwizz;
	  echo 1 > /system/.speedwizz/zipallign_installed
	  /sbin/busybox mount -o remount,ro /system;
fi;

##### init scripts #####
/sbin/busybox sh /sbin/run-init-scripts.sh

echo $(date) END of post-init.sh
