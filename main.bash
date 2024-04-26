#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Необходимо указать две директории"
  exit 1
fi
src_dir="$1"
dst_dir="$2"
if [ ! -d "$src_dir" ]; then
  echo "Исходная директория не существует"
  exit 1
fi
if [ ! -d "$dst_dir" ]; then
  mkdir -p "$dst_dir"
fi
function copy_files {
  local src_dir="$1"
  local dst_dir="$2"
  local count=1
  for entry in "$src_dir"/*; do
    if [ -f "$entry" ]; then
      filename=$(basename "$entry")
      extension="${filename##*.}"
      filename="${filename%.*}"
      new_filename="${filename}"
      while [ -f "${dst_dir}/${new_filename}.${extension}" ]; do
        count=$((count + 1))
        new_filename="${filename}_${count}"
      done
      cp "$entry" "${dst_dir}/${new_filename}.${extension}"
    elif [ -d "$entry" ]; then
      copy_files "$entry" "$dst_dir"
    fi
  done
}
copy_files "$src_dir" "$dst_dir"
echo "Копирование файлов из '$src_dir' в '$dst_dir' завершено."
