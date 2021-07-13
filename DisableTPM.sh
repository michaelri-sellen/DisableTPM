#!/bin/bash
#
# File : Command Configure config script Linux/Unix
# Generated by michaelri
# At Tue 07/13/2021  8:22:17.75
# On SELLEN-100381
#
# Generated by Command Configure Configuration Wizard 4.5.0
#
# Only for supported Linux and Ubuntu installations with cctk and srv-admin installed
# Will need to be root or will require 'sudo' privileges

SCRIPTNAME=`basename $0`
LOG=`basename $0`.log

# /etc/redhat-release -Linux or /etc/lsb-release -Ubuntu or /etc/lsb-release -Ubuntu-Core
CCTKPATH=/opt/dell/dcc;
CCTKEXE=cctk;
INIBASE=.;
if [[ -f /etc/os-release ]]; then
   . /etc/os-release    #Sourcing into os-release
   if [[ $ID = ubuntu-core ]]; then # ID - ubuntu-core or ubuntu or rhel
	CCTKPATH=/snap/bin;
       CCTKEXE=dcc.cctk;
	INIBASE=/var/snap/dcc/current;	 
   fi
fi
CCTKWHICH=`which cctk 2> /dev/null`


function err {
	echo "Error: ${SCRIPTNAME} : $1"
	exit $2
}


function hlp {
	echo "Help : ${SCRIPTNAME}"
	echo "Applies BIOS config exported from a host system"
	echo "A valid cctk installation is expected"
	echo "Should be run by the root user, or using a 'sudo' command"
	echo "Arguments:"
	echo "-h|--help    this help message"
}

# Handle arguments
if [ "x$2" != "x" ]; then
	hlp
	exit 0
fi

# Check cctk installation presence
if [ "x${CCTKWHICH}" != "x" -a -f "${CCTKWHICH}" -a -x "${CCTKWHICH}" ]; then
	CCTK="${CCTKWHICH}"
elif [ -f "${CCTKPATH}/${CCTKEXE}" -a -x "${CCTKPATH}/${CCTKEXE}" ];  then
	CCTK="${CCTKPATH}/${CCTKEXE}"
else
	err "cctk installation not found" -1
fi


TMPINI=$INIBASE/.tmp.cctk.config.ini
if [ -f ${TMPINI} ]; then
	rm -f ${TMPINI}
fi

cat > ${TMPINI} <<HERE
[cctk]
TpmActivation=Disabled
TpmPpiAcpi=Disabled
TpmPpiClearOverride=Disabled
TpmPpiDpo=Disabled
TpmPpiPo=Disabled
TpmSecurity=Disabled
HERE


if [ "$(id -u)" != "0" ]; then
   err "Permission Denied - Insufficient priviliges" -1
fi
"${CCTK}" -i ${TMPINI} > ${LOG}
if [ $? == 0 ]; then
	echo "BIOS settings applied successfully"
else
	echo "Error applying BIOS settings."
fi
echo "Details in ${LOG}"
exit $rtn

