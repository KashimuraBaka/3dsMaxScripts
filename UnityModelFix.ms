function f str child:false = (
	-- return (getNodeByName str)
	return execute("$'" + str + "'" + (if child then ("...*") else ("")))
)

function HandleLoliModel objectName =
(
	local whiteList = #($PS_EyeLight, $PS_Floor, $PS_R, $PS_L)
	for obj in $'PS_*' do
	(
		if not isValidNode obj then exit
		local childrens = #()
		for whiteObject in whiteList do
		(
			childrens += GetAllChildren whiteObject
		)
		if (findItem childrens obj) == 0 then
		(
			delete (GetAllChildren obj)
		)
	)
	delete $'AttackRange*'/...*
	delete $'Pos_*'/...*
	delete $'Light_*'/...*
	delete $'*Collision*'/...*
	delete $'EffPoint*'/...*
	delete $'XBone*'/...*
	delete $'*(1)'/...*
	
	if $'PS_L' != undefined then (
		for child in $'PS_L'.Children do
		(
			if (findString child.Name "L_") == undefined then
			(
				child.Name = "L_" + child.Name
			)
		)
	)
	
	if $'PS_L' != undefined then (
		for child in $'PS_L'.Children do
		(
			if (findString child.Name "R_") == undefined then
			(
				child.Name = "R_" + child.Name
			)
		)
	)
	
	local targetObject = f objectName
	targetObject.Parent = undeinfed
	targetObject.Position = [0, 0, 0]
	targetObject.Scale = [25.0, 25.0, 25.0]
	targetObject.Rotation = (eulerAngles 270 0 0)
	delete $SEM/...*
)

function GetChildren children accumArray =
(
	-- 遍历当前节点的子对象
	for child in children.children do
	(
		append accumArray child
		GetChildren child accumArray
	)
)
	
function GetAllChildren node =
(
	if (isValidNode node) then
	(
		local childrens = #(node)
		GetChildren node childrens
		return childrens
	)
	return #()
)

function FindParentObject node targetObject =
(
	local parentObject = node.Parent
	if parentObject != undefined then
	(
		if parentObject != targetObject then
		(
			return (FindParentObject parentObject targetObject)
		)
	)
	return undefined
)

function ImportFBXAnimation fileName objectName anmationName index =
(
	delete objects
	
	FbxImporterSetParam "ResetImport"
	FBXImporterSetParam "TakeIndex" index
	importFile fileName #noPrompt using:FBXIMP
	
	-- HandleErrorObject()
	HandleLoliModel(objectName)
	
	maxKeyFrameCount = 1

	-- 遍历每一个Dummy对象
	for dum in (for obj in objects where classOf obj == Dummy collect obj) do
	(
		-- 初始化起始帧和结束帧
		startFrame = 999999
		endFrame = -999999
		controllers = #(dum.position.controller, dum.rotation.controller, dum.scale.controller)
		
		-- 遍历每个控制器
		for ctrl in controllers do (
			if ctrl != undefined and ctrl.keys.count > 0 then (
				-- 获取每个控制器的起始帧和结束帧
				for k = 1 to ctrl.keys.count do (
					key = ctrl.keys[k]
					if key.time < startFrame then startFrame = key.time
					if key.time > endFrame then endFrame = key.time
				)
			)
		)
		-- 如果找到有效的起始帧，将其调整为 0
		if startFrame == 999999 then startFrame = 0
		if endFrame == -999999 then endFrame = 0
		
		animationLength = endFrame - startFrame
		
		if animationLength > maxKeyFrameCount then (
			maxKeyFrameCount = animationLength
		)
	)

	-- 应用时间轴范围
	animationRange = interval 0 maxKeyFrameCount
	
	-- 相对路径
	local smdPath = (getFilenamePath fileName) + "anims\\"
	-- 文件夹是否存在, 不存在则进行创建
	if not doesfileexist smdPath then makeDir smdPath
	ExportFile (smdPath + anmationName + ".smd") #noPrompt
)

function main = (
	local fileName = "G:\CS2\Boss_Level03_v2\Boss_Level03_v2.fbx"
	local objectName = "BoneRoot_BossLevel03"
	local animations = #(
		"001Battle",
		"101Battle_Charge",
		"002_03WalkR",
		"102_03WalkR_Charge",
		"002Walk",
		"102Walk_Charge",
		"002_02WalkL",
		"102_02WalkL_Charge",
		"022AttackRun",
		"021AttackRunStart",
		"007DamagedFont",
		"008DamagedLeft",
		"009DamagedRight",
		"010AttackCombo01",
		"011AttackCombo02",
		"012AttackCombo03",
		"013AttackCombo04",
		"014AttackHammer",
		"015AttackAssault",
		"016AttackSprint",
		"017AttackComboB01",
		"018AttackComboB02",
		"019AttackComboB03",
		"020AttackSprintB",
		"023AttackRunEnd",
		"003TurnLeft",
		"103TurnLeft_Charge",
		"004TurnRight",
		"104TurnRight_Charge",
		"005SprintForward",
		"105SprintForward_Charge",
		"006SprintBack",
		"106SprintBack_Charge",
		"024Death",
		"025Death_Loop",
		"201PlayDoll",
		"202LookBack",
		"203LookBack_Loop",
		"204StandUp",
		"205StandUp_Loop",
		"206BearSwitch",
		"207BearSwitch_Loop",
		"208BearSwitch02",
		"209LookPlayer",
		"210ScriptDeath",
		"211AbsorbSoul",
		"212AbsorbSoulLoop",
		"213AbsorbSoulComplete",
		"001_Idle",
		"214Fall",
		"215FallLoop",
		"012.5AttackCombo03_v2",
		"107ChargeComplete"
	)
	local animationCount = FBXImporterGetParam "TakeCount" fileName
	if animations.count == animationCount then (
		for i = 1 to animations.count do (
			ImportFBXAnimation fileName objectName animations[i] i
		)
	)
)

-- main()
HandleLoliModel("Boss_Level03_v2")