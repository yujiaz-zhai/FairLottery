pragma solidity ^0.5.2;
contract Lottery{
    uint id;
    bool ifWin;
    bool ifDraw;
    uint oneBetPrice;
    uint BonusPool;
    uint TotalBet;
    uint timestamp;
    struct AllTicketInfo{
        address owner;
        uint bets;
        uint[] ticketNumber;
    }
    struct Winner{
        address owner;
        uint bets;
    }
    AllTicketInfo[] public allTicketInfo;
    Winner[] public winnerList;
}