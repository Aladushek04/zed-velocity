;; Indent the body of block directives, with `#end` aligned to the opener.

(if_directive
  ")" @start
  ["#end" "#{end}"] @end) @indent

(if_directive
  (elseif_clause) @outdent)

(if_directive
  (else_clause) @outdent)

(foreach_directive
  ")" @start
  ["#end" "#{end}"] @end) @indent

(macro_definition
  ")" @start
  ["#end" "#{end}"] @end) @indent

(define_directive
  ")" @start
  ["#end" "#{end}"] @end) @indent

(velocimacro_call
  ["#end" "#{end}"] @end) @indent
