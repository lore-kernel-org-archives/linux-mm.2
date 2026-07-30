Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81EBC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894FC6B0095; Thu, 30 Jul 2026 03:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845876B0096; Thu, 30 Jul 2026 03:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C186B0098; Thu, 30 Jul 2026 03:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1316B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:56:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2D29C0898
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:56:33 +0000 (UTC)
X-FDA: 85044685866.03.CDE3F64
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id B48CCA000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:56:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HGWdoxmu;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kYUoylBjRpt4UY7b9pvf/x3I+ZQSehWSo8f0BRembw0=;
	b=QhMZ+zuzt1LnpScxTn/yJ1U+EZJGbCo3u+ec1OevOve58Mqv7FqybObBRjv3ifJ9fcAgPR
	QCKrpVY1atRWZq2/jvQyOrRPSIJjV81adc3EplSxKkvqBk/3uQGLX2QmuZ9shwTVSWjyaf
	XTrLfcvT+KAvK3DkuFKly6lPa3STW2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785398191;
	b=mAbtuiQRNFQlQwDlkavf4ZfxFSaBLG6bF+SrwQnscm3UzX4m5ruiB3V2ZECm3u3HjMgD4U
	jNQuixWPx/y2BaUNRPYYy1eSMI+CwnP1q6xSAOvkT0BvV4Wzk4j1+kVmeXoManorQ/c7m9
	RqfdRjJUYOQiV4MIcA9z9+2LmCWNrTY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HGWdoxmu;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kYUoylBjRpt4UY7b9pvf/x3I+ZQSehWSo8f0BRembw0=; b=HGWdoxmuJlXoYeFMx2uayVs2Mn
	iuj5YQwVbefHSirIayStAY/eFz4r/bReeyROqayOcbEYV0gdoHtVdSGjBBYG6YZdb2B8ZYdjzz7xN
	4pUklA4gLV3XEgpv5Zd4m9EX1aVzcQktJus/KAx48ZCR9hr8RvF3eb7Xo6IWI+/+IHNFc1JuQSh8N
	lan2mkVtX+P8qeY+Bjgu47zISvvJyT9GK3n/E/bk0PPssuuOjvXxMcsEXF+mOGETLlFJV7bsiBTjo
	PUYiOjnrvZCAP1/lu64Vv+9EsVL+/cOi8QW0CG/jpZnHla/QY0LDPzz0JxzRrb15ypFeqaQUNhNQ3
	cY0pdKow==;
