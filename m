Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50352C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4115D6B008A; Tue, 28 Jul 2026 23:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39BA26B008C; Tue, 28 Jul 2026 23:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23CB56B0092; Tue, 28 Jul 2026 23:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEFEC6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:04:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FD581203B3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:04:23 +0000 (UTC)
X-FDA: 85040320806.29.6CB4C98
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67BCF180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:04:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=NM8AeRiv;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785294261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRrzaTkeqMhQEAFJoBWQCaCouPXjA4AXdDyoXmearKc=;
	b=si50olo8XqQZjFwCZD8ffY/DSDvjKVZIQA+k4j0jNKjcIb0ns/Jd5/6g7cOaIKE3+XGyg3
	rPqhsQZvOq6kPqnPvTfu49BjH0aYz0unIDjh3tMU5U2Xom5PoRyBoUyykxn2y3RXbEG02U
	XvZawW4nqJ5y610QZ4NpV1xiTTOMZ38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785294261;
	b=VXDTW9Mo6M1m68bewXIXX6W414+j1VExSA5h9RxDx4lKIwe62SwfHSYuO5mjgKDQN4rwMq
	qstD8Iwe9QVYeUa/YFQzAQXBlOtDCyp7JPfd1bTtagCP8353c4U/ldttltPxZr7bLOKRAG
	mxqNvIU1msD+XnlqMsbqhiKU+SHoaTQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=NM8AeRiv;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lRrzaTkeqMhQEAFJoBWQCaCouPXjA4AXdDyoXmearKc=; b=NM8AeRivIdQE37nqagRYGyNdLy
	9ZfMvg7XrhV1Ixsu0vT1e7QvjJftSli3t4BN83AFKDPT3EI2PcYNrr/c87UNcO8tlJZ0YJnivC20i
	LArFiUphpd+yb4QfMld0U3pmMYwlenuGI3i+/KcmvcFbSMW2c4AKXIe8sxcAVIYsqF9OzNlYl6tew
	uJH8nXwvnqujziIP/8KBAYck5lDG8jStTZUiZn+Su5e5cvuugS9rJX1LYT909hPMA5J9O0bfiJ0L8
	T6dSJUd/+qZ1yxniJvls7o7sEDiSMEq4R1WEiPE/5yNV3GF1jFJcYNCfGrtdc6517DF8qcqp+nydc
	MkGPFAtw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wouZ2-000000004ml-0MDM;
	Tue, 28 Jul 2026 23:02:36 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com
