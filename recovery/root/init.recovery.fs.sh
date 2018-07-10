#!/sbin/sh

if [ ! -e /sbin/mkfs.vfat -a -e /sbin/mkfs.fat ]
then
	ln -s /sbin/mkfs.fat /sbin/mkfs.vfat
fi

if [ -d /dev/lvpool ]
then
	# Maintain compatibility
	mkdir /dev/partitions
	ln -s /dev/lvpool/system /dev/partitions/system
	ln -s /dev/lvpool/cache /dev/partitions/cache
	ln -s /dev/lvpool/userdata /dev/partitions/userdata
	ln -s /dev/lvpool/media /dev/partitions/media
else
	# Maintain compatibility
	mkdir /dev/partitions
	ln -s /dev/block/mmcblk0p12 /dev/partitions/system
	ln -s /dev/block/mmcblk0p6 /dev/partitions/cache
	ln -s /dev/block/mmcblk0p13 /dev/partitions/userdata
	ln -s /dev/block/mmcblk0p14 /dev/partitions/media

	# Replace fstab.
	cp /fstab.qcom /fstab.qcom.lvm
	mv /fstab.qcom.std /fstab.qcom

	# In recovery, need to replace recovery fstab
	if [ -f /etc/recovery.fstab ]
	then
		cp /fstab.qcom /etc/recovery.fstab
	fi

	if [ -f /etc/twrp.fstab -a -f /etc/twrp.fstab.std ]
	then
		cp /etc/twrp.fstab /etc/twrp.fstab.lvm
		cp /etc/twrp.fstab.std /etc/twrp.fstab
	fi
fi