Received: from [2601:18c:8180:83cc:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wpLaS-000000006Ma-09Un;
	Thu, 30 Jul 2026 03:53:52 -0400
Date: Thu, 30 Jul 2026 03:53:50 -0400
From: Rik van Riel <riel@surriel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, Aristeu Rozanski
 <aris@ruivo.org>
Subject: [PATCH RFC] mm/gup: batch contiguous pages in follow_page_mask()
 and return them via a pages array
Message-ID: <20260730035350.1fc95dd8@fangorn>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B48CCA000B
X-Stat-Signature: s5jmqz4g88tep6zysxcoe9w9fgrxh147
X-HE-Tag: 1785398190-607053
X-HE-Meta: U2FsdGVkX1/s6oBLas4rJl2Fk47CuSL3dB5MWH/SZAObT3hZno2ZnE8iMegngZTHPiaoADwD4LckrNZfLEH6VQU/rHbEbt0+wTZFVr0JDrlRXkD6X136oGVpCkj4b1bJG3nT32pt+Wq8ZS0urxzNLwyXOwuoQXmShAigXAu9lxN+PAf+FZ5ZLv2DFchUT7vMJvK+5CB9H3Kb3c9OfLAzzsj1JSTsG/Mga2dFEghlzaXJxmvxWIvpEDEGXWfGv+510G4fGnp5bPmNjowYci9XntKSQKOWO1y+MPmaYTjOv5XJm4s9kuKW//5rTqktSjv88flMWQM64aq0DCIMWThURc8l5I/9nUk4tRzB5nSUtfkl/AkJY2TGByXLoJ7Rt4zACU5ATfkZ0RI2DZpQ98qCDk5w1aoqmVm8QMvOf7CT/Kq3P5KM9YUr/O1iAsWwhv3diYnmhaTaIao6HJI32Zqyk67EJEoG2f34r3JO2U9xKFzs+6kcdexOhsiAIRTCiVYT3UkN/8XamddyHKcuORrYJyn5l/6v+wATEQTjSMfitYhuXJ7Vm5l0Ovz6phRGAUOKUSga0gbMc6KjguHzAl0+V5W6MKPiFvHsir2SyZ8aYkbvZxinz1/bOZMkBu2GqNRKnXEPYfdwU6tvanYmN86TTKjPpjrZF9eJwjgWSBJMoK/y1rXURrxYBnW8o58Rwh/FsOf9DpQgQ8hEyeD62nSlIeiicKWdNZeICdjqZWGHZjZx+ScvrifxZkbjm33VpniIn9t25PKElPz5cscAHfEkTZZThihif4pQlhtLsHrBR7OPpJegxcs4ElAkriy9fnZiNQNQ9qRToW3ZYX6PXu9SS41bXtqSkVX3jlvk7bcf5GjDe/tf5TSP4l1hAmuIqQWfzOlvMVH9ij+kTQx80rJwjPwZbJiCWR0YGbAfZ+T2EuGWzQt9PTzQ8ATzUsTlESGuE6KU4VD/mz3IxAWMOdQ
 /JOVKFZG
 ZqN6iQqlZQV2WRJpMs3Mzt0cmyYJ4P0LVZUAcsy42WWj5u2i4/PO10/2DlD3+0RSIhq6o3Mq0i/c8FIqypWqg16PmIpNgDsWzzcdBVDHYRfCd9937svmfUH7KmYyFXh8zw448dmZNuH0meMerBpoOlLJIRJM+kRiVo8QQB7+ZmUvNF7DaxHL7yhWmrMxBUPYwj1tdrZBkzaEHWQIaT4HN1850aePJsjRDAi/y1MS0lyJsz0s94Imm4BQSBUPMkKliPNhGxWlyK9dF4SOV5f+7p5paqZqrPtgUWUCXTGPl2CSnaU80hVMXQ2jQlUwrvjSGmmSWKdHPsj6DOg4dy4gtFA9OYFo5LadiC2qvtVpfxTB5Z0NLTlaZl3sRfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() reports the size of the page it found with a page_mask:
a bitmask of the enclosing naturally-aligned huge page. That can only
describe a power-of-two block aligned to its own size.

A PTE-mapped large folio is walked one page at a time even though
it maps a contiguous run, while the PMD/PUD-mapped cases already return
their whole mapping in one step.

Even when a huge PMD/PUD call does return more than one page, the walk
still only hands back a single struct page* for the first page.

The caller, __get_user_pages(), has to grab refs for the remaining pages
and fill its own pages[] array afterward: a second try_grab_folio() call
for everything beyond the first page, then a loop storing each subpage
and flushing caches, outside the walk that found them.

By moving the work done in that second loop into follow_page_mask(),
the repeated page table walks can be avoided for PTE mapped pages.

Walking the whole range inside follow_page_pte() avoids restarting the
walk, redoing the pgd/p4d/pud/pmd descent and retaking the PTE lock, at
every folio boundary within the same page table.

To keep things simple, follow_page_mask() does still only walk
one P4D, PUD, and PMD at a time. The vast majority of requests
should be much smaller.

A PFNMAP page with no struct page returns -EEXIST, fatal only when the
caller wants **pages filled in. The vsyscall gate area, which never
goes through follow_page_mask(), keeps filling its own single pages[]
slot rather than sharing the batch-fill logic that moved into the
walkers.

The old page_increm clamp to the caller's remaining request
(page_increm > nr_pages) is now a VM_WARN_ON_ONCE instead of a silent
correction: follow_page_mask() already bounds every batch by @end, and
@end is derived from the caller's remaining nr_pages, so the count
coming back should never exceed it.

Unlike before, refs are already grabbed and pages[] already filled by
the time the caller sees the count, so silently clamping it down at
this point would leak references instead of merely wasting a
comparison.

Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, the slow
pin_user_pages() path) on a 256 MB MADV_HUGEPAGE anonymous region in a
4 CPU VM, median get time over 16 iterations, before and after measured
back to back in the same VM. Each folio size was confirmed through the
per-size anon_fault_alloc counters (4096 folios for 64 kB, 128 for 2 MB):

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  64 kB mTHP            2929 us      201 us   (14.6x)
  2 MB THP (control)      73 us       69 us
  4 kB base (control)   2721 us     1198 us   (2.3x)

