defmodule FishingSpot.FishLanded do
  use Ecto.Model

  schema "fish_landed" do
    timestamps
    field :date_and_time,    :datetime
    field :weight,           :decimal
    field :length,           :decimal

    belongs_to :person,      Person
    belongs_to :location,    Location
    belongs_to :fly_type,    FlyType
  end
end
