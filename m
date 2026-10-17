Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46C4CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808C26B0088; Sat, 17 Oct 2026 11:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BAB96B008A; Sat, 17 Oct 2026 11:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFE56B008C; Sat, 17 Oct 2026 11:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 452816B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:41:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D296A40294
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:41:30 +0000 (UTC)
X-FDA: 85332532740.27.6F20320
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 467E0180006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:41:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792251689;
	b=zrFj8yNsAkXSnMM9hjegqv2ot5+h5W18J344inv/iLDF7IX/PFpuNZAo54UxZjMckWCNqe
	WdqObkFcAxAPR0rrOlikrMzX2TlI0O6BSzdCAQ3yhruYK2eK25Tqm/DL2FnAMqeBX93jJH
	X4D++WNqHw7wq947OU/U33GBr6nd91A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792251689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=HXjCdSTSw8tkdXl8pfePmVTrTVApqz3VyVQTrGwKdJs=;
	b=lplNn0yw6s4PePePnj/KzX28MPmooFVsVpB7Jbq4V2KoX1ToBXldodIrVoDCpCGPiNbxyc
	gq+XqIb8RSaZ2sKZi1BNe6SEovvGn3ZHkCkfDwi3A/ew7+14jleQ9C3EgSf8ZJHKJL+Ioy
	IkdC9OIXQ5ObHgr/bV0Bx3LDZHW4LJY=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xI6XA-002Lfu-P6;
	Sat, 17 Oct 2026 11:41:20 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] mm/vmalloc: read vm_map_ram block regions from the requested offset
Date: Sat, 17 Oct 2026 11:41:20 -0400
Message-ID: <20261017154120.795844-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 467E0180006
X-Rspam-User: 
X-Stat-Signature: ka44m94saz9b3hf3po7zixrwhbew18ag
X-HE-Tag: 1792251689-278891
X-HE-Meta: U2FsdGVkX1/wuEcj9w/9KwsyNvxLGExVBTzhVyt25izTDykuKklcx59GZFuIGViCQvLSOOQ54xRujRFErxmeTUAl3ML5Nwf1Rku+4HFmzmQhNik/IngtSUX6+r9DUYxtz4uSTw1yNDSQscuG0EFfranf/dzyQS7M8xUY13P0j8n5e7g2FdRdBhBv1w2ww+Q+CbvTZ535XIEQg6Z6oR+6abM6AmEpxIRXzWcijYtKoCLw6XqVH3gkSEjDOJ2P1mC7oB1nneJh8Phe9cuRsN38XNhHodr+vFBJNQoeH3boC8vcO//jMcoxw96Qh9oUNTSOzic0hUrk/RlFw6X7ilkrmREFdkaWieyDgVg7xSVYGsk1sQqR6ueYNZEJ36Vpbl7AtNW+m031kHJv2re0ebgV/nCp2cFdo4KgZ8YaT4cO44f9ecrkyquPz5kZEfmkFP9TsbD9dX94LtNoIMwskKY9+7co3yiTiIupRH90zQoZ8eKL4ywf59TsTfd2+xWI1FVdB4J0LIqsoYN06+qnjlxT5Tm7My7CYyVNj1+ToDIhm5yOhlrKK4s4gncNyWAHqExr+iTreQj8HLsEu7iYQjnCP0s3RP8blnUJY4mS+b6a/HOfHa0k9TTDp9cLscovHD7+/ZUqRG8cik3F7ScMJ0uUdzFS6xqnmmVt6OmXBPi3GbItJwMd00ORh949h04lYK1db1RNh6UPMnT0cC6CYgdGjpP/VqI98nkurkwJYzWnHjQJOFb6TVy8kKXO8ow0Or61fU98pHlt90zRl8PDY9Nvs9oY8HYY/iUb0vv6yYCQ46UAVuAatPY3NZABJaJittZshlfFXuttm8Tn7sYwvIA4r5LopMPWgagzA8mHAX0QQkWD73t0qSr9oLP5nU54yAQjklfjWETtGsznX9l4TGMctfR0urCnuT79J2F36bhYDAOgycOED3MckjuXkng0yA5upGSfEXWXqD9Xs3l0NlX
 /f8/708m
 61z3ag5pI5PpJKkLsixvdGFF4kX5QVXUR+UcvsAvnOVq150AvYyb/bkBtcXkWOxNze0762pYDsMbmi6O336UPbEyE8rZDKrycd9HO2o/cQjS5K+ThBls6Ie9HH9wzFTAvdt7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading a vm_map_ram() mapping through /proc/kcore returns the wrong
memory for every page except the first page of the first used region in
its vmap block.  read_kcore_iter() calls vread_iter() one page at a
time, so a root user reading a live system with drgn, crash or gdb gets
that first page in place of every later page of the mapping, and in
place of the zeroes of the unused pages after it.  This affects every
vm_map_ram() mapping that fits in a vmap block (up to BITS_PER_LONG
pages): erofs and f2fs decompression buffers, videobuf2 vmalloc/dma-sg
buffers, udmabuf vmaps, fuse readdir pages.  Kernels since v6.3 are
affected.

vmap_ram_vread_iter() walks the used regions of the block and, for each
region, zero-fills up to its start and then copies from
start + offset_in_page(addr).  A read starting in a later page of a
region therefore copies the region's first page, and a read starting
past the end of a region still copies from that region.

Skip regions that end at or before addr, and copy from addr itself,
i.e. use addr - start as the offset into the region.

