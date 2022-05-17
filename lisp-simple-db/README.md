# Simple database using common-lisp
## Usage:
A.Table:

1.to create a table:

    (create-table 'student :id :name :age :sex :class)

2.to see more about the tables created:

    (about-table)

3.to remove a table:

    (remove-table 'student)

B.Column:

1.to add columns:

    (add-column 'student :score :tel)

2.to remove columns:

    (remove-column 'student :score :tel)

C.Rows:

1.to insert a row:

    (insert-into 'student 007 "b2ns" 100 "male" 5)

2.to select rows:

    (select-from 'student "all" (where "all"))
    (select-from 'student (:name :age) (where (:name "b2ns")) (orderby :age <))
    (select-from 'student (:name :age :class) (where (:name has "ns") (:age > 5 <= 50 /= 22) (:class 10)) (orderby :id <))

3.to update rows:

    (update 'student (where (:name "b2ns")) :age 1 :class 12 :id 008)

4.to delete rows:

    (delete-from 'student (where (:age < 18)))

D.Database

1.to save the whole dateabase:

    (save-db "filename.db")

2.to load a dateabase:

    (load-db "filename.db")

3.to clear the whole dateabase:

    (clear-db)

E.Math function

    (count-tb 'student (where (:name has "ing")))
    (max-tb 'student (where "all") :age)
    (min-tb 'student (where (:sex "female")) :age)
    (sum-tb 'student (where "all") :age)
    (avg-tb 'student (where "all") :age)

