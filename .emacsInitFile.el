(message "hello from org directory")

(setq custom-file "~/org/org-files/custom.el")


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))


(unless (package-installed-p 'use-package)
  ;; (package-refresh-contents :async)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
	use-package-expand-minimally t))

(global-visual-line-mode 1)

(electric-pair-mode 1)
(add-hook 'after-init-hook 'toggle-frame-maximized)

(use-package paredit
  :hook ((clojure-mode . enable-paredit-mode)
         (clojurescript-mode . enable-paredit-mode)
         (emacs-lisp-mode . enable-paredit-mode)))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t)


(use-package eldoc
  :ensure nil
  :config
  (global-eldoc-mode 1))

(use-package pdf-tools
  :ensure t
  :config
  (pdf-loader-install))


;; C-M-n, C-M-p, C-M-a, C-M-e, C-M-f, C-M-b movement around sexp and equivalent.
(let ((map global-map))
  (define-key map (kbd "C-M-k") #'kill-sexp)
  (define-key map (kbd "C-M-<backspace>") #'backward-kill-sexp))


(use-package denote
  :ensure t)
(setq denote-directory "/home/alpha/notes")

(use-package which-key
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
    which-key-side-window-max-width 0.33
    which-key-idle-delay 0.05)
  :diminish which-key-mode)
;; (provide 'init-which-key)	

(use-package emmet-mode
    :ensure t)
(use-package web-mode
    :ensure t)
(use-package prettier
    :ensure t)


(use-package org-roam
  :ensure t
  :bind
  ("C-c n l" . org-roam-buffer-toggle)
  ("C-c n f" . org-roam-node-find)
  ("C-c n i". org-roam-node-insert)
  ("C-c n c" . org-roam-capture)
  ("C-c n g" . org-roam-graph)
  :config
  (setq org-roam-directory (file-truename "~/org/org-roam"))
  (org-roam-db-autosync-mode)
   (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:25}" 'face 'org-tag))))


(use-package marginalia
  :config (marginalia-mode))		

(load "/home/alpha/org/develop/az-elisp-function.el")


(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)



(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil)))
  (add-hook 'rust-mode-hook
            (lambda () (prettify-symbols-mode))))

(use-package jupyter)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)))
 
(use-package company
	     :ensure t
)

(use-package company-quickhelp :ensure t :defer 30
  :config
  (company-quickhelp-mode t))


