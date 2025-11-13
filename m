Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119E9CD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F380F8E0011; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FE28E000F; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50BF8E0011; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A52AE8E0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69D134CFAF
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:40 +0000 (UTC)
X-FDA: 84103650120.28.062C766
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5E41140006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tzs2MJz6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992578; a=rsa-sha256;
	cv=none;
	b=z+Tc3xRV3roLea8RA6774V8mR7idNF7k/s5wg6kloCKUbg3qSZosFI+M6HiqStbIa6H6Xb
	aN/BM0o1w1wE2egjjQ+IM4hP9dNLj9dubVZnKy7HWNKJPHWhwe73ldA5HcjnNCqCh/aoDG
	ScWX6+WprURl3zDF7u3tQfDAPr6LuT4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tzs2MJz6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ph1LM4e+4fMT8OTS6Q8r3xDATqFyFTsTZoy7H8qnSGI=;
	b=Bohk9RQdj0DZIcRwePITRNxbfVSPMPOIsUX7V05XqQ9V7B3VEsWZ5Pswa8svhwQVdg60So
	MQVkbBxZKu26Zq/Jh7gVv+UIFVZlMjYyEOAPU7NMwLVcfElYICK4yJxOann0ujTtOCZrmv
	YTRT6WjDg58NviBVsLZTf+QzWuujDaw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ph1LM4e+4fMT8OTS6Q8r3xDATqFyFTsTZoy7H8qnSGI=; b=tzs2MJz6xT6E8TEE9EcHiyhqwN
	xWtFOxV0qT+Cxp5nR3AhIzsPddmsaF9W4QNEqk8Z9kYQbvJnWIDAEItoGkPfrc2ttOheULJY2DOrW
	IgZayyXAJA88TIGAT4ktdNnk2iBdGrIc5Ko9iIxOpOr9JMCp3YnXc21yOuwSWc16XA1SXqMG8rf+d
	lIO1z+Vemfiubj8ExgiPjvz24rvtVE8BnwqwNd6MkchgyIidPXkGabrRwMuSbULkDTA1MNzuFd4nR
	9bm6bqt1kKXM38GlUmodW8pIKTwqBkBIcldszyLEQSSZATt+N45vjXbDnQST8Ll4LC1qERJG5Hdl3
	mCKfN4vQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOO-1M6X;
	Thu, 13 Nov 2025 00:09:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH v4 01/16] slab: Reimplement page_slab()
