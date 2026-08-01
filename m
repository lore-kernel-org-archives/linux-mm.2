Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B44CC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5831A6B008A; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C356B0093; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3852C6B0095; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D95796B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:16:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C3E4801E2
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:23 +0000 (UTC)
X-FDA: 85051237446.22.58E5170
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 85A6640004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kLLQRNG3;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frJWwvl6Omv6CrI+LKD0Y+Mv87IoxqrmxcgZCvlyOIA=;
	b=8jUBiquVOU5cD5/P07JMaHfGkYNT4k3kgOoXDn7xcCiO+VXCnSl3Venco6S7MeB2ZzIh9m
	jeqwJhJV5cbr1zMy8eZC6rUBbZ0enSXeth0v3QuLtKQ52Uprb7nDbr330TaABq9zeTq0gr
	arOQmL/KupwmDjPoEYvCrSf7YOBzn/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554181;
	b=xJHxVf3uSXt7Sbae703HfPBt2KzBuy1w5oR1sM7gukZA1Khv7IfaRoWv9r1NvJeq4bi2Eu
	nSnxdSJkLTIhc23hoIt4Y/lB3JSOB2lcbRaaq3zduhCL0gLQqLi5zhfH7tl9/h04WScVde
	oB4ljQRXpmrzB/qq1new9BxaBejksBY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kLLQRNG3;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=frJWwvl6Omv6CrI+LKD0Y+Mv87IoxqrmxcgZCvlyOIA=; b=kLLQRNG3v5Z2B5GMFumP0Wm1qu
	3b3YxLgXEktuylf8uXqpOgYAppzJ9EZFpSHymnJya/VDqO+XvxjgpkH4pFqKBb8BcsLRk7NgFlrW4
	V9iD/cSwDrHDTVV4Y7tAZ9fWvv0+5agVV7tJqmeYdGgWJxuRz3d9v6HizJchxGG/cZvw2JwyBoVgh
	hrLEjWvyvhdz9uIWUZX6c4CGadQivOUsn5Jhy3qd4d0MiQYHS8NVBIJvCRe05qF0rrb9RtE0YSOdv
	DaMaFqH6qOCmekRIE9hqxNMxJ5tn5aA88ZPu2EEP1VvC+daC/6PWGGWzpaInqJZTLQlo0X1WAmnKc
	IuulJlvQ==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq0CU-000000001Q5-3x3V;
	Fri, 31 Jul 2026 23:15:50 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH 4/5] mm/gup: return a huge page's full count from follow_page_mask()
