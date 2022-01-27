;; init.el --- My init.el  -*- lexical-binding: t; coding: utf-8-unix -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-when-compile
  (defmacro add-subdirs-to-load-path (dir)
    `(let ((default-directory ,dir))
       (add-to-list 'load-path default-directory)
       (normal-top-level-add-subdirs-to-load-path))))

;; 個人作成 lisp path
(eval-and-compile
;  (add-subdirs-to-load-path (locate-user-emacs-file "./site-lisp"))
  ;; (add-subdirs-to-load-path
  ;;  (expand-file-name(concat data-directory "../../site-lisp")))
  (add-subdirs-to-load-path "d:/S023784/gccemacs/share/emacs/site-lisp")
)

(eval-and-compile
  (setq default-frame-alist
	(append (list
		 '(top . 10)
		 '(left . 10)
		 '(width . 80)
	         '(height . 26)
	         '(ime-font . "ＭＳ ゴシック-18")
	         '(font . "ＭＳ ゴシック-18")
	         )))
  (setq initial-frame-alist
	(append (list
		 '(top . 10)
		 '(left . 10)
		 '(width . 80)
		 '(height . 26)
		 '(ime-font . "ＭＳ ゴシック-18")
		 '(font . "ＭＳ ゴシック-18")
		 )))
  )
(eval-and-compile

  ;; proxy 関連の設定

  (setq my-net-uid "S023784")
  (setq my-net-passwd "**********")
  (setq my-proxy-host "strings-oswest-lb10.kddi.com")
  (setq my-proxy-port 8080)

  (setenv "http_proxy"
          (format "http://%s:%s@%s:%d/"
                  my-net-uid my-net-passwd my-proxy-host my-proxy-port))
  (setenv "https_proxy"
          (format "http://%s:%s@%s:%d/"
                  my-net-uid my-net-passwd my-proxy-host my-proxy-port))
  (setenv "no_proxy" "localhost,127.0.0.1")
  )

(eval-and-compile
  (customize-set-variable
   'url-proxy-services
   (list '("no_proxy" . "^\\(127.0.0.1\\|localhost\\|10.*\\|172.22.164.88\\|*.kddi.com\\|clarinet\\|kidsland\\|manabi.sabacloud.com\\|outlook.office365.com\\)")
	 (cons "http"   (format "%s:%d" my-proxy-host my-proxy-port))
	 (cons  "https" (format "%s:%d" my-proxy-host my-proxy-port))))

(customize-set-variable
 'request-curl-options
 '("--trace-ascii" "c:/Users/S023784/AppData/Local/Temp/curl-trace"
   "--noproxy" "127.0.0.1"))

  (customize-set-variable
   'url-http-proxy-basic-auth-storage
   `(( ,(format "%s:%d" my-proxy-host my-proxy-port)
       (,my-net-uid
        .
        ,(base64-encode-string (format "%s:%s" my-net-uid my-net-passwd))))))
  )

(eval-and-compile
  (customize-set-variable
   'package-user-dir "d:/S023784/gccemacs/share/emacs/site-lisp/elpa")

  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")
                       ))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; ここにいっぱい設定を書く(start)

