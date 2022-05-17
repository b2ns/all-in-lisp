;;;;Description: use CLOS more like C++
;;;;Author: b2ns

(defpackage :b2ns.github.def-class
  (:use :cl)
  (:export :def-class :new :super :this))
(in-package :b2ns.github.def-class)

;;;to define a class
(defmacro def-class (class-name extends attribute &rest method)
  `(progn
     (defclass ,class-name ,extends;define class
       ,(loop for i in attribute do
              (cond
                ((atom i) (setf i `(,i)) (push nil (cdr i)))
                ((equal (cdr i) nil) (push nil (cdr i)))
                ((position (cadr i) '(:class :instance)) (push :allocation (cdr i)) (push nil (cdr i)))
                ((cddr i) (push :allocation (cddr i))))
              (push :initform (cdr i))
              (push (car i) (cdr i))
              (push :initarg (cdr i))
              (push (car i) (cdr i))
              (push :accessor (cdr i))
              collect i))

     (defgeneric ,class-name (obj &rest rest));generic function for default constructor
     ,@(loop for i in method collect;generate generic function
             `(defgeneric ,(car i) (obj &rest rest)
                ,(if (and (not (listp (cadr i))) (not (position (cadr i) '(:after :before :around))))
                     `(:method-combination ,(cadr i));for method-combination
                     `(:documentation "default"))))

     (defmethod ,class-name ((this ,class-name) &rest rest) rest);method for default constructor
     ,@(loop for i in method for tmp = nil for combo = nil do;generate method
             (when (not (listp (cadr i))) (setf combo (cadr i)) (setf i (delete combo i)))
             (push `(let* ,(loop for j in (cadr i) collect `(,j (pop rest))) rest ,@(cddr i)) tmp)
             (push `((this ,class-name) &rest rest) tmp)
             (if combo (push combo tmp))
             (push (car i) tmp)
             (push 'defmethod tmp)
             collect tmp)))
;;;to make a new instance
(defmacro new (class-name &body body)
  `(let ((tmp (make-instance ',class-name
                ,@(loop for i in body for n from 1
                        if (oddp n) collect `',i
                        else collect i))))
     (,class-name tmp)
    tmp))
;;;to use parent's method
(defmacro super (&body body)
  `(call-next-method this ,@body))
