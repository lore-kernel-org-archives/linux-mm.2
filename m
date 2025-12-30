Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A6FE94120
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 07:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531276B0005; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5025C6B0095; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8F86B0005; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E96D06B0095
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9D801A15B9
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:54 +0000 (UTC)
X-FDA: 84275300508.28.036C776
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A9E4C0006
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lX11Megu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767079493; a=rsa-sha256;
	cv=none;
	b=8TegvZUvz+j4SjZZ4WiRmPV6PDVNaRSa1sP1BYa/WuCD1DsOefk4dtUjOGG6rYDdOaL6AG
	/5Dam0j6qPBAqU09hTFHgBJ6BlrJJ0qlsAXbDji9JieqZpf32a2+/w7Rk+vPP8hgyqE7TD
	+3YSGz/Mf//++/sB07sbLd9qIBwYcTU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lX11Megu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767079493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uzbpQxj+V1E7pCsrXlfewNDkd3JCgks0Qd16aHKnwg=;
	b=Jw20sMPlxqRZJNil0nqKVWGVB/GcFS2o8t0/TqtpErtJXgGu0y3IsJtFm5e0MM6CoGfhoy
	F12/FaSPginmYxtvrWWh+EWVOaixqPKHhZ6zCQO8jOCi4FktJ4X65JaG7b8tacuHuSie3z
	OPKFw9LgVIbMpc8yHrk+FeH2z9ZMLEk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5uzbpQxj+V1E7pCsrXlfewNDkd3JCgks0Qd16aHKnwg=;
	b=lX11Meguypp/BppOkHb394VWYLGgL3u4KeexP9UjrpR+MpFo26Ho9F6yHIN7Xyo3f2Dj2P1Md
	dldsG9/UGwfPkFUMwFMxyoYsLaNJDyC7Ffp6vTgMB0KXkvlXrPzoppjgnhRHsewSGul43vUOie+
	0BGLnSTXc0NjTh0DtaBjaiw=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dgPfz1qmRz1T4Gb;
	Tue, 30 Dec 2025 15:22:19 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F45A2016A;
	Tue, 30 Dec 2025 15:24:49 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 15:24:48 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Tue, 30 Dec 2025 15:24:21 +0800
Message-ID: <20251230072422.265265-6-wangkefeng.wang@huawei.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A9E4C0006
X-Stat-Signature: tuxe7ubufsixtsos4apun93w34h8w1ss
X-HE-Tag: 1767079492-499139
X-HE-Meta: U2FsdGVkX183bsrALTa9sjy5b/MmF03MAZd6G2bXSz1mfoXY8nG1yVMqc60iKNCiMuvK8+Zfz/NgCUw5fhryRj1XZgEE6kyu6ToxXJQnVWj33iifbJjaEYF5K4gFiGIMbFXJ+YIgJQitGUMEE/BZiAymR4fHnjKPYMBTwbJZ33rxSyP9c3mx41IwwB1tNR60xNltllTBjf/hmXDOcMl/Mr/3CgiLTuSCYuwD9AWQYwPgUGqLNsYycglQoLTFTByBuTx4BJKO85hyTUbJCgiViIGJw2IeryAYvDrVXyHddqCWYv2I0e6oKvKpDap6GoxHpPQkAJkxDEfWZBWLmZ0LuFtY7kQT4cnZ3ko6NyvnizwaCbpuk8lnVOz8Apm978f6qEc3ngnjE3T4h9ZGyxCfiuS0nu/I7jE2WeGlqRsDurVkoZaf4wZizeScUG1AkfOM9XYHGEbrAecnNoTWYaDw9DpnKael99Bjx4FFCqAx0MXyoQaO4u782KE8WWVwzCCC0+bie/SLHxn7lMAG4PHx9elm46/ODOQ26sailNBJgjigOn1xZHVfLpIuAMmOFsvX5OdUt6g9gNYkBMeRHRnHsHLqztz3R21MOjjZyhkx+yo+Chzc5e+pX/awk99EtXbHh1utv6jK9PrHFyyAuRy4J1wJkjluZiq/4iIo/q6czHOxMx9K6ss0ao5jDf4yP/49F8P4xjtpYh2EoSKTw/EwPkJ6Tg8C3djsSJlqqO2yL5zgEmp2eJMT3WNwJ6Cmtk1c9qk/HZg6YV9X0FSUDQSZ1TSFbb+bN3RA5eZBNdrtP9LcFhzMbUJtAbwbxsvhnNs1mJd7ycx+iYyZDmDW9JMrOaW7DyBJINns5wBSao4z9VrzvuzLFsKy8nVx05aeYDKBV0e0t+CTmn1I1lWBtM7H6MUof4SXI00w6QC0LSvco+yf6yV7RCB/J56iksz4vTVADsYg9Vdzj/MtPLPKjoZ
 55ZJtEeW
 8JusqYLC3tCr2/zvdMaCZUBOQ/K7TtiHn3B4TlE3T3QVE8tU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
incrementing their refcount, then convert hugetlb cma to use the
cma_alloc_frozen_compound() and cma_release_frozen() and remove the
unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
into mm/internal.h since no outside user.

The set_pages_refcounted() is only called to set non-compound pages
after above changes, so remove the processing about PageHead.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h |  26 +++--------
 mm/cma.c            | 107 +++++++++++++++++++++++++++++---------------
 mm/hugetlb_cma.c    |  24 +++++-----
 mm/internal.h       |  10 ++---
 4 files changed, 97 insertions(+), 70 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e5745d2aec55..e2a690f7e77e 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -51,29 +51,15 @@ extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int
 			      bool no_warn);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count);
