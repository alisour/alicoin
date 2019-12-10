package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
    "strings"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

//VERY IMPORTANT: The first letter needs to be captilized
type ballot struct {
    DocType   string  `json:"docType"`
	FirstName string  `json:"firstname"`
	LastName  string  `json:"last name"`
	BallotID  string  `json:"ballotid"`
	Decision  string  `json:"decision"`
}

// Init is called during chaincode instantiation to initialize any data.
func (t *ballot) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)

}

//invoke is for function calling 
func (t *ballot) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	// Handle different functions
	switch function {
	
	case "initCandidate":
		//create a new candidate
		return t.initCandidate(stub, args)
	case "initvote":
		//voting action
		return t.initvote(stub, args)

	default:
		//error
		fmt.Println("invoke did not find func: " + function)
		return shim.Error("Received unknown function invocation")
	}
}

func (t *ballot) initCandidate(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//  0-firstName  1-lastName

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	// ==== Input sanitation ====
	fmt.Println("- start init candidate")

	if len(args[0]) == 0 {
		return shim.Error("1st argument must be a non-empty string")
	}
	if len(args[1]) == 0 {
		return shim.Error("2nd argument must be a non-empty string")
	}

	personFirstName := strings.ToLower(args[0])
	personLastName := strings.ToLower(args[1])
	hash := sha256.New()
	hash.Write([]byte(personFirstName + personLastName)) // ballotID is created based on the person's name
	ballotID := hex.EncodeToString(hash.Sum(nil))
	voteInit := "Candidate"
    doctype := "ballot"
	
    // ==== Check if candidate already exists ====
	ballotAsBytes, err := stub.GetState(string(ballotID))
	if err != nil {
		return shim.Error("Failed to get candidate value: " + err.Error())
	} else if ballotAsBytes != nil {
		fmt.Println("This candidate already exists: " + ballotID)
		return shim.Error("This candidate already exists: " + ballotID)
	}

	// ==== Create ballot object and marshal to JSON ====
	Ballot := ballot{doctype, personFirstName, personLastName, ballotID, voteInit}
	ballotJSONByte, err := json.Marshal(Ballot)
	if err != nil {
		return shim.Error(err.Error())
	}

	//ballotID becomes the key for this tuple
	err = stub.PutState(string(ballotID), ballotJSONByte)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success([]byte(ballotID))
}

func (t *ballot) initvote(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	//  0- personID, 1-fullname 2-decision-ballotID-
	// "This is going to be passed from the client side"

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	// ==== Input sanitation ====
	fmt.Println("- start init vote")

	if len(args[0]) == 0 {
		return shim.Error("1st argument must be a non-empty string")
	}
	if len(args[1]) == 0 {
		return shim.Error("2nd argument must be a non-empty string")
	}
    if len(args[2]) == 0 {
		return shim.Error("3rd argument must be a non-empty string")
	}

    //take person id and person full name then digest a key
	personID := args[0]
	personName := strings.ToLower(args[1])
	hash := sha256.New()
	hash.Write([]byte(personID + personName)) 
    voteID := hex.EncodeToString(hash.Sum(nil))

    //take the full name of the decision then digest another key to compare
    arginit := strings.ToLower(args[2])
    hash_2 := sha256.New()
    hash_2.Write([]byte(arginit))
	voteInit := hex.EncodeToString(hash_2.Sum(nil))
    doctype  := "ballot"
	
    // ==== Check if voter already exists ====
	voterAsBytes, err := stub.GetState(string(voteID))
	if err != nil {
		return shim.Error("Failed to get voter value: " + err.Error())
	} else if voterAsBytes != nil {
		fmt.Println("This voter already exists: " + voteID)
		return shim.Error("This voter already exists: " + voteID)
	}


    // ==== Check if candidate already exists ====
	ballotAsBytes, err := stub.GetState(string(voteInit))
	if err != nil {
		return shim.Error("Failed to get candidate value: " + err.Error())
	} else if ballotAsBytes != nil {
		// ==== Create ballot object and marshal to JSON ====
	    Ballot := ballot{doctype, personID, personName, string(voteID), string(voteInit)}
	    ballotJSONByte, err := json.Marshal(Ballot)
	    if err != nil {
		    return shim.Error("Failed to get candidate value: " + string(voteInit))
	    }

	    //ballotID becomes the key for this tuple
	    err = stub.PutState(string(voteID), ballotJSONByte)
	    if err != nil {
		    return shim.Error(err.Error())
	    }

	    return shim.Success([]byte(voteID))
	}
    return shim.Error("Failed to get candidate value: " + err.Error())
}

func main() {
	if err := shim.Start(new(ballot)); err != nil {
		fmt.Printf("Error starting SimpleAsset chaincode: %s", err)
	}
}
