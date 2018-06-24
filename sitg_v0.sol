// pragma solidity;

// Skin In The Game
// Risk=Reward
// Decentralized accountability
// Actions, not words and opinions
// Stake your word

// SITGv0, 2018-06-24 oskarth
// Inspired by DominantAssuranceContract, dominant.sol

// Assumes repeated games with funders, alt blind evaluation

// Can optionally do reverse operation, fund first with specific commit string
// Or this can be part of a 'signals' package with rough funding indicators

// Can do this on Telegram etc too, I'll do X general contribution

// Optionally do partial payout at campaign goal (later)

// sitg(stake, hash) - cli/slack/status/etc.
// Imagine starting a week with this.

// Optionally titrate where both funder and owner can sign modification
// Imagine big project lots of money but then you break it down after
// So you can titrate this and say "this part will be fulfilled here, at the same time remove that pledge from bigger project". So we can gradually refine the deal.

// Ideally stake happens iff it is funded
// Ideally fund goal is price discovered, not static

// Can provide cryptographic proof that you are ok foregoing 20% of your salary in exchange for partaking in a specific pool that values work up to 30-40% of average salary, so you trade volatility 0..40. Similar pool for 100% of salary where variability is 0..150-200%. Does this make sense? Reasoning a bit iffy. Want to capture 100% (stable salary) 80% (some bets) 50% (fiddy-fiddy) 20% (basic income) 0% (all-in) commitment though, probably.

// Like challenging someone/something to a duel

contract SITG_v0 {
  address owner;
  bytes32 precommitment; // hash of the commitment text
  uint256 deadline;
  bool done;
  string details; // link to non cryptographic human readable gist or so
  
  constructor() {
    owner = msg.sender;
    done = false;
  }

  // sha1("Oskar commits to XXX by YY date with ZZ attributes.") => precommitment
  function precommit(uint256 _stake, bytes32 _precommitment, uint256 deadline, string _details) payable {
    // Optionally make this a percent with a dynamic? hidden? cap
    require(msg.value == _stake, "The amount is incorrect.");
    stake = _stake;
    precommitment = _precommitment;
    deadline = _deadline;
    details = _details;
  }

  function pledge(uint256 amount) payable {
    // Optionally set campaignDeadline, interacts with stake, req?
    // Optionally more than one funders
    require(msg.value == amount, "The amount is incorrect.");
    require(msg.sender != owner, "The owner cannot pledge.");
    balanceOf[owner] += amount;
    funder = msg.sender;
  }

  function markAsDone() {
    // Optionally delegate to evaluation function
    require(msg.sender == funder, "Only funder can mark as done.");
    done = true;
  }

  function getRefund() {
    // Optionally separate campaign deadline with DCA style for multi-funders
    require(now >= deadline, "Work still in progress.");
    require((msg.sender == funder) || (funder == null), "Only funder can get refund, unless there is no funder after the deadline.");
    msg.sender.transfer(address(this).balance);
  }

  function claimFunds() {
    require(done, "Work not done yet.");
    require(msg.sender == funder, "Only owner can claim funds.");
    msg.sender.transfer(address(this).balance);
  }
}
