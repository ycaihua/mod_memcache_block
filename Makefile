CC=gcc
# -Os removed from next line
CFLAGS="-I /usr/local/include/libmemcached -arch x86_64 -pipe -no-cpp-precomp -g"
APXS_LDFLAGS='-Wl,-arch x86_64 -L/usr/local/lib/libmemcached -lmemcached'

# MACOSX_DEPLOYMENT_TARGET=10.5
# CFLAGS=”-arch x86_64 -g -Os -pipe -no-cpp-precomp”
# CCFLAGS=”-arch x86_64 -g -Os -pipe”
# CXXFLAGS=”-arch x86_64 -g -Os -pipe”
# LDFLAGS=”-arch x86_64 -bind_at_load”
# export CFLAGS CXXFLAGS LDFLAGS CCFLAGS MACOSX_DEPLOYMENT_TARGET

HTTPDROOT=/twitter/httpd

# if mac:
all: mod_memcache_block.slo Makefile

# disgusting hack here to force x86_64, I can't figure out how to make apxs do this.

mod_memcache_block.slo  : mod_memcache_block.c
	${HTTPDROOT}/bin/apxs  ${CFLAGS} ${APXS_LDFLAGS}  ${LDFLAGS} -c mod_memcache_block.c
#	/usr/share/apr-1/build-1/libtool --silent --mode=link gcc  -o mod_memcache_block.la  -rpath /twitter/httpd/modules -module -avoid-version    mod_memcache_block.lo -arch x86_64


clean:
	rm *.slo *.la *.lo *.o .libs/*

install: mod_memcache_block.slo
	${HTTPDROOT}/bin/apxs  ${CFLAGS} ${APXS_LDFLAGS} ${LDFLAGS} -a -i -c mod_memcache_block.c 

installtest: install
	${HTTPDROOT}/bin/apachectl stop
	${HTTPDROOT}/bin/apachectl start
	tail -f ${HTTPDROOT}/logs/error_log