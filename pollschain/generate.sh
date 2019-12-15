#create crypto-config file
../bin/cryptogen generate --config=./base/crypto-config.yaml



#create genesis block file
../bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block


#Create Channel file
../bin/configtxgen -profile pollschainchannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID pollschainchannel


#Create anchor peer file
../bin/configtxgen -profile pollschainchannel -outputAnchorPeersUpdate ./channel-artifacts/Org1Anchor.tx -channelID pollschainchannel -asOrg Org1MSP
