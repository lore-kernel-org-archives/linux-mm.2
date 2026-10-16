Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4184FCCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2356E6B0098; Fri, 16 Oct 2026 06:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212E26B0099; Fri, 16 Oct 2026 06:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4506B009B; Fri, 16 Oct 2026 06:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C00C56B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:08:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B82C0A0333
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:24 +0000 (UTC)
X-FDA: 85328064528.14.AA16DC6
Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	by imf07.hostedemail.com (Postfix) with ESMTP id C045140006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M09KK9+Y;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792145303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+eJ19vrp6ZLYCSeajjRkflgd6UcAPd1W/o5gl94xRs=;
	b=HHmWJo1z82r3p3WhvBgv4BvlGxp1UJa9x1NBfbjfyaEQdLmrl4t/iqjKOh/gl57paraYqk
	YhNkphbz6sz1rDWymjPSpeZ1BuHiUix37i67zAKBeRZfxFFY03CaUMP+4XlOPnkZ+j6IcJ
	oeZuO94JuzNU7XMJ+YT0XEMThmZgiFI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M09KK9+Y;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792145303;
	b=inUKSXzCB88rV5ubkJqY1I4EF9dG6wzUkm3l5+ck4U6ubJR9sgp+IB3ri0Ht15Kju2fMso
	gn2mmqFmmnXVvuC6AnlsIJt2nlyh3C0XqVWuDg7ej5hXUE4a1vEq86YmBgg0+yQ1N4f0I7
	UXinOZj6cJRX/3k9o+vgVXDVqQdKHtA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2uRw2+n1CHmqrh0TXBLIKbgmX24s7o46A04u/aBddaU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792145301; v=1; x=1792750101;
 b=M09KK9+YpJXBh8rRkPVhIy1dUf7bd5FUju1gkZwG9/oz5dMNWKbCu4gbyIz03VcxrIzvX+8c
 RR73tEYtP9ucVRCygEcsHvsqpojfyjQXpoLpyfTQzSaL39xhgr+VMd7aKLqJuTZBoHwNUW2saaO
 V9AsEIQ44WKwZJQyCUvZd9Cc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 61d30523d445ad60;
	Fri, 16 Oct 2026 10:08:21 +0000
X-Mizu-Trace-ID: 61d30523d445ad60
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 3/5] mm: hugetlb: track CMA reservations by page order
Date: Fri, 16 Oct 2026 18:07:34 +0800
Message-ID: <57cd5cac5e2749cba24c502bcd9682ad8b9f2bcd.1792136742.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792136742.git.zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C045140006
X-Stat-Signature: d3n3dr6x3bk1nsg64xeqxwaceuox6qqk
X-HE-Tag: 1792145302-794638
X-HE-Meta: U2FsdGVkX1+/4UXsabdZ04xOevDmMSg+Qi857hWrrxm5pNlz8ZAfmPa+7XIWz7PsvmuHf9qqopAieVkL7QuMRUvH5bebRDhdOI5r32k5uhSHqaWf74wPzwoTO75sc9XXFoFhDDq7CyLfy9UjkNrA4OdbzgcFDmVsd21qXNzSxTsfsFr+5Dq6jm40vfsiscHm1T/j6sQw5a514RZDH9KZ341zg2FPhnwBjRw+H9rZ0SKlpkSIhQataH51ax0RwpDPUMAf5syagn1c93i2QHEL7vJ7eU7Lvd4nCDna2Xdn5VxsPcDQrqjdXRIw9IEwjYC+SKb/o2C6ET63Tpve5hbdygidooOplA67rfvs6r5VvNUcu10GFGwAQeFOL8pGh3pORU0JPCsaGKAgUiLMqk4QhefFvdgG37o8LNIGARhsWEAfhEoKsITCWl+o6cbdGbz3Oc+PkBHk0jknd4xjbDzVPmzCm0MZ/bWXta54ESlvD3geAPq3Xyv8yz5JcMl4erhsTD0YIkmKoJZZdDLhJ76RZd7cn7g2TsfObyEmZmTXPlYbcfGFBElsC0stcb/jAn+/2oeslQJkRudFo7mf3J9fU9/eOoOZvv93Ca2RG60m2wq3hZ1yIFOx5rVbS/n8IayKc1yrxb46hlxhk1mbBdzSjW3qLlU1YYWmGnUNXJcptVWvC2YF1cHNEubBbZZx6t/knoR+HEZIXn8SNUk4QXyyrJCVfFdvcSQvUKqv6MJi5WvAUgpQLnzuoWRGpOKy7HJlpdO0vP0agG9ZldJ/S+n77fE2+MhqLV/qGXKFGAqaEy/aiknHaAZohVuXIQyEUmMV57aZGLgMah7lKGiJcLCPbJrqtv+UrcxPaZniBHkwp2DaD8E2u5/BAdYxXWG/ol4QmVmrJtrFSXZC1IR4UxPi9Ojl1GPpwiPN2xHOrvDcQYu+EVg0rG0kUtSt5QnqlrQwqei8ACKt8aBtb8tz3c5
 4d7TvrZb
 vB8gm0564lxzXocgxoU/AUUEmAz5+CDaG2Kd/tZipDAYV55k2aN7xiuY6cpyrKKvkvyYeVYFpOB7NrRdgvsfCIVF3X6FulGUVVmDtiY/elGEqHqR9gUp4mVI0/0gm2HR7RBE+RMLVe8TnZCG8jQao2LwWh7SBQpEovXlEEDa205NWD6HnbOg3NV3hfdOvaGV4yyPhiMOboUXiaUcSTt8N6r0KXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Prepare for a separate CMA pool for PMD-sized HugeTLB pages by organizing
