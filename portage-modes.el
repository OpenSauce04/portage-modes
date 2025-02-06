;;; portage-modes.el --- Major modes for editing Portage config files

;; Copyright (C) 2024 OpenSauce

;; Author: OpenSauce <opensauce04@gmail.com>
;; URL: https://github.com/OpenSauce04/portage-modes
;; Version: 0.4
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; Adds several major modes which provide syntax highlighting when
;; viewing or editing configuration files for Portage, the Gentoo
;; Linux package manager.
;;
;; When opening a file in `/etc/portage/`, the
;; relevant mode is automatically enabled depending on which file is
;; being viewed.
;;
;; Highlighting rules and colors vary by mode depending
;; on the expected content of the given file.

;;; Code:

;;; Custom face definitions
(defface portage-modes-positive-face '((t :inherit 'success :weight normal))
  "Face used by portage-modes to indicate that something is being added.")
(defface portage-modes-negative-face '((t :inherit 'error :weight normal))
  "Face used by portage-modes to highlight that something is being removed.")

;;; Font lock keyword definitions
(defvar portage-modes-common-font-lock-keywords
  ;; package.env keyword highlighting
  `(( ,(rx
        (group-n 1 "#")
        (group-n 2 (0+ not-newline)))
      (1 'font-lock-comment-delimiter-face)
      (2 'font-lock-comment-face))))

(defvar portage-modes-env-mode-font-lock-keywords
  ;; package.env keyword highlighting
  `(( ,(rx
        (group-n 1
          " "
          (1+ not-newline)))
      (1 'font-lock-function-call-face))))

(defvar portage-modes-keywords-expression (rx(or
                                              "*" "**" "alpha" "amd64" "arm" "arm64" "hppa" "loong" "m68k" "mips" "ppc" "ppc64" "riscv" "s390" "sparc" "x86"
                                              "amd64-linux" "arm-linux" "arm64-linux" "ppc64-linux" "riscv-linux" "x86-linux" "arm64-macos" "ppc-macos" "x86-macos" "x64-macos" "x64-solaris")))
(defvar portage-modes-keywords-mode-font-lock-keywords
  ;; package.accept_keywords keyword highlighting
  `(( ,(rx
        (group-n 1
          " "
          (zero-or-one "~")
          (or (regex portage-modes-keywords-expression))
          symbol-end))
      (1 'portage-modes-positive-face))
    ( ,(rx
        (group-n 1
          " -"
          (zero-or-one "~")
          (or (regex portage-modes-keywords-expression))
          symbol-end))
      (1 'portage-modes-negative-face))))

(defvar portage-modes-license-mode-font-lock-keywords
  ;; package.env keyword highlighting
  `(( ,(rx
        (group-n 1
          " "
          (1+ not-newline)))
      (1 'font-lock-keyword-face))))

(defvar portage-modes-use-mode-font-lock-keywords
  ;; package.use keyword highlighting
  `(( ,(rx
        (group-n 1
          " -"
          (1+ (not whitespace))))
      (1 'portage-modes-negative-face))
    ( ,(rx
        (group-n 1
          " "
          (1+ (not whitespace))))
      (1 'portage-modes-positive-face))))

;;; Major mode definitions
;;;###autoload
(define-derived-mode portage-modes-env-mode prog-mode
  "Portage-Env"
  "Major mode for editing Portage's package.env file"
  (font-lock-add-keywords nil portage-modes-env-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-modes-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-modes-generic-mode prog-mode
  "Portage-Generic"
  "Major mode for editing miscellaneous Portage files"
  (font-lock-add-keywords nil portage-modes-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-modes-keywords-mode prog-mode
  "Portage-Keywords"
  "Major mode for editing Portage's package.accept_keywords file(s)"
  (font-lock-add-keywords nil portage-modes-keywords-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-modes-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-modes-license-mode prog-mode
  "Portage-License"
  "Major mode for editing Portage's package.license file"
  (font-lock-add-keywords nil portage-modes-license-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-modes-common-font-lock-keywords))

;;;###autoload
(define-derived-mode portage-modes-use-mode prog-mode
  "Portage-Use"
  "Major mode for editing Portage's package.use file(s)"
  (font-lock-add-keywords nil portage-modes-use-mode-font-lock-keywords)
  (font-lock-add-keywords nil portage-modes-common-font-lock-keywords))

;;; Major mode active files
;;;###autoload
(progn
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.accept_keywords\\'" . portage-modes-keywords-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.accept_keywords/.*\\'" . portage-modes-keywords-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.env\\'" . portage-modes-env-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.license\\'" . portage-modes-license-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.mask\\'" . portage-modes-generic-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.mask/.*\\'" . portage-modes-generic-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.unmask\\'" . portage-modes-generic-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.unmask/.*\\'" . portage-modes-generic-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.use\\'" . portage-modes-use-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/package.use/.*\\'" . portage-modes-use-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/profile/package.provided\\'" . portage-modes-generic-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/profile/package.use.force/.*\\'" . portage-modes-use-mode))
  (add-to-list 'auto-mode-alist '("^/etc/portage/profile/package.use.mask/.*\\'" . portage-modes-use-mode)))

(provide 'portage-modes)

;;; portage-modes.el ends here
