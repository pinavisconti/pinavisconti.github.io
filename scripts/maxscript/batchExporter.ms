-- Downloaded from: http://www.pinavisconti.com

gc()
clear
try
(
	destroyDialog exporterUI
)
catch
(
	format "\nCould not destroy original dialog\n"
)
(
	m_dir = undefined
	m_expSel = undefined
	m_extFormat = undefined
	m_originalFile = maxfilepath + maxfilename
	m_copyFileName = undefined
	m_selType = #("selected","editPolys","all")
	
	fn ObjectExport directory extensionFormat exportObject =
	(
		exportObject.pos = [0,0,0]
		fileName = exportObject.name
		select exportObject
		try
		(
			exportFile (directory + "/" + fileName + "." + extensionFormat) #noPrompt selectedOnly:true
		)
		catch
		(
			format "\nFailed to export %. \n" exportObject.name
		)
	)
	
	fn CreateCopyFile =
	(
		copyFileName = maxFilePath + (getFilenameFile maxFileName) + "_exportTempFile.max"
		saveMaxFile copyFileName quiet:true
		return copyFileName
	)
	
	fn SelectedExport directory extensionFormat =
	(
		exportObjs = (selection as array)
		originalLocations = #()
		for i = 1 to exportObjs.count do
		(
			if(exportObjs[i] != undefined) then
			(
				append originalLocations exportObjs[i].pos
				ObjectExport directory extensionFormat exportObjs[i]
				exportObjs[i].pos = originalLocations[i]
			)
		)
	)
	
	fn EditPolyExport directory extensionFormat =
	(
		m_copyFileName = CreateCopyFile()
		loadMaxFile m_copyFileName
		for o in objects do
		(
			if(classof(o) == Editable_Poly)then
			(
				ObjectExport directory extensionFormat o
			)
		)
		deletefile m_copyFileName
		loadMaxFile m_originalFile
	)
	
	fn AllExport directory extensionFormat =
	(
		m_copyFileName = CreateCopyFile()
		loadMaxFile m_copyFileName
		for o in objects do
		(
			ObjectExport directory extensionFormat o
		)
		deletefile m_copyFileName
		loadMaxFile m_originalFile
	)
	
	fn InitializeExport directory selectionType extensionFormat =
	(
		case selectionType of
		(
			1: SelectedExport directory extensionFormat
			2: EditPolyExport directory extensionFormat
			3: AllExport	directory extensionFormat
		)
	)
	
	fn UpdateExportSel rdo_btn =
	(
			curState = rdo_btn.state
			m_expSel = curState
	)
	
	curRolloutFloater = newrolloutfloater "Batch Exporter 01" 300 195
	rollout exporterUI "Batch Exporter"
	(
	    label lbl_selectDir "Please select a directory:" 	pos:[15,15]
		edittext edt_directoryPath "" 						width:200
		button btn_browseDir "Browse"						pos:[220,30]
		
		dropdownlist ddl_extFormat "Extension" items:#("fbx","3ds","obj")		
		radiobuttons rdo_exportSel "Export which of the following?" labels:#("selected objects","editable polys","all")
		button btn_export "Export"
		
		
		on btn_browseDir pressed do
		(
			m_dir = getSavePath caption:"" initalDir:#export --#Scene
			edt_directoryPath.text = (m_dir as string)
		)
		
		on ddl_extFormat selected sel do
		(
			m_extFormat = (ddl_extFormat.selected as string)
		) 
		
		on rdo_exportSel changed state do
		(
			UpdateExportSel rdo_exportSel
		)
		
		on btn_export pressed do
		(
			if(m_dir == undefined) then
			(
				Messagebox "You have not defined a save directory, please do so." Title: "No directory detected"
			)
			else if(m_exportSel == 1 AND selection.count < 1)then
			(
				Messagebox "You have chosen export selected but not selected any objects." Title: "No selection detected"
			)
			else
			(
				UpdateExportSel rdo_exportSel
				if((m_extFormat == undefined) OR (m_extFormat == "")) then
				(
					m_extFormat = "fbx"
				)
				
				InitializeExport m_dir m_expSel m_extFormat
			)

		)
	)
	addRollout exporterUI curRolloutFloater rolledup:false
	Createdialog exporterUI
)
	