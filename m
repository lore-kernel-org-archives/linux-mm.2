Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076E9CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A8F6B009F; Fri, 16 Oct 2026 06:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014B36B00A0; Fri, 16 Oct 2026 06:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A466B00A1; Fri, 16 Oct 2026 06:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7BB56B009F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:08:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0359C1402FD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:38 +0000 (UTC)
X-FDA: 85328065158.04.52054ED
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0F1C91C0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hw6pwTfK;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792145317;
	b=X+nb99JxcjRzJgSVlQuQ/2ZCxamX4G+OS6BznzzQ13M38zoff7Nh7f07gVovZSN9YW4Qm/
	3nwZDmSF6kMOWChDfmKiBvztDa8iqL0DTxwKJXlkpYqomVdC2IigPn1vJJOu1FbPDtlLbf
	cmj0wSrthEwDjihDadkRmxXbrDohgBE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hw6pwTfK;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792145317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWVcxDlFcv2lmm2MeBhkxt3evnF7lknPB7nxdvr1eLo=;
	b=1gVOa4KQqh2Y+nEeyfknTglY5hnDCisOIU70sGpxGnb69Z4nBS7oYJYjhH09basd1WqAFI
	8UKqcv1n6XRw0gGgU6tVqmbE5Q3DakHVRzU+g1Pmx7UuQsd5Lz757COp0K59O/swiE41De
	m9nC1ahdUR7uJPishYkBTzhOOCr52LQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4DSBl484xVrRS4yCKPYIq3uyqzNZ4TiuHGnnf3lGWuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792145315; v=1; x=1792750115;
 b=Hw6pwTfKgvUYpkEnS0YXuaBouiprMw4XaREIt2XLE6abnsZQpUU4J+Oha2k1dMPlINNJGivU
 m8tIfU6DbRqjXWxJDX2X/94qNfvmuZO8suo3DiWaCDsa7ATmxJu+VQZNcmc0pyJGAHOSd+hypRu
 tCvUER0/y9QGdY9eX2/XkDBE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0dae0c1d7400b4cc;
	Fri, 16 Oct 2026 10:08:35 +0000
X-Mizu-Trace-ID: 0dae0c1d7400b4cc
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 5/5] mm: hugetlb: enable CMA allocation for PMD-sized pages
Date: Fri, 16 Oct 2026 18:07:36 +0800
Message-ID: <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792136742.git.zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F1C91C0007
X-Rspam-User: 
X-Stat-Signature: c5s8w8whswsydwijquyacfaqfu5w8qs4
X-HE-Tag: 1792145316-476822
X-HE-Meta: U2FsdGVkX1+kpqDLwMDbY4tCdkruBVj63fuWlwGcizWa9oooxGpV9HOX5GoJ4TDbPCKyKUeJlMlEnoPWzghr2WcvUPFlc3E10OYhrp7JE5Sd3TdsFiWvvoi0+Qa1EVub8C15IDmCkrdqTPkjLs1T667LgZRPKmTUs9bWoF4X2VL+JFkJ2NKfg9SSnvcyg2+hwwawoJxqGfwFuAyU0oLMssaj0EVz4GURKU0firww0jD+DwzrElhh0KNo82+78ZOzpeafATJAvBsN0+vHc+v1VxKVWCsAMzinJM1dyNPXZzM3N2AP1rKb9ljLbka7SODJlc3+/S892nnvE5dAM8Ss2jjCwNVskK5KgxbAFzq8shg+JLwRRyHfCmR/MqN/K4ywVY3HPdLmGk3uINvHRhCTYrF9vP0jFdZrA3nZQN3fzInP/wPffJ3VwXXxf68tltXyENMAQ+IQg/G/akJ3Dov9raFzE1+5kpy2MXhq/vd9++ZdQ2ci8cw5QRgwegzT7dMOvh6WotOIaf31BW0ksc7sX4oa+NztJPY4PmKYIL/kPDh87cVGFGsF3qavi5Ji1nFTavSHUKVbB+pRRLGPrUJSe6+l/BA48P///DGKWcLdrDtWLfdPjF/PKbi1UvaCHm32yLohZfoBvJpc9VcCMCa1cuEH79yZijCc0+bQLdRwrGSBBC4smT9s/A7fBcqlYfN47hvDpw+drJVgHQWHTBdl+L6elHOvZTeba/Owdocr/z492agRlqOXZYEnCpZUhn0c5tMBdDXxHqx50V7uUMaQ7DHvANnLBERhm0g2f7hgdaX8S0atdmu2U5uGaJRchSQXEfJD7YEvnM7GnpAeleZIbfv/IHOkQOjsDEzxi2cYmAHVtRjuMgV6F/z/09bgaBYJFCFO9zpPHwpxh8fdfmRp2G7SLuGZ2k4iaw/z0t7G5IHvINWiiUE3AmtvjFM7tZgz9wWHHTXL5GBsoaGuUIB
 wneGYaUw
 QXpLmIW1fuwgMs3mrOoLkBxOCsqASCbJHQUPY7xRE84WJAzZFG+L6gpiwbnIno6ds4+4K1/PTyRhEsJLYXJ+hLkF4EvxXgLhaJySe83/wU6N1mFCSMF8yjPuUIRnVT3hKuheB+hrSDhOBTNAbivY2w7t6s4fJWgWOO60NQeEtpB+xBbTqGbsxhtkdtBUwNMAFB2Uo4ESPJWgJIxaqRgTMS45weg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Allow hugetlb_cma=<capacity>@<page-size> to select the architecture's PMD
