pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

contract Certify
{
	event OrgCreated(address _from, Org addr);
	event UserCreated(address _from, User addr);

	mapping(address => User) public allUsers;
	mapping(address => Org) public allOrgs;

	string public testWord;

	// Constructor
	function Certify() public 
	{
        testWord = "Blockchain at UCI";
    }

    // For testing purposes
    function setTestWord() public returns (string)
    {
    	testWord = "HI";
    }
    
    // For testing purposes
    function viewTestWord() public view returns (string)
    {
        return testWord;
    }
    
    // get name of user based on address
    function viewUsersName(address identifier) public view returns (string)
    {
        return allUsers[identifier].getName();
    }
    
    // view the addresses of the certificates the user ownes
    // <param name=identifier> The address of the User creator. (Uses AllUsers mapping to get User object) <param/>
    function viewUsersCertificates(address identifier) public view returns (Certification[])
    {
        return allUsers[identifier].getCertifications();
    }
    
    // function viewUsersCertificateNames(address identifier) public view returns (string[])
    // {
    //     string[] names;
    //     for(uint i = 0; i < allUsers[identifier].getCertifications().length; i++)
	   //  {
	   //      names.push(allUsers[identifier].getCertifications()[i].getName());
	   //  }
	   //  return names;
    // }

    // view the names of the certificates the user owns
    // <param name=user> The address of the User object <param/>
    function viewUsersCertificateNames(User user) public view returns (string[])
    {
        string[] names;
        for(uint i = 0; i < user.getCertifications().length; i++)
	    {
	        names.push(user.getCertifications()[i].getName());
	    }
	    return names;
    }

	// identifier is either a address or a username
	// We'll only use address for now but later add if statement to differentiate
	function searchForUser(address identifier) returns (User)
	{
		return allUsers[identifier];
	}

	// When user creates an account
	// Only function that Users call
	// Creates an event so that we get the address
	function createNewUser(string _name, string _username) returns (address)
	{
		User user = new User(_name, _username);
		allUsers[msg.sender] = user;
		UserCreated(msg.sender, user);
	}

	// When an organization creates a new organization
	// Creates an event so that we get the address
	function createNewOrg(string _name) returns (Org)
	{
		Org org = new Org(_name, msg.sender);
		allOrgs[msg.sender] = org;
		OrgCreated(msg.sender, org);
	}

	// get the actual User object from an address
	function getUser(address user_address) returns (User)
	{
		return allUsers[user_address];
	}

	// get the actual Org object from an address
	function getOrg(address org_address) public view returns (Org)
	{
		return allOrgs[org_address];
	}

	// get the Org that belongs to the msg.sender address
	function getCurrentOrg() public view returns (Org)
	{
		return getOrg(msg.sender);
	}
	
	function getUserFromAddress(address identifier) public view returns (User)
	{
	    return allUsers[identifier];
	}

}

contract User 
{
	string name;
	string username;
	Certification[] certificationsRecieved;
	
	function getName() public view returns (string)
	{
	    return name;
	}

	function User(string _name, string _username) public
	{
		name = _name;
		username = _username;
	}

	// return the certification addresses that User holds
	function getCertifications() returns (Certification[])
	{
		return certificationsRecieved;
	}

	// add a certification to list of certifications recieved
	function addToCertificationsRecieved(Certification certificate) 
	{
		certificationsRecieved.push(certificate);
	}

}

contract Org
{
	string name;
	
	// address of the creator of the org
	address addressBelongsTo;
	Certification[] certificationsOwned;

	function Org(string _name, address _addressBelongsTo) public
	{
		name = _name;
		addressBelongsTo = _addressBelongsTo;
	}

	// Get the address of the creator of the org.
	function getAddressBelongsTo() returns (address)
	{
		return addressBelongsTo;
	}

	// 
	function createNewCertificate(string _name, string _description)
	{
	   // require(msg.sender == addressBelongsTo);
		Certification certificate = new Certification(_name, _description, addressBelongsTo);
		certificationsOwned.push(certificate);
	}

	function linkUserWithCertificate(User user, Certification certificate)
	{
	   // require(msg.sender == addressBelongsTo);
	    // need to require that the certification is in the org's certificationsOwned
	    //require(ownsCertification(certificate));
		user.addToCertificationsRecieved(certificate);
		certificate.addToRecievers(user);
	}
	
	// determine if certification is inside certificationsOwned
	function ownsCertification(Certification certificate) returns (bool)
	{
	    for (uint i = 0; i < certificationsOwned.length; i++)
	    {
	        if (certificationsOwned[i] == certificate)
	        {
	            return true;
	        }
	    }
	    return false;
	}
	
	// View the first certificate the org ownes
	function viewFirstCertificate() public view returns (Certification)
	{
	    return certificationsOwned[0];
	}
	
	// returns list of all certificates org ownes
	function viewAllCertificates() public view returns (Certification[])
	{
	    return certificationsOwned;
	}

	function viewSpecificCertificate(uint index) public view returns (Certification)
	{
		return certificationsOwned[index];
	}

}

contract Certification
{
	string name;
	string description;
	address addressOrgBelongsTo;
	User[] recievers;

	function Certification(string _name, string _description, address _addressOrgBelongsTo) public
	{
		name = _name;
		description = _description;
		addressOrgBelongsTo = _addressOrgBelongsTo;
	}

	// add user to list of people who have recieved certificate
	function addToRecievers(User user)
	{
		//require(msg.sender == addressOrgBelongsTo);
		recievers.push(user);
	}
	
	function getName() public view returns (string)
	{
	    return name;
	}
}

