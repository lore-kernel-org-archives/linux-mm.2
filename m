Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BD5606A684
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=WMHCDNSZ
Received: by kanga.kvack.org (Postfix)
	id 483906B05B9; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7EE6B05B8; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3006B05BC; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E95516B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 638491C4472
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:29 +0000 (UTC)
X-FDA: 85467440898.22.B5DB350
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A9921C000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="WMHCDN S";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463787;
	b=1zJ4x3ylvkG4Ntth53FF1AhwnL7NZJnONqaCAS/mJ6i1e51oHMYZARuI+pFIbPz9j6TnYv
	CnhmL1vJx3jomj0HByR1ZBQIOO99Qbxc/OdKvuju+0hqJMvo/W6tWJqsYGz8AHWDXYmT1+
	EH4Umlm4VYHHnc5ORupZzD9mf4Kz/CM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psRfc0KHheIriVsHfc4tEURoTeOTCGIfo9MPK7BM01o=;
	b=mOJNjAp1is2P/pjDkzQKXDjg4ahesDxgp8WZlFwqSTQJjhBsH79OjbCbvMnJ3ZoG7ah36B
	6Ujg3L13O7Ahr23fDX+yxPRp6Kgn/gI1DOdvHnlRkmfEVypxAnWpIXe9LFNz8Q2mO09Xtp
	Oabo8J+wwHSNwaVCLhgOFw6dXGaro9E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="WMHCDN S";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=psRfc0KHheIriVsHfc4tEURoTeOTCGIfo9MPK7BM01o=; b=WMHCDN
	SZMjBzZPPYC6sFRzkkaLym/MIvixrdAnn4T1oTUKOtKoCY2MlTJy+XODOUHzRNaoGUmN7WB/uC9sA
	BoilXj99ZhUn205mvvc0SVnkZPoGsbGB8iljRzCjbXY77KH+KZ5bBM/f7Dq7f95JZwthppQI1zg66
	fxUraWqzTG1RRRRjxBa6QyBBuIUqfMPBzjYZj9c5khQOSF+dp+SswIeqwpwjTCKH1GS9dOncuUPEF
	2K7s5X5zvz8XXMfjshWj4hz1Y13nk1L3hIlusyiLG9Dzg4XTtNhN9WDgMuFPlZoPNOFhbxi5tII9x
	3MQg61tFwwl6HNo21KJrYh2HvBgg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-1RMz;
	Mon, 23 Nov 2026 19:56:15 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 3/9] mm/gup: convert follow_page_mask() to return a long
Date: Mon, 23 Nov 2026 14:56:03 -0500
Message-ID: <20261123195609.4115244-4-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9A9921C000B
X-Stat-Signature: yj6iifkihhsexpmittdi6p1qws3bhsna
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795463787-657413
X-HE-Meta: U2FsdGVkX1+KLVdmBReYY1SaPbtuSZ0J3lX/tioJ40cZaY1V3EwKQTIEF0b9R8dkBO3pyiLOIE9kHInFxYeHn4n2G8jaYUDQOkt5FojdDYFzKN680RZrCE8CN/YHVseruR0hihwBoMZno/pdvtK92dV0TnebXYypfx5G03NNRRCUbqTkc7gQuSkgbi0O01IA0VhCEpC/nteDb3xKfx0dW6y1PBdrlXsGCnBmHTKKAq66jEAqu1dDzyH6FNXsqZR4Rz7pQzA+VaEBmy+NIUNR/chk6ak7r6WFA8QteFDZM52qOFfyX6HDWpuxTZL+U+sqjMO/s5vk7S7yBdr2TcnHf6J31XIxrsSW7ZHL1TM+KAvxCyeC+p4ydbHxv2cBuKDG0C6rGV7ujBChyqSeiOvrMqwhDDMrXX2keyeaUaOZ7zdtnhkzJNAqXf9lQ/R7IYZ3F+A8Uv8iab/53cWQC0IJhKH7mmNWCwZcYGLDO1/Vp8E65++vmhS4R6kufjzyEmodbpvKw8eIs22zFj6+LvF1hmHzOFwMHUA9u9+BJgDLX15MY0j3eSmjVKlL1if/Y0AfcXWTz/Wrb5Q6uG1ToK3AfoXDPZPaM2y8E93j3IojU2lUOVOontXm7jUzhhP8opcxxAt5CGwr+uxpOq0x1uGV1pxfHRE7xv5NxLm2YF2PGr9NhmEAIjKYgLC3xm7rXgk6cIFDgMem2aIabOpQTtEFp6vHk3P9FLTazREB4T1YH9V0/GBo+Piwqby1qe5PGp+N9tzZo/viPOD+RJ/IGOBCUgSiNpK3SNwneYgR5sRngudqtNm9xRSqCZoXOXpQdLY9xDRiRhSbmbCCnh1puHbDN4HlToNbMIep+DJD5OTLUzaxzji0OfXaRDASTA+RsknJvg8Vliu2SmNHyCVlOMM6GvP4aAt0oqHFp/K+9H+Wg6OxipeNk0Z+vGmrM2LQIa53vBfufS1n1doh4PZzRAS
 ZuDP8uTJ
 qHol6+em6CGG347d+O8KSu7U1tdm7pVThMR7zyBhnXF2dSqfnnIMC+JHFKeF71kZNGco00IgtBJuyTJIp9Tyj5O9kZpa2885hhgNu7Gsw5/8c+jSwP3J7d4+ZAo8V2YNHlzzdDhY2+kc1f62qzkQXTtb4B1llkzw1FW1Gp9BAVzVgxvbAtJAEC9aXUgzzo4eD7AbtB+OjIu4uRztKrxEUKtKkOMvwh4Mos57lPqiDM6BzoZ1X4VHVb0VczVxeHYtf0yh/MNcxjnxAUfPUCk5bm5qmzkMeva0/1daZoVDDQcmloZar53ybupOCiaD+kybn4p/wj67i6qvObGYh9WHzUR5fNw462hshAiW+GMZy5V4pbL0McANgGB316LnB1ZrQ5fePei++Hqm7/9YkXR5+PH3yZPRD3oaLQWvafYpqC46ebx8gMQvROkLUsAhrYRZGpbclQEn/lN2iFPlZNh2p03ooGaPvDjHwooZdPi2fOGaVvvY+GrcIvIMIZm6Lbvxq33Dmc/EF3021Y4raPeiFtcdDs0icTEf6pGialULYfIqDoX30/Jo77ye3QqZUmGLDmuuTGmpgiS+lbuOoyzlLnWA5JzmaTCDIyFgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_mask() and its helpers return a struct page pointer: NULL,
