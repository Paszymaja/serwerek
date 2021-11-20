apt install openjdk-17-jre-headless curl -y
ufw allow 25565
mkdir fabric
cd fabric
curl -o installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.9.0/fabric-installer-0.9.0.jar
java -jar installer.jar server -mcversion 1.17.1 -downloadMinecraft
rm installer.jar
mv server.jar vanilla.jar
mv fabric-server-launch.jar server.jar
echo "serverJar=vanilla.jar" > fabric-server-launcher.properties
mkdir mods
cd mods
wget https://github.com/FabricMC/fabric/releases/download/0.42.1%2B1.17/fabric-api-0.42.1+1.17.jar
wget https://github.com/gnembon/fabric-carpet/releases/download/1.4.54/fabric-carpet-1.17.1-1.4.54+v211117.jar

cd ..
apt install unzip -y
wget https://cdn.discordapp.com/attachments/594937794619506700/911590329474482206/void.zip
unzip void.zip

java -Xmx3G -Xms3G -jar server.jar
