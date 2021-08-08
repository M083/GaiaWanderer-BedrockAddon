@echo off
cd /d %~dp0
chcp 65001

if not exist %~dp0\resource_pack\* (
	echo このファイルと同じディレクトリにresource_packフォルダを作成してください
	pause
	exit
)
if not exist %~dp0\behavior_pack\* (
	echo このファイルと同じディレクトリにbehavior_packフォルダを作成してください
	pause
	exit
)
if not exist %~dp0\resource_pack\manifest.json (
	echo %~dp0\resource_packフォルダ内にmanifest.jsonが見つかりませんでした
	pause
	exit
)
if not exist %~dp0\behavior_pack\manifest.json (
	echo %~dp0\behavior_packフォルダ内にmanifest.jsonが見つかりませんでした
	pause
	exit
)
if exist %~dp0\behavior_pack\manifest_replaced.json (
	del %~dp0\behavior_pack\manifest_replaced.json
)
if exist %~dp0\resource_pack\manifest_replaced.json (
	del %~dp0\resource_pack\manifest_replaced.json
)

setlocal enabledelayedexpansion
for /f "delims=" %%a in (%~dp0\behavior_pack\manifest.json) do (
	set line=%%a
	set dev_check=!line:~-10,-9!
	if {!dev_check!} == {[} (
		set now_dev_num=!line:~-9,8!
	)
)
echo 現在のバージョンは%now_dev_num%です
goto :update_answer
endlocal
exit

:update_answer
set /P answer="バージョンを更新しますか？ (y/n)"

if /i {%answer%}=={y} (goto :yes)
if /i {%answer%}=={yes} (goto :yes)

exit /b 0

:yes
setlocal enabledelayedexpansion
set /P new_dev_num="バージョンを入力してください (X,XX,XXX)"
for /f "delims=" %%a in (%~dp0\behavior_pack\manifest.json) do (
	set line=%%a
	set line2=!line:%now_dev_num%=%new_dev_num%!
	echo !line2!>> %~dp0\behavior_pack\manifest_replaced.json
)
for /f "delims=" %%a in (%~dp0\resource_pack\manifest.json) do (
	set line=%%a
	set line2=!line:%now_dev_num%=%new_dev_num%!
	echo !line2!>> %~dp0\resource_pack\manifest_replaced.json
)
endlocal

del %~dp0\behavior_pack\manifest.json
ren %~dp0\behavior_pack\manifest_replaced.json manifest.json
del %~dp0\resource_pack\manifest.json
ren %~dp0\resource_pack\manifest_replaced.json manifest.json

echo 更新が完了しました