use Mix.Config
config :fishing_spot, FishingSpot.Repo,
    pool: Ecto.Adapters.SQL.Sandbox,
    adapter: Ecto.Adapters.Postgres,
    database: "fishing_spot",
    username: "postgres",
    password: ""