CMA areas and reservation parameters into pools identified by page order.

Select the corresponding pool for allocation, CMA-only checks and
boot-time allocation decisions. Release folios through the CMA area that
owns their physical memory, including after demotion.

Record each pool's successfully reserved capacity. Remove
hugetlb_cma_validate_params(), since the per-pool CMA-only check already
handles missing or empty pools.

Continue accepting only the architecture's existing CMA page size and
preserve the default pool's use by all gigantic sizes. PMD-sized pool
support will be added in a subsequent patch.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb.c     |   6 +-
 mm/hugetlb_cma.c | 154 ++++++++++++++++++++++++++++++++---------------
 mm/hugetlb_cma.h |  11 ++--
 3 files changed, 112 insertions(+), 59 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 76f4d2a5e0206..9d569eae852c5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1368,7 +1368,7 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 	if (folio)
 		return folio;
 
-	if (hugetlb_cma_exclusive_alloc())
+	if (hugetlb_cma_exclusive_alloc(order))
 		return NULL;
 
 	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
@@ -3635,7 +3635,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 	 * Skip gigantic hugepages allocation if early CMA
 	 * reservations are not available.
 	 */
-	if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
+	if (hstate_is_gigantic(h) && hugetlb_cma_size(h) &&
 	    !hugetlb_early_cma(h)) {
 		pr_warn_once("hugetlb_cma is enabled, skip boot time allocation\n");
 		return;
@@ -4338,8 +4338,6 @@ static __init void hugetlb_parse_params(void)
 
 		hcp->setup(hcp->val);
 	}
