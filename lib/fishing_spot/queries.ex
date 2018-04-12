defmodule FishingSpot.Queries do
  alias FishingSpot.Repo
  alias FishingSpot.FishLanded
  alias FishingSpot.Fisherman
  alias FishingSpot.Account

  import Ecto.Query
  @moduledoc """
  Welcome to the Ecto Query Library!
  """

  @doc """
  Selects all `Fisherman` records from the database.
  """
  def all_fishermen do
    Repo.all(
      from fisherman in Fisherman
    ) |> IO.inspect

    Repo.all(
      from fisherman in Fisherman,
      select: fisherman
    ) |> IO.inspect

    # TODO: Output name and date of birth of all fishermen as a list

    # TODO: Output name and date of birth of all fishermen as a tuple

    # TODO: Output name and date of birth of all fishermen as a map
  end

  def ordered_fishermen do
    # TODO: Output names of all fishermen ordered by names

    # TODO: Output names of all fishermen ordered Z-A


    # TODO: Output names of all fishermen ordered by name and date_of_birth

  end

  def biggest_fish do
    # TODO: Output the biggest fish

    # TODO: Output biggest fish as a map with key :big_fish

  end

  def fishy_fish do
    # TODO: Output all fish whose length is greater than 24
  end

  def fisherman_by_keyword do
    {_, date} = Ecto.Date.cast("1976-01-05")

    Repo.all(
      from fisherman in Fisherman,
      where: [name: "Lew", date_of_birth: ^date]
    )

    where(Fisherman, [name: "Lew", date_of_birth: ^date]) |> Repo.all

    join(Fisherman, :inner, [], fish_landed in FishLanded)
      |> where([fisherman, fish_landed], [name: "Lew", date_of_birth: ^date, id: fish_landed.fisherman_id])
      |> Repo.all
    nil
  end

  def fishy_fish_count do
    Repo.all(
      from fish in FishLanded,
      select: count(fish.id),
      where: fish.length > 24
    )
  end

  def biggest_fish_per_fisherman do
    # TODO: Find biggest fish per fisherman, output the biggest fish size and name of the fisherman
  end

  def biggest_fish_per_fisherman_ordered do
    # TODO: Find biggest fish per fisherman ordered by the name, output it in the form %{biggest_fish: 999, fisherman: xyz}

  end

  def biggest_fish_per_fisherman_in_clause do
    # TODO: Find biggest fish per fisherman, who is either Mark or Kirk, ordered by the name, output it in the form %{biggest_fish: 999, fisherman: xyz}
  end

  def biggest_fish_per_fisherman_not_in_clause do
    # TODO: Find biggest fish per fisherman, who is NOT Mark or Kirk, ordered by the name, output it in the form %{biggest_fish: 999, fisherman: xyz}
  end

  def biggest_fish_per_fisherman_two_queries do
    [big_fish] = Repo.all(
      from fish in FishLanded,
      select: max(fish.length)
     )

    Repo.all(
      from fish in FishLanded,
      join: fisherman in assoc(fish, :fisherman),
      where: fish.length == ^big_fish,
      select: [fish.length, fisherman.name]
    )
  end

  def biggest_fish_catcher do
    # TODO: Find fisherman who caught the biggest fish, output in the form [length, name]
  end

  def fish_per_day do
    # TODO: Find number of fishes caught per day
  end

  def composed_biggest_fish_details do
    query = FishLanded
      |> join(:inner, [fish], fisherman in assoc(fish, :fisherman))
      |> join(:inner, [fish, fisherman],
              trip in assoc(fisherman, :trips))
      |> select([fish], count(fish.id))

    IO.inspect query
    Repo.all(query)
  end

  def select_associated do
    # TODO: Fetch fisherman "Mark" and the sizes of all fishes he caught
    # use preload
    query = Fisherman
      |> join(:inner, [fisherman], fish in assoc(fisherman, :fish_landed))
      |> where([fisherman], fisherman.id == 1)
      |> select([fisherman, fish], %{fisherman: fisherman, length: fish.length})
      |> preload([fisherman, fish], [fish_landed: fish])

    Repo.one(first(query)).fisherman.fish_landed |> IO.inspect
  end

  def distinct_fish_weight_with_order_by do
    # TODO: Output distinct fishes ordered by date_and_time
  end

  def biggest_fish_per_fisherman_having do
    # TODO: Find the biggest fish caught by those fishermen who caught more than 15 fishes, output like [biggest_fish_length, fisherman_name]
  end

  def all_fish_limit_10 do
    # TODO: Output top ten fishes sorted by their length
  end


  def composed_keyword_queries do
    # TODO: Create a composable query to output fisherman name, where the fish fly is a "Muddler Minnow", for fisherman "Mark" who caught fish
    # weighing heavier than 10 pounds
  end
end
