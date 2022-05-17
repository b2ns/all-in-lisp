# Infix-notation transform into prefix-notation or post-notation in Lisp
## Usage:
1.infix-notation to prefix-notation:

    (trans-notation "pre" 1 + 2.0 * :[ 3e2 - 0.4 :] / 5)
    => + 1 / * 2.0 - 300.0 0.4 5

2.infix-notation to postfix-notation:

    (trans-notation "post" 1 + 2.0 * :[ 3e2 - 0.4 :] / 5)
    => 1 2.0 300.0 0.4 - * 5 / +

3.use infix-notation to calculate in common-lisp:

    (infix-cal 1 + 2.0 * :[ 3e2 - 0.4 :] / 5)
    => 120.840004

