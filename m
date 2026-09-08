Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6932C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B456B0095; Tue,  8 Sep 2026 07:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CB26B0098; Tue,  8 Sep 2026 07:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82716B0095; Tue,  8 Sep 2026 07:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C21FF6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:24:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53F4B1A054E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:46 +0000 (UTC)
X-FDA: 85190362572.29.D52A98F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CCA080005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Kt/T3D8X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866684;
	b=rqXFga7t/l+rPVVoVYQQTXFjrTpjIcoINC1sAH4SZaZGUl/Fy6XHChyylevuVDFu7IBfcX
	U5F1TomX04IVRfuBkJ/4nyuC90pf7a0bWwtk5lLNF2fjMqExG1PQu9wCf4cbaUpdReJAli
	PxwXXe83DkgH/HHQXuEZRVKqG5Cqxg0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Kt/T3D8X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SN9pBsYau6XqA12Xdl8N5Dmjue89SDbE0U+vn84I9OA=;
	b=aqCycWF1uI6e8H0G+BrAglGd6aIcDPTVmiZE9CBY5q2HVp4U1NmF2Sz0gYrKa6P7w1pfpp
	jyZjvS0lnbGXpiYNIutHmBMzwb6GjLaCvhkib37yxKOgwnwvgy2hWJOyJ/Tkv30sK19XV1
	NfM2rB1fIWAnXMqFraOT5HA3169Y4uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD82B43D22;
	Tue,  8 Sep 2026 11:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485D01F00A3D;
	Tue,  8 Sep 2026 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866683;
	bh=SN9pBsYau6XqA12Xdl8N5Dmjue89SDbE0U+vn84I9OA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Kt/T3D8XZpEzIO2N4iiHbSPlr4ezP2rFGrKhB8FxNGJUjNIAUpTwD9HB2w4fSdRXB
	 3d+G27lYP0VS4+TljcJccGORudcFm1kPDdz4/OEvCSMQ06hhm/tILmG6tXjv+fSxQy
	 zMCIcl9up+LoaF/s+i3mqtqISioFKy9/BCXkdOX0OrxdQ5lfZVcnYbTsAy7l10FKw/
	 DsKUhaVgrSL3QWN6+1haOn5hhpXGYybvQCKtSVfLx1qeHkhsUox0Tr1QG2JXGHkIYg
	 UC6y/zN+LsXyYlH9dSgiyaqdJXFBbTQor3lMoBMTACgjNNtY5Gk5lqMhdnzWFhkCEo
	 7x8z0YQX9TC/Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 12:23:38 +0100
Subject: [PATCH v2 1/6] mm: move drivers/char/mem.c to mm/char-mem.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-map-private-dev-zero-v2-1-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfyjcdzyWeZOE6yTvbwKf+P1jDhiwHK17HsCu8FHw7
 pSpHKH/OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR+cGMDA1rKx8/uvU/ObR5
 C9+U0lkqDLvK95be62aedsT4ueG2cysYGXrNlfuezn9pcvO5e9qxW+tsvDTsSzwdDZrzPZyFtWf
 fZwMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7CCA080005
X-Stat-Signature: amkwgrwobtjebcw3jjedqj4zciebct7p
X-HE-Tag: 1788866684-992783
X-HE-Meta: U2FsdGVkX1//RoNKovcqmTXfP2ACKalmATmxjrPRFYIsVZyWzB8xBcqDJUMJpx4WwITqCF7srOwRGtR368imkWNSzl3czvt4HOLs79CncwN+l9bmqkWsoWy06qodwfimuDpUp6+VvB01Z7cM9RG28qi68ZS+f2fDrWqfBKBFSanshvRjULwRnKsixe1k3NsWuY67RjJzKNwt5WFKcN0IeH5aF1UwYZgjc/I6gxIA9OMhN4AFNlIds2hQgp8fy0/9kiULLVovv5khJ+i0Z26hjqptfAkV2HuXMVFgaY0iKrgSR2Z/xw5mZnbhIryxkzEJrc5Yz4H/GNc1j4n5ewxL/wAZIsXrsXfCmgrWuSzgf+gp0JwegyL2uq6eEQdWy6a7yY76WETxFccH5Q49JUiUAnwAe0aLF+sezxzjAS1SkT4bBVGuOyI0WS7l9ZWc3Pk74i6pVEs2twFp1BfVXbx13MuECgwjOr7rzyaMqSJSOmpGNheVUafmGriHbhXqxzxCt3ydlmoJfhI65ngoyMEqkQS3yvmSnqXulEuTO3GVzrk55SSwgGCA8QvHIWpW9j+QxQ/iyw21OevSf9Q5Jx7MeVZc6T5ucUBb0FeMFzAyWlXaDdFbhHFIjDtmQFbcy4d+v2SKm5161Npl83119j9ze7LB9LQQ6/ptKK2KE5yRfCsLJgq+N8G0NS6AtfL/NvmTilGEiOq2eWvVFKkJCdxyIHjByIP6CLke6/sjGWNpI6N6yiG/mNY+cJeKil8Qd3AkShhyzw5OqD86yG7jk8Vc4Vg7Mms40iGYDG83jEZvcYEK8meWReU4aZNYNk/1Hi+71ut2rSYu8FBChcwFMzeM1X97HRPx0jtAiPOkhjU8PAXdKigefI51RS9Z2V9as17AmPB9EW+ZXifAELah6Ue7O/hbIPIS80yICa1kwNMe/dodgm9bkSHgzNIOhJugs3Nhdxe/FiEU0hjMnVmlQ3N
 Qv7TCIlu
 M5kFxiZsdAsBI/R592roqUg6uo910NOwWQC1Bm3yyRSHLcRMry2UC8U6FMcrj5DSPg6pE1IHDvVar2bQTCf4AgxHjzZAOBSecHRpgPltAV1vS2exFpipiuvr+ZZeLQ8PXzUxkMONXtGiyhhLtRuuFX2EFaZrh9ptRzM/v9ORZ8fw0c+zmlhTuq6KjbR6OfBN30/KwFylu+hhPQ2MUYGYgYu/RmG1U7yGHteuW2Oiy+RZwEgfW8oiQAvJLsuXGC/at3mnXtVcXrT03D4jWKDaZ7sJzXSTVl49MP9npbO/wps9gyzAHQlZMU+4ca8IO3foj63jhUOJKyXeW3EhUw6UCuaZenXdGGMTiyz2tBd+4j0A8Xug=
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


