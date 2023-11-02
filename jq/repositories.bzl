"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//jq/private:toolchains_repo.bzl", "PLATFORMS", "toolchains_repo")

# WARNING: any changes in this function may be BREAKING CHANGES for users
# because we'll fetch a dependency which may be different from one that
# they were previously fetching later in their WORKSPACE setup, and now
# ours took precedence. Such breakages are challenging for users, so any
# changes in this function should be marked as BREAKING in the commit message
# and released only in semver majors.
def rules_jq_dependencies():
    # The minimal version of bazel_skylib we require
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        ],
    )

_DOC = "TODO"
_ATTRS = {
    "jq_version": attr.string(mandatory = True),
    "platform": attr.string(mandatory = True, values = PLATFORMS.keys()),
}

def _jq_repo_impl(repository_ctx):
    repository_ctx.report_progress("Downloading JQ releases info")
    repository_ctx.download(
        url = ["https://api.github.com/repos/stedolan/jq/releases"],
        output = "versions.json",
    )
    versions = repository_ctx.read("versions.json")
    version_found = False
    for v in json.decode(versions):
        version = v["tag_name"].lstrip("jq-")
        if version == repository_ctx.attr.jq_version:
            version_found = True
    if not version_found:
        fail("did not find {} version in https://api.github.com/repos/stedolan/jq/releases".format(repository_ctx.attr.jq_version))

    file_url = "https://github.com/stedolan/jq/releases/download/jq-{}/jq-{}".format(repository_ctx.attr.jq_version, repository_ctx.attr.platform)

    repository_ctx.report_progress("Downloading and extracting JQ toolchain")
    repository_ctx.download(
        url = file_url,
        executable = True,
        output = "jq-{}".format(repository_ctx.attr.platform),
    )

    build_content = """#Generated by jq/repositories.bzl
load("@rules_jq//jq:toolchain.bzl", "jq_toolchain")
jq_toolchain(name = "jq_toolchain", target_tool = select({
        "@bazel_tools//src/conditions:host_windows": "jq-%s.exe",
        "//conditions:default": "jq-%s",
    }),
)
""" % (repository_ctx.attr.platform, repository_ctx.attr.platform)

    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", build_content)

jq_repositories = repository_rule(
    _jq_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def jq_register_toolchains(name, **kwargs):
    """Convenience macro for users which does typical setup.

    - create a repository for each built-in platform like "jq_linux_amd64" -
      this repository is lazily fetched when jq is needed for that platform.
    - TODO: create a convenience repository for the host platform like "jq_host"
    - create a repository exposing toolchains for each platform like "jq_platforms"
    - register a toolchain pointing at each platform
    Users can avoid this macro and do these steps themselves, if they want more control.

    Args:
        name: base name for all created repos, like "jq0_6_1"
        **kwargs: passed to each jq_repositories call
    """
    for platform in PLATFORMS.keys():
        jq_repositories(
            name = name + "_" + platform,
            platform = platform,
            **kwargs
        )
        native.register_toolchains("@%s_toolchains//:%s_toolchain" % (name, platform))

    toolchains_repo(
        name = name + "_toolchains",
        user_repository_name = name,
    )
