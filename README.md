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