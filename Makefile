
#  Part of rvglue/ase2rv source code,
#  Copyright (C) 2000 Alexander Kroeller (alilein@gmx.de)
#  Copyright (C) 2001 Gabor Varga (bootes@freemail.hu)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


#### DEBUG / RELEASE BUILD ####################################################

# Set this to a non-empty value to make a debug build (-g3, unstripped).
# Do 'make clean; make' if you change this.
DEBUG_BUILD =

#### DIRECTORIES ##############################################################

OBJECTSDIR      = .
LIBDIR          = lib
APPDIR          = app
ASE2RVDIR       = ase2rv
MKMIRROR_DIR    = mirror


#### TARGETS ##################################################################

LIB             = rvgluelib
APP             = $(OBJECTSDIR)/rvglue
ASE2PRM_APP     = $(OBJECTSDIR)/ase2prm
ASE2W_APP       = $(OBJECTSDIR)/ase2w
ASE2TAZ_APP     = $(OBJECTSDIR)/ase2taz
ASE2VIS_APP     = $(OBJECTSDIR)/ase2vis
MKMIRROR_APP    = $(OBJECTSDIR)/mkmirror


#### VERSION ##################################################################

VERSION         = beta7


#### OPTIONS ##################################################################

CC              = g++
AR              = ar
RANLIB          = ranlib

ifdef DEBUG_BUILD
DEBUG_CCOPT     = -g3
STRIP           = true
else
DEBUG_CCOPT     = -O3
STRIP           = strip
endif
CCOPT           = -Wall -DAPPVERSION=\"$(VERSION)\"  -fpermissive \
                  -D_GLUE_USE_WIN_DIRS -D_USE_VTCODES $(DEBUG_CCOPT)


#-DUSE_DMALLOC
#L_DMALLOC=-ldmalloc
EXECUTABLE_EXT  = .exe

#### SOURCES ##################################################################

LIBFILES        = axisbox box collapsedmesh helpfunc lookup matrix3 mesh \
                  ncpwriter polygon polymod print prmwriter rvcolor surface \
			vector vertex world wwriter

APPFILES        = appopts colormod errdesc findfile finf fixbridge fixpipe \
                  input legomod main modlist optkeep parsedcolor parsedmod \
                  parser readprm simplemods tazmod texdef texfloor texmap \
                  texwall wf wmodlist

ASE2RVFILES     = appopts asefacevlist asekeys asematerial asemesh aseparser \
                  aseprint asevlist namelist

ASE2PRM_MAIN    = ase2prm
ASE2W_MAIN      = ase2w
ASE2TAZ_MAIN    = ase2taz
ASE2VIS_MAIN    = ase2vis

MKMIRROR_FILES  = mkmirror


#### OBJECTS ##################################################################

LIBOBJECTS      = $(LIBFILES:%=$(OBJECTSDIR)/$(LIBDIR)/%.o)
LIBFILE         = $(OBJECTSDIR)/lib$(LIB).a

APPOBJECTS      = $(APPFILES:%=$(OBJECTSDIR)/$(APPDIR)/%.o)

ASE2PRMOBJECTS  = $(ASE2RVFILES:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o) \
                  $(ASE2PRM_MAIN:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o)

ASE2WOBJECTS    = $(ASE2RVFILES:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o) \
                  $(ASE2W_MAIN:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o)

ASE2TAZOBJECTS  = $(ASE2RVFILES:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o) \
                  $(ASE2TAZ_MAIN:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o)

ASE2VISOBJECTS  = $(ASE2RVFILES:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o) \
                  $(ASE2VIS_MAIN:%=$(OBJECTSDIR)/$(ASE2RVDIR)/%.o)

MKMIRROROBJECTS = $(MKMIRROR_FILES:%=$(OBJECTSDIR)/$(MKMIRROR_DIR)/%.o)


#### RULES ####################################################################

all: app ase mirror

run: $(APP)
	./$(APP)

dox:
	doxygen

STOREDIR = /net/store/glue.store
store:
	@echo Making store...
	@rm -Rf $(STOREDIR)
	@mkdir $(STOREDIR)
	@cp Makefile $(STOREDIR)
	@echo " -------- lib --------"
	@mkdir $(STOREDIR)/$(LIBDIR)
	@cp $(LIBDIR)/*.cpp $(STOREDIR)/$(LIBDIR)
	@cp $(LIBDIR)/*.h $(STOREDIR)/$(LIBDIR)
	@echo " -------- app --------"
	@mkdir $(STOREDIR)/$(APPDIR)
	@cp $(APPDIR)/*.cpp $(STOREDIR)/$(APPDIR)
	@cp $(APPDIR)/*.h $(STOREDIR)/$(APPDIR)
	@echo " -------- ase --------"
	@mkdir $(STOREDIR)/$(ASE2RVDIR)
	@cp $(ASE2RVFILES:%=$(ASE2RVDIR)/%.cpp) $(STOREDIR)/$(ASE2RVDIR)
	@cp $(ASE2RVFILES:%=$(ASE2RVDIR)/%.h) $(STOREDIR)/$(ASE2RVDIR)
	@cp $(ASE2PRM_MAIN:%=$(ASE2RVDIR)/%.cpp) $(STOREDIR)/$(ASE2RVDIR)
	@cp $(ASE2W_MAIN:%=$(ASE2RVDIR)/%.cpp) $(STOREDIR)/$(ASE2RVDIR)
	@cp $(ASE2TAZ_MAIN:%=$(ASE2RVDIR)/%.cpp) $(STOREDIR)/$(ASE2RVDIR)
	@cp $(ASE2VIS_MAIN:%=$(ASE2RVDIR)/%.cpp) $(STOREDIR)/$(ASE2RVDIR)
	@echo " ------ mkmirror -----"
	@mkdir $(STOREDIR)/$(MKMIRROR_DIR)
	@cp $(MKMIRROR_FILES:%=$(MKMIRROR_DIR)/%.cpp) \
                                                    $(STOREDIR)/$(MKMIRROR_DIR)
	@cp $(MKMIRROR_DIR)/*.h $(STOREDIR)/$(MKMIRROR_DIR)
	@chmod -R a+rwX $(STOREDIR)

newver:
	@rm `grep 'APPVERSION' \
            $(APPFILES:%=$(APPDIR)/%.cpp) \
            $(LIBFILES:%=$(LIBDIR)/%.cpp) \
         | sed -e 's/:.*//g' -e 's/\.cpp/.o/g'`

