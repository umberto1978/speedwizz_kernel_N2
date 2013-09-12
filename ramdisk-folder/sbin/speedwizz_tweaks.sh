#!/sbin/busybox sh
# thanks to hardcore and nexxx
# thanks to knzo, gokhanmoral, pikachu01
# thanks to dorimanx
# thanks to simone201 

# VM Tweaks (thx to dorimanx)
  /sbin/busybox sysctl -w vm.vfs_cache_pressure=70
  echo "12288" > /proc/sys/vm/min_free_kbytes;
  echo "1500" > /proc/sys/vm/dirty_writeback_centisecs;
  echo "200" > /proc/sys/vm/dirty_expire_centisecs;
  echo "70" > /proc/sys/vm/dirty_background_ratio;
  echo "90" > /proc/sys/vm/dirty_ratio;
  echo "4" > /proc/sys/vm/min_free_order_shift;
  echo "1" > /proc/sys/vm/overcommit_memory;
  echo "50" > /proc/sys/vm/overcommit_ratio;
  echo "128 128" > /proc/sys/vm/lowmem_reserve_ratio;
  echo "3" > /proc/sys/vm/page-cluster;
  echo "4096" > /proc/sys/vm/min_free_kbytes;
  echo "0" > /proc/sys/vm/swappiness;

# SD cards (mmcblk) read ahead tweaks
  echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "1024" > /sys/devices/virtual/bdi/179:16/read_ahead_kb
  echo "512" > /sys/devices/virtual/bdi/default/read_ahead_kb
  echo "256" > /sys/block/mmcblk0/bdi/read_ahead_kb
  echo "256" > /sys/block/mmcblk1/bdi/read_ahead_kb

# TCP tweaks (thx to dorimanx)
  echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
  echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;
  echo "1" > /proc/sys/net/ipv4/tcp_sack;
  echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
  echo "1" > /proc/sys/net/ipv4/tcp_window_scaling;
  echo "1" > /proc/sys/net/ipv4/tcp_moderate_rcvbuf;
  echo "1" > /proc/sys/net/ipv4/route/flush;
  echo "2" > /proc/sys/net/ipv4/tcp_syn_retries;
  echo "2" > /proc/sys/net/ipv4/tcp_synack_retries;
  echo "10" > /proc/sys/net/ipv4/tcp_fin_timeout;
  echo "0" > /proc/sys/net/ipv4/tcp_ecn;
  echo "524288" > /proc/sys/net/core/wmem_max;
  echo "524288" > /proc/sys/net/core/rmem_max;
  echo "262144" > /proc/sys/net/core/rmem_default;
  echo "262144" > /proc/sys/net/core/wmem_default;
  echo "20480" > /proc/sys/net/core/optmem_max;
  echo "6144 87380 524288" > /proc/sys/net/ipv4/tcp_wmem;
  echo "6144 87380 524288" > /proc/sys/net/ipv4/tcp_rmem;
  echo "4096" > /proc/sys/net/ipv4/udp_rmem_min;
  echo "4096" > /proc/sys/net/ipv4/udp_wmem_min;

# New scheduler tweaks + readahead tweaks (thx to Pikachu01 && dorimanx)
for i in $MMC;
do
	if [ -e $i/queue/rotational ]; then
		echo "0" > $i/queue/rotational; 
	fi;
	if [ -e $i/queue/nr_requests ]; then
		echo "8192" > $i/queue/nr_requests;
	fi;
	if [ -e $i/queue/iostats ]; then
		echo "0" > $i/queue/iostats;
	fi;
	if [ -e $i/queue/iosched/back_seek_penalty ]; then
		echo "1" > $i/queue/iosched/back_seek_penalty;
	fi;
	if [ -e $i/queue/iosched/slice_idle ]; then
		echo "2" > $i/queue/iosched/slice_idle;
	fi;
done;

# Misc IO Tweaks (thx to dorimanx)
  echo "524288" > /proc/sys/fs/file-max;
  echo "1048576" > /proc/sys/fs/nr_open;
  echo "32000" > /proc/sys/fs/inotify/max_queued_events;
  echo "256" > /proc/sys/fs/inotify/max_user_instances;
  echo "10240" > /proc/sys/fs/inotify/max_user_watches;

# Misc Kernel Tweaks (thx to dorimanx)
  echo "2048" > /proc/sys/kernel/msgmni;
  echo "65536" > /proc/sys/kernel/msgmax;
  echo "10" > /proc/sys/fs/lease-break-time;
  echo "128" > /proc/sys/kernel/random/read_wakeup_threshold;
  echo "256" > /proc/sys/kernel/random/write_wakeup_threshold;
  echo "500 512000 64 2048" > /proc/sys/kernel/sem;
  echo "2097152" > /proc/sys/kernel/shmall;
  echo "268435456" > /proc/sys/kernel/shmmax;
  echo "524288" > /proc/sys/kernel/threads-max;

