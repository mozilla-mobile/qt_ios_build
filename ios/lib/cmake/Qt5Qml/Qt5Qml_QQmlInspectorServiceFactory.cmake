
add_library(Qt5::QQmlInspectorServiceFactory MODULE IMPORTED)

set(_Qt5QQmlInspectorServiceFactory_MODULE_DEPENDENCIES "Quick;Qml;PacketProtocol;Gui;Gui;Core;Core")

foreach(_module_dep ${_Qt5QQmlInspectorServiceFactory_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Qml_FIND_VERSION_EXACT}
            ${_Qt5Qml_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Qml_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Qml_process_prl_file(
    "${_qt5Qml_install_prefix}/plugins/qmltooling/libqmldbg_inspector.prl" RELEASE
    _Qt5QQmlInspectorServiceFactory_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QQmlInspectorServiceFactory_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Qml_process_prl_file(
    "${_qt5Qml_install_prefix}/plugins/qmltooling/libqmldbg_inspector_debug.prl" DEBUG
    _Qt5QQmlInspectorServiceFactory_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QQmlInspectorServiceFactory_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QQmlInspectorServiceFactory PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Qml_QQmlInspectorServiceFactory_Import.cpp"
)

_populate_Qml_plugin_properties(QQmlInspectorServiceFactory RELEASE "qmltooling/libqmldbg_inspector.a" TRUE)
_populate_Qml_plugin_properties(QQmlInspectorServiceFactory DEBUG "qmltooling/libqmldbg_inspector_debug.a" TRUE)

list(APPEND Qt5Qml_PLUGINS Qt5::QQmlInspectorServiceFactory)
set_property(TARGET Qt5::Qml APPEND PROPERTY QT_ALL_PLUGINS_qmltooling Qt5::QQmlInspectorServiceFactory)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_qmltooling>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_qmltooling>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QQmlInspectorServiceFactory,${_manual_plugins_genex};${_plugin_type_genex}>"
)
set(_user_specified_genex_versionless
    "$<IN_LIST:Qt::QQmlInspectorServiceFactory,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QQmlInspectorServiceFactory,QT_PLUGIN_EXTENDS>,Qt::Qml>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QQmlInspectorServiceFactory,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QQmlInspectorServiceFactory,${_no_plugins_genex}>>,"
            "$<NOT:$<IN_LIST:Qt::QQmlInspectorServiceFactory,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QQmlInspectorServiceFactory>"
)
set_property(TARGET Qt5::Qml APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QQmlInspectorServiceFactory APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Quick;Qt5::Qml;Qt5::PacketProtocol;Qt5::Gui;Qt5::Gui;Qt5::Core;Qt5::Core"
)
set_property(TARGET Qt5::QQmlInspectorServiceFactory PROPERTY QT_PLUGIN_TYPE "qmltooling")
set_property(TARGET Qt5::QQmlInspectorServiceFactory PROPERTY QT_PLUGIN_EXTENDS "")
set_property(TARGET Qt5::QQmlInspectorServiceFactory PROPERTY QT_PLUGIN_CLASS_NAME "QQmlInspectorServiceFactory")
