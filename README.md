# virtualbox-scancodes

Send keys when the VirtualBox guest has no sensible way of communicating with the outside world like SSH, for example in the EFI shell or before the OS is installed.

# Usage

`source scancodes.sh` - loads functions from script  
`sendkeys` - read a string of ASCII characters and send them as scancodes to the guest virtual machine  
`sendspecial` - read names of special characters by name, space delimited  
`sendenter` - send ENTER key  
`printksc` - print names of recognized special keys
