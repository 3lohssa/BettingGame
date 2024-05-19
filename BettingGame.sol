// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract BettingPool {
    struct Bet {
        address payable bettor;
        uint amount;
    }

    Bet[] public bets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function placeBet() public payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        bets.push(Bet(payable(msg.sender), msg.value));
    }

    function pickWinner() public {
        require(msg.sender == owner, "Only the owner can pick the winner");
        require(bets.length > 0, "No bets placed");

        if (bets.length == 1) {
            // If there is only one bettor, refund the bet
            Bet storage soleBettor = bets[0];
            soleBettor.bettor.transfer(soleBettor.amount);
        } else {
            // Choose a random winner
            uint winnerIndex = random() % bets.length;
            Bet storage winner = bets[winnerIndex];
            uint totalPool = address(this).balance;

            // Transfer the entire pool to the winner
            winner.bettor.transfer(totalPool);
        }

        // Reset the betting pool
        delete bets;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, bets.length)));
    }
}
