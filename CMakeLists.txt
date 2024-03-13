# Copyright (c) the Dviglo project
# License: MIT

# Указываем минимальную версию CMake
cmake_minimum_required(VERSION 3.16)

# Название проекта
project(big_int)

# Название таргета
set(target_name tester)

# Версия стандарта C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Если используется одноконфигурационный генератор и конфигурация не указана
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    # то конфигурацией по умолчанию будет Release
    set(CMAKE_BUILD_TYPE Release)
    # Нельзя оставлять переменную CMAKE_BUILD_TYPE пустой (подробности в Dviglo2D)
endif()

# Указываем Студии на то, что исходники в кодировке UTF-8.
# Это позволяет писать U'🍌'. У других компиляторов, похоже, нет с этим проблем
# https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p2295r6.pdf
if(MSVC)
    add_compile_options(/utf-8)
endif()

# Выводим больше предупреждений
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
    
    if(NOT MINGW)
        add_compile_options(-fsanitize=undefined)
        add_link_options(-fsanitize=undefined)
    endif()
endif()

# Создаём список файлов
file(GLOB source_files *.cpp *.hpp)

# Создаём приложение
add_executable(${target_name} ${source_files})

# Отладочная версия приложения будет иметь суффикс _d
set_property(TARGET ${target_name} PROPERTY DEBUG_POSTFIX _d)

# Заставляем VS отображать дерево каталогов
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${source_files})

# Включаем поддержку папок в IDE
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Включаем тестирование
enable_testing()

# Добавляем приложение в список тестируемых
add_test(NAME ${target_name} COMMAND ${target_name})

# В Visual Studio таргет будет назначен стартовым вместо ALL_BUILD,
# чтобы потом не делать это вручную при отладке приложения
set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${target_name})
