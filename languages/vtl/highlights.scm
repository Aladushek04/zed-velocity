;; Velocity Template Language (VTL) syntax highlighting.

;; Comments

(comment) @comment
(block_comment) @comment
(documentation_comment) @comment.doc

;; Literal `#[[ ... ]]#` blocks are emitted verbatim.

(unparsed_content) @string.special

;; Escapes: `\$`, `\#`, `\\`

(escape_sequence) @string.escape
(string_escape_sequence) @string.escape

;; Directives

[
  "#if" "#{if}"
  "#elseif" "#{elseif}"
  "#else" "#{else}"
  "#end" "#{end}"
  "#foreach" "#{foreach}"
  "#set" "#{set}"
  "#macro" "#{macro}"
  "#define" "#{define}"
  "#include" "#{include}"
  "#parse" "#{parse}"
  "#evaluate" "#{evaluate}"
  "#stop" "#{stop}"
  "#break" "#{break}"
  "#@"
] @keyword

"in" @keyword

;; Word-form operators: `and`, `or`, `not`, `eq`, ...

[
  "and"
  "or"
  "not"
  "eq"
  "ne"
  "lt"
  "le"
  "gt"
  "ge"
] @operator

;; Macro and function names

(macro_definition
  name: (identifier) @function)

(velocimacro_call
  name: (identifier) @function)

(generic_directive
  name: (directive_name) @function)

(define_directive
  name: (reference
    name: (identifier) @function))

;; References

(reference
  name: (identifier) @variable)

(reference
  property: (identifier) @property)

(reference
  method: (identifier) @function)

(macro_definition
  parameter: (identifier) @variable.parameter)

(macro_definition
  parameter: (reference
    name: (identifier) @variable.parameter))

;; Literals

(string) @string
(number) @number
(boolean) @boolean

;; Map/array keys inside references (`$map['key']`) read better as properties
;; than as plain strings.

(reference
  index: (string
    [(single_quoted_string_content) (double_quoted_string_content)] @property))

;; Operators

(binary_expression
  operator: _ @operator)

(unary_expression
  operator: _ @operator)

"=" @operator
".." @operator

;; Punctuation

["(" ")" "[" "]" "{" "}"] @punctuation.bracket

["," ":" "."] @punctuation.delimiter

(reference
  "$" @punctuation.special)

(reference
  "!" @punctuation.special)
