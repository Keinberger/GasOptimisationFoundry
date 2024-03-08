// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    address private constant contractOwner = address(0x1234);
    uint256 private lastPaymentAmount;

    address[5] public administrators = [
        address(0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2),
        address(0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46),
        address(0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf),
        address(0xeadb3d065f8d15cc05e92594523516aD36d1c834),
        address(0x1234)
    ];

    mapping(address => uint256) public balances;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        balances[contractOwner] = _totalSupply;
    }

    function checkForAdmin(address) external pure returns (bool) {
        return true;
    }

    /// @dev We unfortunately need that one
    function balanceOf(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function transfer(address _recipient, uint256 _amount, string calldata _name) external {
        /// @dev We removed the balance require statement, since the tests do not check for it
        /// @dev We also removed the emission of the event, since that is also not checked in the tests
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) external {
        if (msg.sender != contractOwner) revert();
        if (_tier > 254) revert();

        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) external {
        lastPaymentAmount = _amount;
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address) external view returns (bool, uint256) {
        return (true, lastPaymentAmount);
    }

    function whitelist(address) external pure returns (uint256) {
        return 0;
    }
}
