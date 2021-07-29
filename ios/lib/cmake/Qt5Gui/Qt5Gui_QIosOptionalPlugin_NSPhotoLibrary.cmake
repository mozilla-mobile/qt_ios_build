
add_library(Qt5::QIosOptionalPlugin_NSPhotoLibrary MODULE IMPORTED)

set(_Qt5QIosOptionalPlugin_NSPhotoLibrary_MODULE_DEPENDENCIES "Gui;Gui;Core")

foreach(_module_dep ${_Qt5QIosOptionalPlugin_NSPhotoLibrary_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Gui_FIND_VERSION_EXACT}
            ${_Qt5Gui_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Gui_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Gui_process_prl_file(
    "${_qt5Gui_install_prefix}/plugins/platforms/darwin/libqiosnsphotolibrarysupport.prl" RELEASE
    _Qt5QIosOptionalPlugin_NSPhotoLibrary_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QIosOptionalPlugin_NSPhotoLibrary_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Gui_process_prl_file(
    "${_qt5Gui_install_prefix}/plugins/platforms/darwin/libqiosnsphotolibrarysupport_debug.prl" DEBUG
    _Qt5QIosOptionalPlugin_NSPhotoLibrary_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QIosOptionalPlugin_NSPhotoLibrary_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QIosOptionalPlugin_NSPhotoLibrary PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Gui_QIosOptionalPlugin_NSPhotoLibrary_Import.cpp"
)

_populate_Gui_plugin_properties(QIosOptionalPlugin_NSPhotoLibrary RELEASE "platforms/darwin/libqiosnsphotolibrarysupport.a" TRUE)
_populate_Gui_plugin_properties(QIosOptionalPlugin_NSPhotoLibrary DEBUG "platforms/darwin/libqiosnsphotolibrarysupport_debug.a" TRUE)

list(APPEND Qt5Gui_PLUGINS Qt5::QIosOptionalPlugin_NSPhotoLibrary)
set_property(TARGET Qt5::Gui APPEND PROPERTY QT_ALL_PLUGINS_platforms_darwin Qt5::QIosOptionalPlugin_NSPhotoLibrary)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_platforms_darwin>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_platforms_darwin>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QIosOptionalPlugin_NSPhotoLibrary,${_manual_plugins_genex};${_plugin_type_genex}>"
)
set(_user_specified_genex_versionless
    "$<IN_LIST:Qt::QIosOptionalPlugin_NSPhotoLibrary,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QIosOptionalPlugin_NSPhotoLibrary,QT_PLUGIN_EXTENDS>,Qt::Gui>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QIosOptionalPlugin_NSPhotoLibrary,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QIosOptionalPlugin_NSPhotoLibrary,${_no_plugins_genex}>>,"
            "$<NOT:$<IN_LIST:Qt::QIosOptionalPlugin_NSPhotoLibrary,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QIosOptionalPlugin_NSPhotoLibrary>"
)
set_property(TARGET Qt5::Gui APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QIosOptionalPlugin_NSPhotoLibrary APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Gui;Qt5::Gui;Qt5::Core"
)
set_property(TARGET Qt5::QIosOptionalPlugin_NSPhotoLibrary PROPERTY QT_PLUGIN_TYPE "platforms/darwin")
set_property(TARGET Qt5::QIosOptionalPlugin_NSPhotoLibrary PROPERTY QT_PLUGIN_EXTENDS "-")
set_property(TARGET Qt5::QIosOptionalPlugin_NSPhotoLibrary PROPERTY QT_PLUGIN_CLASS_NAME "QIosOptionalPlugin_NSPhotoLibrary")