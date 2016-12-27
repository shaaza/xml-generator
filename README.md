## Description
A CLISP macro that generates XML tags and their attributes programmatically, allowing dynamic HTML/XML/SVG generation from a Lisp program.

## Example
```lisp
(load "generator.lisp")
(tag div (class 'home)
             (tag p (class 'text id 'name) (princ 'William))
             (tag div (class 'empty)))
```

Output:

```html
<div class="HOME">
  <p class="TEXT" id="NAME">WILLIAM</p>
  <div class="EMPTY"></div>
</div>
```

## Installation

Place the file and src folder in your project directory, and load "main.lisp" from CLISP interpreter or from your CLISP script.
