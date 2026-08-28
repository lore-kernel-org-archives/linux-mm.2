Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18A5C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665206B009E; Thu, 27 Aug 2026 21:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6155C6B009F; Thu, 27 Aug 2026 21:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDE56B00A0; Thu, 27 Aug 2026 21:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD4A16B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:56:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25BF714023C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:56:08 +0000 (UTC)
X-FDA: 85149012816.07.AE72F72
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D37D120004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:56:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=LYbO2KI7;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Dv4NqhjD;
	dmarc=pass (policy=reject) header.from=ruivo.org;
	spf=pass (imf29.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=9zuV56l/qgXmDAJTkcSlImju8YC5S6pgLDypMF2ZN/4=;
	b=c9C4v4szhD8/UWwRvokNKz0YtD9cXsqCDTLS+yu8GPZx86gRNEICNlXM+uweSytvCI0N2s
	WKzA0KNMR55kQyaa5D7QXIw4pBiKoLtlmbhBjWNzlEAUX1M1GKzo9DbDvakd2xXU3h1cal
	F96Lvjh3bnt9bfw6uWjI8npGi57+F9s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=LYbO2KI7;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Dv4NqhjD;
	dmarc=pass (policy=reject) header.from=ruivo.org;
	spf=pass (imf29.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882166;
	b=1jqMClk4vO7kxBzpkGIU/h41ohnMcUt4uBhpawXzslSFnLcFmexPNFsJ2D6r4dLHg1KDO4
	7Mp57GWi/Vj7ZV7WDJbe2zbCJWcFD7i0ccmr8cSBOBDrr+EgPNcnBVuFFwIfz+Alg9nUXb
	UVmjJYn+VhTezOzbCZi6OCp7maLRhP4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787882165; bh=Mo5wx0SUtgKKkbZ87YKQi1sICRW5v1NDN+X2BsZ8ges=;
	h=Date:From:To:Cc:Subject:References:From;
	b=LYbO2KI7rDkuEZHSoqpPWwvvfftnDx+k+RbNHgbtwGsbxPZ3hNyjLrrtWJ+5CisTI
	 nynHN067pjjvdso5BUUnJMTrnkPuSPf22Djt7A9Loh2qDf1Wf/2HKFtlcnw1V42gt8
	 0WXlSU81bukHZxQHj8HGzsp294lD9CRVfRi/fXrQ=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id CA8C252C36; Thu, 27 Aug 2026 21:56:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787882142; bh=Mo5wx0SUtgKKkbZ87YKQi1sICRW5v1NDN+X2BsZ8ges=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Dv4NqhjD6SVhGHlcnQumg/gH4pJaUP8AXgweZjzdGqHTPJ2vyntGpeQoLPLJ+ekT3
	 sYn8Sr9CXqt8URK3NM9MBMwZ+jeTVN+QwLev2KbqLIiKZkwpacuvW6KP+R8qscKLn7
	 /L8sZ+SgMYWrGZaCF4qoQF+vtaIur6w4Z0oW3yKY=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 8B2B0531ED;
	Thu, 27 Aug 2026 21:55:42 -0400 (EDT)
Received: from aris by helbrecht.local with local (Exim 4.100-RC3)
	(envelope-from <aris@ruivo.org>)
	id 1wzlok-00000008ORw-1dDA;
	Thu, 27 Aug 2026 21:55:42 -0400
Message-ID: <20260828015542.334186653@ruivo.org>
User-Agent: quilt/0.69
Date: Thu, 27 Aug 2026 21:55:44 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH v3 2/2] mm: gup: cleanup the gup_fast_*() call chain
References: <20260828015542.125576330@ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: en8sf9ribu99d7ie1wsh3h7wwjd4eacb
X-Rspamd-Queue-Id: 4D37D120004
X-HE-Tag: 1787882166-676478
X-HE-Meta: U2FsdGVkX18ujiVoFsZNfG6EapbGxhe55pK3p/KwwtHHrjQedNuI4SKqWfIQAzg3JVr01W49WGCSVN63iWwOZChH4kjsWauz5z554ebqbSbcpoT5uQNd7q4hNePOSF6BwJfobj+lwMZNnDY/m4h/q9htaAg8ZeLqN6Ufk52POLd+/5Tda1EBW98S/0y8Iq3yb5M5pWwttcqhEXL/iJnchXb3NIrfdNythaqPknFVP5wrs/Te63uTjSgHYnxvnJpauOg4AtTw09Wn5PUYCnvFIKhfnN52pkwkFdA2EthmdYr5f9ovDt4Z5o5dsWDSKcOcREf4hPPHFUZSFvxMvHJkNqxlEwVqzjCrlCsA23bZ2jY1MUZo8xDRSdgXpwoeiF0JIU4sFjm9swo954EvnTv9PVq5csLJOkCRsCsqWT+2sis3Y0tHW+IPIgvDzkQ+r1jVnjCDXtf4arqbyEszttnyZl3H4cJe38IOSoaaurXnEqW+NBhXRAUjlonCkmzhlgwU1G7CKn3CPCdoMKn7c1bJ4f2t/ogYICKWD7Znq8sGptpWW+84b6lx3DcFb7LuBgzoJgubsYeOTLmbQBk4Kfr/tPh4XPDmNC6NrOOhY79HEiZsgeUUv/D1nRl5j3MY3Zg7rM4rLeZi8CHdVxv/mXmIFUxkAOhNKe5NzS89w/o0kae/QWB0K5hTeIw++cNYypSXFlotiNHBuLbqGjD7trb5w2CUYOmb14/Uc6/pRjBDshy9H08KVTPQy92a/J9KeNqEhU6lMeDA/2Am1aH4mTFR1m8gqxzLvMYBrxX5c/27OIxKTSNQvyN+w7wnBAjgALb2l9T0nI5xZrVDV8YcXPnnXjY0uMxC5vGTCWCLTOq9ngWAToqxfGUmHcS22uC4+pCNYX6xOfqPYX7W0BzoHOhoaOGmH3opanAmDAyCD/BOvLN+zBwZPdPdmfMGh6GkS3zlzLyxlqT31ODn1K44byX
 Gc8Z+VQE
 fnAByhhpfanUnqiw0KwDQgbQ8LKEdUsLRg3/vqXeTeSkI0l2+dLYWdczGHeDu3E11TPIeSMJG6WnS0KaKMhcGBDOrhJzc3oqcmeySDBlMjcZoMWWf6kHJpk3iVUPfLZn53v7oUn0CpQJJ6FKcXzyFfWnyxIAXDjYmy0hux02U+7Uwgga+cbigDrKbRlz9k8eFuS46XA5LYyH+xhhjPlQzEDSlgZti/EZ/7hwcgv9FeILuYpeHOVzhPb2Z8PGlC8H0HpOU/U3+e1klA2Sr6EA04WWNPRNVA6L2vrt7H8kw2D2kDA4MlAaIHeAi4Y2p2Ty0oSVQaAe9MYad7Rq0ToxucWPV4GelIJOsLq/FfBfGD16yptNgt2lyQfOQOE6pqKS+ZlpI9jWtb4GjS3A9D1psnXx9fGMycjE6Lx4owaBNXziu3ATMe9XwtZgInS+JJdHQDKQq71rnNPaGFawnDlHOa34Xo9slCZBflpm7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor gup_fast functions so each step of the way returns the number of
pages pinned. Because the previous step of the chain knows what the number
it should be, less indicates an error. This way there's no need to pass *nr
along.

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

---
 mm/gup.c |  179 +++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 94 insertions(+), 85 deletions(-)

--- a/mm/gup.c	2026-08-04 23:54:17.836445556 -0400
+++ b/mm/gup.c	2026-08-27 15:26:13.350864227 -0400
@@ -2826,11 +2826,11 @@ static bool gup_fast_folio_allowed(struc
  * also check pmd here to make sure pmd doesn't change (corresponds to
  * pmdp_collapse_flush() in the THP collapse code path).
  */
-static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
+		unsigned long addr, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
-	int ret = 0;
+	unsigned long nr_pages = 0;
 	pte_t *ptep, *ptem;
 
 	ptem = ptep = pte_offset_map(&pmd, addr);
@@ -2892,15 +2892,13 @@ static int gup_fast_pte_range(pmd_t pmd,
 			goto pte_unmap;
 		}
 		folio_set_referenced(folio);
-		pages[*nr] = page;
-		(*nr)++;
+		pages[nr_pages] = page;
+		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 
-	ret = 1;
-
 pte_unmap:
 	pte_unmap(ptem);
-	return ret;
+	return nr_pages;
 }
 #else
 
