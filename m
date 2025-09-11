Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA01CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219028E0005; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C75D8E0006; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AC08E0001; Thu, 11 Sep 2025 02:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE0D68E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:57:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F04758C7D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:10 +0000 (UTC)
X-FDA: 83876062620.09.01723F4
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1502E1C0004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757573828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9oPLJzG99Jh3YwSf/9dS14WB1D58fDFox/TWeEN3RpU=;
	b=ToXpdRIR/Np/aM01GfXYaNKP75jSg+b8igjGjx0RvUu+p5BdD37BjaJjAxU84PH3y6pm9R
	WkWGPrG3vbMFcd6ysTNpQTM/H+jlWGmkvsN/OHmgBeM8oHO+U1bucHcGoDayeaj9if32OZ
	bpOG29riQcswFMU71DFsy9bUDcvFxDY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757573828; a=rsa-sha256;
	cv=none;
	b=sVZCCLrDqDM2hXlAiaJ7Ge3y0Rwwp24VXkig2PHT/HYICHPGEY/rnLhTAkQA0uMA8Nf8rk
	p1ahWvuiqPl7rpFsvRAQC5VJQM5/oteODAUkDcW0qqiErLeq02qgjCAWmEadnLXB7b0O35
	YznNuOINVBzMz/QjCEOWZc6w+vsUG0c=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMpCG4Vs9zRkNW;
	Thu, 11 Sep 2025 14:52:26 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A6630180B63;
	Thu, 11 Sep 2025 14:57:03 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 14:57:02 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH 1/4] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
Date: Thu, 11 Sep 2025 14:56:56 +0800
Message-ID: <20250911065659.617954-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 1502E1C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: 68xnc99tqq75cp7i81nuefte1o7a5q39
X-Rspam-User: 
X-HE-Tag: 1757573826-478995
X-HE-Meta: U2FsdGVkX1+EOZH79ncbuHM5ksf9CsYOVgH+hiA4z71R4NzDtdvo8XrtIkQs0F8k7znpwqaK/YL2PVbMzDNkzJMX4dd1yl6w+VhRm4+hD0hxW8QZJpY9F/3LOqLju7M6BkdEZKleHhvpddWaJU8PhoHkNH8ZExdgMgJ67xWKgyv42NarbSLtOZtb93U/MCKhkytTDZiEN5OrVTki1wUeFjumubXUP4lNqiISo9OgviHs7eHxX4E92XssvxxjAVpv8hH34wNcDJezlC5poXjkxoZc2i0Ktj0skPMJGwgfFlyW2ao02Hl2mM/+4n4fL49K7pf9bvkFn7HJQprN4RQOP9Oh8SZc69Nz/RmBGoiwnAn0tgbIVaZooCbuoldsHUTzWF0puoQ8k8mdLIagSVDxrKJ1RGPn94ubwf9hrMvmlSSVO3Q9pyR3B7CFVZxom9jtL5Y3HG7dJOkdW9pACcrhHdaKcaH/J8UsBHhEGAD+fGs8HHKnxZw19UzCf3viwixylk0tn1vpz15wwGfeTVTjPYIlXj1qQ58jYy7r/PBA/oHiK1QVRh0nhU8128jOd02dpoCBNgtUXHouulYDi2DYKPnjwjzw80308tyewWSgfqb8NM3LQiCtrnn5yAkp5bDSaFN6Vu3EVDxKnwJCtTjzpNqM+dWRJ89gq3b0TUhmz2jgYMZikoZT/TtEcgmtautH55alpcWeNGJne1bVqRI1wOaYSrWXf+dJbFcFbwhNf/YUh7kjoJqOnEZr1apG4GyZwxNzMcZ0IFvK85X5LpnrqrRAjCIHF0bBU9CYZNeftkN4qgEfRDAn2wqrn0Oar6QXdvOAgqYbqGMVjxwRnCbIKea4ceH9Redlvawvuz5wS3lBeHNf1Ci4LLq6zs4nLbh11LqEcP8YcQdJPTwD1xa4YFII8hmsmhglBxKpyhqbC7AbxWtCBuxbnXoMpJ6S1wwQiH4+TEjqABg1uprTC5N
 /ryuqCWz
 QN6OQoJPuD+n0QuyecKR7L+zHMdMdwd5YwgHWxvZmFewe7DKuQYB+vI6B54HhXUbAmoSAVEKWuZdTIc9TbrZnio0kND4DQlKSFryhNsBoDMN7I6AbaBSkS6zdpyT6NGza020cGV01otyn8dCjOwU4Xe1W02Seuud2VJhIsVFfwL09zhAQEFlj6hkGDYU7s32VxdfEOFCebZMUupIDe7vGAW/iqe4h3XAtqtV3QZb5EGD+s9wqTI/WRK4Hlcs9JTC3pmp9/kMdVwZFHEtkafdpeCljW5T67D0WC0jxfXmkfOUkSlC6WhmIWS293QKtwRXhvO+4C48N5wy1sF4mb7Lfm6hf25+vRK2PC/D/nuSOgky+IC8Xsup8Ds2pxFXUs6xa0goAGISTX4SOu/Q8IXNNBVpPuOOqKPTDtqp15PvtkrcphwTniT8d+0PHJHmdneo3dwTZBGVxYGTOiw5sJ3IRkGrO1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new helper to free huge page to be consistency to
debug_vm_pgtable_alloc_huge_page(), also move the
free_contig_range() under CONFIG_ALLOC_CONTIG since all
caller are built with CONFIG_ALLOC_CONTIG.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/gfp.h   |  2 +-
 mm/debug_vm_pgtable.c | 35 ++++++++++++++++-------------------
 mm/page_alloc.c       |  2 +-
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 5ebf26fcdcfa..651acd42256f 100644
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
index 830107b6dd08..767321a8b26c 100644
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
+		debug_vm_pgtable_free_huge_page(args, args->pud_pfn, HPAGE_PMD_ORDER);
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6ff9f17d5f4e..587be3aa1366 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7090,7 +7090,6 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	}
 	return NULL;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
@@ -7117,6 +7116,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
+#endif /* CONFIG_CONTIG_ALLOC */
 
 /*
  * Effectively disable pcplists for the zone by setting the high limit to 0
-- 
2.43.0


