Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E382ECA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7202C8E001C; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A35B8E0017; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6898E001C; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F89E8E0017
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0B741168A5
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:24 +0000 (UTC)
X-FDA: 83844291048.17.99BA044
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93F5414000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817363; a=rsa-sha256;
	cv=none;
	b=eaikelgfyPLT0tblnHsjTQweeGdcv/fsQhRC7v5IC+1EU/7jvZSXIogP+SYUEvVIlwXiky
	znoYVVknm6duFvyyrHHpAq0b+eByZVh0lxTV97rT7C57u6BDRsOQLZEbc3EJt9/HFK5zCq
	y5Iqg4xm9eT3xritdeQje2S3wc1rd80=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s97fL5l5vqENHjtNrCn8DUwfgbMf2JpKOBdzegpSfys=;
	b=CHJAou3iaclWK6vTJZ8WfbBoBvnrjlxzAOX0HlJP5GEnSz13mqOAO7RIXxOi610DVt4fXG
	BSv7C4ni1NNzy+AhAF7MzXCkfi+2ohIBncZTS4rXVOOYRcLfehXiEuMnutFdjdCLBsSrDq
	4Dr8lnhTfauCF2kn2gGfg/m0JZG4RtU=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cGQTf0tfxz24hwX;
	Tue,  2 Sep 2025 20:46:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 888E11402C1;
	Tue,  2 Sep 2025 20:49:19 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:18 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 9/9] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Tue, 2 Sep 2025 20:48:20 +0800
Message-ID: <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93F5414000C
X-Stat-Signature: xjpz7oc19rdtzbdr8ntzxtpddtqapswh
X-Rspam-User: 
X-HE-Tag: 1756817361-264207
X-HE-Meta: U2FsdGVkX1/GUmB+xIrG0Hr/mdGEcJMKTmEkTkxAjZnHCRJVJGAMqM/Tx8wlmR7udSMLr2swetfG41txQVJ3iae7EW3R60YNjGucNJLIS8J9hJphsrLspLO/a4U9zLPkQ+nY+LcQ9q3mb9eJTLWh991OcOMcH5qS5j+aN2Han1Fgxs6/hMeRLoDzSw7YBm5BLKT/m0/UwJNRwTLg+vNAqrrNOoweY1bpEvEH1KMYEo2qFqKfiCuG8aUJnHTEk+KsDh/RK/tNgXQJtV9lfEMr9vmmla+2LEHN9YSbkI6Rp0EP9X5vV923oQlUs+nh13YhqnLUkJZ7oO+3b+f566UuccDNgEr7DPAjXJZlzDOx6hj09VJSq2BInMssxQs6SKWthtLOGagL+KFFrcpt1nbSVR7iX0hIW+rH6KqxB8Td1adRRi48TpK1NUSk2z7eAIfh1xhV7XOCxBFirQTPdAae+1hZe5NzggJKdQrE0V4UqbReGFva5tPKONm2aKqxeCVqvl12u0Tx45+E77cq/jxYUtQmmLvk3wuFDd3fsS7v0LX85+Twcc44/N5Bfwj1pG9WqjRGFgEhiwdQDd9CXl4778p3wECTMtux9YmebwapllW82Fil5+B7p4DhrSgkWSg2Td01uG/CtBEg5KUUgbCDx5XDEM2HHhoGzBCAygqeVKBY0pMYzLW8hi/JU2iJluNCN9r+32+1B7R3I9TFJ6iD01gEL0yPiwtvzlYqx4UpWMAv6YRKQI9yw97srKypcHhcbVeo+iUg2ZI+U+qo9UErbNvzEBl9vYhy9/aVthhP4ncmwx5CjpoBBaa0bdI3EHnfKOYuAnSl5d1grLZfEDt+1aX97Ax2+8EUaT0dPE2BAZZ8zF9SI5IOIehQQfXYxu4vX/4K/mAMotZcyjmupkqIsgQCRra3c3mjq26EVK8xvA4ESTf10rXILVEm5CItUSwHGGFblXszg3JmjonuaHp
 Sl+66FjK
 N6uef
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_gigantic_folio() will allocate a folio by alloc_contig_range()
with refcount increated and then freeze it, convert to allocate a frozen
folio directly to remove the atomic operation about folio refcount, also
saving atomic operation during __update_and_free_hugetlb_folio too.

