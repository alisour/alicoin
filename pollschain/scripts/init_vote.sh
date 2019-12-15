echo "*****CALL VOTE FUNCTION*****"

docker exec -ti cli sh -c "peer chaincode invoke -o orderer.pollschain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/pollschain.com/orderers/orderer.pollschain.com/msp/tlscacerts/tlsca.pollschain.com-cert.pem --peerAddresses peer0.org1.pollschain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.pollschain.com/peers/peer0.org1.pollschain.com/tls/ca.crt -n polltest -c '{\"Args\":[\"initvote\", \"18374629640\",\"firstvoter\", \"firstcandidate\"]}' -C pollschainchannel"
sleep .5s