The PMD-mapped 2 MB THP already returned the whole mapping in one step
and doesn't go through follow_page_pte() at all, so it stays flat
within measurement noise.

The 64 kB run benefits from batching the refcount grab across the
whole run and from no longer restarting the walk between runs.

The 4 kB case never batches (each page is its own folio) but still
benefits from not restarting the walk between adjacent pages in the
same page table.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 539 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 329 insertions(+), 210 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..3804c7f4c355 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -608,15 +608,15 @@ static inline bool can_follow_write_common(struct page *page,
 	return page && PageAnon(page) && PageAnonExclusive(page);
 }
 
-static struct page *no_page_table(struct vm_area_struct *vma,
-				  unsigned int flags, unsigned long address)
+static long no_page_table(struct vm_area_struct *vma,
+		unsigned int flags, unsigned long address)
 {
 	if (!(flags & FOLL_DUMP))
-		return NULL;
+		return 0;
 
 	/*
 	 * When core dumping, we don't want to allocate unnecessary pages or
-	 * page tables.  Return error instead of NULL to skip handle_mm_fault,
+	 * page tables.  Return error instead of 0 to skip handle_mm_fault,
 	 * then get_dump_page() will return NULL to leave a hole in the dump.
 	 * But we can only make this optimization where a hole would surely
 	 * be zero-filled if handle_mm_fault() actually did handle it.
@@ -625,12 +625,29 @@ static struct page *no_page_table(struct vm_area_struct *vma,
 		struct hstate *h = hstate_vma(vma);
 
 		if (!hugetlbfs_pagecache_present(h, vma, address))
-			return ERR_PTR(-EFAULT);
+			return -EFAULT;
 	} else if ((vma_is_anonymous(vma) || !vma->vm_ops->fault)) {
-		return ERR_PTR(-EFAULT);
+		return -EFAULT;
 	}
 
-	return NULL;
+	return 0;
+}
+
+static void gup_fill_pages(struct vm_area_struct *vma, unsigned long address,
+		struct page *page, unsigned long nr, struct page **pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr; i++) {
+		struct page *subpage = page + i;
+
+		pages[i] = subpage;
+		flush_anon_page(vma, subpage, address + i * PAGE_SIZE);
+		flush_dcache_page(subpage);
+	}
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
@@ -646,38 +663,43 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 	return can_follow_write_common(page, vma, flags);
 }
 
-static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+static long follow_huge_pud(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long end,
+		pud_t *pudp, unsigned int flags,
+		struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
 	pud_t pud = *pudp;
 	unsigned long pfn = pud_pfn(pud);
+	unsigned long off, nr;
 	int ret;
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
 	if (!pud_present(pud))
-		return NULL;
+		return 0;
 
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
-		return NULL;
+		return 0;
 
-	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
+	off = (addr & ~PUD_MASK) >> PAGE_SHIFT;
+	pfn += off;
 	page = pfn_to_page(pfn);
 
 	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
-		return ERR_PTR(-EMLINK);
+		return -EMLINK;
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	nr = min(HPAGE_PUD_NR - off, (end - addr) >> PAGE_SHIFT);
+
+	ret = try_grab_folio(page_folio(page), nr, flags);
 	if (ret)
-		page = ERR_PTR(ret);
-	else
-		*page_mask = HPAGE_PUD_NR - 1;
+		return ret;
+
+	gup_fill_pages(vma, addr, page, nr, pages);
 
-	return page;
+	return nr;
 }
 
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
@@ -698,14 +720,15 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 	return !userfaultfd_huge_pmd_wp(vma, pmd);
 }
 
-static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_huge_pmd(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long end,
+		pmd_t *pmd, unsigned int flags,
+		struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
 	struct page *page;
+	unsigned long off, nr;
 	int ret;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
@@ -713,50 +736,55 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	page = pmd_page(pmdval);
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pmd(pmdval, page, vma, flags))
-		return NULL;
+		return 0;
 
 	/* Avoid dumping huge zero page */
 	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(pmdval))
