#tag Class
Protected Class CustomThreadScan
Inherits Thread
	#tag Event
		Sub Run()
		  Me.AddUserInterfaceUpdate("Thread":"Start")
		  
		  Me.ScanFolderForXojoProjects(Me.StartFolderItem)
		  
		  Memory.Sort(AddressOf MemoryCompare)
		  
		  Me.AddUserInterfaceUpdate("Thread":"Ready")
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddMemory(f As FolderItem, version As String, project As String)
		  Var m As New MemoryClass
		  m.F = f
		  m.Version = version
		  m.Project = project
		  
		  Memory.Add(m)
		  
		  Me.AddUserInterfaceUpdate("Count":Memory.Count)
		  
		  'If f.DisplayName.Contains("TimeRecordingPC") Then
		  'Break
		  'End If
		  'If f.DisplayName.Contains("PatternInput") Then
		  'Break
		  'End If
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DateStr(d As DateTime) As String
		  Return d.ToString(Locale.Current, DateTime.FormatStyles.Medium, DateTime.FormatStyles.Medium)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBinVersion(f As FolderItem) As String
		  Var version As String = "?"
		  Try
		    Var st As BinaryStream = BinaryStream.Open(f)
		    
		    Var m As MemoryBlock = st.Read(128,Encodings.UTF8)
		    Var firstRow As String = m
		    'PSIVStrn    2019.03 IDEvInt
		    Var x1 As Integer = firstRow.IndexOf("PSIVStrn")
		    Var x2 As Integer 
		    x2 = firstRow.IndexOf("IDEvInt")
		    If x2=-1 Then x2 = firstRow.IndexOf("Ver1Strn") 'PSIVStrn   •2019.011Ver1Strn
		    If x1>=0 And x2>x1 Then
		      version = firstRow.Middle(x1+8,x2-(x1+8))
		      version = version.Trim()
		      version = version.TrimLeft(Chr(0)) 'why
		      version = version.TrimLeft(Chr(8)) 'why
		      version = version.TrimLeft(Chr(7)) 'why
		    End If
		    
		    st.Close
		  Catch e As IOException
		    version = e.Message
		  End Try
		  
		  Return version
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetXMLVersion(f As FolderItem) As String
		  Var version As String = "?"
		  Var xml As New XMLDocument
		  
		  Try
		    xml.LoadXML(f)
		  Catch e As XmlException
		    version = e.Message
		    Return version
		  End Try
		  
		  Var nodes As XmlNodeList
		  nodes = xml.XQL("//RBProject")
		  Var node As XmlNode
		  For i As Integer = 0 To nodes.Length - 1
		    node = nodes.Item(i)
		    version = node.GetAttribute("version")
		  Next
		  
		  Return version
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetXojoVersion(f As FolderItem) As String
		  Var version As String = "?"
		  Try
		    Var st As TextInputStream = TextInputStream.Open(f)
		    st.Encoding = Encodings.UTF8
		    For i As Integer = 1 To 4
		      Var x As String = st.ReadLine()
		      Var sp() As String = x.Split("=")
		      If sp(0)="RBProjectVersion" Then
		        version = sp(1)
		      End If
		    Next
		    st.Close
		  Catch e As IOException
		    version = e.Message
		  End Try
		  
		  Return version
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MemoryCompare(m1 As MemoryClass, m2 As MemoryClass) As Integer
		  If m1.F.DisplayName > m2.F.DisplayName Then Return  1
		  If m1.F.DisplayName < m2.F.DisplayName Then Return -1
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MemoryToList(list As DesktopListBox, ModificationColumn As Integer, Tx As String)
		  list.RemoveAllRows
		  
		  
		  
		  For Each m As MemoryClass In Memory
		    Var view As Boolean =  False
		    If tx.Length = 0 Then 
		      view = True
		    Else
		      If m.f.DisplayName.Contains(Tx,ComparisonOptions.CaseInsensitive,Locale.Current) Then
		        view = True
		      End If
		      If m.f.NativePath.Contains(Tx,ComparisonOptions.CaseInsensitive,Locale.Current) Then
		        view = True
		      End If
		    End If
		    If view Then
		      Var f As FolderItem = m.f
		      list.AddRow f.DisplayName.Left(f.DisplayName.Length-(f.Extension.Length+1)), m.Version, m.Project, WeekDayStr(f.ModificationDateTime), DateStr(f.ModificationDateTime), f.NativePath
		      Var row As Integer = list.LastAddedRowIndex
		      list.RowTagAt(row) = f
		      list.CellTagAt(row, ModificationColumn)= f.ModificationDateTime
		    End If
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Scan(folder As FolderItem)
		  
		  For Each f As FolderItem In folder.Children
		    If f.IsFolder = True Then
		      
		      If f.DisplayName = "Angefangene Projekte" Or f.DisplayName = "Tests" Then
		        'diese nicht
		      Else
		        Scan(f)
		      End If
		      
		    End If
		    
		    If f.IsFolder = False Then
		      
		      Me.FileCount = Me.FileCount + 1
		      Me.AddUserInterfaceUpdate("Files":Me.FileCount)
		      
		      Var version As String = "?"
		      Select Case f.Extension.Lowercase
		      Case "xojo_binary_project"
		        System.DebugLog f.NativePath
		        version = GetBinVersion(f)
		        AddMemory(f, version, "Binary Project")
		        
		      Case "xojo_project"
		        System.DebugLog f.NativePath
		        version = GetXojoVersion(f)
		        AddMemory(f, version, "Project")
		        
		      Case "xojo_xml_project"
		        System.DebugLog f.NativePath
		        version = GetXMLVersion(f)
		        AddMemory(f, version, "XML Project")
		        
		      End Select
		      
		    End If
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScanFolderForXojoProjects(f As FolderItem)
		  System.DebugLog CurrentMethodName
		  
		  Memory.RemoveAll
		  FileCount = 0
		  
		  If f = Nil Then
		    System.DebugLog "nil"
		  Else
		    System.DebugLog "List Recursive"
		    Scan(f)
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WeekDayStr(date As DateTime) As String
		  return date.ToString("eee", Locale.Current)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		FileCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Memory() As MemoryClass
	#tag EndProperty

	#tag Property, Flags = &h0
		StartFolderItem As FolderItem
	#tag EndProperty


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
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
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Types"
			EditorType="Enum"
			#tag EnumValues
				"0 - Cooperative"
				"1 - Preemptive"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