(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
	 (js-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)



;; Enabling only some features
(setq dap-auto-configure-features '(sessions locals controls tooltip))


;;(use-package lsp-ui :commands lsp-ui-mode)
(add-hook 'after-init-hook 'global-company-mode)


(use-package yasnippet
 :ensure t
 :config (use-package yasnippet-snippets
          :ensure t)
 :hook
         (python-mode . yas-minor-mode)
	 (c-mode-hook . yas-minor-mode)
	 (c++-mode-hook . yas-minor-mode)
	 (js2-mode . yas-minor-mode)
(yas-reload-all))


;; (use-package gdb-mi :quelpa (gdb-mi :fetcher git
;;                                     :url "https://github.com/weirdNox/emacs-gdb.git"
;;                                     :files ("*.el" "*.c" "*.h" "Makefile"))
;;   :init
;;   (fmakunbound 'gdb)
;;   (fmakunbound 'gdb-enable-debug))

(use-package expand-region
  :ensure t
  :bind ("M-m" . er/expand-region))

(use-package org-journal
  :ensure t
  :config
	(setq org-journal-dir "~/org/org-files/journal/")
	(setq org-journal-enable-agenda-integration t)
)

;; minibuffer history cycling with M-n, M-p
;; M-n when there is a default value will give you the default value
(use-package vertico
  :init	     
  (vertico-mode)
  (setq vertico-resize t)
  (setq vertico-count 40)
  (setq vertico-scroll-margin 0)
  )

(advice-add #'vertico--format-candidate :around
            (lambda (orig cand prefix suffix index _start)
              (setq cand (funcall orig cand prefix suffix index _start))
              (concat
               (if (= vertico--index index)
                   (propertize "->" 'face 'vertico-current)
                 "  ")
               cand)))

(use-package orderless
   :init
       ;; Configure a custom style dispatcher (see the Consult wiki)
       ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
       ;;       orderless-component-separator #'orderless-escapable-split-on-space)
       (setq completion-styles '(orderless)
             completion-category-defaults nil
             completion-category-overrides '((file (styles partial-completion)))))

(setq search-whitespace-regexp ".*?")

;; set up consult-outline and consult-grep
;; "Small-scale" search is C-s
;; "Larger-scale" search on `M-s M-KEY'
;; consult-outline = M-s M-s
;; consult-grep = M-s M-g
;; consult-line = M-s M-lo
(use-package consult
  :ensure t
  :bind
  ("C-x b" . consult-buffer)
  ("M-s M-l" . consult-line)
  ("M-s M-f" . consult-find) ;; search recursivly from the directory of any file you are visiting
  ("M-s M-s" . consult-outline)
  ("M-s M-g" . consult-grep)) 


(setq lpr-command "gtklp")

(setq ps-lpr-command "gtklp")
  
	
(setq backup-directory-alist '(("." . "~/.emacs.d/.saves")))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; (use-package zeal-at-point
;;   :ensure t
;;   :hook (
;; 	 (add-to-list 'zeal-at-point-mode-alist '(python-mode . ("python" "django")))
;; 	 (add-to-list 'zeal-at-point-mode-alist '(js2-mode . ("javascript))
;; )))


(use-package magit
  :ensure t)
(use-package calfw
  :ensure t)
(use-package calfw-org
  :ensure t)
(use-package calfw-cal
  :ensure t)
(require 'calfw) 
(require 'calfw-org)


; (global-set-key (kbd "C-c h")' helm-command-prefix) 
(global-unset-key (kbd "C-x c"))

;;General Keys I need to set always
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "M-8") 'compile)




(defun bms/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case  --type org --line-buffered --color=always --max-columns=500 --no-heading --line-number . -e ARG OPTS"))
    (consult-ripgrep org-roam-directory)))

(global-set-key (kbd "C-c rr") 'bms/org-roam-rg-search)

;; Open full size no menu's
'(Initial-frame-alist '((fullscreen . maximized)))
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)


(global-set-key "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
;; define-key prog-mode-map
(define-key global-map (kbd "C-c l") 'org-store-link)


(setq org-deadline-warning-days 0)

(setq org-bookmark-names-plist nil)
;; (set-face-attribute 'bookmark-face nil :background 'unspecified :foreground 'unspecified :inherit 'shadow) 
(setq org-agenda-custom-commands
      `(;; ("A" "Daily agenda and top priority tasks"
        ;;  ,prot-org-custom-daily-agenda
        ;;  ((org-agenda-fontify-priorities nil)
        ;;   (org-agenda-dim-blocked-tasks nil)))
        ;; ("P" "Plain text daily agenda and top priorities"
        ;;  ,prot-org-custom-daily-agenda
        ;;  ((org-agenda-with-colors nil)
        ;;   (org-agenda-prefix-format "%t %s")
        ;;   (org-agenda-current-time-string ,(car (last org-agenda-time-grid)))
        ;;   (org-agenda-fontify-priorities nil)
        ;;   (org-agenda-remove-tags t))
        ;;  ("agenda.txt"))
        ;; NOTE 2023-02-28 19:33 +0200: The above is what I sent you
        ;; via email.  So I am just expanding on this variable
        ("W" "TODO Tasks without a deadline or scheduled date"
         ((tags-todo
          "*"
          ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))))))))

;; (setq org-capture-templates
;; '(("t" "Todo" entry(file+headline "~/org/org-files/todo.org" "Tasks")
;;  "* TODO %?")
;;  ("b" "tech_base" plain (file my/create-techbase-file) "* + %^G \n%?")))



(setq org-capture-templates
      '(("g"
	 "General task (task without a date)"
	 entry
	 (file+headline "~/org/org-files/todo.org" "Tasks without dates")
	 "* TODO %?"
	 :prepend nil
	 :empty-lines-after 2
	 :empty-lines-before 2)

	("d"
	 "Task with a deadline"
	 entry
	 (file+headline "~/org/org-files/todo.org" "Tasks with a date")
	 "* TODO %?\nDEADLINE: %^T"
	 :prepend nil
	 :empty-lines-before 2
	 :empty-lines-after 2)

	("s"
	 "Task with a scheduled date"
	 entry
	 (file+headline "~/org/org-files/todo.org" "Tasks with a date")
	 "* TODO %?\nSCHEDULED: %^T"
	 :prepend nil
	 :empty-lines-before 2
	 :empty-lines-after 2)

	("l"
         "Task with link to mail attachment"
         entry
         (file+headline "~/org/org-files/todo.org" "Tasks with a mail attachement")
         "* TODO %?\n%l"
	 :prepend nil
	 :empty-lines-before 2
	 :empty-lines-after 2)


	("p"
	 "Items to discuss with Prot"
	 entry
	 (file+headline "~/org/org-files/todo.org" "prot")
	 "* %?"
	 :prepend nil
	 :empty-lines-before 2
	 :empty-lines-after 2)

	("i"
	 "Invoices that need to be entered and emailed"
	 entry
	 (file+headline "~/org/org-files/todo.org" "Customer Invoices")
	 "* TODO %?"
	 :prepend nil
	 :empty-lines-before 2	 
	 :empty-lines-after 2)

	("f"
	 "projects to do when we have time"
	 entry
	 (file+headline "~/org/org-files/todo.org" "future projects")
	 "* %?"
	 :prepend nil
	 :empty-lines-before 2
	 :empty-lines-after 2)))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(setq org-hide-emphasis-markers t)

  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  (use-package org-modern
    :config
    (add-hook 'org-mode-hook 'org-modern-mode))

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
(setq org-crypt-key nil)




