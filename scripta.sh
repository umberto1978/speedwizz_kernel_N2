#!/bin/bash

CurrentKernelVer=87

while [ "$CurrentKernelVer" -ne 101 ]; do
	y=$(($CurrentKernelVer + 1))	
	wget https://www.kernel.org/pub/linux/kernel/v3.x/incr/patch-3.0.$CurrentKernelVer-$y.gz -O ../patch-3.0.$CurrentKernelVer-$y.gz
	gunzip -d ../patch-3.0.$CurrentKernelVer-$y.gz
	patch -p1 < ../patch-3.0.$CurrentKernelVer-$y
function pause(){
   read -p "$*"
}
 
# ...
# call it
pause 'Press [Enter] key to continue...'
# rest of the script
	rm ../patch-3.0.$CurrentKernelVer-$y
	CurrentKernelVer=$(( $CurrentKernelVer + 1 ))
done

