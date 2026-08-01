Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CD6C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20516B0092; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7EE6B0093; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3906B0095; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 747926B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBFC2160217
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:22 +0000 (UTC)
X-FDA: 85051237404.13.BAB9F70
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6970C40003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="IfOz/lDo";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bR/vAGfDb9MXggb5yxUq+nu3vsIKwtkqbsmt5GvQiXQ=;
	b=N+ivozezPoC8Ml+A0CH9892RFMO2PTwGqMH2DDLOZS0Zl26oq73CyGMbIanh0OgjxvIWee
	/btBfpjA5QnfgC0xcR7TfIiaAajGPW8I0ZBzSMUUGzuPmoDiNgFqu7ujirb/9xgnHU/Dhu
	ezlY0bTQKZWQ61khUlZ2FFx7KeC3wZ8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="IfOz/lDo";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554181;
	b=D1y7gR65fmEU79t15xaf6ifg8xd7tMpjDX0kExrLgJII5LtpYiL4MKtzOwfvaQ3NYNOM5T
	50eXckXozBB56LzFOB5vWCsII97WbPOestEVmylKzL1xqAFvyqZdsxFeWdmvfr6Eghd1lv
	bRGyRJigNaGKydf+2pz6+YHEBWQo9MU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bR/vAGfDb9MXggb5yxUq+nu3vsIKwtkqbsmt5GvQiXQ=; b=IfOz/lDosv3Cp2TErnHOwxM3rr
	MJXIlmAY8t/Wyi0IRlDqhtKjQ2I0qy6G634Rta8Eh5OTWdcdp71qF9UdG1+vPuKx62LdyoKsDfPrX
	3goVqp9/kQK4CC6RshBPCLhPt0xaM9J3++I4gYor2C7lBugQsC1JJMiG8wfqJhe2A1HNeRFvEbwP3
	t8d51n5D1bPzZJRLeDvZhVjmhqiY44uZGKzZ3C2wb46utjdlcPUVrNj0fJ4J1QqHrvH10+E4A5CZ6
	We+U123cuMHElmphHo3uYzNHXDxv0yCQdZ3OhbxkFZE70weIrwRi4aRubpXcYC6WD1BPo2ZMsHbmc
	Fbtq+45w==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq0CU-000000001Q5-3ezp;
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
Subject: [PATCH 1/5] mm/gup: convert follow_page_mask() to return a long
Date: Fri, 31 Jul 2026 23:15:36 -0400
Message-ID: <20260801031540.2742891-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260801031540.2742891-1-riel@surriel.com>
References: <20260801031540.2742891-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6970C40003
X-Rspam-User: 
X-Stat-Signature: aop1neao76nkqcdtg4fxrp7bsmbmmtf4
X-HE-Tag: 1785554181-422618
X-HE-Meta: U2FsdGVkX18KsHHg22hOl7bJ+7QxyYt/a4IdxoKl77mzLdCeGAHZ9VpuXpNxiL5bminrGouBcjwrEDOzrB3iRsL1n1lsMmnbBk3YT2FaLlXLiqoddjuIa7D3lWmgvWGKqTQZHNe6UwdAv6Qiwmx5L2jP/V1P2nDEBZEHriVYvUjY8ecnH6hgk4GH4xgMY0PqvpnUI1UozC3fccZuIdH1SC0Dnxxil2EZzjXWmHy/9/cB9r9V9pF8r2xM5RRpaxxJ2Y1mjuTb27fBjfmnZsnvznw56DnDMxEvzzzM8jpnbIT+N14if9FrZE52Pg3at1rmMr/mjmAqMcjLYgc0a2jL9d8v1GxSvjq+z++5kmlqON6f6n3t7P1ViNdaJnH11DPBaIHg17335vylsWO/FvWYZ7j25owb60+Y3Yi34ZLBfEH4l4gMz0Vk52F+hoZAKATfVv2bIH7PNI+Fl47jJzAy3BUwlXEh2t28sE+2EojcFdiUaaTJ6yjaWohnW5GD3hKleNPjyAgh8Uxu5wLIOG62uLlN7PnK6Oh4+7rA358mv9EifplF/bAJbtoQwhl0uZYv1b5MEKiiwdDhkt4MFlPIn+r5f5bCpZqydVHMW1H1VLMQB55GtRStxa6pKqooQNgUn2Jfl9dmHS1/6Fb6J2exTY2gU3KxDbhErny5Kl7tqvbpOfx06N0Z4EqCR0oRvSIS3lQRaFY2RELNMNxpm8ib2zPx5yhKyEq/HtsXNoLzl6b3YQxq2jxNxj/zKLrt0/5l+AdFTE7sDc79BNG81KAzH5wfEX/d6aUMjxrY3QTzlRtfL5r87coVSaIY2xMg2z/9nLfYarhZIoN3JIdARiYa5pLGc/1xoMURImXIY1WmUja9bP5BfAHADuc2osx5PWzc187alT+4atzQK4yFSZcesEIlsibWL1i2qojtyGbEUX6O10uTRw3NwCOB2OeHteqvyq2hHo1gEX9vNEU5PBS
 hJFx8+i7
 LlhbPotTTc8aY50fVjYpFiRDBDptDucho1lbbIILWvltkFaH0unh5i3rEtptDEOnISMGax+vcvnqn401DKLrNGW/BkUEIdiFp4dphQbkK11sHynMsP8guMtTvpl3UeS9IQQLDbiz4MTMy9TWr/a0/IxNzDcViI2E8P8v7z8f6WE5dUxs9xB+v7w8hX6CoNU3RSFoOMQx0FqHwbQHoGCFiu0mjTVt3uUjDNBNe6dmtwnmh+VG42ftZi0ENql3+UAPH/i6o9nFkKjAgdsHSi3rc1w8rGBDbk7Ovcp/kz/Havl31yJo9eCDuQi+inJlOq551mmXiYbEut+vl91VfjsVrVn7InQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() and its helpers return a struct page pointer: NULL,