@@ -2913,21 +2911,21 @@ pte_unmap:
  * get_user_pages_fast_only implementation that can pin pages. Thus it's still
  * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
  */
-static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
+		unsigned long addr, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
 	return 0;
 }
 #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 
-static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
+		unsigned long addr, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
 	struct page *page;
 	struct folio *folio;
-	int refs;
+	unsigned long nr_pages, i;
 
 	/* See gup_fast_pte_range() */
 	if (pmd_protnone(orig))
@@ -2939,42 +2937,40 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	if (pmd_special(orig))
 		return 0;
 
-	refs = (end - addr) >> PAGE_SHIFT;
+	nr_pages = (end - addr) >> PAGE_SHIFT;
 	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 
-	folio = try_grab_folio_fast(page, refs, flags);
+	folio = try_grab_folio_fast(page, nr_pages, flags);
 	if (!folio)
 		return 0;
 
 	if (unlikely(pmd_val(orig) != pmd_val(pmdp_get_lockless(pmdp)))) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
 
 	if (!gup_fast_folio_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
 	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
 
-	pages += *nr;
-	*nr += refs;
-	for (; refs; refs--)
+	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
 	folio_set_referenced(folio);
-	return 1;
+	return nr_pages;
 }
 
-static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
+		unsigned long addr, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
 	struct page *page;
 	struct folio *folio;
