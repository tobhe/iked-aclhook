#!/bin/ksh

# Copyright (c) 2020 Tobias Heider
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# # ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

addr="$2"
rdomain="$8"
iface="lo$rdomain"

check_iface() {
	ifconfig $iface
	if [ "$?" -ne 0 ]; then
		ifconfig "enc$rdomain" create rdomain "$rdomain"
	fi
}

do_assoc() {
	if [ "$addr" == "" ]; then
		echo "aclhook: nothing to do"
	else
		echo "aclhook: setting "$addr" on $iface"
		ifconfig $iface inet "$addr" rdomain "$rdomain"
		route -T "$rdomain" add default "$addr"
	fi
}

do_free() {
	echo "aclhook: clearing $iface"
	ifconfig $iface delete
}

case "$1" in
assoc)	do_assoc;;
free)	do_free;;
esac

exit 0