feel:
	@cat $(APPDIR)/*.h $(LIBDIR)/*.h $(APPFILES:%=$(APPDIR)/%.cpp) \
            $(LIBFILES:%=$(LIBDIR)/%.cpp) | wc -l


#### RULES FOR LIB ############################################################

lib: $(LIBFILE)

$(LIBFILE): $(LIBOBJECTS)
	@echo "    ar [33m[1m$@[0m"
	@$(AR) cr $@ $(LIBOBJECTS)
	@echo "    ranlib [33m[1m$@[0m"
	@$(RANLIB) $@


#### RULES FOR APP ############################################################

app/errlist.h: app/errlist.src app/errdesc.h
	./create_elist.sh

app: $(APP)

$(APP): $(LIBFILE) $(APPOBJECTS)
	@echo "    link [33m[1m$@[0m"
	@$(CC) -Wall $(APPOBJECTS) -o $@ \
          -lm -L$(OBJECTSDIR) -l$(LIB) $(L_DMALLOC)
	@$(STRIP) $@$(EXECUTABLE_EXT)


#### RULES FOR ASE2RV #########################################################

ase: $(ASE2PRM_APP) $(ASE2W_APP) $(ASE2TAZ_APP) $(ASE2VIS_APP)

$(ASE2PRM_APP): $(LIBFILE) $(ASE2PRMOBJECTS)
	@echo "    link [33m[1m$@[0m"
	@$(CC) -Wall $(ASE2PRMOBJECTS) -o $@ \
          -lm -L$(OBJECTSDIR) -l$(LIB) $(L_DMALLOC)
	@$(STRIP) $@$(EXECUTABLE_EXT)

$(ASE2W_APP): $(LIBFILE) $(ASE2WOBJECTS)
	@echo "    link [33m[1m$@[0m"
	@$(CC) -Wall $(ASE2WOBJECTS) -o $@ \
          -lm -L$(OBJECTSDIR) -l$(LIB) $(L_DMALLOC)
	@$(STRIP) $@$(EXECUTABLE_EXT)

$(ASE2TAZ_APP): $(LIBFILE) $(ASE2TAZOBJECTS)
	@echo "    link [33m[1m$@[0m"
	@$(CC) -Wall $(ASE2TAZOBJECTS) -o $@ \
          -lm -L$(OBJECTSDIR) -l$(LIB) $(L_DMALLOC)
	@$(STRIP) $@$(EXECUTABLE_EXT)

$(ASE2VIS_APP): $(LIBFILE) $(ASE2VISOBJECTS)
	@echo "    link [33m[1m$@[0m"
	@$(CC) -Wall $(ASE2VISOBJECTS) -o $@ \
          -lm -L$(OBJECTSDIR) -l$(LIB) $(L_DMALLOC)
	@$(STRIP) $@$(EXECUTABLE_EXT)

asepanics:
	@echo "Number of sxpanic()-calls in ase2rv:"
	@grep sxpanic $(ASE2RVFILES:%=$(ASE2RVDIR)/%.cpp) | wc -l


#### RULES FOR MKMIRROR #######################################################

mirror: $(MKMIRROR_APP)

$(MKMIRROR_APP): $(LIBFILE) $(MKMIRROROBJECTS)
	@echo "    link [33m[1m$@[0m"
	@$(CC) -Wall $(MKMIRROROBJECTS) -o $@ -L$(OBJECTSDIR) -l$(LIB) -lm
	@$(STRIP) $@$(EXECUTABLE_EXT)


#### COMPILATION RULES ########################################################

clean:
	@rm -f $(LIBOBJECTS) $(LIBFILE) \
		$(APPOBJECTS) $(APP) \
		$(ASE2PRMOBJECTS) $(ASE2PRM) \
		$(ASE2WOBJECTS) $(ASE2W) \
		$(ASE2TAZOBJECTS) $(ASE2TAZ) \
		$(ASE2VISOBJECTS) $(ASE2VIS) \
		$(MKMIRROROBJECTS) $(MKMIRROR_APP)

$(OBJECTSDIR)/%.o: %.cpp
	@echo "    compile [33m[1m$<[0m"
	@$(CC) $(CCOPT) -I$(LIBDIR) $(DEFINES) -c $< -o $@

depend:
	makedepend -Y. -p$(OBJECTSDIR) -I$(LIBDIR) \
		$(LIBOBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		$(APPOBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		$(ASE2PRMOBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		$(ASE2WOBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		$(ASE2TAZOBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		$(ASE2VISOBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		$(MKMIRROROBJECTS:$(OBJECTSDIR)/%.o=%.cpp) \
		2> /dev/null


#### DEPENDENCIES #############################################################

include lib.dep app.dep ase2rv.dep mirror.dep
