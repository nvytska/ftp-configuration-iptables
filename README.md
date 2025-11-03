# Assignment 4: 
Student: Nataliia Vytska  

Group: CS420 Group 2

---
**Brief description**

This project sets up a secure FTP server and controlled access, using iptables and authorization server.The authorization server listens on port 7777 and dynamically modifies rules based on valid credentials stored in `/etc/authServer/credentials.txt`. 


The best approach is:

**Instalation:**
0. Clone repo: ```git clone https://github.com/nvytska/ftp-configuration-iptables.git```
1. Create new clean VM: ```multipass launch --name ftp-lab```.
2. Mount: ```multipass mount ./ftp-configuration-iptables ftp-lab:/home/ubuntu/ftp-configuration-iptables```.
3. ```multipass shell ftp-lab```
4. Go to directory: ```cd ftp-configuration-iptables```.

**How to use script?**

5. Run the script: ```chmod +x configureServer.sh
sudo ./configureServer.sh 192.168.0.105,10.10.1.2```.
6. Check services: ```sudo systemctl status vsftpd
sudo systemctl status authServer.service```
7. Test authorization: ```telnet localhost 7777```. You should have access granted.
8. Test FTP connection: ```ftp localhost```.