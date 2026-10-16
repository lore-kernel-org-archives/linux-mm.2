Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD82CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0506B0096; Fri, 16 Oct 2026 06:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A13C6B0098; Fri, 16 Oct 2026 06:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F7F6B0099; Fri, 16 Oct 2026 06:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27FE36B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:08:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF520C032D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:19 +0000 (UTC)
X-FDA: 85328064318.21.BCFA4A1
Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC2A11C0009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dn7lLlAN;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792145298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8jxwNR8+rED1mkwkAROnmlRzdaU5ijTrai6+L19GRU=;
	b=nf0a49W4/P2DwGV2th2KI1+v9qP6L/Kqqz0kvGb+XdQ3GYaLO9MEzBc/F9zHijmoUITAph
	qRa1cpxb0dZg97Ujla/B3utTa9Qlms0d16Wy9Cq7dWx+4HixeRWfQa4Za68HvMdJL2lRby
	lcdq67R1Dvyq2pHAdnoc85cFK36T32U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dn7lLlAN;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792145298;
	b=txfgZIhGeEg30bGXnWIzVP7nZgxeJj+C5a3xYfhUEID/4k19gVx09Wyc0zre6PnL5yyhjo
	X0fdcQSNGHCIPWH60ZuYNxFIlzBqgVHxDj0aMoJrWaV0KshQnhhcyw1seIRLMjwwdMZryZ
	1EOlZwxcTL4ONgTYdcAmz99vLqqDBEk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vFXvpqTON00YO7LfvdDshNdI/kJ41BB016pc3EbYSxk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792145296; v=1; x=1792750096;
 b=dn7lLlANdMIwk0n01EI6r8spRut9V4UNgCeGFbdxD8Jp/UyFq9AL6UuyloorMVc+JTGsGQNb
 Mg+UA9e8qE2MZoJ0DYvU+vuL35mybi0W19xHmrAT3ZQuWbhz2G4xQ/fH//wKdD7u16hRXb/zAOD
 VU1pPo6UGaSQkq77RiPLRJ7M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 49719a37e359c778;
	Fri, 16 Oct 2026 10:08:16 +0000
X-Mizu-Trace-ID: 49719a37e359c778
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 2/5] mm: hugetlb: group CMA pool and reservation state
Date: Fri, 16 Oct 2026 18:07:33 +0800
Message-ID: <100b5e1400e692086b1af70e88732faa5a638be1.1792136742.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792136742.git.zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC2A11C0009
X-Rspam-User: 
X-Stat-Signature: zkpmu88o9odx5fhpoed4gpht5c76mccy
X-HE-Tag: 1792145297-165198
X-HE-Meta: U2FsdGVkX1+NLnorTr0ewWuIvie0CT4tOpfc6UV5ovMuC58pKLm3P6PZE3kv30p5Jp35Q2/klyduqqigT94Z8lqMk0E8rn+AfHBx13Yln/OTGpGmJhjx/iN7NS5egni/SnELOsIKP2FAGVqV1g0fsjmviPzgLG34zTVB8Ti/wXrCWrNHjWszJh5jF87wLt4p3CakUc794IV17GYJqGg0l2fmUk66DRx9n1uu2zOVomrHtDc8Vwit/vhvSwrY9WBJRdwuXQoWTc6+hxSFrbpv/lrr7ZfDgW9oX+YxAsdc9G/BL9Q9ftWU7nFKhBs4+C5fAtdpvEOCd9ECiR2eUaU3CXW5kB+KM7mLbL/BcQBpq8SNmtnqgb/UCUbHMd7Vmff2HPTSenmBBPTyCJSnMkJQHbpUp/6iJJ8W/NYoQDUqMYUhIaEn/PrJaOq+W+XpbRoDD/d6asRLg1RwZo8SCx39rmJknU59aovUzqCKNlPrA8GUT6nzGoR392+FqMtPK5KDVXE+UFk9XcIYzWdiVeKRE+1AYQg8MN0Xaqbx7SRyVh6PprQRpfD3lzav7CFtc45OBW92h8zzXF/Gj40mE3MMeJT5qliDaNfKModrGf5dMPO4iyIuTd8mL0K3xgbYPtJb5oF4XX2GFWqzhDCg86x5m3X0xjae0G/Z8DA8+QY71EtJK6bOL0diWkoSwj2rV1unbsj0vwaWNca8kKMermmJpSVWGVWPC1Obvrv9NjAfVZpbqWiSgubIUa84Jj4QHHL/v0K2GwAJP2VC9mU+zhzJa/kL87PHy8YyVQxYj/uJvIovP7o6UYiGRBP+Qf5RbdO/ofifLVXvVclCSrw3Wk/ObcmnNwyh0sEYoiAlTKQgybckMakHufQjmW+tBWWhr9rV42j62hyRVQQ/umo+C4SxtHlXOCzodNmGsneXyI7CY7fupwLIY0URlyBo85Bfm5cAvCcaxD1rwhDJutFET9c
 5ujKo4E4
 AkdILJVvjI/V1LqAflgFMxCsiR/s+wvE9L25Y81kdX7sVDe89IIfLKcWDZ0uBYwcDGjsB1/KZC9hjSI5bNH0Yu9ShAXvYT1Q+5kyF6ZO+gd1IMrYWdnTZZxYwjVNBr7bCb6PHCuZpHEQ4KkE1BYxuqxk5T+O66W4VLgc8jReR3K8I59m2su2rgjeFSUWABRIUq2L0tcYb+m9GrNmZXGWAcuCONw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The HugeTLB CMA areas, total size, per-node sizes and percentages are
