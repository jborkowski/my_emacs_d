(packages-conditional-install '(org org-bullets))

(require 'org)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(setq org-log-done t)
(setq org-directory "~/Documents/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))

(setq org-agenda-files
      (list (concat org-directory "/gtd.org")
            (concat org-directory "/work.org")
            (concat org-directory "/personal.org")))

(setq org-return-follows-link t)

(setq org-capture-templates
      '(
        ("j" "Journal" entry (file+datetree "~/Documents/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("x"  "Local Notes" entry (file+headline (lambda () (concat (file-name-directory buffer-file-name) "notes.org")) "Copied regions")
         "* %^{Title} %U \n %i")
        ("t" "Todo" entry (file+headline "~/Documents/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ))

(setq org-agenda-custom-commands 
    '(("w" todo "WAITING" nil) 
    ("n" todo "NEXT" nil)
    ("d" "Agenda + Next Actions" ((agenda) (todo "NEXT"))))
)

(setq org-publish-project-alist
      '(("org-notes"
         :base-directory org-directory
         :publishing-directory "~/Documents/public_html/"
         :publishing-function org-twbs-publish-to-html
         :with-sub-superscript nil
         )))

(defun my-org-publish-buffer ()
  (interactive)
  (save-buffer)
  (save-excursion (org-publish-current-file))
  (let* ((proj (org-publish-get-project-from-filename buffer-file-name))
         (proj-plist (cdr proj))
         (rel (file-relative-name buffer-file-name
                                  (plist-get proj-plist :base-directory)))
         (dest (plist-get proj-plist :publishing-directory)))
    (browse-url (concat "file://"
                        (file-name-as-directory (expand-file-name dest))
                        (file-name-sans-extension rel)
                        ".html"))))

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "s-/") 'my-org-publish-buffer)))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))