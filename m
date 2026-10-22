Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3303B606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Dprvjl+K
Received: by kanga.kvack.org (Postfix)
	id C76456B02B3; Thu, 22 Oct 2026 03:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DEE6B02B4; Thu, 22 Oct 2026 03:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15A36B02B7; Thu, 22 Oct 2026 03:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82BFF6B02B3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:32:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6A3B120793
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:38 +0000 (UTC)
X-FDA: 85349444796.29.673CE60
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2D81A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dprvjl+K;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792654357;
	b=UWJTSr1lJHoMcZNWyZ3KG3PEmRPT0uUiJwHP3xE1kQGlD7zigvTrStuZa9fbxXRzX00m1D
	TZuP+DurFV/b/vZ13bFQGHRLpWinvNINYkOsCdP9j6Cl4fLlnw9O067rI+lqFGYYpOORfc
	POSoJYSeOOQlnQoZipSC0kEP0KQnke8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dprvjl+K;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792654357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t96VkQI1QtBR4oHBW18DVNKMMxlz6mxmTHkgR+EXUQA=;
	b=nnrKP1w+v8ffZS/Hukwx+MQiydteG40BjmQgp9Jr6T+Coh5ytUqPLRk7zRPDgXL2erOJdZ
	fC3dJiEUSk48+cGig1iHBbM3q+Ja0WSiMytDdtZ9tppgJpnmYxJHc6UQA3e2V6ZdpkTYMR
	JabW/Rmb3GVA6dVsScJVhQInBd1+gJc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IX4lDX3UPiFBBi3OMqFi2xks6o7jTO1Q2KveUJZdLoE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792654355; v=1; x=1793259155;
 b=Dprvjl+K7btLYtHWi7GpHLwvqywaLkMghRAhwwilncey2TifpQswpbEfX1sdQ78QgoK2LnAA
 QEYJw4kM8YPBUICq/eEM6TgQjrI+NDoBqqv+LJokonH/rjpufA6xnU3wOk7qtWlXvOdJxjcHmBv
 g9anrEhaUnQ7X0uqYN24Mrc0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7539dc5461ec0d7f;
	Thu, 22 Oct 2026 07:32:35 +0000
X-Mizu-Trace-ID: 7539dc5461ec0d7f
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 5/5] mm: hugetlb: enable CMA allocation for PMD-sized pages
Date: Thu, 22 Oct 2026 15:31:49 +0800
Message-ID: <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792651104.git.zhengqi.arch@bytedance.com>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E2D81A0007
X-Stat-Signature: quhicquk5js46cgbbrwzhbfxj1h77y8x
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792654356-186801
X-HE-Meta: U2FsdGVkX1+D9HJy0hJPDIofoeARhGvQHmOUvwxVIzdHNNFWWntqt9YMgyvr87uczEUusD2ftO2ItFWnxQgz0hjSqWcnVltGws+4Bna5DBsdQIxrABxTbZLEM4TQ9s+MQbyuhqRgVLV/wlx+5JnKl3x+EEMmS/1tvfi1QvmWx04P+XD96IrGfdl4xiTEZwEUee5sl0ZXyYoMPTnieD8ZbfcFyNEnoJJSfchOdVW6D4XU6sQ16OXmLuJYGMxdtDeOZl8p4tntoHxKVYXGBRPnhD2Ft7mPwNByLUbWSo2hVM5HhMjoW7siqCSDSKDKSepQVO4Obktw4Clm0xe1/+YRD+dHv+gpuVSE8gqI0JBhOzrIk3Rxuzmjz5SLQJNpbAtenqwnsuDNyfSpQthUOZhvNyHNZeJuq1snFlKXc2JGS6Fo98U21zAvdTKqASUag8aL4BTqbsuNmNTTi4acnL855z7vrGzvG8iPLIpANulhGS464cVuMDhuA4r5TONShh3Bl39qBe/Oshx5cQBqpDThokz5qUgsmt337Z2vSa5pPev+sP9z6ilt7gMD5/FH3qaPkwbdW66R9dhyvaeZOPEjdDYwamjgx/jLDMoSnxV1SvgyTlToaN57s+CiB9EqKQtKOzDAmWvRd9Q55xeQ96HbhV6w2jo6mvcXF7T3Rs1G5e0n6xN1stUES+b1OgabQ6Sk18E7x8bUu41kDhI2tIy/RuXNf7OfSADHImZKAPTlVIQynHaa8fy1a023Vi1qg5cXv1r5wW9dS9GA4qigvk0rVSvI+JcNGCAe6On8FfXTjw93RhzC3pHSzMdAOqVmEvCB+vPOoWw5aDJinr6WJj2SJDhn6TGsWLqeyklKfuHioj1hyuExOUMXMq3Q+Ko+uZPTM0/hl3TeFIeVY8GsWHK0ZMhwbNGDEBPXwnWurrTuky3cB5bn48VNU0uoE6i4iy9NgZIFKWQReJHCeWE34hk
 cUKFv7yO
 G0INCzv5m586+tuLjKPV1nG+mpPkP6Jamo4VBiqeYtETsfSwF1Z4Ou/A5lD1IpsgnymrNJLPgRIf7bXllMSmtOvrgM1b5pkiryP/teq6Kn8LH4MO1yZ6wwmNf0oUF4L+jzs14GyV4YeVpSc5SXHw1vMVUmGO6XeMqXUsoYRywfO++4428DEHIs9h6nFx4nRoqc0PMQZo2RR445UZNn1NP38nUlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Allow hugetlb_cma=<capacity>@<page-size> to select the architecture's PMD