Subject: [PATCH 1/2] mm/gup: pass an end address to follow_page_mask() and return a page count
Date: Tue, 28 Jul 2026 23:02:33 -0400
Message-ID: <20260729030234.2063885-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260729030234.2063885-1-riel@surriel.com>
References: <20260729030234.2063885-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 67BCF180002
X-Stat-Signature: sw1egzo39txycq5y7igejhhsrzs8e9y5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785294261-248199
X-HE-Meta: U2FsdGVkX1/K9g9GAss9xJidRbhZi/eNBTSi/rSaiWvvw+T3JLbrYLiOBOUxbDlQney7Z5h/35AdFMFOVFP2kLqEDjS5qlY5JLuT93cZ0SObkdrN9cJ4zJSqMiMEzNRJeXdqnZt2HPQn9n1cNwzAGtmiHYthIO9ArkoO2jxPQsMIZjdVUfQquRDHB6LVNoGvS6l5YfDiZCqx/Wxd+a/V80X7mGN+4Qn72OXG5lZ3PO1E5GxVLblkUlYO8baevls7E3VWgg+95QSqsZt3HaRQAPE1VzOs4JDAI1Fto4cALKaIpv0Yn6CDD8dl8Yh/23XVFQCyXiAaVmhsnFvhPnIbiLHpkhvnF18oFXS4ySzbPomIfG4ButYWTm7HOkmiWUF06WUZqwxvb2orAy5CiXaTCcqHzge1oAcuGAkNm3Pga39pDSCjeBnIFxUxHCW7bqMIJGfA05p6IlnfQS582oxdO2Di0goW3ddji7dylgTBYEsnv24Gh1HsAyrXi+BdIpkJ0GBDy63EDcfdrb0o0/VjXXrWo5hGYqqZv3OgWIhVpxPq3CNeekK+E+V8xCkdiDgE8E5RkI+Nt8NQ4MVQEqKUmaWxGE+NeC2gYGehE73+1c5YLJXQfijnXqKE7aId5CBe9mU5ffiQFm7ykkOJcLz1wOn4GW6erm0gYiNlfIFC2nKSge4/8kBxf9ddy0fc7WyFPm7N1cIUG1lhMDLWICufLvU/B+PCBeklXtx/CA0J8+SsZmlYKxvbdL8Gap+7HK5+HnALUh1PfbAtQh5iN9CPCB5/g5pVvfCMRUW+Jz01FUKkaBbCa0xkrwx9vQAP6JdogkoEAh+1VcrJ1KqrA2l9vhSAv4t/EKv7MwWCA92EiUoDeW409ItGc4nQnAMFF15uB/s4KjG4PSdXoQ74FZlmbUmKRG0Fd7CB7NREdUB39D7L57kmLn+Vo/B+FhyyCT7bTgavK72EWT4qYd2aC72
 t+D9eT+6
 9MBq5V+5cONfJBK8X50OQj8oWhSIGmMlkkDiAj2XZLDgQo12FX6svk9wVOYO9UnJ2/cwZ1+lHhQ26ojqCEwUw2tmyCwNujIclJjG8bVrsxV9FgWn4bEXWmlrg0rjjDwMQKOJcpWOKcX4znMJ6qaXydnTSMeKn0m4bF4Phb5VUkZ2O/QmVY1Bn4DXzagkJEcW0EYJSMUv6aWDVRdQvNxeL7LKdAg4uG1zIdL/hGTxnR7Bm0PEBBTSd5F7eXBfVfO8YWY5pbmPV67uYctHS5JvvG2laW8z10GW+ZULdOidCyQHv4kAGhyZGmNY0PwzYlxHKK+mrG4lefEBk5ZQr+JJRO9Pot6sUUIYIir6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() reports how many pages the returned page covers with a
page_mask: a bitmask of the enclosing naturally-aligned huge page. Callers
turn that into a stride, which assumes the run is a power-of-two block
aligned to its own size.

That form cannot describe an arbitrary contiguous run, which a later patch
needs to batch PTE-mapped large folios.

Replace the page_mask output with nr_pages, the number of contiguous pages
the returned page covers starting at @address, and add an @end argument
bounding how far the walk looks, so a small request does not scan an entire
large folio.

The huge PMD and PUD paths report the same stride as before, now as a count
clamped to @end. __get_user_pages() uses the count directly.

No functional change intended.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 94 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 42 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 99902c15703b..3437cd3407d5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -647,8 +647,9 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 }
 
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pud_t *pudp, int flags,
+				    unsigned long *nr_pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
@@ -672,10 +673,13 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 		return ERR_PTR(-EMLINK);
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
-	if (ret)
+	if (ret) {
 		page = ERR_PTR(ret);
-	else
-		*page_mask = HPAGE_PUD_NR - 1;
+	} else {
+		unsigned long off = (addr & ~PUD_MASK) >> PAGE_SHIFT;
+
+		*nr_pages = min(HPAGE_PUD_NR - off, (end - addr) >> PAGE_SHIFT);
+	}
 
 	return page;
 }
@@ -699,9 +703,9 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 }
 
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pmd_t *pmd, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
@@ -738,23 +742,25 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	*page_mask = HPAGE_PMD_NR - 1;
+	*nr_pages = min(HPAGE_PMD_NR - ((addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT),
+			(end - addr) >> PAGE_SHIFT);
 
 	return page;
 }
 
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pud_t *pudp, int flags,
+				    unsigned long *nr_pages)
 {
 	return NULL;
 }
 
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long addr, unsigned long end,
+				    pmd_t *pmd, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	return NULL;
 }
