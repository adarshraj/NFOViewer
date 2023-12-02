
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include comdlg32.inc
include shell32.inc
include masm32.inc
include gdi32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib comdlg32.lib
includelib shell32.lib
includelib masm32.lib
includelib gdi32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DLGBOX		equ 1001
IDC_CONTENT		equ	1002
IDC_OPEN		equ	1003
IDC_SAVE		equ	1004
IDC_EXIT		equ	1005
IDM_FILE 		equ	1020
IDM_OPEN 		equ	1021
IDM_SAVE 		equ 1022
IDM_DASH 		equ 1023
IDM_EXIT 		equ	1024
IDM_ABOUT 		equ	1026
IDM_NOSCROLL	EQU	1062
MAXSIZE			equ	300

;#########################################################################
.data		
szTitle				db	"Select a NFO file...",0	
szSaveTitle			db	"Save NFO file as...",0
szBuffer			db	MAXSIZE 		dup(0)
szBuffer2			db	MAXSIZE 		dup(0)
szFileName			db	MAXSIZE 		dup (0)	
szFileExtFilters	db	"NFO Files (*.nfo)",0,"*.nfo",0
					db	"AllFiles (*.*)",0, "*.*",0,0	
;ext					db	".nfo",0					
stHashFont LOGFONT <13,0,0,0,FW_NORMAL,0,0,0,OEM_CHARSET,OUT_DEFAULT_PRECIS	,PROOF_QUALITY	,0,FF_MODERN,"Terminal">					
CreatedBy			db	"Created By Me",0
Info				db	"Info",0
forma				db	"%d",0
					
.data?
stOpenFileName	OPENFILENAME 	<?>
hInstance		HINSTANCE 		?
hHandle				HANDLE		?
globalHandle		HANDLE		?
globalBuffer		dd 			?
filesizeHandle		dd 			?
fileSize			dd 			?
SizeReadWrite		dd 			?
hFont				dd			?
ext					db	10 dup(?)
lineCount			dd			?
;#########################################################################
