Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F823C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4716B008A; Sat, 26 Sep 2026 06:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5646B008C; Sat, 26 Sep 2026 06:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E22D6B0092; Sat, 26 Sep 2026 06:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5527F6B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D91ADA6F77
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:28 +0000 (UTC)
X-FDA: 85255571856.15.92DBFB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 328674000A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDlwayMn;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SN9pBsYau6XqA12Xdl8N5Dmjue89SDbE0U+vn84I9OA=;
	b=yYKJkgsyGcqD8NIcZETgQbHYP836m/2LLLDtDuu3S7KEWS0WljJLkU89QC22OAahnqgOfn
	XVtKO7zwIw1w+ETIrE7YB0b7tKMWGd55pSPbwU5LjsiGm144N3nBo69Whku+KV0FhVypS8
	jbHpdNXPXxVtNiiiFyPnk6MPhLwiIpQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDlwayMn;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419287;
	b=BijogA0gDT1ySp6lwJnPCCRIOcjAYPxTayiTKGvzVwPv+Cr1P+VQIPbP9bAWt2lck0Er8b
	t6JPIROIhYGt6qJfBm0fy/xSS7sRmXmKCemW+JTv8j4weUZjEklma4wQ88i3u+RiuIMrFA
	hWEifPSViHYGNjLCz8ydU4HVJxLXShg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4B0A6022E;
	Sat, 26 Sep 2026 10:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B241F00893;
	Sat, 26 Sep 2026 10:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419286;
	bh=SN9pBsYau6XqA12Xdl8N5Dmjue89SDbE0U+vn84I9OA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SDlwayMniSSzMZ/yLnVoRDTY/aOgPvhOA2LDiF/HlKzgD59VRgg8qfLbmWV7AjCq6
	 KcV2jNVcf1F7ESdYqqNdVr2WdSLVNuqYjM8FKZInbRK6pksEv45OLMbpbPiXYiakAv
	 GzJS+FJWIy3W4WFfo5Ti/kaKJ2vJzLZfe42+vQTxNR8h3N6RwzclBbPRVCG/jNPeY6
	 sUw2rWFuNimrCLiB4hqW0C2nrzcAH9Wh9uh0Mm4I72cvVZR4P9bdx4pR+3TofHvUSS
	 BAxuw0Jqca/FbYdDyfMaLQlNrMTYCBgzl/QDCcLbquBLipWly0Y6peVXaC44g1vd2b
	 tvEK9r4ONorwA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 26 Sep 2026 11:41:06 +0100
Subject: [PATCH v3 1/6] mm: move drivers/char/mem.c to mm/char-mem.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-map-private-dev-zero-v3-1-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3650; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QmSOJwju5TfiPg8slA7VLmMjfjzHO2fnrvsHpTcasuQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/Q+/VRBOIGh33GV2KqlxwrmbZjPvVD3V/jBJdNPb
 NX1ezGptaOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATyVvAyHB/cdWRts5T9u3f
 F3OtFtnikhAgN4NTJtCSR8XV/EieSxAjQ9fhBx3mZfcf5SWt3Wt56MQ79hk1mUazDwhltj74mey
 5nBkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 328674000A
X-Stat-Signature: hepoqkdi1zpndbusxqsduk8fdjpm5j11
X-HE-Tag: 1790419287-255215
X-HE-Meta: U2FsdGVkX19tmR3PuKyAKUVuc0t+xazQttQbcu6iCVM8ss6qsJwxV5rzXDpu0FZd4mfHSehzgEnBAyR5BeUvPiSGQ9+U4UbUYTNqT+pghhz7NIAaVXR2jKx6BVBxEiHuCyPxI+zvKZ4WvKfm201YNtqV2ydTIKCe0ynmG99NAOmShqwajWI45CLgxTPnzG0xFNVzQPPZPTXu+FyK77PO6JeOywEU/c1SKrm/HN8G1wZda6y0RLLZopXP/Xq4k30WEx4u9XBWR9Rgli6VYI6XN/aFVcs4b6uva4ad7XbqNBWMMuZnGy9xXEv+uMLsy3KAMcsoubLdorYCFOf4yPOakgmG2jzJ/yOgdqnXr3Z+fi4MtYMeozEvo6dnK7jjYyYgNVZw/BXHK5U9WjdSPHX7/xDJCMZuyGltetEWeNF5ZdWvZafPYN3tBuyLH1PTIwO2ck5wqL+AzBOvjB868iXRjgbtcHzIbG/+zB/x82JVzAZ9ixJ9cypbfth5TZFH0M9VxNLyN+i14WCXuqYFdGiYVJbz1gdDFOk2m2Y3Q9KvEO+tdH9slY2sFTDz1VFOwOUg6LwTB8FAhjzt9x6hnqiUBQyWTjZT/EDkEeueThRXAL90WuuVktvwhsRMuJE+aFH6ZvokTDjXKgYqPwVut7XtenykRdbOXncZ9IzkqQG32UWNwTIzvoP9kIkxF75MY6FU9h7GS7M5Wg24thZ4fv5FQ4EUMKkdnEigdL8FtD6T6hM20b0KCHYQAcUSzLie/hVmRMe1yw+EjShWGF/VTv4Hhta/fxlqptosvIOXZRU9iiOagf2XZt3DzwVZFdWCI4yB7M57A+lDyQBriAMseQi5Cc+wTw0CmEFRsiiVJsbRws4NCJMMvLehgHYLbkRL1V2E+mMfXi7cGei/0nC2tCxWFL/Hmr6h54wjs7ZWyk/phRJLybHhvEU22I2sCgNnv0sW4Mb/zNo3Jo9cbWOL9MI
 zEyDVCa4
 Ria/rYsoSzcakpBDcOetlU/QvMP6SmEhWNYseJz6KnqYHUMViQUeBHpVUm1Q8l7U516BRa3SwrJC3PHoOKpngVqWKcBdY5jax3OKl43uHPj6UE+05Tt7cM7xqIZrnRS/k6YJragurJLcPoCc7mXEK07hcr0BYvNNhDjBvAhzfYvXc4FEMqVz611CpbSfhQD4A7v8IyqhcGKpQ+ciTDs0DHu/RclPg7Nq2Ea0zaul/6wCbdNrQniy3FJkOUEYB9SJdWKwMBnmQ6r4Sms3EPGI7qUfPGsYwN10Efor6XQ6NQfImpVXiSP+lqimkD7uxdud3kWImPZJmjgN8RCCY7rwHe5Qs+hzkUo4KfO9cxe+Pn2dsY7E=
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


