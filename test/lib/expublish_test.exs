defmodule ExpublishTest do
  use ExUnit.Case

  import Expublish.TestHelper
  import ExUnit.CaptureLog

  alias Expublish.Options
  alias Expublish.Project
  alias Expublish.Semver

  doctest Expublish

  setup do
    [options: Options.parse(["--dry-run"])]
  end

  test "major/1 exits on unclean working directory", %{options: options} do
    File.write!("expublish_major_test", "generated by expublish test")

    fun = fn ->
      assert catch_exit(Expublish.major(options)) == {:shutdown, 1}
    end

    assert capture_log(fun) =~ "working directory not clean"

    on_exit(fn -> File.rm!("expublish_major_test") end)
  end

  test "major/1 runs without errors", %{options: options} do
    fun = fn ->
      with_release_md(fn ->
        Expublish.major(options)
      end)
    end

    Project.get_version!()
    |> Semver.major()
    |> assert_dry_run(fun)
  end

  test "minor/1 runs without errors", %{options: options} do
    fun = fn ->
      with_release_md(fn ->
        Expublish.minor(options)
      end)
    end

    Project.get_version!()
    |> Semver.minor()
    |> assert_dry_run(fun)
  end

  test "patch/1 runs without errors", %{options: options} do
    fun = fn ->
      with_release_md(fn ->
        Expublish.patch(options)
      end)
    end

    Project.get_version!()
    |> Semver.patch()
    |> assert_dry_run(fun)
  end

  test "alpha/1 runs without errors", %{options: options} do
    fun = fn ->
      with_release_md(fn ->
        Expublish.alpha(options)
      end)
    end

    Project.get_version!()
    |> Semver.alpha(options)
    |> assert_dry_run(fun)
  end

  test "beta/1 runs without errors", %{options: options} do
    fun = fn ->
      with_release_md(fn ->
        Expublish.beta(options)
      end)
    end

    Project.get_version!()
    |> Semver.beta(options)
    |> assert_dry_run(fun)
  end

  test "rc/1 runs without errors", %{options: options} do
    fun = fn ->
      with_release_md(fn ->
        Expublish.rc(options)
      end)
    end

    Project.get_version!()
    |> Semver.rc(options)
    |> assert_dry_run(fun)
  end

  defp assert_dry_run(new_version, fun) do
    assert capture_log(fun) =~ "Skipping new entry in CHANGELOG.md"
    assert capture_log(fun) =~ "Skipping new version commit"
    assert capture_log(fun) =~ "Skipping new version tag"
    assert capture_log(fun) =~ "Skipping \"git push origin master --tags\""
    assert capture_log(fun) =~ "Skipping \"mix hex.publish --yes\""
    assert capture_log(fun) =~ "Finished dry run for new package version"
    assert capture_log(fun) =~ "#{new_version}"
  end
end
