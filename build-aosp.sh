#!/bin/sh

if [ ! -e /home/umberto1978/android/release-tools/bmp2splash/bmp2splash ]; then
      echo "make bmp2splash..."
      make -C /home/umberto1978/android/release-tools/bmp2splash
  fi

/home/umberto1978/android/release-tools/bmp2splash/bmp2splash /home/umberto1978/android/logo/speedwizz_logo.bmp > /home/umberto1978/android/speedwizz_kernel_N2/drivers/video/samsung/logo_rgb24_user.h
export USER_BOOT_SPLASH=y

echo "Move to our working directory first"
cd /home/umberto1978/android/speedwizz_kernel_N2
echo "Done"
sleep 3

echo "Perform a Make clean on our working tree to initialize it"
find . -name "*~" -exec rm -rf {} \;
make clean
make mrproper
echo "Done"
sleep 3

echo "Perform a working config"
make speedwizz_test_defconfig
echo "Done"
sleep 3

echo "Start compiling..."
make 
echo "Done"
sleep 3

echo "Compile modules twice, just to be sure"
make modules CFLAGS_MODULE=-fno-pic
echo "Done"
sleep 3

#Copy the compiled zImage on a building directory for later usage
echo "Create a directory for compiled images and check his content"
cd /home/umberto1978/android
if [ -d compiled ]; then cd /home/umberto1978/android/compiled;
else
mkdir compiled;
cd /home/umberto1978/android/compiled;
fi
if [ -f zImage ]; then rm zImage;
fi
echo "Done"
sleep 3

echo "Now move to source directory and copy new zImage to the compiled directory"
cd /home/umberto1978/android/speedwizz_kernel_N2/arch/arm/boot
if [ -f zImage ]; then cp zImage /home/umberto1978/android/compiled/;
echo "Done, zImage copied";
else echo "No zImage found!! Exiting program!";
exit;
fi
sleep 3

echo "Now copy the newly compiled modules to compiled directory as well"
cd /home/umberto1978/android/compiled
if [ -d modules ]; then rm -rf modules;
fi
mkdir /home/umberto1978/android/compiled/modules;
cd /home/umberto1978/android/speedwizz_kernel_N2
find . -name "*.ko" -exec cp {} /home/umberto1978/android/compiled/modules/ \;
echo "done"
sleep 3

echo "now build ramdisk"
cd /home/umberto1978/android/ramdisk-folder_AOSP
rm *~
sleep 3

echo "erasing old modules and zImage"
cd /home/umberto1978/android/ramdisk-folder_AOSP/lib/modules
rm -f btlock*
rm -f commkm*
rm -f logger*
rm -f mvpkm*
rm -f pvtcpkm*
rm -f dhd*
rm -f scsi_wait_scan*
cd /home/umberto1978/android/boot-images
rm -f *zImage*
echo "Done"
sleep 3

echo "copy new modules and zImage"
cd /home/umberto1978/android/compiled/modules
find . -name "*.ko" -exec cp {} /home/umberto1978/android/ramdisk-folder_AOSP/lib/modules/ \;
cd /home/umberto1978/android/compiled
cp zImage /home/umberto1978/android/boot-images/new_zImage
echo "Done"
sleep 3

echo "now pack ramdisk"
cd /home/umberto1978/android/boot-images
rm *.img
cd /home/umberto1978/android/ramdisk-folder_AOSP
find . | cpio -o -H newc | gzip > /home/umberto1978/android/boot-images/ramdisk.cpio.gz
cd /home/umberto1978/android/boot-images
mv ramdisk.cpio.gz initrd.img
echo "Done"
sleep 3

echo "now build boot.img"
cd /home/umberto1978/android/boot-images
./mkbootimg.Linux.x86_64 --kernel new_zImage --ramdisk initrd.img -o newBoot.img --base 0x10000000
echo "Done"
sleep 3

echo "Moving boot.img"
cd /home/umberto1978/android/build
rm -f *.img
find . -name "*.zip" -exec mv {} /home/umberto1978/android/released/ \;
find . -name "*.tar" -exec mv {} /home/umberto1978/android/released/ \;
cd /home/umberto1978/android/boot-images
mv newBoot.img /home/umberto1978/android/build/boot.img
echo "now compiling zip and Tar flashables"
cd /home/umberto1978/android/build
zip -r speedwizz_kernel_N2_AOSP_`date +"%Y-%m-%d-%H-%M-%S"` ./
tar -H ustar -c boot.img > speedwizz_kernel_N2_AOSP_`date +"%Y-%m-%d-%H-%M-%S"`.tar
echo "DONE!"
sleep 3
exit


