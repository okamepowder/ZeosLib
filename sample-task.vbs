set fso = createObject("Scripting.FileSystemObject")
CommandFile = fso.getParentFolderName(WScript.ScriptFullName) & "\sample-update.bat"

If fso.FileExists(CommandFile) = True Then
  Set ws = CreateObject("Wscript.Shell")
  ws.run "cmd /c " & """" & CommandFile & """", 6
End If


' https://learn.microsoft.com/ja-jp/office/vba/language/reference/user-interface-help/shell-function
' 0 vbHide
' 6 vbMinimizedNoFocus