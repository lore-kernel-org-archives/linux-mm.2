Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2704CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEF68E00C9; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B523C8E0106; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DCF8E00C9; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 628798E0105
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3158A1A0F89
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:45 +0000 (UTC)
X-FDA: 84034186530.01.9BC33D9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8EC7DC000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cQNZnINc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKWmfByFtxYQlDkzWTDKFEiPy9+AjaREeaRH403kMuM=;
	b=AFx4g47N/mpH38q3QDaXgHt88U5JJXxVNGYmtkSujQ5kCPRoYLYsZNIM4Un/t+Lvlue0Pa
	RRIluxRtksfhm29jDeqqYU7FBg08lxaoBEXTp7ZmN30fI2CJmzakb/bwu9aRhqBw2+atgO
	W7iRNHq8mYF0QZkrBNaGr/+bfCJ75Z8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cQNZnINc;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338683; a=rsa-sha256;
	cv=none;
	b=MHXALv7Ns9nQnrOp6so/uMI69ADgrzPErT0j2vyhwIMavtkpfxeh/sDROkyQJfLXHCJrBW
	ED+v1GSpK2Tns2X4Dje/3tm3SQZo1RHh/ongjJBKS/9DlZrAi0a+cjaBloQ21+cebDr8xq
	1GByZ2uJ/Mj49RTEl3u9euA99mVC5JA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=dKWmfByFtxYQlDkzWTDKFEiPy9+AjaREeaRH403kMuM=; b=cQNZnINciBXOwW2SKKKDUfJDmH
	sH1UKGsUp7FhCSYuUS4vZCHYjfE4i12xE5AFpVFBePISr7nFi7WP2D2TzLZbVXfNHRcgNKhbzIMQ3
	4FqUVwtfMaccOEcmlRjHHDQ1jFkRtr0PoyebRqzYJLfFHVY3VRKsbiXRs/bT74E/xU6NFk5LiBlKL
	8zK8w3irDCosY8fNQ2ugPo60ARakopjsSE2ZLTTC5viYYLIRqU+AmbF5hPE4lGgdLSfCKLik8ChXj
	5mt5Zqe+YqyheT2jMQHYmaLEb/7G46MHKGhFOyM4NIfkHIKJmH3+Re5hctyeRbKXM95POdcvHoLkN
	tjjHpuNg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKQf-1Tbe;
	Fri, 24 Oct 2025 20:44:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 01/17] slab: Reimplement page_slab()
Date: Fri, 24 Oct 2025 21:44:16 +0100
Message-ID: <20251024204434.2461319-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wh6xstezn86mmajai4cpacpp4su6cmia
X-Rspamd-Queue-Id: 8EC7DC000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761338683-18211
X-HE-Meta: U2FsdGVkX18mhn5mA4pVz/xqGif0z0VRzoXzEMLLSlUr9fPfngbxzCbcBbgDOcdx385I2Rma8HyOAit361qUZGRz4DBQo4g7HkcqdIuCg+/BT+3Ds+Dhrk9WZJL53eWMd9qbAxXS4RXXrR4eiUvH1kxJzE3owh56BazxpM8AbW11OuVlf9tq3pC4hPE4dNEpVTY/GxmElihDV9gK2fCVSDCsm1hVN8o0pgtdAWdSPHmsGjTyucYbCnGyxyZVI2CXXbyNfW20xYw1nFqGqrG9F/l/DgCbsq9I+H6AqsKeh7irgvHWCiBkOGPHc46eYUwMKOYC+LUlL5pGwxmynVoVdC4uyrtjS5jTTxZxMFEQTP/1TewWyZBEAM3ZwmT4a2iNpWpStU9VrYwcPuNH1nKCcd3JrxNwWaiGd2Of1t1nWIgh2X0z9R99iVTZ741n6xafwOs9ShAglOSKSdLNOuJ86ET1+pbKe0KCv8/iZRRbS+udeiBpkyrWbAMu8NJ+pbrBLp03/o37aBEi34xmFzNbjwRx6osEq0kWRWrysYjWO79PkOZzMABUN9bBlTuoZhU+qd6PSWWZ793V9UNaIcNhCxuGEcV/M2LPGJqvsr1unN79wJEZNHlZeC5hS+qo/rjhcaYNmP2owTev5Zrj2YiC7NUHy7Hf3b/MJWSnrdlVxRjZn+kvdqvwy7/vNimkNAZZqBROowFw1GJTuOexXgTmFMCvRLR6kpWgzfurE1CeX3K/3TpoP3VUKLPUiJwg+BlU33hP0MOkTUpwdIqwNr/c+i482svJMhrss0gs8z1anLKEerWg/JrcV998nR2CjqY9Qz9zewIlbVMxMKtxHHyNJxYI3cB4x3ojxCQHSR75dZB7ZokEAY0N0+v6E6itnPQ1RNwRQreGT5hLXOoeUmWhM5oSmyHHM7oPb9e4IGV4g6jxjwPsKX7pdyRF11GSvhRTogFCkyj0iPEAMVJkPyl
 49r2cJo0
 tS7d1dXREuNwyigPmFHXHc0C2xrzsLVbap/CXBZZsp0OdjGDFnm5+doLpDjLvMkJd0luP2r+zThwJMipNXYEkTJFF4dbEW9ijg9Ti8RBvJcFUaqH9q8EuIJop0MiaXJlkP7evT18h5EjjT+LeVMi6BY5snBaGsZ8NGPzrVdqwijhYWUKg03h1PpcCaZ8ZVFBMV21egOX/S+IexfreuziGjdYB/JEuvchxKfKuvmqT/+t6+dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separate slabs from folios, we need to convert from any page
