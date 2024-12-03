;; Local

(when (file-readable-p "local-before.el")
  (ignore-errors (load-file "local-before.el")))

;; Variables

(defvar workspace-path "~/workspace/" "Folder with all the projects")

(defvar notes-path "~/Documents/notes/" "Folder with notes")

;; Utilities

(defmacro comment (&rest body)
  "Comment out one or more s-expressions."
  nil)

(defun my-notes ()
  (interactive)
  (dired notes-path))

(defun my-workspace ()
  (interactive)
  (dired workspace-path))

(setq my/eshell-aliases
      '((g  . magit)
	(gl . magit-log)
	(d  . dired)
	(o  . find-file)
	(w  . (lambda () (dired workspace-path)))
	(oo . find-file-other-window)
	(l  . (lambda () (eshell/ls '-la)))
	(eshell/clear . eshell/clear-scrollback)))

(mapc (lambda (alias)
	(defalias (car alias) (cdr alias)))
      my/eshell-aliases)

;; Setup Packages

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(use-package pass
  :ensure t)

(use-package password-store-otp
  :ensure t)

(use-package password-store
  :ensure t)

(use-package denote
  :ensure t
  :custom
  (denote-directory notes-path))

(use-package ace-window
  :ensure t
  :config
  (global-set-key [remap other-window] #'ace-window))

(use-package avy
  :ensure t
  :bind (("C-j" . avy-goto-char-2)))

(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook
            (lambda ()
              (setq-local indent-tabs-mode nil)
              (setq-local tab-width 2))))

(use-package magit
  :ensure t)

(use-package eglot
  :ensure t
  :hook ((python-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (typescript-mode . eglot-ensure))
  :commands eglot eglot-ensure
  :bind
  (("C-c c r" . eglot-rename)
   ("C-c c a" . eglot-code-actions)
   ("C-c c d" . eglot-find-declaration)
   ("C-c c t" . eglot-find-type-definition)
   ("C-c c i" . eglot-find-implementation)
   ("C-c c h" . eldoc-doc-buffer)
   ("C-c c e" . flymake-show-buffer-diagnostics)
   ("C-c c f" . eglot-format-buffer))
  :config
  (setq eglot-autoshutdown t))

(use-package company
  :ensure t
  :hook ((text-mode prog-mode) . company-mode))

(use-package wgrep
  :ensure t
  :bind (:map grep-mode-map
	      ("e" . #'wgrep-change-to-wgrep-mode)
	      ("C-c C-c" . #'wgrep-finish-edit)))

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t)
  (vertico-count 13)
  (vertico-resize t)
  (vertico-multiline-threshold 0)
  :config
  (savehist-mode 1)
  (setq read-buffer-completion-ignore-case t
        read-file-name-completion-ignore-case t
        completion-ignore-case t))

(use-package marginalia
  :ensure t
  :after vertico
  :init
  (marginalia-mode 1))

(use-package orderless
  :ensure t
  :after vertico
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package ibuffer
  :ensure nil
  :bind (("C-x C-b" . ibuffer)))

(use-package consult
  :ensure t
  :bind (("M-s M-b" . consult-buffer)
	 ("M-s M-f" . consult-find)
	 ("M-s M-g" . consult-grep)
	 ("M-s M-l" . consult-line)
	 ("M-s M-o" . consult-outline)))

(use-package org
  :ensure t)

(use-package org-tempo
  :after org
  :demand t)

(use-package json-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package browse-at-remote
  :ensure t
  :commands (browse-at-remote browse-at-remote-kill))

(use-package yasnippet
  :ensure t
  :hook
  ((prog-mode) . yas-minor-mode))

(use-package yasnippet-snippets
  :ensure t)

(use-package prettier-js
  :ensure t
  :hook (yaml-mode json-mode typescript-mode js-mode typescript-tsx-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package transient
  :ensure t)

(unless  (eq system-type 'windows-nt)
  (use-package vterm
    :ensure t))

(use-package jest-test-mode
  :ensure t
  :commands jest-test-mode
  :hook (typescript-mode js-mode typescript-tsx-mode))

;; Look & Feel

(use-package ef-themes
  :ensure t
  :config
  (ef-themes-select 'ef-light))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(global-hl-line-mode)


;; LLMs

(use-package gptel
  :ensure t
  :config
  (gptel-make-gemini "Gemini" :stream t :key (lambda () (password-store-get "google/gemini-api-key")))
  (gptel-make-anthropic "Claude" :stream t :key (lambda () (password-store-get "anthropic/claude-api-key")))
  (setq
   gptel-api-key (lambda () (password-store-get "openai/api-key"))
   gptel-model 'llama3.2:latest
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '(llama3.2:latest))))


;; Constant Improvement

(use-package speed-type
  :ensure t)

;; Local

(when (file-readable-p "local-after.el")
  (ignore-errors (load-file "local-after.el")))
