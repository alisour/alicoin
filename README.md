### voteapp
# Simple voting chaincode implementation of hyperledger fabric in go


### MY TOOLS

**linux/amd64, Hyperledger Fabirc (v1.4.4), Docker version 18.09.7, docker-compose version 1.17.1, go version go1.13.3 , npm (v5.6.0), node.js (v8.10.0)

### HOW TO UP THE NETWORK AND INSTALL CHAINCODE

# Firstly,open bash in "pollschain" directory and put command below to create certificates for network:

```
./generate-crypto-config.sh
```

# Then up the network and install the chaincode with this:
```
./start.sh
```

# Then to test functions of the chaincode firstly put this command below:
```
./init_candidate.sh
```
# Then this:
```
./init-vote.sh
```
# After that send the same commands with this and see what happens:
```
./error_test.sh
```
Dont forget to stop:
```
./stop.sh
```
# Got inspired(!) from this repo:

https://github.com/erickzzh/Voting-blockchain-fabric
