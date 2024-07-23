defmodule Expublish.Commitizen do
  @moduledoc """
  Implements commitizen specification.

  https://www.conventionalcommits.org/en/v1.0.0/#specification
  """

  defstruct all: [], patch: [], feature: [], breaking: []

  def run(commits) do
    collect(commits)
  end

  defp collect(commits, acc \\ %__MODULE__{})

  defp collect([], acc), do: acc

  defp collect(["feat: " <> _ = commit_no_scope | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit_no_scope | acc.all], feature: [commit_no_scope | acc.feature]})
  end

  defp collect(["fix: " <> _ = commit_no_scope | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit_no_scope | acc.all], patch: [commit_no_scope | acc.patch]})
  end

  defp collect(["feat!: " <> _ = commit_no_scope | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit_no_scope | acc.all], breaking: [commit_no_scope | acc.breaking]})
  end

  defp collect(["fix!: " <> _ = commit_no_scope | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit_no_scope | acc.all], breaking: [commit_no_scope | acc.breaking]})
  end

  defp collect(["fix(" <> _ = commit | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit | acc.all], patch: [commit | acc.patch]})
  end

  defp collect(["feat(" <> _ = commit | rest], acc) do
    collect(rest, %__MODULE__{acc | all: [commit | acc.all], feature: [commit | acc.feature]})
  end

  defp collect([_ | rest], acc) do
    collect(rest, acc)
  end
end