(eval-and-compile
  (leaf leaf
    :config
    (leaf leaf-convert :ensure t)
    (leaf leaf-tree
      :ensure t
      :custom ((imenu-list-size . 30)
               (imenu-list-position . 'left)))))

(eval-and-compile
  (leaf macrostep
    :ensure t
    :bind (("C-c e" . macrostep-expand))))

;; ;; IME の設定 開始
(eval-and-compile
  (leaf tr-ime
    :doc "Emulator of IME patch for Windows"
    :req "emacs-27.1" "w32-ime-0.0.1"
    :tag "emacs>=27.1"
    :url "https://github.com/trueroad/tr-emacs-ime-module"
    ;; :if (eq system-type 'windows-nt)
    ;; IM のデフォルトを IME に設定
    :custom ((default-input-method . "W32-IME")
	     ;; IME のモードライン表示設定
	     (w32-ime-mode-line-state-indicator . "[--]")
	     (w32-ime-mode-line-state-indicator-list . '("[--]" "[あ]" "[--]"))
	     )
    :ensure t
    :require t
    :commands w32-ime-wrap-function-to-control-ime
              tr-ime-detect-ime-patch-p
    :bind
    ;; alt-x が半角カナになるため
    (
     ("ｺ" . backward-word)              ; alt-b
     ("ｼ" . kill-word)                  ; alt-d
     ("ﾊ" . forward-word)               ; alt-f
     ("ﾀ" . fill-paragraph)             ; alt-q
     ("ﾃ" . kill-ring-save)             ; alt-w
     ("ｻ" . execute-extended-command)   ; alt-x
     ("ﾝ" . yank-pop)                   ; alt-y
     ("､" . beginning-of-buffer)        ; alt-shift-<
     ("｡" . end-of-buffer)              ; alt-shift->
     )
    :config
    ;; ;; tr-imeのDLLを自動でダウンロードしてくれる 
    (tr-ime-advanced-install)
    ;; IME 初期化
    (w32-ime-initialize)
    ;; IME 制御（yes/no などの入力の時に IME を off にする）
    (w32-ime-wrap-function-to-control-ime 'universal-argument t nil)
    (w32-ime-wrap-function-to-control-ime 'read-string nil nil)
    (w32-ime-wrap-function-to-control-ime 'read-char nil nil)
    (w32-ime-wrap-function-to-control-ime 'read-from-minibuffer nil nil)
    (w32-ime-wrap-function-to-control-ime 'y-or-n-p nil nil)
    (w32-ime-wrap-function-to-control-ime 'yes-or-no-p nil nil)
    (w32-ime-wrap-function-to-control-ime 'map-y-or-n-p nil nil)
    (modify-all-frames-parameters '('(ime-font . "Meiryo UI-20")))
    ))

(eval-and-compile
;; IME の未確定文字列のフォント設定
(set-frame-font "Meiryo UI-18" nil t))

(eval-and-compile
  (leaf url-http
    :defvar 
    url-http-after-change-function
    url-basic-auth-storage
    url-http-proxy url-https-default-port
    :preface
    (defun url-https-proxy-connect (connection)
      (setq url-http-after-change-function 'url-https-proxy-after-change-function)
      (process-send-string
       connection
       (format
        (concat "CONNECT %s:%d HTTP/1.1\r\n"
	        "Host: %s\r\n"
	        (let ((proxy-auth
		       (let ()
                         (setq url-basic-auth-storage
			       'url-http-proxy-basic-auth-storage)
		         (url-get-authentication url-http-proxy nil 'any nil))))
                  (if proxy-auth (concat "Proxy-Authorization: " proxy-auth "\r\n")))
	        "\r\n")
        (url-host url-current-object)
        (or (url-port url-current-object)
            url-https-default-port)
        (url-host url-current-object))))
    :after t))

(eval-and-compile
  (leaf *my:env01
    :config
    (setq py-ver (getenv "PY_VER"))
    (if (eq (setq my-sys (getenv "MY_SYS")) nil)
        (setq my-sys "cygwin")
      ;;(setq my-sys "mingw32")
      ;;(setq my-sys "mingw64")
      )

    (setq my-title-sys my-sys)
    (setq my-emacs-debug (if (getenv "MY_EMACS_DEBUG") t nil))
    (if my-emacs-debug
        (setq my-title-sys (concat my-title-sys " debug")))

    (setenv "EMACS_VERSION" emacs-version)

    ;; (setq frame-title-format              ; C source code
    ;;       `(multiple-frames "%b" ("" ,(format "%%b - GNU Emacs %d at "emacs-major-version) my-sys)))
    (setq frame-title-format              ; C source code
          `(multiple-frames "%b" ("" ,(format "%%b - GNU Emacs %s at " emacs-version) my-title-sys)))

    (cond
     ((string= my-sys "cygwin")
      (setq my-path
	    '("D:/S023784/home/.rbenv/bin"
	      "D:/S023784/home/bin"
	      "D:/cygwin/usr/local/bin"
	      "D:/cygwin/bin"
	      "D:/S023784/gccemacs/bin"
	      )))
     ((string= my-sys "mingw32")
      (setq my-path 
	    '("D:/S023784/gccemacs/bin"
	      "d:/msys32/usr/local/bin"
	      "D:/msys32/mingw32/bin"
	      "d:/msys32/usr/bin"
	      "d:/msys32/usr/bin/site_perl"
	      "d:/msys32/usr/bin/vendor_perl"
	      "d:/msys32/usr/bin/core_perl"
	      )))
     ((string= my-sys "mingw64")
      (setq my-path
	    `(
              ;; "D:/S023784/gccemacs/home/py-win/Scripts"
              "d:/S023784/gccemacs/home/py-3_9/Scripts"
              ,(cond ((string= py-ver "3.6")
                      "d:/msys32/mingw64/opt/python/3.6")
                     ((string= py-ver "3.9")
                      "d:/msys32/mingw64/opt/python/3.9")
                     ((string= py-ver "3.10")
                      "d:/msys32/mingw64/opt/python/3.10"))
	      "d:/msys32/mingw64/opt/texinfo/6.8/bin"
	      "d:/msys32/mingw64/local/bin"
	      "d:/msys32/mingw64/bin"
	      "d:/S023784/home/.cargo/bin"
	      "d:/msys32/usr/local/bin"
	      "d:/msys32/usr/bin"
	      "d:/msys32/usr/bin/site_perl"
	      "d:/msys32/usr/bin/vendor_perl"
	      "d:/msys32/usr/bin/core_perl"
              ,(cond ((string= emacs-version "28.0.90")
	              "d:/S023784/emacs-28.0.90/bin")
                     ((string= emacs-version "29.0.50")
                      "d;/S023784/emacs-29/bin"))
              "d:/S023784/gccemacs/bin"
              "d:/nodejs"
	      ))))

    (setq exec-path (append my-path exec-path)) ; C source code
    (setenv "PATH" (string-replace "/" "\\" (mapconcat 'identity exec-path ";")))

    (setenv "LANG" "C")
    (setenv "RUBY_BUILD_HTTP_CLIENT" "wget")
    (setenv "PAGER" "cat")
    (setenv "CARGO_HOME" "D:\\S023784\\home\\.cargo")
    (setenv "CARGO_INSTALL_ROOT" "d:\\msys32\\mingw64\\local")
    (setenv "RUSTUP_HOME" "D:\\S023784\\home\\.rustup")

    ;; ;;; shell の設定

    ;; ;;; Cygwin の bash を使う場合
    (setenv "SHELL" "/bin/sh")
    (setq explicit-shell-file-name "bash") ; shell
    (setq shell-file-name "sh")            ; C source code
    (setq shell-command-switch "-c")       ; simple
    ;; ;; ;; fakecygpty
    ;; (if (string= my-sys "cygwin")
    ;;   (progn
    (require 'fakecygpty)
    (fakecygpty-activate)
    ;; ;    (setq explicit-shell-file-name "f_bash") ; shell
    ;;     ))

    ;; ;;; coding-system の設定
    ;; (modify-coding-system-alist 'process ".*sh\\.exe" 'undecided-dos)
    (modify-coding-system-alist 'process ".*sh\\.exe" '(sjis-dos . undecided-unix))
    (modify-coding-system-alist 'process ".*sh" '(sjis-dos . undecided-unix))
    ))

(eval-and-compile
  ;; (declare-function doc-view-pdf->png-converter-ghostscript "doc-view")
  (leaf doc-view
    :ensure t
    :commands doc-view-pdf->png-converter-ghostscript
    :custom
    ((doc-view-ghostscript-program . "/mingw64/bin/gs")
    (doc-view-pdf->png-converter-function . #'doc-view-pdf->png-converter-ghostscript)
    (doc-view-dvipdf-program . "/mingw64/bin/dvipdf")
    (doc-view-ps2pdf-program . "/mingw64/bin/ps2pdf")
    (doc-view-pdftotext-program . "/d/s023784/gccemacs/bin/pdftotext")
    )))
;;;===================================
;;; とりあえず init_tmp.el の残りの部分を貼り付けた
(eval-and-compile
  (leaf *my:env02
    :config
    (add-to-list
     'file-coding-system-alist              ; C source code
     '("\\.txt\\'" . japanese-cp932))
    (add-to-list
     'file-coding-system-alist              ; C source code
     '("\\.py\\'" . utf-8-unix))
    (add-to-list
     'file-coding-system-alist              ; C source code
     '("\\.rs\\'" . utf-8-unix))
    (add-to-list
     'file-coding-system-alist              ; C source code
     '("\\.ipynb\\'" . utf-8-unix))
    ))
;; (setq bitmap-alterable-charset 'tibetan-1-column)
;; tibetan-1-column

(eval-and-compile
  ;; emacsclentw
  (leaf server
    :doc "Lisp code for GNU Emacs running as server process"
    :tag "builtin"
    :require t
    :config
    (server-force-delete)
    (server-start)))


;;; マウスカーソルを消す設定
;;; たぶん obsolete
;; (eval-and-compile
;; (leaf w32-vars
;;   :doc "MS-Windows specific user options"
;;   :tag "builtin" "internal"
;;   ;; :defvar w32-hide-mouse-on-key w32-hide-mouse-timeout
;;   :setq ((w32-hide-mouse-on-key . t)
;;          (w32-hide-mouse-timeout . 5000)))
;; )

(eval-and-compile                                        ;###
  (leaf *my:env03
    :config
    (defun eww-mode-hook--disable-image ()
      (setq-local shr-put-image-function 'shr-put-image-alt))
    (add-hook 'eww-mode-hook 'eww-mode-hook--disable-image)
    ;; (load "mylisp-eww-image")
    (require 'mylisp-eww-image)

    ;; find-file のファイル名補完で SPC が利用出来るようにする。
    (define-key minibuffer-local-filename-completion-map " "
      'minibuffer-complete-word)

    (define-key lisp-interaction-mode-map "\C-c\C-c" 'comment-region)
    (define-key emacs-lisp-mode-map "\C-c\C-c" 'comment-region)

    ))

(eval-and-compile
  (leaf cperl-mode
    :doc "Perl code editing commands for Emacs"
    :tag "builtin"

    :bind (:cperl-mode-map
           ("\C-C\C-C" . comment-region)))

  ;; (leaf rust-mode
  ;;   :doc "A major-mode for editing Rust source code"
  ;;   :req "emacs-25.1"
  ;;   :tag "languages" "emacs>=25.1"
  ;;   :url "https://github.com/rust-lang/rust-mode"
  ;;   :added "2021-09-27"
  ;;   :emacs>= 25.1
  ;;   :ensure t
  ;;   :bind (:rust-mode-map
  ;;          ("\C-C\C-C" . comment-region))
  ;;   :custom ((rust-format-on-save . t)) 
  ;;   :config
  ;;   (add-to-list
  ;;    'file-coding-system-alist              ; C source code
  ;;    '("\\.rs\\'" . utf-8-unix)))

  (defun switch-to-other-buffer ()
    (interactive)
    (switch-to-buffer (other-buffer)))
  (global-set-key '[home] 'switch-to-other-buffer)

  (tool-bar-mode 0)

  )

;;;
;;; web で見付けた font の設定
;;;
;;; (defvar user/standard-fontset
;;;   (create-fontset-from-fontset-spec standard-fontset-spec)
;;;   "Standard fontset for user.")
;;; (defvar user/font-size 18
;;;   "Default font size in px.")
;;; (defvar user/cjk-font "ＭＳ ゴシック" ;; ← ★日本語フォントの設定
;;;   "Default font for CJK characters.")
;;;
;;; ;; 日本語とアルファベットフォントのサイズバランスが悪い場合はここで調整する
;;; ;; 参考： https://qiita.com/kaz-yos/items/0f23d53256c2a3bd6b8d
;;; (defvar user/cjk-font-scale
;;;   '((14 . 1.0)
;;;     (15 . 1.0)
;;;     (16 . 1.1)
;;;     (17 . 1.1)
;;;     (18 . 1.0))
;;;   "Scaling factor to use for cjk font of given size.")
;;;
;;; ;; Specify scaling factor for CJK font.
;;; (setq face-font-rescale-alist
;;;       (list (cons user/cjk-font
;;;                   (cdr (assoc user/font-size user/cjk-font-scale)))))
;;;
;;; (defvar user/latin-font "Consolas" ;; ← ★アスキーフォントの設定
;;;   "Default font for Latin characters.")
;;; (defvar user/unicode-font "Segoe UI Emoji" ;; ← ★絵文字フォントの設定
;;;   "Default font for Unicode characters, including emojis.")
;;; (defun user/set-font ()
;;;   "Set Unicode, Latin and CJK font for user/standard-fontset."
;;;   ;; Unicode font.
;;;   (set-fontset-font user/standard-fontset 'unicode
;;;                     (font-spec :family user/unicode-font) nil 'prepend)
;;;
;;; ;; Specify scaling factor for Unicode font.
;;; (defvar user/unicode-font-scale
;;;   '((14 . 1.0)
;;;     (15 . 1.0)
;;;     (16 . 1.0)
;;;     (17 . 1.0)
;;;     (18 . 1.0))
;;;   "Scaling factor to use for Unicode font of given size.")
;;;
;;; (add-to-list 'face-font-rescale-alist (cons 'user/font-size user/unicode-font-scale))
;;;
;;; ;; Latin font.
;;; ;; Only specify size here to allow text-scale-adjust work on other fonts.
;;;   (set-fontset-font user/standard-fontset 'latin
;;;                     (font-spec :family user/latin-font :size user/font-size) nil 'prepend)
;;;   ;; CJK font.
;;;   (dolist (charset '(kana han cjk-misc hangul kanbun bopomofo))
;;;     (set-fontset-font user/standard-fontset charset
;;;                       (font-spec :family user/cjk-font) nil 'prepend))
;;;   ;; Special settings for certain CJK puncuation marks.
;;;   ;; These are full-width characters but by default uses half-width glyphs.
;;;   (dolist (charset '((#x2018 . #x2019)    ;; Curly single quotes "‘’"
;;;                      (#x201c . #x201d)))  ;; Curly double quotes "“”"
;;;     (set-fontset-font user/standard-fontset charset
;;;                       (font-spec :family user/cjk-font) nil 'prepend)))
;;; ;; Apply changes.
;;; (user/set-font)
;;; ;; Ensure user/standard-fontset gets used for new frames.
;;; (add-to-list 'default-frame-alist (cons 'font user/standard-fontset))
;;; (add-to-list 'initial-frame-alist (cons 'font user/standard-fontset))
;;;
;;; ;; IMEの変換のときのフォント
;;; (modify-all-frames-parameters '((ime-font . "ＭＳ ゴシック-12"))) ;; ← ★日本語変換のときのフォント設定
;;;

(eval-and-compile
  (leaf *my:env04
    :config
    (define-key lisp-interaction-mode-map "\C-c\C-c" 'comment-region)
    (define-key emacs-lisp-mode-map "\C-c\C-c" 'comment-region)

    (defun man-set-fonts ()
      (interactive)
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "\\(.\b+\\)+" nil t)
          (or (eobp) (forward-char))
          (let ((st (match-beginning 0)) (en (point)) (bs 0))
	    (if (not (eq (char-after st) ?_))
	        nil
	      (forward-char -1)
	      (while (eq (preceding-char) ?\b)
	        (forward-char -1)
	        (setq bs (1+ bs)))
	      (while (and (eq (char-after (1- st)) ?_)
		          (< 1 bs))
	        (delete-char -1)
	        (setq bs (1- bs) st (1- st) en (1- en))))
	    (goto-char st)
	    (if (fboundp 'make-face)
	        (put-text-property st en 'face
			           (if (looking-at "_") 'underline 'bold)))
	    (while (and (< (point) en) (looking-at ".\b+"))
	      (replace-match ""))))))
    )) ; eval-and-compile

(eval-and-compile

  (leaf sh-mode
    :bind (:sh-mode-map
	   ("\C-c\C-c" . comment-region)
	   ("\C-cc" . sh-case)))

  (leaf bat-mode
    :doc "Major mode for editing DOS/Windows scripts"
    :tag "builtin"
    :bind (:bat-mode-map
	   ("\C-c\C-c" . comment-region))
    :config
    (setq auto-mode-alist
          (append
           (list
            (cons "\\.[bB][aA][tT]$" 'bat-mode))
           (list
            (cons "CONFIG\\." 'bat-mode))
           (list
            (cons "AUTOEXEC\\." 'bat-mode))
           auto-mode-alist)))
  ) ; eval-and-compile


(eval-and-compile
  (leaf *my:env05
    :config
    (defun browse-url-w3m-at-point (&optional arg)
      (interactive "P")
      (let ((url (browse-url-url-at-point)))
        (setq browse-url-browser-function 'w3m-browse-url)
        (if url
	    (browse-url url (if arg
			        (not browse-url-new-window-flag)
			      browse-url-new-window-flag))
          (error "No URL found"))))
    (global-set-key "\C-xm" 'browse-url-w3m-at-point)

    (defun browse-url-default-at-point (&optional arg)
      (interactive "P")
      (let ((url (browse-url-url-at-point)))
        (setq browse-url-browser-function 'browse-url-default-browser)
        (if url
	    (browse-url url (if arg
			        (not browse-url-new-window-flag)
			      browse-url-new-window-flag))
          (error "No URL found"))))
    (global-set-key "\C-xM" 'browse-url-default-at-point)

    (setq Info-default-directory-list
          '( "d:/S023784/gccemacs/share/info"
	     "d:/cygwin/usr/local/info"
	     "d:/cygwin/usr/share/info"))

    )) ; (eval-and-compile


(eval-and-compile
  (leaf *my:env06
    :config
    (defun my-kill-current-buffer () (interactive)(kill-buffer (current-buffer)))
    (global-set-key '[f12] 'my-kill-current-buffer)
    (global-set-key '[f8] 'goto-line)
    (global-set-key "\C-m"'newline-and-indent)
    ;;(global-set-key "\C-m" 'reindent-then-newline-and-indent)
    (global-set-key "\C-j" 'newline)

    (setq grep-find-use-xargs nil)
    )) ; (eval-and-compile

(eval-and-compile
  (leaf text-mode
    :doc "text mode, and its idiosyncratic commands"
    :tag "builtin" "wp"
    :custom ((fill-column . 64)
             (indent-tabs-mode . nil)
             ;; (auto-fill-mode . t)
             )
    :bind (:text-mode-map
           ("\C-Xc" . center-line))
    :config
    (add-hook 'text-mode-hook #'(lambda nil (auto-fill-mode t)))
    )
  )  ;(eval-and-compile

;;;
;;; Lookup Setup
;;;

;; (if (not (string= emacs-version "28.0.90"))
(eval-and-compile
  (leaf lookup
    :doc "Search interface to electronic dictionaries"
    :commands lookup-setup lookup lookup-region lookup-pattern
    lookup-word my-lookup-describe-word
    ;; :require t
    :preface
    (defvar my-lookup-english-prep-list '("at" "by" "for" "in" "on" "of" "with" "as" "before" "after") "\
List of English prepositions
英語の前置詞のリスト")
    (defvar my-lookup-english-prep-regexp
      (format "\\(%s\\)\\b"
	      (mapconcat 'regexp-quote my-lookup-english-prep-list "\\|"))
      "Regexp of Englist prepositions
英語の前置詞とマッチする正規表現")
    (defvar my-lookup-read-minibuffer-history '() "\
my-lookup-read-from-minibuffer 関数のヒストリ")
    (defun my-lookup-word-at-point ()
      "カーソル位置の単語を返す関数"
      (save-excursion
        (if (not (looking-at "\\<")) (forward-word -1))
        (if (looking-at my-lookup-english-prep-regexp)
	    (let ((strs
	           (my-lookup-split-string
		    (my-lookup-buffer-substring-no-properties
		     (progn (forward-word -1) (point))
		     (progn (forward-word 2) (point))))))
	      (if (string-match "\\cj" (car strs))
	          (car (cdr strs))
	        (concat (car strs) " " (car (cdr strs)))))
          (my-lookup-buffer-substring-no-properties
           (point) (progn (forward-word 1) (point))))))
    (defun my-lookup-read-from-minibuffer (&optional init pre-prompt)
      "ミニバッファから単語を読みとる"
      (let ((w (or init (my-lookup-word-at-point) "")))
        (setq my-lookup-read-minibuffer-history
	      (cons w my-lookup-read-minibuffer-history)
	      w (read-from-minibuffer
	         (if pre-prompt
		     (format "%s Input word : " pre-prompt)
	           "Input word : ")
	         w nil nil '(my-lookup-read-minibuffer-history . 1)))
        (if (>= (length w) 2) w
          (read-from-minibuffer
           (format "\"%s\" is too short. Input word again : " w)
           w nil nil '(my-lookup-read-minibuffer-history . 1)))))

    (defun my-lookup-split-string (string &optional separators) "\
Splits STRING into substrings where there are matches for SEPARATORS.
Each match for SEPARATORS is a splitting point.
The substrings between the splitting points are made into a list
which is returned.
If SEPARATORS is absent, it defaults to \"[ \\f\\t\\n\\r\\v]+\".

If there is match for SEPARATORS at the beginning of STRING, we do not
include a null substring for that.  Likewise, if there is a match
at the end of STRING, we don't include a null substring for that."
           (or separators (setq separators "[ \f\t\n\r\v]+"))
           (let (list (start 0))
             (while (string-match separators string start)
               (or (= start (match-beginning 0))
	           (setq list (cons (substring string start (match-beginning 0)) list)))
               (setq start (match-end 0)))
             (nreverse (if (= start (length string)) list (cons (substring string start) list)))))

    (if (fboundp 'buffer-substring-no-properties)
        (defalias 'my-lookup-buffer-substring-no-properties 'buffer-substring-no-properties)
      (defun my-lookup-buffer-substring-no-properties (start end) "\
Return the characters of part of the buffer, without the text properties.
The two arguments START and END are character positions;
they can be in either order. [Emacs 19.29 emulating function]"
             (let ((string (buffer-substring start end)))
               (set-text-properties 0 (length string) nil string)
               string)))

    ;; 単語を辞書で調べる関数
    (defun my-lookup-describe-word (word)
      "Display the meaning of word."
      (interactive
       (let ((w (my-lookup-read-from-minibuffer)))
         (list w)))
      (lookup-word word))
    :bind (("\C-c\C-y" . lookup-pattern)
           ("\C-cw"    . my-lookup-describe-word)
           (:ctl-x-map
            ("l"    . lookup)             ; C-x l - lookup
            ("y"    . lookup-region)      ; C-x y - lookup-region
            ("\C-y" . lookup-pattern)))   ; c-x C-y - lookup-pattern
    :custom
    ((lookup-enable-splash . nil)
     (lookup-default-dictionary-options
      .
      '((:stemmer .  stem-english)))
     (lookup-process-coding-system . 'euc-jp)
     ;; ;; 検索エージェントの設定
     (ndeb-program-name . "x86_64-w64-mingw32-eblook")
     (lookup-search-agents
      .

      '(
	;; スーパー統合辞書 (EPWING)
	(ndeb "dict/sidict"
	      :select ("chujiten"	; 研究社 新英和・和英中辞典
		       )
	      :unselect ("koujien"	; 広辞苑 第四版
			 "kanjigen"	; 漢字源
			 "gn97ep"	; 現代用語の基礎知識 1997 年版
			 ))
	;; フリー辞書からの直接検索
	(ndic "~/dict" :enable ("gene" "jedict"))
	;; Longman Dictionary of Contemporary English 4 (EPWING)
	(ndeb "dict/ldoce"
	      :select ("ldoce4"		; Longman 4th Edition
		       )
	      :unselect ("bank"		; LDOCE4 Examples and Phrases
			 "colloc"	; LDOCE4 Collocation
			 "activ"	; Longman Activator
			 ))
	))
     (lookup-use-kakasi . nil)
     (lookup-inline-image . t)
     ))

;;; @@ obsolete process-kill-without-query
  (make-obsolete
   'process-kill-without-query
   "use `process-query-on-exit-flag' or `set-process-query-on-exit-flag'."
   "22.1")
  (defun process-kill-without-query (process &optional _flag)
    "Say no query needed if PROCESS is running when Emacs is exited.
Optional second argument if non-nil says to require a query.
Value is t if a query was formerly required."
    (let ((old (process-query-on-exit-flag process)))
      (set-process-query-on-exit-flag process nil)
      old))

  ;; (with-eval-after-load ':lookup
    (lookup-setup)
    ;; )

  ); eval-and-compile
;; )  ; (if (not (string= emacs-version "28.0.90"))

;; (eval-and-compile
;; (load "my-calendar-setup"))
(eval-and-compile
  (leaf *my:env07
    :config
    (require 'my-calendar-setup)))

(eval-and-compile
  (leaf migemo
    :ensure t
    :require t
    :custom
    ((migemo-user-dictionary  . nil)
      (migemo-regex-dictionary . nil)
      (migemo-isearch-enable-p . nil)
      (migemo-options          . '("--quiet" "--nonewline" "--emacs"))
      ;; (migemo-options          . '("-q" "--emacs" "-i" "\a"))
      (migemo-command          . "cmigemo")
      ;; ;; ruby migemo
      ;;  (migemo-options          . '("-S" "migemo" "-t" "emacs" "-i" "\a"))
      ;;  (migemo-command          . "ruby")
      (migemo-coding-system    . 'utf-8-unix)
      (migemo-dictionary       . "d:/S023784/gccemacs/share/migemo/utf-8/migemo-dict"))
    :config
    (migemo-init)
    ))

(eval-and-compile
  (leaf *my:env08
    :config
    (if (string= my-sys "cygwin")
        (setq my-fortune-program "fortune")
      (setq my-fortune-program "fortune"))
    ;; (setq my-fortune-program "d:/cygwin/bin/fortune.exe")
    (setq my-fortune-file "HangulStandard40")
    (modify-coding-system-alist 'process " *fortune*" '(utf-8 . utf-8))

    (require 'timezone)
    (defun my-fortune ()
      (interactive)
      (let ((my-fortune-buffer (get-buffer-create " *fortune*"))
	    (list (decode-time))
	    day month year yday
	    (p1 "-m") p2 i)
        (setq select-enable-clipboard nil)
        (setq day   (nth 3 list))
        (setq month (nth 4 list))
        (setq year  (nth 5 list))
        (setq yday (1- (timezone-day-number month day year)))
        (setq i (mod yday 39))
        (setq i (1+ i))
        (setq p2 (format "^%2.2d" i))
        (set-buffer my-fortune-buffer)
        (save-excursion
          (erase-buffer)
          (message
           (format "%s %s %s %s %s "
	           my-fortune-program
	           my-fortune-buffer
	           p1 p2 my-fortune-file))
          (call-process my-fortune-program nil
		        `(,(format "%s" my-fortune-buffer) nil)
		        nil p1 p2 my-fortune-file)
          (goto-char (point-min))
                                        ;      (kill-line 2)
          (insert "\n")
          (goto-char (point-min))
          (while (re-search-forward "^" nil t)
	    (replace-match ";; " nil nil))
          (insert "\n")
          (goto-char (point-min))
          (while (search-forward ";; %\n" nil t)
	    (replace-match "" nil t)))
        (setq initial-scratch-message (buffer-string))
        (setq select-enable-clipboard t)))

    ))

(eval-and-compile
  (leaf *my:env09
    :config
    (global-set-key "\C-xj" 'auto-fill-mode)

    (defun my-make-scratch (&optional arg)
      (interactive)
      (progn
        ;; "*scratch*" を作成して buffer-list に放り込む
        (my-fortune)
        (set-buffer (get-buffer-create "*scratch*"))
        (funcall initial-major-mode)
        (erase-buffer)
        (insert initial-scratch-message)
        (or arg (progn (setq arg 0)
                       (switch-to-buffer "*scratch*")))
        (cond ((= arg 0) (message "*scratch* is cleared up."))
              ((= arg 1) (message "another *scratch* is created")))))

    (defun my-buffer-name-list ()
      (mapcar (function buffer-name) (buffer-list)))

    (add-hook 'kill-buffer-query-functions
	      ;; *scratch* バッファで kill-buffer したら内容を消去するだけ
	      ;; にする
              (function (lambda ()
                          (if (string= "*scratch*" (buffer-name))
                              (progn (my-make-scratch 0) nil)
                            t))))

    (add-hook 'after-save-hook
	      ;; *scratch* バッファの内容を保存したら *scratch* バッファを
	      ;; 新しく作る
              (function (lambda ()
                          (unless (member "*scratch*" (my-buffer-name-list))
                            (my-make-scratch 1)))))
    )) ; (eval-and-compile

(eval-and-compile
  (leaf browse-kill-ring
    :doc "interactively insert items from kill-ring"
    :tag "convenience"
    :url "https://github.com/browse-kill-ring/browse-kill-ring"
    :ensure t
    :require t
    :bind (("\C-ck" . browse-kill-ring))
    :custom
    ((browse-kill-ring-separator
      .
      ;; "────────────────────────────────"
      ;; "----------------------------------------------------------------"
      "|----+----|----+----|----+----|----+----|----+----|----+----|---"
      )
     (browse-kill-ring-display-duplicates . nil))
    ;; :custom-face
    ;; '((browse-kill-ring-separator-face . "blue")
    ;;   (browse-kill-ring-separator-face . 'browse-kill-ring-separator-face))
    :config (browse-kill-ring-default-keybindings)
    ;; (defadvice yank-pop (around kill-ring-browse-maybe (arg))
    ;;   "If last action was not a yank, run `browse-kill-ring' instead."
    ;;   (if (not (eq last-command 'yank))
    ;;       (browse-kill-ring)
    ;;     ad-do-it))
    ;; (ad-activate 'yank-pop)

    ))

(eval-and-compile
  (leaf visual-basic-mode
    :doc "A mode for editing Visual Basic programs."
    :tag "builtin" "evil" "basic" "languages"
    :url "http://www.emacswiki.org/cgi-bin/wiki/visual-basic-mode.el"
    :commands visual-basic-mode
    :bind (:visual-basic-mode-map
           ("\C-c\C-c" . comment-region))
    :custom ('(auto-mode-alist
               . ,(append
                   '(("\\.\\(frm\\|bas\\|cls\\|vbs\\)$" . visual-basic-mode))
                   auto-mode-alist))
             (visual-basic-mode-indent . 2)
             (comment-column . 18)
             (indent-tabs-mode . nil))))
(eval-and-compile
  (leaf ttl-mode
    :doc "mode for Turtle (and Notation 3)"
    :added "2021-09-10"
    :ensure t
    :bind (:ttl-mode-map
           ("\C-c\C-c" . comment-region))
    :commands ttl-mode
    :custom ('(auto-mode-alist
               . ,(append
                   '(("\\.ttl$" .
                      ttl-mode)) auto-mode-alist))
	     (ttl-mode-indent . 2)
	     (comment-column . 18)
	     (indent-tabs-mode . nil))))

(eval-and-compile
  (leaf *my:env10
    :config
    (defun my-today ()
      (interactive)
      (let ((day (format-time-string "%Y/%m/%d"))
	    (week (nth (nth 6 (decode-time))
		       '("日" "月" "火" "水" "木" "金" "土"))))
        (format "%s (%s)" day week)))

    ;; (defun my-insert-time()
    ;;   (interactive)
    ;;   (insert (format-time-string "%H:%M")))
    (defun my-insert-time()
      (interactive)
      (let ((time-string (format-time-string "%H:%M")))
        (kill-new time-string)
        (insert time-string)))

    (defvar my-insert-today-bullet "○")
    ;; (setq my-insert-today-template "%s %s

    ;;    ☆ 実績/予定

    ;;       au電番残数調査                         
    ;;       本日の作業一覧抽出                     
    ;;       【LDAP Manager】ユーザIDデータ取得     
    ;;       入門証管理 アラート検知メール通知報告  
    ;;       【サイボウズ】アカウント登録           
    ;;       SURF2日次卸し                          
    ;;       SURF2ロール追加削除                    
    ;;       朝礼                                   
    ;;       MIN管理表送付                          
    ;;       パスワード変更 KICSS root              
    ;;       パスワード変更 Naile(F転送) root       
    ;;       パスワード変更 KICSS DB                
    ;;       パスワード変更 SOD sodsys              
    ;;       回線借用の有無確認                     
    ;;       宛先メンテナンス                       
    ;;       ASKリカバリ対象一覧メンテ              
    ;;       BSMダウンタイム登録                    
    ;;       統合インフラ監視MSG無視 作業対象確認   
    ;;       【FACE(CICD)】ID払出し対応             
    ;;       iidabashi01アカウント運用              
    ;;       SURF2商用データ持出申請                
    ;;       SURF2ロール追加削除                    
    ;;       OA系・管理系 月間スケジュール確認      
    ;;       入退室管理簿作成                       
    ;;       入退室管理簿作成                       


    ;; ")
    (defvar my-insert-today-template "%s 駅前勤務開始します。(9:00～)
%s 駅前勤務終了します。

%s %s

   ☆ 実績/予定
      記録                                   
      メール                                 


")

    (defun insert-today (&optional no-itemize)
      (interactive "P")
      (let ((day (my-today))
            (mmdd (format-time-string "%m/%d"))
            (p (point)))
        (insert
         (if no-itemize
	     day
           ;;        (setq day (format "%s %s\n\n   ☆ 実績\n\n   ☆ 予定\n\n"
           ;;        (setq day (format "%s %s\n\n   ☆ 実績/予定\n\n"
           (setq day (format my-insert-today-template mmdd mmdd my-insert-today-bullet day))))
        (goto-char p)
        ;;    (forward-line 4)
        ;;    (end-of-line)
        day))


    (defun draft-cluc-time ()
      (interactive)
      (save-excursion
        (let (p s st-h st-m ed-h ed-m st-min ed-min min)
          (forward-line 0)
          (setq p (search-forward-regexp "[012][0-9]:[0-5][0-9]-[012][0-9]:[0-5][0-9]"))
          (setq s (buffer-substring (- p 11) p))
          (setq st-h (string-to-number (substring s 0 2)))
          (setq st-m (string-to-number (substring s 3 5)))
          (setq ed-h (string-to-number (substring s 6 8)))
          (setq ed-m (string-to-number (substring s 9 11)))
          ;;   (message (format "%d %d %d %d" st-h st-m ed-h ed-m))
          (setq st-min (+ (* st-h 60) st-m))
          (setq ed-min (+ (* ed-h 60) ed-m))
          (setq min (- ed-min st-min))
          ;;       (message "%d" min)
          (end-of-line)
          (insert (format " %d" min)))))

    ;;(global-set-key "\C-xt" 'my-insert-time)
    ;;(global-set-key "\C-xT" 'draft-cluc-time)

    (defvar my:ctl-x-w-map (make-sparse-keymap)
      "Keymap for subcommands of C-x w.")
    (defalias 'my:ctl-x-w-prefix my:ctl-x-w-map)
    (define-key ctl-x-map "w" 'my:ctl-x-w-prefix)
    (define-key my:ctl-x-w-map "t" 'my-insert-time)
    (define-key my:ctl-x-w-map "T" 'draft-cluc-time)

    )) ; (eval-and-compile

(eval-and-compile
  (leaf *my:env11
    :config
    (defun my-suikyo ()
      (interactive)
      (let ((my-suikyo-buffer (get-buffer-create " *suikyo*"))
	    (my-suikyo-file "~/suikyo.txt"))
        (progn
          (set-buffer my-suikyo-buffer)
          (save-excursion
            (erase-buffer)
            (insert-file-contents my-suikyo-file)
            (goto-char (point-min)))
          (switch-to-buffer my-suikyo-buffer))))))

(eval-and-compile
  (leaf abbrev
    :doc "abbrev mode commands for Emacs"
    :tag "builtin" "convenience" "abbrev"
    :custom
    (
     ;; 保存先を指定する
     (abbrev-file-name . "~/.abbrev_defs")
     ;; 略称を保存する
     (save-abbrevs . t))
    :config
    ;; 略称展開のキーバインドを指定する
    ;; (define-key esc-map  " " 'expand-abbrev) ;; M-SPC
    ;; 起動時に保存した略称を読み込む
    (quietly-read-abbrev-file)))

;; ;;; Suikyo (ローマ字ひらがな変換ライブラリ)
;; (require 'init-suikyo)
;; ;; ;;; PRIME for Emacs
;; (require 'init-prime)
;; (load "prime")


(eval-and-compile
  (leaf *my:env12
    :config
    ;; (defvar draft-dir "//FSVAQUA02/private/S023784/課題一覧/日報/")
    (defvar draft-dir "C:/Users/S023784/OneDrive - KDDI株式会社/daily/")
    (defvar draft-start-day 1)
    ;; (decode-time)
    ;;                                  1    2   3     4    5   6
    ;; Decode a time value as (SEC MINUTE HOUR DAY MONTH YEAR DOW DST ZONE).
    ;; (find-file "//Fsvcyan02/private/S023784/課題一覧/日報0901/drft090209.txt")
    ;; day-of-week  0  1  2  3  4  5  6
    ;;             日 月 火 水 木 金 土
    (defun draft-file-string (&optional day-of-week prev-week specified-time)
      (interactive)
      (let  ((draft-dir draft-dir)
	     (draft-file-format "drft%2.2d%2.2d%2.2d.txt")
	     list day month year dow
	     s
                                        ;	 file
             )
        (if (not day-of-week)
	    (setq day-of-week draft-start-day))
        (if (not specified-time)
	    (setq list (decode-time))
          (setq list (decode-time specified-time)))
        (setq day   (nth 3 list))
        (setq month (nth 4 list))
        (setq year  (nth 5 list))
        (setq dow   (nth 6 list))
        (setq day (+ (- day dow) day-of-week))
        (setq year (- year 2000))
        (if prev-week (setq day (- day 7)))
        (if (< day 1)
	    (progn
	      (setq day
		    (+ (nth month '(nil 31 31 28 31 30 31 30 31 31 30 31
				        30)) day))
	      (setq month (1- month))))
        (setq s draft-dir)
        (setq s (concat s draft-file-format))
                                        ;    (setq file
        (format s year month day);)
        ))
    (defun draft-open-file (&optional day-of-week prev-week specified-time)
      (interactive)
      (let  (list dow file)
        (if (not day-of-week)
	    (setq day-of-week draft-start-day))
        (if (not specified-time)
	    (setq list (decode-time))
          (setq list (decode-time specified-time)))
        (setq dow   (nth 6 list))
        (if (or prev-week
	        (eq day-of-week dow))
	    (let ()
	      (setq file (draft-file-string day-of-week t specified-time))
	      (find-file file)))
        (setq file (draft-file-string day-of-week nil specified-time))
        (find-file file)
        ))
    (draft-open-file)
                                        ;(call-process "NET" nil " *NET USE*" nil "USE" "P:" "S023784")

    (defun pr-me-ban-user-list ()
      (interactive)
      (let ((l (decode-time))
	    year month day hour minute sec n)
        (setq year   (nth 5 l))
        (setq month  (nth 4 l))
        (setq day    (nth 3 l))
        (setq hour   (nth 2 l))
        (setq minute (nth 1 l))
        (setq sec    (nth 0 l))
        (setq n 0)
        (while (< (setq n (1+ n)) 3)
          (insert (format ",%4.4d%2.2d%2.2d000000"
		          year month day)))
        (setq n 0)
        (while (< (setq n (1+ n)) 3)
          (insert (format ",%4.4d%2.2d%2.2d%2.2d%2.2d%2.2d"
		          year month day hour minute sec)))
        (insert "\n")))
    )) ; (eval-and-compile

(eval-and-compile
  (leaf time
    :doc "display time, load and mail indicator in mode line of Emacs"
    :tag "builtin"
    ;; :defvar display-time-format
    :custom ((display-time-format . "%m/%d %H:%M")
             (display-time-mode . t)))

  (defun conv600w (a)
    (/ (* 500.0 a) 600.0))

  ) ; (eval-and-compile

(eval-and-compile
  (leaf *my:env13
    :config
    (if my-emacs-debug
        (progn
          (setq my-emacs-directory "~/.debug.emacs.d")
          (setq my-comp-command
                "emacs -q --batch -f batch-byte-compile init.el")
          )
      (progn
        (setq my-emacs-directory user-emacs-directory)
        (setq my-comp-command
              "emacs -q --batch -f batch-byte+native-compile init.el")
        ))

    (defun my-comp-init ()
      (interactive)
      (let ((bl (buffer-list))
            (tf (expand-file-name (concat my-emacs-directory "/init.el")))
            (elc (expand-file-name (concat my-emacs-directory "/init.elc")))
            b)
        (while (setq b (car bl))
          (if (and (string= (buffer-file-name b) tf)
                   (buffer-modified-p b))
              (progn
                (set-buffer b)
                (save-excursion
                  (save-buffer)
                  ;; (async-shell-command my-comp-command)
                  )))
          (setq bl (cdr bl)))
        (if (file-newer-than-file-p tf elc)
            (async-shell-command
             my-comp-command))))

    ;; my-comp-init の前に init.el をセーブするか聞かれてしまうのでコメントアウト。
    ;; el と elc の保存日時を比較するようにしたので復活
    (add-hook 'kill-emacs-hook #'my-comp-init)
    )) ; (eval-and-compile



(eval-and-compile
  (leaf *my:env14
    :defvar gnutls-algorithm-priority
    :config
    ;; (require 'package)
    ;; (add-to-list 'package-archives
    ;; 	     '("melpa" . "https://melpa.org/packages/") t)
    ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
    ;; and `package-pinned-packages`. Most users will not need or want to do this.
    ;; (add-to-list 'package-archives
    ;; 	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
    ;; (package-initialize)

    (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

    (defface holiday-face
      '((((class color) (background light))
         :background "pink")
        (((class color) (background dark))
         :background "chocolate4")
        (t
         :inverse-video t))
      "Face for indicating in the calendar dates that have holidays.
See `calendar-holiday-marker'."
      :group 'calendar-faces)

    (defface diary-face
      '((((min-colors 88) (class color) (background light))
         :foreground "red1")
        (((class color) (background light))
         :foreground "red")
        (((min-colors 88) (class color) (background dark))
         :foreground "yellow1")
        (((class color) (background dark))
         :foreground "yellow")
        (t
         :weight bold))
      "Face for highlighting diary entries.
Used to mark diary entries in the calendar (see `diary-entry-marker'),
and to highlight the date header in the fancy diary."
      :group 'calendar-faces)


    (defun string-to-int (string &optional base)
      (floor (string-to-number string base)))


    ;; ファイル保存時に改行がない場合、末尾改行を付加する
    (leaf files
      :custom ((require-final-newline . t)
               (safe-local-variable-values . '((syntax . elisp)))))

    )) ; (eval-and-compile

(eval-and-compile
  (leaf olm
    :doc "Outlook Mail in Emacs"
    :req "dash-2.8.0"
    :tag "mail"
    :added "2021-09-10"
    :ensure t
    :commands olm
    :custom
    ((olm-folder-alist
      .
      '(
        ("000 inbox" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00000000010C0000")
        ("000 outbox" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00000000010B0000")
        ("000 send" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000000001090000")
        ("000 deleted" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00000000010A0000")
        ("000 deleted_坂田さんT" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000639192A200000")
        ("000 予定表" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549950000")
        ("010 EZ運用会議" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549E10000")
        ("010 ISOP BSM" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00043A721EA60000")
        ("010 TGI運用" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001AE94692B0000")
        ("010 auシステム業務調整" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C5494F0000")
        ("010 標準T" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E40000")
        ("010 課金ログ" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549E70000")
        ("011 Sachie" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000279413A130000")
        ("011 telework" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0006391929680000")
        ("011 トラ情" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0006391929640000")
        ("015 isop-kanri" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C54A4A0000")
        ("015 isop-kml" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C54A4C0000")
        ("015 isop-oa" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C54A490000")
        ("015 kiss-system" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000279413B0F0000")
        ("015 stage-kyotu" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C54A4B0000")
        ("020 opmg" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E20000")
        ("020 uk" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E10000")
        ("050 ISOP障害連絡" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E30000")
        ("050 iMAD" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549DB0000")
        ("050 isd-tr" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001B00FCB130000")
        ("050 アクセスエラー" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0006391929950000")
        ("050 メッセージ検知連絡" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E60000")
        ("050 作業報告" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A85D804E0000")
        ("050 地震連絡" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A85D804D0000")
        ("050 夜間定期連絡" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E70000")
        ("050 情シス連絡" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A652C4E50000")
        ("070 do-jo" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000049B816140000")
        ("080 salary" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000049B816130000")
        ("080 tmp" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00011097DA6F0000")
        ("090 misc" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000049B816120000")
        ("090 union" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000068F68B6F0000")
        ("500 CF-PJ" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C5494D0000")
        ("900 Spam Report" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C5494E0000")
        ("910 kintone" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0006391929E80000")
        ("910 teams" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0006391929E90000")
        ("999 ChatWork" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00036B15E4050000")
        ("999 ISWF" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001A85D804F0000")
        ("999 gyokei-g" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549660000")
        ("999 【ＳＴＡＧＥ】○○通知" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00036B15E4030000")
        ("Archive" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000251FBB8510000")
        ("Contacts" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB590000")
        ("Contacts_Companies" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000191F729730000")
        ("Contacts_Companies1_7ef1ada7-d9ac-41f0-a366-edab47bbb241" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB5F0000")
        ("Contacts_GAL Contacts" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C10000")
        ("Contacts_GAL Contacts_2af75404-daed-471d-a02d-1d2ff7d62cd4" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000358C1A7D70000")
        ("Contacts_Organizational Contacts" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00009BF14CAB0000")
        ("Contacts_Organizational Contacts1_2bcebb8a-da57-40d0-b342-294bc9b1477a" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB5E0000")
        ("Contacts_PeopleCentricConversation Buddies" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00009BF14CAA0000")
        ("Contacts_PeopleCentricConversation Buddies1_4a9c95ec-d307-49a3-8b20-61de96f564f9" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB5D0000")
        ("Contacts_Recipient Cache" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C00000")
        ("Contacts_Recipient Cache_f944fcfe-0a77-4a88-bdeb-062de31f5369" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB5A0000")
        ("Contacts_Skype for Business 連絡先" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB5B0000")
        ("Contacts_{A9E2BC46-B3A0-4243-B315-60D991004455}1" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00033458CB5C0000")
        ("Conversation Action Settings" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876BF0000")
        ("Deleted Items" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C5494C0000")
        ("ExternalContacts" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001D9A234140000")
        ("Junk" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876D10000")
        ("PersonMetadata" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00025BDE13110000")
        ("RSS フィード" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549420000")
        ("Social Activity Notifications" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000330FEC8B20000")
        ("Trash" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C50000")
        ("Yammer Root" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001FF5CF12E0000")
        ("Yammer Root_Feeds" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001FF5CF1310000")
        ("Yammer Root_Inbound" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001FF5CF12F0000")
        ("Yammer Root_Outbound" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001FF5CF1300000")
        ("greeting" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549500000")
        ("hoge" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00036B15E3E10000")
        ("rss" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549510000")
        ("work" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876D00000")
        ("☆ old" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C60000")
        ("☆ old_010 bbhikari" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876CA0000")
        ("☆ old_010 bbhikari2" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876CB0000")
        ("☆ old_010 bbhikari3" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876CC0000")
        ("☆ old_010 kaitsu-s" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876CD0000")
        ("☆ old_010 オペバリA班" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000068F68B700000")
        ("☆ old_020 対外呼称" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000842C1D150000")
        ("☆ old_150 temp" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876D40000")
        ("☆ old_500 OA系" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876D50000")
        ("☆ old_510 情報系" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876D30000")
        ("☆ old_infosys-ope" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C70000")
        ("☆ old_kep-o" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C90000")
        ("☆ old_kepler" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876C80000")
        ("クイック操作設定" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549430000")
        ("ジャーナル" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000000001100000")
        ("タスク" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000000001120000")
        ("ニュース フィード" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C5494B0000")
        ("ファイル" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001EB2CEBF00000")
        ("メモ" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000000001110000")
        ("下書き" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00000000010F0000")
        ("予定表" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00000000010D0000")
        ("予定表_辰巳 大佑" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000656D43EF50000")
        ("会話履歴" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549550000")
        ("会話履歴" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0001F857AD860000")
        ("低優先メール" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000E0A8ED5F0000")
        ("同期の失敗" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C649420000")
        ("迷惑メール" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F0000423876BE0000")
        ("連絡先_73b12c3e-2d40-4ead-8f72-157d0e0e5a5f" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00000000010E0000")
        ("連絡先_MyContactPoint" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549570000")
        ("連絡先_MyContactPoint_P" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549580000")
        ("連絡先_PostMaster" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549590000")
        ("連絡先_Skype for Business 連絡先" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C5495A0000")
        ("連絡先_iisop-bsm" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F00043A721EA50000")
        ("連絡先_モバイル表示用" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549BA0000")
        ("連絡先_委託様" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549B40000")
        ("連絡先_業務計画G" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549610000")
        ("連絡先候補" . "00000000B274CC0EE0F7124DB4D721AC0947A94F0100EB52227BB83EAC42AE32BD8B6D80170F000119C549470000")
        )))))
;;;===================================

(eval-and-compile
  (leaf eww
    :doc "Emacs Web Wowser"
    :tag "builtin"
    :added "2021-09-10"
    :custom
    ((eww-bookmarks-directory . "~/.w3m/")
     (eww-download-directory . "~/../Downloads/")
     (eww-search-prefix . "https://www.google.com/search?tbs=qdr:y&q="))))

(eval-and-compile
  (leaf w3m
    :doc "an Emacs interface to w3m"
    :tag "hypermedia" "www" "w3m"
    ;; :defvar (w3m-use-ftp-proxy
    ;;          w3m-home-page
    ;;          w3m-mode-map)
    :ensure t
    :after "w3m"
    :commands w3m w3m-browse-url w3m-find-file
    :custom
    ((w3m-default-directory            . "~/")
     (w3m-default-save-directory       . "~/../../home/.w3m")
     (w3m-external-view-temp-directory . "~/../../home/.w3m")
     (w3m-profile-directory            . "~/../../home/.w3m")
     (w3m-use-ftp-proxy . t)
     (w3m-home-page . "file:///cygdrive/d/S023784/home/.w3m/bookmark.html")
     (w3m-dirlist-cgi-program
      . "/usr/libexec/w3m/cgi-bin/dirlist.cgi")
     (w3m-use-cookies . t)
     (w3m-cookie-accept-bad-cookies . t)
     (w3m-display-mode . 'plain))
    :bind (:w3m-mode-map
           ("n"       . w3m-next-anchor)
           ("b"       . w3m-previous-anchor)
           ((kbd "M-RET") . w3m-view-this-url-new-session)
           ('[up]     . previous-line)
           ('[down]   . next-line)
           ('[right]  . forward-char)
           ('[left]   . backward-char))))


;; 補完: vertico, marginalia, consult

;; 補完.1. helm, ivy の無効化

;; 依存する拡張がまだまだ多いので, 一度インストールして邪魔しな
;; いようにしておくことに.
(eval-and-compile
  (leaf helm :ensure t :defer-config (helm-mode -1))
  (leaf ivy :ensure t :defer-config (ivy-mode -1)))

;; ファイル名を minibuffer におさまる様に整形
(eval-and-compile
  (leaf *my:env15
    :config
    (defun my:shorten-file-path (fpath max-length)
      "Show up to `max-length' characters of a directory name `fpath' like zsh"
      (let* ((path (reverse (split-string (abbreviate-file-name fpath) "/")))
             (output "")
             (top (mapconcat 'identity (reverse (last path 3)) "/"))
             (vmax (- max-length 4 (length top)))
             (path (butlast path 3))
             )
        (while (and path
                    (and (< (length output) vmax)
                         (< (length (concat "/" (car path) output)) vmax)))
          (setq output (concat "/" (car path) output))
          (setq path (cdr path)))
        ;; 省略
        (when path
          (setq output (concat "/..." output)))
        (format "%s%s" top output)))))

;; 補完.2. 無視する拡張子の追加設定

(eval-and-compile
  (leaf *completion
    :init
    ;; 補完で無視する拡張子の追加．そのうち増える．
    (cl-loop for ext in
             '(;; TeX
               ".dvi"
               ".fdb_latexmk"
               ".fls"
               ".ilg"
               ".jqz"
               ".nav"
               ".out"
               ".snm"
               ".synctex\\.gz"
               ".vrb"
               ;; fortran >= 90
               ".mod"
               ;; zsh
               ".zwc"
               ;; libtool
               ".in"
               ".libs/"
               ;; fxxkin Apple
               ".DS_Store"
               "._DS_Store"
               ;; "org-id-locations"
               )
             do (add-to-list 'completion-ignored-extensions ext))
    ))

;; 補完.3. vertico: 本体

;; find-fileでHelmみたいにC-lでディレクトリを遡る - emacs より,
;; C-l で一つ上の階層へ上がれる様にしたり.

(eval-and-compile
  (leaf vertico
    :ensure t
    :after org
    :defun org-tags-completion-function
    :preface
    (defun my:disable-selection ()
      (when (eq minibuffer-completion-table #'org-tags-completion-function)
        (setq-local vertico-map minibuffer-local-completion-map
                    completion-cycle-threshold nil
                    completion-styles '(basic))))
    ;;
    (defun my:filename-upto-parent ()
      "Move to parent directory like \"cd ..\" in find-file."
      (interactive)
      (let ((sep (eval-when-compile (regexp-opt '("/" "\\")))))
        (save-excursion
          (left-char 1)
          (when (looking-at-p sep)
            (delete-char 1)))
        (save-match-data
          (when (search-backward-regexp sep nil t)
            (right-char 1)
            (filter-buffer-substring (point)
                                     (save-excursion (end-of-line) (point))
                                     #'delete)))))
    :advice
    (:before vertico--setup
             my:disable-selection)
    ;; :bind
    ;; (:vertico-map (("C-l" . my:filename-upto-parent)))
    ;; :custom-face
    ;; `((vertico-current
    ;;    . '((t (:inherit hl-line :background unspecified)))))
    :custom
    `((vertico-count . 9)
      (vertico-cycle . t)
      (vertico-multiline . '(("↓" 0 1
                              (face vertico-multiline))
                             ("…" 0 1
                              (face vertico-multiline))))
      )
    ;; :config
    ;; :hook (after-init-hook . vertico-mode)
    :custom-face
    (vertico-current
     . '((t :inherit highlight :extend t)))
    ))

;; 補完.4. marginalia: リッチな注釈(Enable richer annotations)

(eval-and-compile
  (leaf marginalia
    :ensure t
    :bind (("M-A" . marginalia-cycle)
           (:minibuffer-local-map
            ("M-A" . marginalia-cycle)
            ))
    :custom
    `((marginalia-annotators
       . '(marginalia-annotators-light marginalia-annotators-heavy nil)))
    ;; :hook
    ;; (after-init-hook . marginalia-mode)
    ))

;; 補完.5. consult: 便利コマンド集

;; consult-recent-file のカスタマイズのみ.

(eval-and-compile
  (leaf consult
    :doc "Consulting completing-read"
    :url "https://github.com/minad/consult"
    :ensure t
    :bind (("C-c h"   . consult-history)
           ("C-M-#"   . consult-register)
                                        ;        ("C-c k"   . consult-kmacro)     ; browse-kill-ring
           ("C-c m"   . consult-mode-command)
           ("C-h a"   . consult-apropos)
           ("C-s"     . my:isearch-or-consult)
           ("C-x 4 b" . consult-buffer-other-window)
           ("C-x 5 b" . consult-buffer-other-frame)
           ("C-x C-r" . my:consult-recent-file)
           ("C-x M-:" . consult-complex-command)
           ("C-x b" . consult-buffer)
           ("C-x r b" . consult-bookmark)
           ("M-#"     . consult-register-load)
                                        ;        ("M-'"     . consult-register-store) ; abbrev-prefix-mark
           ("M-y"     . consult-yank-pop)
           ("M-g e"   . consult-compile-error)
           ("M-g f"   . consult-flymake)
           ("M-g g"   . consult-goto-line)
           ("M-g M-g" . consult-goto-line)
           ("M-g o" . consult-outline)
           ("M-g m" . consult-mark)
           ("M-g k" . consult-global-mark)
           ("M-g i" . consult-imenu)
           ("M-g I" . consult-imenu-multi)
           ("M-s d" . consult-find)
           ("M-s D" . consult-locate)
           ("M-s g" . consult-grep)
           ("M-s G" . consult-git-grep)
           ("M-s r" . consult-ripgrep)
           ("M-s l" . consult-line)
           ("M-s L" . consult-line-multi)
           ("M-s m" . consult-multi-occur)
           ("M-s k" . consult-keep-lines)
           ("M-s u" . consult-focus-lines)
           ("M-s e" . consult-isearch-history)
           ;; (isearch-mode-map
           ;;  ("M-e" . consult-isearch-history)
           ;;  ("M-s e" . consult-isearch-history)
           ;;  ("M-s l" . consult-line)
           ;;  ("M-s L" . consult-line-multi))
           )
    :defun consult--file-preview consult--read
    :defvar recentf-list
    :custom
    `(;; 増やさないと preview 時に theme がロードされない模様.
      ;; とりあえず default の 10 倍にしている. 1 MB かな?
      (consult-preview-raw-size       . 1024000)
      (register-preview-delay         . 0)
      (register-preview-function      . #'consult-register-format)
      (xref-show-xrefs-function       . #'consult-xref)
      (xref-show-definitions-function . #'consult-xref)
      ;;    (consult-preview-key            . ,(kbd "C-M-p"))
      (consult-preview-key            . 'any) ;常にプレビュー
      (consult-narrow-key             . "<")
      )
    :config
    (advice-add #'register-preview :override #'consult-register-window)
    (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)
    (defun my:consult-recent-file ()
      "Find recent using `completing-read' with shorten filename"
      (interactive)
      (let ((files
             (mapcar
              (lambda (f)
                (cons (my:shorten-file-path f (- (window-width) 2)) f))
              recentf-list)))
        (let ((selected
               (consult--read
                (mapcar #'car files)
                :prompt "Find recent file: "
                :sort nil
                :require-match t
                :category 'file
                :state (consult--file-preview)
                :history 'file-name-history)))
          (find-file (assoc-default selected files)))))
    (defun my:isearch-or-consult (unuse-consult)
      (interactive "P")
      (let (current-prefix-arg)
        (call-interactively (if unuse-consult 'isearch-forward 'consult-line))))
    ))

;; vertico-modeとmarginalia-modeを有効化する
;; 何故か leaf ブロックの after-init-hook が効かない
(eval-and-compile
  ;; (defun after-init-hook ()
  ;;   (vertico-mode)
  ;;   (marginalia-mode)
  ;;   ;; savehist-modeを使ってVerticoの順番を永続化する
  ;;   (savehist-mode))
  ;; (add-hook 'after-init-hook #'after-init-hook)
  (vertico-mode)
  (marginalia-mode)
  (savehist-mode)
  ;; :bind も効いていない
  (define-key vertico-map (kbd "C-l") 'my:filename-upto-parent))

;; 補完.6. orderless: 補完候補の選択

;; とりあえずはデフォルトのまま

(eval-and-compile
  (leaf orderless
    :ensure t
    ;; :init (leaf flx :ensure t)
    :custom
    `((completion-styles . '(orderless))
      (orderless-matching-styles
       . '(orderless-prefixes
           orderless-flex
           orderless-regexp
           orderless-initialism
           orderless-literal))
      )
    ))

(eval-and-compile
  (leaf embark
    :doc "Conveniently act on minibuffer completions"
    :req "emacs-26.1"
    :tag "convenience" "emacs>=26.1"
    :url "https://github.com/oantolin/embark"
    :emacs>= 26.1
    :ensure t
    :bind (("C-." . embark-act)         ;; pick some comfortable binding
           ("C-;" . embark-dwim)        ;; good alternative: M-.
           ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
    ;; Optionally replace the key help with a completing-read interface
    :custom (prefix-help-command . #'embark-prefix-help-command)
    ;; Hide the mode line of the Embark live/completions buffers
    :config
    (with-eval-after-load 'embark
      (add-to-list 'display-buffer-alist
                   '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*" nil
                     (window-parameters
                      (mode-line-format . none)))))))

(eval-and-compile
  (leaf embark-consult
    :doc "Consult integration for Embark"
    :req "emacs-26.1" "embark-0.12" "consult-0.10"
    :tag "convenience" "emacs>=26.1"
    :url "https://github.com/oantolin/embark"
    :emacs>= 26.1
    :ensure t
    :after embark consult))

;; 補完.7 以下、ivy 設定のコメントアウト

(eval-and-compile
  (leaf consult-dir
    :doc "Insert paths into the minibuffer prompt"
    :req "emacs-26.1" "consult-0.9" "project-0.6.0"
    :tag "convenience" "emacs>=26.1"
    :url "https://github.com/karthink/consult-dir"
    :emacs>= 26.1
    :ensure t
    :bind (("C-x C-d" . consult-dir)
           (:minibuffer-local-completion-map
            ("C-x C-d" . consult-dir)
            ("C-x C-j" . consult-dir-jump-file)))))

;; ivy
;; (eval-and-compile
;; (leaf ivy
;;   :doc "Incremental Vertical completYon"
;;   :req "emacs-24.5"
;;   :tag "matching" "emacs>=24.5"
;;   :url "https://github.com/abo-abo/swiper"
;;   :emacs>= 24.5
;;   :ensure t
;;   :blackout t
;;   :leaf-defer nil
;;   ;; :bind (ivy-minibuffer-map
;;   ;;        (" " . ivy-partial)
;;   ;;        ((kbd "TAB") . ivy-partial))
;;   :defvar ivy-minibuffer-map
;;   :custom ((ivy-initial-inputs-alist . nil)
;;            (ivy-use-selectable-prompt . t))
;;   :global-minor-mode t
;;   :config
;;   (define-key ivy-minibuffer-map " " 'ivy-partial)
;;   (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-partial)
;;   (defun isearch-forward-or-swiper (unuse-swiper)
;;     (interactive "P")
;;     (let (current-prefix-arg)
;;       (call-interactively (if unuse-swiper 'isearch-forward 'swiper))))
;; ;;; バックエンドのivyがスペースを".*"に置換してしまうため、無効にする
;; ;;; これをしないと純粋に正規表現isearchの置き換えにならない
;;   (fset 'ivy--regex 'identity)
;;   (leaf swiper
;;     :doc "Isearch with an overview. Oh, man!"
;;     :req "emacs-24.5" "ivy-0.13.0"
;;     :tag "matching" "emacs>=24.5"
;;     :url "https://github.com/abo-abo/swiper"
;;     :emacs>= 24.5
;;     :ensure t
;;     :bind (
;;            ;; ("C-s" . swiper)
;;            ("C-s" . isearch-forward-or-swiper)
;;            ))
;;   (leaf counsel
;;     :doc "Various completion functions using Ivy"
;;     :req "emacs-24.5" "ivy-0.13.4" "swiper-0.13.4"
;;     :tag "tools" "matching" "convenience" "emacs>=24.5"
;;     :url "https://github.com/abo-abo/swiper"
;;     :emacs>= 24.5
;;     :ensure t
;;     :blackout t
;;     :bind (("C-S-s" . counsel-imenu)
;;            ("C-x C-r" . counsel-recentf)
;;            ("ﾝ" . counsel-yank-pop))
;;     :custom `((counsel-yank-pop-separator . "\n----------\n")
;;               (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
;;     :global-minor-mode t)
;;   (leaf swiper-migemo
;;   :doc "Use ivy/counsel/swiper with migemo"
;;   :req "emacs-27.1" "ivy-0.13.4" "migemo-1.9.2"
;;   :tag "emacs>=27.1"
;;   :url "https://github.com/tam17aki/swiper-migemo"
;;   :emacs>= 27.1
;;   :ensure t
;;   :require t
;;   :after ivy migemo
;;   :defvar swiper-migemo-enable-command
;;   :config
;;   (add-to-list 'swiper-migemo-enable-command 'counsel-recentf)
;;   (add-to-list 'swiper-migemo-enable-command 'counsel-rg)
;;   ;; (setq migemo-options '("--quiet" "--nonewline" "--emacs"))
;;   (migemo-kill)
;;   (migemo-init)
;;   ;; (global-swiper-migemo-mode +1)
;; )))

(eval-and-compile
  (leaf prescient
    :doc "Better sorting and filtering"
    :req "emacs-25.1"
    :tag "extensions" "emacs>=25.1"
    :url "https://github.com/raxod502/prescient.el"
    :emacs>= 25.1
    :ensure t
    :custom ((prescient-aggressive-file-save . t))
    :global-minor-mode prescient-persist-mode))

;; ### comment ivy setting
;; (eval-and-compile
;; (leaf ivy-prescient
;;   :doc "prescient.el + Ivy"
;;   :req "emacs-25.1" "prescient-5.1" "ivy-0.11.0"
;;   :tag "extensions" "emacs>=25.1"
;;   :url "https://github.com/raxod502/prescient.el"
;;   :emacs>= 25.1
;;   :ensure t
;;   :after prescient ivy
;;   :custom ((ivy-prescient-retain-classic-highlighting . t))
;;   :global-minor-mode t))

;; ;; company

;; (leaf company
;;   :doc "Modular text completion framework"
;;   :req "emacs-24.3"
;;   :tag "matching" "convenience" "abbrev" "emacs>=24.3"
;;   :url "http://company-mode.github.io/"
;;   :emacs>= 24.3
;;   :ensure t
;;   :blackout t
;;   :leaf-defer nil
;;   :bind ((company-active-map
;;           ("M-n" . nil)
;;           ("M-p" . nil)
;;           ("C-s" . company-filter-candidates)
;;           ("C-n" . company-select-next)
;;           ("C-p" . company-select-previous)
;;           ("<tab>" . company-complete-selection))
;;          (company-search-map
;;           ("C-n" . company-select-next)
;;           ("C-p" . company-select-previous)))
;;   :custom ((company-idle-delay . 0)
;;            (company-minimum-prefix-length . 1)
;;            (company-transformers . '(company-sort-by-occurrence)))
;;   :global-minor-mode global-company-mode)

;; (leaf company-c-headers
;;   :doc "Company mode backend for C/C++ header files"
;;   :req "emacs-24.1" "company-0.8"
;;   :tag "company" "development" "emacs>=24.1"
;;   :added "2020-03-25"
;;   :emacs>= 24.1
;;   :ensure t
;;   :after company
;;   :defvar company-backends
;;   :config
;;   (add-to-list 'company-backends 'company-c-headers))

;; (customize-set-variable 'python-black-extra-args '("-l" "79"))


(eval-and-compile
  (leaf company
    :doc "Modular text completion framework"
    :req "emacs-25.1"
    :tag "matching" "convenience" "abbrev" "emacs>=25.1"
    :url "http://company-mode.github.io/"
    :emacs>= 25.1
    ;; :ensure t
    :require t
    :blackout t
    :leaf-defer nil
    :bind (((kbd "C-M-c")     . company-complete)
           (:company-active-map
            ((kbd "C-h")       . nil)
            ((kbd "C-n")       . company-select-next)
            ((kbd "C-p")       . company-select-previous)
            ((kbd "<tab>")     . company-complete-common-or-cycle)
            ((kbd "<backtab>") . company-select-previous)
            ((kbd "C-i")       . company-complete-selection)
            ((kbd "M-d")       . company-show-doc-buffer))
           (:company-search-map
            ("C-n"             . company-select-next)
            ("C-p"             . company-select-previous)))
    :custom ((company-minimum-prefix-length      . 2)
             (company-selection-wrap-around      . t)
             (company-tooltip-maximum-width      . 50))
    :custom-face
    (company-tooltip
     . '((t (:background "dark slate gray" :foreground "lightgrey"))))
    (company-tooltip-common
     . '((t (:background "dark slate gray" :foreground "lightgrey"))))
    (company-tooltip-common-selection
     . '((t (:background "steelblue" :foreground "white"))))
    (company-tooltip-selection
     . '((t (:background "steelblue" :foreground "white"))))
    (company-preview-common
     . '((t (                        :foreground "white" :underline t))))
    (company-scrollbar-fg
     . '((t (:background "grey60"))))
    (company-scrollbar-bg
     . '((t (:background "gray40"))))
    ;; :global-minor-mode global-company-mode
    :config
    ;; (add-hook 'LaTeX-mode-hook  #'(lambda nil (company-mode 1)))
    ;; (add-hook 'c++-mode-hook    #'(lambda nil (company-mode 1)))
    ;; (add-hook 'c-mode-hook      #'(lambda nil (company-mode 1)))
    ;; (add-hook 'python-mode-hook #'(lambda nil (company-mode 1)))
    ;; (add-hook 'rustic-mode-hook #'(lambda nil (company-mode 1)))
    ;; (add-hook 'sh-mode-hook     #'(lambda nil (company-mode 1)))
    ;; (add-hook 'lisp-mode-hook   #'(lambda nil (company-mode 1)))
    ;; (add-hook 'emacs-lisp-mode-hook   #'(lambda nil (company-mode 1)))
    ;; (add-hook 'lisp-interaction-mode-hook #'(lambda nil (company-mode 1)))
    (add-hook 'LaTeX-mode-hook  #'company-mode)
    (add-hook 'c++-mode-hook    #'company-mode)
    (add-hook 'c-mode-hook      #'company-mode)
    (add-hook 'python-mode-hook #'company-mode)
    (add-hook 'rustic-mode-hook #'company-mode)
    (add-hook 'sh-mode-hook     #'company-mode)
    (add-hook 'lisp-mode-hook   #'company-mode)
    (add-hook 'emacs-lisp-mode-hook   #'company-mode)
    (add-hook 'lisp-interaction-mode-hook #'company-mode)
    ))

(eval-and-compile
  (leaf consult-company
    :doc "Consult frontend for company"
    :req "emacs-27.1" "company-0.9" "consult-0.9"
    :tag "emacs>=27.1"
    :url "https://github.com/mohkale/consult-company"
    :emacs>= 27.1
    :ensure t
    :after company consult
    :config
    (define-key
      company-mode-map
      [remap completion-at-point]
      #'consult-company)))

;; (leaf company-quickhelp
;;   :doc "Popup documentation for completion candidates"
;;   :req "emacs-24.3" "company-0.8.9" "pos-tip-0.4.6"
;;   :tag "quickhelp" "documentation" "popup" "company" "emacs>=24.3"
;;   :url "https://www.github.com/expez/company-quickhelp"
;;   :added "2021-11-19"
;;   :emacs>= 24.3
;;   :ensure t
;;   :after company pos-tip
;;   :custom ((company-quickhelp-color-foreground . "white")
;;            (company-quickhelp-color-background . "dark slate gray")
;;            (company-quickhelp-max-lines        . 5)))

(eval-and-compile
  (leaf editorconfig
    :custom (
             ;; (editorconfig-get-properties-function
             ;; . #'editorconfig-core-get-properties-hash)
             (editorconfig-exec-path . "/mingw64/bin/editorconfig"))
    :config
    (editorconfig-mode 1)))

(eval-and-compile
  (leaf python-mode
    :doc "Python major mode"
    :tag "oop" "python" "processes" "languages"
    :url "https://gitlab.com/groups/python-mode-devs"
    :ensure t
    :custom ((py-shell-name . "python"))
    :hook
    ;; (python-mode-hook .
    ;;                   (lambda ()
    ;;                     (add-hook 'before-save-hook
    ;;                               'python-black-buffer nil t)))
    (python-mode-hook . eglot-ensure)
    ))

(eval-and-compile
  (leaf py-isort
    :doc "Use isort to sort the imports in a Python buffer"
    :url "http://paetzke.me/project/py-isort.el"
    :ensure t
    :config
    (add-hook 'python-mode-hook
              #'(lambda nil
                  (add-hook 'before-save-hook 'py-isort-buffer nil t)))))

;; (leaf python
;;   :doc "Python's flying circus support for Emacs"
;;   :tag "builtin"
;;   :added "2021-11-05"
;;   :custom
;;   (python-shell-interpreter . "ipython")
;;   (python-shell-interpreter-args
;;    .
;;    "-i --simple-prompt --InteractiveShell.display_page=True"))

(eval-and-compile
  (leaf flyspell
    :ensure t
    :config
    (add-hook 'c-mode-hook      #'(lambda () (flyspell-prog-mode)))
    (add-hook 'c++-mode-hook    #'(lambda () (flyspell-prog-mode)))
;;  (add-hook 'go-mode-hook     #'(lambda () (flyspell-prog-mode)))
;;  (add-hook 'rustic-mode-hook #'(lambda () (flyspell-prog-mode)))
    (add-hook 'python-mode-hook #'(lambda () (flyspell-prog-mode)))
;;  (add-hook 'LaTeX-mode-hook  #'(lambda () (flyspell-mode)))
    ))

(eval-and-compile
  (leaf flymake-diagnostic-at-point
    :ensure t
    :after flymake
    :commands flymake-diagnostic-at-point-mode
    :config
    (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)))

(eval-and-compile
  (leaf eglot
    :doc "Client for Language Server Protocol (LSP) servers"
    :req "emacs-26.1" "jsonrpc-1.0.14" "flymake-1.0.9" "project-0.3.0" "xref-1.0.1" "eldoc-1.11.0"
    :tag "languages" "convenience" "emacs>=26.1"
    :url "https://github.com/joaotavora/eglot"
    :emacs>= 26.1
    :ensure t
    :after jsonrpc flymake project xref eldoc
    :defvar eglot-server-programs
    :bind (:eglot-mode-map
           ((kbd "C-c e f") . eglot-format)
           ((kbd "C-c e r") . eglot-rename)
           ((kbd "C-c e o") . eglot-code-action-organize-imports)
           ((kbd "C-c e h") . eldoc)
           ((kbd "<f6>")    . xref-find-definitions))
    :require t
    :config
    (add-to-list 'eglot-server-programs
                 '(c++-mode "clangd"))
    ;;(add-to-list 'eglot-server-programs
    ;;             '(rustic-mode . ("rust-analyzer")))
    (add-to-list 'eglot-server-programs
                 '(rustic-mode . ("rust-analyzer")))
    (add-to-list 'eglot-server-programs
                 '(python-mode "pyls"))
    ;; (add-to-list 'eglot-server-programs
    ;;              `(python-mode . ("pyls" "-v" "--tcp" "--host"
    ;;                               "localhost" "--port" :autoport)))
    (add-to-list 'eglot-server-programs
                 '(sh-mode . ("sh" "/d/nodejs/bash-language-server" "start")))
    (add-to-list 'eglot-server-programs
                 '(ruby-mode . ("solargraph")))
    ))

(eval-and-compile
  (leaf consult-eglot
    :doc "A consulting-read interface for eglot"
    :req "emacs-27.1" "eglot-1.7" "consult-0.9"
    :tag "lsp" "completion" "tools" "emacs>=27.1"
    :url "https://github.com/mohkale/consult-eglot"
    :emacs>= 27.1
    :ensure t
    :after eglot consult))

(eval-and-compile
  (leaf cc-mode
    :hook (c++-mode-hook . eglot-ensure)))

;; (leaf esh-mode
;;   :hook (sh-mode-hook . eglot-ensure))

(eval-and-compile
  (leaf dumb-jump
    :doc "Jump to definition for 50+ languages without configuration"
    :req "emacs-24.3" "s-1.11.0" "dash-2.9.0" "popup-0.5.3"
    :tag "programming" "emacs>=24.3"
    :url "https://github.com/jacktasia/dumb-jump"
    :emacs>= 24.3
    :ensure t
    ;; ### comment ivy setting
    ;; :custom (dumb-jump-selector . 'ivy)
    ))

(eval-and-compile
  (leaf cargo
    :ensure t
    :commands cargo-minor-mode
    ))

(eval-and-compile
  (leaf rustic
    :ensure t
    ;; :hook
    ;; (rustic-mode-hook . 
    ;;                   (lambda ()
    ;;                     (racer-mode t)
    ;;                     (dumb-jump-mode t)
    ;;                     (highlight-symbol-mode t)
    ;;                     (rainbow-delimiters-mode t)
    ;;                     (smartparens-mode t)))
    ;; (rustic-mode-hook . eglot-ensure)
    ;; :mode 
    :commands (rustic-mode rustic-setup-lsp)
    :defvar rustic-mode-hook
    :config
    ;; (setq rustic-mode-hook nil)
    (remove-hook 'rustic-mode-hook #'rustic-setup-lsp)
    (add-hook 'rustic-mode-hook #'eglot-ensure)
    (add-hook 'rustic-mode-hook #'cargo-minor-mode)
    (add-hook 'rustic-mode-hook #'flyspell-prog-mode)
    (add-to-list 'auto-mode-alist
                 '("\\.rs$" . rustic-mode))
    ;; (leaf quickrun
    ;;   :ensure t)
    ;; (leaf racer
    ;;   :ensure t)
    ;; (leaf smartparens
    ;;   :ensure t)
    ;; (leaf rainbow-delimiters
    ;;   :ensure t)
    ;; (leaf highlight-symbol
    ;;   :ensure t)
    ))

(eval-and-compile
  (leaf prog-mode
    :doc "Generic major mode for programming"
    :tag "builtin" "internal"
    :blackout (lisp-interaction-mode . "ElInt")
    (editorconfig-mode . " EdCfg")
    ))

;; (leaf ein
;;   :doc "Emacs IPython Notebook"
;;   :req "emacs-25" "websocket-1.12" "anaphora-1.0.4" "request-0.3.3" "deferred-0.5" "polymode-0.2.2" "dash-2.13.0" "with-editor-0.-1"
;;   :tag "reproducible research" "literate programming" "jupyter" "emacs>=25"
;;   :url "https://github.com/dickmao/emacs-ipython-notebook"
;;   :added "2021-12-09"
;;   :emacs>= 25
;;   :ensure t
;;   :defvar ein:markdown-output-buffer-name ein:worksheet-enable-undo
;;           ein:output-area-inlined-images ein:markdown-command
;;           ein:notebook-mode-map ein:notebooklist-date-format
;;   :commands ein:markdown-standalone
;;   :after websocket anaphora deferred polymode with-editor
;;   :defun (ein:format-time-string . ein-utils) (smartrep-define-key . smartrep)
;;   :preface
;;   (defun ein:markdown-preview nil
;;     (interactive)
;;     (ein:markdown-standalone)
;;     (browse-url-of-buffer ein:markdown-output-buffer-name))

;;   :hook ((ein:notebook-mode-hook . electric-pair-mode)
;;          (ein:notebook-mode-hook . undo-tree-mode))
;;   :pre-setq ((ein:worksheet-enable-undo . t)
;;              (ein:output-area-inlined-images . t))
;;   :require ein ein-notebook ein-notebooklist ein-markdown-mode smartrep
;;   :setq ((ein:markdown-command . "pandoc --metadata pagetitle=\"markdown preview\" -f markdown -c ~/.pandoc/github-markdown.css -s --self-contained --mathjax=~/.pandoc/mathjax.js"))
;;   :config
;;   (with-eval-after-load '"ein-notebook"
;;     (smartrep-define-key ein:notebook-mode-map "C-c"
;;       '(("C-n" quote ein:worksheet-goto-next-input-km)
;;         ("C-p" quote ein:worksheet-goto-prev-input-km))))

;;   (with-eval-after-load '"ein-notebooklist"
;;     (defun ein:format-nbitem-data (name last-modified)
;;       (let ((dt (date-to-time last-modified)))
;;         (format "%-30s%+20s" name
;;                 (ein:format-time-string ein:notebooklist-date-format dt))))))

(eval-and-compile
  (leaf google-translate
    :doc "Emacs interface to Google Translate."
    :tag "convenience"
    :url "https://github.com/atykhonov/google-translate"
    :ensure t
    :require t
    :bind (
           ;; ("\C-ct" . google-translate-at-point)
           ;; ("\C-cT" . google-translate-query-translate)
           ("\C-ct" . google-translate-smooth-translate)
           )
    :custom ((google-translate-backend-method . 'curl);
             ;; (google-translate-default-source-language . "en")
             ;; (google-translate-default-target-language . "ja")
             (google-translate-translation-directions-alist
              .
              '(("en" . "ja") ("ja" . "en")
                ("ko" . "ja") ("ja" . "ko"))))
    :config
    ;; (set-language-environment "Japanese")
    ;; (set-default-coding-systems 'utf-8)
    ;; (set-terminal-coding-system 'utf-8)
    ;; (set-keyboard-coding-system 'utf-8)
    ;; (set-buffer-file-coding-system 'utf-8)
 ;; (require 'google-translate-default-ui)
    (require 'google-translate-smooth-ui)
    (with-eval-after-load 'google-translate
      (defun google-translate--get-b-d1 nil
        (list 427110 1469889687)))
    ))

(eval-and-compile
  (leaf which-key
    :bind ((help-map
            ("M" . which-key-show-major-mode)))
    :pre-setq
    (
     ;; a) delay 1 seconds
     (which-key-idle-delay . 1)
     (which-key-idle-secondary-delay . 1)
     ;; b) show hints immediately
     ;; (which-key-idle-delay . 0.01)
     ;; (which-key-idle-secondary-delay . 0.01)
     ;; c) always press `C-h` to trigger which-key
     ;; (which-key-show-early-on-C-h    . t)
     ;; (which-key-idle-delay           . 10000)
     ;; (which-key-idle-secondary-delay . 0.05)
     )
    :require t
    :config
    (which-key-mode)))

(eval-and-compile
  (leaf tab-bar
    :doc "frame-local tabs with named persistent window configurations"
    :tag "builtin"
    :init
    (defvar my:ctrl-t-map (make-sparse-keymap)
      "My original keymap binded to C-t.")
    (defalias 'my:ctrl-t-prefix my:ctrl-t-map)
    (define-key global-map (kbd "C-t") 'my:ctrl-t-prefix)
    (define-key my:ctrl-t-map (kbd "c")   'tab-new)
    (define-key my:ctrl-t-map (kbd "C-c") 'tab-new)
    (define-key my:ctrl-t-map (kbd "k")   'tab-close)
    (define-key my:ctrl-t-map (kbd "C-k") 'tab-close)
    (define-key my:ctrl-t-map (kbd "n")   'tab-next)
    (define-key my:ctrl-t-map (kbd "C-n") 'tab-next)
    (define-key my:ctrl-t-map (kbd "p")   'tab-previous)
    (define-key my:ctrl-t-map (kbd "C-p") 'tab-previous)
    (define-key my:ctrl-t-map (kbd "w")   'tab-switch)
    (define-key my:ctrl-t-map (kbd "C-w")   'tab-switch)
    ;;
    (defun my:tab-bar-tab-name-truncated ()
      "Custom: Generate tab name from the buffer of the selected window."
      (let ((tab-name (buffer-name (window-buffer (minibuffer-selected-window))))
            (ellipsis (cond
                       (tab-bar-tab-name-ellipsis)
                       ((char-displayable-p ?…) "…")
                       ("..."))))
        (if (< (length tab-name) tab-bar-tab-name-truncated-max)
            (format "%-12s" tab-name)
          (propertize (truncate-string-to-width
                       tab-name tab-bar-tab-name-truncated-max nil nil
                       ellipsis)
                      'help-echo tab-name))))
    :custom
    ((tab-bar-show                   . 1)
     (tab-bar-close-button-show      . nil)
     (tab-bar-close-last-tab-choice  . nil)
     (tab-bar-close-tab-select       . 'left)
     (tab-bar-history-mode           . nil)
     (tab-bar-new-tab-choice         . "*scratch*")
     (tab-bar-new-button-show        . nil)
     (tab-bar-tab-name-function      . 'my:tab-bar-tab-name-truncated)
     (tab-bar-tab-name-truncated-max . 12)
     (tab-bar-separator              . "")
     )
    :config
    (tab-bar-mode +1)
    (tab-bar-history-mode +1)
    ))

(eval-and-compile
  ;; cus-edit.c
  (leaf cus-edit
    :doc "tools for customizing Emacs and Lisp packages"
    :tag "builtin" "faces" "help"
    :custom `((custom-file . ,(locate-user-emacs-file "custom.el")))))

(eval-and-compile
  (leaf bytecomp
    :custom
    ((byte-compile-warnings . '(not
                                obsolete
                                free-vars
                                unresolved
                                callargs
                                redefine
                                noruntime
                                cl-functions
                                interactive-only
                                make-local))
     (debug-on-error        . nil))
    :config
    (let ((win (get-buffer-window "*Compile-Log*")))
      (when win (delete-window win)))
    ))

(eval-and-compile
  ;; cus-start.c
  (leaf cus-start
    :doc "define customization properties of builtins"
    :tag "builtin" "internal"
    :preface
    (defun c/redraw-frame nil
      (interactive)
      (redraw-frame))
    :bind (("M-ESC ESC" . c/redraw-frame)
           ("\C-h\C-v" . apropos-variable))
    :custom ((user-full-name . "Masahiro Tsuge") ; C soruce
             (user-mail-address . "ma-tsuge@kddi.com") ; start up
             (user-login-name . "S023784")             ; C source
             (create-lockfiles . nil)                  ; C source
             ;; (debug-on-error . t)                      ; C source
             (init-file-debug . t)                     ; start up
             (frame-resize-pixelwise . t)              ; C source
             (enable-recursive-minibuffers . t)        ; C
             (history-length . 1000)                   ; C
             (history-delete-duplicates . t)           ; C
             (scroll-preserve-screen-position . t)     ; C
             (scroll-conservatively . 100)             ; C
             ;; (mouse-wheel-scroll-amount . '(1 ((control) . 5))) ; mwheel
             ;; (default-process-coding-system . '(undecided-dos . utf-8-unix)) ; C
             (default-process-coding-system . '(utf-8 . utf-8-unix)) ; C
             (ring-bell-function . 'ignore)            ; C
             (text-quoting-style . 'straight)          ; C
             (truncate-lines . nil)                    ; C
             ;; (use-dialog-box . nil)                     ; C
             ;; (use-file-dialog . nil)                    ; C
             (menu-bar-mode . t)                       ; C
             (tool-bar-mode . nil)                     ; C
             (scroll-bar-mode . t)                     ; scroll-bar
             (indent-tabs-mode . nil)                  ; C
	     (column-number-mode . t)                  ; simple
	     (inhibit-startup-screen . t)              ; startup
	     (initial-scratch-message . nil)           ; startup
	     (read-buffer-completion-ignore-case . t)  ; C
             (buffer-file-coding-system . 'utf-8-unix) ; C
	     (url-debug . t)                           ; url-util
             `(source-directory          ; C
               . 
               ,(cond ((string= emacs-version "28.0.90")
	               "d:/S023784/home/src/emacs/28.0.90/emacs/")
                      ((string= emacs-version "29.0.50")
                       "d:/S023784/home/src/emacs/28/native/emacs/")))
             `(find-function-C-source-directory        ; find-func
               .
               ,(expand-file-name "src" source-directory))
             (sort-columns-subprocess . nil)           ; sort
	     )
    :config
    (defalias 'yes-or-no-p 'y-or-n-p)
    ;; (keyboard-translate ?\C-h ?\C-?)
    ))

(eval-and-compile
  (leaf diff
    :doc "run `diff'"
    :tag "builtin"
    :custom-face
    (diff-file-header       . '((t (:extend t :background "grey20" :weight bold))))
    (diff-header            . '((t (:extend t :background "grey15"))))
    (diff-indicator-added   . '((t (:inherit diff-added :foreground "cyan"))))
    (diff-indicator-removed . '((t (:inherit diff-removed :foreground "orange1"))))
    (diff-refine-added      . '((t (:inherit diff-refine-changed :background "#033803" :foreground "PaleTurquoise1"))))
    (diff-removed           . '((t (:inherit diff-changed :extend t :background "#1C1111" :foreground "moccasin"))))
    ))

(eval-and-compile
  (leaf ediff
    :doc "a comprehensive visual interface to diff & patch"
    :tag "builtin"
    :custom
    ;; コントロール用のバッファを同一フレーム内に表示する
    ((ediff-window-setup-function . 'ediff-setup-windows-plain)
     ;; ediff のバッファを左右に並べる（"|"キーで上下、左右の切り替え可）
     (ediff-split-window-function . 'split-window-horizontally))
    :custom-face
    (ediff-fine-diff-B . '((t (:background "dark green"))))))

(eval-and-compile
  (leaf facemenu
    :doc "create a face menu for interactively adding fonts to text"
    :tag "builtin" "faces"
    :commands facemenu-remove-all))

(eval-and-compile
  (leaf *my:env16
    :config
    (defun my-home () (interactive) (cd "~/"))

    (defun my-scratch ()
      (interactive)
      (let ((buf-name "a")
            buf)
        (setq buf (get-buffer-create buf-name))
        (switch-to-buffer buf)
        (cd user-emacs-directory)
        (cd "./..")))
    ))
                                        ; (eval-and-compile


(eval-and-compile
(put 'set-goal-column 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'scroll-right 'disabled nil)
) ; (eval-and-compile

(eval-and-compile
  (find-file (expand-file-name "~/../../home/memo.txt")))
;; (let ((a))
;;   (setq a  (find-file (expand-file-name "~/../../home/memo.txt")))
;;   (with-current-buffer a
;;     (set-buffer-modified-p nil)))

(eval-and-compile
  (my-make-scratch))

;; 何故か動作しないのでコメントアウト
;; (switch-to-buffer-other-tab "memo.txt")
;; (switch-to-buffer-other-tab (file-name-nondirectory (draft-file-string)))
;; ((tab-switch "*scratch*")

;; ここにいっぱい設定を書く(end)

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
