
add_library(Qt5::QTextToSpeechPluginIos MODULE IMPORTED)

set(_Qt5QTextToSpeechPluginIos_MODULE_DEPENDENCIES "Gui;Core")

foreach(_module_dep ${_Qt5QTextToSpeechPluginIos_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5TextToSpeech_FIND_VERSION_EXACT}
            ${_Qt5TextToSpeech_DEPENDENCIES_FIND_QUIET}
            ${_Qt5TextToSpeech_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_TextToSpeech_process_prl_file(
    "${_qt5TextToSpeech_install_prefix}/plugins/texttospeech/libqtexttospeech_speechios.prl" RELEASE
    _Qt5QTextToSpeechPluginIos_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QTextToSpeechPluginIos_STATIC_RELEASE_LINK_FLAGS
)

_qt5_TextToSpeech_process_prl_file(
    "${_qt5TextToSpeech_install_prefix}/plugins/texttospeech/libqtexttospeech_speechios_debug.prl" DEBUG
    _Qt5QTextToSpeechPluginIos_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QTextToSpeechPluginIos_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QTextToSpeechPluginIos PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5TextToSpeech_QTextToSpeechPluginIos_Import.cpp"
)

_populate_TextToSpeech_plugin_properties(QTextToSpeechPluginIos RELEASE "texttospeech/libqtexttospeech_speechios.a" TRUE)
_populate_TextToSpeech_plugin_properties(QTextToSpeechPluginIos DEBUG "texttospeech/libqtexttospeech_speechios_debug.a" TRUE)

list(APPEND Qt5TextToSpeech_PLUGINS Qt5::QTextToSpeechPluginIos)
set_property(TARGET Qt5::TextToSpeech APPEND PROPERTY QT_ALL_PLUGINS_texttospeech Qt5::QTextToSpeechPluginIos)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_texttospeech>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_texttospeech>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QTextToSpeechPluginIos,${_manual_plugins_genex};${_plugin_type_genex}>"
)
set(_user_specified_genex_versionless
    "$<IN_LIST:Qt::QTextToSpeechPluginIos,${_manual_plugins_genex};${_plugin_type_genex}>"
)
string(CONCAT _plugin_genex
    "$<$<OR:"
        # Add this plugin if it's in the list of manually specified plugins or in the list of
        # explicitly included plugin types.
        "${_user_specified_genex},"
        "${_user_specified_genex_versionless},"
        # Add this plugin if all of the following are true:
        # 1) the list of explicitly included plugin types is empty
        # 2) the QT_PLUGIN_EXTENDS property for the plugin is empty or equal to the current
        #    module name
        # 3) the user hasn't explicitly excluded the plugin.
        "$<AND:"
            "$<STREQUAL:${_plugin_type_genex},>,"
            "$<OR:"
                # FIXME: The value of CMAKE_MODULE_NAME seems to be wrong (e.g for Svg plugin
                # it should be Qt::Svg instead of Qt::Gui).
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QTextToSpeechPluginIos,QT_PLUGIN_EXTENDS>,Qt::TextToSpeech>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QTextToSpeechPluginIos,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QTextToSpeechPluginIos,${_no_plugins_genex}>>,"
            "$<NOT:$<IN_LIST:Qt::QTextToSpeechPluginIos,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QTextToSpeechPluginIos>"
)
set_property(TARGET Qt5::TextToSpeech APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QTextToSpeechPluginIos APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Gui;Qt5::Core"
)
set_property(TARGET Qt5::QTextToSpeechPluginIos PROPERTY QT_PLUGIN_TYPE "texttospeech")
set_property(TARGET Qt5::QTextToSpeechPluginIos PROPERTY QT_PLUGIN_EXTENDS "")
set_property(TARGET Qt5::QTextToSpeechPluginIos PROPERTY QT_PLUGIN_CLASS_NAME "QTextToSpeechPluginIos")