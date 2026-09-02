Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC47C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416636B00AD; Wed,  2 Sep 2026 14:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A02D6B00B2; Wed,  2 Sep 2026 14:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD9B6B00B3; Wed,  2 Sep 2026 14:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5E96B00AD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:00:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98F861C19EA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:00:54 +0000 (UTC)
X-FDA: 85169588028.04.8E7D76D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9E5512000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:00:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGydZTsC;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372052;
	b=Rnw5O0HVNn52On8aV56lXWRe7ij3XUbJTi8JUOwvQktXecsqeiJ68t9JDP4srU2tvzrMg9
	wwiLg/JTq16eHrFazQ6COyYGwSs/ddgB44wq1bAJuaiHmXNm8UwmHDgmeSO4zoBahbul2M
	CPvRJn70lKvJjL0OsaEmkEXSTlfAwRQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGydZTsC;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkujdrJ/pdcNwpIbp+sSj6hn+DXxw2Xn58xtJMFlJxs=;
	b=XgJ3w2WM4lgKzZ5vtMF+jnIiqR6xwlfxf7ZnejMJWMFANh+0E+j5vW58bn56CC4/6yjVnd
	E4OUT7Bf94lsO4ZgT/VEXDaeAywMG/MjsRpFec+cOwpaHUx64eh+714yj/tPcp35jwbCv3
	QAloIGNt5zx8uBEa1VDruKhEk1Wtna0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32C1A60230;
	Wed,  2 Sep 2026 18:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90601F00A3A;
	Wed,  2 Sep 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372051;
	bh=FkujdrJ/pdcNwpIbp+sSj6hn+DXxw2Xn58xtJMFlJxs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OGydZTsC4RGgesW31RFvGv8NgGNrrRKWaqywQDMxbqsW3Wyx/EAVj4VvJR4KJQbPD
	 hym+9RctbEOEGHMpWGfFbBe3BnGzDbiq24XumBUsaPFDDJaTAoU8HQI+YJHXCFOK5g
	 NgZh6lej/czw/qPob3S7F7vTewedg/mXKnNvl9bdyz8PJayZs4oGeHzKFSk4O92+FK
	 Bvp3bCd6znxQJFZrEFrBVszkU5TEgG6yVESvbT0BrYMJCmt+ZQpPaVkwC+dQ6lRCpl
	 d6OeS478mdWn1liNL+w1RxG1n2/Ml2n+QqX2Qu9+MSrvgcT3P8BLCMCJLKzxNCkmJV
	 /kJ5V4j43Y/xA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:00:18 +0100
Subject: [PATCH 1/6] mm: move drivers/char/mem.c to mm/char-mem.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-map-private-dev-zero-v1-1-a578c730cec7@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
In-Reply-To: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3541; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+lQ64M91uOCmTZQebnoxYSvQq7Jfy6kZG9l8lKXW1J4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpHg9UN0a/7/TWUg8x1o8wJEhtUpBeIuz+fbSa8W7/
 zObn2PqKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwES+nWVkOLx4/glBmX8CS0Ju
 N0R7HdjYZGh3L3mhVNVJ0x2/leXSuxkZvrf0GS0/11DnPH/nmmXZixev8t3nq/U/6vO9NzdmC07
 7zQAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E5512000A
