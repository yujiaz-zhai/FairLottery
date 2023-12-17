import "./User.sol";
import "./ShuangSeQiu.sol";
pragma solidity ^0.5.2;
contract Main{
    User user;
    constructor () public {
        user = new User();
    }
    uint lid = 0; // Lottery id
    mapping(address => bool) public ifRegister;
    mapping(uint => address) public lotteryMap;

    // Lottery Function
    function _createLottery(uint _oneBetPrice, uint _bonusPool) public returns(string memory){
        if(lid == 0){
            lid += 1;
            uint timestamp = now;
            lotteryMap[lid] = address(new ShuangSeQiu(lid, _oneBetPrice, _bonusPool, timestamp));
            return "Lottery Create Success";
        }else{
            ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[lid]);
            require(ssq._ifDraw(), "Still exists Lottery without Drawing");
            lid += 1;
            uint timestamp = now;
            lotteryMap[lid] = address(new ShuangSeQiu(lid, _oneBetPrice, _bonusPool, timestamp));
            return "Lottery Create Success";
        }
        
    }
    function _getLotteryInfoById(uint _lid) public view returns(uint, bool, bool, uint, uint, uint, uint){
        ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[_lid]);
        return ssq._getLotteryInfoById(_lid);
    }
    function _generateWinningNumbers(uint _lid) public returns(string memory){
        ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[_lid]);
        string memory res = ssq._generateWinningNumbers();
        return res;
    }
    function _getWinningNumbers(uint _lid) public view returns(string memory){
        ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[_lid]);
        string memory res = ssq._getWinningNumbers();
        return res;
    }
    function _BuyTicket(uint _lid, uint bets, uint[] memory ticketNumber) public returns(string memory){
        require(ifRegister[msg.sender] == true, "User not register");
        require(lotteryMap[_lid] != address(0), "Lottery not exists");
        require(bets > 0, "Bets must be greater than 0");
        ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[_lid]);
        string memory res = ssq._BuyTicket(msg.sender, bets, ticketNumber);
        return res;
    }
    function _getTicketInfo(uint _lid) public view returns(string memory){
        ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[_lid]);
        return ssq._getTicketInfo(msg.sender);
    }

    function _DrawLottery(uint _lid) public returns(string memory){
        ShuangSeQiu ssq = ShuangSeQiu(lotteryMap[_lid]);  
        bool res = ssq._findWinner();
        if(res == true) return  "Winner Winner Chicken Dinner";
        else return "Better Next Time";            
    }
       




    // User Function 
    function _getUserSum() public view returns(uint){
        return user._getUserSum();
    }

    function _userRegister(string memory name) public returns(string memory){
        ifRegister[msg.sender] = true;
        string memory res = user._userRegister(msg.sender, name);
        return res;
    }
    function _getUserInfo() public view returns(uint, string memory, bool, uint){
        return user._getUserInfo(msg.sender);
    }

    function _addBalance(uint amount) public returns(string memory){
        string memory res = user._addBalance(msg.sender, amount);
        return res;
    }

    function _sayHello() public view returns(string memory){
        return user._sayHello();
    }
}