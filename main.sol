// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Twitter{

    uint16 public MAX_TWEET_LENGTH = 300;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;

    address public owner;


    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetID, uint256 newLikeCount);
    event TweetUnLiked(address unliker, address tweetAuthor, uint256 tweetID, uint256 newLikeCount);


    constructor() {
        owner = msg.sender;
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner !");
        _;
    }


    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }


    function createTweet(string memory _tweet) public {

        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Out of character");

        Tweet memory newTweet = Tweet({
            id : tweets[msg.sender].length,
            author : msg.sender,
            content : _tweet,
            timestamp : block.timestamp,
            likes : 0
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }


    function likeTweets(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }


    function unlikeTweets(address author, uint256 id) external {
       require(tweets[author][id].id == id, "Tweet does not exist");
       require(tweets[author][id].likes > 0, "Tweet has no likes");

        tweets[author][id].likes--; 

        emit TweetUnLiked(msg.sender, author, id, tweets[author][id].likes);
    }


    function getTweet(uint _i) public view returns(Tweet memory) {
       return tweets[msg.sender][_i];    
    }


    function getAllTweets(address _owner) public view returns(Tweet[] memory) {
        return tweets[_owner];
    }
}