# Bazel rules for [jq](https://github.com/jqlang/jq)

This ruleset facilitates getting the desired version of jq into your Bazel project as reliably and
easily as possible, while avoiding unnecessary network hits, and supporting caching of distribution
and built artifacts.

Examples will be created in the "examples" directory that should be cut-n-pasted to your WORKSPACE
(and soon your MODULE.bazel).

The intent of this work is to:

- offer a traditional WORKSPACE and newer bzlmod capability
- re-home slamdev's work in making binaries available,
- address the wider array of jq binaries now produced in a release,
- adapt to the new naming schema, and
- offer a fallback of building JQ if a release is not available or the user so chooses

## Installation

### Traditional WORKSPACE

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
   name = "rules_jq",
   sha256 = "52771b5f7fb5017b0f5a3816b46624d2b9a336ddc178b261de988d969cd329d8",
   url = "https://github.com/jqlang/bazel_rules_jq/releases/download/0.0.1/bazel_rules_jq-v0.0.1.tar.gz",
)

load("@rules_jq//jq:repositories.bzl", "jq_register_toolchains", "rules_jq_dependencies")

rules_jq_dependencies()

jq_register_toolchains(
    name = "jq",
    jq_version = "1.6",
)
```

The resulting JQ binary cannot be directly called, but can be used via `jq_eval()`
(see example/eval) or as a Makefile-style variable (see example/genrule)

### bzlmod Modular Format

(soon)

## History

2022-03-26 slamdev created slamdev/rules_jq to map jq as a bazel toolchain

2022-03-28 slamdev's most recent update was an arm binary (when jq-1.6 had none)

2023-03-01 in-place JQ builds as backup demo'd in "bazel-rules-foreign-example-jq"

2023-05-28 jq migrated to jqlang/jq

2023-10-30 this repo created in jqlang to combine these actions as noted above
