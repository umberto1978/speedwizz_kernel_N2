SpeedWizz_N2_Kernel---GT-N7100
==============================

New project for international version of the Samsung Galaxy Note 2 GT N7100 device

The actual source upload consist:

- The source code jb_update2 released from samsung for N7100
- The above source comes ALREADY patched with hardcore's speedmod patch from his GT I9300 kernel, both devices sharing the same source code (almost) but different defconfig.
- The mmc drivers section is patched with samsung fix straight from GT I9300 source update 10, to avoid issue with SDS; my kernel sources are SAFE.
- I use actual the DMB2 kernel initramfs, no longer hosted in github, only made the boot image unsecure and added init.d support. Learning how to implement those things is very easy.
- NOTE: i use to compile a running kernel a Linaro GCC 4.6.3, kernel runs smooth and no bug at all.

Latest update, 20 July 2013 15:39 local time, Italy.
