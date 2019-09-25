'Start eemagine macro recording
'Time: Monday, March 18, 2019 19:51:28
'Macro Name: C:\Users\KHO\Desktop\Visor raw 20190308_1451\filter2.vbs
Dim CurrentItem
Dim Application
Dim Documents
Set Application = CreateObject("asa.Application")
Application.Activate
Set Documents = Application.Documents
Set CurrentItem = Application.ActiveDocument
main()
Sub main()
'Bandpass
CurrentItem.FFTFilterData Array(".\Output"), "EEProbe", 0.3, 1000, 24, 0
'Bandstop (Notch) 
CurrentItem.FFTFilterData Array(".\Output"), "EEProbe", 51.0, 49.0, 36, 0
End Sub
