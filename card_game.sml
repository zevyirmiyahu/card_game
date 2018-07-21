(* Programming Languages Part A, Card Game
   Author: Zev Yirmiyahu
   Email: zy@zevyirmiyahu.com
   Website: zevyirmiyahu.com
   GitHub: https://github.com/zevyirmiyahu

*)

(* ABOUT PROGRAM: 
 A game is played with a card-list and a goal. The player has a list of held-cards, initially empty.  The player makes a move by either drawing, which means removing the first card in the card-list from the card-list and adding it to the held-cards, or discarding, which means choosing one of the held-cards to remove.  The game ends either when the player chooses to make no more moves or when the sum of the values of the held-cards is greater than the goal. The objective is to endthe game with a low score (0 is best).  Scoring works as follows:  Let sum be the sum of the values of the held-cards. If
sum is greater than goal, the preliminary score is three times (sum−goal), else the preliminary score is (goal−sum). The score is the preliminary score unless all the held-cards are the same color, in which case the score is the preliminary score divided by 2 (and rounded down as usual with integer division)
*)


(* Assume that Num is always used with values 2, 3, ..., 10
   though it will not matter *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* Returns color of card *)
fun card_color card =
    case card of
	(Spades, _) => Black
      | (Clubs, _) => Black
      | (Diamonds, _) => Red
      | (Hearts, _) => Red 

(* Returns card value *)
fun card_value card =
    case card of
	(_, Num n) => n
      | (_, Ace) => 11
      | (_, Jack) => 10
      | (_, Queen) => 10
      | (_, King) => 10

(*Returns card list with all elements except card c and raises exception e if card c is NOT in the list of cards *)
fun remove_card (cs, c, e) =
    case cs of
	[] => raise e
      | x1::[] =>
	if x1 = c then []
	else x1::remove_card([], c, e)
      | x1::x2::cs' =>
	if x1 = c then x2::cs'
	else if x2 = c then x1::cs'
	else x1::x2::remove_card(cs', c, e)

(* Takes a list of card and returns true if all cards are same color *)
fun all_same_color cardList =
    case cardList of
	[] => true
      | x1::cardList' =>
	let
	    val color = card_color(x1)
	in
	    let
		fun compare list =
		    case list of
			[] => true
		      | x::cardList'' => 
			if color <> card_color(x) then false
			else compare(cardList'')
	    in
		compare(cardList')	
	    end 
	end

		 
(*

(* Returns sum of cards using ONLY recursion *)	 
fun sum_cards cardList =
    case cardList of
	[] => 0
      | x::cardList =>
	card_value(x) + sum_cards(cardList)
*)

(* Returns sum of values of cards using tail recursion *)
fun sum_cards cardList =
    let fun aux(cardList, acc) =
	    if cardList = []
	    then acc
	    else case cardList of
		     x::cardList =>
		     aux(cardList, acc + card_value(x))
    in
	aux(cardList, 0)
    end

(* Computers the score by taking a cardList (players hand) and an int (the goal) *)
fun score (cardList : card list, goal : int) =
    let	val sum = sum_cards(cardList)
    in
	let fun aux(cardList, goal) =
		if all_same_color(cardList)
		then
		    if sum > goal then 3 * (sum - goal) div 2
		    else (goal - sum) div 2
		else if sum > goal then 3 * (sum - goal)
		else goal - sum 
	in
	    aux(cardList, goal)
	end
    end


(* Runs the game *)
fun officiate(cardList : card list, moveList : move list, goal : int) =
    let fun game_state(heldCards, cardList, moveList, goal) =
	    if sum_cards(heldCards) > goal then score(heldCards, goal)
	    else
	    case cardList of
		[] => score(heldCards, goal) 
	      | x::cardList' =>
		case moveList of
		    [] => score(heldCards, goal)
		  | y::moveList' =>
		    if y = Draw then game_state(x::heldCards, cardList', moveList', goal)
		    else
			case heldCards of
			    [] => raise IllegalMove
			 | c::heldCards' => 
			   game_state(remove_card(heldCards, c, IllegalMove), cardList, moveList', goal) 
    in
	game_state([], cardList, moveList, goal)
    end
