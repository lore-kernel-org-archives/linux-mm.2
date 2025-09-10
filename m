Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D03CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4BF28E0003; Wed, 10 Sep 2025 09:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD0F8E0001; Wed, 10 Sep 2025 09:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913B88E0003; Wed, 10 Sep 2025 09:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80B808E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:51:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BC6613BF17
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:51:24 +0000 (UTC)
X-FDA: 83873477688.22.1C00914
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3DAC714000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:51:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FX+8Qla0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757512282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC/bk+aKvdIBrrJ30kooAeuYcfMT0KbaNtS5uBTN9lc=;
	b=LnoLDOXXeWH1xfdJeC4OWofuxIY9+sHGlOnSU/+VRWrAefZTTalA16t6dsEWOcbzUrFKr2
	4I2RJ6pBI7UnpVvuZI6GqlUQFur8SpQOxJQ7U7QEgQktiuWzHaz4hXPRJCdO/A8FA4bZZA
	pp/3JUvLvqYYkt19pruApF4pZYoVWqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757512282; a=rsa-sha256;
	cv=none;
	b=jXW7yQba6npBTEJslO7pkWtfirhnr+Ox4RsdpouGn7bqnGSHoDq3RZ7urEuLc02r7ZMp/c
	X3FEBf4+mnnMaicOlJoIFQ5iSYSckTPYkxLPJKbDsR2ovj+LybhWZMkGLuVOip9orHF8IQ
	CfwOeOSDfx+iFDi/mjPGX38gr2BdiQU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FX+8Qla0;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZC/bk+aKvdIBrrJ30kooAeuYcfMT0KbaNtS5uBTN9lc=; b=FX+8Qla09u0oS8yXVaC2o+e2t6
	ZQ93liu5yxXdmo6r77uOV8xjnYN49IkT+JxMCwkqfRBATTTIATJeeLWmP9WebqrxPsh9dvhe7eYzF
	V4S/JgUVjxEfQoaIPXMYyhBzsy2W8fH7FcwlMbpvY93KRaq0/5t4L+xfFyHM+KuQApFeDGmlMgEc0
	k+CBFI88CGcwQcVSUd5nZAJJsmXtgpUwGpzjeY16rwWoDxvscx/bpNFbZjQjn2xAOlTgkiar6Dzlo
	vFCHZXakf0wwgAhRYxVMqq8aGjdGeFo6v7daqPe6DvhrJyiJy1ofT2RQ8S71zOorVCq1Cpr1yoX0s
	FeUY4CjQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFY-2SfW;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 18/22] usercopy: Remove folio references from check_heap_object()
