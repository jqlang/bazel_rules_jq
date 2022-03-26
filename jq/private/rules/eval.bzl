"jq_eval rule"

load("@bazel_skylib//lib:collections.bzl", "collections")
load("@bazel_skylib//lib:shell.bzl", "shell")

_DOC = "Defines a jq eval execution."

_ATTRS = {
    "srcs": attr.label_list(
        doc = "Files to apply filter to.",
        allow_files = True,
    ),
    "filter": attr.string(
        doc = "Filter to evaluate",
    ),
    "filter_file": attr.label(
        doc = "Filter file to evaluate",
        allow_single_file = True,
    ),
    "indent": attr.int(
        doc = "Use the given number of spaces (no more than 7) for indentation",
        default = 2,
    ),
    "seq": attr.bool(
        doc = "Use the application/json-seq MIME type scheme for separating JSON texts in jq's input and output",
    ),
    "stream": attr.bool(
        doc = "Parse the input in streaming fashion, outputting arrays of path and leaf values",
    ),
    "slurp": attr.bool(
        doc = "Instead of running the filter for each JSON object in the input, read the entire input stream into a large array and run the filter just once",
    ),
    "raw_input": attr.bool(
        doc = "Don't parse the input as JSON. Instead, each line of text is passed to the filter as a string",
    ),
    "compact_output": attr.bool(
        doc = "More compact output by putting each JSON object on a single line",
    ),
    "tab": attr.bool(
        doc = "Use a tab for each indentation level instead of two spaces",
    ),
    "sort_keys": attr.bool(
        doc = "Output the fields of each object with the keys in sorted order",
    ),
    "raw_output": attr.bool(
        doc = "With this option, if the filter's result is a string then it will be written directly to standard output rather than being formatted as a JSON string with quotes",
    ),
    "join_output": attr.bool(
        doc = "Like raw_output but jq won't print a newline after each output",
    ),
    "nul_output": attr.bool(
        doc = "Like raw_output but jq will print NUL instead of newline after each output",
    ),
    "exit_status": attr.bool(
        doc = "Sets the exit status of jq to 0 if the last output values was neither false nor null, 1 if the last output value was either false or null, or 4 if no valid result was ever produced",
    ),
    "args": attr.string_dict(
        doc = "Passes values to the jq program as a predefined variables",
    ),
    "argsjson": attr.string_dict(
        doc = "Passes JSON-encoded values to the jq program as a predefined variables",
    ),
}

def _impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name + ".json")

    command = [ctx.var["JQ_BIN"]]
    if ctx.attr.filter:
        command.append(shell.quote(ctx.attr.filter))
    for f in ctx.files.srcs:
        command.append(f.path)
    if ctx.attr.seq:
        command.append("--seq")
    if ctx.attr.stream:
        command.append("--stream")
    if ctx.attr.slurp:
        command.append("--slurp")
    if ctx.attr.raw_input:
        command.append("--raw-input")
    if ctx.attr.compact_output:
        command.append("--compact-output")
    if ctx.attr.tab:
        command.append("--tab")
    if ctx.attr.sort_keys:
        command.append("--sort-keys")
    if ctx.attr.raw_output:
        command.append("--raw-output")
    if ctx.attr.join_output:
        command.append("--join-output")
    if ctx.attr.nul_output:
        command.append("--nul-output")
    if ctx.attr.exit_status:
        command.append("--exit-status")
    for [name, value] in ctx.attr.args:
        command.append("--arg {} {}", shell.quote(name), shell.quote(value))
    for [name, value] in ctx.attr.argsjson:
        command.append("--argjson {} {}", shell.quote(name), shell.quote(value))
    command.append("--indent {}".format(ctx.attr.indent))

    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [out],
        arguments = [out.path],
        tools = ctx.toolchains["@slamdev_rules_jq//jq:toolchain_type"].default.files,
        command = " ".join(command) + " > $1",
        mnemonic = "JQ",
        progress_message = "JQ to %{output}",
    )

    return [DefaultInfo(files = depset([out]), runfiles = ctx.runfiles(files = [out]))]

eval = rule(
    doc = _DOC,
    implementation = _impl,
    attrs = _ATTRS,
    provides = [DefaultInfo],
    toolchains = ["@slamdev_rules_jq//jq:toolchain_type"],
)
