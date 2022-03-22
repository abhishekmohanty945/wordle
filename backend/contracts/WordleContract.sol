// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract WordleContract {
    string word_of_the_day;
    string[] word_list = ["route", "stair", "eight", "boner", "seven"];
    string[] valid_words = ["route", "stair", "eight", "boner", "seven"];
    uint day = 0;
    uint attempt = 1;
    address user;
    event send_word(string _word);
    mapping(address => mapping(uint => uint)) attempts_per_day;
    
    constructor(address _user) {
        user = _user;
    }
    function assign() public {
        require(msg.sender == user, "Access Denied");
        word_of_the_day = word_list[day];
        day++;
    }
    function is_valid_word(string memory _word) public view returns (bool) {
        for(uint i = 0; i < 5; i++){
            bool check = true;
            bytes memory valid_words_list = bytes(valid_words[i]);
            for(uint j = 0; j < 5; j++){
                if(valid_words_list[i] != bytes(_word)[i]){
                    check = false;
                    break;
                }
            }
            if(check){
                return true;
            }
        }
        return false;
    }

    function is_letter_in_word(bytes1 _letter, bytes memory _word) internal pure returns(bool){
        for(uint i = 0; i < 5; i++){
            if(_word[i] == _letter){
                return true;
            }
        }
        return false;
    }

    function check_positions(string memory _word) internal view returns(string memory){
        require(is_valid_word(_word) == true, "Not a valid word");
        bytes memory valid = new bytes(5);
        bytes memory word_today = bytes(word_of_the_day);
        bytes memory entered_word = bytes(_word);
        for(uint i = 0; i < 5; i++){
            if(bytes(word_today)[i] == entered_word[i]){
                valid[i] = "1";
            }
            else if(word_today[i] != entered_word[i] && is_letter_in_word(entered_word[i], word_today)){
                valid[i] = "2";
            }
            else {
                valid[i] = "0";
            }
        }
        return string(valid);
    }

    function attempts(string memory _word) external{
        string memory output;
        if(attempts_per_day[msg.sender][day] <= 4){
            output = check_positions(_word);
            bytes memory output_bytes = bytes(output);
            bool done = true;
            for(uint i = 0; i < 5; i++){
                if(output_bytes[i] != "1"){
                    done = false;
                    break;
                }
            }
            if(done) attempts_per_day[msg.sender][day] = 5;
            attempts_per_day[msg.sender][day]++;
        }
        emit send_word(output);
        // return output;
    }
}