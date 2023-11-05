## Full Examples

These examples are intended to show more completely how to use the `jq` rules: rather than just
snippets of untested code that may bitrot over time, these examples are tested on each PR, and are
nearly identical to what a consumer of the rules would use -- except that the local_repository()
rule should be replaced with a http_archive() rule as documented in WORKSPACE (and MODULE.bazel if
appropriate)

Sure, the actual examples are those used as validation in the "example" directory, but I intend to
add to them. ...and test on every PR (at least with a linux build on the latest bazel)

## Running Full Examples

with reference to the changes in ci.yaml, you can run a full-example as follows:

```
    (cd full-examples/basic && bazel build //...)
```

Of course, if you have an HTTP cache or federated bazel cache, you can reuse the work done in a
build at the root workspace.

## Ignored

NOTE that the `full-examples` directory is ignored from a wildcard build: the `bazel-*` softlinks,
and the recursive nature of the resulting tree-transversal after a build is done, becomes a really
problematic endless loop. Don't remove them.
