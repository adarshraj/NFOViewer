.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include NFO Viewer.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax
    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DLGBOX,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
			invoke  GetWindowLong,hWnd,GWL_EXSTYLE
            or   eax,WS_EX_LAYERED
			invoke  SetWindowLong,hWnd,GWL_EXSTYLE,eax
			xor esi, esi
			.while esi <=255
				invoke  SetLayeredWindowAttributes,hWnd,0,esi,LWA_ALPHA
				add esi, 100
				invoke Sleep, 20
			.endw	 
			invoke RtlZeroMemory,addr stOpenFileName, 1024			
			invoke CreateFontIndirect, addr stHashFont
			mov hFont,eax
			invoke SendDlgItemMessage, hWnd, IDC_CONTENT, WM_SETFONT, hFont, TRUE	
			
			mov stOpenFileName.lStructSize, SIZEOF stOpenFileName
			mov stOpenFileName.hwndOwner, NULL
			mov stOpenFileName.hInstance, offset hInstance
			mov stOpenFileName.lpstrFilter, offset szFileExtFilters
			mov stOpenFileName.lpstrCustomFilter, NULL
			mov stOpenFileName.nFilterIndex,1
			mov stOpenFileName.lpstrFile, offset szFileName
			mov stOpenFileName.nMaxFile, SIZEOF szFileName
			mov stOpenFileName.lpstrTitle,offset szTitle
			mov stOpenFileName.Flags,OFN_FILEMUSTEXIST or \
									 OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
									 OFN_EXPLORER or OFN_HIDEREADONLY
			mov stOpenFileName.lpstrDefExt, offset ext
			
			invoke SetTimer,hWnd, 0,4000,0
							 				 
	.elseif eax==WM_COMMAND
		mov eax, wParam
		mov edx, eax
		shr edx, 16
		.if eax ==  IDM_OPEN	
			invoke GetOpenFileName,addr stOpenFileName
			.if eax == TRUE 
				invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,65535
				mov globalHandle, eax
				invoke GlobalLock, globalHandle
				mov globalBuffer, eax
				invoke CreateFile, addr szFileName,GENERIC_READ or GENERIC_WRITE ,FILE_SHARE_READ or FILE_SHARE_WRITE, NULL,OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE, NULL
				mov hHandle, eax
				invoke ReadFile, hHandle,globalBuffer,65534, addr SizeReadWrite, NULL
				invoke SendDlgItemMessage, hWnd, IDC_CONTENT,WM_SETTEXT,0, globalBuffer
				invoke SetWindowText, hWnd,addr szFileName	
							
				invoke SendDlgItemMessage, hWnd, IDC_CONTENT,EM_GETLINECOUNT,0,0
				mov lineCount, eax

				invoke CloseHandle,hHandle
				invoke GlobalUnlock,globalBuffer
				invoke GlobalFree,globalHandle				
			.endif
		.elseif eax == IDM_SAVE
			invoke KillTimer,hWnd,0	
			invoke SendDlgItemMessage, hWnd, IDC_CONTENT, EM_GETMODIFY,0,0
			.if eax == TRUE
				mov stOpenFileName.Flags,OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY
				mov stOpenFileName.lpstrTitle,offset szSaveTitle
				invoke GetSaveFileName, addr stOpenFileName
				.if eax == TRUE
					invoke CreateFile, addr szFileName, GENERIC_WRITE or GENERIC_READ,FILE_SHARE_WRITE or FILE_SHARE_WRITE, NULL,CREATE_NEW,FILE_ATTRIBUTE_ARCHIVE,NULL
					mov hHandle, eax
					invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT,65535			
					mov globalHandle, eax
					invoke GlobalLock, globalHandle
					mov globalBuffer, eax
					invoke SendDlgItemMessage,hWnd,IDC_CONTENT,WM_GETTEXT,65534, globalBuffer
					invoke WriteFile, hHandle, globalBuffer, eax, addr SizeReadWrite, NULL
					invoke CloseHandle,hHandle
					invoke GlobalUnlock,globalBuffer
					invoke GlobalFree,globalHandle
				.endif
			.endif
		.elseif eax == IDM_NOSCROLL
			invoke KillTimer,hWnd,0	
		.elseif eax ==  IDM_EXIT
			invoke SendMessage, hWnd,WM_CLOSE, 0, 0		
		.elseif eax == IDM_ABOUT
			invoke MessageBox, hWnd, addr CreatedBy, addr Info,MB_OK	
		.endif
		comment ~ ~
	.elseif eax == WM_TIMER

				invoke SendDlgItemMessage, hWnd, IDC_CONTENT,EM_LINESCROLL,0, 5
				;invoke SendDlgItemMessage, hWnd, IDC_CONTENT,EM_SCROLL,SB_LINEUP, 0

	.elseif eax==WM_CLOSE
		invoke EndDialog,hWnd,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
