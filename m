Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB196C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 03:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2856B0092; Tue,  4 Aug 2026 23:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9946B0093; Tue,  4 Aug 2026 23:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82CC6B0095; Tue,  4 Aug 2026 23:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79FA46B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:59:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B4F280346
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:59:18 +0000 (UTC)
X-FDA: 85065860796.26.F06FC29
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0C6E1C0003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:59:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b="j/Ns2YII";
	dkim=pass header.d=ruivo.org header.s=mail header.b=XNkV5XPZ;
	spf=pass (imf21.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785902356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=AhTA8RQpCp+Aez80rnIu2xxZI6Pa2Fp7Ao84Xp3OzGo=;
	b=5n93Q7hE1WWpSHMuytAzbsVNh4pwg0s4x1DGVHXm+tkJ8Dh9r2zdAruzyBcvPUPhWQJqNy
	ntqsJuos9gjKHnLJ54awX46P/usdMK0s2ARd8TkiwmBFEcHfa78CKkjwM/YYwGmVnjrOVF
	BmqvY7EUlhuFP0l1OGy9N/qkncRqQn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785902356;
	b=7usPypF89/apaJb5GW/jInEd12U485j+QpKDXj0rIpZ58pdber5xiBxj4mTV6xkmB12UtO
	kJgnE5xT8SD9ZQlANBRWXb+SIRvJQQEpLjBh68MYKG1V7xwJCVyXiNOviBHI/JFJcy8lPQ
	nc9oaITox8GssyHuJg5w3SpqbyA+YzY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b="j/Ns2YII";
	dkim=pass header.d=ruivo.org header.s=mail header.b=XNkV5XPZ;
	spf=pass (imf21.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785902356; bh=25GNAlPD9EMD3y2co6dbm3jAj1iMOn3H+AbOO6e514I=;
	h=Date:From:To:Cc:Subject:References:From;
	b=j/Ns2YIIqx0xbC3NN541OGqfGDHyxkY88kC1JDG3sNhIq6UVFk2gsfZp6caytIENs
	 RC5YND16Kh959gsFOAHjeJUkVJoIG/35KvthGOYFTgyXh1Our6uiofyQTBzjRsezEi
	 eol0uVfSw1642Ef6arPfkFCc4FQbFHXvKOSTy3LA=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 22F5652EAB; Tue, 04 Aug 2026 23:59:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785902328; bh=25GNAlPD9EMD3y2co6dbm3jAj1iMOn3H+AbOO6e514I=;
	h=Date:From:To:Cc:Subject:References:From;
	b=XNkV5XPZCh0t0S3CR/zPAHjadv6aqmT0Dj5eqj2NWxBZukFGpCJ8J2/fEfJDmoCHT
	 uJ8bsIWbSjZONZy/fwmVg4d2xxaz5NIYI9Jc/keGP2d+njPOyi5+EBCVlhcYue//Ln
	 LVvG18ojkcGN4rfEBAY2kpMo66gDt240198EXcRg=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 5E79C52E45;
	Tue, 04 Aug 2026 23:58:48 -0400 (EDT)
Received: from aris by helbrecht.local with local (Exim 4.99.4)
	(envelope-from <aris@ruivo.org>)
	id 1wrSmG-00000003Qwa-0uHy;
	Tue, 04 Aug 2026 23:58:48 -0400
Message-ID: <20260805035848.161794043@ruivo.org>
User-Agent: quilt/0.69
Date: Tue, 04 Aug 2026 23:58:49 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH v2 2/2] mm: gup: cleanup the gup_fast_*() call chain
References: <20260805035847.936054733@ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: B0C6E1C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nb3hrn55efnidomb8dpt1tzymq4ay7p5
X-HE-Tag: 1785902356-207147
X-HE-Meta: U2FsdGVkX19tQ1g6pG0p0S7o95l0XVmgVYGTU826BZv+ax9z0cCAqZLnDkEfYhgHtXkEONLSY4O/GJwCRnpL3ni7tQZyJq+tggzSx5fgYvs8MF8XkZ9LPBTBW94Y4V8ZtLODw4K4xiLhximOPZqr4PEH40LhWtDsNDF8pQf/nxsg8596WJEV6n6OoH17AbHUThIUwegEWX+gDC7HFRQZBHIRhHnwkZLVEWyQK1o70VrwennqKcDPJNnC3znElWna52QI13WvJO+emmarEu2Q2/yqxP1zVO+39DDlbGpnaYQc8p3Yz13Ss/pXfRYyVnxdDqV0HpuK0uqQWh7eNRPzgaAiFU0VsZnAbEfRxs86nN8UKrHb88Ud1byFnqmA7onGIuZVvvV9gYvWc04VnMK+MX1si+44gOlasgLtlE7YiUY9suqVXGVptpNZWXR7764ubi+zCfWmC4djlJxOsKvWPHdmiJZ1CnPdbbZHIWcwTkrNWFnT4U9bmpVcv6XdccKv6wb6yZ9EtFaLhh/0Wk0APhZtxMuXvBHLfPrQpVVR1OrHh0IWKPa1vJEzdE7mglUbDTM91eVVuJmhKp1CKu0TVxXbzMKLGq0vZB0JmgAimlJcjVC8EVuLih+6IhsBE1Q9Ak/dzB009urITvcwula7n9aP0Viiyic1EcAkeEG4rRhoqKJdZ8dxITQO2d2fu99MV4qRxLlPMEmJGLdAGzyDj8JcldD9Q+5tHCPMhtCfFRzPEtUSnrR/X1KrH3KHVuuT7bbNSsaNh15ROMji7CGp38QoZAwWF3v0baihJjkCQvZJpyle5ViOp/bqEYqva5lQRfz3/D7Tfwvhw8Z9rmTkNqFnCMJOAm9WFrCsiefECSB0vxcmJHQtkUvQ6nX3TofkoyHJkDTzJGaW7538vQ8gsNCBRqO7TcvWpSJnkMAgoHkIrhsu1zEYeBzE/dhDRiK9TreCQhlTJFvtIACDWhV
 iOI9Zao6
 KuBLy9kubFGrrEpauY3QCfA9MJrg7xPEe4+a8bGt1l+W4+3Ea0aZzys7Igsgo9AnLOuu9pDueY6BnEBwemRVygGsoxzCXFngS1DxJmZUR6hRMhGZnhOLyazKUnqISjPDuwvL4JWqLwQqPCJ//gjhsvwuNbtE1Qci0eZoLtGWbSrGLn3DUc8V8i5ebef4i3HXJR5IZWOE7EFFyq8xwB+mgmRJOhr1cd5qfTkkBA6PmZm1sOiBjDgbUUCdBOFkgW37bgrH7SpaRfwrPymKGIvfXOX61989OjGXPQjBGkYo84ukd0e/D0QsiV8D0dWP+HYo27nxJnJHEdeInaCq4E5TnrC0w3mKGAOJg95jSCVy9t9bdPHOQAkzLK4d7jxKMtOGIeRB28ICEKqPxLSvRbYlkUeHVAQGNyZgDAMFbqd1goqWFmNz1r8GjO2Zg3h6DNasbhnOZxLdqmDwwbTGQlR8AFi+4CTlFm/APbxGo
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

--- a/mm/gup.c	2026-08-03 22:08:37.484301806 -0400
+++ b/mm/gup.c	2026-08-03 23:01:02.283356460 -0400
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
+	unsigned long next, nr_pages, chunk_nr_pages;
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


