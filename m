Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A69CCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 23:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D376B0088; Sat, 17 Oct 2026 19:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD446B008A; Sat, 17 Oct 2026 19:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F39B6B008C; Sat, 17 Oct 2026 19:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22DAA6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:13:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90B641C3273
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:13:31 +0000 (UTC)
X-FDA: 85333671822.06.30A74EA
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB7A540003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:13:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792278810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oePduJrBA6N31O0rmo9f+c0UDynN15W1p4it3ziYZCs=;
	b=DpDRCc3+P/uqu3hfkX/wetbRkAkjugTxPV3529RTG67nqFIrMfbXwdjrcQvEB8pu0TzhOh
	S4/Cyu7UVLJXgLtiSkFP6rVa09OqLvqYAhQYXgjcYRXkzFk51ZLwirincse4B937mQmyox
	EbrB5seDgW/7wl8F3Ynf9wGvd85F3sU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792278810;
	b=4nkrBjcMYbArbJ6yIEOAEfxtPcxj/p2IgYm9O8vT6KE0dpAkfV3Taw8jYowXNc8lcA5yje
	R3Zv2mluZcAFuLCk+tm1CoCI4vmG9usOAIcg7Xj5MWT4PHZ/zj0ICsOBiTXYDPe55pRh3q
	xGqbZuGO0H5U/3ARsyxpNC/fnuZ5mGU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xIDaf-003kaO-P9;
	Sat, 17 Oct 2026 19:13:25 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v2] mm/vmalloc: read vm_map_ram block regions from the requested offset
Date: Sat, 17 Oct 2026 19:13:25 -0400
Message-ID: <20261017231325.796986-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
References: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB7A540003
X-Stat-Signature: oe4p4p8pmx9kydy6ae5nmwma7z6bnf98
X-Rspamd-Server: rspam05
X-HE-Tag: 1792278809-943568
X-HE-Meta: U2FsdGVkX19uiUxrtb7WLrpZxw6HXrT34BZrZKNmO+az5ImyobUhrvTpEKryAUtTN2zEfesWXQQtRG9am3cn2YdMYLV37BNF4yF4sWBzc3eK5x+5Ns7h3CQsakkW+ODs92ijb6SZCiC17a9qeAI+XwnEpjXmOjjUiG+Q/dYUE1eZzXub8Q3yU9u0Mwv2vvmpViik0XcVdbaX7+7+YeAU14MgBOK8A9zdPQnfKHlVeLT4CFhpnKMpYYvBnXLnqECO/aq4HYQdUIV+Ih6lgMZs3B2F5fQGUt+vyydwyvx+YfY/WbUJX0TunfUz9lL/U2isIHjgM1SzA41WmfRFUuE2uatuqaRKhcDC4BNPXhSFAQQiUEIDeYuVz0p+zd2ptA24DM7XLM2O5N7XskJaje6jhUF91xp4Tqlj1Gif56a5mVkO+BC3UVxtutQFEQ+XrLqnPHIdCAYszQpCx7prt0a6IEGXueyFW2Bx4+eO3fW2frUk2emG73nbstgxbFiY/T43Ey2p5NyVzjJ/EHiNTuUBuFcPt3okAizNxOX/0OAK4LK+ItI3xrd+qhvYkEdupsSc4xyHojFzI1w0GCWZnnyKPfa5qYnWRWtRC0yhu0jKT+hHqAGUmynM2+y+CBxuB1ClcEn9XyHoHQsbrmLUHP9ij0hohAaBNlzaTthCy5ohMuz25TeC8woOFIA+f7tsi7xi+yVFtMSUGytM135K7ZfOdA8NS52ikB/XnMUn/k/wS0or3IiXZ2tlOdLgMKaDG2AEZ/E+2SwK9SMCT5UconpeK/vf8yQ+UDk3YC7gdOSV71OZVg50yBUNSAbYHFuyYRbTui/Lw3SP3IeCmQfpsQj7Gd3B0v563SYbumnCvvN5YexinU/PkDwnt1aJsI9rfaHj7dKRuzvS7IMXAHw4uxfjrMCcj+8FcMlRxZqN2x3y2rjOnn0V4WMyV8+c6hnr3/00bKErOy36Ser0CSnLl1m
 4uPC4GfQ
 GjTEchdtzk5modU80hvenF1rK58KGafeuIbi8FDHGtwnuHKROLzAM0Gnm001lvzHZoGOAVK3RFqTrhtlRDu/+vPQ70B83lV4gVttPZUBhpzpOygFsNS/G9h0zhMHbtdDxeps/
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
i.e. use addr - start as the offset into the region.  The region is
re - rs pages long, not re - rs + 1: for_each_set_bitrange() returns
[rs, re) with re the first clear bit.  The extra page is one whose
used_map bit is clear, and vb_free() clears the bits before it unmaps
the pages, so a read racing with vm_unmap_ram() copied the page being
freed instead of zero-filling it.

Tested on x86_64 by queueing a 29-page V4L2_MEMORY_USERPTR buffer on a
vivid capture device, which videobuf2-vmalloc maps with vm_map_ram(),
page i starting with "userptr page i", and reading every page of its
vmap block through /proc/kcore.  Before, all 1024 pages of the block
read as page 0.  After, pages 0..28 read back in order and the rest of
the block carries no tag.  With a second buffer in the same block and a
100-page buffer outside the block path, reads at unaligned offsets,
across page and region boundaries, into and within the unused part of
the block, and of the whole block return the true contents.  With an
msleep() inserted between the bitmap_clear() and the
vunmap_range_noflush() of vb_free(), a read of a one-page buffer being
unmapped between two mapped ones returns zeroes.

Fixes: 06c8994626d1 ("mm/vmalloc.c: allow vread() to read out vm_map_ram areas")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Changes in v2:
      - region length is (re - rs) pages, not (re - rs + 1); suggested by
        Andrew Morton.  The extra page was shown with an msleep() added to
        vb_free() between its bitmap_clear() and its vunmap_range_noflush():
        a one-page buffer being unmapped between two mapped ones then read
        back its own bytes through /proc/kcore with v1 and zeroes with v2.
    
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
index bea9f76ed7e7..643299c9ca15 100644
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
+		size = (re - rs) << PAGE_SHIFT;
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