-		return ERR_PTR(-EFAULT);
+		return -EFAULT;
 
 	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
-		return NULL;
+		return 0;
 
 	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
-		return ERR_PTR(-EMLINK);
+		return -EMLINK;
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	off = (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
+	nr = min(HPAGE_PMD_NR - off, (end - addr) >> PAGE_SHIFT);
+
+	ret = try_grab_folio(page_folio(page), nr, flags);
 	if (ret)
-		return ERR_PTR(ret);
+		return ret;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_TOUCH))
 		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	*page_mask = HPAGE_PMD_NR - 1;
+	page += off;
+
+	gup_fill_pages(vma, addr, page, nr, pages);
 
-	return page;
+	return nr;
 }
 
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
-static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+static long follow_huge_pud(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long end,
+		pud_t *pudp, unsigned int flags,
+		struct page **pages)
 {
-	return NULL;
+	return 0;
 }
 
-static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_huge_pmd(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long end,
+		pmd_t *pmd, unsigned int flags,
+		struct page **pages)
 {
-	return NULL;
+	return 0;
 }
 #endif	/* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 
@@ -799,67 +827,24 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
-static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags)
+/*
+ * The caller has already run every per-PTE safety check (present,
+ * write-fault, gup_must_unshare()) on each PTE in the run, so this only
+ * does the per-folio work: the refcount grab, the FOLL_PIN accessibility
+ * fault-in, dirty/accessed marking, and the array fill with per-subpage
+ * cache flushes.
+ */
+static long follow_page_pte_commit(struct vm_area_struct *vma,
+		unsigned long run_address, struct folio *folio,
+		struct page *run_page, pte_t run_pte, unsigned long run_len,
+		unsigned int flags, struct page **pages)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	struct folio *folio;
-	struct page *page;
-	spinlock_t *ptl;
-	pte_t *ptep, pte;
-	int ret;
-
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (!ptep)
-		return no_page_table(vma, flags, address);
-	pte = ptep_get(ptep);
-	if (!pte_present(pte))
-		goto no_page;
-	if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
-		goto no_page;
-
-	page = vm_normal_page(vma, address, pte);
-
-	/*
-	 * We only care about anon pages in can_follow_write_pte().
-	 */
-	if ((flags & FOLL_WRITE) &&
-	    !can_follow_write_pte(pte, page, vma, flags)) {
-		page = NULL;
-		goto out;
-	}
-
-	if (unlikely(!page)) {
-		if (flags & FOLL_DUMP) {
-			/* Avoid special (like zero) pages in core dumps */
-			page = ERR_PTR(-EFAULT);
-			goto out;
-		}
-
-		if (is_zero_pfn(pte_pfn(pte))) {
-			page = pte_page(pte);
-		} else {
-			ret = follow_pfn_pte(vma, address, ptep, flags);
-			page = ERR_PTR(ret);
-			goto out;
-		}
-	}
-	folio = page_folio(page);
-
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
-		page = ERR_PTR(-EMLINK);
-		goto out;
-	}
-
-	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			     !PageAnonExclusive(page), page);
+	long ret;
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret)) {
-		page = ERR_PTR(ret);
-		goto out;
-	}
+	ret = try_grab_folio(folio, run_len, flags);
+	if (unlikely(ret))
+		return ret;
 
 	/*
 	 * We need to make the page accessible if and only if we are going
@@ -869,14 +854,13 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	if (flags & FOLL_PIN) {
 		ret = arch_make_folio_accessible(folio);
 		if (ret) {
-			unpin_user_page(page);
-			page = ERR_PTR(ret);
-			goto out;
+			gup_put_folio(folio, run_len, flags);
+			return ret;
 		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !folio_test_dirty(folio))
+		    !pte_dirty(run_pte) && !folio_test_dirty(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * pte_mkyoung() would be more correct here, but atomic care
@@ -885,24 +869,184 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		 */
 		folio_mark_accessed(folio);
 	}