@@ -800,7 +806,8 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags)
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, unsigned long *nr_pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -885,6 +892,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		 */
 		folio_mark_accessed(folio);
 	}
+
 out:
 	pte_unmap_unlock(ptep, ptl);
 	return page;
@@ -896,9 +904,9 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 }
 
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long address, unsigned long end,
+				    pud_t *pudp, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
@@ -912,7 +920,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, end, pmd, flags, nr_pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -925,24 +933,24 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, end, pmd, flags, nr_pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags);
+			follow_page_pte(vma, address, end, pmd, flags, nr_pages);
 	}
-	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
+	page = follow_huge_pmd(vma, address, end, pmd, flags, nr_pages);
 	spin_unlock(ptl);
 	return page;
 }
 
 static struct page *follow_pud_mask(struct vm_area_struct *vma,
-				    unsigned long address, p4d_t *p4dp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long address, unsigned long end,
+				    p4d_t *p4dp, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
@@ -955,7 +963,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+		page = follow_huge_pud(vma, address, end, pudp, flags, nr_pages);
 		spin_unlock(ptl);
 		if (page)
 			return page;
@@ -964,13 +972,13 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
+	return follow_pmd_mask(vma, address, end, pudp, flags, nr_pages);
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,
-				    unsigned long address, pgd_t *pgdp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+				    unsigned long address, unsigned long end,
+				    pgd_t *pgdp, unsigned int flags,
+				    unsigned long *nr_pages)
 {
 	p4d_t *p4dp, p4d;
 
@@ -981,15 +989,16 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
+	return follow_pud_mask(vma, address, end, p4dp, flags, nr_pages);
 }
 
 /**
  * follow_page_mask - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
+ * @end: virtual address at which to stop batching contiguous pages
  * @flags: flags modifying lookup behaviour
- * @page_mask: a pointer to output page_mask
+ * @nr_pages: output; number of contiguous pages the caller can read
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -998,15 +1007,17 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, @page_mask is set according to the size of the page.
+ * On output, @nr_pages holds how many contiguous pages the folio that includes
+ * the returned page has mapped into this process, so the caller can advance
+ * over a large folio in one step.
  *
  * Return: the mapped (struct page *), %NULL if no mapping exists, or
  * an error pointer if there is a mapping to something not represented
  * by a page descriptor (see also vm_normal_page()).
  */
 static struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned long *page_mask)
+			      unsigned long address, unsigned long end,
+			      unsigned int flags, unsigned long *nr_pages)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1014,13 +1025,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 
 	vma_pgtable_walk_begin(vma);
 
-	*page_mask = 0;
+	*nr_pages = 1;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		page = no_page_table(vma, flags, address);
 	else
-		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
+		page = follow_p4d_mask(vma, address, end, pgd, flags, nr_pages);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1358,7 +1369,6 @@ static long __get_user_pages(struct mm_struct *mm,
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1373,7 +1383,7 @@ static long __get_user_pages(struct mm_struct *mm,
 
 	do {
 		struct page *page;
-		unsigned int page_increm;
+		unsigned long page_increm;
 
 		/* first iteration or cross vma bound */
 		if (!vma || start >= vma->vm_end) {
@@ -1400,7 +1410,7 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				page_mask = 0;
+				page_increm = 1;
 				goto next_page;
 			}
 
@@ -1423,7 +1433,8 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, gup_flags, &page_mask);
+		page = follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
+					gup_flags, &page_increm);
 		if (!page || PTR_ERR(page) == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
@@ -1456,7 +1467,6 @@ static long __get_user_pages(struct mm_struct *mm,
 			goto out;
 		}
 next_page:
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
 
-- 
2.53.0-Meta