size in addition to its existing CMA size. PMD pages are 2M on x86-64 and
2M, 32M or 512M on arm64 with 4K, 16K or 64K base pages.

Give PMD pages their own pool without changing the original pool's sharing
among other gigantic sizes. On arm64 with 4K base pages, 32M and 1G pages
continue to use the default 1G-aligned pool. Unsuffixed arguments and an
explicit default size still configure that same pool.

PMD requests use only the PMD pool, even when their order is gigantic.
Other gigantic requests use only the original pool. Apply this mapping
consistently to allocation, CMA-only policy and boot-time accounting.

Move CMA allocation into the common fresh HugeTLB allocation path so
non-gigantic pages can use CMA. Align reservations to both the selected
page size and CMA's minimum alignment, and use a bitmap granularity no
larger than the selected order. Keep the original CMA area names and give
PMD areas distinct names. Document the syntax and pool selection.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 .../admin-guide/kernel-parameters.txt         | 39 ++++++++++++-------
 mm/hugetlb.c                                  | 31 +++++++--------
 mm/hugetlb_cma.c                              | 26 ++++++-------
 3 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e3f25e805fea6..71cd431f07fe2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2065,31 +2065,42 @@ Kernel parameters
 			Note that this parameter only applies to non-gigantic huge pages.
 
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
-			of gigantic hugepages. Or using node format, the size
-			of a CMA area per node can be specified.
+			of hugepages. Or using node format, the size of a CMA area
+			per node can be specified.
 			The size can be an absolute value (e.g., 2G) or a
 			percentage of the total memory or node memory (e.g., 20%).
 			Percentage-derived sizes are rounded down to a multiple of
-			the architecture's gigantic hugepage size and may become
-			zero.
-			Format: nn[KMGTPE] or nn% or (node format)
-				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
-				<node>:nn%[,<node>:nn%]
-
-			The size must be a multiple of the gigantic page size.
+			the larger of the selected hugepage size and CMA's minimum
+			alignment, and may become zero.
+			Format: nn[KMGTPE][@<page-size>] or nn%[@<page-size>]
+				or (node format)
+				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]][@<page-size>] or
+				<node>:nn%[,<node>:nn%][@<page-size>]
+
+			An optional @<page-size> suffix selects the architecture's
+			default CMA hugepage size or a supported PMD size. If
+			omitted, the default is used. For node format, append
+			the suffix after the entire node list. Repeat the
+			parameter to configure the two pools independently.
+
+			The size must be aligned to both the selected hugepage
+			size and CMA's minimum alignment.
 			When using node format, this applies to each per-node size.
 			Missaligned values are dropped with a warning.
 
-			Reserve a CMA area of given size and allocate gigantic
-			hugepages using the CMA allocator. If enabled, the
-			boot-time allocation of gigantic hugepages is skipped.
+			Reserve a CMA area of given size and allocate hugepages
+			using the CMA allocator. For gigantic page sizes with a
+			reserved CMA pool, normal boot-time allocation is skipped.
+			With hugetlb_cma_only=1, early CMA allocation is used where
+			supported.
+
 
 	hugetlb_cma_only=
 			[HW,CMA,EARLY] When allocating new HugeTLB pages, only
 			try to allocate from the CMA areas.
 
