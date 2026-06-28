"""
Tic Tac Toe with Minimax and Alpha-Beta Pruning
------------------------------------------------
A console-based Tic Tac Toe game where the AI player decides its moves
using the minimax algorithm enhanced with alpha-beta pruning.

Supports:
    1) Human vs Computer  (adjustable AI search depth)
    2) Computer vs Computer (adjustable search depth for both sides)

Scoring used by the AI:
    +10  -> AI wins
    -10  -> Opponent wins
      0  -> Draw / no result yet
"""

import math

EMPTY = ' '
PLAYER_X = 'X'
PLAYER_O = 'O'
BOARD_SIZE = 3

# All winning index combinations for a 3x3 board (rows, columns, diagonals)
WIN_COMBOS = [
    (0, 1, 2), (3, 4, 5), (6, 7, 8),   # rows
    (0, 3, 6), (1, 4, 7), (2, 5, 8),   # columns
    (0, 4, 8), (2, 4, 6),              # diagonals
]


def print_board(board):
    """Prints the 3x3 board to the console in a readable grid form."""
    print()
    for row in range(3):
        cells = board[row * 3: row * 3 + 3]
        line = " " + " | ".join(c if c != EMPTY else " " for c in cells)
        print(line)
        if row < 2:
            print("---+---+---")
    print()


def get_winner(board):
    """Returns 'X' or 'O' if there is a winner on the board, else None."""
    for a, b, c in WIN_COMBOS:
        if board[a] != EMPTY and board[a] == board[b] == board[c]:
            return board[a]
    return None


def is_full(board):
    """True if there are no empty cells left."""
    return EMPTY not in board


def is_game_over(board):
    """Game ends when someone has won or the board is full (draw)."""
    return get_winner(board) is not None or is_full(board)


def get_opponent(player):
    """Returns the other player's symbol."""
    return PLAYER_O if player == PLAYER_X else PLAYER_X


def get_empty_cells(board):
    """Returns a list of indices of all empty cells."""
    return [i for i, val in enumerate(board) if val == EMPTY]


def evaluate_board(board, player):
    """
    Scores a terminal/near-terminal board from the perspective of `player`
    (the AI seat we are computing a move for).
        +10 if `player` has won
        -10 if the opponent has won
          0 otherwise (draw or non-terminal)
    """
    winner = get_winner(board)
    if winner == player:
        return 10
    if winner == get_opponent(player):
        return -10
    return 0


def minimax(board, depth, alpha, beta, maximizing_player, player):
    """
    Minimax with alpha-beta pruning.

    board             -> current board state
    depth             -> remaining search depth (limits how far ahead the AI looks)
    alpha, beta       -> pruning bounds
    maximizing_player -> True if it's `player`'s (the AI's) turn to move here,
                          False if it's the opponent's turn
    player            -> the symbol the AI is computing the best move for
    """
    score = evaluate_board(board, player)

    # Terminal states: someone already won
    if score == 10 or score == -10:
        return score

    # Draw, or we've run out of search depth
    if is_full(board) or depth == 0:
        return 0

    if maximizing_player:
        best = -math.inf
        for cell in get_empty_cells(board):
            board[cell] = player
            value = minimax(board, depth - 1, alpha, beta, False, player)
            board[cell] = EMPTY
            best = max(best, value)
            alpha = max(alpha, best)
            if beta <= alpha:
                break  # beta cut-off
        return best
    else:
        best = math.inf
        opponent = get_opponent(player)
        for cell in get_empty_cells(board):
            board[cell] = opponent
            value = minimax(board, depth - 1, alpha, beta, True, player)
            board[cell] = EMPTY
            best = min(best, value)
            beta = min(beta, best)
            if beta <= alpha:
                break  # alpha cut-off
        return best


def make_ai_move(board, player, depth):
    """
    Picks and plays the best move for `player` on `board`, searching up to
    `depth` plies ahead using minimax + alpha-beta pruning.
    Returns the index of the cell that was played (or None if no move was possible).
    """
    best_score = -math.inf
    best_move = None

    for cell in get_empty_cells(board):
        board[cell] = player
        score = minimax(board, depth - 1, -math.inf, math.inf, False, player)
        board[cell] = EMPTY

        if score > best_score:
            best_score = score
            best_move = cell

    if best_move is not None:
        board[best_move] = player

    return best_move


def get_human_move(board):
    """Prompts the human for a move (1-9, left-to-right/top-to-bottom) and validates it."""
    while True:
        raw = input("Enter your move (1-9): ").strip()
        if not raw.isdigit():
            print("Please enter a number between 1 and 9.")
            continue
        move = int(raw) - 1
        if move < 0 or move > 8:
            print("Please enter a number between 1 and 9.")
            continue
        if board[move] != EMPTY:
            print("That cell is already taken. Try again.")
            continue
        return move


def ask_depth(prompt_text):
    """Asks for a search depth between 1 and 9, defaulting to 9 (perfect play) on bad input."""
    raw = input(prompt_text).strip()
    if raw.isdigit() and 1 <= int(raw) <= 9:
        return int(raw)
    print("Invalid input, defaulting to depth 9 (optimal play).")
    return 9


def announce_result(board, names):
    """Prints the final result of the game using the provided name mapping."""
    winner = get_winner(board)
    if winner:
        print(f"Game over: {names[winner]} ({winner}) wins!")
    else:
        print("Game over: It's a draw!")


def play_human_vs_computer():
    board = [EMPTY] * 9

    human = input("Choose your symbol, X or O (X moves first): ").strip().upper()
    while human not in (PLAYER_X, PLAYER_O):
        human = input("Please type X or O: ").strip().upper()
    computer = get_opponent(human)

    depth = ask_depth("Set the computer's search depth (1-9, 9 = perfect play): ")

    names = {human: "You", computer: "Computer"}
    current = PLAYER_X
    print_board(board)

    while not is_game_over(board):
        if current == human:
            print(f"Your turn ({human}).")
            move = get_human_move(board)
            board[move] = human
        else:
            print(f"Computer's turn ({computer}), thinking...")
            make_ai_move(board, computer, depth)
        print_board(board)
        current = get_opponent(current)

    announce_result(board, names)


def play_computer_vs_computer():
    board = [EMPTY] * 9

    depth_x = ask_depth("Set search depth for Player X (1-9): ")
    depth_o = ask_depth("Set search depth for Player O (1-9): ")

    names = {PLAYER_X: "Player X", PLAYER_O: "Player O"}
    current = PLAYER_X
    print_board(board)

    while not is_game_over(board):
        depth = depth_x if current == PLAYER_X else depth_o
        print(f"{names[current]}'s turn ({current}), thinking...")
        make_ai_move(board, current, depth)
        print_board(board)
        current = get_opponent(current)

    announce_result(board, names)


def play_game():
    print("=== Tic Tac Toe: Minimax with Alpha-Beta Pruning ===")
    while True:
        print("\n1. Human vs Computer")
        print("2. Computer vs Computer")
        print("3. Quit")
        choice = input("Choose a mode: ").strip()

        if choice == '1':
            play_human_vs_computer()
        elif choice == '2':
            play_computer_vs_computer()
        elif choice == '3':
            print("Thanks for playing!")
            break
        else:
            print("Invalid choice, please enter 1, 2, or 3.")


if __name__ == "__main__":
    play_game()