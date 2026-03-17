;; Store easy-config files elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;; ************************
;; EMACS STUFF
;; ************************

;;; Functions

;; Copy line
(defun copy-line()
  (interactive)
  (let ((opoint (point))) ; save-excursion not work :(
	(move-beginning-of-line 1)
	(kill-line)
	(yank)
	(goto-char opoint)))
(global-set-key (kbd "C-M-y") 'copy-line)

;; Jump between matching symbols
(defun hop-between-pairs(dir)
  "Jumps between matching symbols under the cursor.
For example, can between closing and opening parentheses,
html tags, lua blocks and everything else I can be bothered
to add"
  (interactive "cDirection: ")
  (if (eq ?f dir)
	  (progn ;; Forward
		(if (or (eq ?\( (char-after))
				(eq ?\( (char-before))
				(eq ?\{ (char-after))
				(eq ?\{ (char-before))
				(eq ?\[ (char-before))
				(eq ?\[ (char-after)))
			(forward-sexp) ;; Generic jump
		  (if (eq major-mode 'mhtml-mode) ;; Html
			  (sgml-skip-tag-forward 1)
			(if (eq major-mode 'lua-mode) ;; Lua
				(progn ;; Jump to before last symbol because that's good for lua
				  (end-of-line)
				  (backward-word)
				  (lua-forward-sexp))
			))))
	(progn ;; Backward
	  (if (or (eq ?\) (char-after))
			  (eq ?\) (char-before))
			  (eq ?\} (char-after))
			  (eq ?\} (char-before))
			  (eq ?\] (char-before))
			  (eq ?\] (char-after)))
		  (backward-sexp) ;; Generic jump
		(if (eq major-mode 'mhtml-mode) ;; Html
			(sgml-skip-tag-backward 1)
		  (if (eq major-mode 'lua-mode) ;; Lua
			  (lua-backward-up-list)
		  ))))
	))
; Bind
(keymap-global-set "C-c h" 'hop-between-pairs)
;; Tabs (on by default I think because of perspective? idk...)
(keymap-global-set "C-c t" 'tab-switcher)
;; Disable tool bar
(tool-bar-mode -1)
;; UTF-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
;; Show empty lines
(setq-default indicate-empty-lines t)
;; Scroll margin
(setq scroll-margin 8)
;; Undo limits
;; Limit of 64mb.
(setq undo-limit 67108864)
;; Strong limit of 1.5x (96mb)
(setq undo-strong-limit 100663296)
;; Outer limit of 10x (960mb).
(setq undo-outer-limit 1006632960)
;; Indentation
(setq-default backward-delete-char-untabify-method nil)
(setq indent-tabs-mode t)
(setq-default indent-tabs-mode t)
(setq default-tab-width 4)
(setq-default tab-width 4)
(setq tab-width 4)
;; Mentally sane formatting
(defun c-mode-fuckyou-emacs()
  (c-set-style "bsd"))
(add-hook 'c-mode-common-hook 'c-mode-fuckyou-emacs)
;; Fill column
(setq-default fill-column 80)
;;; Unbind 'C-x f'
(keymap-global-unset "C-x f")
;; Give specific languages the same width
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
;; Autocomplete after tabulation
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)
(defvaralias 'sgml-basic-offset 'tab-width)
;; Whitespace clarity
(setq x-stretch-cursor t)
;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; Default text mode and autofill mode
(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;; Transparent background
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))
;; GDB window apocalypse
(setq gdb-many-windows t)
;; Make C-q more intuitive
(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)
;; ************************
;; SENSIBLE DEFAULTS
;; ************************
;; Sensible defaults
(add-to-list 'load-path "~/.emacs.d/sensible-defaults")
(require 'sensible-defaults)
;; Enable some
(sensible-defaults/automatically-follow-symlinks)
(sensible-defaults/make-scripts-executable)
(sensible-defaults/single-space-after-periods)
(sensible-defaults/offer-to-create-parent-directories-on-save)
(sensible-defaults/overwrite-selected-text)
(sensible-defaults/make-dired-file-sizes-human-readable)
(sensible-defaults/always-highlight-code)
(sensible-defaults/show-matching-parens)
(sensible-defaults/flash-screen-instead-of-ringing-bell)
(sensible-defaults/yank-to-point-on-mouse-click)
(sensible-defaults/offer-to-create-parent-directories-on-save)
;; All keybindings are cool
(sensible-defaults/use-all-keybindings)
;; Dont clog directories with back-up files
(sensible-defaults/backup-to-temp-directory)
(setq backup-by-copying t
	  version-control t 
	  delete-old-versions t
	  delete-by-moving-to-trash nil
	  kept-old-versions 2
      kept-new-versions 6
      auto-save-default t ;; auto-save every buffer that visits a file
      auto-save-timeout 20 ;; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 300) ;; number of keystrokes between auto-saves (default: 300)
;; ************************
;; PACKAGES
;; ************************
;; Initialize package manager
(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; Incase emacs -v < 29 (unlikely, since even Debian 13 has v30)
(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))
;; Packages

;; Delete selected text when writing
(use-package delsel
  :ensure nil ; no need to install it as it is built-in
  :hook (after-init . delete-selection-mode))

;; Theme (Standard dark tinted)
;; Not really sure what's going on here
(use-package standard-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(standard-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/standard-themes#h:d8ebe175-cd61-4e0b-9b84-7a4f5c7e09cd>
  (standard-themes-take-over-modus-themes-mode 1)
  :bind ;; These are kind of fun :D
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs nil)

  ;; Finally, load your theme of choice
  (modus-themes-load-theme 'standard-dark-tinted))

;; Nerd font
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; Command descriptions
(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

;; Preview subdirs in dired
(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))
(put 'narrow-to-region 'disabled nil)
;; Magit??
(use-package magit
  :ensure t
  )
;; Quick window switching
(use-package ace-window
  :ensure t
  )
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-c o") 'ace-swap-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; Simple markdown preview, might change out later, but
;; this is already one of the most convenient
(use-package gh-md
  :ensure t
  )
;; Multiple "workspaces" (like tab-bar-mode, but a bit different)
(use-package perspective
  :ensure t
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))  ; pick your own prefix key here
  :init
  (persp-mode))
;; Save workspace (persp-mode.el looks rough )
(use-package activities
  :ensure t
  :init
  (activities-mode)
  (activities-tabs-mode)
  ;; Prevent `edebug' default bindings from interfering.
  (setq edebug-inhibit-emacs-lisp-mode-bindings t)

  :bind
  (("C-x C-a C-n" . activities-new)
   ("C-x C-a C-d" . activities-define)
   ("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-s" . activities-suspend)
   ("C-x C-a C-k" . activities-kill)
   ("C-x C-a RET" . activities-switch)
   ("C-x C-a b" . activities-switch-buffer)
   ("C-x C-a g" . activities-revert)
   ("C-x C-a l" . activities-list)))
;; Add lua
(use-package lua-mode
  :ensure t
  )
;; Orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring
;; Lsp
(use-package lsp-mode
  :ensure t
  :hook (prog-mode . lsp-deferred)
  :custom
  (lsp-auto-guess-root t))                ;; auto guess root
(keymap-global-set "C-c r" 'lsp-rename)
;; Not super pretty but very functional
(setq-default flymake-show-diagnostics-at-end-of-line t)
(setq flymake-show-diagnostics-at-end-of-line t)
;; Logging because Emacs sucks ass 
(setq lsp-log-io t)
(setq lsp-print-io t)
;; Trust emacs formatting for now
(setq lsp-enable-indentation nil)
(setq lsp-enable-on-type-formatting nil)
;; Code completion
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :bind (:map company-mode-map
			  ([remap completion-at-point] . company-complete))
  :custom
  (company-idle-delay 0)
  (company-echo-delay 0)
  (company-show-numbers t)
  (company-require-match nil)
  (company-tooltip-align-annotations t)
  (company-backends '(company-capf)))
(keymap-global-set "C-c TAB" 'company-complete)
(put 'upcase-region 'disabled nil)
;; Fast movement
(use-package avy
  :ensure t)
;; Trying which one feels better
(keymap-global-set "C-c j" 'avy-goto-word-1)
(keymap-global-set "C-c m" 'avy-goto-char-2)
