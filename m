Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DE8E94121
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 07:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437F46B0089; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B01F6B0096; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186DE6B0089; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5B946B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55B871615F6
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:54 +0000 (UTC)
X-FDA: 84275300508.10.C13E7A5
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf29.hostedemail.com (Postfix) with ESMTP id 23FE7120004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="03/K6Qme";
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767079492; a=rsa-sha256;
	cv=none;
	b=BU8fVB3j+cdgBXQCxT/w+1yBoodTrbZ5hQaFZeICDuDcSkYNW6eqhdBSxlKxq84fe/SkfC
	Crd85zEABTFM6YrwVnB8cNbuCn776r+6nw30WXGzPGSEXckubaw+Eqz51mThx9x775wTYc
	nAOeSWumFybxbk1TS20UY+5PBY0vlfE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="03/K6Qme";
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767079492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIrJ63gMQ73PTR+9fCyHgsHG9uXbRTWlg7Cyhxd4wOs=;
	b=S5ecCmtWwypb3D4hfeuQwrRnCNaouPJAHUpy4dxy5qkMfGs/UvkB/REvvPvU/sD5FgbVl5
	7GUHrljeVeKXWxLpcqfJ4aUaH0laRcVQuiUeEjzjsuQL4jOc713KDyhyckZAbcnN54+uJn
	WzPf7BjNOefYphkIz8ZtwaxueASv6+Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sIrJ63gMQ73PTR+9fCyHgsHG9uXbRTWlg7Cyhxd4wOs=;
	b=03/K6QmeWfvlk+iHY376sUXDs6UJjy2WPoitYgajiWJ2IxDE8BgGzYCbNJBsbkqauhPwyFRBf
	DAoyor+m4wWqcu9TeL9ZDIwSQIUxL4rGf4SMFzI/u9CALH+7j5HyUzsvlPQJQO6tdNkhDCrvVq0
	Q9vZtIjIb5IBv065aD3dUC8=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dgPf90kHwznTVr;
	Tue, 30 Dec 2025 15:21:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 148F34056E;
	Tue, 30 Dec 2025 15:24:46 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 15:24:45 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 1/6] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Tue, 30 Dec 2025 15:24:17 +0800
Message-ID: <20251230072422.265265-2-wangkefeng.wang@huawei.com>
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
X-Rspamd-Queue-Id: 23FE7120004
X-Rspamd-Server: rspam04
X-Stat-Signature: oja7a8datrm34jkthsxjg7gggyiafw1f
X-HE-Tag: 1767079490-288615
X-HE-Meta: U2FsdGVkX1+ZBw6fIPG8zmaEdaIpZmLZwimogXCuXQptH65M3zmeP/nLD7NBZg00o9nMaC5NM1kiFn4oE6vQZGhG4TCKBiq2/lGeLMMlsmQSV+H1xFKtt1oKj8qP65DTKwDRx97vSutj/hzDZbS8MbM/dm2t0MutjmG3fz8286sOBjv1PfHEOP3eUBCJiUr9aU5lOt4j+rjDHBVPObrpzXdwbu3beEwXM42V/mtmIZb2GvXpxFldWheKCcNZXY3M3gPDCBYYln46b1TGXeTXXdYuL3tJj1Je3Lg2opxRTIkSXQQLLb3Dpn6PbjUtrpwjJInr96kIGoPKu9yVhjS1KKNBmGz4/UOZK52Sh1iIrBCKH065V6VEAi4YfUVul6AfZ8WOURg5TQLgq8f4IS0+9y1tR00HKjwkZSWRHWqJo1cUeREtcCoMhnP3w5+/cohzPByA97ma9NKmdxf08rw8OJXrMdwyPSr26zYX1LW58ewkiGCiJ8IPEaVB2o9ONkBVxdln9PSb3FFsKK9NlBJxaZNVgeEb5iTXFi246LWG/eW8Xl3K+nh7DIiowP0JUkM/M8WLAzweIW/dSeIDBZ4zZcBvXG0J+WhYUD/gk4TwwHM09JQa3/Oln3Ov+iKOgO4x+4g5AZdbEusi/SYcoDaMwO4iqYOR2YvHpSgPbx3ClBzIdz9Am2oR9f+fPbxbwzUO49UK0TSvl65hEEh5mRDZmw39tHNLl+95fguFSzhC8xgwcpjkSezIFs6ZRXqxhKsJXXIRX1J0xYOJxc31F7ZGopfoUb2xZfrWFgCYLZwueDENcJHI2gGm5i2GK/HYzXveDYFbbfq7Idrhnbygm/N1QU7sXlKYie0D8ZuKC5pgNLKjrW/KfRNV7wPgz3NyRWzY5iS80AjAG2dQC1DLk67cCXXz8Otj+PJU5VFNlAxiS2+xuHij8eZMKDdRUH7xzTpot1ZEUT6aQFzgAFQwvf5
 v+fandLz
 zp6Uq65n9ktHk40XwO3f1dmnTiJ9LRj9lISROAd4ss045+2sZz80QmMGDzjxhrS9jlMG5nXIVADEj9kb0Vx3D/ehRNQeRFup1d71iTlZz56ohKuru/HfKUaGitdUYgU5bqF8oTlKRHWhkqE9b4LkCFbdoTZiNJvp9EImC/Cw4KGLnohfAV+ym3ZloNb3MfbOwz471z6OwqX3gSpPqPjaQaMbILBHXSBxD5pLSWFyMs7GeeKc+207+papyF0GjLcCxygI54xJVLTYby0EjsVSKzKDAe9Ol5dTpz9obWJBpC1zFPgdaBh0vMDOlcMM0L3ZLudjAK5cHkY1bgeF0tegVOPFdYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new helper to free huge page to be consistency to
debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER
instead of open-code.

Also move the free_contig_range() under CONFIG_ALLOC_CONTIG
since all caller are built with CONFIG_ALLOC_CONTIG.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h   |  2 +-
 mm/debug_vm_pgtable.c | 38 +++++++++++++++++---------------------
 mm/page_alloc.c       |  2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b155929af5b1..ea053f1cfa16 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -438,8 +438,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
-#endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
+#endif
 
 #ifdef CONFIG_CONTIG_ALLOC
 static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index ae9b9310d96f..83cf07269f13 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -971,22 +971,26 @@ static unsigned long __init get_random_vaddr(void)
 	return random_vaddr;
 }
 
-static void __init destroy_args(struct pgtable_debug_args *args)
+static void __init
+debug_vm_pgtable_free_huge_page(struct pgtable_debug_args *args,
+		unsigned long pfn, int order)
 {
-	struct page *page = NULL;
+#ifdef CONFIG_CONTIG_ALLOC
+	if (args->is_contiguous_page) {
+		free_contig_range(pfn, 1 << order);
+		return;
+	}
+#endif
+	__free_pages(pfn_to_page(pfn), order);
+}
 
+static void __init destroy_args(struct pgtable_debug_args *args)
+{
 	/* Free (huge) page */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_pud_hugepage() &&
 	    args->pud_pfn != ULONG_MAX) {
-		if (args->is_contiguous_page) {
-			free_contig_range(args->pud_pfn,
-					  (1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)));
-		} else {
-			page = pfn_to_page(args->pud_pfn);
-			__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
-		}
-
+		debug_vm_pgtable_free_huge_page(args, args->pud_pfn, HPAGE_PUD_ORDER);
 		args->pud_pfn = ULONG_MAX;
 		args->pmd_pfn = ULONG_MAX;
 		args->pte_pfn = ULONG_MAX;
@@ -995,20 +999,13 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_hugepage() &&
 	    args->pmd_pfn != ULONG_MAX) {
-		if (args->is_contiguous_page) {
-			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
-		} else {
-			page = pfn_to_page(args->pmd_pfn);
-			__free_pages(page, HPAGE_PMD_ORDER);
-		}
-
+		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER);
 		args->pmd_pfn = ULONG_MAX;
 		args->pte_pfn = ULONG_MAX;
 	}
 
 	if (args->pte_pfn != ULONG_MAX) {
-		page = pfn_to_page(args->pte_pfn);
-		__free_page(page);
+		__free_page(pfn_to_page(args->pte_pfn));
 
 		args->pte_pfn = ULONG_MAX;
 	}
@@ -1242,8 +1239,7 @@ static int __init init_args(struct pgtable_debug_args *args)
 	 */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    has_transparent_pud_hugepage()) {
-		page = debug_vm_pgtable_alloc_huge_page(args,
-				HPAGE_PUD_SHIFT - PAGE_SHIFT);
+		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PUD_ORDER);
 		if (page) {
 			args->pud_pfn = page_to_pfn(page);
 			args->pmd_pfn = args->pud_pfn;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a045d728ae0f..206397ed33a7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7248,7 +7248,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7275,6 +7274,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.27.0


