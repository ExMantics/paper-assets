contract UnsafeTokenSwap {  // Swap token using ether
  IERC20 token;
  address owner;
  uint256 token_price;
  uint256 release_timestamp;

  constructor(address _token, uint256 _token_price) {
    owner = msg.sender;
    token = IERC20(_token);
    token_price = _token_price;
  }

  function set_release_time(uint256 afterTime) public {
    require(msg.sender == owner);
    release_timestamp = block.timestamp + afterTime;
  }

  function swap_tokens(uint256 amount) public payable {
    require(block.timestamp >= release_timestamp,
      "The token has not been released yet");
    require(msg.value >= token_price * amount,
      "Insufficient ETH for swap");
    require(token.balanceOf(address(this)) >= amount,
      "Insufficient tokens in contract");
    token.transferFrom(owner, msg.sender, amount);
  }

  function clear_ether() public {
    require(msg.sender == owner);
    payable(owner).transfer(address(this).balance);
  }
}
