Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A10CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E6D8E0013; Wed, 10 Sep 2025 09:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6098E0003; Wed, 10 Sep 2025 09:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33248E0013; Wed, 10 Sep 2025 09:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2D368E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:11:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6F231A08D4
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:11:26 +0000 (UTC)
X-FDA: 83873376972.29.C9580C9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 036C84000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:11:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Fe29CR2B
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SyO7GEwXYAHYZcsCy0qpMmbE1vQ9CATN/sRPOWmjEQ=;
	b=4BR+oGpONlV8V27C4UkVUNnWXSx1iYN6o8aMMzclE+pM8LtVEg/WxkoU19EpSp/FuJ3KrM
	ox2Gz6Ft2oxEywDDfPRLImJwTLYMF19e19WFjTwomBfp7BX0rjhNVUZuRjiV4+9kvThI2f
	rE+Ns3MyU4Nm1aLLTneJvdHIjRPy4ls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509885; a=rsa-sha256;
	cv=none;
	b=lNe4Hmx16dBwIkBQQlbKQM8zfa5QkRxXhgv0ZxJaP3pjvx9xhGwwcn3cLvuEx/18gOE3xu
	ZTCxktFSz11S9q4AQEGCOaZrM57xac9eOEM9fcLWAJjV5VsLl67SVn9CbU6fu+aWiA03f5
	3MsGgHBKNKSW4ZtLJVaG++dHRqGsgd0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Fe29CR2B;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5SyO7GEwXYAHYZcsCy0qpMmbE1vQ9CATN/sRPOWmjEQ=; b=Fe29CR2Bvi84I4ijp6dfaa280T
	reYN0HGIDS11sxTQXFKGTOGm/Bj1d5RwKMjI9MUkXDLrn9cKCsf7q6ZgiPsQqZuCukJhof4dIVu5+
	ZYWmYHuLGNPnHD+8gPirh+ZnPYgpK4ho647HWOjW9bMHNWP5Q7F2uKgNFUfSzYMpoVqUGIuOzXaeq
	su8nLBKwtwn36turBDfPBbqJRh/5C1mlV6ATDcr7WjsozCl0PG69fLdkbFN4zR/NG6jHvWq7dQu3Y
	6oX/si4SkGMT8asZZJQU39zbNcAQL2aChx0g2B7qf49gNB9rQGUHgBP07khy0wwvvPKA92iO3jPEo
	jDROpL1w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MEm-1Y3d;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 06/22] slab: Reimplement page_slab()
Date: Wed, 10 Sep 2025 12:54:48 +0100
Message-ID: <20250910115507.1991829-7-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5b5gxareio9a6y35xqema1mw6g3b7q7m
X-Rspam-User: 
X-Rspamd-Queue-Id: 036C84000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757509884-336661
X-HE-Meta: U2FsdGVkX1/xFZble0ChhVMrwqDdz23QaOFWRcCD2kpYLGhmlvcE8ajK6H+2pWaQACJ/7X/TFC5pFhlKrbdJacFtK/S88E36imZqf5GB4i1AylM0HaS9NN+wylPIws87ty3/ZjFHpv9fCOlB2Rw32bOmdmBbXex29TY8PSVnPTGc1s9fFhVrfitth8bGPVlch54QLvUIu2+QK40driymcInUvI2c591liKaJEWKQsYIJKxDIcPtCO+ll1gbVcEQ2/zy8OX8Ug20DZOSK8hvG00bYssBp7W9rIOsxR7dao4+WshyudmnGUnc7AHzc/GrK+ggyYwpW1rMiD/vln5dFXZae1vU/muLqP2DZXa5FdGdy78JYmXm8TK4+nOisK8oRA3uoy9+ZCC8fuUO17m803Vq2KnnyiVIgkgPO8czlc9DvFuYy003wWUNyO06xiRNWKtXSYb26o+86jLnEQyXRua/vwOQ6pYmPwsJc6XTW17iNiN44wADbDoyWaC8xJKpR5Xlq07G21QmTcCPVV1GlKS5+uwJrf7iA8B3y5nNj9Q9DGp4/cGrAnDucRq3mfSnxrpaFh/yvLz3x5C/RtAJsVrUKBGGCbOAeJb878TWk3sY1uu3LyhcsA1i4L0iUfj1XzVYI31irb4xVU2V8lVnLCwtnY/xq84l+9pOgkzaGOhE1WZktt0y89cPcXsHADGAEx+kqrjoEVs4K0gNTZqwqQOTyQvncpwZ2tpUnS9+3AaM7ekk9d06ZUQuO58GwnQPsmuYlVt9CCtvm1ShN0B4hApy5hPD71fhIsDymKm5zJe3c3hiVa2gI48ylXag7YqA9cTjYCl3z+Ny5Kayf8X0E7L4wFwJXyh5OmToWJC8zRB8Obz9B4jeQZ421WWI3jwtpKaKn1RSWGx+MT+qiUlzhgUPBK0Qj4az+oGlQGdAoOOo9F6ocABHDxNSBvLil7MTIg5blGmDwdHME9u//u76
 8RZr9W0D
 4sB2hzRPquaNm4GmKBSUIvOEbIx731y5MgLvZ1zLBXMKUC6wX/+P4+uilWWXIkQ2NFoz0WzcJIpuveQbAwwuknsMyHdjSzDDOmV8BZTOSNvKRn2LaRh08IYCdESJBUkRKOlhrk822dJH7GOQqimpZC8K4bwF6VxK14YY4CG16zOcMMZiQnnPyu+zncE1Sz77tk8RE
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
index a57411252564..a997207c3b71 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1055,19 +1055,7 @@ PAGE_TYPE_OPS(Table, table, pgtable)
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


