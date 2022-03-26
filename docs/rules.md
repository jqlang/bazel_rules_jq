<!-- Generated with Stardoc: http://skydoc.bazel.build -->

# JQ Rules

<a id="#jq_eval"></a>

## jq_eval

<pre>
jq_eval(<a href="#jq_eval-name">name</a>, <a href="#jq_eval-args">args</a>, <a href="#jq_eval-argsjson">argsjson</a>, <a href="#jq_eval-compact_output">compact_output</a>, <a href="#jq_eval-exit_status">exit_status</a>, <a href="#jq_eval-filter">filter</a>, <a href="#jq_eval-filter_file">filter_file</a>, <a href="#jq_eval-indent">indent</a>, <a href="#jq_eval-join_output">join_output</a>,
        <a href="#jq_eval-nul_output">nul_output</a>, <a href="#jq_eval-raw_input">raw_input</a>, <a href="#jq_eval-raw_output">raw_output</a>, <a href="#jq_eval-seq">seq</a>, <a href="#jq_eval-slurp">slurp</a>, <a href="#jq_eval-sort_keys">sort_keys</a>, <a href="#jq_eval-srcs">srcs</a>, <a href="#jq_eval-stream">stream</a>, <a href="#jq_eval-tab">tab</a>)
</pre>

Defines a jq eval execution.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="jq_eval-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="jq_eval-args"></a>args |  Passes values to the jq program as a predefined variables   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |
| <a id="jq_eval-argsjson"></a>argsjson |  Passes JSON-encoded values to the jq program as a predefined variables   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |
| <a id="jq_eval-compact_output"></a>compact_output |  More compact output by putting each JSON object on a single line   | Boolean | optional | False |
| <a id="jq_eval-exit_status"></a>exit_status |  Sets the exit status of jq to 0 if the last output values was neither false nor null, 1 if the last output value was either false or null, or 4 if no valid result was ever produced   | Boolean | optional | False |
| <a id="jq_eval-filter"></a>filter |  Filter to evaluate   | String | optional | "" |
| <a id="jq_eval-filter_file"></a>filter_file |  Filter file to evaluate   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| <a id="jq_eval-indent"></a>indent |  Use the given number of spaces (no more than 7) for indentation   | Integer | optional | 2 |
| <a id="jq_eval-join_output"></a>join_output |  Like raw_output but jq won't print a newline after each output   | Boolean | optional | False |
| <a id="jq_eval-nul_output"></a>nul_output |  Like raw_output but jq will print NUL instead of newline after each output   | Boolean | optional | False |
| <a id="jq_eval-raw_input"></a>raw_input |  Don't parse the input as JSON. Instead, each line of text is passed to the filter as a string   | Boolean | optional | False |
| <a id="jq_eval-raw_output"></a>raw_output |  With this option, if the filter's result is a string then it will be written directly to standard output rather than being formatted as a JSON string with quotes   | Boolean | optional | False |
| <a id="jq_eval-seq"></a>seq |  Use the application/json-seq MIME type scheme for separating JSON texts in jq's input and output   | Boolean | optional | False |
| <a id="jq_eval-slurp"></a>slurp |  Instead of running the filter for each JSON object in the input, read the entire input stream into a large array and run the filter just once   | Boolean | optional | False |
| <a id="jq_eval-sort_keys"></a>sort_keys |  Output the fields of each object with the keys in sorted order   | Boolean | optional | False |
| <a id="jq_eval-srcs"></a>srcs |  Files to apply filter to.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="jq_eval-stream"></a>stream |  Parse the input in streaming fashion, outputting arrays of path and leaf values   | Boolean | optional | False |
| <a id="jq_eval-tab"></a>tab |  Use a tab for each indentation level instead of two spaces   | Boolean | optional | False |