-
-	hugetlb_cma_validate_params();
 }
 
 /*
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 4f27eb242dc3b..9f1dfe6c2af67 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -19,6 +19,7 @@
 struct hugetlb_cma_pool {
 	struct cma *cma[MAX_NUMNODES];
 	unsigned long size;
+	unsigned int order;
 };
 
 struct hugetlb_cma_config {
@@ -27,14 +28,31 @@ struct hugetlb_cma_config {
 	unsigned int percent_in_node[MAX_NUMNODES];
 };
 
-static struct hugetlb_cma_pool hugetlb_cma __ro_after_init;
-static struct hugetlb_cma_config hugetlb_cma_config __initdata;
+static struct hugetlb_cma_pool hugetlb_cma[HUGE_MAX_HSTATE] __ro_after_init;
+static struct hugetlb_cma_config hugetlb_cma_config[HUGE_MAX_HSTATE] __initdata;
+static unsigned int hugetlb_cma_nr __ro_after_init;
+static unsigned int hugetlb_cma_default_order __ro_after_init;
 
 static bool hugetlb_cma_only __ro_after_init;
 
 static char hugetlb_cma_cmdline[COMMAND_LINE_SIZE] __initdata;
 static unsigned int hugetlb_cma_cmdline_len __initdata;
 
+static struct hugetlb_cma_pool *hugetlb_cma_pool(unsigned int order)
+{
+	unsigned int i;
+
+	/* Gigantic sizes share the architecture's original CMA pool. */
+	if (order_is_gigantic(order))
+		order = hugetlb_cma_default_order;
+
+	for (i = 0; i < hugetlb_cma_nr; i++) {
+		if (hugetlb_cma[i].order == order)
+			return &hugetlb_cma[i];
+	}
+	return NULL;
+}
+
 #ifdef CONFIG_NUMA
 static phys_addr_t __init memblock_node_memory_size(int nid)
 {
@@ -56,10 +74,16 @@ static phys_addr_t __init memblock_node_memory_size(int nid)
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
-	struct hugetlb_cma_pool *pool = &hugetlb_cma;
+	unsigned int i;
+	int nid = folio_nid(folio);
+	unsigned long nr_pages = folio_nr_pages(folio);
 
-	WARN_ON_ONCE(!cma_release_frozen(pool->cma[folio_nid(folio)],
-					 &folio->page, folio_nr_pages(folio)));
+	for (i = 0; i < hugetlb_cma_nr; i++) {
+		if (cma_release_frozen(hugetlb_cma[i].cma[nid], &folio->page, nr_pages))
+			return;
+	}
+
+	WARN_ON_ONCE(1);
 }
 
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
@@ -70,9 +94,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	struct page *page = NULL;
 	const nodemask_t *nmask;
 	unsigned int cpuset_mems_cookie;
-	struct hugetlb_cma_pool *pool = &hugetlb_cma;
+	struct hugetlb_cma_pool *pool = hugetlb_cma_pool(order);
 
-	if (!pool->size)
+	if (!pool || !pool->size)
 		return NULL;
 
 retry_cpuset:
@@ -111,7 +135,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 
 void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
-	struct hugetlb_cma_pool *pool = &hugetlb_cma;
+	struct hugetlb_cma_pool *pool = hugetlb_cma_pool(huge_page_order(h));
 	struct cma *cma;
 	void *m;
 	int node;
@@ -135,15 +159,16 @@ void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exa
 
 static int __init hugetlb_cma_parse(char *p)
 {
-	struct hugetlb_cma_pool *pool = &hugetlb_cma;
-	struct hugetlb_cma_config *config = &hugetlb_cma_config;
+	struct hugetlb_cma_pool *pool;
+	struct hugetlb_cma_config *config;
+	unsigned int order = hugetlb_cma_default_order;
+	unsigned int i;
 	int nid, count = 0;
 	unsigned long tmp;
 	char *s = p;
 	char *suffix = strchr(p, '@');
 
 	if (suffix) {
-		unsigned int order = arch_hugetlb_cma_order();
 		unsigned long long page_size;
 		char *end;
 
@@ -159,6 +184,26 @@ static int __init hugetlb_cma_parse(char *p)
 		}
 	}
 
+	if (!order) {
+		pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < hugetlb_cma_nr; i++) {
+		if (hugetlb_cma[i].order == order)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(hugetlb_cma))
+		return -EINVAL;
+
+	pool = &hugetlb_cma[i];
+	if (i == hugetlb_cma_nr) {
+		hugetlb_cma_nr++;
+		pool->order = order;
+	}
+	config = &hugetlb_cma_config[i];
+
 	while (*s) {
 		if (sscanf(s, "%lu%n", &tmp, &count) != 1)
 			break;
@@ -256,20 +301,14 @@ unsigned int __weak arch_hugetlb_cma_order(void)
 	return 0;
 }
 
