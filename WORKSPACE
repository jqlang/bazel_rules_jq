# Declare the local Bazel workspace.
# This is *not* included in the published distribution.
workspace(
    name = "slamdev_rules_jq",
)

load(":internal_deps.bzl", "rules_jq_internal_deps")

# Fetch deps needed only locally for development
rules_jq_internal_deps()

load("//jq:repositories.bzl", "jq_register_toolchains", "rules_jq_dependencies")

# Fetch our "runtime" dependencies which users need as well
rules_jq_dependencies()

jq_register_toolchains(
    name = "jq1_6",
    jq_version = "1.6",
)

############################################
# Gazelle, for generating bzl_library targets
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.17.2")

gazelle_dependencies()