stored in separate singleton variables. Group the runtime areas and
size into a pool, and the temporary reservation inputs into a separate
configuration structure.

Keep one instance of each structure and preserve the existing parsing,
reservation and allocation behavior. This separates the mechanical state
conversion from adding support for multiple page orders.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb_cma.c | 163 ++++++++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 74 deletions(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index a17d32fa5ebb3..4f27eb242dc3b 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -16,14 +16,21 @@
 #include "internal.h"
 #include "hugetlb_cma.h"
 
+struct hugetlb_cma_pool {
+	struct cma *cma[MAX_NUMNODES];
+	unsigned long size;
+};
 
-static struct cma *hugetlb_cma[MAX_NUMNODES] __ro_after_init;
-static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
-static bool hugetlb_cma_only __ro_after_init;
-static unsigned long hugetlb_cma_size __ro_after_init;
+struct hugetlb_cma_config {
+	unsigned long size_in_node[MAX_NUMNODES];
+	unsigned int percent;
+	unsigned int percent_in_node[MAX_NUMNODES];
+};
+
+static struct hugetlb_cma_pool hugetlb_cma __ro_after_init;
+static struct hugetlb_cma_config hugetlb_cma_config __initdata;
 
-static unsigned int hugetlb_cma_percent __initdata;
-static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
+static bool hugetlb_cma_only __ro_after_init;
 
 static char hugetlb_cma_cmdline[COMMAND_LINE_SIZE] __initdata;
 static unsigned int hugetlb_cma_cmdline_len __initdata;
@@ -49,7 +56,9 @@ static phys_addr_t __init memblock_node_memory_size(int nid)
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
-	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
+	struct hugetlb_cma_pool *pool = &hugetlb_cma;
+
+	WARN_ON_ONCE(!cma_release_frozen(pool->cma[folio_nid(folio)],
 					 &folio->page, folio_nr_pages(folio)));
 }
 
@@ -61,8 +70,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	struct page *page = NULL;
 	const nodemask_t *nmask;
 	unsigned int cpuset_mems_cookie;
+	struct hugetlb_cma_pool *pool = &hugetlb_cma;
 
-	if (!hugetlb_cma_size)
+	if (!pool->size)
 		return NULL;
 
 retry_cpuset:
@@ -73,15 +83,15 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 		nmask = nodemask;
 	}
 
