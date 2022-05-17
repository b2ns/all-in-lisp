# Use CLOS in Lisp more like C++
## Usage:
1.to define a class:

    (def-class Son (Dad Mon)  ;extends list
      ;;attribuate
      (name (age) (sex "male") (counter1 :class) (counter2 0 :class))
      
      ;;method
      (Son () (format t "constructor from son"))  ;constructor (can be ignored)
      (set-name (x) (setf (name this) x))
      (get-name () (name this))
      (eat (x) (format t "eat ~a~%" x))
      (use-dad-method (x y z) (super x y z))      
    )

2.to make a new instance:

    (new Son)
    (new Son name "b2ns" age 1 counter1 100)

3.more usage:

	(def-class Dad ();extends
	  ;;attribute
	  (first-name (last-name "Smith") (age) (sex "male") (counter1 :class) (counter2 50 :class))

	  ;;method
	  (Dad () (format t "constructor from Dad~%"))

	  (eat :before () (format t "wash hands~%"))
	  (eat () (format t "eat meat~%"))
	  (eat :after () (format t "wipe mouth~%"))

	  (speak (str) (format t "from dad: ~a~%" str))

	  (add-age (x) (incf (age this) x) (format t "form dad~%"))

	  (work () (format t "I am working~%"))

	  (playwith (x) (cond
					  ((equal 'Dad (type-of x)) (format t "Dad:Dad"))
					  ((equal 'Son (type-of x)) (format t "Dad:Son"))))
	  )
	(defparameter *d* (new Dad first-name "Mark" age 40 counter1 10))
	(first-name *d*)
	(last-name *d*)
	(age *d*)
	(sex *d*)
	(counter1 *d*)
	(incf (counter1 *d*))
	(counter2 *d*)
	(incf (counter2 *d*))

	(eat *d*)
	(speak *d* "hello")
	(add-age *d* 5)
	(work *d*)
	(playwith *d* *d*)

	(def-class Mon ()
	  (first-name (last-name "Smith") (age 35) (sex "female") (counter3 0 :class) (eyes "green"))

	  (Mon () (format t "constructor from Mon~%"))

	  (eat () (format t "eat fruit~%"))

	  (speak (str) (format t "from mom: ~a~%" str))

	  (add-age (x) (incf (age this) x) (format t "form mom~%"))

	  (clean () (format t "I am cleaning~%"))
	  )

	(defparameter *m* (new Mon first-name "Mary"))
	(first-name *m*)
	(last-name *m*)
	(age *m*)
	(sex *m*)
	(counter3 *m*)
	(incf (counter3 *m*))
	(eyes *m*)

	(eat *m*)
	(speak *m* "world")
	(add-age *m* 3)
	(clean *m*)

	(def-class Son (Dad Mon)
	  ((first-name) age (sex "male") (hobby "game") (counter2 100 :class))

	  (eat () (format t "eat cake~%"))
	  (eat :before () (format t "before~%"))
	  (eat :after () (format t "after~%"))

	  (speak (str) (super str))

	  (study () (format t "I am studying~%"))

	  (playwith (x) (cond
					  ((equal 'Dad (type-of x)) (format t "Son:Dad"))
					  ((equal 'Son (type-of x)) (format t "Son:Son"))))
	  )
	(defparameter *s* (new Son first-name "Mars" age 5))
	(first-name *s*)
	(last-name *s*)
	(age *s*)
	(sex *s*)
	(hobby *s*)
	(eyes *s*)
	(counter1 *s*)
	(counter2 *s*)
	(counter3 *s*)
	(incf (counter2 *s*))

	(eat *s*)
	(speak *s* "hello world")
	(add-age *s* 1)
	(study *s*)
	(work *s*)
	(clean *s*)

	(let ((obj))
	  (if (< (random 100) 50)
		  (setf obj (new Son))
		  (setf obj (new Dad)))
	  (playwith obj obj))

