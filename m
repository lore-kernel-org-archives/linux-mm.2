Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61F8C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4006B0092; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0626B0098; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FC06B0093; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44AB6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51B081603CB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
X-FDA: 85011262224.30.0C55273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5030014000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/yiDBJ2";
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602390;
	b=mr6z4OZ7mBSXL5KbHGBZgrMqJV+YK+tlOdtoYVouE6AE/nkQNe4BMfVsswNVhEzwe97lb9
	2oAci/sKyd92HjevSNBCsVWvzBy+jFBd+nrPHnGHoGQQ8DS1/YyC+ETkZzC0xKT4gdxk00
	fMCr+SnXUDyXEqu17XECUyVzbvhiaD8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/yiDBJ2";
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqxsorY3HIvAhXWiexmMe748BxZR3QlfTfEOwGnkhkM=;
	b=e0uFPog61q+Hxvin+8u9Im5ZtxEDOOIgn1B76VlUXHfeMjEUMl7NLolonqS4AMAby/a0us
	QqQWhjLX+zSjg9gITC6h3kKzRUG4KGRjhq0m3f2/Wot2sUhKiGk+FS6MEE+T2E+HrUy4Ff
	huXcv1H4LLt1vI1mc+EUB2BqTMZkxT0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5239A43FE3;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 332BAC4AF0B;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=Wu07gWj3erS7hK5FPPelwtFUrfvOki8Pg8B+z3neeSc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M/yiDBJ2nGMs3YeIqFjgXDdqQaBtXuvBCS9Liqauek39MEy/kPmh5zzJIF5z9fd2O
	 St7/2uvZpPVnOVnQOp/w3Ml6r3lHlj3nvEwul35ZGR9Hcqo0IDyJfoqOPBd6VNe1vi
	 B0OcR2imFFVlMHCWsCl7i6Uu2tmo4lj54xjUeiyTYo+JzZUP/0cytjRdXZV+zk/whV
	 nngHfIM/9oj3vyg3Oog4lRl1tmO7fch//zkmYoTdyqNK+DsoNFDhm0/Q+7TcXhKPca
	 AI7Ad9J68yfVnRBn8ZLBO/YpNzD1qufpBr/0QGkRnmzFdBbnHuJC3qu7r2It6XKvzm
	 cpDQkWhLQsGvA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F989C4452F;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:09 -0700
Subject: [PATCH v3 06/13] WIP: mm: hugetlb: Move subpool functions to
 hugetlb_subpool.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-6-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=13070;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PqvaRfss4aqadaeJH8AH48w85toFWMCvvNrNEPaAyKc=;
 b=6BBdWsqAWtEKlq9TQ6riYxZR+DYxf0X+5j+MmIiRrX5Qew2yTCc0lofrYvLoqZxxd15dJ9XzO
 rp96xiTX4M0BBhoisnSQr1lEnbII6WuKTLr/kYov9HrK9LNWk5icisR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5030014000A