ERR_PTR(), or the page found. Change the return type to long instead:
0, a negative errno, or 1 with the page stored in a new pages[0] slot.

This lets the return type carry a page count rather than a single
struct page pointer.

follow_huge_pud(), follow_huge_pmd() and follow_page_pte() now store
the found page in a pages[0] slot. __get_user_pages() reads that page
back from pages[i], fills the rest of a large folio's run itself, and
flushes the whole run's caches with gup_flush_pages(). The follow path
itself never flushes: the caches are always flushed from
__get_user_pages(), without any page table lock held.

The vsyscall gate area bypasses follow_page_mask() and fills and flushes
its own slot the same way. The gate handles a single page, so it
initializes the count to 1.

*page_mask and __get_user_pages()'s handling of a large folio's
remaining subpages are untouched, and mm/gup_test.c
(PIN_LONGTERM_BENCHMARK) shows no measurable difference for 4 kB,
64 kB mTHP, or 2 MB THP.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 258 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 141 insertions(+), 117 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d35fedbce7e1..963c09b955d9 100644
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
@@ -625,12 +625,12 @@ static struct page *no_page_table(struct vm_area_struct *vma,
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
 }
 
 static unsigned long gup_pages_not_requiring_unshare(
@@ -760,9 +760,10 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 	return can_follow_write_common(page, vma, flags);
 }
 
-static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+static long follow_huge_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp,
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
@@ -775,22 +776,24 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
-		return NULL;
+		return 0;
 
 	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
 	page = pfn_to_page(pfn);
 	folio = page_folio(page);
 
 	if (!pud_write(pud) && gup_must_unshare(vma, flags, folio, page))
-		return ERR_PTR(-EMLINK);
+		return -EMLINK;
 
 	ret = try_grab_folio(folio, 1, flags);
 	if (ret)
-		page = ERR_PTR(ret);
-	else
-		*page_mask = HPAGE_PUD_NR - 1;
+		return ret;
+
+	*page_mask = HPAGE_PUD_NR - 1;
+
+	gup_fill_pages(pages, page, 1);
 
-	return page;
+	return 1;
 }
 
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
@@ -811,10 +814,10 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 	return !userfaultfd_huge_pmd_wp(vma, pmd);
 }
 
-static struct page *follow_huge_pmd(struct vm_area_struct *vma,
-				    unsigned long addr, pmd_t *pmd,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_huge_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd,
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
@@ -829,24 +832,24 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 
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
 
 	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, folio, page))
-		return ERR_PTR(-EMLINK);
+		return -EMLINK;
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
 	ret = try_grab_folio(folio, 1, flags);
 	if (ret)
