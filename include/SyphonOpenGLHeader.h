
// Comment this line to active OpenGL 2.1 legacy version
#define SYPHON_OPENGL_VERSION_32


#if defined( SYPHON_OPENGL_VERSION_32 )
    #include <OpenGL/gl.h>
    #define GL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
    #include <OpenGL/gl3.h>
    #include <OpenGL/glext.h>

#else
    #import <OpenGL/CGLMacro.h>

#endif
