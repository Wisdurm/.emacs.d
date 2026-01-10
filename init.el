;; Store easy-config files elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;; ************************
;; EMACS STUFF
;; ************************
;; Copy line
(defun copy-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (move-beginning-of-line 1)
)
(global-set-key (kbd "C-M-y") 'copy-line)
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
(setq-default fill-column 80)
;; Specific languages
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
;; Whitespace clarity
(setq x-stretch-cursor t)
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
;; Dont clog directories with auto-save files
(sensible-defaults/backup-to-temp-directory)
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
