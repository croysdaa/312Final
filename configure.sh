#!/usr/bin/env bash

sudo apt update
sudo apt-get install openjdk-17-jdk
wget https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar
mv server.jar minecraft_server..jar
java -Xmx1024M -Xms1024M -jar minecraft_server..jar nogui
sed -i "s/false/true/" ~/eula.txt
cat <<EOF >run.sh
#!/usr/bin/env bash
java -Xmx1024M -Xms1024M -jar minecraft_server..jar nogui
EOF
chmod +x run.sh
cd /etc/systemd/system
cat <<EOF >minecraft.service
	[Unit]
	Description=Minecraft Server
	After=network.target

	[Service]
	User=admin
Restart=on-failure
RestartSec=25s
ExecStart=/home/admin/run.sh

[Install]
WantedBy=multi-user.target
EOF
chmod 0755 minecraft.service

sudo systemctl --user daemon-reload
sudo systemctl --user enable /etc/systemd/system/minecraft.service
sudo systemctl start minecraft.service