-out:
-	pte_unmap_unlock(ptep, ptl);
-	return page;
-no_page:
-	pte_unmap_unlock(ptep, ptl);
-	if (!pte_none(pte))
-		return NULL;
-	return no_page_table(vma, flags, address);
+
+	gup_fill_pages(vma, run_address, run_page, run_len, pages);
+
+	return 0;
+}
+
+/*
+ * Return how many PTEs starting at @ptep (whose value is @pte, mapping a
+ * page of @folio) can be committed together with it: consecutive present
+ * PTEs mapping consecutive pages of @folio with a uniform write bit,
+ * bounded by @walk_end (already clamped to this page table, this VMA, and
+ * the caller's requested range). Returns at least 1. A cheap pte_same()
+ * scan, not a re-derivation of each page via vm_normal_page(), so a large
+ * folio's run costs one such scan instead of one per page.
+ *
+ * gup_must_unshare() and the write-fault check are per PTE. A writable run
+ * is always safe: a writable anon page is exclusive, and FOLL_WRITE is
+ * satisfied. A read-only run is only safe for a plain read; FOLL_WRITE
+ * would need a COW fault per page and FOLL_PIN would need a per-page
+ * gup_must_unshare() check, so those fall back to a single page and let
+ * the caller's own per-PTE loop cover the rest one at a time.
+ */
+static unsigned long follow_pte_batch(struct vm_area_struct *vma,
+		unsigned long address, unsigned long walk_end, struct folio *folio,
+		pte_t *ptep, pte_t pte, unsigned int flags)
+{
+	pte_t batch_pte = pte;
+	unsigned long max;
+
+	if (!folio_test_large(folio))
+		return 1;
+	if (!pte_write(pte) && (flags & (FOLL_WRITE | FOLL_PIN)))
+		return 1;
+
+	max = (walk_end - address) >> PAGE_SHIFT;
+	if (max <= 1)
+		return 1;
+
+	return folio_pte_batch_flags(folio, vma, ptep, &batch_pte, max,
+				     FPB_RESPECT_WRITE);
 }
 