-	int refs;
+	unsigned long nr_pages, i;
 
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
@@ -2982,41 +2978,39 @@ static int gup_fast_pud_leaf(pud_t orig,
 	if (pud_special(orig))
 		return 0;
 
-	refs = (end - addr) >> PAGE_SHIFT;
+	nr_pages = (end - addr) >> PAGE_SHIFT;
 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 
-	folio = try_grab_folio_fast(page, refs, flags);
+	folio = try_grab_folio_fast(page, nr_pages, flags);
 	if (!folio)
 		return 0;
 
 	if (unlikely(pud_val(orig) != pud_val(pudp_get(pudp)))) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
 
 	if (!gup_fast_folio_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
 
 	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
 
-	pages += *nr;
-	*nr += refs;
-	for (; refs; refs--)
+	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
 	folio_set_referenced(folio);
-	return 1;
+	return nr_pages;
 }
 
-static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud,
+		unsigned long addr, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
-	unsigned long next;
+	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	pmd_t *pmdp;
 
 	pmdp = pmd_offset_lockless(pudp, pud, addr);
@@ -3025,26 +3019,30 @@ static int gup_fast_pmd_range(pud_t *pud
 
 		next = pmd_addr_end(addr, end);
 		if (!pmd_present(pmd))
-			return 0;
+			break;
 
 		if (unlikely(pmd_leaf(pmd))) {
-			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
-				pages, nr))
-				return 0;
-
-		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
-					       pages, nr))
-			return 0;
+			chunk_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr,
+							   next, flags,
+							   &pages[nr_pages]);
+
+		} else
+			chunk_nr_pages = gup_fast_pte_range(pmd, pmdp, addr,
+							    next, flags,
+							    &pages[nr_pages]);
+		nr_pages += chunk_nr_pages;
+		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
+			break;
 	} while (pmdp++, addr = next, addr != end);
 
