# shellcheck disable=SC2215

function md2docx () {
	cd "$(dirname "$*")" || return
	INPUT_FILE="$(basename "$*")"
	OUTPUT_FILE="${INPUT_FILE%.*}_CG.docx"

	pandoc \
		"$INPUT_FILE" \
		--output="$OUTPUT_FILE" \
		--defaults=Paper-Word \
		--metadata=date:"$(date "+%d. %B %Y")" \
	&& open -R "$OUTPUT_FILE" \
	&& open "$OUTPUT_FILE"
}

function docx2md () {
	cd "$(dirname "$*")" || return
	INPUT_FILE="$(basename "$*")"
	OUTPUT_FILE="${INPUT_FILE%.*}_imported.md"

	pandoc \
		"$INPUT_FILE" \
		--output="$OUTPUT_FILE" \
		--defaults=docx2md

	mv ./attachments/media/* ./attachments/
	rmdir ./attachments/media/
	sed -i '' 's/\/media\//\//g' "$OUTPUT_FILE"
	sed -i '' 's/„/"/' "$OUTPUT_FILE"

	open -R "$OUTPUT_FILE"
}


