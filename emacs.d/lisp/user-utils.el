;;; user-utils.el --- -*- lexical-binding: t; -*-

;;; Commentary:

;; Contains various functions (most of them interactive, to be binded)

;;; Code:

;;;###autoload
(defun user-minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

;;;###autoload
(defun user-forward-paragraph (&optional n)
  "Advance just past next blank line.
With N goes forward that many paragraphs."
  (interactive "p")
  (let ((para-commands
         '(user-forward-paragraph user-backward-paragraph)))
    ;; Only push mark if it's not active and we're not repeating.
    (or (use-region-p)
        (not (member this-command para-commands))
        (member last-command para-commands)
        (push-mark))
    ;; The actual movement.
    (dotimes (_ (abs n))
      (if (> n 0)
          (skip-chars-forward "\n[:blank:]")
        (skip-chars-backward "\n[:blank:]"))
      (if (search-forward-regexp
           "\n[[:blank:]]*\\(\n[[:blank:]]*\\)+" nil t (cl-signum n))
          (goto-char (match-end 0))
        (goto-char (if (> n 0) (point-max) (point-min))))
      )
    ))

;;;###autoload
(defun user-backward-paragraph (&optional n)
  "Go back up to previous blank line.
With N goes back that many paragraphs."
  (interactive "p")
  (user-forward-paragraph (- n)))

(defmacro user-bol-with-prefix (function)
  "Define a new function which call FUNCTION.
Except it moves to beginning of line before calling FUNCTION when
called with a prefix argument.  The FUNCTION still receives the
prefix argument."
  (let ((name (intern (format "endless/%s-BOL" function))))
    `(progn
       (defun ,name (p)
         ,(format
           "Call `%s', but move to BOL when called with a prefix argument."
           function)
         (interactive "P")
         (when p
           (forward-line 0))
         (call-interactively ',function))
       ',name)))

;;;###autoload
(defun user-isearch-delete ()
  "Delete non-matching text or the last character.
If it's a regexp delete only the last char but only if
the error is \"incomplete input\", or \"trailing backslash\".
That way we don't remove the whole regexp for a simple typo.
\(Eg: for \"search-this-\(strni\" it would have deleted the whole \"strni\"\)."
  (interactive)
  (if (= 0 (length isearch-string))
      (ding)

    (if (or (string-equal isearch-error "incomplete input")
            (isearch-backslash isearch-string))
        (setq isearch-string (substring isearch-string 0 (1- (length isearch-string))))
      (setq isearch-string
            (substring isearch-string
                       0
                       (or (isearch-fail-pos) (1- (length isearch-string))))))

    (setq isearch-message
          (mapconcat #'isearch-text-char-description isearch-string "")))

  (funcall (or isearch-message-function #'isearch-message) nil t)

  (if isearch-other-end (goto-char isearch-other-end))
  (isearch-search)
  (isearch-push-state)
  (isearch-update))

;;;###autoload
(defun user-smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;;;###autoload
(defun user-open-line-above (arg)
  "Same thing as vim 'O' command.  With ARG opens that many lines."
  (interactive "p")

  (beginning-of-line)
  (open-line arg)
  (indent-according-to-mode))

;;;###autoload
(defun user-smarter-backward-kill-word ()
  "Deletes the previous word, respecting:
1. If the cursor is at the beginning of line, delete the '\n'.
2. If there is only whitespace, delete only to beginning of line and exit.
3. If there is whitespace, delete whitespace and check 4-5.
4. If there are other characters instead of words, delete one only char.
5. If it's a word at point, delete it."
  (interactive)

  (if (= (point) (line-beginning-position))
      ;; 1
      (delete-char -1)

    (if (string-match-p "^[[:space:]]+$"
                        (buffer-substring-no-properties
                         (line-beginning-position) (point)))
        ;; 2
        (delete-horizontal-space)

      (when (thing-at-point 'whitespace)
        ;; 3
        (delete-horizontal-space))

      (if (thing-at-point 'word)
          ;; 5
          (let ((start (car (bounds-of-thing-at-point 'word)))
                (end (point)))
            (if (> end start)
                (delete-region start end)
              (delete-char -1)))
        ;; 4
        (delete-char -1)))))

;;;###autoload
(defun user-smarter-kill-word-or-region ()
  "If the region is active, will call `kill-region'.
Else it will use `user-smarter-backward-kill-word'.
Basically simulates `C-w' in bash or vim when no region is active."
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (user-smarter-backward-kill-word)))

;;;###autoload
(defun user-comment-dwim (arg)
  "If a region is selected, it comments the region like `comment-dwim'.
If we are at the end of line, adds a comment like `comment-dwim'.
If none of the above, comment current line with `comment-line'.
The prefix ARG is given to the comment function."
  (interactive "*P")

  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end) arg)
    (if (= (point) (line-end-position))
        (comment-dwim arg)
      (comment-line arg))))

;;;###autoload
(defun user-ispell-word-on-line ()
  "Call `ispell-word'.
If there's nothing wrong with the word at point, keep looking for a typo
until the beginning of line.  You can skip typos you don't want to fix
with `SPC', and you can abort completely with `C-g'."
  (interactive "P")
  (let ((stop (line-beginning-position)))
    (save-excursion
      (while (if (thing-at-point 'word)
                 (if (ispell-word nil 'quiet)
                     nil ; End the loop.

                   (forward-word -1)
                   (> (point) stop))

               (forward-word -1)
               (> (point) stop))))))

;;;###autoload
(defun user-ispell-dwim ()
  "Call `ispell-buffer' of `ispell-comments-and-strings'.
Depends if the current major mode is derived from `prog-mode'.
Saves the position before.  You can skip typos you don't want to fix with
`SPC', and you can abort completely with `C-g'."
  (interactive)
  (save-excursion
    (if (derived-mode-p 'prog-mode)
        (ispell-comments-and-strings)
      (ispell-buffer))))

;;;###autoload
(defun user-next-error ()
  "Go to the next compilation error/search item (ignoring any elisp errors)."
  (interactive)
  (ignore-errors
    (next-error)))

;;;###autoload
(defun user-prev-error ()
  "Go to the previous compilation error/search item (ignoring any elisp errors)."
  (interactive)
  (ignore-errors
    (previous-error)))

;;;###autoload
(defun user-join-line ()
  "Join line like VIM."
  (interactive)
  (join-line -1))

(provide 'user-utils)

;;; user-utils.el ends here
