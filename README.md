# card_game

## Description:
   A game is played with a card-list and a goal. The player has a list of held-cards, initially empty.  The player makes a move by either drawing, which means removing the first card in the card-list from the card-list and adding it to the held-cards, or discarding, which means choosing one of the held-cards to remove.  The game ends either when the player chooses to make no more moves or when the sum of the values of the held-cards is greater than the goal. The objective is to endthe game with a low score (0 is best).  Scoring works as follows:  Let sum be the sum of the values of the held-cards. If
sum is greater than goal, the preliminary score is three times (sum−goal), else the preliminary score is (goal−sum). The score is the preliminary score unless all the held-cards are the same color, in which case the score is the preliminary score divided by 2 (and rounded down as usual with integer division)