size in addition to its existing CMA size. PMD pages are 2M on x86-64 and
2M, 32M or 512M on arm64 with 4K, 16K or 64K base pages.

Give PMD pages their own pool while preserving the existing sharing among
gigantic sizes. Unsuffixed arguments and an explicit default size continue
to configure the default pool. Gigantic PMD sizes retain access to that
pool when no PMD pool is reserved. Apply this mapping consistently to
allocation, CMA-only policy and boot-time accounting.

Try buddy allocation first for non-gigantic PMD pages, with CMA as a
fallback, to reduce CMA migration and leave CMA capacity for later
allocations. Preserve CMA-only policy and CMA-first allocation for
gigantic pages.

Align reservations to both the selected page size and CMA's minimum
alignment, and use a bitmap granularity no larger than the selected order.
Keep the original CMA area names and give PMD areas distinct names.
Document the syntax and pool selection.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 .../admin-guide/kernel-parameters.txt         | 40 ++++++++++++-------
 mm/hugetlb.c                                  | 18 ++++-----
 mm/hugetlb_cma.c                              | 22 +++++-----
 3 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index c06cb660a3ce4..0cc77e648f396 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2065,31 +2065,43 @@ Kernel parameters
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
+			For CMA allocation, PMD pages use the PMD pool if reserved.
+			Otherwise, gigantic PMD pages use the default pool. Other
+			gigantic page sizes always share the default pool.
+
+			The size must be aligned to both the selected hugepage
+			size and CMA's minimum alignment.
 			When using node format, this applies to each per-node size.
 			Missaligned values are dropped with a warning.
 
-			Reserve a CMA area of given size and allocate gigantic
-			hugepages using the CMA allocator. If enabled, the
-			boot-time allocation of gigantic hugepages is skipped.
+			For gigantic page sizes with a reserved CMA pool, normal
+			boot-time allocation is skipped. With hugetlb_cma_only=1,
+			early CMA allocation is used where supported.
 
 	hugetlb_cma_only=
 			[HW,CMA,EARLY] When allocating new HugeTLB pages, only
 			try to allocate from the CMA areas.
 
-			This option does nothing if hugetlb_cma= is not also
-			specified.
+			This option only affects page sizes with a CMA pool
+			successfully reserved by hugetlb_cma=.
 
 	hugetlb_free_vmemmap=
 			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c1a8d00be11ac..bad5cd4978c5e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1835,22 +1835,20 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 {
 	struct folio *folio = NULL;
 	int order = huge_page_order(h);
+	bool cma_only = hugetlb_cma_exclusive_alloc(order);
 
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	if (allow_cma && order_is_gigantic(order))
+	if (!order_is_gigantic(order) && !cma_only)
+		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
+						 node_alloc_noretry);
+
+	if (!folio && allow_cma)
 		folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
-	if (!folio) {
-		if (hugetlb_cma_exclusive_alloc(order))
-			return NULL;
 
-		if (order_is_gigantic(order))
-			folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
-		else
-			folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-							 node_alloc_noretry);
-	}
+	if (!folio && order_is_gigantic(order) && !cma_only)
+		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 
 	if (folio)
 		init_new_hugetlb_folio(folio);
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index c279c3f548705..5071f0ae012bd 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -180,11 +180,13 @@ static int __init hugetlb_cma_parse(char *p)
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
@@ -339,14 +341,7 @@ static void __init hugetlb_cma_reserve_pool(struct hugetlb_cma_pool *pool,
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
@@ -437,14 +432,19 @@ static void __init hugetlb_cma_reserve_pool(struct hugetlb_cma_pool *pool,
 			size = min(per_node, pool->size - reserved);
 		}
 
-		snprintf(name, sizeof(name), "hugetlb%d", nid);
+		if (pool == &hugetlb_cma[HUGETLB_CMA_DEFAULT])
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


