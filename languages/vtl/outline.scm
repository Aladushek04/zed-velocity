;; Macros and `#define` blocks in the outline panel.

(macro_definition
  name: (identifier) @name) @item

(define_directive
  name: (reference
    (identifier) @name)) @item
