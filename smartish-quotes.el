;; Copyright © 2018 by D. F. Hall <authorfunction@hardboiledbabylon.com>

;; Permission to use, copy, modify, and/or distribute this software for
;; any purpose with or without fee is hereby granted, provided that the
;; above copyright notice and this permission notice appear in all
;; copies.

;; THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
;; WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
;; AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
;; DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
;; OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
;; TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
;; PERFORMANCE OF THIS SOFTWARE.

;; NOTE:
;; These were pulled from dfh-str.el and dfh-pair.el to make this
;; more portable as a single file.

(defun smartish--insert-pair (pair-left pair-right)
  (if (use-region-p)
      (progn
	(let ((point-start (region-beginning)) (point-end (region-end)))
	  (deactivate-mark)
	  (goto-char point-end)
	  (insert pair-right)
	  (goto-char point-start)
	  (insert pair-left)
	  (goto-char (+ (length pair-left) point-start))))
    (insert pair-left)
    (let ((point-save (point)))
      (insert pair-right)
      (goto-char point-save))))

(defun smartish--preceding-string (len)
  (if (bobp)
      ""
    (if (< (point) len)
	""
      (buffer-substring-no-properties (- (point) len) (point)))))

;; NOTE END

(defvar smartish-quotes-user-custom-open-str nil)

(defvar smartish-double-quote-left "``")
(defvar smartish-double-quote-right "''")
(defvar smartish-single-quote-left "`")
(defvar smartish-single-quote-right "'")

;; linefeed  #x000A
;; space     #x0020
(defun smartish--do-replace-or-insert-quote ()
  (let (( cb (preceding-char) ))
    (if (or (= cb #x000A) (= cb #x0020) (= cb 0))
	(insert smartish-double-quote-left)
      (insert smartish-double-quote-right))))

(defun smartish-insert-double-quote ()
  (interactive)
  (when (use-region-p) (delete-region (region-beginning) (region-end)))
  (if smartish-quotes-user-custom-open-str
      (if (string=
	   (smartish--preceding-string
            (length smartish-quotes-user-custom-open-str))
	   smartish-quotes-user-custom-open-str)
	  (insert smartish-double-quote-left)
	(smartish--do-replace-or-insert-quote))
    (smartish--do-replace-or-insert-quote)))

(defun smartish-insert-double-quote-pair ()
  (interactive)
  (smartish--insert-pair smartish-double-quote-left
                         smartish-double-quote-right))

(defun smartish-insert-single-quote-pair ()
  (interactive)
  (smartish--insert-pair smartish-single-quote-left
                         smartish-single-quote-right))

(defvar smartish-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "\"") 'smartish-insert-double-quote)
;;    (define-key map (kbd "C-c 3 '") 'smartish-insert-single-quote-pair)
    map)
  "Keymap for `smartish-quotes-mode'.")

(define-minor-mode smartish-quotes
  "A mode for inserting smart typographical quotations."
  :lighter " ``''"
  :keymap smartish-keymap)

(provide 'smartish-quotes)
