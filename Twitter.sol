//SPDX-License-Identifier: MIT

//Decentralized Social Media Project - "Blockchain Twitter"

pragma solidity ^0.8.26;

// 1. Create a Twitter contract
// 2. Create a mapping between a user and a tweet
// 3. Add function to create a tweet and save it in mapping
// 4. Create a function to get tweet
// 5. Add an array of tweets
// 6. Create a struct
// 7. Add a require statement to limit the tweet length
// 8. Add function changeTweetLength to change maximum length
// 9. Create constructor to set owner of contract
// 10. Create a modifier called onlyOwner
// 11. Use onlyOwner on the changeTweetLength function
// 12. Add id to tweet
// 13. Set the id to be the tweet length
// 14. Add function to like a tweet
// 15. Add function to unlike a tweet
// 16. Mark the functions as external
// 17. Create events for the tweet called TweetCreated and TweetLiked
// 18. Emit the events in the createTweet() and likeTweet() function
// 19. Create function getTotalLikes, to get total tweet likes
// 20. Loop over all the tweets
// 21. Sum up totalLikes
// 22. Return totalLikes

contract Twitter {
    //create events
    event TweetCreated(uint, address, string, uint);
    event TweetLiked(address, address, uint, uint);
    event TweetUnliked(address, address, uint, uint);

    //define global variables
    uint16 public MAX_TWEET_LENGTH = 280;
    address public owner;

    //define a struct
    struct Tweet {
        uint id;
        address author;
        string content;
        uint timestamp;
        uint likes;
    }

    //add mapping of user to tweet stored in an array []
    //mapping(address => string[]) public tweets;
    mapping(address => Tweet[]) public tweets;

    //specify the owner of the contract upon deployment
    constructor() {
        owner = msg.sender;
    }

    //the modifier onlyOwner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    //the changeTweetLength function
    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    //create total likes function
    function getTotalLikes(address _author) external view returns (uint) {
        uint totalLikes;

        for (uint i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }

        return totalLikes;
    }

    //function to create a tweet
    function createTweet(string memory _tweet) public {
        //tweets[msg.sender] = _tweet;

        //Condition with require statement
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long");

        //the newTweet object
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        //tweets[msg.sender].push(_tweet);
        tweets[msg.sender].push(newTweet);

        //emit event
        emit TweetCreated(
            newTweet.id,
            newTweet.author,
            newTweet.content,
            newTweet.timestamp
        );
    }

    //function to like tweet
    function likeTweet(address author, uint id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        tweets[author][id].likes++;
        //emit event
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    //function to unlike tweet
    function unlikeTweet(address author, uint id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes");
        tweets[author][id].likes--;
        //emit event
        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    //function to get a tweet
    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    //Function to get all the tweets from a user
    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