-	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+	if (pool->cma[nid] && node_isset(nid, *nmask))
+		page = cma_alloc_frozen_compound(pool->cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nmask) {
-			if (node == nid || !hugetlb_cma[node])
+			if (node == nid || !pool->cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(pool->cma[node], order);
 			if (page)
 				break;
 		}
@@ -101,17 +111,18 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 
 void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
+	struct hugetlb_cma_pool *pool = &hugetlb_cma;
 	struct cma *cma;
 	void *m;
 	int node;
 
-	cma = hugetlb_cma[nid];
+	cma = pool->cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
 	if (m || node_exact)
 		return m;
 
 	for_each_node_mask(node, hugetlb_bootmem_nodes) {
-		cma = hugetlb_cma[node];
+		cma = pool->cma[node];
 		if (!cma || node == nid)
 			continue;
 		m = cma_reserve_early(cma, huge_page_size(h));
@@ -124,6 +135,8 @@ void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exa
 
 static int __init hugetlb_cma_parse(char *p)
 {
+	struct hugetlb_cma_pool *pool = &hugetlb_cma;
+	struct hugetlb_cma_config *config = &hugetlb_cma_config;
 	int nid, count = 0;
 	unsigned long tmp;
 	char *s = p;
@@ -157,8 +170,8 @@ static int __init hugetlb_cma_parse(char *p)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
-			hugetlb_cma_size = 0;
-			hugetlb_cma_percent = 0;
+			pool->size = 0;
+			config->percent = 0;
 
 			s += count + 1;
 			tmp = memparse(s, &next);
@@ -168,12 +181,12 @@ static int __init hugetlb_cma_parse(char *p)
 						tmp, nid);
 					break;
 				}
-				hugetlb_cma_percent_in_node[nid] = tmp;
-				hugetlb_cma_size_in_node[nid] = 0;
+				config->percent_in_node[nid] = tmp;
+				config->size_in_node[nid] = 0;
 				s = next + 1;
 			} else {
-				hugetlb_cma_size_in_node[nid] = tmp;
-				hugetlb_cma_percent_in_node[nid] = 0;
+				config->size_in_node[nid] = tmp;
+				config->percent_in_node[nid] = 0;
 				s = next;
 			}
 
@@ -193,19 +206,19 @@ static int __init hugetlb_cma_parse(char *p)
 				if (tmp > 100) {
 					pr_warn("hugetlb_cma: invalid percentage %lu\n", tmp);
 				} else {
-					hugetlb_cma_percent = tmp;
-					hugetlb_cma_size = 0;
+					config->percent = tmp;
+					pool->size = 0;
 					for (nid = 0; nid < MAX_NUMNODES; nid++) {
-						hugetlb_cma_size_in_node[nid] = 0;
-						hugetlb_cma_percent_in_node[nid] = 0;
+						config->size_in_node[nid] = 0;
+						config->percent_in_node[nid] = 0;
 					}
 				}
 			} else {
-				hugetlb_cma_size = tmp;
-				hugetlb_cma_percent = 0;
+				pool->size = tmp;
+				config->percent = 0;
 				for (nid = 0; nid < MAX_NUMNODES; nid++) {
-					hugetlb_cma_size_in_node[nid] = 0;
-					hugetlb_cma_percent_in_node[nid] = 0;
+					config->size_in_node[nid] = 0;
+					config->percent_in_node[nid] = 0;
 				}
 			}
 			break;