Date: Fri, 31 Jul 2026 23:15:39 -0400
Message-ID: <20260801031540.2742891-5-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260801031540.2742891-1-riel@surriel.com>
References: <20260801031540.2742891-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85A6640004
X-Stat-Signature: r9k959xszf9bwg49btemmpd34rfozj6w
X-HE-Tag: 1785554180-688754
X-HE-Meta: U2FsdGVkX18r+WBKA6N9clS1KIaBPhBw3691l/GgIkh+Gm9LrNLIGrCN/uxFhsqczA7oC08x+XjvyN8zqdVhvGiZPwQABPhlolic13zHIdK5Bx1kXpvlsMU0AZPJUnFi8A0NwzAl6hVNMwN3QojPkLrImAEbIocGMPD7ASqClTJPQUpGrczxQo9ofSjXdXcPtkkmWpHpNGbKxy7W5xbdRtvDC2dDF7o2K55NBkbz8DuUMHLlZ9a9+096FMAUwQlGjWS/f8jMv9dB6z+v/g/cLdK5qnROHGaLaAskUzKsC8Q2kObhaI1l5ckyATLBb8In050aThchF+brkS+OMoLETH4qaZX8tD54LVyNNzIb8WevuqAznidOoNhfg3CB3o5yo3poqOYF4/wkcv+frqfqTGSr9hArKgrbdMvoTxQn1v6AcPJ3yQY0LLpDmcRgKI4EK5lr2QN6INCCfLfq3QqCkaaU8vW/dHkt/tDXchhFSS9kZje+iqe2J09wX0Ow2F3PjWsW8dI/D8qht9MMiUKjc+GScTiPZxTpERK+ZjKBU8IJlxo1i0hkYg7OwyQit3htUjoVa9oZp5hYmCeSRawSpCZkPr9OOlXHcOynr2pvK7O9NnEkcllIFYFOKDu5q6IwG/bfky7LEuvt5zQ7K1xQyUeTHz1IuOzPNCUPRcNRiQblb6RYKBEwSV5NiRr/0sEYkbir9pAUkb3Hmohk1vZcpofymUt+NQeQ01OQhlcwcy7k/orR6h27WEW7tF2YDctI9UeSsafgHUqJxd2MfCaNgGBu+W/W24bVMeMoVbX+5kxY9n6bhTI0bB9va7D6Zx8XNxb5Dz2XwaL91w1fq8Z9PkzDD6Tq4LJl22BDszNbSW3yIOrBIoJA935WsNt9L9i97IN5qjxUx352yGd0xqxSxCx2BTBdzorJjsbkMLbuyK3J++DdgjolpeIGBVGHUKi9wLuoCpa0QwVN8svaLu0
 qARw27DQ
 KF7eGjUhKGrkxooxTMh+WOh+DfRPy2nVwLvwrrwA9IJhZeGsDSBKOFP6opMs3KI0GHEoyyZyj6HVQGTbu1rbtMgEN8XbSSTQ7XEM6OOxPX3QIGCsSRVmLlZ4I7Ctwo63wX0pmuLhxFiPmHWxLPciTQF0DgcNuSETQU5eNxlHBiNklj1mou8WG43FhBMzWnmc4A7ryb6JrhWnH+pMa3UzVtaarU5hDmUXF4aWkZ1HbtfLEythVXjhOIWY8rNuLwW8CLTmBv6PwOcNrVmy8ybmrwUNEpelxtCAm90EWz+7g0mZ8eNGYjTvCzrXZvebf3YcJsvPNF7hVRfXdrrx/PT6wsxIHfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_huge_pud()/follow_huge_pmd() already know the huge page's full
size but report it via a separate *page_mask output; __get_user_pages()
does a second try_grab_folio() call and subpage loop for everything
past the first page.

Add an @end argument, have the huge paths report their count as the
return value instead, clamped to the huge page's size and @end, and
fill every subpage via gup_fill_pages().

The huge paths grab refs under the pud/pmd lock, then store the first
page in pages[0] and return; follow_pud_mask()/follow_pmd_mask() fill
the rest of the array and flush caches after releasing the lock. The
pages are already pinned by then, so this is safe.

This keeps the lock held for a fixed amount of work regardless of
folio size: a 1 GB PUD-mapped folio can be up to HPAGE_PUD_NR pages,
too long to flush while blocking every other user of that lock.

This merges two try_grab_folio() calls into one, and returns whatever
error try_grab_folio() gives instead of forcing -EFAULT on the second
call's failure.

*page_mask and __get_user_pages()'s second-grab/subpage loop are now
dead; remove them. The old silent page_increm clamp becomes a
VM_WARN_ON_ONCE, since @end already bounds the count and refs/pages[]
are already committed by the time the caller sees it -- truncating
here would leak references, not just waste a comparison.

follow_page_pte() is unaffected, still returning at most 1 page.

__get_user_pages()'s -EEXIST handling also needs an explicit nr = 1 for
the pages == NULL case now: it used to get that for free from
page_mask staying 0 for a PFN-special PTE, but nr is -EEXIST there
without it, which would grow nr_pages instead of shrinking it.

