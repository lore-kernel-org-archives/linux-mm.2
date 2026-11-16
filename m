Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A11C606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VuyMD/d2
Received: by kanga.kvack.org (Postfix)
	id 592F86B05BB; Mon, 16 Nov 2026 02:14:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A586B05BC; Mon, 16 Nov 2026 02:14:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458F86B05BD; Mon, 16 Nov 2026 02:14:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25E936B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7997808EE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:24 +0000 (UTC)
X-FDA: 85440118848.26.1CBAC73
Received: from mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	by imf09.hostedemail.com (Postfix) with ESMTP id C1456140009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VuyMD/d2";
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8vTH4ZwG/2DWs42qtrHbGL6SaYihVYpzXL05YW5oBw=;
	b=Gg9tjF7Jz2VHzBQ7mC2ujNxHdvXxLZLQ5NB4abbx9FkGsXE5sO5J85A4DBRgPCwUrvrJYl
	bNq38WhaO8GNf1lOu5RO/ZnlnWs6rTJ0Ae2aEdKpZMSJExrDD6nIV5Nwq92En8XtwCtdhr
	Grva3JnGhUpB9yQnmUJLQn+OMkXC2nA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813263;
	b=I2x+uuvmduhdA0fXLRP1ZQbwuXrB1Zr67fUi1LaJkKO4Mjgj/26Wl3MzGtw+7MgaIRr1P3
	FCsGGE9dF61lW7pUGeBt/bhNmwljO0nIiBzO/HWwHzXS6lCYNL/6nBaFVEDV067yoMwEZT
	itCtMPnq3NjN8JgCvD1JfNAs47mIW8M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VuyMD/d2";
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZK0HyZRkuJf6PUVCzsSx26r+AdupLQhc4IQDUdlGHx8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813261; v=1; x=1795418061;
 b=VuyMD/d2FNS1xfFGffpEoXLYVZOHRJHoksYj3ncxI4GngvkPOXcE3xO4g0EwHAAAXruYRGqb
 vMkJtMsMiUUbty62kzy5AwvUpwK8KcXgyJd4Jko7YhXUYq5zFyeSKfzGwFOO9wNoOzcC3vKLosv
 2rQp85uxhVs9eQU+LwfP9ABs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6aca88df114c26b4;
	Mon, 16 Nov 2026 07:14:21 +0000
X-Mizu-Trace-ID: 6aca88df114c26b4
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 07/11] mm/vmalloc: undo what __vmap_pages_range_noflush() mapped on failure
Date: Mon, 16 Nov 2026 15:13:21 +0800
Message-Id: <20261116071325.263682-8-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gkoyxwiuu9zq8ufzhj1nj9rysh1oiuqw
X-Rspamd-Queue-Id: C1456140009
X-Rspam-User: 
X-HE-Tag: 1794813262-855401
X-HE-Meta: U2FsdGVkX18aKu4OBj0XQRlwXGSSDgu61uDB3l1Yb9QfO0eNqndSxKuKKFSIL2oKLcdX5OgeWUtgjdDrUxUMgE7ku0Qs37IP7DfiYdBlb9s4rqWo9t5lkakIxNKLs5wlwH9x8p4m9LneddE7ij0N3Ng2bMwX7f3n6pVGEpykDXU/A3M8mAXzubD3pvvqqH06TBFAe7vMjkFNEikAxHp0dy9SIwXbzGRgLxAYybLIhRd+2nJlwaltBFBCbjvRvr8kCmD1A/2hag9CiRvcPH4FiZJkdlXSifDmF5yBBxKWixwuaZRNx481/OgFyw3+LIOcRnuWQzvAPCs7aVmlx6rLjoPCZPRQmTf+Rv4/B/2HBiasQpvkBkJQWc6SgRvC4t3S+h4s6n3bIvcQ94sUiK+5ZfqWgToVUs5XTgPXQOFu8K98j4w2XeQkzSbsDLEq7QZ7NOA8nW/QktJRcF3ao1XTzVuAUYAoLWEG5j6FBr2o7tJ3/wOV6Ny4hTT9lOeToL8+6rSZru642++wjb6mSsrRSAUkDYRHvE5gGklsitNfOcgakkEhiyxU6EWA9c74+fHYHiR55MI0+bRSsC8vbwG/B/T+THGRePzye5rjGRKfJYBL5+8WMpvGLdBXWRiaxWyxtu7YCpSSD2nn4mKFDOExX3BitsbdZf5JooWCbT7Wls0/YskZcO+Izn2gK8BLeJ4XzQC/CcyNwrNluIiwpKhJ533TjojVSR/NftJGGxb84S4VCF5LLi+pQw3G6MLoVmOA49PVAeAY1DMQ/0yEmmvwS/VeMMPhC5TY7fNTKjG04vWmvIC4sqGk+44cV2h74cpbacO6w6Mh0GIQ9MMqPGvqzSklA+KCWh9Le+5RNIl/8kMlUe7p4jS3wmpk8GxQhmucjE7Q/EWGuTcaZxjx4BBOEfKcnKaCxGYKBtn3fsgb7o0+p4TqQku7slhPBmQaZQnK+2IdyYqu+tQKW84Tv4G
 7BLhPN79
 kIkLNcT/kvBMx1oAXXkSIA5k7ylpmUyT95kKb8ffPu72LpzawJ5s7XfJlzT2tyTxlQwgmDJ0YpZ9FfrQCJv7ScUDLdL2an5eeEGvj1IB5QIC7cNLrq5VETUcVLdULhbKlHOFoj3zCVRb/D4vCZl3//EQPNvVkzMAz6s4HIfvml9QIn30hP2o1xA3lPIbaifBbFtMvBJrxUS4YnioR4ApC0WJQVcKSJ8CdnAj/OJK6MOE5hIUsz7CpNyWTD1h+2vxuduKSSe3d67btmOx913IAU3u2sKl0JezhIhQhjtj6YGkPKPTBNQUySbxdYKxZgMCfRqTVKCWGnQbnZw8PwEPQmIvuzGWyqNMPXsEjlL1b1foLxH1WugYERDOjBs7fuyonMUpM3eSyZ2+oofw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__vmap_pages_range_noflush() maps a struct page array and may fail
