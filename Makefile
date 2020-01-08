TARBALL=nethack4-4.3-beta2.tar.gz
URL=http://nethack4.org/media/releases/$(TARBALL)

default: docker

$(TARBALL):
	wget $(URL)

docker: $(TARBALL)
	docker build --build-arg NETHACK_TAR=$(TARBALL) -t nethack4 .

clean:
	rm -f $(TARBALL)