X-Stat-Signature: zub46omicskfereafnht58ecjtwj88i3
X-Rspam-User: 
X-HE-Tag: 1784602390-66275
X-HE-Meta: U2FsdGVkX183balmSyECFe420yIFbYMmpZxDp+Qp6r7P0XmJ38WztKkz0WHT4FaYA/PNvmJdMPyxrHr0M27HDCIjZlKy/C7V0CyxOjwoIr4QTSy9Ye0Zv+pQgeQ6LxAW4OhKxkoXlvFvlOoF8Q9CZ7KmOSd67bAqKabwKwH7YXzYKF2NfBM7Invyj4HUKoE5WydvBpiv69M8J16iUdF4LwjPrXkZHoBmYGltO+n2zJSVKpd7gJbORan2H7obXVWorVCrEMAoAdIBQ40/7RiCCyfch5u/1JruayNtZ3ftopiNCRgRrvl7HbP9LDRIMPcBRociyUjdbLY15wpwl6WJwDZ5XhQKDpELB2JtcqSw77ms8bjhmRTgoFCGCqpSR2ZR8KOXap/ds7CNKUvxEARbqQUq/Vo+aRAh6Ns/pRZAGlT3FPM3pQKg1tY7VEhhwuXuUXf/+JYrbqAZD3m7O7P87nBh7Yu3q6Ab1DOMWlQNylDhf72BVJ+kHhWjPLakKAi3A6kIFuCTVvQVebxfR1yKowQ1IAwucA1mUmD+2dPinANGlY3K8IfVoKUaiPuPJHW8EMrmEEcgUJi8cQomHlTEinM2q1bva7l2wcg8D440vbKpKdosXxkC9YS6cY+Q4+Oju9eloxW5JyE852SEF9yOBvVKrbl5i+zG2OeEyAUEzpQw7I8eeFFMfVLIzKcKhqYcJUjiFLHqyd3WH6Xrv9wQQZxaou7AwaSvM2sslJSq9bBJYZFrhc0cqETajDkP3DW2PWGBalfwkgwNoYqOW07uXUqz+Vh5AVOaLHdrtI+tZ4qisdkeAttdGQhuQqPVarXTpAUmNpDDEPa1rumih+J0fips85oycsNyiIdwd/Ou1n3Mhc3XUSdq3SBJlXtetk1jW5qbu2s/MC4YgWBpv2LrzUhN/efu5X2aP036jXBr745KOQkwLtFPcILR4RNAP69D8QnmJ/TG48MJ3CoUGCX
 FumDxxLL
 /Mogzqfa8fJOejNRbq258V21I2hbSuOO768PXgxuoiK/1lCzdXjYeOZsw/apQnY8r+pnIjg6oPca7Q1sEd49MnRyG6ybakBMXk38KV2rdXukCwdxO/elTT1GNRlgKfgmFndDNdMmr6NN8C8g9bvjakRBJaejjsLjm6du0nQg1V4whjt/DWOWGu7W5PxQZVB0DSOT+y+lRwT7pbGhL34KfZsjW/b4vdIvoWRCwUuNk5Srk8vTUmkIa7HpsVuctSj3bW6ZhRxtp3cqY5HfZPGsO5LDQHFwgZKv2b8LdvBrsrCqFPDUdZQl/SiPYaK6IhZ4wF4zN9xJRhNe1BQOgj4ZYWfalbmwNoR/Fcfqc/xUvPIsVIK0IoOv38ThgXqY8pBHU/UfcSrRCxrNnzCqNOBofdwCYSVSzc62RGJzrgBRnkFQCoBGOiu7+4Qs1ASFie/zy8q5khU1e9taQe2M4aX7GJcA5M6dhueUQZk5JN7W7NGCXxBkAkZVrkHjzXPP6Uw9xIQby0OAMjMDSiaf4c/0HLExlCi3tEJvlYQpC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move all HugeTLB subpool lifecycle, page reservation, and accounting routines
out of `mm/hugetlb.c` and into their own dedicated, encapsulated translation unit
at `mm/hugetlb_subpool.c`.

Also introduces the internal `mm/hugetlb_subpool.h` header for holding the
subpool-local APIs, allowing `fs/hugetlbfs` and `mm/` to access the subpool functions cleanly.
The subpool internal layout structures remain in `include/linux/hugetlb.h` until getters
are introduced.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c    |   1 +
 include/linux/hugetlb.h |   4 +-
 mm/Makefile             |   2 +-
 mm/hugetlb.c            | 156 +-------------------------------------------
 mm/hugetlb_subpool.c    | 168 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb_subpool.h    |  17 +++++
 6 files changed, 191 insertions(+), 157 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 26c0187340636..8c1caad74c409 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/ctype.h>
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
+#include "../../mm/hugetlb_subpool.h"
 #include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 34b9a3e1be0fa..f36be371c6e88 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -114,9 +114,7 @@ extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
-struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
-						long min_hpages);
-void hugepage_put_subpool(struct hugepage_subpool *spool);
+int hugetlb_acct_memory(struct hstate *h, long delta);
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061c..3965c959e5099 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -78,7 +78,7 @@ endif
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
-obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
+obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_subpool.o hugetlb_sysfs.o hugetlb_sysctl.o
 ifdef CONFIG_CMA
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb_cma.o
 endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3f6189d2d0188..e87f26a3e1f3e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -39,6 +39,7 @@
 #include <linux/padata.h>
 #include <linux/pgalloc.h>
 #include <linux/memcontrol.h>
+#include "hugetlb_subpool.h"
 
 #include <asm/page.h>
 #include <asm/tlb.h>
@@ -114,8 +115,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 static int num_fault_mutexes __ro_after_init;
 struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 
