all: compress

compress: mount.cifs.gz mount.cifs.xz mount.cifs.xz.b64 mount.cifs.gz.b64
	@true

mount.cifs:
	docker run --rm debian:sid bash -c 'apt-get -qq update >&2 && apt-get -d -o=dir::cache=/tmp -y --print-uris -qq install cifs-utils | grep /cifs-utils_ | cut -f1 -d" "' \
	| docker run --rm --interactive -i alpine sh -c 'url=$$(cat); url=$$(eval echo "$$url"); apk add -q --update wget ca-certificates binutils >&2; wget -q $$url >&2; ar x $$(basename $$url) >&2; tar xf data.tar.* >&2; cat $$(tar tf data.tar.* | grep /$@$$)' \
	> $@
	chmod a+x $@

mount.cifs.gz: mount.cifs
	gzip -9kc $^ > $@

mount.cifs.gz.b64: mount.cifs.gz
	base64 -b0 $^ > $@

mount.cifs.xz: mount.cifs
	xz -9ekc $^ > $@

mount.cifs.xz.b64: mount.cifs.xz
	base64 -b0 $^ > $@