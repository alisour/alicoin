echo "*****CLEAN THE NETWORK*****"
docker-compose -f docker-compose-cli.yaml -f docker-compose-couch.yaml down --volumes

echo "*****INIT THE NETWORK*****"
docker-compose -f docker-compose-cli.yaml -f docker-compose-couch.yaml up -d
sleep .5s 

echo "*****CREATE CHANNEL*****"
docker exec -ti cli sh -c "peer channel create -o orderer.pollschain.com:7050 -c pollschainchannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/pollschain.com/orderers/orderer.pollschain.com/msp/tlscacerts/tlsca.pollschain.com-cert.pem"
sleep .5s 


echo "*****ADD PEERS TO THE CHANNEL*****"

docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/users/Admin@org1.pollschain.com/msp CORE_PEER_ADDRESS=peer0.org1.pollschain.com:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/peers/peer0.org1.pollschain.com/tls/ca.crt peer channel join -b pollschainchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/users/Admin@org1.pollschain.com/msp CORE_PEER_ADDRESS=peer1.org1.pollschain.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/peers/peer1.org1.pollschain.com/tls/ca.crt peer channel join -b pollschainchannel.block"
sleep .5s

echo "*****UPDATE ANCHOR PEER*****"

docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/users/Admin@org1.pollschain.com/msp CORE_PEER_ADDRESS=peer0.org1.pollschain.com:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/peers/peer0.org1.pollschain.com/tls/ca.crt peer channel update -o orderer.pollschain.com:7050 -c pollschainchannel -f ./channel-artifacts/Org1Anchor.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/pollschain.com/orderers/orderer.pollschain.com/msp/tlscacerts/tlsca.pollschain.com-cert.pem"
sleep .5s


echo "*****INSTALL THE CHAINCODE*****"
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/users/Admin@org1.pollschain.com/msp CORE_PEER_ADDRESS=peer0.org1.pollschain.com:7051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/peers/peer0.org1.pollschain.com/tls/ca.crt peer chaincode install -n polltest -v 1.0 -p github.com/chaincode -l golang"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/users/Admin@org1.pollschain.com/msp CORE_PEER_ADDRESS=peer1.org1.pollschain.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/peers/peer1.org1.pollschain.com/tls/ca.crt peer chaincode install -n polltest -v 1.0 -p github.com/chaincode -l golang"
sleep .5s

echo "*****INSTANTIATE THE CHAINCODE ON THE CHANNEL*****"
docker exec -ti cli sh -c "peer chaincode instantiate -o orderer.pollschain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/pollschain.com/orderers/orderer.pollschain.com/msp/tlscacerts/tlsca.pollschain.com-cert.pem -C pollschainchannel -n polltest -v 1.0 -c '{\"Args\":[\"Init\"]}' -P \"OR ('Org1MSP.member')\""
sleep .5s


echo "*****LIST OF CONTAINERS IN THE NETWORK******"
docker ps