ERR_PTR(), or the page found. Change the return type to long instead:
0, a negative errno, or 1 with the page stored in a new pages[0] slot.

This lets the return value carry a page count in a later change,
rather than only ever a single struct page pointer.

follow_huge_pud() and follow_huge_pmd() now store the found page and
flush its caches themselves; __get_user_pages() reads pages[i] back
to still expand a large folio's remaining subpages itself. The
vsyscall gate area, which bypasses follow_page_mask(), fills its own
slot the same way.

*page_mask and __get_user_pages()'s handling of a large folio's
remaining subpages are untouched, and mm/gup_test.c
(PIN_LONGTERM_BENCHMARK) shows no measurable difference for 4 kB,
64 kB mTHP, or 2 MB THP.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 269 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 148 insertions(+), 121 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..09c64ef2f57c 100644
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
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
@@ -646,9 +646,10 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
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
@@ -659,25 +660,31 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
 	if (!pud_present(pud))
-		return NULL;
+		return 0;
 
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
-		return NULL;
+		return 0;
 
 	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
 	page = pfn_to_page(pfn);
 
 	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
-		return ERR_PTR(-EMLINK);
+		return -EMLINK;
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
 	if (ret)
-		page = ERR_PTR(ret);
-	else
-		*page_mask = HPAGE_PUD_NR - 1;
+		return ret;
+
+	*page_mask = HPAGE_PUD_NR - 1;
+
+	if (pages) {
+		pages[0] = page;
+		flush_anon_page(vma, page, addr);
+		flush_dcache_page(page);
+	}
 
-	return page;
+	return 1;
 }
 
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
@@ -698,10 +705,10 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
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
@@ -713,24 +720,24 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
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
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
 	if (ret)
-		return ERR_PTR(ret);
+		return ret;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_TOUCH))
@@ -740,23 +747,30 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	*page_mask = HPAGE_PMD_NR - 1;
 