Tested on x86_64 by queueing a 29-page V4L2_MEMORY_USERPTR buffer on a
vivid capture device, which videobuf2-vmalloc maps with vm_map_ram(),
page i starting with "userptr page i", and reading every page of its
vmap block through /proc/kcore.  Before, all 1024 pages of the block
read as page 0.  After, pages 0..28 read back in order and the rest of
the block carries no tag.  With a second buffer in the same block and a
100-page buffer outside the block path, reads at unaligned offsets,
across page and region boundaries, into and within the unused part of
the block, and of the whole block return the true contents.

Fixes: 06c8994626d1 ("mm/vmalloc.c: allow vread() to read out vm_map_ram areas")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Reproducer (CONFIG_PROC_KCORE=y, CONFIG_VIDEO_VIVID=y or =m, root):
    
      /* short.c: argv[1] = vivid capture node */
      #include <elf.h>
      #include <fcntl.h>
      #include <linux/videodev2.h>
      #include <stdio.h>
      #include <string.h>
      #include <sys/ioctl.h>
      #include <sys/mman.h>
      #include <unistd.h>
    
      int main(int argc, char **argv)
      {
      	struct v4l2_format fmt = { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE };
      	struct v4l2_requestbuffers req = { .count = 1,
      		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE, .memory = V4L2_MEMORY_USERPTR };
      	struct v4l2_buffer b = { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
      		.memory = V4L2_MEMORY_USERPTR };
      	static Elf64_Phdr ph[64];
      	static char buf[4096], line[256];
      	unsigned long lo, hi, a;
      	int fd = open(argc > 1 ? argv[1] : "/dev/video0", O_RDWR);
      	int kc = open("/proc/kcore", O_RDONLY), i, n, np, c;
      	Elf64_Ehdr eh;
      	FILE *f;
      	char *p;
    
      	ioctl(fd, VIDIOC_G_FMT, &fmt);
      	fmt.fmt.pix.width = 320;
      	fmt.fmt.pix.height = 180;
      	ioctl(fd, VIDIOC_S_FMT, &fmt);
      	np = (fmt.fmt.pix.sizeimage + 4095) / 4096;	/* 29 for YUYV */
      	p = mmap(NULL, np * 4096, PROT_READ | PROT_WRITE,
      		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
      	for (i = 0; i < np; i++)
      		sprintf(p + i * 4096, "userptr page %d", i);
      	b.m.userptr = (unsigned long)p;
      	b.length = np * 4096;
      	if (ioctl(fd, VIDIOC_REQBUFS, &req) || ioctl(fd, VIDIOC_QBUF, &b))
      		return perror("QBUF"), 1;	/* buffer now vm_map_ram()ed */
    
      	f = fopen("/proc/sys/kernel/kptr_restrict", "w");	/* raw %pK */
      	fputs("1", f);
      	fclose(f);
      	if (pread(kc, &eh, sizeof(eh), 0) != sizeof(eh) || eh.e_phnum > 64 ||
      	    pread(kc, ph, eh.e_phnum * sizeof(*ph), eh.e_phoff) < 0)
      		return perror("/proc/kcore"), 1;
      	f = fopen("/proc/vmallocinfo", "r");
      	while (fgets(line, sizeof(line), f)) {
      		if (!strstr(line, "vm_map_ram") ||
      		    sscanf(line, "0x%lx-0x%lx", &lo, &hi) != 2)
      			continue;
      		printf("%lx:", lo);
      		for (c = 0, a = lo; a < hi; a += 4096)
      			for (i = 0; i < eh.e_phnum; i++)
      				if (ph[i].p_type == PT_LOAD && a >= ph[i].p_vaddr &&
      				    a < ph[i].p_vaddr + ph[i].p_memsz &&
      				    pread(kc, buf, 4096, ph[i].p_offset +
      					  a - ph[i].p_vaddr) == 4096 &&
      				    sscanf(buf, "userptr page %d", &n) == 1 &&
      				    c++ < 32)
      					printf(" %d", n);
      		printf("%s (%d pages carry a tag)\n", c > 32 ? " ..." : "", c);
      	}
      	return 0;
      }
    
      $ gcc -static -o short short.c
      # modprobe vivid; ./short /dev/videoN     # N = vivid capture node
    
    Before:
      ff32776280800000: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ... (1024 pages carry a tag)
    After:
      ff636d6c00800000: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 (29 pages carry a tag)

 mm/vmalloc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..34340c2490b8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4588,7 +4588,7 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
 	struct xarray *xa;
 	unsigned long offset;
 	unsigned int rs, re;
-	size_t remains, n;
+	size_t remains, n, size;
 
 	/*
 	 * If it's area created by vm_map_ram() interface directly, but
@@ -4622,6 +4622,10 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
 			goto finished;
 
 		start = vmap_block_vaddr(vb->va->va_start, rs);
+		size = (re - rs + 1) << PAGE_SHIFT;
+
+		if (addr >= start + size)
+			continue;
 
 		if (addr < start) {
 			size_t to_zero = min_t(size_t, start - addr, remains);
@@ -4635,8 +4639,8 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
 		}
 
 		/*it could start reading from the middle of used region*/
-		offset = offset_in_page(addr);
-		n = ((re - rs + 1) << PAGE_SHIFT) - offset;
+		offset = addr - start;
+		n = size - offset;
 		if (n > remains)
 			n = remains;
 

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0


