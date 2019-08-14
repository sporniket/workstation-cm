# Sample seed VM project

> Status : EXPERIMENTAL

## How to use the seed project

1. Create a new VM project folder.
2. Duplicate the `Vagrantfile.template` as Vagrantfile
3. Customize the Vagrantfile (see below)
4. start the VM with `vagrant up`.

From there, make changes to your vm project to suit your needs.

## Vagrantfile customization

_This section assume that the reader has a basic understanding of a `Vagrantfile` and its content, and that the reader knows where to look for further explainations in the reference manual of Vagrant, forums and stackoverflow_

The template contains some markers that need to be replaced with actual values :

* `@@@MEMORY@@@` : the size of the RAM of the VM, e.g. `20000` ; _leave at least 4 Gb to the host system_.
* `@@@CPUS@@@` : the number of CPU cores to use, e.g. `4` ; _leave at least 4 cores to the host system_.
* `@@@USECASE@@@` : `with-proxy` or `no-proxy`.
* `@@@USERLOGIN@@@` : your favorite login, or the user login taken from the host.
* `@@@USERDISPLAYNAME@@@` : your favorite display name, or the display name taken from the host ; used for the account creation and for git settings.
* `@@@PROXYHOST@@@` : the proxy host name or IP address, eg `10.0.2.2`.
* `@@@PROXYPORT@@@` : the proxy port number, eg `3128`.
* `@@@NOPROXY@@@` : a comma separated list of hosts that should be accessed directly, i.e. the value of the `NO_PROXY` environment variable.
