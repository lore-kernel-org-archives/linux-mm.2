Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E11C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0806B0095; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60656B0098; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DDC6B0099; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 855AC6B0095
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07DA81407B1
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:40 +0000 (UTC)
X-FDA: 83730997560.27.08B52CC
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id B97611A0004
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119898; a=rsa-sha256;
	cv=none;
	b=HjXEaenYBZzBLguGlehhzjk/AL5IQMfB6ZeQdq4BPsabddC+57RghGeVtFfkiTVNBnOiOK
	T1vMLXKcY60qE8KUIG1iSskQL6YF9YTDQNM+hlWebr4oaN+qgs9lqZK73Cfnwsy1wMAtpg
	ENs95EN/Gwd8AGtVb4T+HA+P2PUXvac=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZtBOGZNjH76+Rs9XAFBZiTEOk7tIJ5g0gyAN7c3iuHs=;
	b=WWBUQrPn+gZAg+OJwdY5qBA+c+yqI7TtOkZJ/TYvfTiyl1sN0/Dz0LzS0wVpPpJjYwREKO
	aLSoX6bjQ9HHCsX6jvJo6sAAQG9iu/XDhZV6hvBR9jJt9IN5jdJRNVpVhEAtt1ZgFXl2p2
	W9OddE40L5vnUmtE2ZRR07IIfEDdfnU=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bvF050NsZz27j0S;
	Sat,  2 Aug 2025 15:32:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 03C40180042;
	Sat,  2 Aug 2025 15:31:35 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:34 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 7/7] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Sat, 2 Aug 2025 15:31:07 +0800
Message-ID: <20250802073107.2787975-8-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: xrik5air1q5zg1jrc1n8fh7sx76ghxsp
X-Rspam-User: 
X-Rspamd-Queue-Id: B97611A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754119897-452628
X-HE-Meta: U2FsdGVkX19BT1sMjJuaUtBzpLbJa2JQIwuq/mOBAi+KaXO5Z6qsgOSwGPxeQQdj1yl6mSwk2AJAD0EVPryQO/WHu+a/R11IItNvHbvE3Th+09RMQ8B9vnciPi04B4oAh5wePeef+j5+7gEGT5WbTS32RwQWxPja68Nd1+04JsE0d92KivmURrz5ddKLpp00GYH1oCiHqRmaWN5MWbP4Y7OErsFzOm6H24ddpX2xtcYYFLmzA/rD8rWWhkKqKIRqa8jJYrdtyvyt1te1ggh5bMtj1eOtGm+G8YI78amB4vTF0sdxUjsNwoJsLx5N8QzEFwmbNoFBtXQacv5AE9d3vcBu1yx5EfqbXw02MQLUPS+s9boCEuaw0gg4eO1SOgcMW1/5mF3AWhtK/dm4VtjBQzPNLL48loEJF4iJihMkD+xUOZQyWvOqk1aVVQ7k/h/uML+c76Z7K5kBOrBSG/ZSXTlCg3eugp05mKRwkjIW0p+IU+bcJmOmra19Ez0jYVCGZ+R06xdmSE8zpYJEO5UeCi9qEvu4U8o+w2gX28GdKhOhn83s5ECRnRfg8IL8OieQUb1XgzaA8DE8NX0BfOreKel8YYKJI0HQSUXRf11LazEq1XSz/hkEDaHzdQeFVRJ03p+eY2vgDWdwDw0XRdMuQDpeT//KIxIwLwPXdm2KrJg1RWfrmyxRoAhg5r+uk4c34hikPLLICEM/OxbbxLjlFvhRZDJk5fL0HwHzyZy0DBgNJr+edq2vdlMxgSLJ9qm3LdYg1dPOep4HgekUpjHxPjRHqIAMhycGogh5zDhfHamQC5FUicXAG2AgjOuZt+9ya0EC8XSjVd5X7CQLCuLBfsWg3oTn9r5SOT0iSem2pguN4PzwMcsMTsguE2v/LoGCaOIJNyxGU26orqw9hce6A9E88lGVJJC00x5ApvJHiI5Sg24URDV5WY6yH9DBeEG3GHceMvvdamwSi0gwflY
 B+uwmOwV
 4MskF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_gigantic_folio() will allocate a folio by alloc_contig_range()
with refcount increated and then freeze it, convert to allocate a frozen
folio directly to remove the atomic operation about folio refcount and
cleanup alloc_gigantic_folio() a bit.

Also move folio_alloc_frozen_gigantic(), cma_alloc/free_frozen_folio() and
cma_validate_zones() into mm/internal.h since only hugetlb use it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h | 20 --------------------
 include/linux/gfp.h | 23 -----------------------
 mm/cma.c            |  4 ++--
 mm/hugetlb.c        | 43 +++++++++++--------------------------------
 mm/hugetlb_cma.c    | 12 ++++++------
 mm/hugetlb_cma.h    | 10 +++++-----
 mm/internal.h       | 37 +++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c     |  8 +++++---
 8 files changed, 66 insertions(+), 91 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..f116e23629ee 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -57,24 +57,4 @@ extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long e
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
-#ifdef CONFIG_CMA
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
-bool cma_free_folio(struct cma *cma, const struct folio *folio);
-bool cma_validate_zones(struct cma *cma);
-#else
-static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
-{
-	return NULL;
-}
-
-static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
-{
-	return false;
-}
-static inline bool cma_validate_zones(struct cma *cma)
-{
-	return false;
-}
-#endif
-
 #endif
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 5ebf26fcdcfa..5ad78c296344 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -440,27 +440,4 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 #endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
-#ifdef CONFIG_CONTIG_ALLOC
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
-{
-	struct page *page;
-
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
-		return NULL;
-
-	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
-
-	return page ? page_folio(page) : NULL;
-}
-#else
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
-{
-	return NULL;
-}
-#endif
-/* This should be paired with folio_put() rather than free_contig_range(). */
-#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
-
 #endif /* __LINUX_GFP_H */
