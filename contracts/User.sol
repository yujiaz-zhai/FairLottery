pragma solidity ^0.5.2;

contract User{
    struct User{
        uint id;
        string name;
        bool ifWiner;
        uint balance;
    }

    uint uid = 0;
    mapping(address => User) public userMap;

    function _getUserSum() public view returns(uint){
        return uid;
    }
    
    // 最后记得添加 event 事件
    function _userRegister(address _useraddr, string memory name) public returns(string memory){
        require(userMap[_useraddr].id == 0, "User already exists");
        uid += 1;
        userMap[_useraddr] = User(uid, name, false, 0);
        return "User Register Success";
    }

    function _getUserInfo(address _useraddr) public view returns(uint, string memory name, bool, uint){
        require(userMap[_useraddr].id != 0, "User not exists");
        return (userMap[_useraddr].id, userMap[_useraddr].name, userMap[_useraddr].ifWiner, userMap[_useraddr].balance);
    }

    function _addBalance(address _useraddr, uint amount) public returns(string memory){
        require(userMap[_useraddr].id != 0, "User not exists");
        userMap[_useraddr].balance += amount;
        return "Add Balance Success";
    }
    
    function _sayHello() public pure returns(string memory){
        return "Hello";
    }

}
