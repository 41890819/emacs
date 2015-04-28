;=====load path=====
(add-to-list 'load-path "~/.emacs.d/site-lisp")

;=====显示时间=====
(display-time)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;=====其他设置=====
(show-paren-mode t);括号高亮
(setq frame-title-format "wli@-->%f");标题全路径显示
;(customize-set-variable 'scroll-bar-mode 'right);;滚动栏右侧显示
(scroll-bar-mode 0);关闭滚动栏
(tool-bar-mode 0);关闭工具栏
(menu-bar-mode 0);关闭菜单栏
(fset 'yes-or-no-p 'y-or-n-p);缩写yes和no
(setq default-tab-width 8);tab8个字符宽度
(setq show-paren-style 'parentheses);括号匹配但不来回弹跳
(setq inhibit-startup-message t);不显示启动画面
(setq gnus-inhibit-startup-message t);不显示GNU启动画面
;(set-language-environment "Chinese-GB")
(prefer-coding-system 'gb2312)
(prefer-coding-system 'utf-8)
;=====窗口移动=====
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;=====颜色设置=====
(require 'color-theme)
;(color-theme-taming-mr-arneson)
;(color-theme-calm-forest)
;(color-theme-deep-blue)
;(color-theme-green-kingsajz)
;(color-theme-jonadabian-slate)
;(color-theme-linh-dang-dark)
;(color-theme-sitaram-solaris)
;(color-theme-subtle-hacker)
;(color-theme-White-On-Grey)
(color-theme-dark-blue2)
;(color-theme-vim-colors)
;(color-theme-gnome2)

;=====cedet=====
;=====http://emacser.com/cedet.htm=====
(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")
(semantic-load-enable-code-helpers);当光标停留在函数名上，会在状态栏显示原型
(global-semantic-tag-folding-mode 1);使函数体可以折叠
(setq semantic-idle-scheduler-idle-time 432000)

;=====stardict=====
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)
(defun kid-sdcv-to-buffer ()
  (interactive)
  (let ((word (if mark-active
                  (buffer-substring-no-properties (region-beginning) (region-end))
                  (current-word nil t))))
    (setq word (read-string (format "查字典 (默认 %s): " word)
                            nil nil word))
    (set-buffer (get-buffer-create "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    ; 在没有创建 *sdcv* windows 之前检查是否有分屏(是否为一个window)
    ; 缺憾就是不能自动开出一个小屏幕，自己注销
    (if (null (cdr (window-list)))
        (setq onewindow t)
      (setq onewindow nil))
    (let ((process (start-process-shell-command "sdcv" "*sdcv*" "sdcv" "-n" word)))
      (set-process-sentinel
       process
       (lambda (process signal)
         (when (memq (process-status process) '(exit signal))
           (unless (string= (buffer-name) "*sdcv*")
             (setq kid-sdcv-window-configuration (current-window-configuration))
             (switch-to-buffer-other-window "*sdcv*")
             (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
             (local-set-key (kbd "n") 'next-line)
             (local-set-key (kbd "j") 'next-line)
             (local-set-key (kbd "p") 'previous-line)
             (local-set-key (kbd "k") 'previous-line)
             (local-set-key (kbd "SPC") 'scroll-up)
             (local-set-key (kbd "DEL") 'scroll-down)
             (local-set-key (kbd "q") (lambda ()
                                        (interactive)
                                        (if (eq onewindow t)
                                            (delete-window)
                                          (progn (bury-buffer) (other-window 1))))))
           (goto-char (point-min))))))))
;=====ecb=====
;(add-to-list 'load-path "~/.emacs.d/site-lisp/ecb-2.40")
;(require 'ecb)
;(setq ecb-auto-activate t ecb-tip-of-the-day nil)

;(global-set-key [(f6)] 'ecb-hide-ecb-windows)
;(global-set-key [(f5)] 'ecb-show-ecb-windows)

;=====使某一ecb窗口最大化=====
;(define-key global-map [(f9)] 'ecb-maximize-window-directories)
;(define-key global-map [(f10)] 'ecb-maximize-window-sources)
;(define-key global-map [(f11)] 'ecb-maximize-window-methods)
;(define-key global-map [(f12)] 'ecb-maximize-window-history)
;(define-key global-map [(f8)] 'ecb-restore-default-window-sizes);恢复原始大小

;;eshell中输入cls清空eshell
(defun eshell/cls ()
"Clears the shell buffer ala Unix's clear or DOS' cls"
(interactive)
;; the shell prompts are read-only, so clear that for the duration
(let ((inhibit-read-only t))
;; simply delete the region
(delete-region (point-min) (point-max)))) 

;=====woman(WithOut man)=====
(global-set-key [(f12)] (lambda()        ;;设定F1为woman快捷键
(interactive)
(let ((woman-topic-at-point t))
(woman))))
(setq woman-use-own-frame nil)          ;; WoMan不打开新的 frame, 你可能会想要这个配置


;=====tabbar=====
(require 'tabbar)
(tabbar-mode t)
(global-set-key [(control left)] 'tabbar-backward)
(global-set-key [(control right)] 'tabbar-forward)

(setq tabbar-buffer-groups-function
	  (lambda (b)(list "All Buffers")))
(setq tabbar-buffer-list-function
	  (lambda()
		(remove-if
		 (lambda(buffer)
		   (find (aref(buffer-name buffer) 0)" *"))
		 (buffer-list))))
;=====设置tabbar外观=====
;设置默认主题;字体，背景和当前颜色，大小
(set-face-attribute 'tabbar-default-face nil
					:family "DejaVa sans mono"
					:background "gray80"
					:foreground "gray30"
					:height 1.0
					)
(set-face-attribute 'tabbar-button-face nil
					:inherit 'tabbar-default
					:box '(:line-width 1 :color "yellow 70")
					)
(set-face-attribute 'tabbar-selected-face nil
					:inherit 'tabbar-default
					:foreground "DarkGreen"
					:background "LightGoldenrod"
					:box '(:line-width 2 :color "DarkGoldenrod")
					:overline "black"
;					:underline "black"
					:weight 'bold
					)
(set-face-attribute 'tabbar-unselected-face nil
					:inherit 'tabbar-default
					:box '(:line-width 2 :color "#00B2BF")
					)
;=====speedbar=====
(define-key global-map [(f3)]  'speedbar-get-focus)
; (setq speedbar-right-side nil)  
; (setq speedbar-show-unknown-files t)  
; (setq speedbar-use-images nil)  
; (setq speedbar-width 30)  

(require 'xcscope)
(setq cscope-do-not-update-database t);不更新cscope

(define-key global-map [(control f3)]  'cscope-set-initial-directory)
(define-key global-map [(control f4)]  'cscope-unset-initial-directory)
(define-key global-map [(control f5)]  'cscope-find-this-symbol)
(define-key global-map [(control f6)]  'cscope-find-global-definition)
(define-key global-map [(control f7)]  'cscope-find-global-definition-no-prompting)
(define-key global-map [(control f8)]  'cscope-pop-mark)
(define-key global-map [(control f9)]  'cscope-next-symbol)
(define-key global-map [(control f10)] 'cscope-next-file)
(define-key global-map [(control f11)] 'cscope-prev-symbol)
(define-key global-map [(control f12)] 'cscope-prev-file)
(define-key global-map [(control f1)]  'cscope-display-buffer)
(define-key global-map [(control f2)]  'cscope-display-buffer-toggle)

;=====最大化屏幕=====
(defun my-max-window()
(x-send-client-message nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
(x-send-client-message nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
)
(run-with-idle-timer 1 nil 'my-max-window)

;======显示行号=====
(require 'linum)
(global-linum-mode 1)

;=====C模式设置=====
(defun my-c-mode-hook()
  (c-set-style "linux")
;  (setq tab-width 8 indent-tabs-mod nil)
;  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8)
)
(add-hook 'c-mode-hook 'my-c-mode-hook)

;=====auto-complete=====
(add-to-list 'load-path "~/.emacs.d/site-lisp/auto-complete")

(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/auto-complete/ac-dict")

(ac-config-default)

;全局开启auto-complete

(global-auto-complete-mode t)

(global-set-key [(control tab)] 'auto-complete)

;设置auto-complete弹出菜单配色

(set-face-background 'ac-candidate-face "#657B83")

(set-face-underline 'ac-candidate-face "#657B83")

(set-face-background 'ac-selection-face "#93A1A1")

;添加需要提示的内容

(setq-default ac-sources '(

						   ac-source-filename

						   ac-source-words-in-all-buffer

						   ac-source-functions

						   ac-source-variables
						   
						   ac-source-symbols
						   
						   ac-source-features
						   
						   ac-source-abbrev
						   
						   ac-source-words-in-same-mode-buffers
						   
						   ac-source-dictionary))

;=====初始化shell=====
(eshell)
(rename-buffer "sh3")
(eshell)
(rename-buffer "sh2")
(eshell)
(rename-buffer "sh1")
(eshell)
(rename-buffer "sh")
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(show-paren-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#233b5a" :foreground "#fff8dc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
