pragma solidity ^0.4.2;

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
		Org org = new Org(_name);
		allOrgs[msg.sender] = org;
	}

	function getUser(address user_address) returns (User)
	{
		return allUsers[user_address];
	}

	function getOrg(address org_address) returns (Org)
	{
		return allOrgs[org_address];
	}

	function getCurrentOrg() returns (Org)
	{
		return getOrg(msg.sender);
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
	Certification[] certificationsOwned;

	function Org(string _name) public
	{
		name = _name;
	}

	function createNewCertificate(string _name, string _description)
	{
		Certification certificate = new Certification(_name, _description);
		certificationsOwned.push(certificate);
	}

	function linkUserWithCertificate(User user, Certification certificate)
	{
		user.addToCertificationsRecieved(certificate);
		certificate.addToRecievers(user);
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
}

