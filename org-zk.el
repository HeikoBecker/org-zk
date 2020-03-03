(defcustom org-zk-dir "~/Zettelkasten/"
  "Default Zettelkasten directory.")

(defcustom org-zk-append-capture t
  "If non-nil, append a zettelkasten capture template to variable org-capture-templates")

(defun org-zk-visit-timestamped-file-with-title ()
  "Visit a new file named by the current timestamp"
  (interactive)
  (setq new-zettel--name (read-string "Title:"))
  (let* (
        (curr-date-stamp (format-time-string "%Y%m%d-%H%M"))
        (safe-file-name
         ;; escape some characters
         (replace-regexp-in-string ":" ""
         (replace-regexp-in-string "'" ""
         (replace-regexp-in-string " " "-" new-zettel--name))))
        (file-string (format "%s-%s.org" curr-date-stamp safe-file-name))
        (file-name (expand-file-name file-string org-zk-dir)))
  (set-buffer (org-capture-target-buffer file-name))
  (goto-char (point-max))))

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

(setq org-zk-plain-note-template
      "%(format \"#+TITLE: %s\n\" new-zettel--name)\
#+PROPERTY: Timestamp %<%Y%m%d-%H%M>\n\n%?")

(setq org-zk-paper-note-template
      (concat org-zk-plain-note-template
              "#+PROPERTY: BIBKEY %^{bibtexkey}\n\
#+PROPERTY: Tags %^{tags}\n\n\
%?* General Information\n\
** Category\n\
** Context (Related work and theoretical bases)\n\
** Correctness\n** Contributions\n** Clarity"))

(defun get-org-zk-plain-template ()
  (format "%s" org-zk-plain-note-template))

(defun get-org-zk-paper-template ()
  (format "%s" org-zk-paper-note-template))

;; Append a Zettelkasten capture for org-capture
(when org-zk-append-capture
  (setq org-capture-templates
    (append org-capture-templates
            '(
              ("Z" "Zettel [Note]" plain
               (function org-zk-visit-timestamped-file-with-title)
               (function get-org-zk-plain-template))
               ;;"#+TITLE: %^{TITLE}\n#+PROPERTY: Timestamp %<%Y%m%d_%H%M>\n\n %?")
              ("P" "Paper [Zettelkasten]" plain
               (function org-zk-visit-timestamped-file-with-title)
               (function get-org-zk-paper-template))))))