half way. The ptes installed so far stay behind, so a retry of the
same range, the __GFP_NOFAIL loop in __vmalloc_area_node() or the
module tags populate, trips the WARN_ON(!pte_none()) in
vmap_pages_pte_range() and fails with -EBUSY.

vmap_pages_range_noflush_walk() now reports how many pages it
installed through its running index into the pages array, and
__vmap_pages_range_noflush() undoes [addr, addr + mapped_pages *
PAGE_SIZE) on failure. vmap_pages_pte_range() fails with -EBUSY
instead of installing over a pte that is already set, so the ptes
below that point are all ours, while a pte above it can only have
been put there by somebody else, for example when the caller's range
overlaps an existing mapping. Going further would clear ptes that
are not ours.

This path can run with a non-blocking gfp mask, the undo passes
gfpflags_allow_blocking() as can_resched.

Suggested-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/hooks.c  |  4 ++--
 mm/kmsan/shadow.c |  4 ++--
 mm/vmalloc.c      | 36 +++++++++++++++++++++++++++++-------
 mm/vmalloc.h      |  3 ++-
 4 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 69008b085658..d830a4e649f1 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -208,7 +208,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 		mapped = __vmap_pages_range_noflush(
 			vmalloc_shadow(start + off),
 			vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
-			PAGE_SHIFT);
+			PAGE_SHIFT, gfp_mask);
 		if (mapped) {
 			err = mapped;
 			goto ret;
@@ -218,7 +218,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 		mapped = __vmap_pages_range_noflush(
 			vmalloc_origin(start + off),
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
-			PAGE_SHIFT);
+			PAGE_SHIFT, gfp_mask);
 		if (mapped) {
 			err = mapped;
 			goto ret;
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 212449db34a1..452760a333e4 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -247,7 +247,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 	origin_end = vmalloc_meta((void *)end, KMSAN_META_ORIGIN);
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
-					    s_pages, page_shift);
+					    s_pages, page_shift, gfp_mask);
 	kmsan_leave_runtime();
 	if (mapped) {
 		err = mapped;
@@ -255,7 +255,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 	}
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
-					    o_pages, page_shift);
+					    o_pages, page_shift, gfp_mask);
 	kmsan_leave_runtime();
 	if (mapped) {
 		/* Undo the shadow mapping set up above. */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5c1eacc2a0ac..4f3c320a4849 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -725,7 +725,8 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
  * may have contiguous chunks, as hinted by @shift.
  */
 static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int shift)
+		pgprot_t prot, struct page **pages, unsigned int shift,
+		unsigned int *mapped_pages)
 {
 	unsigned long start = addr;
 	pgd_t *pgd;
@@ -748,6 +749,7 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
+	*mapped_pages = nr;
 	return err;
 }
 
@@ -758,18 +760,36 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
  * The caller is responsible for calling flush_cache_vmap() after this
  * function returns successfully and before the addresses are accessed.
  *
+ * On failure the PTEs installed by this call are torn down before
+ * returning, so a retry sees a clean range; PTEs that were already
+ * there when the walk failed are left alone. When @gfp_mask cannot
+ * block, the teardown skips cond_resched(), it may run in atomic
+ * context.
+ *
  * This is an internal function only. Do not use outside mm/.
  */
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int page_shift)
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
 {
+	int err;
+	unsigned int mapped_pages = 0;
+
 	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
 		page_shift = PAGE_SHIFT;
 
-	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
+	err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift,
+					    &mapped_pages);
+
+	/* Undo the PTEs installed before the failure. */
+	if (err && mapped_pages)
+		__vunmap_range_noflush(addr, addr + (mapped_pages * PAGE_SIZE),
+				       gfpflags_allow_blocking(gfp_mask));
+
+	return err;
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
@@ -781,7 +801,8 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
+					  gfp_mask);
 }
 
 static int __vmap_pages_range(unsigned long addr, unsigned long end,
@@ -3715,7 +3736,7 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages)
 {
 	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
-	unsigned int prev_shift = 0, batch_idx = 0;
+	unsigned int prev_shift = 0, batch_idx = 0, nr_mapped;
 	unsigned long batch_start = addr, batch_end = addr;
 	int err;
 
@@ -3734,7 +3755,8 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 
 		if (shift != prev_shift) {
 			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
-					prot, pages + batch_idx, prev_shift);
+					prot, pages + batch_idx, prev_shift,
+					&nr_mapped);
 			if (err)
 				goto out;
 			prev_shift = shift;
@@ -3756,7 +3778,7 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	/* Remaining */
 	if (batch_start < end)
 		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
-				pages + batch_idx, prev_shift);
+				pages + batch_idx, prev_shift, &nr_mapped);
 
 out:
 	if (!err)
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index 4ec114a75f04..9ea28845f713 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -40,7 +40,8 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
 
 int __must_check __vmap_pages_range_noflush(unsigned long addr,
 		unsigned long end, pgprot_t prot,
-		struct page **pages, unsigned int page_shift);
+		struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask);
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
-- 
2.25.1