-static struct page *follow_pmd_mask(struct vm_area_struct *vma,
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+/*
+ * Walk the PTEs from @address to @end (bounded to this page table and this
+ * VMA), one run at a time. Each run starts with a full per-PTE resolve
+ * (vm_normal_page(), write-fault check, gup_must_unshare()) on its first
+ * PTE, then follow_pte_batch() finds how many more PTEs extend it via a
+ * cheap comparison scan, without re-deriving each one. Looping here
+ * instead of returning to the caller after every run avoids restarting
+ * the walk -- redoing the pgd/p4d/pud/pmd descent and retaking this lock
+ * -- at each folio boundary inside the range.
+ *
+ * If the first PTE cannot be included (not present, needs a write/unshare
+ * fault, is a PFN-special mapping, ...), that reason is returned directly,
+ * matching what a single-PTE call would have returned. If a later run hits
+ * one of those conditions after an earlier run in this call already
+ * succeeded, the walk simply stops there and returns what it already has;
+ * the caller will re-issue starting at that address and get the real
+ * classification then.
+ */
+static long follow_page_pte(struct vm_area_struct *vma,
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pte_t *ptep, *orig_ptep;
+	unsigned long walk_end;
+	unsigned long nr = 0;
+	bool need_no_page_table = false;
+	long ret = 0;
+
+	orig_ptep = ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!ptep)
+		return no_page_table(vma, flags, address);
+
+	walk_end = min(pmd_addr_end(address, end), vma->vm_end);
+
+	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+		struct page *page;
+		struct folio *folio;
+		unsigned long batch;
+
+		if (!pte_present(pte)) {
+			if (nr)
+				break;
+			if (pte_none(pte))
+				need_no_page_table = true;
+			goto unlock;
+		}
+		if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags)) {
+			if (nr)
+				break;
+			goto unlock;
+		}
+
+		page = vm_normal_page(vma, address, pte);
+
+		/*
+		 * We only care about anon pages in can_follow_write_pte().
+		 */
+		if ((flags & FOLL_WRITE) &&
+		    !can_follow_write_pte(pte, page, vma, flags)) {
+			if (nr)
+				break;
+			goto unlock;
+		}
+
+		if (unlikely(!page)) {
+			if (flags & FOLL_DUMP) {
+				/* Avoid special (like zero) pages in core dumps */
+				if (nr)
+					break;
+				ret = -EFAULT;
+				goto unlock;
+			}
+
+			if (is_zero_pfn(pte_pfn(pte))) {
+				page = pte_page(pte);
+			} else {
+				/*
+				 * Proper page table entry exists, but no
+				 * corresponding struct page: the caller decides
+				 * whether that is fatal (see the -EEXIST handling
+				 * in __get_user_pages()).
+				 */
+				if (nr)
+					break;
+				ret = follow_pfn_pte(vma, address, ptep, flags);
+				goto unlock;
+			}
+		}
+		folio = page_folio(page);
+
+		if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
+			if (nr)
+				break;
+			ret = -EMLINK;
+			goto unlock;
+		}
+
+		VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+				     !PageAnonExclusive(page), page);
+
+		batch = follow_pte_batch(vma, address, walk_end, folio, ptep, pte,
+					 flags);
+
+		ret = follow_page_pte_commit(vma, address, folio, page, pte,
+					     batch, flags,
+					     pages ? pages + nr : NULL);
+		if (ret) {
+			if (nr)
+				break;
+			goto unlock;
+		}
+		nr += batch;
+
+		/* The loop's own increment covers one PTE; skip the rest of the batch. */
+		ptep += batch - 1;
+		address += (batch - 1) * PAGE_SIZE;
+	}
+
+unlock:
+	pte_unmap_unlock(orig_ptep, ptl);
+	if (need_no_page_table)
+		ret = no_page_table(vma, flags, address);
+	return nr ? (long)nr : ret;
+}
+
+static long follow_pmd_mask(struct vm_area_struct *vma,
+		unsigned long address, unsigned long end,
+		pud_t *pudp, unsigned int flags,
+		struct page **pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
-	struct page *page;
+	long ret;
 	struct mm_struct *mm = vma->vm_mm;
 
 	pmd = pmd_offset(pudp, address);
@@ -912,7 +1056,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -925,28 +1069,28 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
-		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags);
+		return pte_alloc(mm, pmd) ? -ENOMEM :
+			follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
-	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
+	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
-	return page;
+	return ret;
 }
 
-static struct page *follow_pud_mask(struct vm_area_struct *vma,
-				    unsigned long address, p4d_t *p4dp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_pud_mask(struct vm_area_struct *vma,
+		unsigned long address, unsigned long end,
+		p4d_t *p4dp, unsigned int flags,
+		struct page **pages)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
-	struct page *page;
+	long ret;
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
@@ -955,22 +1099,22 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+		ret = follow_huge_pud(vma, address, end, pudp, flags, pages);
 		spin_unlock(ptl);
-		if (page)
-			return page;
+		if (ret)
+			return ret;
 		return no_page_table(vma, flags, address);
 	}
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
+	return follow_pmd_mask(vma, address, end, pudp, flags, pages);
 }
 
