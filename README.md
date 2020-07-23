# uperf-docker-s390x
docker  container for uperf client/server on s390x architecture

### Deploying to OpenShift cluster
1. uperf server ``` oc create -f uperf-server.yml```
1. uperf client ``` oc create -f uperf-client.yml```