Rename some functions to make them more self-explanatory,

  folio_alloc_gigantic		-> folio_alloc_frozen_gigantic
  cma_alloc/free_folio		-> cma_alloc/free_frozen_folio
  hugetlb_cma_alloc/free_folio	-> hugetlb_cma_alloc/free_frozen_folio

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h |  8 ++++----
 include/linux/gfp.h | 14 ++++++-------
 mm/cma.c            | 22 +++++++++++++-------
 mm/hugetlb.c        | 50 +++++++++------------------------------------
 mm/hugetlb_cma.c    | 13 ++++++------
 mm/hugetlb_cma.h    | 10 ++++-----
 6 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e5745d2aec55..cceec7b25bae 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -57,16 +57,16 @@ extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long e
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
 #ifdef CONFIG_CMA
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
-bool cma_free_folio(struct cma *cma, const struct folio *folio);
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp);
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio);
 bool cma_validate_zones(struct cma *cma);
 #else
-static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	return NULL;
 }
 
-static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
+static inline bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	return false;
 }
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index d0047b85fe34..ceda042be704 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -447,26 +447,26 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
 #ifdef CONFIG_CONTIG_ALLOC
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
 {
 	struct page *page;
 
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
+	page = alloc_contig_frozen_pages_noprof(1 << order, gfp, nid, node);
 
 	return page ? page_folio(page) : NULL;
 }
 #else
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
 {
 	return NULL;
 }
 #endif
-/* This should be paired with folio_put() rather than free_contig_range(). */
-#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
+/* This must be paired with free_frozen_pages() rather than free_contig_range(). */
+#define folio_alloc_frozen_gigantic(...) alloc_hooks(folio_alloc_frozen_gigantic_noprof(__VA_ARGS__))
 
 #endif /* __LINUX_GFP_H */
diff --git a/mm/cma.c b/mm/cma.c
index b4413e382d5d..49d53879c1d0 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -924,20 +924,21 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 			   ACR_FLAGS_CMA);
 }
 
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	struct page *page;
 
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
+	page = __cma_alloc(cma, 1 << order, order, gfp,
+			   ACR_FLAGS_CMA | ACR_FLAGS_FROZEN);
 
 	return page ? page_folio(page) : NULL;
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count)
+			  unsigned long count, bool frozen_page)
 {
 	unsigned long pfn, end;
 	int r;
@@ -960,7 +961,14 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 	if (r == cma->nranges)
 		return false;
 
-	free_contig_range(pfn, count);
+	if (frozen_page) {
+		struct page *head_page = compound_head((struct page *)pages);
+
+		free_frozen_pages(head_page, compound_order(head_page));
+	} else {
+		free_contig_range(pfn, count);
+	}
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -981,15 +989,15 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	return __cma_release(cma, pages, count);
+	return __cma_release(cma, pages, count, false);
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio), true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4e8709d7deee..1d801bf65916 100644
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
@@ -1472,43 +1462,20 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
 		nr_nodes--)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
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
-}
+	if (hugetlb_cma_exclusive_alloc())
+		return NULL;
 
-#else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
-					  nodemask_t *nodemask)
-{
-	return NULL;
+	return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
@@ -1641,9 +1608,12 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
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
index e8e4dc7182d5..24738a1d6098 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -18,29 +18,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
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
-				      int nid, nodemask_t *nodemask)
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
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
+			folio = cma_alloc_frozen_folio(hugetlb_cma[node], order, gfp_mask);
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
-- 
2.27.0


