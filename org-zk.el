(defvar org-zk-dir "~/Zettelkasten/"
  "Default Zettelkasten directory.")

(defvar org-zk-append-capture t
  "If non-nil, append a zettelkasten capture template to variable org-capture-templates")

(defun org-zk-visit-timestamped-file ()
  "Visit a new file named by the current timestamp"
  (interactive)
  (let* (
        (curr-date-stamp (format-time-string "%Y%m%d-%H%M.org"))
        (file-name (expand-file-name curr-date-stamp org-zk-dir)))
  (set-buffer (org-capture-target-buffer file-name))
  (goto-char (point-max))))

(defun org-zk-find-zettel-by-content (content)
  "Searches in the Zettelkasten for content specified in @content"
  (interactive "bSearch for:")
  (grep-compute-defaults)
  (rgrep content "*.org" org-zk-dir))

;; Append a Zettelkasten capture for org-capture
(when org-zk-append-capture
  (setq org-capture-templates
    (append org-capture-templates
            '(
              ("Z" "Zettel [Note]" plain
               (function org-zk-visit-timestamped-file)
               "#+TITLE: %^{TITLE}\n#+PROPERTY: Timestamp %<%Y%m%d_%H%M>\n\n %?")
              ("P" "Paper [Zettelkasten]" plain
               (function org-zk-visit-timestamped-file)
               "#TITLE: %^{Title}\n#+PROPERTY: Timestamp %<%Y%m%d_%H%M>\n\
#+PROPERTY: BIBKEY %^{bibtexkey}\n\
#+TAGS:\n\n\
%?* General Information\n\
** Category\n\
** Context (Related work and theoretical bases)\n\
** Correctness\n** Contributions\n** Clarity")
              ))))
