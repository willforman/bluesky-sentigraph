defmodule SentiGraph.PostsTest do
  use ExUnit.Case, async: true
  import ParameterizedTest

  alias SentiGraph.Posts

  param_test "get_next_poll_time_msec",
    [
      %{ time: ~N[2024-11-17 10:04:59], msec_want: 1000},
      %{ time: ~N[2024-11-17 10:00:01], msec_want: 4 * 60 * 1000 + 59 * 1000},
    ], %{time: time, msec_want: msec_want} do
      dbg time
      msec_got = Posts.get_next_poll_time_msec(time)
      assert msec_got == msec_want
  end
end
