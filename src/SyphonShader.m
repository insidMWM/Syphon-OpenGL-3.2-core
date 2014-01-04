/*
 
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //      SyphonShader.m
    //		Copyright 2013 InsiD SAS, all rights reserved
    //
    //		Date        19/12/2013
    //		Developer   Romain Cheminade
    //		Contact     info@insidinc.com
    ///////////////////////////////////////////////////////////////////////////////////////////////
 
    Syphon
    Copyright 2010-2011 bangnoise (Tom Butterworth) & vade (Anton Marini).
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SyphonShader.h"
#import "SyphonOpenGLHeader.h"

#if !defined( SYPHON_OPENGL_VERSION_32 )
    #import <Cocoa/Cocoa.h>
#endif

const char * shader_2dtexrect_vertex_program =

	"#version 150  \n"
    "#extension GL_ARB_explicit_attrib_location : enable \n"
    
	"#define ATTR_POSITION	0  \n"
	"#define ATTR_TEXCOORD	4  \n"
	
	"uniform mat4 u_orthoMatrix;"
	
	"layout(location = ATTR_POSITION) in vec2 AttrPosition;"
	"layout(location = ATTR_TEXCOORD) in vec2 AttrTexcoord;"
	
	"out vec2 VertTexcoord;"
	
	"void main()"
	"{"	
		"VertTexcoord = AttrTexcoord;"
		"gl_Position = u_orthoMatrix * vec4(AttrPosition, 0.0, 1.0);"
	"}";


const char * shader_2dtexrect_fragment_program =

	"#version 150  \n"
    "#extension GL_ARB_explicit_attrib_location : enable \n"
	
	"uniform sampler2D u_diffuse;"
	
	"in vec2 VertTexcoord;"
	
	"layout(location = 0, index = 0) out vec4 FragColor;"

	"void main()"
	"{"
		"FragColor = texture( u_diffuse, VertTexcoord );"
	"}";


@implementation SyphonShader

//=================================================================================================
- (id)initShader: (BOOL)callInitGL
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    [super init];
    
    if( self && callInitGL ) {
        [self oglInit];
    }
    
    return self;
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonShader initShader)" );
    return (id)0;
    
#endif
}



//=================================================================================================
- (void)oglInit
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    // Vertex shader
    GLuint VertexShader = glCreateShader( GL_VERTEX_SHADER );
    glShaderSource( VertexShader, 1, &shader_2dtexrect_vertex_program, NULL );
    glCompileShader( VertexShader );
    
    // Fragment shader
    GLuint FragmentShader = glCreateShader( GL_FRAGMENT_SHADER );
    glShaderSource( FragmentShader, 1, &shader_2dtexrect_fragment_program, NULL );
    glCompileShader( FragmentShader );
    
    
    // Program
    program = glCreateProgram();
    
	glAttachShader( program, VertexShader );
	glAttachShader( program, FragmentShader );
    
	glDeleteShader( VertexShader );
	glDeleteShader( FragmentShader );
    
	glLinkProgram( program );
    
    
    // Uniform
    glUseProgram( program );
	
	uniformOrthoMatrix = glGetUniformLocation( program, "u_orthoMatrix" );
	uniformDiffuse = glGetUniformLocation( program, "u_diffuse" );
    
	// Invariant uniform, we need only 1 texture
	glUniform1i( uniformDiffuse, 0 );
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonShader oglInit)" );
    
#endif
}

//=================================================================================================
- (void)oglUninit
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    if( program ) {
		glDeleteProgram( program );
		program = 0;
	}
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonShader oglUninit)" );
    
#endif
}



//=================================================================================================
- (void)oglUseProgram: (SyphonCamera*)camera
{
#if defined( SYPHON_OPENGL_VERSION_32 )
    // Activate shader
	glUseProgram( program );
    // Send uniforms
	glUniformMatrix4fv( uniformOrthoMatrix, 1, GL_FALSE, [camera baseAddress] );
    
#else
    NSLog( @"Syphon target OpenGL version is 2.1 legacy, do not call this method (SyphonShader oglUninit)" );
    
#endif
}

@end
