;; Velocity templates are usually wrappers around a markup or JSON document.
;; Injected languages are resolved by name, so these rely on the languages that
;; ship with Zed: "HTML" and "JSON".
;;
;; Directives and references split the template into many `text` nodes, so the
;; content itself is used to decide whether a chunk belongs to the surrounding
;; document. Fragments are parsed independently, which may leave parts of the
;; markup unstyled, but it never affects the VTL highlighting.

; XML/HTML markup: tags, attributes and comments around Velocity constructs.
((text) @injection.content
  (#match? @injection.content "<[a-zA-Z_/!?:]")
  (#set! injection.language "HTML"))

; JSON documents, e.g. `.vtl` templates that render JSON payloads.
((text) @injection.content
  (#match? @injection.content "^\\s*[\\[{]|\"[^\"\\n]*\"\\s*:")
  (#set! injection.language "JSON"))
