// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventKar{

    struct Event{
        address mc;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextid;

    function createShow(string memory name,uint date,uint price,uint ticketCount) external  {
        require(date>block.timestamp,"you can organize event for future");
        require(ticketCount>0, "abe kuch toh le bikhari");
        events[nextid] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextid++;

    }

    function buyTicket(uint id,uint howMany) external payable  {
        require(events[id].date !=0,"this event doesnt exist");
        require(events[id].date > block.timestamp,"time is already over");
        Event storage _event = events[id];
        require(msg.value==(_event.price*howMany), "not enough money");
        require(_event.ticketRemain>=howMany, "not enough tickets left");
        _event.ticketRemain-=howMany;
        tickets[msg.sender][id] += howMany;


    }

    function transferToOthers(uint id,uint howmany,address to) external {
        require(events[id].date !=0,"this event doesnt exist");
        require(events[id].date > block.timestamp,"time is already over");
        require(tickets[msg.sender][id]>=howmany, "you dont have tickets");
        tickets[msg.sender][id] -= howmany;
        tickets[to][id]+=howmany;
        
    }

    


}