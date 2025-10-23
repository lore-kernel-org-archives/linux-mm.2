Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E95CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E5E8E0019; Thu, 23 Oct 2025 08:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241AC8E001C; Thu, 23 Oct 2025 08:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38D28E0011; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C023E8E001E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89BEA12978B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:59 +0000 (UTC)
X-FDA: 84029235318.04.6534B48
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id 197B9100008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220797; a=rsa-sha256;
	cv=none;
	b=oJqUnKzZuf7PP/xdFgZp+hqalxNV76Aw2lzkysFrJAyeIEw5JQ4HdPuuqU5Vx89BslgFex
	AZAnC3VE6LnZ3wels8M7z8LcbE1uYrAT/I7kziq9qMZx3911h4azB5kuhRUWkBMcEx1Ogu
	EeqrFzKNWvLJQfY2qDrs3EOurvU+2V4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9l6KAzt0C5M1nm1boFwCXRNanJgk/qppkb+zXDRf1KU=;
	b=V/TJnKGVsYDMHj0cKqH0QhVNt9HNE/u0MY0j5h7Wh15HhEWJqDDAAcVBxY4KgN6ftMoo97
	WjZhaEs0Yndo10o97FMzBaIETkFVMLb7PNKcjsLTjr8504A2M0oFsXZETxMWxOnjZT/qZl
	q6rwWCi80ssTtOQzsjYiqXN20vcVNZ4=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4csl1j67lpznfc2;
	Thu, 23 Oct 2025 19:59:05 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DB0A214010D;
	Thu, 23 Oct 2025 19:59:53 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:52 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Thu, 23 Oct 2025 19:59:40 +0800
Message-ID: <20251023115940.3573158-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 197B9100008
X-Stat-Signature: hk86d19s3h6etisq9xmnonbkzut5ojdr
X-HE-Tag: 1761220796-899573
X-HE-Meta: U2FsdGVkX182nh97Gnx52NAE/k8la5aF8M7b73MtkopI9rfPhcZGpaa72PG6ihelPKjHFyrYnJMlIzqzZk0ZHPFs8FKQ/loQ2hxqm1MKhkxGQWPL9P9+HnsQTjjBYYUYeIfZe2KskLv76nb/vL/MRCl1lhrNdsoGIwCumRuATaPh4CVUqKPa8sKSwc/3DaLst8q0pUc918nBkWXY2M5P45i/4XYSLaFSt6GezHTNQUE24DSdgYHRLG05aQ3/78N06t5nFY0qIzY5SaX6Tk3igd8JO01KWhjP1SeMUvfo8Q7DpLBteBlLLX8u6p2IRrgLaE8AUGYwJAtjTWn66s0ol0+aLWVwdHd0goUZUelBEDi24cAFAXRjjpVa454cNztYYVDNpKvKT+O3ZQvo8Ly3RDAgB8JmpJek9MnqKOMljxOAcXKzBtDqH+2npt60kSWyggczAHT1nj8Vxx1jiAeFuVjPWiRbkOvl0bbppNt0uCzw1oW9kGg+QV2AKGdJYsYicPQueHbP1pd+qgWQ9xG6dkCD8xnW7dwhD6yFikF1M1Dz3Io+x6NaEaBKgRTkvFPx5N3EqYvvwIV71XkNUxDifj6S1AA8hhFMmu9c6lKRVgLTAgIdds9ENX3LVEfFyMUd3SLstxnkcEFqFXzgUHtlT7BfUM7BkOtyvErmZzMCJ/gvNVWTlSTxrCpU8ityBut/j91A0lFHDhVNbAcqLL8aih1cpiOdt/kpvi7qwuxZp4/2ibwKnMqCrAyjDYiTHnsfJb8xbEUvln91by1GwZ0JyY8rfnAg4MuiaNKqWVfm7n0D5eOQjm4mdK2FEMCljdO+ODAZAUKlDEMpwB1ysf5OBpsRxktEq7oZGNiTfMYdmZVRTSyMIVxAlqZN2V3sx/Z7HfNk9PSKFqqBrozW6hVA1QpVTNtnTFJt9UwSt+B8CU/QhQywxa/DTgvHpOdxsn+X5VVlfJSVgeMR2q7E32q
 a3luEto4
 JTgORzVjHyhvhavWe/cPszWDNLERte/MTtSjKCskQq7Iz/FqBsdKMT1rU9SMaxi/5jpfHObq4kALT5GnpOBUudo/yk7kViRpZU9dSZHO5iA/PHliHaHAXN1xnYyhr8WZHsmmNL5AVZ3zuwJvqNm1OmKsNKXv/7/E5rZyvOBDuR5jy1LSALYRMQ9hp7xRrBB6hUVLofA0vFS/HImjCJUKT4BT2h/2v3385FjlZwGOX/RqqDLjAtHYrtWZT2d5FDkHpBIlvIK7eBHRC4B5eXd7YC9fPig==
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
 include/linux/gfp.h | 23 ------------------
 mm/hugetlb.c        | 58 +++++++++++----------------------------------
 mm/hugetlb_cma.c    |  9 +++----
 mm/hugetlb_cma.h    | 10 ++++----
 4 files changed, 22 insertions(+), 78 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 6aba25904f36..96c92ba1d45e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -453,27 +453,4 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
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
index 7774c286b3b7..f61cfbf2174c 100644
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
 /*
  * Check if the hstate represents gigantic pages but gigantic page
  * runtime support is not available. This is a common condition used to
@@ -1482,46 +1472,24 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
+#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
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
-#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
+#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
 					  nodemask_t *nodemask)
 {
@@ -1652,9 +1620,11 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
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
index 0a57d3776c8d..7a33fa4981aa 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -18,16 +18,14 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
-void hugetlb_cma_free_folio(struct folio *folio)
+void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
-	folio_ref_dec(folio);
-
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
 					 &folio->page, folio_nr_pages(folio)));
 }
 
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-				      int nid, nodemask_t *nodemask)
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	int node;
 	struct folio *folio;
@@ -50,7 +48,6 @@ struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
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


