# uperf-docker-s390x
docker  container for uperf client/server on s390x architecture. Builds using s390x arch in Travis. 

### Deploying to OpenShift cluster
1. uperf server 
``` 
        oc apply -f uperf-server.yml
        oc apply -f uperf-service.yml
```

2. uperf client ``` oc apply -f uperf-client.yml```

### Rebuilding docker images using buildx with target architectures
```
docker buildx build --platform linux/x86_64,linux/s390x -t aosadchyy/uperf --push .
```