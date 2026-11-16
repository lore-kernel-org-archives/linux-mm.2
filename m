Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080DA606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=g1k3FSTj
Received: by kanga.kvack.org (Postfix)
	id 7AA346B00EF; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734206B05B2; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB3B6B05B3; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 259606B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 971E61A01BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:45 +0000 (UTC)
X-FDA: 85442203770.30.8C9C321
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id E8A551A0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="g1k3FS T";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPiLt6pr6PQBreqVN9qRWncE3ugZDHyAdeWrb3ccFRU=;
	b=Z1UTxS9jsXbSHqajyVZtIgmxcpoGDcF7MS0tOpo5UoZlrdP5dFb2+zoI5BSdL/iIURgn5H
	BoHPdX6mpxlHe7V/1oAyrGIorX3uy/V92tA1HfC03PbP6Tnqd3CSay08LkZRVXExGJ7uO4
	dQSJXyEZ0IVIj9uUSa7ljV378QVYkgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862904;
	b=udDNrnYub+L7lgdsDDq9TWiaPhiwGVKeBrmdC2HsfHNgOFpZVhJQyRpDHfoLWhJEONG7lW
	ImdrJEndEg7+T39gCaTd45O+TMDiowilP9Mk++X8XYGt7J7VjBVCZMXMfikJtoFcvVXXsn
	nosBZQiIj7EmwEZn3FIaY6/yuIjoRa4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="g1k3FS T";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=kPiLt6pr6PQBreqVN9qRWncE3ugZDHyAdeWrb3ccFRU=; b=g1k3FS
	TjQVdyWa45xZL4yQkUChTODtP3w6cvaKJJsThr905rKxG8UR3qqeHxEEfcHXsRCVMHhP4+K3RkDeq
	1PvmT/0H1OkJDX71o8hBFg2hIydmAgPJkiX4aZdTrll7dqjDBnP5Jb972sjcKv41b3zusbmzkLEqD
	Yk6jrSqwOvzJSbTEcH0e+09pm78fNfCjYnAX3Kllhpx+wJBqs+Rd399tQ8EfpIa0yN85lk+tw90Rf
	oVLnWL4Ak/8QCwcf3NqxBU5MbLKjHMry8LQlrO62qmhWFKsC/EypR/CGmFibz80PF4noV7FIzJjzl
	NjNzagQWVW+p//HUPTHnNfg5gffA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-200P;
	Mon, 16 Nov 2026 21:01:30 +0000
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
Subject: [PATCH v5 3/8] mm/gup: convert follow_page_mask() to return a long
Date: Mon, 16 Nov 2026 16:01:22 -0500
Message-ID: <20261116210127.3837898-4-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E8A551A0006
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fkn1ac6rqx3aaqa5g41xju46mf9d4ey5
X-Rspam-User: 
X-HE-Tag: 1794862903-866766
X-HE-Meta: U2FsdGVkX19RkM5sMNvTrDeYx8D10CGFrCyYGWQANim8BXA8C+z8R6lMe5lpCNWXYcvjsAGMzoMUic4ygR1Vk2YGZ6E0J2JbtVa4vTLGLorSrMbeRbb6tqeYoUxLYXETyK6g04y+pbf1ekrPb07WiRg6TB6oXLZLDZpBpP1x//Hb3YozbpGQ1w975t/quCZxFfnQzyDtLGqILyRqUnHO8/CpttJvplNapGbScf4Xd8QKzCWZEYD94jhy9ZdwdxLFrxovPgODE7hQwT0/LDcdFj5FoIRwuY7CX6MveyAs+azJWJTLoo7NrG7XOl6nENmJny3/0RoXP6al3ebJdUN/vOhPCoGKGK+8uqTJqzgAJyxaX2TOrUsauTPsZGt4Bx0EXDTjgiDgRWj/wYYJ4R9dfr695M0RxAKWJCX/MGdsGC2JlAMbQH4QOYJrAOnrx96U1kzPSPomgn2klRcO+5LsVRBy9KZdU9wq5m7dV8tNjsIwBde8nZ4l4k9rEkkOTZhJw6Y7dJbaXDBELQ6AXL6vlzTXFQ75mguHS836PB4DJGR3Wv557nqLjgyXXFVI0MrnyOMtoPwGx4uuJkFvxw7dSiCwkNorvq+siQOUoxdZLeU3oGortTLiH11XYoux9LQ+UFVXIxOOUd672Y7YuMc3idHTiKOaZ8DnXQU+aCxZ6EICgJueIIJGXsPc+f5FPoSvCV76gMOUcKEOAYqi9FF1r9NTsz6yu3YvXGXe5Sf9aTUsEYGHhaRJTFH2CJWFHkt/i294JhdUdG2yabkrz8x8luHKzbGY8a0lpgdfPeLdImOPlJYvLOJCctOCrtEuaLKSZ+NIhP3OLMqTZsddH3QocO4+ZLeuNDQcVND9yHF5aXMTBou91I3okWRd3p437YCntciVf1VtgLF8l0tTsU6XeVx9rxDP5jqIBHApHn/uRtTbYy7obzSptg5LoAqp0G4iZD+TUupgHoMb/1Ywuo2
 di6FIYSe
 jpjh1/sIlBt+x+1qwf0iA7mgycfmlQ9yCqzquFOffXaJw6ywQkXFpacGLaI16PxwAa4iCj/5h6fnxRfNDNhY0NbnP8Awe82xlxb1yJKCGtQ5u6aFmQ/UT4op49G8lpRvpuk2LWVW+Xa1oiNtEad1j/aJuOL8zQKdmo+MNBrh7vp1yiDC0hFlSmBOcfDSgW5oyLFde/YDAI7UbRNMZEVVzsxMmhqm87RF1dx2fNyyxuamlutFp9PNTimx33ANtZ55nE1RFh7aD/U0QRNXw1GHICZK87CCgRcobO504eoL3qyVlvzPuZwtQpDlyTWvydyr/kFAt1r/SHTzU1vDcgjzfiq28da8YEtUbe7Xmx/SSoRTQS4o4f54+Spr0V+d3hema01Vhyt+2WdGSVCo=
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
its own slot the same way.

*page_mask and __get_user_pages()'s handling of a large folio's
remaining subpages are untouched, and mm/gup_test.c
(PIN_LONGTERM_BENCHMARK) shows no measurable difference for 4 kB,
64 kB mTHP, or 2 MB THP.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 257 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 140 insertions(+), 117 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d35fedbce7e1..c59d436be7ad 100644
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
@@ -1523,8 +1536,10 @@ static long __get_user_pages(struct mm_struct *mm,
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				page_mask = 0;
-				goto next_page;
+				if (pages)
+					pages[i] = page;
+				nr = 1;
+				goto fill_flush;
 			}
 
 			if (!vma) {
@@ -1546,10 +1561,11 @@ static long __get_user_pages(struct mm_struct *mm,
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
@@ -1563,7 +1579,7 @@ static long __get_user_pages(struct mm_struct *mm,
 				goto out;
 			}
 			BUG();
-		} else if (PTR_ERR(page) == -EEXIST) {
+		} else if (nr == -EEXIST) {
 			/*
 			 * Proper page table entry exists, but no corresponding
 			 * struct page. If the caller expects **pages to be
@@ -1571,49 +1587,56 @@ static long __get_user_pages(struct mm_struct *mm,
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


