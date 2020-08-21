#!/bin/bash -e
#
#  Copyright © 2018-2020 Kontain Inc. All rights reserved.
#
# Install Kontain release on a Linux box. Assumes root.
#
# Usage: ./kontain-install.sh [TAG]


[ "$TRACE" ] && set -x

readonly TAG=${1:-0.1-test}
readonly PREFIX="/opt/kontain"
readonly URL="https://github.com/kontainapp/km-releases/releases/download/${TAG}/kontain.tar.gz"

function check_args {
   echo "check-arg: Noop for now"
}

function warning {
   echo "*** Warning:  $*"
}

function error {
   echo "*** Error:  $*"
   exit 1
}

validate=0
function check_prereqs {
   # check for PREFIX
   if [[ ! -d $PREFIX || ! -w $PREFIX ]] ; then
      error "$PREFIX does not exist or not writeable. Use 'sudo mkdir -p $PREFIX ; sudo chown `whoami` $PREFIX'"
   fi

   if ! command -v gcc ; then
      warning "GCC is not found, only pre-linked unikernels can be used on this machine"
   fi

   # check and warn about kvm and version
   if ! lsmod | grep -q kvm ; then
      warning "KVM module is missing"
      if ! lsmod | grep -q kkm ; then
         warning "KKM module is also missing"
         validate=0
      elif [ ! -w /dev/kkm  ] ; then
         warning "/dev/kkm is missing or not writeable"
      else
         validate=1
      fi
   elif [ ! -w /dev/kvm  ] ; then
      warning "/dev/kvm is missing or not writeable"
   else
      validate=1
   fi


}

function get_bundle {
   mkdir -p $PREFIX
   echo "Pulling $URL..."
   wget $URL --output-document - -q | tar -C ${PREFIX} -xzf -
   echo Done.
   if [ $validate == 1 ] ; then
      $PREFIX/bin/km $PREFIX/tests/hello_test.km Hello World
   else
      echo Install either KVM or KKM Module and then validate installation by running
      echo $PREFIX/bin/km $PREFIX/tests/hello_test.km Hello World
   fi
}

# main
check_args
check_prereqs
get_bundle
