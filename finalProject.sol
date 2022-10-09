//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract finalProject{

    address public owner;
    uint public balance = 5;
    uint public transactionFee =  1;

    struct projectDetails{
        string projectName;
        bool completed;
    }

    projectDetails[] public project;

    constructor(){
        owner = msg.sender;
    }

    receive() payable external{
        balance += msg.value;
    }

    modifier mustBeOwner{
        require(owner == msg.sender, "You Are Not The Owner");
        _;
    }

    function createNewProject(string calldata _projectName) external mustBeOwner{
        require(balance >= transactionFee, "Unsifficient Balance For This Transaction");
        project.push(projectDetails({
            projectName : _projectName,
            completed : false
        }));
        balance -= transactionFee;
    }

    function updateProject(uint _index, string calldata _projectName) external mustBeOwner{
        require(balance >= transactionFee, "Unsifficient Balance For This Transaction");
        project[_index].projectName = _projectName;
        balance -= transactionFee;
    }

    function getProject(uint _index) external view returns(string memory, bool){
        projectDetails memory _project = project[_index];
        return (_project.projectName, _project.completed);
    }
    
    function toggleCompleted(uint _index) external mustBeOwner{
        project[_index].completed = !project[_index].completed;
    }

    event sendTheProject(address indexed _from, address indexed _to, string message);

    function sendTheProjectToAnotherAddress(address _to, uint _index) external mustBeOwner{
        string storage message = project[_index].projectName;
        emit sendTheProject(msg.sender, _to, message);
    }

}