+
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
 extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
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
diff --git a/mm/cma.c b/mm/cma.c
index 0e8c146424fb..5713becc602b 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -856,8 +856,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 	return ret;
 }
 
-static struct page *__cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, gfp_t gfp)
+static struct page *__cma_alloc_frozen(struct cma *cma,
+		unsigned long count, unsigned int align, gfp_t gfp)
 {
 	struct page *page = NULL;
 	int ret = -ENOMEM, r;
@@ -904,7 +904,6 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
 	if (page) {
-		set_pages_refcounted(page, count);
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
 	} else {
@@ -915,6 +914,21 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	return page;
 }
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn)
+{
+	gfp_t gfp = GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0);
+
+	return __cma_alloc_frozen(cma, count, align, gfp);
+}
+
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+{
+	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+
+	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
+}
+
 /**
  * cma_alloc() - allocate pages from contiguous area
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -927,43 +941,27 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
  */
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
-{
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-}
-
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
-		return NULL;
-
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	page = cma_alloc_frozen(cma, count, align, no_warn);
+	if (page)
+		set_pages_refcounted(page, count);
 
-	return page ? page_folio(page) : NULL;
+	return page;
 }
 
-/**
- * cma_release() - release allocated pages
- * @cma:   Contiguous memory region for which the allocation is performed.
- * @pages: Allocated pages.
- * @count: Number of allocated pages.
- *
- * This function releases memory allocated by cma_alloc().
- * It returns false when provided pages do not belong to contiguous area and
- * true otherwise.
- */
-bool cma_release(struct cma *cma, const struct page *pages,
-		 unsigned long count)
+static struct cma_memrange *find_cma_memrange(struct cma *cma,
+		const struct page *pages, unsigned long count)
 {
-	struct cma_memrange *cmr;
+	struct cma_memrange *cmr = NULL;
 	unsigned long pfn, end_pfn;
 	int r;
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
 	if (!cma || !pages || count > cma->count)
-		return false;
+		return NULL;
 
 	pfn = page_to_pfn(pages);
 
@@ -981,27 +979,66 @@ bool cma_release(struct cma *cma, const struct page *pages,
 	if (r == cma->nranges) {
 		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
 			 __func__, (void *)pages, count);
-		return false;
+		return NULL;
 	}
 
-	if (PageHead(pages))
-		__free_pages((struct page *)pages, compound_order(pages));
-	else
-		free_contig_range(pfn, count);
+	return cmr;
+}
+
+static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
+		const struct page *pages, unsigned long count)
+{
+	unsigned long pfn = page_to_pfn(pages);
+
+	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
+	free_contig_frozen_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
+}
+
+/**
+ * cma_release() - release allocated pages
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ * @pages: Allocated pages.
+ * @count: Number of allocated pages.
+ *
+ * This function releases memory allocated by cma_alloc().
+ * It returns false when provided pages do not belong to contiguous area and
+ * true otherwise.
+ */
+bool cma_release(struct cma *cma, const struct page *pages,
+		 unsigned long count)
+{
+	struct cma_memrange *cmr;
+	unsigned long pfn;
+
+	cmr = find_cma_memrange(cma, pages, count);
+	if (!cmr)
+		return false;
+
+	pfn = page_to_pfn(pages);
+	for (; count--; pfn++)
+		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+
+	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count)
 {
-	if (WARN_ON(!folio_test_large(folio)))
+	struct cma_memrange *cmr;
+
+	cmr = find_cma_memrange(cma, pages, count);
+	if (!cmr)
 		return false;
 
-	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+	__cma_release_frozen(cma, cmr, pages, count);
+
+	return true;
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..9469a7bd673f 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -20,35 +20,39 @@ static unsigned long hugetlb_cma_size __initdata;
 
 void hugetlb_cma_free_folio(struct folio *folio)
 {
-	int nid = folio_nid(folio);
+	folio_ref_dec(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
+					 &folio->page, folio_nr_pages(folio)));
 }
 
-
 struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	struct folio *folio = NULL;
+	struct folio *folio;
+	struct page *page = NULL;
 
 	if (hugetlb_cma[nid])
-		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
-	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
+	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
-			if (folio)
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			if (page)
 				break;
 		}
 	}
 
-	if (folio)
-		folio_set_hugetlb_cma(folio);
+	if (!page)
+		return NULL;
 
+	set_page_refcounted(page);
+	folio = page_folio(page);
+	folio_set_hugetlb_cma(folio);
 	return folio;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index b8737c474412..ae7bd87f97b1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -517,11 +517,6 @@ static inline void set_pages_refcounted(struct page *page, unsigned long nr_page
 {
 	unsigned long pfn = page_to_pfn(page);
 
-	if (PageHead(page)) {
-		set_page_refcounted(page);
-		return;
-	}
-
 	for (; nr_pages--; pfn++)
 		set_page_refcounted(pfn_to_page(pfn));
 }
@@ -949,9 +944,14 @@ void init_cma_reserved_pageblock(struct page *page);
 struct cma;
 
 #ifdef CONFIG_CMA
+bool cma_validate_zones(struct cma *cma);
 void *cma_reserve_early(struct cma *cma, unsigned long size);
 void init_cma_pageblock(struct page *page);
 #else
+static inline bool cma_validate_zones(struct cma *cma)
+{
+	return false;
+}
 static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
 	return NULL;
-- 
2.27.0


