Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7292FCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B6F8E0115; Thu, 18 Sep 2025 09:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B308E0112; Thu, 18 Sep 2025 09:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE8F8E0115; Thu, 18 Sep 2025 09:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE0628E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A52531401CA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:47 +0000 (UTC)
X-FDA: 83902430934.20.18FBE23
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B6494000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MFhgU4g4g+8+/+zffgehdGxA4xkvN2nwnCPrun1a4t8=;
	b=X/vPTEuHaWwMrOUPvc6FZ4jQUBTdeLbwzGi7ZIfYnDr6Bd25rNERE3X05SHtYNcZT+SWW6
	kX0Jz+c1s6IfvBV56pbEVuitsq7rDBKfD56UE9urTg+o2zHEfHbp2GSEUJEVL+0CTBSTRL
	U8z1pgGxkpJrEXUbq99YjiXNJbUhUV0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201646; a=rsa-sha256;
	cv=none;
	b=NhBttv6Knb+bd4rl/u5G+q4BwglKY7zb0/9FI4diJC62s5EsN61Bg19p0EC70kZcGDu9R6
	G9yduiX6XKlFVdKwJAfxCIP/CP2T8L3SjCPS20q5C1+2zw+OYM+Ba+x1wzJxAB7ee2unOr
	3pM42EucP/pqL5JPPXqxkYB+h6tdOL4=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cSGTg0k23z14MYJ;
	Thu, 18 Sep 2025 21:20:23 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A8DB180B63;
	Thu, 18 Sep 2025 21:20:40 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:38 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 8/8] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Thu, 18 Sep 2025 21:20:00 +0800
Message-ID: <20250918132000.1951232-9-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B6494000C
X-Stat-Signature: fcne1r5ix5mojt8rm95gjw948kyuy87g
X-HE-Tag: 1758201644-697313
X-HE-Meta: U2FsdGVkX1/rtCAnhRD+fl1GvPTyiy5QBRH9qvyfGPIgoe/xLG1Uv2ro9/mBp/8JOzHx7jJGttE4MDpr/SbseTrzRLtkNJAh778T6UPnQWiH4apzUDO7fJOn4102oVjU+1GNFEThZ+eUS/Xv8K0TyKgDL8GtBHTfIP3swahBjKnRPDJUZ4meNZEk1wjfdHKYNo8xKtfx0Twgt1O0gPpgNaojQ4mG/CJaxFg3iCI2xp+mWtabgj6lkpLjUT7oxhWLrgwuHB5giUMgTyn8+jNrZa0Z8/Xq6Q+3qCX0mrCh/teGN7cutXpyWVd11a8rDNYsozDVPJhRffxmFotApwZfZajWQUnsTlu0M/uHX+GOpz0cjRqJxVIOh330wAUYjerSoHK19ZLcLR9WwAFj+AM6nZ811mVdEAn4KZu+fS6V27R58eVddKi12tENevmS5xCXyI1fgePjGjcDVNWKP1JBdtbtzGnXyDIapR1TFQEGMG2etXFPMMiV9YErtpbgg9vSeRo+MYr5UqhhDO7HnWXUb66amz/R04zQVgl87gvgdLMj1OC6OtLsM8r1RLDkmdgGatpqtp7uLqpIXwTggNZuNa7RjDia18PyWO/Bqf0vGHCxkeOVAswAEb/PLQVkbtpf7VgNL/DOV+SMdcbozDSC9m/W4oZbzAlxz8wu5HsTmdkAWwiHd4DctCNz7p/hdu7SIbEUitS8W+fMqu/Qzap2V8g30p/FANxT9eaNdtubzlungd2dvGno7y+zK834LnQKo3nwRSYd7W9Z7/51HIsGXuy4NCPz3EBVJ2aW+NCE4DurGR2oCb8U5M7tZUz7m5w5ZEQY9u8LTfBq4pWU41TqMtaZNYOU27+ty3gujvZ/eW0FkQrUQvoLbfAcKeBFy2QfnO2cfyAC1jDhpqrxSqTWhB69raBoadSmQU/tIsS1ovAb9zpbbBMZ8QquRkdkMU/WbOrF8kBkFmk8qU0w/HH
 uqxtD0yV
 rawKPCdsa7QvaZV7cyx0z+9x7us6E+SKKxpR+mSv4XYDKhmNAUr0WYjFbZag3dbuIMJCdqrezgGotYH+WyhDuekOyzeH90pAfRJzuCpNv/gbR0hy8hRfiCCGMFW8IU8/uu4n9Lj0HA1aL56aSbvnHehQxfWEt4Ow6/l2j/Wx0k2vdnBcpnBn5eWj0kU6JQ76wbNGEhzMsRyD2Gk8sBKXVQoiKHy/zlRTq4K2aWD4sA8S9nQiQ6rOg/DgyCbV1fBRFuJJ0lqI4WX43dYvGsrCJhKOcpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
with refcount increated and then freeze it, convert to allocate a
frozen folio to remove the atomic operation about folio refcount,
and saving atomic operation during __update_and_free_hugetlb_folio
too. Also rename hugetlb_cma_{alloc,free}_folio() with frozen which
make them more self-explanatory.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h | 23 -------------------
 mm/hugetlb.c        | 54 ++++++++++-----------------------------------
 mm/hugetlb_cma.c    | 11 +++++----
 mm/hugetlb_cma.h    | 10 ++++-----
 4 files changed, 22 insertions(+), 76 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fbbdd8c88483..82aba162f352 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -453,27 +453,4 @@ void free_contig_range_frozen(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc88b659a88b..ce5f94c15268 100644
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
@@ -1472,44 +1462,22 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
 		nr_nodes--)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	bool retried = false;
 
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
-
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
+	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
+							  nid, nodemask);
+	return folio;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
-
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
 					  nodemask_t *nodemask)
@@ -1641,9 +1609,11 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	if (unlikely(folio_test_hwpoison(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
-	folio_ref_unfreeze(folio, 1);
-
-	hugetlb_free_folio(folio);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	if (folio_test_hugetlb_cma(folio))
+		hugetlb_cma_free_frozen_folio(folio);
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
 }
 
 /*
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index fc41f3b949f8..af9caaf007e4 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -18,16 +18,16 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
-void hugetlb_cma_free_folio(struct folio *folio)
+void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	int nid = folio_nid(folio);
 
-	WARN_ON_ONCE(!cma_release(hugetlb_cma[nid], &folio->page,
-				  folio_nr_pages(folio)));
+	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[nid], &folio->page,
+					 folio_nr_pages(folio)));
 }
 
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-				      int nid, nodemask_t *nodemask)
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	int node;
 	struct folio *folio;
@@ -50,7 +50,6 @@ struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 	if (!page)
 		return NULL;
 
-	set_page_refcounted(page);
 	folio = page_folio(page);
 	folio_set_hugetlb_cma(folio);
 	return folio;
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index 2c2ec8a7e134..3bc295c8c38e 100644
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
+		gfp_t gfp_mask,	int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
-- 
2.27.0


