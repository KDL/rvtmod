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
#include "shade_sunsystem.h";

RVColor calculateShade(float degree) {

	RVColor tmp = RVColor(); 
	float sv; //grad?

	//sunshine at 7 AM, sunset starts at 7 PM
	/*let's assume that from 12 to 5 PM it's pretty white,
	* Then, 5 PM to 7 PM white -> violet -> yellow
	* 7 PM -> 7:30 PM: yellow -> orange
	* 7:30 PM -> 08:00 orange -> dark night
	any input after 8 PM is considered as night.
	*/
	
	/*degree = degree%180; //and not a prank...*/
	
	if (degree <= -30) {//plain night
		tmp.setRGB(20,23,40);
	} else if (degree >-30 && degree <= -15)
	{
		//linear from 20,23,40 to 152,160,181 
		sv=(float)(30 + degree)/15.0;
		tmp.setRGB(rvulong(20+132.0*sv),rvulong(23.0+137*sv),rvulong(40+141*sv));
		
	} else if (degree >-15 && degree <= 0)
	{
		//linear from 152,160,181 to 175,100,0
		sv=(float)(15+degree)/15.0;
		tmp.setRGB(rvulong(152+23.0*sv),rvulong(160-60*sv),rvulong(181-181.0*sv));
	} else if (degree>0 && degree <= 10)
	{
		//expo from 175,100,0 to 255,236,142
		sv=(float)(degree/10);
		tmp.setRGB(rvulong(175+80.0*sv),rvulong(100-136*sv),rvulong(0+142.0*sv));
	} else if (degree >10 && degree <= 15)
	{
		//linear from 255,236,142 to 192,153,190
		sv=(float)((degree-10)/5);
		tmp.setRGB(rvulong(255-63*sv),rvulong(236-83*sv),rvulong(142+48*sv));
	} else if(degree >15 && degree <= 20)
	{
		sv=(float)((degree-15)/5);
		//linear from 192,153,190 to 230,230,255
		tmp.setRGB(rvulong(192-38*sv),rvulong(153+77*sv),rvulong(190+65*sv));
	} else {
		//linear from  230,230,255 to 255,255,255
		sv=(float)((degree-20)/70);
		tmp.setRGB(rvulong(230+25*sv),rvulong(230+25*sv),255);
	}



		return tmp;

}