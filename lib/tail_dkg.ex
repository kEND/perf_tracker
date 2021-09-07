defmodule TailDkg do
  @moduledoc """
  Contains function(s) for determining election results
  from validator console.log lines.
  """

  @doc """
  Given a set of lines, do any of them indicate
  we are elected?

        if String.match?(h, ~r/not in DKG this round/) do
          elected?(tail, false)
        end

        if String.match?(h, ~r/Preparing to run DKG/) do
          elected?(tail, true)
        end
  ## Examples

    iex> TailDkg.elected?([])
    false

    iex> TailDkg.elected?(["2093 oe8 not in DKG this round yo", "2093 oe8 not a match theunahoe", "2093 oe8 " <> "Preparing to run DKG" <> " theunahoe"])
    true

    iex> TailDkg.elected?(["2093 oe8 " <> "Preparing to run DKG" <> " theunahoe", "2093 oe8 not a match theunahoe", "2093 oe8 not a match theunahoe"])
    true

    iex> TailDkg.elected?(["2093 oe8 " <> "Preparing to run DKG" <> " theunahoe", "2093 oe8 not a match theunahoe", "2093 oe8 not in DKG this round yo"])
    false

    iex> TailDkg.elected?(["2093 oe8 not in DKG this round yo", "2093 oe8 not a match theunahoe"])
    false

  """
  def elected?(lines, in_election \\ false) do
    case lines do
      [h | tail] ->
        in_election = election_line(h, in_election)
        elected?(tail, in_election)
      [] ->
        in_election
    end
  end

  defp election_line(line, in_election) do
    in_election = String.match?(line, ~r/Preparing to run DKG/) || in_election  # true remains true or false becomes true
    in_election = if String.match?(line, ~r/not in DKG this round/), do: false, else: in_election # sets to false or let's it pass
    in_election
  end
end
