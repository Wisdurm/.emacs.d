;; Store easy-config files elsewhere
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)
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
;; yes, both are needed!
(setq default-tab-width 4)
(setq tab-width 4)
(setq default-fill-column 80)
(setq fill-column 80)
