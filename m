Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D143AC5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE8D6B008C; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C868C6B0092; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26E36B0093; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5636B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0A21C02FA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:12 +0000 (UTC)
X-FDA: 85087502304.25.79F7409
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40CBB140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=eVYMgUEH;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4/cELZKpN9Jscfu/G3Szd5piq+pvPYj8i+M2wz0YJg=;
	b=B16PkSSGmEa+xAeVR0LY1a431p4vvTYRBhw2F5cKcBhdlQKSl12QB/fFUjMa2Xa3HTrs/d
	LSSH0LFRP9FPuKBp8PHtp+7Q0Fb/LNawYowaG7QUi23fPwG2N/pFnrShAHTc6yfQYK4tKU
	W/bHc08isDt1f9CJp+bPy2Tk5gzP7rI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417631;
	b=Ymg4SKC/xbw3uL4scXGufeFLXQj5EdsVxfdqZoI/ijdgFB0iRJCGso0Uxmam+eduGNZu3T
	R+p5cwwQyXU0FwF8Y2AciRwNYIZd7oQy26wYiasC1n0qt6DltvoCRJImBXEFk+ABQ6z2+K
	wH6rNANalAyX3n2skDAnOZ4eLFGC0Z8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=eVYMgUEH;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o4/cELZKpN9Jscfu/G3Szd5piq+pvPYj8i+M2wz0YJg=; b=eVYMgUEH65xNmDXoq7mZCQ6Eg0
	Z66EcMWnUJ4SSa8XU3Tagr4plr2E3bI6utDinRBnVSlhAwJaQqrUwcqlNvWV40OckRjrxohMjhcAQ
	s2q3booJTy0w5BfLdr9AODWKSGe++cTlTc+yNrUZerw0/UmD774DewWnG2A8lNerWaj669wJe1xeR
	z4liytRtQzyg2bAhd0BOPjhbzCQBe/MNLmjV9lo86N8v0P5V2VWlVUzEGaBWRslCo57PGZPe+XuLY
	Q+pIJ9UpB1bgWeejKM2F5wRDJA+cd7HjDM2IofmvEb3Cfo2EPz1IfFAR6DTta1GQZoMDn/ml+sCi2
	dWObgaIg==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2oev;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 6/8] mm/gup: return a huge page's full count from follow_page_mask()
Date: Mon, 10 Aug 2026 22:51:55 -0400
Message-ID: <20260811025157.1632867-7-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40CBB140004
X-Stat-Signature: cksyi5opnw8qgnykgzie6w9rsn8nf5ab
X-Rspam-User: 
X-HE-Tag: 1786417631-13942
X-HE-Meta: U2FsdGVkX1/4IP1lV28gcQhGB4aAp95B7F0vfQqBPKRd6UpHSNG5hB07QEKSZhA5tEaz+8PxBaEBqhWYEfEcQ4U5ZxBME3MMcXmG0ZjHVMU7PXnpXxE0jfpWtKONGAslyIb8TYXNY/sLUT2iLHsVLcZqnoVXitKnelICX+35J68Ugdf3MGmuBsIZPB5h4yU5BfWCGJAOPX29N1SK+rRlX2FAiHmdWcyrKsNNIR4QPA3DQtJrHJfzPiUlXMLG5yEYHdQiB1SzHdA5FcwygOGEJJN+91XWWLKP7ojKSVVdd1u0v4rURs2yhTQn8kR6PkzNGECB2RsKS/4K6BFidNas+PVSe2hg/UUunglw5MsLm8LWUMhJ+udxBLvTZof5/8JoXTXqgvW7KDzssK25VTPJlB54Hvw55AyzK0oxZGEVJDvkle2UBHVXHSrnm2C/MGyHzzwki+tBy53KH2RLncHvtNF5XqxQC2M+uizLsHx4s/ZFMYpTu6jxm1S4Q6bbUFgaWWaBXGzgMkeSErXNkApt9bP1BvgN791Ol+avrmRygiSlspmEXzOoWBXzLhEO6pH8nUZ5SFqxZdjh+6IlsYGcOFZS12e5SN1IrAjxKaPny+xN9umzlWSR+mfNip0N6vmQdQnJXSKsGOIcQsF53fqX5geBnyNrSEZPYvaVSNDRa76youY3qkgfugAFcVI6iIPPclwEM5Sz7Ml5R3lKoGxHEZcE7165Nm0COiLMaSko5ZbwPSsS6j9AEutKyBWnY8UASLSNgbOXCTQzI0cKip+btyAQyW3QUkhJxq2c0DT0dxVvUPPiTOfWY/uNTLfz7Zd/7S4+imjZe98DosL81Z1m/OjLn23e6vcMcoSWanYqL9ltCy1vizTagpa42NA1KrZuMf8eo2XySH+W/BXL40AMl7Zt7xEpYI3iGWj17HLigKjaoj1HDQr+JmvaZ00mdXlwqKfDZkrh6afda4lxX2G
 RfpTeVjw
 +AJVaswJ7oqS9gyvNkRgkce/+4zlzvJ9XfEFHgEfg3HZjBh0nXlRUCLwMJjjnbwXNPWiRVKa7F3WHDILiZF/ZGudZ4FXk2C70L390T5rVOovFvyyMmFWh0yl55Kz1SjJgXpuKT6zRB29cQOi2ER5/A2Khh5FWKkyAJ7wgUyItPqQyt23A7a8vUz2aN/0eX47xXJr0pZDRCAk5acbeyQNxkb1C8mcxIjx0KZA8dx7hyBH17OwIYbuUuvvqF12ZBKsAblo09wgOBdd09qgXo0dIZhd6dvmXPkrO3QG14YAoq96b+Y3o6CCCTgJ8r/EX9qgjHGGfrLrU+8nC1oWuEZSFfQsQCA==
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

