Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2758AD167E7
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5E36B0095; Fri,  9 Jan 2026 04:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF986B0099; Fri,  9 Jan 2026 04:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022856B009B; Fri,  9 Jan 2026 04:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B96D66B0096
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AFED160406
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:32:02 +0000 (UTC)
X-FDA: 84311908884.24.EA698EE
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf23.hostedemail.com (Postfix) with ESMTP id E72BA14000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MLiA0Mc5;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvXKuJ9eWQP+n7Fr1VxcukpX9jYAGn+2FU2i3Bfv2Bs=;
	b=i8Hn0eL7ygj509rDJKzZvCcg24J9gOJnYZOdOR5JKerhACRkjjzQ3Lr156vPV4pr67s9b1
	VXVP67XBnfYTDUWiHJhG2yRw59Qm9jJPAVSA8SXICGpz8NvkWbC6Bv/TADtU8Seh/+NtNG
	eeK4NkDvefVUM2IdgMcL/p56Y8PXhw8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MLiA0Mc5;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951120; a=rsa-sha256;
	cv=none;
	b=3mFAFb5SHh/QNDUxFfph1ZL/uUiiZcjfRFlt7SiUTpHmddiCP7TEr0yb+Q07tNujasAK2M
	zJuDjFkm5VQeoUpPGjyjolDRJf5W3oCDWEd034PFSmQiSHikfUwWRb3rQMvdwsgL2FAtc4
	DV5mqCJS+Z4a1/NI74VQ8M4OCM2XtbY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wvXKuJ9eWQP+n7Fr1VxcukpX9jYAGn+2FU2i3Bfv2Bs=;
	b=MLiA0Mc5AKlQG8IxeFz3w+Oeh+/Yb34EqrUFjIWJwn8y5XtKQndr8HwXOmJOsxOCjgjMqFdi0
	CWytbVyXfrcrRWpLCnaYhewzfosw9unATa2rslUcQ1BKnpzzndrBv5dV+lr49W+IopE2udh0wA4
	qlSe7bQ1vK9kd6uoTd/tJok=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dnc001hVvzpSvL;
	Fri,  9 Jan 2026 17:28:32 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id F273E4036C;
	Fri,  9 Jan 2026 17:31:56 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Jan 2026 17:31:56 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea.uj@bp.renesas.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v6 6/6] mm: hugetlb: allocate frozen pages for gigantic allocation
Date: Fri, 9 Jan 2026 17:31:36 +0800
Message-ID: <20260109093136.1491549-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
References: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: E72BA14000B
X-Stat-Signature: q89kcnqddxp75ebe4g3zip898p49phkd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767951119-572133
X-HE-Meta: U2FsdGVkX19puB6C47xJnyojKMVIoRS7EfTfSbRpw/sYSLKFyXIwQviyteOFDV2Yjc5roj6lXRERIF54rChRTlPzt25T1Fc/9wTl5O7Bc4dOIlmJVX+DDmSQtv6el1wkfym6tm3Cnv8d+9qD9pj5Em76MrnG140DfAI+TWWHWLpyDSkYVv7uhMjxHNOvYw7a5jc6Jo+daQrLp+36mRHKjR+t7t/UtKiCiZWyvspRq7Wpww7U7NBBmrpaUAMnslJw8EmxZJ/pmWG0oxNpkPWnDc/oahF5pI/lyDBozzE86GC1d7vR5f9GBiELnnO56sD7goS/WsjpR7oUxSo8FPiN883ApyW39Fzdx+JMMeEEJgu1BUQySE8wghTZhjCKE5twlEOjOcnizK1MzEm6YFY1s+ox4KcA3GNnC0HtDRMh+PO5aoqQNxSS3vZiEMUiHtCcHMQotMmzAlgIIfNrsTJmzhdwMo3frBpgAM5jdpdFqT19ff8kmqWf4evQyRAZCauD88ODbGAdnDpiRFcAKsxRYiT82y99ACHfVm8viUsfpM4mA6Je43U29qICiOEmg/V2Hvng0guFNRRsc3c9DcYEv7Y2lH48lZLqfSDLX+0HDdbjpP/oGGM+009bNoXr5fKJMHWb8MUjpzh/+Jv8k0BvA9gB6+hYqB8/q/lnrYSKG2gonJxH48Hanywy/6YMwbQmjoXHwKNTkcN7cpeZv+HtU5HRk+avzNfthWg1T3Ej4JbLsYGDiTsyGX2hOudCdF0qhCCaL6C0Mdh2a/ZYVN/V2k2nxk/338K78kusXPujaJWvXGC0U8c/P4mdkWuoi8NKyp2VyNghwMkMUjMvP3YzfLvW4ZL6DzfW/vNY18GwRrQzj2oTqvrGNd4EAVkMPwaQaFlOxyjKkjUmUqj/lhasCevgIjPvINY0Q+Ud+qh8Gzolbe5nDfvlhcTfw89V0ftCju0v4PHWnrg0WbsnfPZ
 g/pz4qIP
 WLWGHjkJsUbnkLV42BGWM/5gMwV8gwv8UuWDXoh/KNve7PTtQJ5IqAA5DrpkuR1XBrdJw3mbh/3PxsCz1rLk5VDU5OIQojStp5aT0nI7eKSUlUhDlICq43vHZgFoXStWJ03hsPTNa5ilAEVAPvpBgHwKIguujbbpBdIfX7W2rKhK1lCPjPkM3dS3RvKTEiZf8ohh5hBRqJmgMSIiTY0Q6Dw/FyO9OsDNut9jTowrJjZ2EvJ+u1f3AaA26fMW8eUv/6ymINzQlMFnywlr4IxwVh2Bf+N3cL22jz+nlhT8bnnmfd/2feEB4vdwAJAbkmt7Mn7fPjZrEBm1EyYJrk1liq5mz0s8mXbSgG/iWNxX6ThN5gn5OTk3S89eSbesw3Muj6i6/Q4pMMZHMzq14rJWOtoEaUZylgA9UtAqcphf2IhQAWnujw/CjKUTwg+aeUhL7a1IheqDZ/KGe18OnqYmAOQxabufUMTRqiyq/h/c++8dItHTM4Y66UstbCKeQ8rQoS3yTsyEJfNjmPn3H0sGxTQOgU/LRyFZDuvOUlDjg2KixJvb4dZDsy7Snkdywfzpf9O32x/kPjMhPt/YaD7d7oU7PUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_gigantic_folio() allocates a folio with refcount increated and
then freeze it, convert to allocate a frozen folio to remove the atomic
operation about folio refcount, and saving atomic operation during
__update_and_free_hugetlb_folio() too.

Besides, rename hugetlb_cma_{alloc,free}_folio(), alloc_gigantic_folio()
and alloc_buddy_hugetlb_folio() with frozen which make them more
self-explanatory.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/hugetlb.c     | 75 +++++++++++++-----------------------------------
 mm/hugetlb_cma.c |  9 ++----
 mm/hugetlb_cma.h | 10 +++----
 3 files changed, 28 insertions(+), 66 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 762aeebf85d2..8c197307db0c 100644
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
index 58ceb6c9e410..0ddf9755c090 100644
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
index 78186839df3a..c619c394b1ae 100644
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
@@ -13,12 +13,12 @@ unsigned long hugetlb_cma_total_size(void);
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