-static struct page *follow_p4d_mask(struct vm_area_struct *vma,
-				    unsigned long address, pgd_t *pgdp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_p4d_mask(struct vm_area_struct *vma,
+		unsigned long address, unsigned long end,
+		pgd_t *pgdp, unsigned int flags,
+		struct page **pages)
 {
 	p4d_t *p4dp, p4d;
 
@@ -981,15 +1125,18 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
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
+ * @pages: array to receive the pages, refcounted per @flags, or NULL to
+ *         walk the page tables (e.g. to fault pages in) without collecting
+ *         or refcounting them
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -998,33 +1145,32 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, @page_mask is set according to the size of the page.
- *
- * Return: the mapped (struct page *), %NULL if no mapping exists, or
- * an error pointer if there is a mapping to something not represented
- * by a page descriptor (see also vm_normal_page()).
+ * Return: the number of contiguous pages starting at @address that were
+ * placed into @pages (if non-NULL), which may be fewer than the pages
+ * requested via @end; 0 if no mapping exists at @address; or a negative
+ * errno for a mapping to something not represented by a page descriptor
+ * (see also vm_normal_page()).
  */
-static struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned long *page_mask)
+static long follow_page_mask(struct vm_area_struct *vma,
+		unsigned long address, unsigned long end,
+		unsigned int flags, struct page **pages)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
-	struct page *page;
+	long ret;
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		page = no_page_table(vma, flags, address);
+		ret = no_page_table(vma, flags, address);
 	else
-		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
+		ret = follow_p4d_mask(vma, address, end, pgd, flags, pages);
 
 	vma_pgtable_walk_end(vma);
 
-	return page;
+	return ret;
 }
 
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
@@ -1358,7 +1504,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1373,7 +1518,7 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
+		long nr;
 
 		/* first iteration or cross vma bound */
 		if (!vma || start >= vma->vm_end) {
@@ -1400,8 +1545,19 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				page_mask = 0;
-				goto next_page;
+				/*
+				 * The gate area never goes through
+				 * follow_page_mask(); fill its slot here.
+				 */
+				if (pages) {
+					pages[i] = page;
+					flush_anon_page(vma, page, start);
+					flush_dcache_page(page);
+				}
+				i++;
+				start += PAGE_SIZE;
+				nr_pages--;
+				continue;
 			}
 
 			if (!vma) {
@@ -1423,10 +1579,11 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, gup_flags, &page_mask);
-		if (!page || PTR_ERR(page) == -EMLINK) {
+		nr = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+				      gup_flags, pages ? &pages[i] : NULL);
+		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
-					   PTR_ERR(page) == -EMLINK, locked);
+					   nr == -EMLINK, locked);
 			switch (ret) {
 			case 0:
 				goto retry;
@@ -1440,70 +1597,32 @@ static long __get_user_pages(struct mm_struct *mm,
 				goto out;
 			}
 			BUG();
-		} else if (PTR_ERR(page) == -EEXIST) {
+		} else if (nr == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
 			 * struct page. If the caller expects **pages to be
 			 * filled in, bail out now, because that can't be done
-			 * for this page.
+			 * for this page. Otherwise the caller didn't ask for the
+			 * page back, so the missing struct page isn't actionable
+			 * for it; advance by the one page follow_page_mask()
+			 * looked at.
 			 */
 			if (pages) {
-				ret = PTR_ERR(page);
+				ret = nr;
 				goto out;
 			}
-		} else if (IS_ERR(page)) {
-			ret = PTR_ERR(page);
+			nr = 1;
+		} else if (nr < 0) {
+			ret = nr;
 			goto out;
 		}
-next_page:
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
-		if (page_increm > nr_pages)
-			page_increm = nr_pages;
-
-		if (pages) {
-			struct page *subpage;
-			unsigned int j;
-
-			/*
-			 * This must be a large folio (and doesn't need to
-			 * be the whole folio; it can be part of it), do
-			 * the refcount work for all the subpages too.
-			 *
-			 * NOTE: here the page may not be the head page
-			 * e.g. when start addr is not thp-size aligned.
-			 * try_grab_folio() should have taken care of tail
-			 * pages.
-			 */
-			if (page_increm > 1) {
-				struct folio *folio = page_folio(page);
-
-				/*
-				 * Since we already hold refcount on the
-				 * large folio, this should never fail.
-				 */
-				if (try_grab_folio(folio, page_increm - 1,
-						   gup_flags)) {
-					/*
-					 * Release the 1st page ref if the
-					 * folio is problematic, fail hard.
-					 */
-					gup_put_folio(folio, 1, gup_flags);
-					ret = -EFAULT;
-					goto out;
-				}
-			}
 
-			for (j = 0; j < page_increm; j++) {
-				subpage = page + j;
-				pages[i + j] = subpage;
-				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
-				flush_dcache_page(subpage);
-			}
-		}
+		/* Never pin more pages than the caller will free.  */
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


