// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TCH8OZ is ERC20 {
    error onlyProtocolAddressError();
    error protocolCannotBeZeroAddress();

    string private T_name;
    string private T_symbol;
    address public immutable protocol;

    modifier onlyProtocol() {
        if (msg.sender != protocol) {
            revert onlyProtocolAddressError();
        }
        _;
    }

    constructor(string memory _name, string memory _symbol, address _protocol) ERC20(_name, _symbol) {
        if (_protocol == address(0)) revert protocolCannotBeZeroAddress();
        T_name = _name;
        T_symbol = _symbol;
        protocol = _protocol;
    }

    function mint(address minter, uint256 amountToMint) public onlyProtocol {
        _mint(minter, amountToMint);
    }

    function burn(address account, uint256 amountToBurn) public onlyProtocol {
        _burn(account, amountToBurn);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function name() public view override returns (string memory) {
        return T_name;
    }

    function symbol() public view override returns (string memory) {
        return T_symbol;
    }

    // Example hook for later: let the protocol update the name/symbol
    function setName(string memory _name) public onlyProtocol {
        T_name = _name;
    }

    function setSymbol(string memory _symbol) public onlyProtocol {
        T_symbol = _symbol;
    }
}
