Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417E8CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8BC8E0007; Fri, 29 Aug 2025 12:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0508E0001; Fri, 29 Aug 2025 12:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD5D8E0007; Fri, 29 Aug 2025 12:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3F38E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:30:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6F41140804
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:30:29 +0000 (UTC)
X-FDA: 83830332978.15.1BB0B04
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31D3B18001A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:30:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dfkJ0HGC
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756485028; a=rsa-sha256;
	cv=none;
	b=Uc8UA5S5TWJsgxbe7Bxm/yYQpF2PyyG8g98NTEy7JVHfveum4s7ClKxA5ZKze5be4ZPijR
	lx66AyUwJl+Bidfocmrz63CbXEjKn+J//wKqAeWQ/hSig2ZuqTF/RVU9B1McUserJ5mi/o
	JJc831m3VxzxZOSK42Vuws0kxZyNAlk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dfkJ0HGC;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756485028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wufkbHjb9cVwLDFN2ioiC4hewzh6PkDpKG3aZ3Uujw=;
	b=G6fXiPe7lFXFsIUujL8mKttV5ggu3Gy+Y11TtAhhTYLhWNhGlIMlL1jDoKlgkMLdWlcfNc
	BL/a8xMm8JTdKS4o41/81zxFKF3/l4LMm1wYI69W/47AsapZi4GX/fpcRBlvBypn6IRbbI
	OYN4cjlaqfBc6rs2ZC/eIWO7S8Q1jL0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=6wufkbHjb9cVwLDFN2ioiC4hewzh6PkDpKG3aZ3Uujw=; b=dfkJ0HGC2Le/sqbVa9mYTay1LC
	VikQi648gc/fuMqpKSUbHj0Xsmm0a2wkoTFWT3WrV4N0qSkG4hNErMm994tbL9+QjtvJ06knVrf9Q
	NvmF+iZjVmJidl9dbPVi0Bd0rU1Yd6a6nfVZ1UpLadLSLaW5Wno2QRNtYSB9I1ZYqR+yWQct+9DIZ
	aaeSCNAfWjFsdUkpCsHYlds/2O8ijdjey0Lwdq8NCnRDT+kMt9gVntWje9sVBFuQvqH1G3hUjZMMN
	Jjikg8HxajH6A/I75VhAleh8HrC8xD6M2VK1NoF/3PVI9JbbzHPZ/9Dy6G6rk1wlR83XWpwrd5pDq
	WpFb4hZA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwH-0z8M;
	Fri, 29 Aug 2025 15:47:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 06/22] slab: Reimplement page_slab()
Date: Fri, 29 Aug 2025 16:47:10 +0100
Message-ID: <20250829154728.3397606-7-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31D3B18001A
X-Stat-Signature: chjwi56zb17oso3a57ggbuttpg7kzqj9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756485028-661245
X-HE-Meta: U2FsdGVkX19LqEtczOSHeFtXoWc8VHtNO+8sIM7CEUyQB0S4HawuEih/lKtYMuLfs9fnKViJCAcy33je9i1ahn/5pQV1ux8sC80QzF4a1m5dzQMirq2JPKydxpQeHNn6UDtq+4uedpug2pj2+zg7zlua60BcoLxYyfYj6x6vpuG2WDvsR0knNBfyZI5ymtqGSYhNe0atj0DlUhdOj2AyoMSkcYrWl5HR9rhod1lYltINJHVLDQ0pCyzNNn7+gN8hrZFaf+Tsa1+/SPZwcR6jjyL0aT8glXmLoGxwhmjdAHq/mVZWVv6vNNOEuWEIZtTEX+fmncxuNRRuoHvxlI0lA+U6MMMfvkFOsHdMwv6jMsp7wffhZj6Dgnfg8ukPFnelFT2sgCqABnpnkTgzaJw+ubilbszi2tQKAmc8Rngs/p5bddJVmYmlrj7ccjNhGhG7I9vHshWXmHcdZWlS9AaIsu1yrcgg+HntybOASgAS8a63yqOYYH4TsELlQVOgrRukGYCoil7jefHPQlEUORIoGfzNZGKPryvm9agFiSS6MpmnX9f8qSLHmWuaSQrt9wSRh2k4h66/XTJQlkACYgari/ZC5A6ER15FkuM73Nrie1NqRMxZM454qaHYE95/4Mv4z0vz5M9IwDkjgkUELq7FBZR48QtGwlFDW0IQCQ/8w5OM8H9vt4fvgNclLqjWo7W/D9+j8HRJ7xmT8wWKdLsonY/mPnZoJ5gRTOaJ9Qh2cRys+nOUlqN3Nx2UeKMvQGVTZLdin5IxnyT5b0QS3fAN6JU81LVm4kw5xPS62bKL4X8rCBp9szCaNYne69fcx2v2qQYq8YuZj0rCMG8o2N5lOszr1fB2I2sUoqb4Bw3shzk=
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
index 5ee6ffbdbf83..39ed2f243279 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1052,19 +1052,7 @@ PAGE_TYPE_OPS(Table, table, pgtable)
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
index 0ed3be100963..5fb0f0f8f99a 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -613,12 +613,14 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct page *page = nth_page(pages, i);
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
 
-		__folio_set_slab(slab_folio(slab));
+		__SetPageSlab(page);
+		slab = page_slab(page);
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
 				 MEMCG_DATA_OBJEXTS;
@@ -665,14 +667,16 @@ static unsigned long kfence_init_pool(void)
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(nth_page(pages, i));
+		struct page *page = nth_page(pages, i);
+		struct slab *slab;
 
 		if (!i || (i % 2))
 			continue;
+		slab = page_slab(page);
 #ifdef CONFIG_MEMCG
 		slab->obj_exts = 0;
 #endif
-		__folio_clear_slab(slab_folio(slab));
+		__ClearPageSlab(page);
 	}
 
 	return addr;
diff --git a/mm/slab.h b/mm/slab.h
index bf2f91a6c535..084231394250 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -142,20 +142,24 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)
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