-			This option does nothing if hugetlb_cma= is not also
-			specified.
+			This option only affects page sizes with a CMA pool
+			reserved by hugetlb_cma=.
 
 	hugetlb_free_vmemmap=
 			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 218fbaee6f7e5..8c00fd9d0658d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1362,18 +1362,8 @@ static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
-	struct folio *folio;
-
-	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
-	if (folio)
-		return folio;
-
-	if (hugetlb_cma_exclusive_alloc(order))
-		return NULL;
-
-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
-							  nid, nodemask);
-	return folio;
+	return (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
+							 nid, nodemask);
 }
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
@@ -1849,11 +1839,18 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	if (order_is_gigantic(order))
-		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
-	else
-		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
+	if (!folio) {
+		if (hugetlb_cma_exclusive_alloc(order))
+			return NULL;
+
+		if (order_is_gigantic(order))
+			folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
+		else
+			folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
+							 node_alloc_noretry);
+	}
+
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 9f1dfe6c2af67..9dd376979e345 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -42,8 +42,8 @@ static struct hugetlb_cma_pool *hugetlb_cma_pool(unsigned int order)
 {
 	unsigned int i;
 
-	/* Gigantic sizes share the architecture's original CMA pool. */
-	if (order_is_gigantic(order))
+	/* PMD pages use their own pool; other gigantic sizes share. */
+	if (order != PMD_SHIFT - PAGE_SHIFT && order_is_gigantic(order))
 		order = hugetlb_cma_default_order;
 
 	for (i = 0; i < hugetlb_cma_nr; i++) {
@@ -177,11 +177,13 @@ static int __init hugetlb_cma_parse(char *p)
 			pr_warn("hugetlb_cma: invalid parameter %s\n", p);
 			return -EINVAL;
 		}
-		if (!order || page_size != (PAGE_SIZE << order) ||
+		if ((page_size != PMD_SIZE &&
+		     page_size != (PAGE_SIZE << order)) ||
 		    !arch_hugetlb_valid_size(page_size)) {
 			pr_warn("hugetlb_cma: unsupported page size in %s\n", p);
 			return -EINVAL;
 		}
+		order = ilog2(page_size) - PAGE_SHIFT;
 	}
 
 	if (!order) {
@@ -340,14 +342,7 @@ static void __init hugetlb_cma_reserve_pool(struct hugetlb_cma_pool *pool,
 	if (!pool->size)
 		return;
 
-	/*
-	 * HugeTLB CMA reservation is required for gigantic
-	 * huge pages which could not be allocated via the
-	 * page allocator. Just warn if there is any change
-	 * breaking this assumption.
-	 */
-	VM_WARN_ON(order <= MAX_PAGE_ORDER);
-	hugepage_size = PAGE_SIZE << order;
+	hugepage_size = max(PAGE_SIZE << order, CMA_MIN_ALIGNMENT_BYTES);
 
 	if (config->percent) {
 		unsigned long orig_size = pool->size;
@@ -438,14 +433,19 @@ static void __init hugetlb_cma_reserve_pool(struct hugetlb_cma_pool *pool,
 			size = min(per_node, pool->size - reserved);
 		}
 
-		snprintf(name, sizeof(name), "hugetlb%d", nid);
+		if (order == hugetlb_cma_default_order)
+			snprintf(name, sizeof(name), "hugetlb%d", nid);
+		else
+			snprintf(name, sizeof(name), "hugetlb-%lukB-%d",
+				 (PAGE_SIZE << order) / SZ_1K, nid);
+
 		/*
 		 * Note that 'order per bit' is based on smallest size that
 		 * may be returned to CMA allocator in the case of
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_multi(size, hugepage_size,
-					HUGETLB_PAGE_ORDER, name,
+					min_t(unsigned int, order, HUGETLB_PAGE_ORDER), name,
 					&pool->cma[nid], nid);
 		if (res || !cma_validate_zones(pool->cma[nid])) {
 			pr_warn("hugetlb_cma: %s: err %d, node %d\n",
-- 
2.54.0


