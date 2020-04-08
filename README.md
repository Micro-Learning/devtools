# devtools

## Build container

```
docker build -t devtools .
```


## Run image

### Linux Environment
```
docker run -it  \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /var/run/docker.sock:/var/run/docker.sock \
       --name devtools \
       devtools
```

### Mac Environment

Download: https://www.xquartz.org/
Tutorial: https://blogs.oracle.com/oraclewebcentersuite/running-gui-applications-on-native-docker-containers-for-mac

After installing XQuartz, start it and open XQuartz -> Preferences from the menu bar. Go to the last tab, Security, and enable both "Allow connections from network clients" and "Authenticate connections" checkboxes and restart XQuartz.
Now your Mac will be listening on port 6000 for X11 connections. Record the IP Address of your Mac as you will need it in your containers.

$ ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'

Add the IP Address of your Mac to the X11 allowed list.
$ xhost + $YOUR_IP
$YOUR_IP being added to access control list

```
docker run -itd  \
       -e DISPLAY=$YOUR_IP \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /var/run/docker.sock:/var/run/docker.sock \
       --name devtools \
       devtools

```
