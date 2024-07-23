defmodule CommitizenTest do
  use ExUnit.Case

  test "groups commits" do
    commits = [
      "fix: i fix something",
      "fix(scope): i fix something in scope",
      "feat: i add a feature",
      "BREAKING CHANGE: ignored",
      "feat!: i add a feature and break something",
      "not noteworthy"
    ]

    assert %{all: [_, _, _, _], patch: [_, _], feature: [_], breaking: [_]} = Expublish.Commitizen.run(commits)
  end
end
