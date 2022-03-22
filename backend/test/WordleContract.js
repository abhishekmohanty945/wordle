const WordleContract = artifacts.require('WordleContract.sol');

contract('WordleContract', accounts => {
    [user, _] = accounts;

    it('should check if word is valid', async () => {
        const wordle = await WordleContract.new(user);
        await wordle.assign();
        var valid_word = await wordle.attempts("route");
        // console.log(valid_word.logs[0].args[0]);
        console.log(valid_word.logs[0].args[0])
        assert(valid_word.logs[0].args[0] === '11111');
    })

    // it('should check if letter is in the word', async () => {
    //     const wordle = await WordleContract.new(user);
    //     var letter_in_word = await wordle.is_letter_in_word('r', "route");
    //     assert(letter_in_word == true);
    // })
});