diff --git a/mm/cma.c b/mm/cma.c
index 2ffa4befb99a..9539fd5700b6 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -921,7 +921,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
 }
 
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	struct page *page;
 
@@ -1008,7 +1008,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 	return true;
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4f73b74a2cff..eea9dc782007 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -125,16 +125,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
-static void hugetlb_free_folio(struct folio *folio)
-{
-	if (folio_test_hugetlb_cma(folio)) {
-		hugetlb_cma_free_folio(folio);
-		return;
-	}
-
-	folio_put(folio);
-}
-
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1477,29 +1467,15 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	bool retried = false;
-
-retry:
-	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
-	if (!folio) {
-		if (hugetlb_cma_exclusive_alloc())
-			return NULL;
-
-		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
-		if (!folio)
-			return NULL;
-	}
 
-	if (folio_ref_freeze(folio, 1))
+	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
+	if (folio)
 		return folio;
 
-	pr_warn("HugeTLB: unexpected refcount on PFN %lu\n", folio_pfn(folio));
-	hugetlb_free_folio(folio);
-	if (!retried) {
-		retried = true;
-		goto retry;
-	}
-	return NULL;
+	if (hugetlb_cma_exclusive_alloc())
+		return NULL;
+
+	return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
 }
 
 #else /* !CONFIG_CONTIG_ALLOC */
@@ -1641,9 +1617,12 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	if (unlikely(folio_test_hwpoison(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
-	folio_ref_unfreeze(folio, 1);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 
-	hugetlb_free_folio(folio);
+	if (folio_test_hugetlb_cma(folio))
+		hugetlb_cma_free_frozen_folio(folio);
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
 }
 
 /*
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..337776786ecf 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -18,29 +18,29 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
-void hugetlb_cma_free_folio(struct folio *folio)
+void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	int nid = folio_nid(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_free_frozen_folio(hugetlb_cma[nid], folio));
 }
 
-
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
-		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+		folio = cma_alloc_frozen_folio(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
+			folio = cma_alloc_frozen_folio(hugetlb_cma[node],
+						       order, gfp_mask);
 			if (folio)
 				break;
 		}
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index 2c2ec8a7e134..71db3544816e 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -3,8 +3,8 @@
 #define _LINUX_HUGETLB_CMA_H
 
 #ifdef CONFIG_CMA
-void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+void hugetlb_cma_free_frozen_folio(struct folio *folio);
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -14,12 +14,12 @@ unsigned long hugetlb_cma_total_size(void);
 void hugetlb_cma_validate_params(void);
 bool hugetlb_early_cma(struct hstate *h);
 #else
-static inline void hugetlb_cma_free_folio(struct folio *folio)
+static inline void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_frozen_folio(int order,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 1da16d550a45..b12cd23e88c4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -933,6 +933,9 @@ struct cma;
 #ifdef CONFIG_CMA
 void *cma_reserve_early(struct cma *cma, unsigned long size);
 void init_cma_pageblock(struct page *page);
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp);
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio);
+bool cma_validate_zones(struct cma *cma);
 #else
 static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
@@ -941,8 +944,42 @@ static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 static inline void init_cma_pageblock(struct page *page)
 {
 }
+static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
+{
+	return NULL;
+}
+static inline bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
+{
+	return false;
+}
+static inline bool cma_validate_zones(struct cma *cma)
+{
+	return false;
+}
 #endif
 
+#ifdef CONFIG_CONTIG_ALLOC
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
+{
+	struct page *page;
+
+	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
+		return NULL;
+
+	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
+
+	return page ? page_folio(page) : NULL;
+}
+#else
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
+{
+	return NULL;
+}
+#endif
+/* This should be paired with free_frozen_pages() rather than free_contig_range(). */
+#define folio_alloc_frozen_gigantic(...) alloc_hooks(folio_alloc_frozen_gigantic_noprof(__VA_ARGS__))
 
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			   int migratetype, bool claimable);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..c542ababb8dc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6822,6 +6822,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
  * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
  *		action and reclaim modifiers are supported. Reclaim modifiers
  *		control allocation behavior during compaction/migration/reclaim.
+ *		If gfp_mask contains __GFP_COMP, the refcount of compound page
+ *		will be not increased.
  *
  * The PFN range does not have to be pageblock aligned. The PFN range must
  * belong to a single zone.
@@ -6955,7 +6957,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-		set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7074,10 +7075,11 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	struct folio *folio = pfn_folio(pfn);
 
 	if (folio_test_large(folio)) {
-		int expected = folio_nr_pages(folio);
+		int order = folio_order(folio);
+		int expected = 1 << order;
 
 		if (nr_pages == expected)
-			folio_put(folio);
+			free_frozen_pages(&folio->page, order);
 		else
 			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
 			     pfn, nr_pages, expected);
-- 
2.27.0


