# Port validarion script
The aim of this script is to take an ip address and a list of ports as standard input, checking if each of the ports is active.
If the port is down, send a command to turn the service on via ssh and write the results to a log.

The script validate the status of the ports provided with the IP Address and, in case that the port is not active, launch a netcat command through ssh (net::ssh in fact) as daemon for provitioning service in the required port. 

In order to test the script portvalidation.rb you must have:
- A virtualization product like VirtualBox
- Vagrant configured on your OS (tested on OSX and Linux Boxes)
- Ruby and the rubygems socket timeout net/ssh and logger gems
- keep in the same working directory the Vagrantfile and portvalidation.rb files provided in the same .tgz file.
- make (not required) some adjunstment to global variables (eg. path to private key) in the portvalidation.rb script

### Procedure

1. launch the ubuntu/trusty64 VM in the same network of the host machine (it will take the net configuration from DHCP, also is possible that the process require the network interface to attach)

`$ vagrant up`

2. run the portvalidation.rb script against the Vagrant VM, defining the ip_of_the_vm and the ports to be validated
$ ruby portvalidation.rb [ip_of_the_vm] [port1] .. [portN]

3. the script execution will return to STDOUT the status of the ports provided as as well a log (default log.txt) with the information relative to the time that host and port were validated






