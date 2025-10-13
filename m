Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE632CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7768E0024; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E588E004C; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEE78E0024; Mon, 13 Oct 2025 09:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D01738E004C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A398F119F3F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:43 +0000 (UTC)
X-FDA: 83993201166.08.1A6ED3F
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf01.hostedemail.com (Postfix) with ESMTP id 24F3B4000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ws8ROuK1;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3/dj+ChEZkcgFm5CRr0GvqBh41TODr1WsBWz25ZfpE=;
	b=B/MWXt7MCX0xF0vGNp+JpkOFQ6hw6Qnb286+i3gijv/0D5iwOArxhlxlUG29nXqAUVHZnX
	4feepEBLOz/haSz9NoJfHpew61oQERwIMfQnNlpq86T8+C7aOeilLjMoaD7kEc3acn8fw6
	m3Bjkgn6pJxvaMvLApkUIMDwAbFjb44=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ws8ROuK1;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362841; a=rsa-sha256;
	cv=none;
	b=T+EhxQgE/l4QsarB+rsi1ntWDfjP4oHGJAFofH9Ch8O3WZSJd5c2jlPw/PPSG7B+MsKwv4
	vlI2rmyJ+7rokfJCdJt45tTJuJbUJa81peyxkLPccJSa7V8UEu8QVaTcZEVGiGzRPvW3+/
	nqOwUQAPXbujBKRGz4VevL0KyyFJ+hI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D3/dj+ChEZkcgFm5CRr0GvqBh41TODr1WsBWz25ZfpE=;
	b=ws8ROuK1Ml5xhah40Orz5haCvX86w83GnhsQijqfkE1yY7icjg96lE9yi/JBuxisJeBnf7N7h
	jt02RkZSFDbMah9Ws6cUwG23+noGjQ0Sd4xIzUL3OdOGU/0wYU+DOYuoQ5pWGjj1Xh2kYMuxrnj
	jxfShWTrapHccKmRVtYa2ho=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cldl64qV8zKm54;
	Mon, 13 Oct 2025 21:40:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BD9581A0188;
	Mon, 13 Oct 2025 21:40:37 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:36 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Mon, 13 Oct 2025 21:38:53 +0800
