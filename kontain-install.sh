#!/bin/bash
#
#  Copyright © 2018-2020 Kontain Inc. All rights reserved.
#
# Install Kontain release on a Linux box. Assumes root.
#
# Usage: ./kontain-install.sh [TAG]

set -e ; [ "$TRACE" ] && set -x

# release name has to be passed via 1st arg, otherwise it's fetched from a file in the repo
export DEFAULT_TAG=$(curl -s https://raw.githubusercontent.com/kontainapp/km-releases/master/default-release)
readonly TAG=${1:-$DEFAULT_TAG}
readonly PREFIX="/opt/kontain"
readonly URL="https://github.com/kontainapp/km-releases/releases/download/${TAG}/kontain.tar.gz"

function check_args {
   # "check-arg: Noop for now"
   true
}

function warning {
   echo "*** Warning:  $*"
}

function error {
   echo "*** Error:  $*"
   exit 1
}

pkgs_missing=0
function check_packages {
    echo "Checking that packages $NEEDED_PACKAGES are present"
    for i in $NEEDED_PACKAGES ; do
        if ! rpm -qa | grep $i -q ; then
            pkgs_missing=1
            warning "Package $i is required and is not installed."
        fi
    done
}

function install_packages {
    source /etc/os-release
    echo "Installing needed packages for $NAME"
    if [ "$NAME" == "Ubuntu" ]; then
        sudo apt-get update
        sudo apt-get install -y libyajl2 libseccomp2 libcap2
    elif [ "$NAME" == "Fedora" ] ; then
        sudo dnf install -y yajl-devel.x86_64 libseccomp.x86_64 libcap.x86_64
    else
        echo "Unsupported linux: $NAME, packages libyajl, libseccomp, libcap may need to be installed for krun to work"
    fi
}

validate=0
function check_prereqs {
   if [ $(uname) != Linux ] ; then
      error "Kontain requires a Linux distribution, e.g. Ubuntu 20 or Fedora 32. Current plaform: $(uname)"
   fi

   # check for PREFIX
   if [[ ! -d $PREFIX || ! -w $PREFIX ]] ; then
      error "$PREFIX does not exist or not writeable. Use 'sudo mkdir -p $PREFIX ; sudo chown `whoami` $PREFIX'"
   fi

   if ! command -v gcc ; then
      warning "GCC is not found, only pre-linked unikernels can be used on this machine"
   fi

   # check and warn about kvm and version
   if ! lsmod | grep -q kvm ; then
      if ! lsmod | grep -q kkm ; then
         warning "No virtualization module (KKM or KVM) is found"
         validate=0
      elif [ ! -w /dev/kkm  ] ; then
         warning "KKM module is present but /dev/kkm is missing or not writeable"
      else
         validate=1
      fi
   elif [ ! -w /dev/kvm  ] ; then
      warning "KVM module is present but /dev/kvm is missing or not writeable"
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
   if [ $pkgs_missing -ne 0 ]; then
      echo "Some packages need to be installed to use all functionality"
   fi
}

# main
check_args
check_prereqs
install_packages
get_bundle
