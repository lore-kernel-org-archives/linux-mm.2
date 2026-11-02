Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6722B606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=FPThPrf+
Received: by kanga.kvack.org (Postfix)
	id 341176B05B8; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311BA6B05BB; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13AE76B05BD; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB80E6B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 409E1A0244
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:14 +0000 (UTC)
X-FDA: 85391172468.24.B775D2E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9E4A1A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FPThPr f";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+Y1QHFtpKDxBX3cd8NoCorZEg/TkqaNPXQ7MhtewMc=;
	b=yJGaq5jeN/9npzFFF99+X3BoMZzTB3MiExZGF8pk+Du6FQRVy2e/6Jwww9+fztonksV4wa
	tmlrzOwblPhJqAU5SxnUujCYgm8hRMzsQtM4knvc/NGzqdnqh9F23ZevIWj7wTINUtFkEG
	pUnLAvRzWf3+rXiEz1qe9Q5/9cEJFok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647872;
	b=GpCb2VKV2JMfu+fr7Wkqia8HpYHKAF3yqkpeFp4k5XznsxA8hw3kNC36JRSgj0t70uG4d4
	7lWYkmjaKDafdHM//LO3gF7zbSzAynOK26hlFMJpETA3QVjAOWpPPjo6ZuMfbVtE23tPfn
	6FfeQ9vF1F2fEW79Bb8mGhfafQZ92SY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FPThPr f";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=a+Y1QHFtpKDxBX3cd8NoCorZEg/TkqaNPXQ7MhtewMc=; b=FPThPr
	f+gnaBFhwXm+QLKw61BtZNxtTQ2yr7TKsOAxWxGSZE/n1BrsjYRo2pA/OdA5g4okA0aUepQKjkNIe
	e2sHbCUJJggyL247X9r9ts4OuXKbWI6DmWD4pLDPL2r+nkIQhGuWZlOqm2LyABXqVF17HIIv0CbhF
	gSAF0nrL3sRwN0hXfUQFhklFzDTKzs7I+nwWAzFHuh+BIc1+En1zQYSBV52TOkDm1bhnQoHdNK+jk
	MiARtJ0CNxSl4CXqs9Fnqg0algoUhk19Cw8SCKQY43VoaeDbYitJor6QeXDvsnpSL10OMLVFPtW8n
	ps0dw0zxWox2X3fb2jeDSPGThjqw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-0peP;
	Mon, 02 Nov 2026 19:30:32 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 6/8] mm/gup: return a huge page's full count from follow_page_mask()
