#tag DesktopWindow
Begin DesktopWindow WindowMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   552
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   2012604415
   MenuBarVisible  =   False
   MinimumHeight   =   480
   MinimumWidth    =   640
   Resizeable      =   True
   Title           =   "Xojo Projects Info"
   Type            =   0
   Visible         =   True
   Width           =   916
   Begin DesktopListBox ListProjects
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   True
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   6
      ColumnWidths    =   "25%,100,128,48,200,*"
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   2
      GridLineStyle   =   3
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   True
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   478
      Index           =   -2147483648
      InitialValue    =   "Name	Version	Project Extension	WD	Modification	Path"
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   True
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   54
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   876
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopSearchField SearchField1
      Active          =   False
      AllowAutoDeactivate=   True
      AllowFocusRing  =   False
      AllowRecentItems=   False
      AllowTabStop    =   True
      ClearMenuItemValue=   ""
      Enabled         =   True
      Height          =   22
      Hint            =   "in Name or Path"
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MaximumRecentItems=   5
      PanelIndex      =   0
      RecentItemsValue=   ""
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      Text            =   ""
      Tooltip         =   ""
      Top             =   20
      Transparent     =   True
      Visible         =   True
      Width           =   128
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
   Begin CustomThreadScan ThreadScan
      FileCount       =   0
      Index           =   -2147483648
      LockedInPosition=   False
      Priority        =   5
      Scope           =   0
      StackSize       =   0
      TabPanelIndex   =   0
      Type            =   0
   End
   Begin DesktopLabel LabelInfo1
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   160
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Projects 0000"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   78
   End
   Begin DesktopLabel LabelInfo2
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Files 00000"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   63
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  CreateBackgroundPicture
		  
		  LabelInfo1.Text = ""
		  LabelInfo2.Text = ""
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  If Self.FillPicture <> Nil Then
		    g.DrawPicture(Self.FillPicture,0,0,g.Width,g.Height,0,0,Self.FillPicture.Width,Self.FillPicture.Height)
		  End If
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function MenuScanFolder() As Boolean Handles MenuScanFolder.Action
		  
		  Var d As New SelectFolderDialog
		  Var f As FolderItem = d.ShowModal
		  
		  If f<>Nil Then
		    ThreadScan.StartFolderItem = f
		    ThreadScan.Start
		  End If
		  
		  Return True
		  
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub AtReady()
		  ThreadScan.MemoryToList(Self.ListProjects, Self.ModificationColumn, "")
		  Self.MouseCursor = System.Cursors.StandardPointer
		  MenuScanFolder.Enabled = True
		  LabelInfo1.Text = ""
		  LabelInfo2.Text = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AtStart()
		  MenuScanFolder.Enabled = False
		  Self.MouseCursor = System.Cursors.Wait
		  ListProjects.RemoveAllRows
		  LabelInfo1.Text = ""
		  LabelInfo2.Text = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateBackgroundPicture()
		  Var pic As New Picture(64,64)
		  Var g As Graphics = pic.Graphics
		  
		  Var linearBrush As New LinearGradientBrush
		  
		  If Color.IsDarkMode = True Then
		    linearBrush.StartPoint = New Point(0.0, 0.0)
		    linearBrush.EndPoint = New Point(g.Width/2.0, g.Height)
		    linearBrush.GradientStops.Add(New Pair(0.0, Color.Black))
		    linearBrush.GradientStops.Add(New Pair(0.5, Color.Gray))
		    linearBrush.GradientStops.Add(New Pair(1.0, Color.Black))
		  Else
		    linearBrush.StartPoint = New Point(0.0, 0.0)
		    linearBrush.EndPoint = New Point(g.Width/2.0, g.Height)
		    linearBrush.GradientStops.Add(New Pair(0.0, Color.Yellow))
		    linearBrush.GradientStops.Add(New Pair(0.5, Color.Red))
		    linearBrush.GradientStops.Add(New Pair(1.0, Color.Orange))
		  End If
		  
		  g.Brush = linearBrush
		  g.FillRectangle(0.0, 0.0, g.Width, g.Height)
		  
		  Self.FillPicture = pic
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function lerp(v0 As Double, v1 As Double, t As Double) As Double
		  
		  Return (1.0 - t) * v0 + t * v1
		End Function
	#tag EndMethod


	#tag Note, Name = Bin
		PSIVStrn    2019.03 IDEvInt
		
		in older projects there are 0 7 8 before the 2019!?
		
		
		
	#tag EndNote

	#tag Note, Name = ToDo
		Version auslesen siehe Notes
		
		Explorer oeffnen
		
		Modified mit Wochentag
		
		
		So if the “IDE Version” column was populated for each project, 
		then when you click on a specific project in your list - you have button (or double-click) that then launches your project in that IDE version.
		
		Something like this would be helpful for people like me, 
		who have more than one version of Xojo installed. And, for whatever reason, 
		have not upgrade every project to the latest version of Xojo.
		
		Sometimes I just want to look at some old code (in its original form, potentially with different or older plugins), 
		while I work in the latest IDE. :nerd_face:
		
		
		
	#tag EndNote

	#tag Note, Name = XML
		
		<?xml version="1.0" encoding="UTF-8"?>
		<RBProject version="2024r3.1" FormatVersion="2" MinIDEVersion="20210300">
		<block type="Project" ID="0">
		 <ProjectSavedInVers>2024.031</ProjectSavedInVers>
		 <IDEVersion>20190300</IDEVersion>
		
	#tag EndNote

	#tag Note, Name = Xojo
		Type=Web2
		RBProjectVersion=2021.021
		MinIDEVersion=20200200
		OrigIDEVersion=20200201
		
		
	#tag EndNote


	#tag Property, Flags = &h0
		FillPicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		ModificationColumn As Integer = 4
	#tag EndProperty

	#tag Property, Flags = &h0
		VersionColumn As Integer = 1
	#tag EndProperty


