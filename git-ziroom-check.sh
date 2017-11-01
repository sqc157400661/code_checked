#!/bin/bash
# @author 史庆闯
# @time 2017-10-25 20:49:43
# 规范代码 本次只有检测要提交代码中是否存在调试代码    ！！后期可以加上代码语法和质量等检测！！！
# 适用于 win mac linux
# 本次版本 v0.0.1 测试版

#echo -e '-------正在更新 GIT  检测钩子-------\n'
cat > pre-push <<'CHECKRELEASE'
#!/bin/bash
version=v0.0.1
check_content='var_dump|die|exit'
now_branch=`git symbolic-ref --short -q HEAD`
var=`git diff --name-only $now_branch  origin/$now_branch`
re=`grep -E "$check_content" $var`
echo -e "----------正在检查提交，当前钩子版本：$version----------\n"
if [ "$re" =  "" ]
	then
		echo  -e "\n-----你的代码检测通过，真是一段优雅的代码啊-----\n"
	else
		echo  -e "\n-----你的代码没有检测通过，真是糟糕啊-----\n"
		exit 1
fi
a=`git var GIT_AUTHOR_IDENT`
a=${a% *}
h=$(cat $1 | head -n 1)
t=$(cat $1 | tail -n +3)
echo -e "$h\n\n${t%%signgit*}\nsigngit:$(date '+%F %T') $h ${a% *} $version" > "$1"
exit 0
CHECKRELEASE
cat > commit-msg <<'CHECKRELEASE2'
#!/bin/bash
version=v0.0.1
check_content='var_dump|die|exit'
var=`git status -s | awk  '{print $2}'`
re=`grep -E "$check_content" $var`
echo -e "----------正在检查提交，当前钩子版本：$version----------\n"
if [ "$re" =  "" ]
	then
		echo  -e "\n-----你的代码检测通过，真是一段优雅的代码啊-----\n"
	else
		echo -e "\033[33m 提交警告！！！ \033[0m"
		echo  -e "\n-----你的代码没有检测通过，真是糟糕啊-----\n"
		# exit 1
fi
a=`git var GIT_AUTHOR_IDENT`
a=${a% *}
h=$(cat $1 | head -n 1)
t=$(cat $1 | tail -n +3)
echo -e "$h\n\n${t%%signgit*}\nsigngit:$(date '+%F %T') $h ${a% *} $version" > "$1"
exit 0
CHECKRELEASE2
mv pre-push .git/hooks/
chmod 777 .git/hooks/pre-push
mv commit-msg .git/hooks/
chmod 777 .git/hooks/commit-msg
#read -p "操作成功，按回车键结束"
rm -f $0