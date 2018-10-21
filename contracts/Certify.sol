pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

contract Certify
{
	mapping(address => User) public allUsers;
	mapping(address => Org) public allOrgs;
	
	event print(string value1);

	string public testWord;

	function Certify() public 
	{
        testWord = "Blockchain at UCI";
    }

    function setTestWord() public returns (string)
    {
    	testWord = "HI";
    }
    
    function viewTestWord() public view returns (string)
    {
        return testWord;
    }
    
    function viewUsersName(address identifier) public view returns (string)
    {
        return allUsers[identifier].getName();
    }
    
    function viewUsersCertificates(address identifier) public view returns (Certification[])
    {
        return allUsers[identifier].getCertifications();
    }
    
    function viewUsersCertificateNames(address identifier) public view returns (string[])
    {
        string[] names;
        for(uint i = 0; i < allUsers[identifier].getCertifications().length; i++)
	    {
	        names.push(allUsers[identifier].getCertifications()[i].getName());
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
	function createNewUser(string _name, string _username) returns (address)
	{
		User user = new User(_name, _username);
		allUsers[msg.sender] = user;
		return msg.sender;
	}

	function createNewOrg(string _name)
	{
		Org org = new Org(_name, msg.sender);
		allOrgs[msg.sender] = org;
	}

	function getUser(address user_address) returns (User)
	{
		return allUsers[user_address];
	}

	function getOrg(address org_address) public view returns (Org)
	{
		return allOrgs[org_address];
	}

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
	
	function getName() returns (string)
	{
	    return name;
	}

	function User(string _name, string _username) public
	{
		name = _name;
		username = _username;
	}

	function getCertifications() returns (Certification[])
	{
		return certificationsRecieved;
	}

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

	function createNewCertificate(string _name, string _description)
	{
	    require(msg.sender == addressBelongsTo);
		Certification certificate = new Certification(_name, _description);
		certificationsOwned.push(certificate);
	}

	function linkUserWithCertificate(User user, Certification certificate)
	{
	    require(msg.sender == addressBelongsTo);
	    // need to require that the certification is in the org's certificationsOwned
	    require(ownsCertification(certificate));
		user.addToCertificationsRecieved(certificate);
		certificate.addToRecievers(user);
	}
	
	// determine if certification is inside certificationsOwned
	function ownsCertification(Certification certificate) returns (bool)
	{
	    for (uint i = 0; i < certificationsOwned.length; i++)
	    {
	        if (sha256(certificationsOwned[i]) == sha256(certificate))
	        {
	            return true;
	        }
	    }
	    return false;
	}
	
	function viewFirstCertificate() public view returns (Certification)
	{
	    return certificationsOwned[0];
	}
	
	function viewAllCertificates() public view returns (Certification[])
	{
	    return certificationsOwned;
	}

}

contract Certification
{
	string name;
	string description;
	User[] recievers;

	function Certification(string _name, string _description) public
	{
		name = _name;
		description = _description;
	}

	function addToRecievers(User user)
	{
		recievers.push(user);
	}
	
	function getName() returns (string)
	{
	    return name;
	}
}

