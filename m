Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122BCD5E13E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604426B0093; Tue, 16 Dec 2025 06:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFA76B0095; Tue, 16 Dec 2025 06:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494446B0096; Tue, 16 Dec 2025 06:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 218D36B0093
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF69EC05C2
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:41 +0000 (UTC)
X-FDA: 84225164562.28.F470A0E
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf21.hostedemail.com (Postfix) with ESMTP id 735C21C0004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="bUPTI00/";
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVdxRuy1vtlNFWNDbQpHxYqRpffboUy6G0gHNnHD/cQ=;
	b=lgHIMFL7TXoUv3DmoE42juh+h8GlOcRA4y6HQlei5F0PJjvxnVIVeSJjboIb4YNG+10/aM
	46zi/4Wb0o0RgU09JywMh509rUm8fN0+7L7oF6G5xy85hyiwwlP2rCgA+MzhbtFHC6rcXH
	2V3lJDNDvH8EbpNyFHS7fO4eUWJZ4o4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="bUPTI00/";
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885780; a=rsa-sha256;
	cv=none;
	b=b+pqKQDOSntwXu+HxrgbvYXGkmtCq8nNrT3ZnNmU9d4Pd7+bmGy8l+mh6l78vdaSZmokwJ
	MYOCPjyqmHswO5TMqdTlJjXIZ16SIHfDaR1DPS5/WuxQt/F8H7+HlHcxwIxP/znUvAxhi8
	sqsEMHcgdwv/FJSoz2km7uS0mQfd/IM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OVdxRuy1vtlNFWNDbQpHxYqRpffboUy6G0gHNnHD/cQ=;
	b=bUPTI00/BYe77YOSookDVPBiH2JwNRiJaEMJk+DHx1ct/hRaX3HOzS6Pq04/mgn5DImwG0tpa
	pjXg8kHJF9qdlV4vBJWSjmuaswRJt/woHZrF23b0GnaZOLRFHAyhqhxV/ZdKaFw5GDl/5lSXgFZ
	5tAewQFTPvpr/ZHXqKBxKZU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dVwBj3wC7zpSvn;
	Tue, 16 Dec 2025 19:46:53 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 19DAB180488;
	Tue, 16 Dec 2025 19:49:36 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:35 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Tue, 16 Dec 2025 19:48:44 +0800
Message-ID: <20251216114844.2126250-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 735C21C0004
X-Stat-Signature: jdcf6gpc6eaao1bfn6desjnc9p847ah1
X-Rspam-User: 
X-HE-Tag: 1765885779-990616
X-HE-Meta: U2FsdGVkX1+8XmF3+qy/WgEaVDI56zuU0v+vhE65CFKxuh5/izVDVSArS64x0VgeFqaoxloaBtzwW8ygKSkbkxCdfcWL+SIfPpeA/NuU9yHQr9qC3+d4kwXyCNb4FjBxkvHpst16Lnz+RLdgOzo/o+IVMl8V9RnsiA7kTFKzC0G4Z9A/88zk6yxTHsL1fL7QRj2Q/l45d5rtKEJ/mO/F9iAZutbPoXMHy9f8QLhZ7UeX8qSwdbDGXSXz3QahIV4YXOvxRXBJAsTwH0BrHx7d6//yHD59wzwYWWXyZQ0ZRm/7TkvPB0IYUbcUITUKyH29FxWiI9ZfZOzOlvloiPQbjKhuFNcHdfBM0piACwLz+Khp18gS0TSXp6NQqimM5hr4IWfOGdgX+vDiKTfbBXANVwlug7kEsNGzLlEpKIWffsXI9bSxxugft/04kNaZgx3Lz/DcdE8rUqrt5MLHHx7ZIIabTsGv5w9Wsp6uqrHc//J9ylL9umkQyiYzxNfaVZElY4P0eWXPoGbwodWwQpRLWoU2yDPaayObCaDUEPbasF4OuStn5oSWmlOf1k2Au+iYz2sr+4XjPDVnpoxniORVeOZ14AicZnWw4aPpTHh9LiCD8QDLiEOrSBFcptdMUUcAUKoR3j7inQindy5G2UYLg9MR9A2SjrpE2G9JNigD6DRoeqoi+VYf8iBQE7GwBfoyeGoWGHM11vkPPmMuyCpmwMXuWJiBOELEu3ThbEgUwmPwL3d3pBpZByL6mOr5uohqXxTGaMFChFmNJbkgRbMwLWQmDJmPgrLnluZBhc23sFkAleYoRIyNoUgyMalp6CnxZ26feEIwnhl82+8y34xWMnkUzUn6gKWO4Y2FdMEvCh3FUx3qTivHjkXPDSKMm/4MxtwtwnsnKfp47DFGTNR3BO/t5ug6YhcP0MLwWDqywvm+znqd98qLY2pAcbdyNVt045iguWxS9CpV0AnuuCR
 IAoKmWNY
 qPlZSgJ8ePVxUVG4RLM4bevN4obFd1mjBZzi9yS8X/86/mLzUw2PIoKpxLdJK6+Y2DropwI25uz1jKpg=
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

Besides, rename hugetlb_cma_{alloc,free}_folio() with frozen which
make them more self-explanatory.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c     | 63 +++++++++++-------------------------------------
 mm/hugetlb_cma.c |  9 +++----
 mm/hugetlb_cma.h | 10 ++++----
 3 files changed, 22 insertions(+), 60 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ed185bbca419..7779ec838da0 100644
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
@@ -1417,51 +1407,24 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	return NULL;
 }
 
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
+#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
 					  nodemask_t *nodemask)
 {
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


