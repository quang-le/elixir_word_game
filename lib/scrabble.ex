defmodule Scrabble do
  @moduledoc """
  An Elixir version of the famous game
  """

  def default_range do
    7
  end

  @doc """
  The board template, i.e. top-left part of the  game board
  """
  def blank_board_template(range) do
    for i <- 0..range, j <- 0..range do
      [i, j]
    end
  end

  def make_triple_word_square(x, y) do
    [x, y, :word_triple]
  end

  def make_double_word_square(x, y) do
    [x, y, :word_double]
  end

  def make_double_letter_square(x, y) do
    [x, y, :letter_double]
  end

  def make_triple_letter_square(x, y) do
    [x, y, :letter_triple]
  end

  def make_regular_square(x, y) do
    [x, y, :regular]
  end

  def make_diagonal_squares(x) do
    case x do
      0 -> make_triple_word_square(x, x)
      5 -> make_triple_letter_square(x, x)
      6 -> make_double_letter_square(x, x)
      _ -> make_double_word_square(x, x)
    end
  end

  def make_other_special_squares(x, y) do
    case x + y do
      6 -> make_triple_letter_square(x, y)
      _ -> make_double_letter_square(x, y)
    end
  end

  @doc """
  The default board template, i.e. top-left part of the classic game board
  """
  def default_board_template do
    for [x, y] <- default_range() |> blank_board_template() do
      case abs(x - y) do
        0 ->
          make_diagonal_squares(x)

        3 when x == 0 or y == 0 ->
          make_double_letter_square(x, y)

        4 when x != 0 and y != 0 ->
          make_other_special_squares(x, y)

        7 ->
          make_triple_word_square(x, y)

        _ ->
          make_regular_square(x, y)
      end
    end
  end

  def apply_x_symetry(template, x_length) do
    Enum.flat_map(template, fn square ->
      [x, y, type] = square
      [square, [2 * x_length - x, y, type]]
    end)
    |> Enum.uniq()
  end

  # I know: it reapeats previous logic
  def apply_y_symetry(template, y_length) do
    Enum.flat_map(template, fn square ->
      [x, y, type] = square
      [square, [x, 2 * y_length - y, type]]
    end)
    |> Enum.uniq()
  end

  @doc """
  Create the board. It takes an array, which defines the top left quarter of the board and generates the whole board by applying 2 consecutives axial symetries
  template_range is the the size of your board's sides/4 +1 (to account for the center which can't be replicated by symetry)
  """
  def create_board(template, template_range) do
    apply_x_symetry(template, template_range) |> apply_y_symetry(template_range)
  end

  def show_triple(board) do
    Enum.filter(board, fn [_x, _y, type] ->
      type == :letter_triple
    end)
  end

  def show_double(board) do
    Enum.filter(board, fn [_x, _y, type] ->
      type == :letter_double
    end)
  end

  @doc """
  Creates a classic scrabble board
  """
  def create_default_board() do
    default_board_template() |> create_board(default_range)
  end
end
