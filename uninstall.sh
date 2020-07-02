if [ -a ./backup.txt ]
	then

		mv readme.md README.md

		GRUB=`cat backup.txt`

		sed -i -e "s|^GRUB_CMDLINE_LINUX_DEFAULT.*|${GRUB}|" /etc/default/grub    
    		echo ""
		echo "Original grub configuration has been restored: "
		echo $GRUB

		    else
    
		echo "No backup file available"
		exit
fi
    
if [ -a /sbin/vfio-pci-override-vga.sh ]
	then
	rm /sbin/vfio-pci-override-vga.sh
fi
	
if [ -a local.conf.modprobe_backup ]
	then
		cp local.conf.modprobe_backup /etc/modprobe.d/local.conf
    	else 
    		rm /etc/modprobe.d/local.conf
fi
	
if [ -a local.conf.dracut_backup ]
	then
		cp local.conf.dracut_backup /etc/dracut.conf.d/local.conf
	else
		rm /etc/dracut.conf.d/local.conf
fi

grub2-mkconfig -o /boot/grub2/grub.cfg