Date: Thu, 13 Nov 2025 00:09:15 +0000
Message-ID: <20251113000932.1589073-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C5E41140006
X-Rspamd-Server: rspam07
X-Stat-Signature: bj9pcso9rpozxiu4wpch9tifgup8f981
X-Rspam-User: 
X-HE-Tag: 1762992578-395851
X-HE-Meta: U2FsdGVkX197n26r/Yftndz3A/29HKtdc0P2kOPKkO/LaOH5bj2fT6V/SRxjQNGctZ45VOag0LNFAgTk4vzuhN5+fysVYzscFDaD10dLyIQyI7FOBKVCbA2Jf4M/IYoVcvw5ivstsdXN+N2hb+xK9i0s+i1yNbYV9+y33ScSuU1nstFEwSGTU1LGUWeMOoc/v4ySERHHkV9vXONB4G2AJEGQGILX6eGFOxD8DWkFvJr0TrMBvqXGTQw81hyet7b3lbeEzEE8PtK29v2kilPyBve5T5tI6u7SDa8GrT22vp0RWC67XDvQy/ZLMlx04Ik27qrUZMFLZl1E9ceOqSOpFZ/zbOJa8l0jrO7Yq9fkzfs6oJoBwLFqWTOwaCcdBA/iHO7zS8y+/uqsdZuuayV1Kx0IdE4GXbdFi5Ar11zsCn6KQ1xBgO9S6KIm87AO+XOfkzVKFy3XnBDqEZXaEA0gLMiUqx377EhaxSScxpbLb7VG5CIr8hjZYTKtKP7q9yHGcopgn6vXCDwFlMmkOYadwBO5IuAplD4t7dSDqd9jDjY+7w6s1dUVsKa3KWDQzr4trXPxKVpJ6peQPRvZsN9yHNrxx1mXgQOezDVryPoXFTxHEKijilbnTT/fogMPL9uFf72PRJfPn1ySkxGW/mgl6Xz2CPRoYPwimaM2TPACVyZFyja6cten8pIzvnmSFJ2GbEQBrqZnzt/7zxxo83KOpDTrUwpa9WHtPfML0aQzALNu7WgiEB4X15pAbW0WGw9Mm75kHj6Fapoz4muV5AU3si5u5QINYnHODoiy76rlWWUA8fqxaoiqK1ePm5miN3fuuLq4oT4hzx1z7ocqq7GVxBlfwakwx0XSLygRE/7mCm5NzQpX+D+H44hNeTQK6x0SajQ1CfbZD87EZDi4zaPFixCCzL42KjZfnRiCVQDk4Y1664gRhYQied+2qTL8wEp/K5vzbjZShIWggemmV/p
 WKIZ801g
 FRJU6Td/e3h/XtqEQ0S/r2i4MdzKYVYWB8CH9pNxZgKy58CaBQmYOyRPwRx8e1sCa5r3XMVIskkd4VNcntZgflUPDI5xDrTXvikqoMV23lNnZXN/JYZYY+p7NIOS1FpAyGIeanEit2VFMCy9aZVvUNpiG3605auCCwTQubSwwtC7IXXlknELV8gWwoQj2PMrXrQbofOC3q7mSUhcfI6UzN5umOMYUc73UxV99oQjQIB/S0nDO34DqrjyynnF7V6qAH+taINFeb3PoVf3gpcL3eBS6O+fHTTFaZQDZI6U3sURmWW1p+s4atHUBQNhq3dkzq2toLSIHcULZbZNEgrcrnl5df40dMjPqS3FI3rJlInPuPKp798YHAkulROTbPEJbxlDn03GTJRxhvy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separate slabs from folios, we need to convert from any page
in a slab to the slab directly without going through a page to folio
conversion first.

Up to this point, page_slab() has followed the example of other memdesc
converters (page_folio(), page_ptdesc() etc) and just cast the pointer
to the requested type, regardless of whether the pointer is actually a
pointer to the correct type or not.

That changes with this commit; we check that the page actually belongs
to a slab and return NULL if it does not.  Other memdesc converters will
adopt this convention in future.

kfence was the only user of page_slab(), so adjust it to the new way
of working.  It will need to be touched again when we separate slab
from page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: kasan-dev@googlegroups.com
---
 include/linux/page-flags.h | 14 +-------------
 mm/kfence/core.c           | 14 ++++++++------
 mm/slab.h                  | 28 ++++++++++++++++------------
 3 files changed, 25 insertions(+), 31 deletions(-)

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
index 727c20c94ac5..e62b5516bf48 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -612,14 +612,15 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab;
+		struct page *page;
 
 		if (!i || (i % 2))
 			continue;
 
-		slab = page_slab(pfn_to_page(start_pfn + i));
-		__folio_set_slab(slab_folio(slab));
+		page = pfn_to_page(start_pfn + i);
+		__SetPageSlab(page);
 #ifdef CONFIG_MEMCG
+		struct slab *slab = page_slab(page);
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
 				 MEMCG_DATA_OBJEXTS;
 #endif
@@ -665,16 +666,17 @@ static unsigned long kfence_init_pool(void)
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab;
+		struct page *page;
 
 		if (!i || (i % 2))
 			continue;
 
-		slab = page_slab(pfn_to_page(start_pfn + i));
+		page = pfn_to_page(start_pfn + i);
 #ifdef CONFIG_MEMCG
+		struct slab *slab = page_slab(page);
 		slab->obj_exts = 0;
 #endif
-		__folio_clear_slab(slab_folio(slab));
+		__ClearPageSlab(page);
 	}
 
 	return addr;
diff --git a/mm/slab.h b/mm/slab.h
index f7b8df56727d..18cdb8e85273 100644
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