@@ -245,6 +258,8 @@ unsigned int __weak arch_hugetlb_cma_order(void)
 
 void __init hugetlb_cma_reserve(void)
 {
+	struct hugetlb_cma_pool *pool = &hugetlb_cma;
+	struct hugetlb_cma_config *config = &hugetlb_cma_config;
 	unsigned long size, reserved, per_node, order, gigantic_page_size;
 	bool node_specific_cma_alloc = false;
 	bool has_node_specific_param = false;
@@ -257,33 +272,33 @@ void __init hugetlb_cma_reserve(void)
 		hugetlb_cma_parse(p);
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
-		if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
+		if (config->size_in_node[nid] || config->percent_in_node[nid]) {
 			has_node_specific_param = true;
 			break;
 		}
 	}
 
 	if (has_node_specific_param) {
-		hugetlb_cma_size = 0;
+		pool->size = 0;
 		for (nid = 0; nid < MAX_NUMNODES; nid++) {
-			if (hugetlb_cma_percent_in_node[nid]) {
+			if (config->percent_in_node[nid]) {
 				phys_addr_t node_gfp_mem = memblock_node_memory_size(nid);
 				u64 s;
 
 				s = mul_u64_u32_div((u64)node_gfp_mem,
-						    hugetlb_cma_percent_in_node[nid],
+						    config->percent_in_node[nid],
 						    100);
 
-				hugetlb_cma_size_in_node[nid] = s;
+				config->size_in_node[nid] = s;
 			}
-			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+			pool->size += config->size_in_node[nid];
 		}
-	} else if (hugetlb_cma_percent) {
-		hugetlb_cma_size = mul_u64_u32_div((u64)memblock_phys_mem_size(),
-						   hugetlb_cma_percent, 100);
+	} else if (config->percent) {
+		pool->size = mul_u64_u32_div((u64)memblock_phys_mem_size(),
+						   config->percent, 100);
 	}
 
-	if (!hugetlb_cma_size)
+	if (!pool->size)
 		return;
 
 	order = arch_hugetlb_cma_order();
@@ -301,36 +316,36 @@ void __init hugetlb_cma_reserve(void)
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 	gigantic_page_size = PAGE_SIZE << order;
 
-	if (hugetlb_cma_percent) {
-		unsigned long orig_size = hugetlb_cma_size;
+	if (config->percent) {
+		unsigned long orig_size = pool->size;
 
-		hugetlb_cma_size = ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << order);
-		if (orig_size && !hugetlb_cma_size)
+		pool->size = ALIGN_DOWN(pool->size, PAGE_SIZE << order);
+		if (orig_size && !pool->size)
 			pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%)\n",
-				orig_size / SZ_1M, hugetlb_cma_percent);
+				orig_size / SZ_1M, config->percent);
 	} else if (has_node_specific_param) {
-		hugetlb_cma_size = 0;
+		pool->size = 0;
 		for (nid = 0; nid < MAX_NUMNODES; nid++) {
-			if (hugetlb_cma_percent_in_node[nid]) {
-				unsigned long orig_size = hugetlb_cma_size_in_node[nid];
+			if (config->percent_in_node[nid]) {
+				unsigned long orig_size = config->size_in_node[nid];
 
-				hugetlb_cma_size_in_node[nid] =
-					ALIGN_DOWN(hugetlb_cma_size_in_node[nid],
+				config->size_in_node[nid] =
+					ALIGN_DOWN(config->size_in_node[nid],
 						   PAGE_SIZE << order);
-				if (orig_size && !hugetlb_cma_size_in_node[nid])
+				if (orig_size && !config->size_in_node[nid])
 					pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%) on node %d\n",
 						orig_size / SZ_1M,
-						hugetlb_cma_percent_in_node[nid],
+						config->percent_in_node[nid],
 						nid);
 			}
-			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+			pool->size += config->size_in_node[nid];
 		}
 	}
 
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
-		size = hugetlb_cma_size_in_node[nid];
+		size = config->size_in_node[nid];
 		if (size == 0)
 			continue;
 
@@ -344,18 +359,18 @@ void __init hugetlb_cma_reserve(void)
 			continue;
 		}
 
-		hugetlb_cma_size -= size;
-		hugetlb_cma_size_in_node[nid] = 0;
+		pool->size -= size;
+		config->size_in_node[nid] = 0;
 	}
 
 	/* Validate the CMA size again in case some invalid nodes specified. */
-	if (!hugetlb_cma_size)
+	if (!pool->size)
 		return;
 
