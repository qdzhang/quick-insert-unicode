;;; quick-insert-unicode.el --- Quick insert unicode characters. -*- lexical-binding: t -*-

;; Copyright © 2022 qdzhang
;; Copyright © 2015 Emanuel Evans

;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; quick-insert-unicode
;; ====================

;;   A completing-read command for looking up unicode characters by name
;;   😉.  Modified from <https://github.com/qdzhang/ivy-unicode>.

;; Installation
;; ~~~~~~~~~~~~

;;   Clone this repository, and put `quick-insert-unicode.el' file to your
;;   `load-path', then require it.

;;   ,----
;;   | (require 'quick-insert-unicode)
;;   `----

;; Usage
;; ~~~~~

;;   `quick-insert-unicode'
;;     The main function to use, bind it to a key whatever you like. This
;;     function use `completing-read' to select unicode characters, and
;;     insert the selected item to current posotion.

;;; Code:

(defvar quick-insert-unicode-names nil
  "Internal cache variable for unicode characters.
Should not be changed by the user.")

(defun quick-insert-unicode-format-char-pair (char-pair)
  "Formats a char pair for quick-insert unicode search."
  (let ((name (car char-pair))
        (symbol (cdr char-pair)))
    (format "%s %c" name symbol)))

(defun quick-insert-unicode-build-candidates ()
  "Builds the candidate list."
  (let ((unames (if (hash-table-p (ucs-names))
                    (mapcar (lambda (elem) `(,elem . ,(gethash elem (ucs-names)))) (hash-table-keys (ucs-names)))
                  (ucs-names))))
    (sort
     (mapcar 'quick-insert-unicode-format-char-pair unames)
     #'string-lessp)))

(defun quick-insert-unicode-insert-char (candidate)
  "Insert CANDIDATE into the main buffer."
  (insert (substring candidate -1)))

;;;###autoload
(defun quick-insert-unicode (arg)
  "Use `completing-read' for looking up unicode characters by name, and insert
the selected item.

With prefix ARG, reinitialize the cache."
  (interactive "P")
  (when arg (setq quick-insert-unicode-names nil))
  ((lambda (x) (quick-insert-unicode-insert-char x))
   (completing-read "Unicode-char: " (quick-insert-unicode-build-candidates))))

(provide 'quick-insert-unicode)
;;; quick-insert-unicode.el ends here