-/* Forward declaration */
-static int hugetlb_acct_memory(struct hstate *h, long delta);
+/* Forward declarations */
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
@@ -126,156 +126,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
-static inline bool subpool_is_free(struct hugepage_subpool *spool)
-{
-	if (spool->count)
-		return false;
-
-	return spool->used_hpages == 0;
-}
-
-static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
-						unsigned long irq_flags)
-{
-	spin_unlock_irqrestore(&spool->lock, irq_flags);
-
-	/* If no pages are used, and no other handles to the subpool
-	 * remain, give up any reservations based on minimum size and
-	 * free the subpool */
-	if (subpool_is_free(spool)) {
-		if (spool->min_hpages != -1)
-			hugetlb_acct_memory(spool->hstate,
-						-spool->min_hpages);
-		kfree(spool);
-	}
-}
-
-struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
-						long min_hpages)
-{
-	struct hugepage_subpool *spool;
-
-	spool = kzalloc_obj(*spool);
-	if (!spool)
-		return NULL;
-
-	spin_lock_init(&spool->lock);
-	spool->count = 1;
-	spool->max_hpages = max_hpages;
-	spool->hstate = h;
-	spool->min_hpages = min_hpages;
-
-	if (min_hpages != -1 && hugetlb_acct_memory(h, min_hpages)) {
-		kfree(spool);
-		return NULL;
-	}
-	spool->rsv_hpages = min_hpages;
-
-	return spool;
-}
-
-void hugepage_put_subpool(struct hugepage_subpool *spool)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&spool->lock, flags);
-	BUG_ON(!spool->count);
-	spool->count--;
-	unlock_or_release_subpool(spool, flags);
-}
-
-/*
- * Subpool accounting for allocating and reserving pages.
- * Return -ENOMEM if there are not enough resources to satisfy the
- * request.  Otherwise, return the number of pages by which the
- * global pools must be adjusted (upward).  The returned value may
- * only be different than the passed value (delta) in the case where
- * a subpool minimum size must be maintained.
- */
-static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
-				      long delta)
-{
-	long ret = delta;
-
-	if (!spool)
-		return ret;
-
-	spin_lock_irq(&spool->lock);
-
-	if (spool->max_hpages != -1 &&
-	    spool->used_hpages + delta > spool->max_hpages) {
-		ret = -ENOMEM;
-		goto unlock_ret;
-	}
-
-	spool->used_hpages += delta;
-
-	/* minimum size accounting */
-	if (spool->min_hpages != -1 && spool->rsv_hpages) {
-		if (delta > spool->rsv_hpages) {
-			/*
-			 * Asking for more reserves than those already taken on
-			 * behalf of subpool.  Return difference.
-			 */
-			ret = delta - spool->rsv_hpages;
-			spool->rsv_hpages = 0;
-		} else {
-			ret = 0;	/* reserves already accounted for */
-			spool->rsv_hpages -= delta;
-		}
-	}
-
-unlock_ret:
-	spin_unlock_irq(&spool->lock);
-	return ret;
-}
-
-/*
- * Subpool accounting for freeing and unreserving pages.
- * Return the number of global page reservations that must be dropped.
- * The return value may only be different than the passed value (delta)
- * in the case where a subpool minimum size must be maintained.
- */
-static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
-				       long delta)
-{
-	long ret = delta;
-	unsigned long flags;
-
-	if (!spool)
-		return delta;
-
-	spin_lock_irqsave(&spool->lock, flags);
-
-	spool->used_hpages -= delta;
-
-	 /* minimum size accounting */
-	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
-		/*
-		 * limit is the maximum number of reservations that
-		 * can be restored to this subpool.
-		 */
-		long limit = spool->min_hpages - spool->used_hpages;
-
-		if (spool->rsv_hpages + delta <= limit)
-			ret = 0;
-		else
-			ret = spool->rsv_hpages + delta - limit;
-
-		spool->rsv_hpages += delta;
-		if (spool->rsv_hpages > limit)
-			spool->rsv_hpages = limit;
-	}
-
-	/*
-	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
-	 * quota reference, free it now.
-	 */
-	unlock_or_release_subpool(spool, flags);
-
-	return ret;
-}
-
 static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
 {
 	return subpool_inode(file_inode(vma->vm_file));
@@ -4602,7 +4452,7 @@ unsigned long hugetlb_total_pages(void)
 	return nr_total_pages;
 }
 
