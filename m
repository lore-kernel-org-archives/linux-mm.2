Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D16CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B008E0016; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2518E000D; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A2C8E001A; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 675478E0011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C04B13C0A7
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:56 +0000 (UTC)
X-FDA: 84029235192.20.E3D566A
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F49AC0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zCdNZSUyRTvri3nLQAMi7tiPgpd6UC23QsRf0XVikHs=;
	b=oIlsck4E3koOc5ZVyauXJcHqdyZ/e802GIhXqkV5CLsWbjSuJYVjiN6I5hLZmE7z3LES3y
	ieKejn26F+W5GhCm84AdlN94Dxt1uJVjRM/b3Z7KXask/k1t0OLni+TQQrTQp1QVMmEjbb
	tjlarEeWOAbh44QLTw2FEKf9SDuB3cg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220794; a=rsa-sha256;
	cv=none;
	b=ZMEOTuPxV3Pgi3fw7OoAkOJxcRJfXIF8mDLarK0IcSvbbooUySwzimd1IIzIK1uuXoky+h
	o7u8dkgKCHFuDCZ2NItWUHfOrnUZcgHB12SoczZaKzzA+9TVm5fv0Kpz8/kRkHlIXsddA+
	iaZ5Iywb2tDw7ItyNdB00LvJvyP/D5E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cskwx2wdSzJsYj;
	Thu, 23 Oct 2025 19:54:57 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 72C9118048F;
	Thu, 23 Oct 2025 19:59:49 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:48 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 1/6] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Thu, 23 Oct 2025 19:59:35 +0800
Message-ID: <20251023115940.3573158-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: ar31rzrua4p9ih4wewyw8uzqy6gyf7nx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F49AC0008
X-HE-Tag: 1761220793-814297
X-HE-Meta: U2FsdGVkX1+3gYuwK5Z4x/VhJqOQA2NzYN6jgAqZTRoc4l6Jq/yLzfz1ibzDEJS7B0GnSdkt01Os2TxEOKIiAM5X+p1YkTERM7kodswtxxw8RF9XnqNtV99IiwBWRnLH40zQ7SDfKCqMPUH/UdZ41E7W3Bi3IXZhcsAeM2uSiUo2wQ1VcLS+1WEB6xAQ6ZZRjVh1B2OG7mcRtUw9GOmc9wn83cBXYJAYCXP55n08pluijEs6GbYqJq+YeR64N1DU7A1TExECJZDkr1E0m4LO/ToqS9fyEGXiay1WWq/B/bntgayAOp4P5aMMpLdhO3B2+BUMVtPNRiRz5NGz2FKwZzYYTBwB5RBFjjg+37iawqqMcdCPCk41Jlndvl/fJ6XEbG+8FfOQCKsbA1Mlp43TzUCQ4hjSnjQNkM/DIowDBr+2qGTGdxb2ZiW8AxpeWm9d6NLBxPCtjKGrANaXoA5Pb80Z8p/bWwJFxWb8ed4g/bDFHI/60zcuV+SXkvMnFlGjVXdrD3AV7atUNThTpd8AuGd3Kd2jJshOEOSA576bikZahZL95z2VzSqnHYNTMuoyoOAxLnK1dUKMHgWKvNqjIHGY2enXDBlef6CYJcx0/JDRLFjk0M1FBq9abPw/gs3T0V2wSwrQTdqz7ye4ElR3DgRgrflw+GRaZEPyL4zVZe6QNz7sZxs7oD8xd5JCSVrjx6TqFfk5IRVHcXH6oCQQEiLn1tNXeMOk3NJcv3Ge94LsosW3XB3Etcbr7NOUWYdgeAmgyfiG7Ewk7sseZH3dS/RbMqUi22CWaxYOs9Evjtn8oZ14MiQOy6vRXzFWKCJsbw3GSF5s181sFhZ/VBY2p4y5cSalI9LTjHCw0OshEjJTQvNQ2DzqLuahqWHUfnmjCViLsgPcS8AL0Iehqv548s7BxhS68uCftvs/8Md5MxzRLVcUr5MScbj3q8R8Bix9
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
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h   |  2 +-
 mm/debug_vm_pgtable.c | 38 +++++++++++++++++---------------------
 mm/page_alloc.c       |  2 +-
 3 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f46b066c7661..92582a329d47 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -437,8 +437,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
 					      int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
-#endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
+#endif
 
 #ifdef CONFIG_CONTIG_ALLOC
 static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..d7f82aa58711 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -946,22 +946,26 @@ static unsigned long __init get_random_vaddr(void)
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
@@ -970,20 +974,13 @@ static void __init destroy_args(struct pgtable_debug_args *args)
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
@@ -1215,8 +1212,7 @@ static int __init init_args(struct pgtable_debug_args *args)
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
index fb91c566327c..aeb57ac45e22 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7151,7 +7151,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7178,6 +7177,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.27.0