(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "yellow" :weight bold)
              ("PROJECT" :foreground "forest green" :weight bold)
	      ("STUDY" :foreground "magenta" :weight bold))))

(use-package modus-themes
  :ensure
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend))


  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)
  :config
  ;; Load the theme of your choice:
  (modus-themes-load-vivendi) ;; OR (modus-themes-load-vivendi)
  :bind ("<f5>" . modus-themes-toggle))






;; (use-package zenburn-theme
;;   :ensure t
;;   :config
;;   (load-theme 'zenburn t))

(setq gc-cons-threshold (* 100 1024 1024)
	company-idle-delay 0.500
	lsp-completion-provider :capf
	lsp-log-io nil
	lsp-idle-delay 0.500
	lsp-enable-links nil
	lsp-signature-render-documentation nil
	lsp-headerline-breadcrumb-enable nil
	lsp-ui-doc-enable nil
	lsp-completion-enable-additional-text-edit nil
	web-mode-enable-current-element-highlight t)

(put 'narrow-to-region 'disabled nil)


;css sort
(use-package com-css-sort
    :commands (com-css-sort com-css-sort-attributes-block com-css-sort-attributes-document)
    :config   (setq com-css-sort-sort-type 'alphabetic-sort)
    )    ;end com-css-sort
;css-eldoc

(use-package css-eldoc
    :commands turn-on-css-eldoc
   ;add a hook if you want always to see the selector options in the minibuffer
    :config
    (add-hook 'css-mode-hook 'turn-on-css-eldoc)
    (add-hook 'scss-mode-hook 'turn-on-css-eldoc)
    );end css-eldoc


(use-package js-comint
    :ensure t)


(use-package server
    :config
    (add-hook 'after-init-hook #'server-start))
;;; Pass interface (password-store)

(use-package password-store
  :config
  (setq password-store-time-before-clipboard-restore 30)
  ;; Mnemonic is the root of the "code" word (κώδικας).  But also to add
  ;; the password to the kill-ring.  Other options are already taken.
  (define-key global-map (kbd "C-c k") #'password-store-copy))

(use-package pass) 

;;; Backups
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backup/"))))
(setq backup-by-copying t)
(setq version-control t)
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq create-lockfiles nil) 


(setq epa-pinentry-mode 'loopback)

;; Add mu4e to the load-path:
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")


(require 'mu4e)
(require 'smtpmail)


(setq mu4e-get-mail-command "mbsync -a")

;; DMS coordinates  40° 35' 12.16" N and a longitude of -73° 48' 41.31" W.
(setq calendar-latitude  40.58        ; these are DD cordinates
        calendar-longitude -73.81)

(define-key global-map (kbd "<XF86Favorites>") #'mu4e)
(setq
 user-mail-address "ari@marina59.com"
 user-full-name  "Ariel Zablozki"
 mu4e-compose-signature
 (concat
  "\t\t\tThank you,\n\n"
  "\t\t\tAriel Zablozki\n"
  "\t\t\thttps://www.marina59.com\n\t\t\thttps://www.linkedin.com/in/zblo/\n\n"

  "\tRockaway Beach, NY\n"
  "....... "(sunrise-sunset)))
(setq smtpmail-smtp-user nil)

(setq send-mail-function 'smtpmail-send-it)

(setq message-signature #'ari/my-signature) 
(use-package smtpmail
  :config
  ;; ;; FIXME 2023-01-26: Do I need any of this?  It seems that the
  ;; ;; contents of the `auth-sources' suffice for this case and
  ;; ;; smtpmail.el is set up to do the right thing out-of-the-box.
  ;; ;; Setting the values here seems wrong for anyone with multiple
  ;; ;; acounts from different service providers.
  (setq smtpmail-default-smtp-server "smtp.fastmail.com"
        smtpmail-smtp-server "smtp.fastmail.com"
        smtpmail-stream-type 'ssl
        smtpmail-smtp-service 465
        smtpmail-queue-mail nil)) 

(defun prot-common-auth-get-field (host prop)
  "Find PROP in `auth-sources' for HOST entry."
  (when-let ((source (auth-source-search :host host)))
    (if (eq prop :secret)
       (funcall (plist-get (car source) prop))
      (plist-get (flatten-list source) prop))))


(setq mu4e-completing-read-function 'completing-read) 
(setq mu4e-update-interval 60)
(setq mu4e-hide-index-messages t)
(setq display-buffer-alist
      '(("\\*mu4e-main\\*"
         (display-buffer-reuse-window display-buffer-same-window)))) 

(setq dired-recursive-deletes 'always)
(setq delete-by-moving-to-trash t) 
(setq dired-dwim-target t) 

(setq shr-use-colors nil)

(setq mu4e-contexts
      `(;; ,(make-mu4e-context
        ;;   :name "ari-old" ; Is there no way to specify a key for switching?
        ;;   :enter-func (lambda () (mu4e-message "Entering Marina"))
        ;;   :leave-func (lambda () (mu4e-message "Leaving Marina"))
        ;;   :match-func (lambda (msg)
        ;;                 (when msg
        ;;                   (mu4e-message-contact-field-matches
        ;;                    msg :to (prot-common-auth-get-field "imapmarina59" :user))))
        ;;   :vars `((user-mail-address . ,(prot-common-auth-get-field "imapmarina59" :user))
	;; 	  (mu4e-refile-folder . "/marina59/ari-old/archive")
        ;;           (mu4e-drafts-folder . "/marina59/ari-old/Drafts")
        ;;           (mu4e-sent-folder .  "/marina59/ari-old/Sent")
        ;;           (mu4e-trash-folder . "/marina59/ari-old/Trash")))

	,(make-mu4e-context
          :name "marina" ; Is there no way to specify a key for switching?
          :enter-func (lambda () (mu4e-message "Entering Marina"))
          :leave-func (lambda () (mu4e-message "Leaving Marina"))
          :match-func (lambda (msg)
                        (when msg
                          (mu4e-message-contact-field-matches
                           msg :to (prot-common-auth-get-field "imapmarina59" :user))))
          :vars `((user-mail-address . ,(prot-common-auth-get-field "imapmarina59" :user))
		  (mu4e-refile-folder . "/marina59/fastmail/Archive")
                  (mu4e-drafts-folder . "/marina59/fastmail/Drafts")
                  (mu4e-sent-folder .  "/marina59/fastmail/Sent")
                  (mu4e-trash-folder . "/marina59/fastmail/Trash")
		  ))))

(setq message-kill-buffer-on-exit t)

    (setq mu4e-bookmarks
          '((:name "ariUnread messages" :query "g:unread AND NOT g:trashed AND NOT maildir:/marina59/ari-old/ AND NOT maildir:/marina59/fastmail/Spam/" :key ?u)
            (:name "ariToday's messages" :query "d:today AND NOT g:trashed AND NOT g:replied AND NOT g:passed AND NOT maildir:/marina59/ari-old/ AND NOT maildir:/marina59/fastmail/Archive/ AND NOT maildir:/marina59/fastmail/Spam/ AND NOT maildir:/marina59/fastmail/Trash/ AND NOT maildir:/marina59/fastmail/Sent/ AND NOT maildir:/marina59/fastmail/Drafts/" :key ?t)
            (:name "ariLast 7 days" :query "d:7d..now AND NOT g:trashed AND NOT g:replied AND NOT g:passed AND NOT maildir:/marina59/fastmail/Archive/ AND NOT maildir:/marina59/ari-old/ AND NOT maildir:/marina59/fastmail/Spam/ AND NOT maildir:/marina59/fastmail/Trash/ AND NOT maildir:/marina59/fastmail/Sent/ AND NOT maildir:/marina59/fastmail/Drafts/" :key ?w)))



(setq org-agenda-files '("~/org/org-files/todo.org"))

;;(load "dired-x")

(setq indium-chrome-executable "google-chrome")


(use-package diredfl
  :ensure t
  :config
  (diredfl-global-mode 1))

(use-package all-the-icons-dired
  :ensure t
  :config
  (setq all-the-icons-dired-monochrome nil)
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))


(use-package dired-subtree
  :ensure t
  :config
  (setq dired-subtree-use-backgrounds nil)
  (let ((map dired-mode-map))
    (define-key map (kbd "<tab>") #'dired-subtree-toggle)
    (define-key map (kbd "<backtab>") #'dired-subtree-remove))) ; S-TAB 


(use-package dired
  :ensure nil
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-AGFhlv --group-directories-first --time-style=long-iso")
  (setq dired-dwim-target t)

  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  (add-hook 'dired-mode-hook #'hl-line-mode))


(use-package trashed
  :ensure t
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S")) 


    (defvar prot-dired--limit-hist '()
      "Minibuffer history for `prot-dired-limit-regexp'.")

(defun prot-dired-limit-regexp (regexp omit)
  "Limit Dired to keep files matching REGEXP.
    With optional OMIT argument as a prefix (\\[universal-argument]),
    exclude files matching REGEXP.
    Restore the buffer with \\<dired-mode-map>`\\[revert-buffer]'."
  (interactive
   (list
    (read-regexp
     (concat "Files "
             (when current-prefix-arg
               (propertize "NOT " 'face 'warning))
             "matching PATTERN: ")
     nil 'prot-dired--limit-hist)
    current-prefix-arg))
  (dired-mark-files-regexp regexp)
  (unless omit (dired-toggle-marks))
  (dired-do-kill-lines)
  (add-to-history 'prot-dired--limit-hist regexp))

(define-key dired-mode-map (kbd "C-c C-l") #'prot-dired-limit-regexp)


(use-package devdocs
  :ensure t)

(use-package js
  :ensure nil
  :config
  ;; Enables word motions inside camelCase words.
  (dolist (hook '(js-mode-hook js-ts-mode-hook js-comint-mode-hook))
    (add-hook hook #'subword-mode)))

(use-package js-comint
  :ensure t
  :config
  (setq js-comint-prompt "> ")

  (defun prot/js-comint-eval-keys ()
    "Bind local keys for JavaScript evaluation."
    (local-set-key (kbd "C-c C-z") #'js-comint-repl)
    ;; These are analogous to what we have for Elisp
    (local-set-key (kbd "C-x C-e") #'js-comint-send-last-sexp)
    (local-set-key (kbd "C-C C-e") #'js-comint-send-buffer))

  (dolist (hook '(js-mode-hook js-ts-mode-hook))
    (add-hook hook #'prot/js-comint-eval-keys)))

;;(use-package eglot :ensure t) 
;;js-comint-reset-repl 


(require 'ob-js)

(add-to-list 'org-babel-load-languages '(js . t))
(org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
(add-to-list 'org-babel-tangle-lang-exts '("js" . "js")) 

(define-key global-map (kbd "<XF86AudioMute>") #'shell) 


(defun my-move ()
(set-window-buffer (selected-window)"*AZ_MB*"))


(setq zoneinfo-style-world-list ; M-x shell timedatectl list-timezones
        '(("America/Los_Angeles" "Los Angeles")
	  ("UTC" "UTC")
          ("America/Chicago" "Chicago")
          ("Brazil/Acre" "Rio Branco")
          ("America/New_York" "New York")
          ("Brazil/East" "Brasília")
          ("Europe/Lisbon" "Lisbon")
          ("Europe/Brussels" "Brussels")
          ("Europe/Athens" "Athens")
          ("Asia/Tehran" "Tehran")
          ("Asia/Tbilisi" "Tbilisi")
          ("Asia/Yekaterinburg" "Yekaterinburg")
          ("Asia/Shanghai" "Shanghai")
          ("Asia/Tokyo" "Tokyo")
          ("Asia/Vladivostok" "Vladivostok")
          ("Australia/Sydney" "Sydney")
          ("Pacific/Auckland" "Auckland")))

(setq world-clock-time-format "%R %z  %A %d %B") ;M-x world clock

(use-package gnus
  :ensure nil
  :config
  (require 'gnus-sum)
  (require 'gnus-dired)
  (require 'gnus-topic)

;;; accounts
  (setq gnus-select-method '(nnnil ""))
  (setq gnus-secondary-select-methods
        '((nntp "news.gwene.org")))

  (setq gnus-search-use-parsed-queries nil) ; Emacs 28
;;; article
  (setq gnus-html-frame-width 80)
  (setq gnus-html-image-automatic-caching t)
  (setq gnus-inhibit-images t)
  (setq gnus-max-image-proportion 0.7)
  (setq gnus-treat-display-smileys nil)
  (setq gnus-article-mode-line-format "%G %S %m")
  (setq gnus-visible-headers
        '("^From:" "^To:" "^Cc:" "^Subject:" "^Newsgroups:" "^Date:"
          "Followup-To:" "Reply-To:" "^Organization:" "^X-Newsreader:"
          "^X-Mailer:"))
  (setq gnus-sorted-header-list gnus-visible-headers)
  (setq gnus-article-x-face-too-ugly ".*") ; all images in headers are outright annoying---disabled!
;;; async
  (setq gnus-asynchronous t)
  (setq gnus-use-article-prefetch 15)
;;; group
  (setq gnus-level-subscribed 6)
  (setq gnus-level-unsubscribed 7)
  (setq gnus-level-zombie 8)
  (setq gnus-activate-level 1)
  (setq gnus-list-groups-with-ticked-articles nil)
  (setq gnus-group-sort-function
        '((gnus-group-sort-by-unread)
          (gnus-group-sort-by-alphabet)
          (gnus-group-sort-by-rank)))
  (setq gnus-group-line-format "%M%p%P%5y:%B%(%g%)\n")
  (setq gnus-group-mode-line-format "%%b")
  (setq gnus-topic-display-empty-topics nil)
;;; summary
  (setq gnus-auto-select-first nil)
  (setq gnus-summary-ignore-duplicates t)
  (setq gnus-suppress-duplicates t)
  (setq gnus-save-duplicate-list t)
  (setq gnus-summary-goto-unread nil)
  (setq gnus-summary-make-false-root 'adopt)
  (setq gnus-summary-thread-gathering-function
        'gnus-gather-threads-by-subject)
  (setq gnus-summary-gather-subject-limit 'fuzzy)
  (setq gnus-thread-sort-functions
        '((not gnus-thread-sort-by-date)
          (not gnus-thread-sort-by-number)))
  (setq gnus-subthread-sort-functions
        'gnus-thread-sort-by-date)
  (setq gnus-thread-hide-subtree nil)
  (setq gnus-thread-ignore-subject nil)
  (setq gnus-user-date-format-alist
        '(((gnus-seconds-today) . "Today at %R")
          ((+ (* 60 60 24) (gnus-seconds-today)) . "Yesterday, %R")
          (t . "%Y-%m-%d %R")))

  ;; When the %f specifier in `gnus-summary-line-format' matches my
  ;; name, this will use the contents of the "To:" field, prefixed by
  ;; the string I specify.  Useful when checking your "Sent" summary or
  ;; a mailing list you participate in.
  (setq gnus-ignored-from-addresses "Ariel Zablozki")
  (setq gnus-summary-to-prefix "To: ")

  (setq gnus-summary-line-format "%U%R %-18,18&user-date; %4L:%-25,25f %B%s\n")
  (setq gnus-summary-mode-line-format "[%U] %p")
  (setq gnus-sum-thread-tree-false-root "")
  (setq gnus-sum-thread-tree-indent " ")
  (setq gnus-sum-thread-tree-single-indent "")
  (setq gnus-sum-thread-tree-leaf-with-other "+-> ")
  (setq gnus-sum-thread-tree-root "")
  (setq gnus-sum-thread-tree-single-leaf "\\-> ")
  (setq gnus-sum-thread-tree-vertical "|")


  (dolist (mode '(gnus-group-mode-hook gnus-summary-mode-hook gnus-browse-mode-hook))
    (add-hook mode #'hl-line-mode))

  (define-key global-map (kbd "C-c m") #'gnus)
  (let ((map gnus-article-mode-map))
    (define-key map (kbd "i") #'gnus-article-show-images)
    (define-key map (kbd "s") #'gnus-mime-save-part)
    (define-key map (kbd "o") #'gnus-mime-copy-part))
  (let ((map gnus-group-mode-map))       ; I always use `gnus-topic-mode'
    (define-key map (kbd "n") #'gnus-group-next-group)
    (define-key map (kbd "p") #'gnus-group-prev-group)
    (define-key map (kbd "M-n") #'gnus-topic-goto-next-topic)
    (define-key map (kbd "M-p") #'gnus-topic-goto-previous-topic))
  (let ((map gnus-summary-mode-map))
    (define-key map (kbd "<delete>") #'gnus-summary-delete-article)
    (define-key map (kbd "n") #'gnus-summary-next-article)
    (define-key map (kbd "p") #'gnus-summary-prev-article)
    (define-key map (kbd "N") #'gnus-summary-next-unread-article)
    (define-key map (kbd "P") #'gnus-summary-prev-unread-article)
    (define-key map (kbd "M-n") #'gnus-summary-next-thread)
    (define-key map (kbd "M-p") #'gnus-summary-prev-thread)
    (define-key map (kbd "C-M-n") #'gnus-summary-next-group)
    (define-key map (kbd "C-M-p") #'gnus-summary-prev-group)
    (define-key map (kbd "C-M-^") #'gnus-summary-refer-thread)))


(use-package elfeed
  :ensure t
  :config
  (setq elfeed-use-curl nil)
  (setq elfeed-curl-max-connections 10)
  (setq elfeed-db-directory (concat user-emacs-directory "elfeed/"))
  (setq elfeed-enclosure-default-dir "~/Downloads/")
  (setq elfeed-search-filter "@2-weeks-ago +unread")
  (setq elfeed-sort-order 'descending)
  (setq elfeed-search-clipboard-type 'CLIPBOARD)
  (setq elfeed-search-title-max-width 100)
  (setq elfeed-search-title-min-width 30)
  (setq elfeed-search-trailing-width 25)
  (setq elfeed-show-truncate-long-urls t)
  (setq elfeed-show-unique-buffers t)
  (setq elfeed-search-date-format '("%F %R" 16 :left))

  ;; Add your RSS feeds here.  The first element is a string, which is
  ;; the link to the RSS feed.  The rest are keywords, which you do
  ;; not need to quote.
  (setq elfeed-feeds
        '(("https://www.debian.org/News/news" gnu linux)
          ("https://www.archlinux.org/feeds/news/" gnu linux private)
	  ("https://bitcoin.org/en/rss/releases.rss" bitcoin)))

  (define-key global-map (kbd "C-c e") #'elfeed)

  (let ((map elfeed-search-mode-map))
    (define-key map (kbd "w") #'elfeed-search-yank)
    (define-key map (kbd "g") #'elfeed-update)
    (define-key map (kbd "G") #'elfeed-search-update--force))

  (define-key elfeed-show-mode-map (kbd "w") #'elfeed-show-yank))
