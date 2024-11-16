defmodule SentiGraph.Repo do
  use Ecto.Repo,
    otp_app: :sentigraph,
    adapter: Ecto.Adapters.Postgres
end
