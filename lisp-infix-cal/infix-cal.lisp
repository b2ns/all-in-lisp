;;;;Description: infix-notation transform into prefix-notation or post-notation
;;;;Author: b2ns

(defpackage :b2ns.github.infix-cal
  (:use :cl)
  (:export :trans-notation :infix-cal))
(in-package :b2ns.github.infix-cal)

;;;utils
;;default operator
(defmacro classify (ch)
  (let ((operators '((:[ :]) (and or) (= < > <= >=) (+ -) (* /))))
    `(cond
       ,@(loop for opt in operators for i from 0 collect
               `((position ,ch ',opt) ,i))
       (t -1))))
;; if is operator
(defun operator-p (ch)
  (if (> (classify ch) -1)
      t
      nil)) 
;;compare priority of operator
(defun priority-p (x y)
  (let ((tmp (- (classify x) (classify y))))
    (cond
      ((= tmp 0) 0)
      ((< tmp 0) -1)
      ((> tmp 0) 1))))

;;;main
;;transform notation
(defmacro trans-notation (pre-or-post &body body)
  (let ((brt-l :]) (brt-r :[) (opt '<) (tmp 'num-stack))
    (if (string= pre-or-post "post")
        (setf brt-l :[ brt-r :] opt '<= tmp '(reverse num-stack))
        (setf body (reverse body)))
  `(let ((num-stack nil) (opt-stack nil))
    (loop for ch in ',body do
          (if (not (operator-p ch))
              (push ch num-stack)
              (cond
                ((equal ,brt-l ch) (push ch opt-stack))
                ((equal ,brt-r ch) (loop until (or (equal ,brt-l (setf ch (pop opt-stack))) (equal nil ch)) do
                                     (push ch num-stack)))
                (t (loop while (,opt (priority-p ch (car opt-stack)) 0) do
                         (push (pop opt-stack) num-stack))
                   (push ch opt-stack)))))
    (loop for ch in opt-stack do (push ch num-stack))
    ,tmp)))

;;use infix-notation to calculate
(defmacro infix-cal (&body body)
  `(let ((postfix (trans-notation "post" ,@body)) (res nil))
     (loop for ch in postfix with a and b do
           (if (not (operator-p ch))
               (push ch res)
               (progn
                 (setf b (pop res))
                 (setf a (pop res))
                 (push `(,ch ,a ,b) res))))
     (eval (car res))))

