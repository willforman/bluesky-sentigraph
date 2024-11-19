defmodule SentiGraph.Posts do
  use GenServer

  # Client

  def start_link(args={:num_posts_to_collect, _num_posts_to_collect, :collect_posts_interval_minutes, _collect_posts_interval_minutes}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec get_next_poll_time_msec(NaiveDateTime.t(), non_neg_integer()) :: non_neg_integer()
  def get_next_poll_time_msec(time, collect_posts_interval_minutes) do
    sec = 60 - time.second
    min = (collect_posts_interval_minutes - 1) - rem(time.minute, collect_posts_interval_minutes)
    (sec * 1000) + (min * 1000 * 60)
  end

  # Server

  @impl true
  def init({:num_posts_to_collect, num_posts_to_collect, :collect_posts_interval_minutes, collect_posts_interval_minutes}) do
    schedule_collect_posts(collect_posts_interval_minutes)
    {:ok, {num_posts_to_collect, collect_posts_interval_minutes}}
  end

  @impl true
  def handle_info(:collect_posts, state={num_posts_to_collect, collect_posts_interval_minutes}) do
    IO.puts "Would collect #{num_posts_to_collect} posts"
    schedule_collect_posts(collect_posts_interval_minutes)
    {:noreply, state}
  end

  defp schedule_collect_posts(collect_posts_interval_minutes) do
    next_poll_time_msec = get_next_poll_time_msec(NaiveDateTime.local_now(), collect_posts_interval_minutes)
    IO.puts "Next poll time in #{next_poll_time_msec} millis"
    Process.send_after(self(), :collect_posts, next_poll_time_msec)
  end
end
