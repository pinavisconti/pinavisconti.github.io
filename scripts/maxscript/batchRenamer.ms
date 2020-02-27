-- Downloaded from: http://www.pinavisconti.com

gc()
clear
try(destroyDialog renamerUI)
catch
(
	format "\nCould not destroy original dialog\n"
)
(
	rename = ""
	
	rollout renamerUI "Batch Renamer"
	(
	    label lbl_nameObjects "Please Write A Name:"
		edittext edt_rename ""
		button btn_generate "Generate"
		
		on btn_generate pressed do
		(
			if edt_rename.text != "" then
			(
				if selection.count > 0 then
				(
					for i in selection do
					(
						i.name = uniquename edt_rename.text
					)

					MessageBox "Renaming Complete." title:"Complete"
				)
				else
				(
					MessageBox "You have not selected any items to rename. Please make a selection before hitting Generate." title: "No Selection Found"
				)
			)
			else
			(
				MessageBox "You must enter a name to batch rename." title:"No name detected."
			)

		)
	)
	
	Createdialog renamerUI
)
	