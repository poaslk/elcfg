;;;;;;;;;;;
;;Common
;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(defun require-or-install (sym &optional init-func)
  (if (not (require sym nil t))
      (and (package-install sym)
           (require sym)))
  (funcall init-func))

;;color
(require-or-install
 'color-theme
 (lambda ()
   (setq color-theme-is-global t)
   (add-hook 'after-init-hook
             (lambda ()
               (color-theme-select)
               (color-theme-calm-forest)))))

(setq default-major-mode 'text-mode)
(global-font-lock-mode t)

;;y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;show pair
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;show time
(display-time-mode t)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;;support copy/paste
(setq x-select-enable-clipboard t)

;;location
(setq frame-title-format "lsp@%b")

(setq default-fill-column 80)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;;show col/line NO.
(setq column-number-mode t)
(setq line-number-mode t)

(setq c-basic-offset 4)
(setq indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-width 4)
(setq tab-stop-list ())

;;auto-complete
(require-or-install
 'auto-complete-config
 (lambda ()
   (ac-config-default)))

;;ecb
(require-or-install
 'ecb (lambda ()
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )))

(global-set-key [f12] 'ecb-activate)
(global-set-key [M-f12] 'ecb-deactivate)
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

(add-hook 'before-save-hook
          (lambda () (untabify (point-min) (point-max))
            (delete-trailing-whitespace)))

(add-hook 'python-mode-hook
          (lambda () (jedi:setup)
          (setq jedi:complete-on-dot t)))

;;;;;;;;;;;
;;Scheme
;;;;;;;;;;;
(require-or-install
 'cmuscheme
 (lambda ()
   (setq scheme-program-name "petite")

   (defun scheme-proc ()
     "Return the current Scheme process, starting one if necessary."
     (unless (and scheme-buffer
                  (get-buffer scheme-buffer)
                  (comint-check-proc scheme-buffer))
       (save-window-excursion
         (run-scheme scheme-program-name)))
     (or (scheme-get-process)
         (error "No current process. See variable `scheme-buffer`")))

   (defun scheme-split-window ()
     (cond
      ((= 1 (count-windows))
       (delete-other-windows)
       (split-window-vertically (floor (* 0.5 (window-height))))
       (other-window 1)
       (switch-to-buffer "*scheme*")
       (other-window 1))
      ((not (find "*scheme*"
                  (mapcar (lambda (w) (buffer-name (window-buffer w)))
                          (window-list))
                  :test 'equal))
       (other-window 1)
       (switch-to-buffer "*scheme*")
       (other-window -1))))

   (defun scheme-send-last-sexp-split-window ()
     (interactive)
     (scheme-split-window)
     (scheme-send-last-sexp))

   (add-hook 'scheme-mode-hook
             (lambda ()
               (paredit-mode 1)
               (define-key scheme-mode-map (kbd "C-c C-p")
                 'scheme-send-last-sexp-split-window)))))

;;;;;;;;;;;
;;C/C++
;;;;;;;;;;;

;;use c++ mode for ".h"
(add-to-list 'auto-mode-alist (cons "\\.h$" #'c++-mode))

(defun add-c-header ()
  (if (not (file-exists-p filename))
      (insert "/*\n  File: " (file-name-nondirectory filename)
              "\n  Author: Lsp\n  Time: " (current-time-string)
              "\n  Email: CD_for_ever@163.com"
              "\n  Encode: UTF8\n*/")))

(add-hook 'c-mode-common-hook 'add-c-header)