Date: Wed, 10 Sep 2025 12:55:00 +0100
Message-ID: <20250910115507.1991829-19-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g34esukuk17wpgy8ct8frwb1qozhpm1j
X-Rspamd-Queue-Id: 3DAC714000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757512282-343861
X-HE-Meta: U2FsdGVkX1+n9ThgSSs20QTDFqgXcOrpGWAp4XfhrfmOQduONtDlvgB1liLVOBIJ+e8rUcaANjwzBdl/t9WbtujA/9RFAjz/Cofy3F2hys8DYIlQ/1pCId2Z4NEatko/M1VJ6uNB3AdSOgDqZ/icnOyurDkhW4y0q/p0hn8XCc0+NKFXd3yvCSfQ9bPz7oPRZF0Uqczm7LEg1815QXrwdQoIeyaPhkw0JM1m4GvDwrGnh7wKawA+0GYAaQouJYKAoguwKpXT2zAsO/3SHKa04wpQIiojhX8gSbMLK3Nd1FsdYViD0NdrBaePL88pbQ9zJE/VNqhqxDIleF50Wmc2bYfBOEZpLov5jk8AKs1UUGumTby+6JfIU4P9WhGDh5qzJMCckGY0bUqB1rCyK650qJnpW3ZnPIJTR6LbFF94kOPmGybbuP2aR7P2eoTEr0oPWlJXWx52vpD54p0tNZOxCEYnLFofZ3R/MtI06lfLH12zKfdwmtqYozuwZA8rasXJsx9aloYr7db0hWR+5Fz3CtTp745sRSlfqQSAiSfrfvLNzDHCfJJXLgNDSefAdQrc362i2VJva1KCslai9JJOIi0ki+zXK3+PZ3Pv5LvhhH73dffvu/6IiOZZxhezITuZHC0ypEy2h8uWimGtfzyi71CAIyL2RUj/gQHAVTo8AXkUa1ozvb6CkOHYgcFFsaMaYRmsg1sJSQbFSgcgwf1q8/+5sxx+s1hgfFedWKGS/CgoBZFIoogOsGOCJ37aLrh+BTiFhPoKB6PQjw4MZBLxSSWkfUL5KT6e6PveViuaFPx2DQZStx5iT+jMLzJKPs8Ttnh9q/dBJlBICDZHsyAx0wdkjeazcYt/D4KcHo3YdcEdmwtsYpdspfcxazCJPktu3DY9+n0drMwzh1yzT11BKwq7VEAwExNdRoW9cGZht3fhJf56+VB+L36pd5ufYYlk7tSHjV0aR2B3iRuvcLX
 ky1kq6VD
 WnYpk1P0ZP8KD2h+NesT58nMm4FSSsNeuVhWKiGFeeyl19tLj8HUElgyXHKp9g/amK20w7oEVRDbZjWD/Y1LqEHFA23dV/3xI8XGT75LI5WHgwnFGgg/ZsZiKK48GR7NZoHG1PppYoRQz/QANJerCylrZjewSfskkNAnUSlsdHW4Qz27+5dMYhmmjGsCO7nd1gU4TKjiltQzcQOkLcdblrWK3BB7+XOWgE/j/GQaSVbHprsMBO2VNecsrZNYmXZPxLv1+ZlsoTrWeUTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because the pointer being checked may not lie within the first PAGE_SIZE
bytes of the object, we have to mark all pages as being LargeKmalloc.
We could use virt_to_head_page() instead, but that would pessimize
slab objects.  Once we move to memdescs properly, we'll tag each page
as being LargeKmalloc anyway, so this is more in keeping with how code
will be written in the future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c     |  8 ++++++--
 mm/usercopy.c | 21 ++++++++++++---------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 523a4551ceb6..58e8354e12a2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5299,10 +5299,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
 
 	if (page) {
+		unsigned long i;
 		ptr = page_address(page);
 		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
-		__SetPageLargeKmalloc(page);
+		for (i = 0; i < 1UL << order; i++)
+			__SetPageLargeKmalloc(page + i);
 	}
 
 	ptr = kasan_kmalloc_large(ptr, size, flags);
@@ -6226,6 +6228,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 static void free_large_kmalloc(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
+	unsigned long i;
 
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
@@ -6236,7 +6239,8 @@ static void free_large_kmalloc(struct page *page, void *object)
 
 	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__ClearPageLargeKmalloc(page);
+	for (i = 0; i < 1UL << order; i++)
+		__ClearPageLargeKmalloc(page + i);
 	free_frozen_pages(page, order);
 }
 
diff --git a/mm/usercopy.c b/mm/usercopy.c
index dbdcc43964fb..8d21635147a4 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -164,7 +164,7 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long offset;
-	struct folio *folio;
+	struct page *page;
 
 	if (is_kmap_addr(ptr)) {
 		offset = offset_in_page(ptr);
@@ -189,15 +189,18 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 	if (!virt_addr_valid(ptr))
 		return;
 
-	folio = virt_to_folio(ptr);
-
-	if (folio_test_slab(folio)) {
+	page = virt_to_page(ptr);
+	if (PageLargeKmalloc(page)) {
+		page = compound_head(page);
+		offset = ptr - page_address(page);
+		if (n > page_size(page) - offset)
+			usercopy_abort("kmalloc", NULL, to_user, offset, n);
+		return;
+	} else {
+		struct slab *slab = page_slab(page);
 		/* Check slab allocator for flags and size. */
-		__check_heap_object(ptr, n, folio_slab(folio), to_user);
-	} else if (folio_test_large(folio)) {
-		offset = ptr - folio_address(folio);
-		if (n > folio_size(folio) - offset)
-			usercopy_abort("page alloc", NULL, to_user, offset, n);
+		if (slab)
+			__check_heap_object(ptr, n, slab, to_user);
 	}
 }
 
-- 
2.47.2