-	if (!IS_ALIGNED(hugetlb_cma_size, gigantic_page_size)) {
+	if (!IS_ALIGNED(pool->size, gigantic_page_size)) {
 		pr_warn("hugetlb_cma: cma area must be a multiple of %lu MiB\n",
 			gigantic_page_size / SZ_1M);
-		hugetlb_cma_size = 0;
+		pool->size = 0;
 		return;
 	}
 
@@ -364,16 +379,16 @@ void __init hugetlb_cma_reserve(void)
 		 * If 3 GB area is requested on a machine with 4 numa nodes,
 		 * let's allocate 1 GB on first three nodes and ignore the last one.
 		 */
-		per_node = DIV_ROUND_UP(hugetlb_cma_size,
+		per_node = DIV_ROUND_UP(pool->size,
 					nodes_weight(hugetlb_bootmem_nodes));
 		per_node = round_up(per_node, gigantic_page_size);
-		if (hugetlb_cma_percent)
+		if (config->percent)
 			pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up to %lu MiB per node\n",
-				hugetlb_cma_size / SZ_1M, hugetlb_cma_percent,
+				pool->size / SZ_1M, config->percent,
 				per_node / SZ_1M);
 		else
 			pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
-				hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+				pool->size / SZ_1M, per_node / SZ_1M);
 	}
 
 	reserved = 0;
@@ -382,12 +397,12 @@ void __init hugetlb_cma_reserve(void)
 		char name[CMA_MAX_NAME];
 
 		if (node_specific_cma_alloc) {
-			if (hugetlb_cma_size_in_node[nid] == 0)
+			if (config->size_in_node[nid] == 0)
 				continue;
 
-			size = hugetlb_cma_size_in_node[nid];
+			size = config->size_in_node[nid];
 		} else {
-			size = min(per_node, hugetlb_cma_size - reserved);
+			size = min(per_node, pool->size - reserved);
 		}
 
 		snprintf(name, sizeof(name), "hugetlb%d", nid);
@@ -398,33 +413,33 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		res = cma_declare_contiguous_multi(size, gigantic_page_size,
 					HUGETLB_PAGE_ORDER, name,
-					&hugetlb_cma[nid], nid);
-		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
+					&pool->cma[nid], nid);
+		if (res || !cma_validate_zones(pool->cma[nid])) {
 			pr_warn("hugetlb_cma: %s: err %d, node %d\n",
 				res ? "reservation failed" : "reserved area spans zones",
 				res, nid);
-			hugetlb_cma[nid] = NULL;
+			pool->cma[nid] = NULL;
 			continue;
 		}
 
 		reserved += size;
-		if (hugetlb_cma_percent_in_node[nid])
+		if (config->percent_in_node[nid])
 			pr_info("hugetlb_cma: reserved %lu MiB (%u%%) on node %d\n",
-				size / SZ_1M, hugetlb_cma_percent_in_node[nid], nid);
+				size / SZ_1M, config->percent_in_node[nid], nid);
 		else
 			pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
 				size / SZ_1M, nid);
 
-		if (reserved >= hugetlb_cma_size)
+		if (reserved >= pool->size)
 			break;
 	}
 
 	if (!reserved)
 		/*
-		 * hugetlb_cma_size is used to determine if allocations from
+		 * pool->size is used to determine if allocations from
 		 * cma are possible.  Set to zero if no cma regions are set up.
 		 */
-		hugetlb_cma_size = 0;
+		pool->size = 0;
 }
 
 bool hugetlb_cma_exclusive_alloc(void)
@@ -434,12 +449,12 @@ bool hugetlb_cma_exclusive_alloc(void)
 
 unsigned long __init hugetlb_cma_total_size(void)
 {
-	return hugetlb_cma_size;
+	return hugetlb_cma.size;
 }
 
 void __init hugetlb_cma_validate_params(void)
 {
-	if (!hugetlb_cma_size)
+	if (!hugetlb_cma.size)
 		hugetlb_cma_only = false;
 }
 
-- 
2.54.0


