
(menu-bar-mode 0)
(add-to-list 'load-path "~/.emacs.d/site-lisp")

(require 'package)
(package-initialize)

;; (add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")))

(require 'color-theme-zenburn)
(color-theme-zenburn)

(when (require 'lusty-explorer nil 'noerror)

  ;; overrride the normal file-opening, buffer switching
  (global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
  (global-set-key (kbd "C-x b")   'buffer-menu))

(when (require 'deft nil 'noerror) 
   (setq
      deft-extension "org"
      deft-directory "~/Org/deft/"
      deft-text-mode 'org-mode)
   (global-set-key (kbd "<f9>") 'deft))

(when (require 'rainbow-delimiters nil 'noerror) 
  (add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'fundamental-mode-hook 'rainbow-delimiters-mode))