Date: Mon,  2 Nov 2026 14:30:24 -0500
Message-ID: <20261102193026.3860700-7-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hmw5gx8wc8opabdyczg5wrk8b4unszki
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9E4A1A0007
X-HE-Tag: 1793647872-254978
X-HE-Meta: U2FsdGVkX19I5yhwvxy0S5uTKW0qMTe2Jo9D7CIFeVn/45zw6PuTBfKbZDJ6xKMX12dAeHVwR4XlRcrkWGmVMhl+U7l72LfO+PTFxGJQdw00XFuI5JK6R8B2WS0IpWxQv5nSb/f0/u1m6SVL21oHSl2YNdSV3KXjBmn2Tnj3qTyeESS80JHN4StGC2VUlx+VSO30ykg1dRk8GGxRILWWyTO+tp9PAmCVvBOD71sM/8I7hdpqjOot3VxCYDd8qpZlkKzyQ1OshNxkEALSzxffyDkGGCtYaems5yQSNaWTPndmo0OlpQXZdga+Z/FdYIvP9ULAg2wK/IAjcMl1VTdhh9uKLeZMzTwH0YV/D6d/YnI0GCgmSSgJoAecuqdmPvJdY+iMFFO+w7Kef651SrnwEtVnlskvK/qJgNrgZo6sveW7nPTohmqgokCjLzGfB2qdkTgdBoA46Tjf9mzLWQg0vfCbi51EFzIYrIyhl/23EuqTtpu1miTC13LMwf3m2ItML4d/e8wN8IvjKhK5Bam81Pj1EoEkIDTZ5z8kO0mcQscMC13HS29dCBJep6mUXpiS0DP2pIPCG3boplbiaeUuyxKMC+u8iF7yvvlST1aGv74GXMhIQiQ0Vd8oWgW2sCfxa1U7nHgqItQx4ivv56hZf+azdb1FlW6D52fLkQ1tafADx52mWKh3JXU9BdRATOQkkAKYcY+ZzGls5350DjGt5ijqwcXoOfM8vBKO/SVz2bDJMpdXeTkJTsJhaUlhS5WIvou78jk5ZjfjKKjK9nwxjNB5qldW9ddLBVqdkwnmCiroB1rKoiKSBMIz4iAZDTlyevxmQAvqqB0rcv9djr8IcBznMb7cMqR+664cO+tzqfr55FQL+wI0e91KcTH1UvXSTAjxz25A2PUCPc2Q8FVEY0bmVm2jqKevf5jfkOgnFmOtz3wzVx8PgIjd2IiIWuUjWnS2+lF6S2szA+XMIui
 rx1K3PDf
 lU45RjNT1EqDXcFzp/Sx2wtF++GqqXCrRhHY/q0PoZhYTA9bZmk14lezB0+6xp4WFRKlmM+/8adYwCf4GbmkXPncyKVdqBUGJ4UGxibKUvlEPxQl0E1jB68lRTp25x+s9g5LLRACZWwhXrGusmLYaXbc+OQOPw+/z6qUrxsZaTnr2kfheY8Sq8pKxhYVM8Vrx5+fXIEgVXOY0AmLvTww6jjHdw+jKwM9wqTf5WPnSuN892CgR4kPL4gk8L2LmoTAJEGTj+rVcSHMtcT30ZB8nWUBgcLgpG/C5V9yefog3iLU3gI+e/xTDLj9+iJD79mfUhtyAAZ1vmvPzOJfYynTv60dC1+0FoLNpfg4C0qchXM/4oOz+hJh+E0DIFUHBFRdmqtmxhIEK18DcJjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 150 +++++++++++++++++++++----------------------------------
 1 file changed, 58 insertions(+), 92 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2edffc424f272..9e7eb8a323bbf 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -683,14 +683,14 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
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
@@ -702,22 +702,23 @@ static long follow_huge_pud(struct vm_area_struct *vma,
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
@@ -739,13 +740,13 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
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
@@ -768,7 +769,10 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	off = PFN_DOWN(addr & ~HPAGE_PMD_MASK);
+	nr = min(HPAGE_PMD_NR - off, PFN_DOWN(end - addr));
+
+	ret = try_grab_folio(page_folio(page), nr, flags);
 	if (ret)
 		return ret;
 
@@ -777,28 +781,25 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
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
@@ -978,9 +979,8 @@ static long follow_page_pte(struct vm_area_struct *vma,
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
@@ -1016,7 +1016,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 		return pte_alloc(mm, pmd) ? -ENOMEM :
 			follow_page_pte(vma, address, pmd, flags, pages);
 	}
-	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
+	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
 
 	/*
@@ -1030,9 +1030,8 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
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
@@ -1045,11 +1044,13 @@ static long follow_pud_mask(struct vm_area_struct *vma,
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
@@ -1060,13 +1061,12 @@ static long follow_pud_mask(struct vm_area_struct *vma,
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
 
@@ -1077,18 +1077,18 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
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
@@ -1097,15 +1097,15 @@ static long follow_p4d_mask(struct vm_area_struct *vma,
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
@@ -1113,13 +1113,12 @@ static long follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		ret = no_page_table(vma, flags, address);
 	else
-		ret = follow_p4d_mask(vma, address, pgd, flags, page_mask, pages);
+		ret = follow_p4d_mask(vma, address, end, pgd, flags, pages);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1457,7 +1456,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1472,7 +1470,6 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
 		long nr;
 
 		/* first iteration or cross vma bound */
@@ -1527,8 +1524,8 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		nr = follow_page_mask(vma, start, gup_flags, &page_mask,
-				      pages ? &pages[i] : NULL);
+		nr = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+				      gup_flags, pages ? &pages[i] : NULL);
 		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   nr == -EMLINK, locked);
@@ -1550,56 +1547,25 @@ static long __get_user_pages(struct mm_struct *mm,
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
2.53.0-Meta