-	return page;
+	if (pages) {
+		pages[0] = page;
+		flush_anon_page(vma, page, addr);
+		flush_dcache_page(page);
+	}
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
 
@@ -799,15 +813,16 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
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
@@ -825,14 +840,14 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
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
 
@@ -840,14 +855,13 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 			page = pte_page(pte);
 		} else {
 			ret = follow_pfn_pte(vma, address, ptep, flags);
-			page = ERR_PTR(ret);
 			goto out;
 		}
 	}
 	folio = page_folio(page);
 
 	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
-		page = ERR_PTR(-EMLINK);
+		ret = -EMLINK;
 		goto out;
 	}
 
@@ -856,10 +870,8 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret)) {
-		page = ERR_PTR(ret);
+	if (unlikely(ret))
 		goto out;
-	}
 
 	/*
 	 * We need to make the page accessible if and only if we are going
@@ -869,8 +881,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	if (flags & FOLL_PIN) {
 		ret = arch_make_folio_accessible(folio);
 		if (ret) {
-			unpin_user_page(page);
-			page = ERR_PTR(ret);
+			gup_put_folio(folio, 1, flags);
 			goto out;
 		}
 	}
@@ -885,24 +896,31 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		 */
 		folio_mark_accessed(folio);
 	}
+
+	if (pages) {
+		pages[0] = page;
+		flush_anon_page(vma, page, address);
+		flush_dcache_page(page);
+	}
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
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+static long follow_pmd_mask(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp,
+		unsigned int flags, unsigned long *page_mask,
+		struct page **pages)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
-	struct page *page;
+	long ret;
 	struct mm_struct *mm = vma->vm_mm;
 
 	pmd = pmd_offset(pudp, address);
@@ -912,7 +930,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags);
+		return follow_page_pte(vma, address, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -925,28 +943,28 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
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
@@ -955,22 +973,22 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+		ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
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
+	return follow_pmd_mask(vma, address, pudp, flags, page_mask, pages);
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
 
@@ -981,7 +999,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
+	return follow_pud_mask(vma, address, p4dp, flags, page_mask, pages);
 }
 
 /**
@@ -990,6 +1008,9 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * @address: virtual address to look up
  * @flags: flags modifying lookup behaviour
  * @page_mask: a pointer to output page_mask
+ * @pages: array to receive the page found, refcounted per @flags, or NULL
+ *         to walk the page tables (e.g. to fault pages in) without
+ *         collecting or refcounting them
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -1000,17 +1021,17 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
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
 
@@ -1018,13 +1039,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
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
@@ -1374,6 +1395,7 @@ static long __get_user_pages(struct mm_struct *mm,
 	do {
 		struct page *page;
 		unsigned int page_increm;
+		long nr;
 
 		/* first iteration or cross vma bound */
 		if (!vma || start >= vma->vm_end) {
@@ -1400,8 +1422,15 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				page_mask = 0;
-				goto next_page;
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
@@ -1423,10 +1452,11 @@ static long __get_user_pages(struct mm_struct *mm,
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
@@ -1440,7 +1470,7 @@ static long __get_user_pages(struct mm_struct *mm,
 				goto out;
 			}
 			BUG();
-		} else if (PTR_ERR(page) == -EEXIST) {
+		} else if (nr == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
 			 * struct page. If the caller expects **pages to be
@@ -1448,53 +1478,50 @@ static long __get_user_pages(struct mm_struct *mm,
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
+		 * the refcount work for all the subpages too.
+		 *
+		 * NOTE: here the page may not be the head page
+		 * e.g. when start addr is not thp-size aligned.
+		 * try_grab_folio() should have taken care of tail
+		 * pages.
+		 */
+		if (pages && page_increm > 1) {
 			struct page *subpage;
 			unsigned int j;
+			struct folio *folio = page_folio(pages[i]);
 
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
 
-			for (j = 0; j < page_increm; j++) {
-				subpage = page + j;
+			for (j = 1; j < page_increm; j++) {
+				subpage = pages[i] + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
-- 
2.53.0-Meta


