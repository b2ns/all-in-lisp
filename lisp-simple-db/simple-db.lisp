;;;;Description: a simple database using common-lisp
;;;;Author: b2ns

(defpackage :b2ns.github.simple-db
  (:use :cl)
  (:export :create-table :about-table :remove-table :add-column :remove-column :insert-into :select-from :update :delete-from :save-db :load-db :clear-db
           :where :has :orderby
           :count-tb :max-tb :min-tb :sum-tb :avg-tb))
(in-package :b2ns.github.simple-db)

;;;dynamic var
(defparameter *filename* "newDB.db")
(defparameter *db* (make-hash-table :test 'equal))
(defparameter *columns* (make-hash-table :test 'equal))

;;;utils
;;to generate table
(defun make-dynamic-array (&optional (size 100))
  (make-array size :fill-pointer 0 :adjustable t)) 
;;substr test
(defun has (str substr)
  (search substr str :test #'string-equal))
;;selector
(defmacro where (&body body)
  (if (null body) (return-from where nil))
  (if (equal "all" (car body))
      `#'(lambda (item) item)
      `#'(lambda (item)
           (and
             ,@(loop for i in body for k = (pop i)
                     if (<= (length i) 1) collect
                       `(equal (gethash ,k item) ,(pop i))
                     else collect
                       `(and
                          (gethash ,k item)
                          ,@(loop while i collect
                         `(,(pop i) (gethash ,k item) ,(pop i)))))))))
;;sort comparator
(defmacro orderby (key opt)
  `#'(lambda (x y)
       (let ((xv (gethash ,key x)) (yv (gethash ,key y)))
         (if (and xv yv)
             (,opt xv yv)
             nil))))

;;;main
;;table
(defun create-table (table &rest cols)
  (setf (gethash table *db*) (make-dynamic-array))
  (setf (gethash table *columns*) cols)
  "Done!")

(defun about-table ()
  (loop for k being the hash-keys in *columns* using (hash-value col)
        for i from 1 do
        (format t "talbe ~a: ~a~%     columns: ~s~%     size: ~a~&" i k col (length (gethash k *db*)))))

(defun remove-table (table)
  (remhash table *db*)
  (remhash table *columns*)
  "Done!")

;;column
(defun add-column (table &rest cols)
  (let ((tmp (reverse (gethash table *columns*))))
    (loop for col in cols do (push col tmp))
    (setf (gethash table *columns*) (nreverse tmp)))
  "Done!")

(defun remove-column (table &rest cols)
  (loop for col in cols do (setf (gethash table *columns*) (delete col (gethash table *columns*) :test #'equal)))
  (loop for item across (gethash table *db*) do
        (loop for col in cols do 
              (remhash col item)))
  "Done!")

;;row
(defun insert-into (table &rest vals)
  (let* ((tb (gethash table *db*)) (cols (gethash table *columns*)) (item (make-hash-table :test 'equal)))
    (loop for k in cols for v in vals do
          (setf (gethash k item) v))
    (vector-push-extend item tb)
    "Done!"))

(defmacro select-from (table cols selector-fn &optional (orderby-fn nil supplied-p))
  `(let ((tmp (remove-if-not ,selector-fn (gethash ,table *db*))) (col))
    (if ,supplied-p
        (sort tmp ,orderby-fn))
    (if (equal "all" ',cols) (setf col (gethash ,table *columns*)) (setf col ',cols))
    (format t "~{  ~10a~}~%" col)
    (loop for i across tmp do
          (loop for k in col do
                (format t "  ~10s" (gethash k i)))
          (format t "~&"))
    ))

(defun update (table selector-fn &rest col-and-val)
  (progn
     (loop for i across (gethash table *db*)
           if (funcall selector-fn i) do
             (loop for j on col-and-val by #'cddr do
                   (setf (gethash (first j) i) (second j))))
    "Done!"))

(defun delete-from (table selector-fn)
  (setf (gethash table *db*)  (delete-if selector-fn (gethash table *db*)))
  "Done!")

;;database
(defun clear-db ()
  (setf *db* (make-hash-table :test 'equal)) 
  (setf *columns* (make-hash-table :test 'equal)) 
  "Done!")

(defun save-db (&optional (filename *filename*))
   (setf *filename* filename)
   (with-open-file (out *filename* :direction :output :if-exists :supersede)
     (print (loop for k being the hash-keys in *db* collect k) out)
     (print (loop for v being the hash-values in *columns* collect v) out)
     (loop for tb being the hash-values in *db* do
           (loop for item across tb do
                 (print (loop for v being the hash-values in item collect v) out))
           (print #\n out))
     )
   "Done!")

(defun load-db (filename)
  (setf *filename* filename)
  (clear-db)
  (with-open-file (in *filename*)
    (let ((tables (read in)) (columns (read in)))
      (loop for k in tables for col in columns do
            (setf (gethash k *db*) (make-dynamic-array))
            (setf (gethash k *columns*) col)
            (loop for item = (read in nil) until (equal item #\n) do
                  (apply #'insert-into k item)))))
  "Done!")

;;;math function
(defun count-tb (table selector-fn)
  (length (remove-if-not selector-fn (gethash table *db*))))

(defmacro with-loop (action)
  `(loop for i across (remove-if-not selector-fn (gethash table *db*))
         for num = (gethash col i)
         when num
         ,action num into result
         count num into size
         finally (return (values result size))))

(defun max-tb (table selector-fn col)
  (+ (with-loop maximize)))

(defun min-tb (table selector-fn col)
  (+ (with-loop minimize)))

(defun sum-tb (table selector-fn col)
  (+ (with-loop sum)))

(defun avg-tb (table selector-fn col)
  (float (multiple-value-call #'/ (with-loop sum))))
