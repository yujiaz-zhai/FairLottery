pragma solidity ^0.5.2;
import "./Lottery.sol";
contract ShuangSeQiu is Lottery{
    uint[] public winningNumbers;
    uint private nonce = 0;
    constructor(uint _id, uint _oneBetPrice, uint _bonusPool, uint timestamp) public {
        id = _id;
        oneBetPrice = _oneBetPrice;
        ifWin = false;
        ifDraw = false;
        BonusPool = _bonusPool;
        TotalBet = 0;
        timestamp = timestamp;
    }
    
    function uintToString(uint v) internal pure returns (string memory str) {
        if (v == 0) {
            return "0";
        }
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i); // 不需要 i + 1
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1];
        }
        return string(s);
    }
    function strCat(string memory a, string memory b) internal pure returns (string memory) {
        bytes memory bytesA = bytes(a);
        bytes memory bytesB = bytes(b);
        string memory concatenatedString = new string(bytesA.length + bytesB.length);
        bytes memory bytesConcatenated = bytes(concatenatedString);
        uint k = 0;
        for (uint i = 0; i < bytesA.length; i++) {
            bytesConcatenated[k++] = bytesA[i];
        }
        for (uint i = 0; i < bytesB.length; i++) {
            bytesConcatenated[k++] = bytesB[i];
        }
        return string(bytesConcatenated);
    }
    function _ifDraw() public returns (bool){
        return ifDraw ? true : false;
    }

    function _generateRandomNumber() public returns(uint){
        nonce++;
        uint random = uint(keccak256(abi.encodePacked(now, msg.sender, block.number, nonce))) % 100;
        return random;
    }

    function _getLotteryInfoById(uint id) public view returns(uint, bool, bool, uint, uint, uint, uint){
        return (id, ifWin, ifDraw, oneBetPrice, BonusPool, TotalBet, timestamp);
    }

    function _generateWinningNumbers() public returns(string memory){
        require(winningNumbers.length == 0, "Winning Numbers already exists");
        for(uint i = 0; i < 7; i++){
            uint random = _generateRandomNumber();
            winningNumbers.push(random);
        }
        return "Generate Winning Numbers Success";
    }

    function _getWinningNumbers() public view returns(string memory){
        string memory winningNumbersStr = "Red: ";
        for(uint i = 0; i < 7; i++){
            if(i == 6){
                winningNumbersStr = strCat(winningNumbersStr, "Blue: ");
            }
            winningNumbersStr = strCat(winningNumbersStr, uintToString(winningNumbers[i]));
            winningNumbersStr = strCat(winningNumbersStr, " ");
        }
        return winningNumbersStr;
    }

    function _BuyTicket(address _useraddr, uint bets, uint[] memory ticketNumber) public returns(string memory){
        allTicketInfo.push(AllTicketInfo(_useraddr, bets, ticketNumber));
        return "BuyTicket Success";
    }
    
    function _getTicketInfo(address _useraddr) public view returns (string memory){
        string memory ticketInfo = "";
        for(uint i = 0; i < allTicketInfo.length; i++){
            if(allTicketInfo[i].owner == _useraddr){
                ticketInfo = strCat(ticketInfo, " Your Number: (Red Ball) ");
                for(uint j = 0; j < allTicketInfo[i].ticketNumber.length - 1; j++){
                    ticketInfo = strCat(ticketInfo, uintToString(allTicketInfo[i].ticketNumber[j]));
                }
                ticketInfo = strCat(ticketInfo, "(Blue Ball) ");
                ticketInfo = strCat(ticketInfo, uintToString(allTicketInfo[i].ticketNumber[allTicketInfo[i].ticketNumber.length - 1]));
            }
        }
        return ticketInfo;
    }
    function _findWinner() public returns(bool){
        ifDraw = true;
        uint matchs = 0;
        for(uint i = 0; i < allTicketInfo.length; i++){
            matchs = 0;
            for(uint j = 0; j < allTicketInfo[i].ticketNumber.length; j++){
                if(allTicketInfo[i].ticketNumber[j] == winningNumbers[j]) matchs++;
            }
            if(matchs == winningNumbers.length){
                ifWin = true;
                winnerList.push(Winner(allTicketInfo[i].owner, allTicketInfo[i].bets));
            }
        }
        return ifWin;
    }
}