Verified with mm/gup_test.c (PIN_LONGTERM_BENCHMARK): no measurable
change for 4 kB, 64 kB mTHP, or 2 MB THP -- these paths don't reach
follow_huge_pud()/follow_huge_pmd(), or the merged call is too small
to measure. This single-threaded benchmark can't show a lock-hold-time
change; the fix above is by inspection, not measurement.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 177 ++++++++++++++++++++++++-------------------------------
 1 file changed, 78 insertions(+), 99 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b6d508a44ced..ccbef9476ff6 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -664,14 +664,14 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 }
 
 static long follow_huge_pud(struct vm_area_struct *vma,
-		unsigned long addr, pud_t *pudp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pud_t *pudp,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
 	pud_t pud = *pudp;
 	unsigned long pfn = pud_pfn(pud);
+	unsigned long off, nr;
 	int ret;
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
@@ -683,21 +683,23 @@ static long follow_huge_pud(struct vm_area_struct *vma,
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
 		return 0;
 
-	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
+	off = PFN_DOWN(addr & ~PUD_MASK);
+	pfn += off;
 	page = pfn_to_page(pfn);
 
 	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
 		return -EMLINK;
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	nr = min(HPAGE_PUD_NR - off, PFN_DOWN(end - addr));
+
+	ret = try_grab_folio(page_folio(page), nr, flags);
 	if (ret)
 		return ret;
 
-	*page_mask = HPAGE_PUD_NR - 1;
-
-	gup_fill_pages(vma, addr, page, 1, pages);
+	if (pages)
+		pages[0] = page;
 
-	return 1;
+	return nr;
 }
 
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
@@ -719,13 +721,13 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 }
 
 static long follow_huge_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmd,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
 	struct page *page;
+	unsigned long off, nr;
 	int ret;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
@@ -748,7 +750,10 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	off = PFN_DOWN(addr & ~HPAGE_PMD_MASK);
+	nr = min(HPAGE_PMD_NR - off, PFN_DOWN(end - addr));
+
+	ret = try_grab_folio(page_folio(page), nr, flags);
 	if (ret)
 		return ret;
 
@@ -757,27 +762,25 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	*page_mask = HPAGE_PMD_NR - 1;
+	page += off;
 
-	gup_fill_pages(vma, addr, page, 1, pages);
+	if (pages)
+		pages[0] = page;
 
-	return 1;
+	return nr;
 }
 
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static long follow_huge_pud(struct vm_area_struct *vma,
-		unsigned long addr, pud_t *pudp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pud_t *pudp,
+		unsigned int flags, struct page **pages)
 {
 	return 0;
 }
 
 static long follow_huge_pmd(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t *pmd,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long addr, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	return 0;
 }
@@ -939,9 +942,8 @@ static long follow_page_pte(struct vm_area_struct *vma,
 }
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
-		unsigned long address, pud_t *pudp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long address, unsigned long end, pud_t *pudp,
+		unsigned int flags, struct page **pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
@@ -977,15 +979,23 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 		return pte_alloc(mm, pmd) ? -ENOMEM :
 			follow_page_pte(vma, address, pmd, flags, pages);
 	}
-	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
+	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
+
+	/*
+	 * Refs are already grabbed above; the array fill and cache
+	 * flushes only touch the now-pinned pages, so do them without
+	 * the pmd lock held.
+	 */
+	if (ret > 0 && pages)
+		gup_fill_pages(vma, address, pages[0], ret, pages);
+
 	return ret;
 }
 
 static long follow_pud_mask(struct vm_area_struct *vma,
-		unsigned long address, p4d_t *p4dp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long address, unsigned long end, p4d_t *p4dp,
+		unsigned int flags, struct page **pages)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
@@ -998,8 +1008,18 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
+		ret = follow_huge_pud(vma, address, end, pudp, flags, pages);
 		spin_unlock(ptl);
+
+		/*
+		 * Refs are already grabbed above; the array fill and cache
+		 * flushes only touch the now-pinned pages, so do them
+		 * without the pud lock held -- a 1 GB folio can be up to
+		 * HPAGE_PUD_NR pages, too long to flush under a spinlock.
+		 */
+		if (ret > 0 && pages)
+			gup_fill_pages(vma, address, pages[0], ret, pages);
+
 		if (ret)
 			return ret;
 		return no_page_table(vma, flags, address);
