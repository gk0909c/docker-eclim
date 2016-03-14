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

view jacoco covarage report at host browser.  
there is nginx setting shell,
+ coverage report location >  /home/dev/workspace/${project_name}/target/site/jacoco/ 
+ port > 8080
```
docker run -d -p 8080:8080  --name eclim gk0909c/eclim
# in container.
# out jacoco covarage report.
# then,
set_nginx_jacoco_report ${project_name}
# see browser, url is http://localhost:8080
```
