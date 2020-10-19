(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(eval-when-compile
  (require 'use-package))

;; Define my minor mode keybindings
(defvar matt-mode-map
  (let ((map (make-sparse-keymap)))
    map))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HELPFUL TIP, you can hook into "after-init-hook" to hook in a mode ;;
;; globally							      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define my minor mode which uses my keybindings
(define-minor-mode matt-mode
  "My global map"
  :init-value nil
  :lighter " matt"    ;; how this shows up in the bottom bar
  :keymap 'matt-mode-map)

;; Define a globalized version of my minor mode
;; to enable my minor mode in all buffers
(define-globalized-minor-mode g-matt-mode matt-mode
  (lambda () (matt-mode 1)))

(use-package g-matt-mode
  :init
  (g-matt-mode 1)
  :bind (:map matt-mode-map
	 ("C-x C-k" . kill-region)
	 ("C-x C-b" . ibuffer)
	 ("M-o" . other-window)
	 ("C-w" . backward-kill-word)
	 ("C-o" . (lambda ()
		    (interactive)
		    (save-excursion
	              (move-end-of-line 1)
	              (open-line 1))
		    (next-line)
		    (indent-for-tab-command)))))

;; configuration
;; (define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
(load-theme 'wombat)
(electric-pair-mode 1)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(setq inhibit-splash-screen t)

(defun aggressive-company-mode-on ()
  (interactive)
  (setq company-idle-delay 0))
  
(defun aggressive-company-mode-off ()
  (interactive)
  (setq company-idle-delay 0.5))

(use-package ibuffer
  :config
  (setq ibuffer-expert t))

(use-package lsp-mode
  :ensure t
  :defer t
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq gc-cons-threshold 100000000)
  :hook ((go-mode . lsp)
	 (js-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)) 
  :bind (("C-c i" . counsel-imenu))
  :commands lsp)

(use-package company-mode
  :hook lsp-mode)

(use-package flycheck
  :defer t
  :bind (("M-p" . flycheck-previous-error)
	 ("M-n" . flycheck-next-error)))

(use-package go-mode
  :defer t
  :ensure t)

(use-package exec-path-from-shell
  :ensure t)

(use-package org
  :defer t)

(use-package which-key
  :defer t
  :init
  (which-key-mode 1))

(use-package counsel
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-height 10)
  :bind (("C-x C-f" . counsel-find-file)
	 ("C-x C-m" . counsel-M-x)
	 ("C-h a" . counsel-apropos)
	 ("C-h f" . counsel-describe-function)
	 ("C-h v" . counsel-describe-variable)
	 ("C-x b" . ivy-switch-buffer)
	 ("C-c v" . ivy-push-view)
	 ("C-c V" . ivy-pop-view)
	 ("C-c S" . ivy-switch-view)
	 ("M-y" . counsel-yank-pop))
  :config
  (use-package ivy-hydra))

;; Worth checking out ivy-posframe and ivy-rich

(exec-path-from-shell-initialize)

(use-package isearch
  :commands (isearch-occur)
  :bind (:map isearch-mode-map
	 ("C-o" . isearch-occur)))

(use-package magit
  :bind (("C-x g" . magit-status)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit ivy-hydra company flycheck counsel which-key org lsp-mode exec-path-from-shell go-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
