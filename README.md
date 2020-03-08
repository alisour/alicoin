# MY TOOLS
Simple voting chaincode implementation of hyperledger fabric.

linux/amd64, Hyperledger Fabric v1.4.4, Docker v18.09.7,
docker-compose v1.17.1, go v1.13.3 , npm v5.6.0, node.js v8.10.0.

# HOW TO UP THE NETWORK AND INSTALL CHAINCODE

You can delete all files inside channel-artifacts before starting.

Firstly,open bash in "pollschain" directory and put command below to create certificates for network:

```
./generate.sh
```

 Then up the network and install the chaincode with this:
```
./start.sh
```

Afterwards, to test functions of the chaincode firstly put this command below:
```
./scripts/init_candidate.sh
```
 And this:
```
./scripts/init_vote.sh
```
Finally push the same commands and one more error command with this and see what happens:
```
./scripts/error_test.sh
```
 Dont forget to stop:
```
./stop.sh
```