in a slab to the slab directly without going through a page to folio
conversion first.  page_slab() is a little different from other memdesc
converters we have in that it will return NULL if the page is not part
of a slab.  This will be the normal style for memdesc converters in
the future.

kfence was the only user of page_slab(), so adjust it to the new way
of working.  It will need to be touched again when we separate slab
from page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h | 14 +-------------
 mm/kfence/core.c           | 12 ++++++++----
 mm/slab.h                  | 28 ++++++++++++++++------------
 3 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..6d5e44968eab 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1048,19 +1048,7 @@ PAGE_TYPE_OPS(Table, table, pgtable)
  */
 PAGE_TYPE_OPS(Guard, guard, guard)
 
-FOLIO_TYPE_OPS(slab, slab)
-
-/**
- * PageSlab - Determine if the page belongs to the slab allocator
- * @page: The page to test.
- *
- * Context: Any context.
- * Return: True for slab pages, false for any other kind of page.
- */
-static inline bool PageSlab(const struct page *page)
-{
-	return folio_test_slab(page_folio(page));
-}
+PAGE_TYPE_OPS(Slab, slab, slab)
 
 #ifdef CONFIG_HUGETLB_PAGE
 FOLIO_TYPE_OPS(hugetlb, hugetlb)
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 727c20c94ac5..b16e73fd5b68 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -612,13 +612,15 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct page *page;
 		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
-		slab = page_slab(pfn_to_page(start_pfn + i));
-		__folio_set_slab(slab_folio(slab));
+		page = pfn_to_page(start_pfn + i);
+		__SetPageSlab(page);
+		slab = page_slab(page);
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
 				 MEMCG_DATA_OBJEXTS;
@@ -665,16 +667,18 @@ static unsigned long kfence_init_pool(void)
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct page *page;
 		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
-		slab = page_slab(pfn_to_page(start_pfn + i));
+		page = pfn_to_page(start_pfn + i);
+		slab = page_slab(page);
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
-		__folio_clear_slab(slab_folio(slab));
+		__ClearPageSlab(page);
 	}
 
 	return addr;
diff --git a/mm/slab.h b/mm/slab.h
index 078daecc7cf5..a64b9b2c8731 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -146,20 +146,24 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)
 	struct slab *:		(struct folio *)s))
 
 /**
- * page_slab - Converts from first struct page to slab.
- * @p: The first (either head of compound or single) page of slab.
+ * page_slab - Converts from struct page to its slab.
+ * @page: A page which may or may not belong to a slab.
  *
- * A temporary wrapper to convert struct page to struct slab in situations where
- * we know the page is the compound head, or single order-0 page.
- *
- * Long-term ideally everything would work with struct slab directly or go
- * through folio to struct slab.
- *
- * Return: The slab which contains this page
+ * Return: The slab which contains this page or NULL if the page does
+ * not belong to a slab.  This includes pages returned from large kmalloc.
  */
-#define page_slab(p)		(_Generic((p),				\
-	const struct page *:	(const struct slab *)(p),		\
-	struct page *:		(struct slab *)(p)))
+static inline struct slab *page_slab(const struct page *page)
+{
+	unsigned long head;
+
+	head = READ_ONCE(page->compound_head);
+	if (head & 1)
+		page = (struct page *)(head - 1);
+	if (data_race(page->page_type >> 24) != PGTY_slab)
+		page = NULL;
+
+	return (struct slab *)page;
+}
 
 /**
  * slab_page - The first struct page allocated for a slab
-- 
2.47.2


