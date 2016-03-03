# docker-eclim #
eclim container to develop java code.
+ JDK8
+ maven
+ eclim

## usage ##
To run,
```
docker run -d -e --name tmp gk0909c/eclim
```

If behind proxy,(for maven)
```
docker run -d -e PROXY_HOST=your.proxy.host -e PROXY_PORT=yourproxyport --name tmp gk0909c/eclim
```

use volume for maven repository persistent
```
docker volume create --name eclim-m2-repository
docker run -d -v eclim-m2-repository:/home/dev/.m2/repository  --name eclim gk0909c/eclim
```
