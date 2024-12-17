;;; portage-modes.el --- Major modes for editing Portage config files -*- lexical-binding: t; -*-

;; Copyright (C) 2024 OpenSauce

;; Author: OpenSauce <opensauce04@gmail.com>
;; URL: https://github.com/OpenSauce04/portage-modes
;; Version: 0.0
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; Adds several major modes which provides syntax highlighting for viewing and editing configuration files for Portage, Gentoo Linux's package manager.
;; When opening a file in `/etc/portage/`, the relevant mode is automatically enabled depending on which file is being viewed.
;; Highlighting rules and colors vary by mode depending on the expected content of the given file.

;;; Code:

;;; Custom face definitions
(defface portage-green-face '((t :foreground "green"))
  "Red face for portage-modes")
(defface portage-red-face '((t :foreground "red"))
  "Green face for portage-modes")

;;; Font lock keyword definitions
(defvar portage-common-font-lock-keywords
  ;; package.env keyword highlighting
  `(( ,(rx
        (group-n 1 "#")
        (group-n 2 (0+ nonl)))
      (1 'font-lock-comment-delimiter-face)
      (2 'font-lock-comment-face))))

(defvar portage-env-mode-font-lock-keywords
  ;; package.env keyword highlighting
  `(( ,(rx
        (group-n 1
          " "
          (1+ nonl)))
      (1 'font-lock-function-call-face))))

(setq portage-keywords-expression `(or 
                       "*" "alpha" "amd64" "arm" "arm64" "hppa" "loong" "m68k" "mips" "ppc" "ppc64" "riscv" "s390" "sparc" "x86"
                       "amd64-linux" "arm-linux" "arm64-linux" "ppc64-linux" "riscv-linux" "x86-linux" "arm64-macos" "ppc-macos" "x86-macos" "x64-macos" "x64-solaris"))
(defvar portage-keyword-mode-font-lock-keywords
  ;; package.accept_keywords keyword highlighting
  `(( ,(rx
        (group-n 1
          " "
          (zero-or-one "~")
          (eval portage-keywords-expression)))
      (1 'portage-green-face))
    ( ,(rx
        (group-n 1
          " -"
          (zero-or-one "~")
          (eval portage-keywords-expression)))
      (1 'portage-red-face))))

(defvar portage-license-mode-font-lock-keywords
  ;; package.env keyword highlighting
  `(( ,(rx
        (group-n 1
          " "
          (1+ nonl)))
      (1 'font-lock-keyword-face))))

(defvar portage-use-mode-font-lock-keywords
  ;; package.use keyword highlighting
  `(( ,(rx
        (group-n 1
          " -"
          (1+ (not whitespace))))
      (1 'portage-red-face))
    ( ,(rx
        (group-n 1
          " "
          (1+ (not whitespace))))
      (1 'portage-green-face))))

;;; Major mode definitions
;;;###autoload
(define-derived-mode portage-env-mode prog-mode
  (font-lock-add-keywords nil portage-env-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-keyword-mode prog-mode
  (font-lock-add-keywords nil portage-keyword-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-license-mode prog-mode
  (font-lock-add-keywords nil portage-license-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-use-mode prog-mode
  (font-lock-add-keywords nil portage-use-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-common-font-lock-keywords))

;;; Major mode active files
(add-to-list 'auto-mode-alist '("^/etc/portage/package.accept_keywords.*" . portage-keyword-mode))
(add-to-list 'auto-mode-alist '("^/etc/portage/package.env" . portage-env-mode))
(add-to-list 'auto-mode-alist '("^/etc/portage/package.license" . portage-license-mode))
(add-to-list 'auto-mode-alist '("^/etc/portage/package.use.*" . portage-use-mode))
(add-to-list 'auto-mode-alist '("^/etc/portage/profile/package.use.force.*" . portage-use-mode))
(add-to-list 'auto-mode-alist '("^/etc/portage/profile/package.use.mask.*" . portage-use-mode))

(provide 'portage-modes)

;;; portage-modes.el ends here
