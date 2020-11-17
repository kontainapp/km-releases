# Kontain Monitor, Kontain VM and unikernels

Public repository with Kontain binary releases. Kontain code is not open source currently and is maintained in a private repository.

Kontain is the way to run container workloads "Secure, Fast and Small - choose three". Kontain runs workloads in a dedicated VM, as a unikernel - within Kontain VM. A workload can be a regular Linux executable, or a Kontain "unikernel" - your code relinked with Kontain libraries to run directly on virtual hardware, without OS layer in the VM. Running in a Kontain Virtual Machine provides VM level isolation/security, but without any of VM overhead - in act, Kontain workloads startup time is closer to Linux process and is faster than Docker containers.

Kontain seamlessly plugs into Docker or Kubernetes run time environments.

Kontain release includes Kontain Monitor, runtime libraries, tools and pre-build unikernel payloads, e.g. Python-3.7.

## Status

BETA - the packaging and docs are work in progress and may change without notice.

## Platform support

* Kontain currently supports and is tested on Linux distribution with kernel 4.15 and above
  * We recommend Fedora 32 or Ubuntu 20.
  * Note than Debian 9 (default in GCP at the moment) is based on 4.09 Kernel, so you'd need to choose other distributions with fresher kernel, e.g. Ubuntu 20 LTS.
* Kontain needs access to virtualization, so it works on Linux with KVM enabled, or Linux with Kontain Kernel Module (KKM) installed and loaded.
  * On AWS, Kontain KKM kernel model is required. For demo purposes, we provide an AWS AMI of Ubuntu 20 with KKM installed and pre-loaded.

## Install

On a Linux machine with KVM enabled, run this

```bash
sudo mkdir -p /opt/kontain ; sudo chown $(whoami) /opt/kontain
wget https://raw.githubusercontent.com/kontainapp/km-releases/master/kontain-install.sh -O - -q | bash
```

Or, you can clone the repository and run the script directly:

```bash
git clone https://github.com/kontainapp/km-releases
./km-releases/kontain-install.sh
```

Either way, the script will try to un-tar the content into /opt/kontain. If you don't have enough access, the script will advice on the next step.

## More info (Documentation and examples)

See [GettingStarted.md](https://github.com/kontainapp/km-releases/blob/master/GettingStarted.md)

## Licensing

**Copyright © 2020 Kontain Inc. All rights reserved.**

**By downloading or otherwise accessing the Kontain Beta Materials, you hereby agree to all of the terms and conditions of Kontain’s Beta License available at https://raw.githubusercontent.com/kontainapp/km-releases/master/LICENSE**

