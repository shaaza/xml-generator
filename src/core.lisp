; This contains the core tag generating macro, on top of which other domain specific languages will be built.

; @macro let1
; @desc Essentially let, but allows usage of let with fewer parentheses.

(defmacro let1 (var val &body body)
              `(let ((,var ,val))
                    ,@body))


; @macro split
; @mapping [(list-head . list-tail), (function with head and tail context), (function if list can't be split)] -> [executes either of the two functions]
; @desc Takes a list, splits it into head and tail, and provides a context with the split head and tail vars to the function 'yes' to execute.
; @exception If list cannot be split, function 'no' will be called.

(defmacro split (val yes no)
  (let1 g (gensym)
    `(let1 ,g ,val
          (if ,g
            (let ((head (car ,g))
                  (tail (cdr ,g)))
              ,yes)
          ,no))))


; @func pairs
; @desc Takes a list of items and groups the items pairwise. If there are odd no of items, the last one is omitted.
; @mapping (list) => (list items converted to pairs)
; @example (pairs '(2 3 4 5 6 7)) => ((2 . 3) (4 . 5) (6 . 7))

(defun pairs (lst) (labels ((f (lst acc)
                      (split lst
                        (if tail
                          (f (cdr tail) (cons (cons head (car tail)) acc))
                          (reverse acc))
                        (reverse acc))))
                      (f lst nil)))

; @func print-tag
; @desc Prints an xml tag along with its attributes. Specify a truthy value for third argument for closing tags.
; @mapping [tag-name, (attributes), isClosingTag?] => [xml tag string]
; @example (print-tag 'sometag '((color . blue) (height . 9)) nil) => <sometag color="BLUE" height="9">

(defun print-tag (name alist closingp)
  (princ #\<)
  (when closingp
    (princ #\/))
  (princ (string-downcase name))
  (mapc (lambda (att)
                (format t " ~a=\"~a\"" (string-downcase (car att)) (cdr att)))
         alist)
(princ #\>))

; @macro tag
; @desc Prints an opening and closing xml tag along with its attributes. Allows other Lisp statements to enclosed via the third argument.
; @mapping [tag-name, (attributes), body1, body2, ...] => [xml tag string]
; @example (tag sometag (color 'blue height (+ 4 5)) (princ 'Hello)) => <sometag color="BLUE" height="9">HELLO</sometag>

(defmacro tag (name atts &body body)
  `(progn (print-tag ',name
             (list ,@(mapcar (lambda (x)
                               `(cons ',(car x) ,(cdr x)))
                             (pairs atts)))
             nil)
           ,@body
          (print-tag ',name nil t)))
