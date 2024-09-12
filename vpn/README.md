# vpn

A shell utility allowing users to manage wireguard connections.

# How does it work?

The utility retrieves wireguard configuration files from the directory
```/etc/wireguard```
and uses
```wg-quick```

# Dependencies

The ```wireguard``` package is required.

# Usage

### Activate a wireguard connection
To activate a wireguard connection, type the command:
```bash
vpn
```

A list of available connections will be displayed and prompt the user to enter the number of the connection to activate.

### Example:
```bash
$ vpn
[sudo] password for user: 
1) connection1  3) proton-vpn
2) connection2	4) proton2-vpn
Select vpn connection: 3
<running wireguard commands to connect>
```