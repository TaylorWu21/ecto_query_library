defmodule FishingSpot.Queries do
  alias FishingSpot.Repo
  alias FishingSpot.FishLanded

  import Ecto.Query

  def biggest_fish do
    Repo.one(
      from fish in FishLanded,
      select: max(fish.length)
    )
  end

  def fishy_fish do
    Repo.all(
      from fish in FishLanded,
      where: fish.length > 24
    )
  end

  def fishy_fish_count do
    Repo.all(
      from fish in FishLanded,
      select: count(fish.id),
      where: fish.length > 24
    )
  end

  def biggest_fish_per_fisherman do
    Repo.all(
      from fish in FishLanded,
      join: fisherman in assoc(fish, :fisherman),
      group_by: fisherman.name,
      select: [max(fish.length), fisherman.name]
    )
  end

  def biggest_fish_per_fisherman_ordered do
    Repo.all(
      from fish in FishLanded,
      join: fisherman in assoc(fish, :fisherman),
      group_by: "fisherman",
      order_by: fisherman.name,
      select: %{biggest_fish: max(fish.length), fisherman: fisherman.name}
    )
  end

  def biggest_fish_per_fisherman_two_queries do
    Repo.all(
      from fish in FishLanded,
      join: fisherman in assoc(fish, :fisherman),
      where: fish.length == ^biggest_fish, 
      select: [fish.length, fisherman.name]
    )
  end

  def biggest_fish_catcher do
    Repo.all(
      from fish in FishLanded,
      left_join: bigger_fish in FishLanded, on: fish.length < bigger_fish.length,
      join: fisherman in assoc(fish, :fisherman),
      where: is_nil(bigger_fish.id),
      select: [fish.length, fisherman.name]
    )
  end

  def biggest_fish_catcher_in_clause do
    Repo.all(
      from fish in FishLanded,
      join: fisherman in assoc(fish, :fisherman),
      where: fragment(
          "? IN (SELECT MAX(biggest_fish.length) FROM fish_landed biggest_fish)", fish.length
        ),
      select: [fish.length, fisherman.name]
    )
  end

  def biggest_fish_details do
    Repo.one(
      from fish in FishLanded,
      join: fly_type in assoc(fish, :fly_type),
      join: fish_species in assoc(fish, :fish_species),
      join: fisherman in assoc(fish, :fisherman),
      join: trip in assoc(fisherman, :trips),
      join: locations in assoc(trip, :locations),
      join: location_types in assoc(locations, :location_type),
      where: fragment(
        "? IN (SELECT MAX(biggest_fish.length) FROM fish_landed biggest_fish)", fish.length
      ),
      where: fish.date_and_time >= trip.start_date,
      where: fish.date_and_time <= date_add(trip.end_date, 1, "day"),
      select: %{
        length: fish.length,
        date_caught: fish.date_and_time,
        fish_type: fish_species.name,
        fly: fly_type.name,
        fisherman: fisherman.name,
        trip_start: trip.start_date,
        trip_end: trip.end_date,
        location: locations.name,
        location_type: location_types.name
      })
  end
end
