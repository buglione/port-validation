#!/usr/bin/ruby
# description: this script takes an ip address and a list of ports as standard input. Check if each of the ports is active and if the port is down, send a ssh command to turn on the service. The final status of the port is write to a log.
# author: Mariano Buglione <buglione@gmail.com>

require 'rubygems'
require 'socket'
require 'timeout'
require 'net/ssh'
require 'logger'
  
# required for ssh conection to a vagrant box
$port = 22
$user = 'vagrant'
$private_key = "~/.vagrant.d/insecure_private_key"

# required for log
$logfile = 'log.txt'
 
# port validation
def port_open(ip, port, seconds=1)
  Timeout::timeout(seconds) do
    begin
      TCPSocket.new(ip, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      false
    end
  end
rescue Timeout::Error
  false
end

# ssh connection and command execution
def ssh(host, user, port, port2open)
  cmd = "while true; do nohup sudo nc -n -l #{port2open}; done > /dev/null 2>&1 &"
  Net::SSH.start( host, user, :port => port, :keys => $private_key) do |ssh|
    result = ssh.exec!(cmd)
    puts result
  end
end

# main program
def main(host, args)
  log = Logger.new($logfile)
  args.each do |i|
    puts "Scanning host: #{host} in port #{i}"
    if port_open(host, i)
      puts "#{i} is open!"
      log.debug "Scanning host: #{host} in port #{i} - port OK"
    else
      puts "#{i} is closed!"
      puts "opening... "
      ssh(host, $user, $port, i)
      log.debug "Scanning host: #{host} in port #{i} - port was down"
    end
  end
end

main ARGV[0], ARGV[1..-1]

