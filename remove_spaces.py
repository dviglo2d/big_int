#!/usr/bin/env python3

# Удаляет пробелы в конце строк

import os


def get_newline(file_path):
    with open(file_path, 'rb') as file:
        content = file.read()

    if b'\r\n' in content:
        return '\r\n'
    else:
        return '\n'


def remove_trailing_spaces(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    # Сохраняем формат разделителя строк
    nel = get_newline(file_path)

    with open(file_path, 'w', encoding='utf-8', newline=nel) as file:
        for line in lines:
            file.write(line.rstrip() + '\n')


if __name__ == '__main__':
    repo_dir = os.path.dirname(os.path.realpath(__file__))
    exts = {'.bat', '.sh', '.md', '.hpp', '.cpp', '.txt', '.py', '.yml', '.editorconfig', '.gitattributes', '.gitignore'}

    for root, dirs, files in os.walk(repo_dir):
        # Игнорируемые папки
        if root == repo_dir:
            dirs.remove('.git')

        for file in files:
            if any(file.endswith(ext) for ext in exts):
                file_path = os.path.join(root, file)
                remove_trailing_spaces(file_path)
                print('Обработан файл: ' + file_path)