Have the huge paths report their count as the return value instead,
clamped to the huge page's size and @end. The merged grab returns
whatever error try_grab_folio() gives, instead of forcing -EFAULT on the
second call's failure.

*page_mask and __get_user_pages()'s second-grab/subpage loop are now
dead; remove them. The old silent page_increm clamp becomes a
VM_WARN_ON_ONCE, since @end already bounds the count and refs/pages[]
are already committed by the time the caller sees it -- truncating here
would leak references, not just waste a comparison.

follow_page_pte() is unaffected, still returning at most 1 page.

The -EEXIST path needs an explicit nr = 1 when pages == NULL: it used to
get that from page_mask staying 0 for a PFN-special PTE, but nr holds
-EEXIST there, which would grow nr_pages instead of shrinking it.

mm/gup_test.c (PIN_LONGTERM_BENCHMARK) shows no measurable change; the
lock-hold-time improvement is by inspection, not measurement.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 150 +++++++++++++++++++++----------------------------------
 1 file changed, 58 insertions(+), 92 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 4036d3dc27df..ea2bb379183e 100644
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
@@ -683,22 +683,23 @@ static long follow_huge_pud(struct vm_area_struct *vma,
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
 	if (pages)
 		pages[0] = page;
 
-	return 1;
+	return nr;
 }
 
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
@@ -720,13 +721,13 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
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
@@ -749,7 +750,10 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	off = PFN_DOWN(addr & ~HPAGE_PMD_MASK);
+	nr = min(HPAGE_PMD_NR - off, PFN_DOWN(end - addr));
+
+	ret = try_grab_folio(page_folio(page), nr, flags);
 	if (ret)
 		return ret;
 
@@ -758,28 +762,25 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	*page_mask = HPAGE_PMD_NR - 1;
+	page += off;
 
 	if (pages)
 		pages[0] = page;
 
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
@@ -953,9 +954,8 @@ static long follow_page_pte(struct vm_area_struct *vma,
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
@@ -991,7 +991,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 		return pte_alloc(mm, pmd) ? -ENOMEM :
 			follow_page_pte(vma, address, pmd, flags, pages);
 	}
-	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
+	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
 
 	/*
@@ -1005,9 +1005,8 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
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
@@ -1020,11 +1019,13 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
+		ret = follow_huge_pud(vma, address, end, pudp, flags, pages);
 		spin_unlock(ptl);
 		/*
 		 * The ref is already held, so the page cannot go away: fill
-		 * the array and flush caches without the lock.
+		 * the array and flush caches without the lock. A 1 GB folio
+		 * can be up to HPAGE_PUD_NR pages, too long to flush under a
+		 * spinlock.
 		 */
 		if (ret > 0 && pages)
 			gup_fill_pages(vma, address, pages[0], ret, pages);
@@ -1035,13 +1036,12 @@ static long follow_pud_mask(struct vm_area_struct *vma,
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
 
@@ -1052,18 +1052,18 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
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
@@ -1072,15 +1072,15 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
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
@@ -1088,13 +1088,12 @@ static long follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		ret = no_page_table(vma, flags, address);
 	else
-		ret = follow_p4d_mask(vma, address, pgd, flags, page_mask, pages);
+		ret = follow_p4d_mask(vma, address, end, pgd, flags, pages);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1432,7 +1431,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1447,7 +1445,6 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
 		long nr;
 
 		/* first iteration or cross vma bound */
@@ -1502,8 +1499,8 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		nr = follow_page_mask(vma, start, gup_flags, &page_mask,
-				      pages ? &pages[i] : NULL);
+		nr = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+				      gup_flags, pages ? &pages[i] : NULL);
 		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   nr == -EMLINK, locked);
@@ -1525,56 +1522,25 @@ static long __get_user_pages(struct mm_struct *mm,
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
-			gup_fill_pages(vma, start + PAGE_SIZE, pages[i] + 1,
-				       page_increm - 1, pages + i + 1);
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
2.55.0


