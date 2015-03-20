CURDIR=$(dirname $(readlink -f $0))

echo $CURDIR

find $CURDIR -name "*.lua" | xargs sed -i -r 's#[ \t]+$##g'

find $CURDIR -name "*.sh" | xargs sed -i -r 's#[ \t]+$##g'

find $CURDIR -name "*.md" | xargs sed -i -r 's#[ \t]+$##g'

find $CURDIR -name "*.rst" | xargs sed -i -r 's#[ \t]+$##g'