@@ -1007,13 +1027,12 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask, pages);
+	return follow_pmd_mask(vma, address, end, pudp, flags, pages);
 }
 
 static long follow_p4d_mask(struct vm_area_struct *vma,
-		unsigned long address, pgd_t *pgdp,
-		unsigned int flags, unsigned long *page_mask,
-		struct page **pages)
+		unsigned long address, unsigned long end, pgd_t *pgdp,
+		unsigned int flags, struct page **pages)
 {
 	p4d_t *p4dp, p4d;
 
@@ -1024,18 +1043,18 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask, pages);
+	return follow_pud_mask(vma, address, end, p4dp, flags, pages);
 }
 
 /**
- * follow_page_mask - look up a page descriptor from a user-virtual address
+ * follow_page_mask - look up pages at a user-virtual address
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
+ * @end: virtual address at which to stop batching contiguous pages
  * @flags: flags modifying lookup behaviour
- * @page_mask: a pointer to output page_mask
- * @pages: array to receive the page found, refcounted per @flags, or NULL
- *         to walk the page tables (e.g. to fault pages in) without
- *         collecting or refcounting them
+ * @pages: array to receive the pages, refcounted per @flags, or NULL to
+ *         walk the page tables (e.g. to fault pages in) without collecting
+ *         or refcounting them
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -1044,15 +1063,15 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, @page_mask is set according to the size of the page.
- *
- * Return: 1 with @pages[0] filled in if a page was found, 0 if no mapping
- * exists at @address, or a negative errno for a mapping to something not
- * represented by a page descriptor (see also vm_normal_page()).
+ * Return: the number of contiguous pages starting at @address that were
+ * placed into @pages (if non-NULL), which may be fewer than the pages
+ * requested via @end; 0 if no mapping exists at @address; or a negative
+ * errno for a mapping to something not represented by a page descriptor
+ * (see also vm_normal_page()).
  */
 static long follow_page_mask(struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags,
-		unsigned long *page_mask, struct page **pages)
+		unsigned long address, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1060,13 +1079,12 @@ static long follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		ret = no_page_table(vma, flags, address);
 	else
-		ret = follow_p4d_mask(vma, address, pgd, flags, page_mask, pages);
+		ret = follow_p4d_mask(vma, address, end, pgd, flags, pages);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1404,7 +1422,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1419,7 +1436,6 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
 		long nr;
 
 		/* first iteration or cross vma bound */
@@ -1477,8 +1493,8 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		nr = follow_page_mask(vma, start, gup_flags, &page_mask,
-				      pages ? &pages[i] : NULL);
+		nr = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+				      gup_flags, pages ? &pages[i] : NULL);
 		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   nr == -EMLINK, locked);
@@ -1500,62 +1516,25 @@ static long __get_user_pages(struct mm_struct *mm,
 			 * Proper page table entry exists, but no corresponding
 			 * struct page. If the caller expects **pages to be
 			 * filled in, bail out now, because that can't be done
-			 * for this page.
+			 * for this page. Otherwise advance by the one page
+			 * follow_page_mask() looked at.
 			 */
 			if (pages) {
 				ret = nr;
 				goto out;
 			}
+			nr = 1;
 		} else if (nr < 0) {
 			ret = nr;
 			goto out;
 		}
 
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
-		if (page_increm > nr_pages)
-			page_increm = nr_pages;
-
-		/*
-		 * This must be a large folio (and doesn't need to
-		 * be the whole folio; it can be part of it), do
-		 * the refcount work for all the subpages too.
-		 *
-		 * NOTE: here the page may not be the head page
-		 * e.g. when start addr is not thp-size aligned.
-		 * try_grab_folio() should have taken care of tail
-		 * pages.
-		 */
-		if (pages && page_increm > 1) {
-			struct page *subpage;
-			unsigned int j;
-			struct folio *folio = page_folio(pages[i]);
-
-			/*
-			 * Since we already hold refcount on the
-			 * large folio, this should never fail.
-			 */
-			if (try_grab_folio(folio, page_increm - 1,
-					   gup_flags)) {
-				/*
-				 * Release the 1st page ref if the
-				 * folio is problematic, fail hard.
-				 */
-				gup_put_folio(folio, 1, gup_flags);
-				ret = -EFAULT;
-				goto out;
-			}
-
-			for (j = 1; j < page_increm; j++) {
-				subpage = pages[i] + j;
-				pages[i + j] = subpage;
-				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
-				flush_dcache_page(subpage);
-			}
-		}
+		/* Check that we didn't pin more pages than the caller will free. */
+		VM_WARN_ON_ONCE(nr > nr_pages);
 
-		i += page_increm;
-		start += page_increm * PAGE_SIZE;
-		nr_pages -= page_increm;
+		i += nr;
+		start += nr * PAGE_SIZE;
+		nr_pages -= nr;
 	} while (nr_pages);
 out:
 	return i ? i : ret;
-- 
2.53.0-Meta


