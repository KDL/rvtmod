/*
 *  Part of ase2rv source code,
 *  Copyright (C) 2014 Ahmed Yahia Kallel (kallelay@gmail.com)
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <string>
#include "str.h"
#include <stdlib.h>

char* strtolower(char* str)
{
	int i=0;
	char *nstr = (char*)malloc(200);
	for(i=0;;i++)
	{
		if(*(str+i)>='A' && (*(str+i)<='Z')) {*(nstr+i)=*(str+i)+'a'-'A';} else {*(nstr+i)=*(str+i);}

		if (i>199 || *(str+i)=='\0') break;
	}
	*(nstr+ i) = '\0';
	return nstr;
}
char* strtolower(const char* str)
{
	int i=0;
	char *nstr = (char*)malloc(200);
	for(i=0;;i++)
	{
		if(*(str+i)>='A' && (*(str+i)<='Z')) {*(nstr+i)=*(str+i)+'a'-'A';} else {*(nstr+i)=*(str+i);}

		if (i>199 || *(str+i)=='\0') break;
	}
	*(nstr+ i) = '\0';
	return nstr;
}