-void __init hugetlb_cma_reserve(void)
+static void __init hugetlb_cma_reserve_pool(struct hugetlb_cma_pool *pool,
+					    struct hugetlb_cma_config *config)
 {
-	struct hugetlb_cma_pool *pool = &hugetlb_cma;
-	struct hugetlb_cma_config *config = &hugetlb_cma_config;
-	unsigned long size, reserved, per_node, order, gigantic_page_size;
+	unsigned long size, reserved, per_node, hugepage_size;
+	unsigned int order = pool->order;
 	bool node_specific_cma_alloc = false;
 	bool has_node_specific_param = false;
 	int nid;
-	char *p;
-
-	for (p = hugetlb_cma_cmdline;
-	     p < hugetlb_cma_cmdline + hugetlb_cma_cmdline_len;
-	     p += strlen(p) + 1)
-		hugetlb_cma_parse(p);
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
 		if (config->size_in_node[nid] || config->percent_in_node[nid]) {
@@ -301,12 +340,6 @@ void __init hugetlb_cma_reserve(void)
 	if (!pool->size)
 		return;
 
-	order = arch_hugetlb_cma_order();
-	if (!order) {
-		pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
-		return;
-	}
-
 	/*
 	 * HugeTLB CMA reservation is required for gigantic
 	 * huge pages which could not be allocated via the
@@ -314,12 +347,12 @@ void __init hugetlb_cma_reserve(void)
 	 * breaking this assumption.
 	 */
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
-	gigantic_page_size = PAGE_SIZE << order;
+	hugepage_size = PAGE_SIZE << order;
 
 	if (config->percent) {
 		unsigned long orig_size = pool->size;
 
-		pool->size = ALIGN_DOWN(pool->size, PAGE_SIZE << order);
+		pool->size = ALIGN_DOWN(pool->size, hugepage_size);
 		if (orig_size && !pool->size)
 			pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%)\n",
 				orig_size / SZ_1M, config->percent);
@@ -331,7 +364,7 @@ void __init hugetlb_cma_reserve(void)
 
 				config->size_in_node[nid] =
 					ALIGN_DOWN(config->size_in_node[nid],
-						   PAGE_SIZE << order);
+						   hugepage_size);
 				if (orig_size && !config->size_in_node[nid])
 					pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%) on node %d\n",
 						orig_size / SZ_1M,