#tag EndWindowCode

#tag Events ListProjects
	#tag Event
		Function ConstructContextualMenu(base As DesktopMenuItem, x As Integer, y As Integer) As Boolean
		  System.DebugLog CurrentMethodName
		  
		  base.AddMenu New DesktopMenuItem("Open Xojo IDE ..", "openxojoide")
		  
		  base.AddMenu New DesktopMenuItem("Open With ..", "selectxojoide")
		  
		  base.AddMenu New DesktopMenuItem("Open Path", "explorer")
		  
		  base.AddMenu New DesktopMenuItem("Projects Count : " + Me.RowCount.ToString, "info")
		  
		  Return True
		  
		End Function
	#tag EndEvent
	#tag Event
		Function ContextualMenuItemSelected(selectedItem As DesktopMenuItem) As Boolean
		  System.DebugLog CurrentMethodName
		  
		  Select Case selectedItem.Tag
		  Case "explorer"
		    If Me.SelectedRowIndex = DesktopListBox.NoSelection Then
		    Else
		      Var f As FolderItem = Me.RowTagAt(Me.SelectedRowIndex)
		      Var folder As FolderItem = f.Parent
		      If folder.IsFolder Then
		        System.DebugLog "Open " + folder.NativePath
		        folder.Open(True)
		      End If
		    End If
		    Return True
		  Case "selectxojoide"
		    If Me.SelectedRowIndex = DesktopListBox.NoSelection Then
		      MessageBox("please select a row")
		    Else
		      
		      Var version As String = Me.CellTextAt(Me.SelectedRowIndex, Self.VersionColumn)
		      
		      Var dlg As New OpenFileDialog
		      dlg.ActionButtonCaption = "select executable file"
		      dlg.CancelButtonCaption = "cancel"
		      'dlg.SuggestedFileName = "Xojo.exe" // MacOS Linux
		      dlg.Title = "select Xojo IDE"
		      dlg.PromptText = "select Xojo IDE for project version " + version
		      dlg.InitialFolder = SpecialFolder.Applications
		      dlg.AllowMultipleSelections = False
		      
		      Var f As FolderItem = dlg.ShowModal
		      If f <> Nil Then
		        
		        ' Use the folderitem here
		        Var db As New DB
		        Var comment As String = ""
		        db.ExecuteSQL("delete from xojo where Version=?", version)
		        db.ExecuteSQL("insert into xojo (Version, Path, Comment) VALUES (?, ?, ?)", version, f.NativePath, comment)
		      Else
		        ' User cancelled
		      End If
		    End If
		    Return True
		  Case "openxojoide"
		    If Me.SelectedRowIndex = DesktopListBox.NoSelection Then
		      MessageBox("please select a row")
		    Else
		      Var version As String = Me.CellTextAt(Me.SelectedRowIndex, Self.VersionColumn)
		      Var db As New DB
		      Var rs As RowSet = db.SelectSQL("select * from xojo where version=?", version)
		      If rs.AfterLastRow = False Then
		        Var f As New FolderItem(rs.Column("Path"), FolderItem.PathModes.Native)
		        f.Open(True)
		      End If
		    End If
		    Return True
		  End Select
		  
		End Function
	#tag EndEvent
	#tag Event
		Function PaintCellBackground(g As Graphics, row As Integer, column As Integer) As Boolean
		  Select Case column
		  Case Self.ModificationColumn
		    If row<= Me.LastRowIndex Then
		      Var dateCell As DateTime = Me.CellTagAt(row, column)
		      Var secondsToday  As Double = DateTime.Now.SecondsFrom1970
		      Var old As DateTime = (DateTime.Now - New DateInterval(0,6,0))
		      Var secondsOld  As Double = old.SecondsFrom1970
		      Var secondsFile As Double = dateCell.SecondsFrom1970
		      
		      If secondsFile<secondsOld Then secondsFile=secondsOld
		      If secondsFile>secondsToday Then secondsFile=secondsToday
		      
		      secondsToday=secondsToday-secondsOld
		      secondsFile=secondsFile-secondsOld
		      
		      Var procent As Double = (secondsFile/secondsToday)
		      
		      Var re As Double = lerp(128.0,128.0,procent)
		      Var gr As Double = lerp(128.0,255.0,procent)
		      Var bl As Double = lerp(128.0,128.0,procent)
		      
		      g.DrawingColor = Color.RGB(re,gr,bl)
		      g.FillRectangle(g.Width-8,0,8,g.Height)
		    End If
		  End Select
		End Function
	#tag EndEvent
	#tag Event
		Function RowComparison(row1 as Integer, row2 as Integer, column as Integer, ByRef result as Integer) As Boolean
		  
		  If column = Self.ModificationColumn Then
		    Var date1 As DateTime = Me.CellTagAt(row1, column)
		    Var date2 As DateTime = Me.CellTagAt(row2, column)
		    If date1>date2 Then result =  1
		    If date1<date2 Then result = -1
		    If date1=date2 Then result =  0
		    Return True
		  End If
		  
		End Function
	#tag EndEvent
	#tag Event
		Sub Opening()
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SearchField1
	#tag Event
		Sub Pressed()
		  Self.MouseCursor = System.Cursors.Wait
		  ThreadScan.MemoryToList(Self.ListProjects, Self.ModificationColumn, Me.Text)
		  Self.MouseCursor = System.Cursors.StandardPointer
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ThreadScan
	#tag Event
		Sub UserInterfaceUpdate(data() as Dictionary)
		  
		  For Each update As Dictionary In data
		    If update.HasKey("Thread") Then
		      If update.Value("Thread") = "Start" Then
		        AtStart
		      End If
		      If update.Value("Thread") = "Ready" Then
		        AtReady
		      End If
		    End If
		    If update.HasKey("Count") Then
		      Var c As Integer = update.Value("Count")
		      LabelInfo1.Text = "Projects " + c.ToString
		    End If
		    If update.HasKey("Files") Then
		      Var c As Integer = update.Value("Files")
		      LabelInfo2.Text = "Files " + c.ToString
		    End If
		  Next
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ModificationColumn"
		Visible=false
		Group="Behavior"
		InitialValue="3"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FillPicture"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="VersionColumn"
		Visible=false
		Group="Behavior"
		InitialValue="1"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