-		return ERR_PTR(ret);
+		return ret;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_TOUCH))
@@ -856,23 +859,26 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	*page_mask = HPAGE_PMD_NR - 1;
 
-	return page;
+	gup_fill_pages(pages, page, 1);
+
+	return 1;
 }
 
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
-static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+static long follow_huge_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp,
+		unsigned int flags, unsigned long *page_mask,
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
+		unsigned long addr, pmd_t *pmd,
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
-	return NULL;
+	return 0;
 }
 #endif	/* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 
@@ -915,15 +921,16 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
-static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags)
+static long follow_page_pte(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd, unsigned int flags,
+		struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
-	int ret;
+	long ret;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
@@ -941,14 +948,14 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	 */
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pte(pte, page, vma, flags)) {
-		page = NULL;
+		ret = 0;
 		goto out;
 	}
 
 	if (unlikely(!page)) {
 		if (flags & FOLL_DUMP) {
 			/* Avoid special (like zero) pages in core dumps */
-			page = ERR_PTR(-EFAULT);
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -956,14 +963,13 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 			page = pte_page(pte);
 		} else {
 			ret = follow_pfn_pte(vma, address, ptep, flags);
-			page = ERR_PTR(ret);
 			goto out;
 		}
 	}
 	folio = page_folio(page);
 
 	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
-		page = ERR_PTR(-EMLINK);
+		ret = -EMLINK;
 		goto out;
 	}
 
@@ -972,10 +978,8 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret)) {
-		page = ERR_PTR(ret);
+	if (unlikely(ret))
 		goto out;
-	}
 
 	/*
 	 * We need to make the page accessible if and only if we are going
@@ -985,8 +989,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	if (flags & FOLL_PIN) {
 		ret = arch_make_folio_accessible(folio);
 		if (ret) {
-			unpin_user_page(page);
-			page = ERR_PTR(ret);
+			gup_put_folio(folio, 1, flags);
 			goto out;
 		}
 	}
@@ -1001,23 +1004,27 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		 */
 		folio_mark_accessed(folio);
 	}
+
+	gup_fill_pages(pages, page, 1);
+	ret = 1;
 out:
 	pte_unmap_unlock(ptep, ptl);
-	return page;
+	return ret;
 no_page:
 	pte_unmap_unlock(ptep, ptl);
 	if (!pte_none(pte))
-		return NULL;
+		return 0;
 	return no_page_table(vma, flags, address);
 }
 
-static struct page *follow_pmd_mask(struct vm_area_struct *vma,
+static long follow_pmd_mask(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud,
-		unsigned int flags, unsigned long *page_mask)
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
-	struct page *page;
+	long ret;
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (unlikely(pud_bad(pud)))
@@ -1030,7 +1037,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -1043,28 +1050,28 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, pmd, flags, pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
-		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags);
+		return pte_alloc(mm, pmd) ? -ENOMEM :
+			follow_page_pte(vma, address, pmd, flags, pages);
 	}
-	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
+	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
 	spin_unlock(ptl);
-	return page;
+	return ret;
 }
 
-static struct page *follow_pud_mask(struct vm_area_struct *vma,
-				    unsigned long address, p4d_t *p4dp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_pud_mask(struct vm_area_struct *vma,
+		unsigned long address, p4d_t *p4dp,
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
-	struct page *page;
+	long ret;
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
@@ -1072,7 +1079,8 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (!pud_leaf(pud))
-		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask,
+				       pages);
 
 	ptl = pud_lock(mm, pudp);
 	pud = *pudp;
@@ -1082,18 +1090,19 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pud_leaf(pud))) {
 		spin_unlock(ptl);
-		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask,
+				       pages);
 	}
 
-	page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
 	spin_unlock(ptl);
-	return page;
+	return ret;
 }
 
-static struct page *follow_p4d_mask(struct vm_area_struct *vma,
-				    unsigned long address, pgd_t *pgdp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_p4d_mask(struct vm_area_struct *vma,
+		unsigned long address, pgd_t *pgdp,
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
 	p4d_t *p4dp, p4d;
 
@@ -1104,7 +1113,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
+	return follow_pud_mask(vma, address, p4dp, flags, page_mask, pages);
 }
 
 /**
@@ -1113,6 +1122,9 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * @address: virtual address to look up
  * @flags: flags modifying lookup behaviour
  * @page_mask: a pointer to output page_mask
+ * @pages: array to receive the page found, refcounted per @flags, or NULL
+ *         to walk the page tables (e.g. to fault pages in) without
+ *         collecting or refcounting them
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -1123,17 +1135,17 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  *
  * On output, @page_mask is set according to the size of the page.
  *
- * Return: the mapped (struct page *), %NULL if no mapping exists, or
- * an error pointer if there is a mapping to something not represented
- * by a page descriptor (see also vm_normal_page()).
+ * Return: 1 with @pages[0] filled in if a page was found, 0 if no mapping
+ * exists at @address, or a negative errno for a mapping to something not
+ * represented by a page descriptor (see also vm_normal_page()).
  */
-static struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned long *page_mask)
+static long follow_page_mask(struct vm_area_struct *vma,
+		unsigned long address, unsigned int flags,
+		unsigned long *page_mask, struct page **pages)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
-	struct page *page;
+	long ret;
 
 	vma_pgtable_walk_begin(vma);
 