X-Stat-Signature: grfnf1a383mit6e5y397dqyk8fn157m1
X-Rspam-User: 
X-HE-Tag: 1788372052-112957
X-HE-Meta: U2FsdGVkX1/gwOvs2+tUs3lzD84mqKGSSxB/M7Yb79it52JfIqE86vRkuLCf0w3GqANGB4vxK4lGVH72FhnFUat3yQpUe9NiCkFO7+wJrdiHQY51e6KF+3TwYSUaAuY5FvtLW7gXFIwNNNFWqEKggy2fxNMJIdiegZKGg263k1HVjSnPJz51VkST2X3LF8yBGMCAALW5ZR7u23YCZoAoQ93HkPQN7p2xWqGOlknRKelqjmfTyvtfncRl62rUlzirdv9U6oWqsezeoxfncSCGKQrPn7vMmIdf8vMPz1GvgI/mrYHBheRq7C5eweg9Y6MI/ijbHjBzP+RTHB14Bom0yG4zN0MrZ/qpaClMGNvHFtWCM7yrhxMLFg4xFw6o8XqJ1gpljRNkQRyIVUk+8jrc+7HjNGqarAPQJoEz/XDJ6gV+tIe3QYUijY3oqNlMop9y/K90dbbxAXHz6An3KrqTeAb3oIwPLzyNLGGgX7mlj74mtilZfy28vv6/bdT1JjeYW7Muq+Oyn3vL3eU7Ia6HWQCt1noukCr5mJ3Y83YTRgr5c9e1n0vyEL1Er6Ab6nTyX/H4dTKNObLAo97cz/9ObvdZL2nnPR0+2ZJYyQDJ3CLO7d1KbFjDGncauKdmZh6iAYSgsRcFsjr4mE+SB4jdx9zdRh4Zwz6gPEyN5Sa0YppdMRI7IvVHydH3R7qAjLy4LgKCYWHFwJqCnePEPEbV/eJV+tGVY2/dZ6QRJiTqKzxNEDs5+6mw3Oo7fRZj0/O3nkdzpyo97Uk0Ztn8ryB4IV/0jRjVHwBOt7Cid1HEJl9H1yn25pranQfz3mEI3P8tbeZWYr9jLpMXSMj6u+DGcnq4GDSnKewVZM1LQG7Vfr0Fd3XUrRhi3gMNEAaNmG/gTbswnJcy88emZ1/vcCDQu+tLhOHv5Ot2NUVFETDfHYri0H9bIocfYuksdWEAXtOKYoUt4J1mKalveuJuJhv
 1sEgTnH9
 SDmNVqMKWLpx4ZDDm/EAIR/pu0a7JdSI1Siurhp+biD6bR8rP1I22KNNR758jsd7QTZ9wDuZ0pZevMTYx6BOM23WopW6A9QrkrWgU8nw08YSZt3pO7KyV+QPPygz4Xd/g+Ub83UClBFl3pxv/q+5NZrf55EL1iwsA32F1Qv+xjOPnnazThOgb9bh595ZE1awsgnXU+LXwKxVpI6GyX94R3mVBji6F2ZMp0XeHbEUShc/r83DREQLupGFlGR/OomNLgnd9nfqDrn9c2LBRXvx3OQ/83KDoag28cSq4vCSZY2T+9N6wMnINoDr9wxasIgKCGBOiTqsa3sO9s6qXLaIBelSaXeJt6oANkbaDRpWaaD5xV0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory character driver implements several mm-specific features and is
always compiled into the kernel, so move it to mm/ where it belongs.

Among other things the driver implements /dev/mem which provides raw access
to physical memory, and /dev/zero which either allows mapping of a shmem
region (if mapped with MAP_SHARED) or, uniquely, anonymous memory (if
mapped MAP_PRIVATE).

This change lays the foundations to allow MAP_PRIVATE-/dev/zero to be
mapped precisely the same as anonymous memory is mapped as currently it is
an edge case within mm.

Also update a couple of comments that reference 'drivers/char/mem.c' to
reference 'mm/char-mem.c'.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 MAINTAINERS                         | 4 ++--
 drivers/char/Makefile               | 2 +-
 mm/Makefile                         | 3 ++-
 drivers/char/mem.c => mm/char-mem.c | 2 +-
 mm/shmem.c                          | 2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2133aec4a200..ebadf4cef076 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17272,7 +17272,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
-F:	drivers/char/mem.c
+F:	mm/char-mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
@@ -17477,7 +17477,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	drivers/char/mem.c
+F:	mm/char-mem.c
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index a46d7bf7c4c8..bb3bf66937b3 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y				+= mem.o random.o
+obj-y				+= random.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_TEST_MISC_MINOR)	+= misc_minor_kunit.o
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..2a3ec53d62ee 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -55,7 +55,8 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
+			   debug.o gup.o mmap_lock.o vma_init.o char-mem.o \
+			   $(mmu-y)
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
diff --git a/drivers/char/mem.c b/mm/char-mem.c
similarity index 99%
rename from drivers/char/mem.c
rename to mm/char-mem.c
index 63253d1de5d7..d2e575545044 100644
--- a/drivers/char/mem.c
+++ b/mm/char-mem.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/drivers/char/mem.c
+ *  mm/char-mem.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
diff --git a/mm/shmem.c b/mm/shmem.c
index 255d69ebceba..c92ed17dbc4a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2981,7 +2981,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 			sb = file_inode(file)->i_sb;
 		} else {
 			/*
-			 * Called directly from mm/mmap.c, or drivers/char/mem.c
+			 * Called directly from mm/mmap.c, or mm/char-mem.c
 			 * for "/dev/zero", to create a shared anonymous object.
 			 */
 			if (IS_ERR(shm_mnt))

-- 
2.55.0


