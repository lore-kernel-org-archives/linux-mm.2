Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB8FE94121
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 07:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A318F6B008A; Tue, 30 Dec 2025 02:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD006B0095; Tue, 30 Dec 2025 02:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716056B0098; Tue, 30 Dec 2025 02:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59D516B008A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:24:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B82313CB7B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:57 +0000 (UTC)
X-FDA: 84275300634.30.2582843
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4AFFBA0004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PpruSnXc;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767079495; a=rsa-sha256;
	cv=none;
	b=aew5c3FQBv1Y9N+J9z9yb/6TXywD+rZc8bto87QldhKXlWkZ5KaIXpvJll7XbewX7JM3Gp
	KohIBfog0iv94zV5rj0fOMx71I5kS7481TASA12uXwPht9pfFWEDh8XzxC7OKas5eE5PJW
	RIaRnSmIrffTfmrHzsAs64rVAOVRIgE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PpruSnXc;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767079495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W61oaaA1mTwFBAiLRG42OSZt1NSg6YKYRhBoYE1mfH4=;
	b=qG894vYV4tbQ3MjnxqJVO2s3Za42xKiyq1jndma1nxppA84TI5xICgaksBondkDX34N0YX
	aKXu64kaBHhXFJmSgMmH2ftVkNBGbcty4afM0Bj/UHGHmeR+nOrQ5EzzKlfrFjdMLAuqm7
	dmbYUlQbz/RYcfLzEeHAHT5VujSvV/Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=W61oaaA1mTwFBAiLRG42OSZt1NSg6YKYRhBoYE1mfH4=;
	b=PpruSnXcitpNCnk9TGSS4Ew0Lc1Ee+xWgcRt0f6R+gYLVIrpFh3DEmEU0kff1Bm+idSPbsKxi
	3+0Tu1kVi30EORItRYMDH/mCrrSCTj4ib7N5FY5AIvlRK2iq9Zbd2EAvibtM6kJaCjXXWVWgwii
	nyi9ZX2xWhhcRc+MgypVsjo=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dgPfF369tz12LDB;
	Tue, 30 Dec 2025 15:21:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 6682740606;
	Tue, 30 Dec 2025 15:24:50 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 15:24:49 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 6/6] mm: hugetlb: allocate frozen pages for gigantic allocation
Date: Tue, 30 Dec 2025 15:24:22 +0800
Message-ID: <20251230072422.265265-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AFFBA0004
X-Rspamd-Server: rspam04
X-Stat-Signature: ocerzh9mkgmiu9z99rt67m35pajndiwj
X-HE-Tag: 1767079493-135066
X-HE-Meta: U2FsdGVkX1+SGJEkaXNiODNQQ/GZWj1pWfdfTnY3Fp1HebquKDqFmC00D5Bv5clky5vEJ+q7iPJfm9sqFgUIaaP6g46S/Pw0FxG6kstcatojIH2p/28iV99+UVCJF4XtqqgP8RDDGgeTZsLnlKOZmL0lNC2LseIyPajCfhYNypgUDfZoDwMGLJxDlqwGGt0PhWNcxt/6A5CRD5M0ymFGOtcipoynGH2fctbiaX1LQ2JysBT6zK26yeoHAExZilElSpAWYp6YSFx/mcRmbRkIcFYMVX95EvStGItn+2B7o7ftMfkSXmLQ86MgPEm0zYQb5hxh2uofAxU3JJzI9C8j98ucAbxXDotu0u0PX2GC7qfNQjYnyG/xc3MdLV5/HlRypfS1AYZWbgttSxN6BHugzvlv+z+UOFqjaAv28lnUxqh7RQSxJqiNQK3iC6pp+3qa7vA8s0b39yapshVS82M+OOeUTcv+HTlA6tMAVFpHVcU+IlcRVdjP96UHJwtkshcDXNLyXqKVfW2qnjAkbQ/jJMauUyBe1DyD+SI105Q2akcMYpz6VH6HAvhhgipzj7beTF/exvQmUbUAfoLTmOg6p5GDSfX12UxtCQY7LCSwGp9jO6ocIW1cH59Qui2XFwSfO/Ib6ug2WAeRz8+Jp4UdnDQzcmDw5nuGX877EER36bwAd/OLGm6K2Bpmrp5Cu76z6KYYVlw+kbYLpOFBt4R05IcSIbkMhV8bOYIl0clONOjWYMYo/zbQWvXV5rA2eCcqzK3VbTrjWm0aw1+x7wNyqtXhYVuV+Zv3l8UXf6tH/hv98MwOxnpYnzTMjZ8rGQEmEdlUs3YbTma+DvoOUvl/90pWz91jJbI/rnHxp4qbwfYFacCO/1+lXcx4Y0MGot6KvM8HHUttghusknOSikOmq6RfzMhuFDu5Sjl838+ZpF74DHKj+BZFFlA5ndUqfXapA4sHZElbE1iveTsKpbf
 q5dfnlGO
 05I+sDRQG7IbeRgXHDqAUspoWUzn7POwOhtgKcJw+SCjdRYA20ylvC0oupSPS5YW2wuqMcitJseotBMCxD7oUAs/6genlpMfXjziphN1BhNrLxU/c6ZCqD3bE/wf1UtjEXcxqpMbzdSkSYFlPpAHAssUzsq3zf/8NLBbhD7QbNA3mJOh+Reew5iZjPH4rlfE99Y8ePxtGuKRrtVWWss7fd0L64wGlVGJWqyWamZszCOLiAs5te03Hx9bShziOUurX0/1HRPjvryZ4cAmZN4/MPcHzFE2CMHSMGp1qGUSFMYlPcE4DUxxYWTvc4QvinysyL5GDmeomXPuz6lk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_gigantic_folio() allocates a folio with refcount increated
and then freeze it, convert to allocate a frozen folio to remove the
atomic operation about folio refcount, and saving atomic operation
during __update_and_free_hugetlb_folio() too.

Besides, rename hugetlb_cma_{alloc,free}_folio(), alloc_gigantic_folio()
and alloc_buddy_hugetlb_folio() with frozen which make them more
self-explanatory.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c     | 75 +++++++++++++-----------------------------------
 mm/hugetlb_cma.c |  9 ++----
 mm/hugetlb_cma.h | 10 +++----
 3 files changed, 28 insertions(+), 66 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c990e439c32e..cb296c6912f6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -121,16 +121,6 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
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
@@ -1417,52 +1407,25 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	return NULL;
 }
 
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
+#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
+static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	bool retried = false;
 
-retry:
-	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
-	if (!folio) {
-		struct page *page;
-
-		if (hugetlb_cma_exclusive_alloc())
-			return NULL;
-
-		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
-		if (!page)
-			return NULL;
-
-		set_page_refcounted(page);
-		folio = page_folio(page);
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
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
+static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
 					  nodemask_t *nodemask)
 {
 	return NULL;
@@ -1592,9 +1555,11 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
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
@@ -1874,7 +1839,7 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 	return NULL;
 }
 
-static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
+static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
@@ -1930,10 +1895,10 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		nid = numa_mem_id();
 
 	if (order_is_gigantic(order))
-		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
+		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
-						  node_alloc_noretry);
+		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
+						 node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 9469a7bd673f..e9f63648df6d 100644
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


