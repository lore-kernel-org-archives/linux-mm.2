Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F689CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C6A8E004F; Mon, 13 Oct 2025 09:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED798E004E; Mon, 13 Oct 2025 09:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC738E004F; Mon, 13 Oct 2025 09:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76D548E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A180140406
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:46 +0000 (UTC)
X-FDA: 83993201292.01.7E3110F
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf01.hostedemail.com (Postfix) with ESMTP id C29F84000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zqyT+mEF;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQvog6X8zPZeyR1FvVhoKDFK5oNZUVFPFRgdEefZ+dc=;
	b=H4Rw7T6ogFOtzwouDDptuVwsbbpWP4TB4EKpKyf7QT4D9PZzmaEBam1zDueEOrRKhLy8cl
	SZu3QFiDbCPQUwLEhTiYuvtLxACTTEjL+HJNCAHLeXt3YK/6NZIXoB8eMd2OaH5go2u9Af
	VEMdryyOijlmYYkRSsbaTCtqpba0VWY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zqyT+mEF;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362844; a=rsa-sha256;
	cv=none;
	b=OY+UVewlLjBXD/dk6uNhcH8rj4eNqOE9qNPY9Fkv/yHqbDuhizx3J3CT4MvbSLWTVb1cq7
	tWOBGQ9nLo1L7xxjuktpOPcMh1sQtooDZlHx4VZptAONUIT+ow+PC9nRU2WnyC71P74YHp
	xfqU9qXBonTvMKF7vCgwjmvQDnGi7rE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PQvog6X8zPZeyR1FvVhoKDFK5oNZUVFPFRgdEefZ+dc=;
	b=zqyT+mEFQhajdOp/TqAycaVXqQk0u2YykpQuqm2hr4fbQo84XSjqsDoXBcFKrMqlh2KvY6S/t
	RawLc8Rf3iunKbTMjJF6a79FLV1FQ+0P2TwnHN4mP2YpBCfvw74mG5MbtiB2dfrwUme/FhOUPYA
	JiaAUiQPaOnmLy7CtDg/1m4=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cldl8059qz1K96c;
	Mon, 13 Oct 2025 21:40:20 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7DB5D1A016C;
	Mon, 13 Oct 2025 21:40:38 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:37 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 6/6] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Mon, 13 Oct 2025 21:38:54 +0800
Message-ID: <20251013133854.2466530-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: q15qzem7f95bf3rxfdzbag54ecccegcy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C29F84000F
X-HE-Tag: 1760362843-104197
X-HE-Meta: U2FsdGVkX18+zHbhMO+orW8DfkRPgTdvRySu/b7JQCs9dItulIr+dnPBSAdlZi+J6eqw1MmhI4QjV7H1YH8/2/ujXR99+2QS+vV3wZ1eMYHMTJiET7b76D6D3nZ2UJFy0oWYzGatNBJHg18lBsrcTFmaTRsXfESfErAy1PdqLd5Haxt8FmrGKSTLL28ZJCsJDOtIM+E2k0n18KdToo9eEv7K+ojnk0KF4ksOz0zkHnxlT+eoIhJpFDrOgtKYTq3C1v4KwNJUN5hYB6PqqqW1eyw0GdKW4u1O7Hh7UGHvezpZvETgLS5M/fKt5pdc+isfBgymH+1JEgpVp1rxcQb2CyNfmWdBLXbdsS3MbXhQNEpVTKAo6VYuxlC1EB17hToHyR2OHUhqIjtb+61PM2ks76fFtRxxNOue4iF/qldydO3WsdrS91lvRBZnN9eEgVM+PkDAzze6GzdTke9BscHWg3jBvcTnRqJwGK7pSKmId4qPXSmf5fwv2OSfMs7AmfqVCoWYmHGPGdu0NOQnpENoElwDebtrup9ttSM3dLwCoCpOvaALLBaIcctA6DJrQHbkNbSOH/Hc6lOY7hBCIENvi00PJngLE0iaSxt/E1udUsqVQzEmJiBkvs9xv5Q+RrHK35QyhtVttyrkxvIWkX/s7z9n8vHnX4Vpzr8bjJge+6VKpNl0o+PhKelz7Ze9DGmkRBhMxQ7WY7QNpLjflL1xdQ1mhM1vq16ypF1zQj7xAbIXDmSd83znn2oKC39hXs7jTfaf5Zv3ldFiCb2OGQLoFEOUCTqkR8n8yXLyDh4cIJjt7dhJ9n4vSmGGeIIj7Y86+iHf033IYL1Bi34VnTRYII97LxvyCA1dFca7W6Q9gn3Bko2pvPYzGveDEflsO7Bp4HbYRkvGdi/nfwIVUee2tKKt5W1KRbXUZxJAsSvB5hPqgh1qJRt/L72MgJUFqy18BU0MlU2OjqrLtZfG2rO
 WW6mAX7H
 OSGUI0yg1KNXefM0dIOl+vSB+KyShcM4OttCHNddOA1hwqKe12sH0kLCb/kCxqTIv+6QtxLoxc7XD8xw=
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
 mm/hugetlb_cma.c    | 11 ++++-----
 mm/hugetlb_cma.h    | 10 ++++----
 4 files changed, 24 insertions(+), 78 deletions(-)

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
index 85b2dac79d25..528754683dd4 100644
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
@@ -1471,46 +1461,24 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
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


