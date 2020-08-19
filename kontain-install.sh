#!/bin/bash -e
#  Copyright © 2018-2020 Kontain Inc. All rights reserved.
#
# Install Kontain release on a Linux box. Assumes root.
#

[ "$TRACE" ] && set -x

readonly PREFIX="/tmp/opt/kontain"
readonly TAG="0.1-test"
readonly URL="https://github.com/kontainapp/km-releases/releases/download/${TAG}/kontain.tar.gz"

function check_args {
   echo "check-arg: Noop for now"
}

function warning {
   echo "*** Warning:  $*"
}

function check_prereqs {
   # check and warn about kvm and version
   if ! lsmod | grep -q kvm ; then warning "KVM module seems to be missing" ; fi
   if [ ! -w /dev/kvm  ] ; then warning "/dev/kvm is missing or not writeable"; fi
}

function get_bundle {
   mkdir -p $PREFIX
   echo "Pulling $URL..."
   wget $URL --output-document - -q | tar -C ${PREFIX} -xzf -
   echo Done. To validate, run \'$PREFIX/bin/km $PREFIX/tests/hello_test.km Hello World\'  using non-root account
}

#main
check_args
check_prereqs
get_bundle
