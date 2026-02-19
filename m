Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B905E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 05:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80ECE6B008A; Thu, 19 Feb 2026 00:03:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC306B008C; Thu, 19 Feb 2026 00:03:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE1F6B0092; Thu, 19 Feb 2026 00:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF706B008A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:03:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEE6A140412
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:03:24 +0000 (UTC)
X-FDA: 84460012728.13.36F34C6
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B364160004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:03:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=a6vXJ8xj;
	dkim=pass header.d=ruivo.org header.s=mail header.b=lpvIqgUp;
	spf=pass (imf08.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771477403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=EkBdW6Cy1EYu9xwJsX/ToZrhxGOZUJl0ZH9KtsMQF6c=;
	b=ALHHzT0Iq5R55ZoEUa5oYz1HF7nXcY/UeZKcylZ1HkF+di4WLUGkU1voqeDvK8ftzFkA0W
	lFN1cjoDsH28hKcHVTQk6nMmLj9uK6FQesyKiSoGcHCmZUI1YzzInGUAE2y1aQHMlis+7p
	f/AnYOhl7BFC2+LA1lgr8ff1fUaI8V8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=a6vXJ8xj;
	dkim=pass header.d=ruivo.org header.s=mail header.b=lpvIqgUp;
	spf=pass (imf08.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771477403; a=rsa-sha256;
	cv=none;
	b=w+sxepYLT3O/8dEy2gkwW8SIxQMWLLd8l3f8Xn+gkIWY/58P+iRKm+pEpNNj4DBk9P2phF
	bvdh6VwJNRqx9h+2/3rROr9FZW9O1BbQtLkwg83my63BaBoHJCIhQrm0Fc7O7MWyxwH8v9
	NEehB3XmY3TgfVrro3rMEFNZAesiBTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1771477402; bh=petmMSihBb5UuVcsRrug1M70mYMuEIdR27FVup3WcRM=;
	h=Date:From:To:Cc:Subject:References:From;
	b=a6vXJ8xjCpCuJqOHeCliYxb8s4SwYlyikbdSfnCweWhF5nL2L7GJI8I8lFT1MGjtF
	 /xPUZp/tU7/WJk9ugORPzysz+7iUFJvQJdgLKtnbu6l9U5yh81o9lGeTCBn4IcVUTb
	 2tzaNHHlyONzHxivX0BIBFlMw5NQAHhEPjRduHX4=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 3C2A952D56; Thu, 19 Feb 2026 00:03:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1771477370; bh=petmMSihBb5UuVcsRrug1M70mYMuEIdR27FVup3WcRM=;
	h=Date:From:To:Cc:Subject:References:From;
	b=lpvIqgUp8Qc4NWDfhSqKh1Z5589HnUmj8+js4CIiXjC+S//X0oTHeLqej2GDiiZAQ
	 hZkjIgg6mlUFcTrzjIAX0BjI+pg2U7oQccyY7+zIKwyUlwgtCoi37vaFmRPfrN8FUF
	 yPGbnuZBTCHbKGltY9nGBFmxjCkBKmsitdCJGYZ0=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 71D8352D56;
	Thu, 19 Feb 2026 00:02:50 -0500 (EST)
Received: from aris by helbrecht.local with local (Exim 4.99.1)
	(envelope-from <aris@ruivo.org>)
	id 1vswBe-00000004J1q-1MWY;
	Thu, 19 Feb 2026 00:02:50 -0500
Message-ID: <20260219050250.266876166@ruivo.org>
User-Agent: quilt/0.69
Date: Thu, 19 Feb 2026 00:02:52 -0500
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH 2/2] mm: gup: cleanup the gup_fast_*() call chain
References: <20260219050250.061598056@ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B364160004
X-Stat-Signature: xxmu48ij9m9wrbw8y6gakkw3rb59botn
X-Rspam-User: 
X-HE-Tag: 1771477402-659053
X-HE-Meta: U2FsdGVkX1/RoZIuXq1WVVkea744fbVFaco+i7YV8yQa24zQGdFMkSl3Wy7FuGkMMFF3WvjNUhTd18uu6Hk/CbWosEhQbvQAey81wYVVhvy0PvGTMcgEsxeyOe57V8APh7F0zuIWxkiM8Bajmuayz/nO8w0Y0pG2+A0UbaKhZQmCJvolosC7X8fZ5K8gKfW2Lh+gr8I8gXqyztOziYA4FNFqhwJUNh4wvT+OwkXlsU+2UxLoyjPqGHi9lstvQ+TIpuTjy7nwmRY9Gc2v+un6/7gwUOfuq7fLt41ycWPBHyUI4AcaHwtNIhm5sXZfqxbER6y8UMvCtzIcspeSUgh6oeB3pK25I10fRi2r/2NHQfRbAQ0Zuqec2sxpf56iGbVU4s9s1/PSPvD/hsHsNZcEpSbvkjKenXdScc7DBBJbGKm+4tY/Zlw4Ww3+UbmDWmrn4JDTkpSSR4GJcD4GxaAh6yl5AD03rel+Ivyry/kesmfdJPgj+37F1LFFB9ikwqgZyywJ0vGN8dFMu29RRkAh9pBu+YLDOw1OmUfQ4VRoMP8akoc9F2OzcX6lxgzohXDLXqiJRsHMQjQaYabzNSGM+Me1wolc4RpcTYhCcHZsNsoze7Uy9pW3dJnVoNaOKrNZ2SyvH45DLnGNz2p5Xf9smXAdeZ6z1untXlg2M0sOiPX/klWJScdcHjbAR8jzsWPFBDMmTIX+IeJa/aEllDZUmetGRSj8f17b5qbuVLoT/g25N4AX+eRfOkjGgCLz0CDIz9MBhUi9dvOTXciz8MTvjZ0Z2UyGVOxFAR/VnlcRFR/JdGMmpVofddUrUcpAXeSw3mkp6dUFlnKLPpA/HztCre1FSiKnwcV1y9AMRyoHfv9pQO0G2lujN1kYFv7JVAfngjarAyyHqTdb20gigMOOWyQub9jxX9OUcuDvTTevdXLkf4L+s9dWy0ItM6GPJ+dEHqS8pU5vyH2iryFlSaW
 LEysWqwm
 SKX/EVn+A+CyzDT644BMcOrqLEMtcMQfPliILgn2glaNPt267xJVX/jdB/GDVEzaeC5EZnMrp/O8tOvAro8PprU1+r2ZVY3itt55yQfne0sKxfIVrsgOhG8H/m+2iLP4rAjz8ysqyHoihmkGFWj60NaDh+zfH9VoqnLHkeqmpm3OPhsWmmy2uEqNyF7vqqWwBO0kRgOZxo5Yn7zaPbaZSVXr0EbI5Mwg0fPP0BXnJ5wOtATrTfKfeCYAzFIHJsJDIy+BQRGc/reMdMtmxfvl/gcHhHT0gG0wGhozcc4O5j0Cn/ObZYYpCVC/4a8V5i1pBTwHuaqELA6aHnx+Vnauqlcj7IxlU1dDtRHoDU+RiYSGjZLuSbosMapgNihkmboZIu0YumKB+qfMJrwLtEf90rgXs6YNNxmXCj4XSnaHVC0AXCOM3QWMpxH1q7fVzb15fPfLDKLkzHSVupepvxAqbBrkHAN+nVP1x8sbq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

--- a/mm/gup.c	2026-02-18 23:39:10.187019351 -0500
+++ b/mm/gup.c	2026-02-18 23:39:10.185510090 -0500
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
 
 	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
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
+	unsigned long nr_pages = 0, i;
 
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
 
 	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
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
+	unsigned long flags, nr_pinned = 0;
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