Message-ID: <20251013133854.2466530-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24F3B4000F
X-Stat-Signature: nbqhbqsbr7w41an1pfsgmekuhhqkn6f9
X-Rspam-User: 
X-HE-Tag: 1760362840-11716
X-HE-Meta: U2FsdGVkX18pIKZELCA2cl3ihNXSw4Sp4BNmowEF07AM0XCaPzGicdH4qbx6ybmvHw7m3vajzT8VCr2Ui1CDmiO6Zsf18Z6SX9T3FZhEZPfN/SQy4+5NPyHtcsJQEe9wYNPxOOi2mB2nG5xOOyWVwUP5a7qEIcKGoEaS3Og7wy5V95xo5xs81a2NX4OvzF1oZIOoOjmBIsHw8mJMdZAeIjUIvHe5oBcaP+ZOhvCnO+Yiio2LJ4g/j3L8dK0R9quntpQkX5G/pqJhLtQpS8L5tl5YsQ28yNvmFbhtDwsVCijuz2hdt/hwIOblv9vE288MXSLlC6AND2yeFBY5JlO3lfbBtCPc0QgHKcyFnu+6g+NLkHn2GuzRwJnMKYt6vf6V/P6TwKC98wlsWUhEp3jbWFiAD9ORCK+m2Pw6kCiwGEXe+I33LoXAbtRcz4HcEsT7zlKcvZ18CnipoluHDi+ZrFg8BiIuwVuJgiF43y6nu4s4iM+Ct2uU5i1IgQXqY64pNZHPR/sFabwdZKYIgN/gQFTXw0sMQMbfLmUOwWl0d8g6E3FVFZIzZf5F6x3HRB+KvvdX5EF861ec+InruC77JOYbQ72EflybuPsuxdG9+AarQfAPCl0iUBFhrBL/8gEaY5yFs9+6g2r6obxsqlKTfwBKpnVE7LFyKpqunECM0tXu4MN9KaeNP1Hh7q3/iMp1MHJkHV3n1UKuu/hWPOJIG1Ab02BSxXJkj2b/eDE50h95f6f9uYU4R52k94S4rz2iyBhvZAVJRl2OhC+cQmyDRledfLdsVQW3XOclOga8xNS9qoHD+7zyLV34lKAuNf2dsG9Na1eNUOCEbRTcKWcUsd8Fhby1U1Z7H+nEGy+qYintvRfc471mOalMQtm2/eDg2chfJ6hFdU69OzcBORETH32kUkVNGKEvIw1XJiIN1R6cXOLIM6qGYYMyCQgfL2vFLeKuBH+Rjfcu8QmR7dW
 OniP6iyL
 M8RMRefDTLkzBORsKIyO+qDBVfnicddFozd9C4inOKpRtxY+xbQ9/bJW2nzmiFZdj1Lns12otz5LtTXNM1a9GTRokOqN90nFnuOLn+hemxxY+kMK2abwvsDqSj4ziIagcSfe7cwHZXNF1EnudPWijI9lvXGD+8Y0ohGez0Cfr7vG7xaSfB9Eeigpggi3Zld3s/AdW2d/xkR4/wRWi8gu2jVRfGieSHCxfLAynF/mbb869hqlkb1ejBJ+x5I878uG/jy8Nw+8xl4HF6kddq1mHlTlyE+aW4EnKA8P8H8krM0JUQXvXrAVrq027uH4L6oo35ayqPZjESymff+407+nyusxwbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce cma_alloc_frozen{_compound}() helper to alloc pages
without incrementing their refcount, and convert hugetlb cma
to use cma_alloc_frozen_compound, also move cma_validate_zones()
into mm/internal.h since no outside user.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h | 25 +++++----------------
 mm/cma.c            | 55 +++++++++++++++++++++++++++++----------------
 mm/hugetlb_cma.c    | 22 ++++++++++--------
 mm/internal.h       |  6 +++++
 4 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e5745d2aec55..4981c151ef84 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -51,29 +51,14 @@ extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int
 			      bool no_warn);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn);
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
index 88016f4aef7f..ec64a3a88bba 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -836,7 +836,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		ret = alloc_contig_range_frozen(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
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
@@ -914,6 +914,21 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
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
@@ -927,23 +942,23 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-}
-
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
-{
+	unsigned long pfn;
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
+	page = cma_alloc_frozen(cma, count, align, no_warn);
+	if (!page)
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	pfn = page_to_pfn(page);
 
-	return page ? page_folio(page) : NULL;
+	for (; count--; pfn++)
+		set_page_refcounted(pfn_to_page(pfn));
+
+	return page;
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count)
+			  unsigned long count, bool frozen)
 {
 	unsigned long pfn, end;
 	int r;
@@ -973,7 +988,11 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 		return false;
 	}
 
-	free_contig_range(pfn, count);
+	if (frozen)
+		free_contig_range_frozen(pfn, count);
+	else
+		free_contig_range(pfn, count);
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -994,15 +1013,13 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	return __cma_release(cma, pages, count);
+	return __cma_release(cma, pages, count, false);
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count)
 {
-	if (WARN_ON(!folio_test_large(folio)))
-		return false;
-
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, pages, count, true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..fc41f3b949f8 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -22,33 +22,37 @@ void hugetlb_cma_free_folio(struct folio *folio)
 {
 	int nid = folio_nid(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_release(hugetlb_cma[nid], &folio->page,
+				  folio_nr_pages(folio)));
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
+			page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
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
index 65148cb98b9c..5f4fe54a5ba7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -936,9 +936,15 @@ void init_cma_reserved_pageblock(struct page *page);
 struct cma;
 
 #ifdef CONFIG_CMA
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
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