@@ -1141,13 +1153,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		page = no_page_table(vma, flags, address);
+		ret = no_page_table(vma, flags, address);
 	else
-		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
+		ret = follow_p4d_mask(vma, address, pgd, flags, page_mask, pages);
 
 	vma_pgtable_walk_end(vma);
 
-	return page;
+	return ret;
 }
 
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
@@ -1497,6 +1509,7 @@ static long __get_user_pages(struct mm_struct *mm,
 	do {
 		struct page *page;
 		unsigned int page_increm;
+		long nr;
 
 		/* first iteration or cross vma bound */
 		if (!vma || start >= vma->vm_end) {
@@ -1523,8 +1536,11 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				page_mask = 0;
-				goto next_page;
+				if (pages)
+					pages[i] = page;
+				nr = 1;
+				page_increm = 1;
+				goto fill_flush;
 			}
 
 			if (!vma) {
@@ -1546,10 +1562,11 @@ static long __get_user_pages(struct mm_struct *mm,
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, gup_flags, &page_mask);
-		if (!page || PTR_ERR(page) == -EMLINK) {
+		nr = follow_page_mask(vma, start, gup_flags, &page_mask,
+				      pages ? &pages[i] : NULL);
+		if (!nr || nr == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
-					   PTR_ERR(page) == -EMLINK, locked);
+					   nr == -EMLINK, locked);
 			switch (ret) {
 			case 0:
 				goto retry;
@@ -1563,7 +1580,7 @@ static long __get_user_pages(struct mm_struct *mm,
 				goto out;
 			}
 			BUG();
-		} else if (PTR_ERR(page) == -EEXIST) {
+		} else if (nr == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
 			 * struct page. If the caller expects **pages to be
@@ -1571,49 +1588,56 @@ static long __get_user_pages(struct mm_struct *mm,
 			 * for this page.
 			 */
 			if (pages) {
-				ret = PTR_ERR(page);
+				ret = nr;
 				goto out;
 			}
-		} else if (IS_ERR(page)) {
-			ret = PTR_ERR(page);
+		} else if (nr < 0) {
+			ret = nr;
 			goto out;
 		}
-next_page:
+
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
 
-		if (pages) {
+		/*
+		 * This must be a large folio (and doesn't need to
+		 * be the whole folio; it can be part of it), do
+		 * the refcount work for the remaining pages.
+		 *
+		 * NOTE: here the page may not be the head page
+		 * e.g. when start addr is not thp-size aligned.
+		 * try_grab_folio() should have taken care of tail
+		 * pages.
+		 */
+		if (pages && page_increm > 1) {
+			struct folio *folio = page_folio(pages[i]);
+
 			/*
-			 * This must be a large folio (and doesn't need to
-			 * be the whole folio; it can be part of it), do
-			 * the refcount work for all the subpages too.
-			 *
-			 * NOTE: here the page may not be the head page
-			 * e.g. when start addr is not thp-size aligned.
-			 * try_grab_folio() should have taken care of tail
-			 * pages.
+			 * Since we already hold refcount on the
+			 * large folio, this should never fail.
 			 */
-			if (page_increm > 1) {
-				struct folio *folio = page_folio(page);
-
+			if (try_grab_folio(folio, page_increm - 1,
+					   gup_flags)) {
 				/*
-				 * Since we already hold refcount on the
-				 * large folio, this should never fail.
+				 * Release the 1st page ref if the
+				 * folio is problematic, fail hard.
 				 */
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
+				gup_put_folio(folio, 1, gup_flags);
+				ret = -EFAULT;
+				goto out;
 			}
 
-			gup_fill_pages(pages + i, page, page_increm);
+		}
+
+	fill_flush:
+		/*
+		 * The first page is already stored and references on the
+		 * whole run are held; fill the rest of the array and flush
+		 * the caches without any page table lock held.
+		 */
+		if (pages) {
+			gup_fill_pages(pages + i, pages[i], page_increm);
 			gup_flush_pages(vma, start, pages + i, page_increm);
 		}
 
-- 
2.56.0


