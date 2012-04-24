#!/bin/bash
#
# wiredKernelLoader.sh
#
# This script expects a connected device.
#
#
# 2011 nubecoder
# http://www.nubecoder.com/
#

# source includes
source "$PWD/../includes"

# error
ERROR="no"

echo
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo "Begin."
echo "*"

# check for device (taken from the OneClickRoot: http://forum.xda-developers.com/showthread.php?t=897612)
CURSTATE=$($ADB_STATE | tr -d '\r\n[:blank:]')
while [ "$CURSTATE" != device ]; do
	CURSTATE=$($ADB_STATE | tr -d '\r\n[:blank:]')
	echo "Phone is not connected."
	CURSTATE="device"
	ERROR="yes"
done

if [ "$ERROR" != "yes" ]; then
	#remove previous files
	echo "Removing previous files."
	$ADB_SHELL "rm " $ZIMAGE_DEST >/dev/null 2>&1
	$ADB_SHELL "rm " $KERNELLOAD_DEST >/dev/null 2>&1

	#push new kernel to phone
	echo "Pushing zImage, this may take a minute."
	$ADB_PUSH $ZIMAGE_SRC $ZIMAGE_DEST >/dev/null 2>&1

	#push kernelLoad to phone and set permissions
	echo "Pushing kernelLoad, this may take a minute."
	$ADB_PUSH $KERNELLOAD_SRC $KERNELLOAD_DEST >/dev/null 2>&1
	echo "Setting permissions on kernelLoad (0755)."
	$ADB_SHELL "chmod 0755" $KERNELLOAD_DEST
	#load kernel with kernelLoad script
	echo "Loading kernel with kernelLoad."
	echo "*"
	$ADB_SHELL $ADB_KERNEL_LOAD
else
	echo "Please connect your phone."
fi

echo "*"
echo "End."
echo "=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]=]"
echo

exit