-	return 1;
+	return nr_pages;
 }
 
-static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d,
+		unsigned long addr, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
-	unsigned long next;
+	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	pud_t *pudp;
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
@@ -3053,24 +3051,27 @@ static int gup_fast_pud_range(p4d_t *p4d
 
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
-			return 0;
-		if (unlikely(pud_leaf(pud))) {
-			if (!gup_fast_pud_leaf(pud, pudp, addr, next, flags,
-					       pages, nr))
-				return 0;
-		} else if (!gup_fast_pmd_range(pudp, pud, addr, next, flags,
-					       pages, nr))
-			return 0;
+			break;
+		if (unlikely(pud_leaf(pud)))
+			chunk_nr_pages = gup_fast_pud_leaf(pud, pudp, addr,
+							   next, flags,
+							   &pages[nr_pages]);
+		else
+			chunk_nr_pages = gup_fast_pmd_range(pudp, pud, addr,
+							    next, flags,
+							    &pages[nr_pages]);
+		nr_pages += chunk_nr_pages;
+		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
+			break;
 	} while (pudp++, addr = next, addr != end);
 
-	return 1;
+	return nr_pages;
 }
 
-static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
 {
-	unsigned long next;
+	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	p4d_t *p4dp;
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
@@ -3079,20 +3080,23 @@ static int gup_fast_p4d_range(pgd_t *pgd
 
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
-			return 0;
+			break;
 		BUILD_BUG_ON(p4d_leaf(p4d));
-		if (!gup_fast_pud_range(p4dp, p4d, addr, next, flags,
-					pages, nr))
-			return 0;
+		chunk_nr_pages = gup_fast_pud_range(p4dp, p4d, addr, next,
+						    flags, &pages[nr_pages]);
+		nr_pages += chunk_nr_pages;
+		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
+			break;
 	} while (p4dp++, addr = next, addr != end);
 
-	return 1;
+	return nr_pages;
 }
 
-static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages, int *nr)
+static unsigned long gup_fast_pgd_range(unsigned long addr,
+		unsigned long end, unsigned int flags,
+		struct page **pages)
 {
-	unsigned long next;
+	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	pgd_t *pgdp;
 
 	pgdp = pgd_offset(current->mm, addr);
@@ -3101,17 +3105,23 @@ static void gup_fast_pgd_range(unsigned
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
-			return;
+			break;
 		BUILD_BUG_ON(pgd_leaf(pgd));
-		if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags,
-					pages, nr))
-			return;
+		chunk_nr_pages = gup_fast_p4d_range(pgdp, pgd, addr, next,
+						    flags, &pages[nr_pages]);
+		nr_pages += chunk_nr_pages;
+		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
+			break;
 	} while (pgdp++, addr = next, addr != end);
+
+	return nr_pages;
 }
 #else
-static inline void gup_fast_pgd_range(unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages, int *nr)
+static inline unsigned long gup_fast_pgd_range(unsigned long addr,
+		unsigned long end, unsigned int flags,
+		struct page **pages)
 {
+	return 0;
 }
 #endif /* CONFIG_HAVE_GUP_FAST */
 
@@ -3129,8 +3139,7 @@ static bool gup_fast_permitted(unsigned
 static unsigned long gup_fast(unsigned long start, unsigned long end,
 		unsigned int gup_flags, struct page **pages)
 {
-	unsigned long flags;
-	int nr_pinned = 0;
+	unsigned long flags, nr_pinned;
 	unsigned seq;
 
 	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
@@ -3154,7 +3163,7 @@ static unsigned long gup_fast(unsigned l
 	 * that come from callers of tlb_remove_table_sync_one().
 	 */
 	local_irq_save(flags);
-	gup_fast_pgd_range(start, end, gup_flags, pages, &nr_pinned);
+	nr_pinned = gup_fast_pgd_range(start, end, gup_flags, pages);
 	local_irq_restore(flags);
 
 	/*


