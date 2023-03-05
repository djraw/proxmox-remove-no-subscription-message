#!/bin/sh

#######################################################
#
# Edits the proxmox Subscription file to make it
# think that it has a Subscription.
#
# Will disable the annoying login message about
# missing subscription.
#
# Tested on Proxmox PVE v5.2-1 / v6.0-4 / v6.3-2 / 7.2-11 / 7.3-4
#
# The sed command will create a backup of the changed file.
# There is no guarantee that this will work for future versions.
# Use at your own risk!
#
# OneLiner:
# wget -q -O - 'https://gist.github.com/tavinus/08a63e7269e0f70d27b8fb86db596f0d/raw/' | /bin/sh
# curl -L -s 'https://gist.github.com/tavinus/08a63e7269e0f70d27b8fb86db596f0d/raw/' | /bin/sh
#
# Save to Local File:
# wget -q -O rem_proxmox_popup.sh 'https://gist.github.com/tavinus/08a63e7269e0f70d27b8fb86db596f0d/raw/' && chmod +x rem_proxmox_popup.sh
# curl -L -o rem_proxmox_popup.sh 'https://gist.github.com/tavinus/08a63e7269e0f70d27b8fb86db596f0d/raw/' && chmod +x rem_proxmox_popup.sh
#
# Then you can just run the file after updates:
# ./rem_proxmox_popup.sh
#
#######################################################

init_error() {
    local ret=1
    [ -z "$1" ] || printf "%s\n" "$1"
    [ -z "$2" ] || ret=$2
    exit $ret
}

# Original command
# sed -i.bak 's/NotFound/Active/g' /usr/share/perl5/PVE/API2/Subscription.pm && systemctl restart pveproxy.service

# Command to restart PVE Proxy and apply changes
PVEPXYRESTART='systemctl restart pveproxy.service'

# File/folder to be changed
TGTPATH='/usr/share/perl5/PVE/API2'
TGTFILE='Subscription.pm'

# Check dependecies
SEDBIN="$(which sed)"

[ -x "$SEDBIN" ] || init_error "Could not find 'sed' binary, aborting..."

# This will also create a .bak file with the original file contents
sed -i.bak 's/NotFound/Active/g' "$TGTPATH/$TGTFILE"
sed -i.bak 's/notfound/active/g' "$TGTPATH/$TGTFILE"
$PVEPXYRESTART

# Removed execution checking, since the terminal gets closed after PVEPXYRESTART anyways

exit 0
