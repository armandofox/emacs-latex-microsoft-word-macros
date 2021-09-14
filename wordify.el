;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; turn the region into something suitable for pasting into Word or other
;;; non-ascii word processors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun change-many (change-list)
  (save-excursion
    (dolist (subst change-list)
      (goto-char (point-min))
      (while (re-search-forward (car subst) nil t)
        (replace-match (cadr subst) nil nil)))))
(provide 'change-many)

(defun wordify-region ()
  "Nondestructively convert region of TeX and text-filled source for
   pasting into MS Wurd, and leave converted region on kill ring"
  (interactive)
  (let ((buf (get-buffer-create "*wordify-temp*")))
    (save-excursion
      (set-buffer buf)
      (erase-buffer))
    (save-excursion
      (copy-to-buffer buf (point) (mark))
      (set-buffer buf)
      (change-many '(("\n\n" "~@@~")
                     ("\n" " ")
                     ("~@@~" "\n")
                     ("``" "Ò")
                     ("''" "Ó")
                     ("\s-+" " "))
      (copy-region-as-kill (point-min) (point-max))))))

(defun texify-region ()
  "Destructively convert region of pasted-in Wurd text to be TeX-friendly."
  (interactive)
  (save-excursion
    (narrow-to-region (point) (mark))
    (change-many '(("\\([^\\]\\)\\$" "\\1\\\\$")
                   ("^%" "~@@~") ("\\([^\\]\\)%" "\\1\\\\%") ("~@@~" "%")
                   ("’" "'")
                   ("‘" "`")
                   ("“" "``")
                   ("”" "''")
                   ("…" "\\\\ldots{}")
                   ("\\.\\.\\." "\\\\ldots{}")
                   ("\"\\([^\"]+\\)\"" "``\\1''")
                   ("—" "---")
                   ("–" "--")
                   ("½" "$1/2$")
                   ("¼" "$1/4$")
                   ))
    (fill-individual-paragraphs (point-min) (point-max))
    (widen)))

;;
;;                   ("\([^\\]\)%" "\\1\%")

(defun empty-region (nlines)
  "Convert filled paragraphs to unfilled paragraphs in region. With prefix arg,
insert that many blank lines between paragraphs (default 0)."
  (interactive "p")
  (replace-all-in-region '(("\\\n\\\n+" "@@@@")
                           ("\\s-*\\\n\\s-*" " ")
                           ("@@@@" "\n"))))

(defun copy-region-as-empty ()
  "Convert region to empty paragraphs and place it on the kill ring without
deleting it."
  (interactive)
  (save-restriction
    (save-excursion
      (empty-region 0)
      (copy-region-as-kill (point) (mark))
      (undo))))

(defun word-outline-to-latex ()
  "Convert multilevel (numbered) Outline text pasted from Word into section,
  subsection, etc. structure of laTeX."
  (interactive)
  (replace-all-in-region '(("^\\s-*[0-9]+\\s-+\\(.*\\)\\s-*$"
                            "\\\\section{\\1}")
                           ("^\\s-*[0-9]+\\.[0-9]+\\s-+\\(.*\\)\\s-*$"
                            "\\\\subsection{\\1}")
                           ("^\\s-*[0-9]+\\.[0-9]+\\.[0-9]+\\s-+\\(.*\\)\\s-*$"
                            "\\\\subsubsection{\\1}")
                           ("^\\\\" "\n\\\\")
                           )))

(defun replace-all-in-region (lst)
  (save-restriction
    (narrow-to-region (point) (mark))
    (let ((case-replace-search nil))
      (dolist (pair lst)
        (goto-char (point-min))
        (while (re-search-forward (first pair) nil t)
          (replace-match (second pair) nil nil))))))