@@ -351,9 +384,9 @@ void __init hugetlb_cma_reserve(void)
 
 		if (!node_isset(nid, hugetlb_bootmem_nodes)) {
 			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
-		} else if (!IS_ALIGNED(size, gigantic_page_size)) {
+		} else if (!IS_ALIGNED(size, hugepage_size)) {
 			pr_warn("hugetlb_cma: cma area of node %d must be a multiple of %lu MiB\n",
-				nid, gigantic_page_size / SZ_1M);
+				nid, hugepage_size / SZ_1M);
 		} else {
 			node_specific_cma_alloc = true;
 			continue;
@@ -367,9 +400,9 @@ void __init hugetlb_cma_reserve(void)
 	if (!pool->size)
 		return;
 
-	if (!IS_ALIGNED(pool->size, gigantic_page_size)) {
+	if (!IS_ALIGNED(pool->size, hugepage_size)) {
 		pr_warn("hugetlb_cma: cma area must be a multiple of %lu MiB\n",
-			gigantic_page_size / SZ_1M);
+			hugepage_size / SZ_1M);
 		pool->size = 0;
 		return;
 	}
@@ -381,7 +414,7 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		per_node = DIV_ROUND_UP(pool->size,
 					nodes_weight(hugetlb_bootmem_nodes));
-		per_node = round_up(per_node, gigantic_page_size);
+		per_node = round_up(per_node, hugepage_size);
 		if (config->percent)
 			pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up to %lu MiB per node\n",
 				pool->size / SZ_1M, config->percent,
@@ -411,7 +444,7 @@ void __init hugetlb_cma_reserve(void)
 		 * may be returned to CMA allocator in the case of
 		 * huge page demotion.
 		 */
-		res = cma_declare_contiguous_multi(size, gigantic_page_size,
+		res = cma_declare_contiguous_multi(size, hugepage_size,
 					HUGETLB_PAGE_ORDER, name,
 					&pool->cma[nid], nid);
 		if (res || !cma_validate_zones(pool->cma[nid])) {
@@ -434,28 +467,49 @@ void __init hugetlb_cma_reserve(void)
 			break;
 	}
 
-	if (!reserved)
-		/*
-		 * pool->size is used to determine if allocations from
-		 * cma are possible.  Set to zero if no cma regions are set up.
-		 */
-		pool->size = 0;
+	/* Only successfully reserved areas enable CMA allocation for this size. */
+	pool->size = reserved;
+}
+
+void __init hugetlb_cma_reserve(void)
+{
+	unsigned int i;
+	char *p;
+
+	hugetlb_cma_default_order = arch_hugetlb_cma_order();
+
+	for (p = hugetlb_cma_cmdline;
+	     p < hugetlb_cma_cmdline + hugetlb_cma_cmdline_len;
+	     p += strlen(p) + 1)
+		hugetlb_cma_parse(p);
+
+	for (i = 0; i < hugetlb_cma_nr; i++)
+		hugetlb_cma_reserve_pool(&hugetlb_cma[i], &hugetlb_cma_config[i]);
 }
 
-bool hugetlb_cma_exclusive_alloc(void)
+bool hugetlb_cma_exclusive_alloc(unsigned int order)
 {
-	return hugetlb_cma_only;
+	struct hugetlb_cma_pool *pool = hugetlb_cma_pool(order);
+
+	return hugetlb_cma_only && pool && pool->size;
 }
 
-unsigned long __init hugetlb_cma_total_size(void)
+unsigned long __init hugetlb_cma_size(struct hstate *h)
 {
-	return hugetlb_cma.size;
+	struct hugetlb_cma_pool *pool = hugetlb_cma_pool(huge_page_order(h));
+
+	return pool ? pool->size : 0;
 }
 
-void __init hugetlb_cma_validate_params(void)
+unsigned long __init hugetlb_cma_total_size(void)
 {
-	if (!hugetlb_cma.size)
-		hugetlb_cma_only = false;
+	unsigned long size = 0;
+	unsigned int i;
+
+	for (i = 0; i < hugetlb_cma_nr; i++)
+		size += hugetlb_cma[i].size;
+
+	return size;
 }
 
 bool __init hugetlb_early_cma(struct hstate *h)
@@ -463,5 +517,5 @@ bool __init hugetlb_early_cma(struct hstate *h)
 	if (arch_has_huge_bootmem_alloc())
 		return false;
 
-	return hstate_is_gigantic(h) && hugetlb_cma_only;
+	return hstate_is_gigantic(h) && hugetlb_cma_exclusive_alloc(huge_page_order(h));
 }
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index 730b2b4965b64..3d829258f6728 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -9,9 +9,9 @@ void hugetlb_cma_free_frozen_folio(struct folio *folio);
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact);
-bool hugetlb_cma_exclusive_alloc(void);
+bool hugetlb_cma_exclusive_alloc(unsigned int order);
+unsigned long hugetlb_cma_size(struct hstate *h);
 unsigned long hugetlb_cma_total_size(void);
-void hugetlb_cma_validate_params(void);
 bool hugetlb_early_cma(struct hstate *h);
 #else
 static inline void hugetlb_cma_free_frozen_folio(struct folio *folio)
@@ -30,18 +30,19 @@ static inline void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid,
 	return NULL;
 }
 
-static inline bool hugetlb_cma_exclusive_alloc(void)
+static inline bool hugetlb_cma_exclusive_alloc(unsigned int order)
 {
 	return false;
 }
 
-static inline unsigned long hugetlb_cma_total_size(void)
+static inline unsigned long hugetlb_cma_size(struct hstate *h)
 {
 	return 0;
 }
 
-static inline void hugetlb_cma_validate_params(void)
+static inline unsigned long hugetlb_cma_total_size(void)
 {
+	return 0;
 }
 
 static inline bool hugetlb_early_cma(struct hstate *h)
-- 
2.54.0


