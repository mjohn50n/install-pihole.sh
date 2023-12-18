# install-pihole.sh
Install pihole on docker with separate IP

Usage Instructions:
Save the script as install-pihole.sh.
Make it executable: chmod +x install-pihole.sh.
Run the script: sudo ./install-pihole.sh.
When prompted, enter the desired password for the Pi-hole admin interface.
Important Notes:
The script uses the -s flag in the read command to ensure the password is not echoed back to the screen when you type it.
The Pi-hole admin password you enter will not be visible as you type, enhancing security.
Ensure the IP address 192.168.1.100 is correctly configured on your Docker host and not in use by other services.
As always, be cautious with network configurations to avoid conflicts.