-static int hugetlb_acct_memory(struct hstate *h, long delta)
+int hugetlb_acct_memory(struct hstate *h, long delta)
 {
 	int ret = -ENOMEM;
 
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
new file mode 100644
index 0000000000000..b12c16aa7e4c5
--- /dev/null
+++ b/mm/hugetlb_subpool.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Subpool and reserve accounting for HugeTLB folios.
+ * Extracted from mm/hugetlb.c
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#ifdef __KERNEL__
+#include <linux/hugetlb.h>
+#endif
+#include <linux/spinlock.h>
+#include <linux/bug.h>
+
+#include "hugetlb_subpool.h"
+
+static inline bool subpool_is_free(struct hugepage_subpool *spool)
+{
+	if (spool->count)
+		return false;
+
+	return spool->used_hpages == 0;
+}
+
+static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
+						unsigned long irq_flags)
+{
+	spin_unlock_irqrestore(&spool->lock, irq_flags);
+
+	/*
+	 * If no pages are used, and no other handles to the subpool
+	 * remain, give up any reservations based on minimum size and
+	 * free the subpool.
+	 */
+	if (subpool_is_free(spool)) {
+		if (spool->min_hpages != -1)
+			hugetlb_acct_memory(spool->hstate,
+						-spool->min_hpages);
+		kfree(spool);
+	}
+}
+
+struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
+						long min_hpages)
+{
+	struct hugepage_subpool *spool;
+
+	spool = kzalloc_obj(*spool);
+	if (!spool)
+		return NULL;
+
+	spin_lock_init(&spool->lock);
+	spool->count = 1;
+	spool->max_hpages = max_hpages;
+	spool->hstate = h;
+	spool->min_hpages = min_hpages;
+
+	if (min_hpages != -1 && hugetlb_acct_memory(h, min_hpages)) {
+		kfree(spool);
+		return NULL;
+	}
+	spool->rsv_hpages = min_hpages;
+
+	return spool;
+}
+
+void hugepage_put_subpool(struct hugepage_subpool *spool)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&spool->lock, flags);
+	BUG_ON(!spool->count);
+	spool->count--;
+	unlock_or_release_subpool(spool, flags);
+}
+
+/*
+ * Subpool accounting for allocating and reserving pages.
+ * Return -ENOMEM if there are not enough resources to satisfy the
+ * request.  Otherwise, return the number of pages by which the
+ * global pools must be adjusted (upward).  The returned value may
+ * only be different than the passed value (delta) in the case where
+ * a subpool minimum size must be maintained.
+ */
+long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
+				      long delta)
+{
+	long ret = delta;
+
+	if (!spool)
+		return ret;
+
+	spin_lock_irq(&spool->lock);
+
+	if (spool->max_hpages != -1 &&
+	    spool->used_hpages + delta > spool->max_hpages) {
+		ret = -ENOMEM;
+		goto unlock_ret;
+	}
+
+	spool->used_hpages += delta;
+
+	/* minimum size accounting */
+	if (spool->min_hpages != -1 && spool->rsv_hpages) {
+		if (delta > spool->rsv_hpages) {
+			/*
+			 * Asking for more reserves than those already taken on
+			 * behalf of subpool.  Return difference.
+			 */
+			ret = delta - spool->rsv_hpages;
+			spool->rsv_hpages = 0;
+		} else {
+			ret = 0;	/* reserves already accounted for */
+			spool->rsv_hpages -= delta;
+		}
+	}
+
+unlock_ret:
+	spin_unlock_irq(&spool->lock);
+	return ret;
+}
+
+/*
+ * Subpool accounting for freeing and unreserving pages.
+ * Return the number of global page reservations that must be dropped.
+ * The return value may only be different than the passed value (delta)
+ * in the case where a subpool minimum size must be maintained.
+ */
+long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
+				       long delta)
+{
+	long ret = delta;
+	unsigned long flags;
+
+	if (!spool)
+		return delta;
+
+	spin_lock_irqsave(&spool->lock, flags);
+
+	spool->used_hpages -= delta;
+
+	 /* minimum size accounting */
+	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
+		/*
+		 * limit is the maximum number of reservations that
+		 * can be restored to this subpool.
+		 */
+		long limit = spool->min_hpages - spool->used_hpages;
+
+		if (spool->rsv_hpages + delta <= limit)
+			ret = 0;
+		else
+			ret = spool->rsv_hpages + delta - limit;
+
+		spool->rsv_hpages += delta;
+		if (spool->rsv_hpages > limit)
+			spool->rsv_hpages = limit;
+	}
+
+	/*
+	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
+	 * quota reference, free it now.
+	 */
+	unlock_or_release_subpool(spool, flags);
+
+	return ret;
+}
diff --git a/mm/hugetlb_subpool.h b/mm/hugetlb_subpool.h
new file mode 100644
index 0000000000000..be1f1cf012c9c
--- /dev/null
+++ b/mm/hugetlb_subpool.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_HUGETLB_SUBPOOL_H
+#define _MM_HUGETLB_SUBPOOL_H
+
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+struct hstate;
+struct hugepage_subpool;
+
+struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
+						long min_hpages);
+void hugepage_put_subpool(struct hugepage_subpool *spool);
+long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta);
+long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
+
+#endif /* _MM_HUGETLB_SUBPOOL_H */

-- 
2.55.0.229.g6434b31f56-goog



