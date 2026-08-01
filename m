Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631CFC55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E5B6B0093; Fri, 31 Jul 2026 23:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB3D6B0095; Fri, 31 Jul 2026 23:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840176B0096; Fri, 31 Jul 2026 23:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0586B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:16:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEFF3801EC
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:22 +0000 (UTC)
X-FDA: 85051237404.10.41B7BEB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4A78C4000C
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HZgRLPVW;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayUmkBGSzdWGbdkSooD5p8ZAVjeLT0Ckq7fwnbKZLFE=;
	b=vFEFX3M/SFQLHxKNNjgYyH1E7tXO1DBKilq4LEL9CkaCboFImASK60f5tzex03op80YwzU
	lBpUwjUXAfjK7egiaFLAaSQrF6a0yoXlQDIre609vfN7KJfXawGi/R6+spKvGwZSDLEd0W
	qClSZor+q8lMnHVigyvVlVpm7ocnUL8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554181;
	b=KKs3qGlOOsLISKKOLvA/JlvBqGKSyxnweyCAM7OF4uv4eEOD9Rxvr686qSo3lfGjeAv7Vr
	v+EepsYCqzVNGFZbOh23Cv5f9JXGk7FQiGEbVrkywrOlDMzeqwejIHNYHdb+dm2Gbu5WcD
	O+mVCvhTpGh5BA4CDWQDak7O37NMgGU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=HZgRLPVW;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ayUmkBGSzdWGbdkSooD5p8ZAVjeLT0Ckq7fwnbKZLFE=; b=HZgRLPVW8/Xv7+jUG3Qa3KUd/P
	160h1qW84hR7wqom/V4sMQvCeaq6wn0S6JHgYFl8MwvE7GrksU504ebaqYaJBk5bTcSlXk/eIVSMr
	ofpO5qVP6gFek/Vb1kflwtYNLegf59qda/P893dblvXE3jReBDBDfaBI8wAifRYs23WvzUBO5cz+g
	GWp/xBubzqS17+MGWS4pVMqi5ezT+57SqsaXjwTaYTF2rlgPaFuw7641YlQUm6OhAlCcNH99g461r
	Qd4pBJXoj5KXgSrmbI6XRexvNKjPoRSQiUkEtAg5yhd1SNf2OkNqj6eYVNX+Oq6OmdtiafnKwrQ/u
	tANJ8wyA==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq0CU-000000001Q5-43PR;
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
Subject: [PATCH 5/5] mm/gup: walk multiple PTEs per follow_page_pte() call
Date: Fri, 31 Jul 2026 23:15:40 -0400
Message-ID: <20260801031540.2742891-6-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260801031540.2742891-1-riel@surriel.com>
References: <20260801031540.2742891-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A78C4000C
X-Stat-Signature: qzur8nwkhm35e68n3nyr1fzo3t6yz14i
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785554180-800669
X-HE-Meta: U2FsdGVkX18r5mzbfqxYXp9p213i76WJqemuViOm1YazTBvA3pk3BKC7doSyeD6j5ygDH6EL4T99b51CE0lLwPWQ1S36NUOtmO3oyFydEgMi31dgazG3o1ksjWIgCLdzfUayNvQYiAP1wU8dvjn9LukEup/Jg895pjPCNlpE/FhevNETUNJI3W6V70yQxe86yyQOadqEaZk+uuO6/jsYzF66a2XI72qfzhwL9pcSMevZrT+Ye6/dWrMExxL1NPyyQgeI9z56mJIyGkfOfVgR8+/DnOxIatUSgeSY3mHEKe/Hdd2UzPGyqzWuvvkZRfi1yukGnzwAL645Yfl0C3TrF+iXBjcn99kpUQbxeBXDSIXn6zfxRfo4hNnmxSZq9f3x4yMB3gq+mIW7WUNCuhrv14EZ/6UQfe6LNSodZdhaYxK1FahB94LOCjiAs3tzEldbKmuXCQe59WtHza606LpmoZyy9KMGwEkInE66c/gUFMw1uMCBF5NlSNlUP1pIpKBBc+//Gald5xaLkC/3IybiNbCCSx2fZBbosXRIrYEgH/vBRi+6At7FzDKQZIpQdEj7WaJCYUSVMJ+wCQRBghxjgo0P33UbocLSDnXRaPL8sEDs0CF3oURdcFcKxDDneU5PLw+FMoJT9opio75q73HqVqEksOfxbueAfu8E2COgcCuAIq+ycYwE1eIoavQNdqVezu5xDCmZ/WkGy9DY7lUF9HXuePtG0IZM5VLcj5L8HklklaPcj++2/yPWiPU+RYH0L3KDhAFlQEjOEnNIyLm1FuiyLVXSjCyONNAPcrUItifyYizG1g0/AAIp1hqS18vdb2FImC8LRdHlJHZ50O389i/8aeHnhYBXQEEj+Ng46WMTPw51N9/wOLPQmV/RTMuS9l0gtowFSD5j7cnGBEc1dGjITxPygEOYgdP33pAVejFkM7DCpeERkAhMXyug9pc1YkOa1zB6dC2vFfHsSH/
 8rX7S8rQ
 VjGDkDQJnMrOwdC088oqp+I7XUW04I69YE+D7yWE7CeAM5HpK8GhyBRV+mdZeg4J4bc6GcT5Rnu9hurCZvYioGQnlIaqystE1ts5RPDqgrPrS8RCR3cu8YL5GMczpiLG7JhXN+AjZLirNVB069iGqFnlSwWMZGxoHG4dMWM3XkXUTWA6XCrRcUy8KP+Gehgg0a4kzfUN6f0lK6aF29vhn+thbNrZHaQsuhujbmJlpHxZfcg6ENaMtHPHro4YF1vTAIWC6QQA4QTFChsJWMESGSztY+68D4UEM1vq6ZNiKg96bkiwe+mhAYdq/kj7j0z+vPrqtDIGCt2QXz/RAfodH1XELeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_pte() still looks at one PTE per call, so
__get_user_pages() calls it once per page even for a PTE-mapped large
folio (mTHP), restarting the pgd/p4d/pud/pmd descent and retaking the
PTE lock each time.

Walk every PTE from @address to the page-table/VMA/@end boundary in
one call instead, without stopping at folio boundaries -- adjacent
pages from different folios, or plain base pages with no folio
relationship at all, are covered by the same call under one lock.

Within that walk, contiguous same-folio pages still get one combined
refcount grab: each run starts with a full per-PTE resolve, then
follow_pte_batch() finds how many more PTEs extend it via a cheap
comparison scan, not a re-derivation of each page.

Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK) on a 256 MB
MADV_HUGEPAGE region in a 4 CPU VM, median get time over 16
iterations, before/after back to back in the same VM. Each folio size
was confirmed through the per-size anon_fault_alloc counters (4096
folios for 64 kB, 128 for 2 MB):

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  64 kB mTHP            3000 us      207 us   (14.5x)
  2 MB THP (control)      70 us       69 us
  4 kB base (control)   2801 us     1188 us   (2.4x)

The 4 kB case shares no folio, so gets no refcount-batching benefit --
yet it still improves 2.4x purely from walking the page table once
instead of restarting per page. The 64 kB run gets that saving plus
refcount batching on top, reaching 14.5x. The 2 MB THP case doesn't
reach follow_page_pte() at all, so it stays flat.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 209 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 145 insertions(+), 64 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ccbef9476ff6..55bbeaa52b13 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -827,18 +827,20 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 
 /*
  * The caller has already run every per-PTE safety check (present,
- * write-fault, gup_must_unshare()) on the PTE, so this only does the
- * per-folio work: the refcount grab, the FOLL_PIN accessibility fault-in,
- * dirty/accessed marking, and the array fill with the cache flush.
+ * write-fault, gup_must_unshare()) on each PTE in the run, so this only
+ * does the per-folio work: the refcount grab, the FOLL_PIN accessibility
+ * fault-in, dirty/accessed marking, and the array fill with per-subpage
+ * cache flushes.
  */
 static long follow_page_pte_commit(struct vm_area_struct *vma,
-		unsigned long address, struct folio *folio, struct page *page,
-		pte_t pte, unsigned int flags, struct page **pages)
+		unsigned long run_address, struct folio *folio,
+		struct page *run_page, pte_t run_pte, unsigned long run_len,
+		unsigned int flags, struct page **pages)
 {
 	long ret;
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
+	ret = try_grab_folio(folio, run_len, flags);
 	if (unlikely(ret))
 		return ret;
 
@@ -850,13 +852,13 @@ static long follow_page_pte_commit(struct vm_area_struct *vma,
 	if (flags & FOLL_PIN) {
 		ret = arch_make_folio_accessible(folio);
 		if (ret) {
-			gup_put_folio(folio, 1, flags);
+			gup_put_folio(folio, run_len, flags);
 			return ret;
 		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !folio_test_dirty(folio))
+		    !pte_dirty(run_pte) && !folio_test_dirty(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * pte_mkyoung() would be more correct here, but atomic care
@@ -866,79 +868,158 @@ static long follow_page_pte_commit(struct vm_area_struct *vma,
 		folio_mark_accessed(folio);
 	}
 
-	gup_fill_pages(vma, address, page, 1, pages);
+	gup_fill_pages(vma, run_address, run_page, run_len, pages);
 
 	return 0;
 }
 
+/*
+ * Return how many PTEs from @ptep can batch with @pte's page:
+ * consecutive present, uniform-write PTEs of @folio, bounded by
+ * @walk_end. Returns at least 1. A cheap pte_same() scan, so a
+ * large folio's run costs one scan.
+ *
+ * gup_must_unshare()/write-fault checks are per PTE, but a writable
+ * run is always safe: a writable anon page is exclusive. A read-only
+ * run under FOLL_WRITE/FOLL_PIN needs a per-page check instead, so
+ * it falls back to one page at a time.
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
+}
+
+/*
+ * Walk every PTE from @address to @end (this page table and VMA).
+ *
+ * If the first PTE can't be included (not present, a write/unshare
+ * fault, PFN-special, ...), that reason is returned directly.
+ * A failure in a subsequent page results in a short read;
+ * __get_user_pages retrying the read will get the error.
+ */
 static long follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct page **pages)
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct folio *folio;
-	struct page *page;
 	spinlock_t *ptl;
-	pte_t *ptep, pte;
-	long ret;
+	pte_t *ptep, *orig_ptep;
+	unsigned long walk_end;
+	unsigned long nr = 0;
+	bool need_no_page_table = false;
+	long ret = 0;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	orig_ptep = ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		return no_page_table(vma, flags, address);
-	pte = ptep_get(ptep);
-	if (!pte_present(pte))
-		goto no_page;
-	if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
-		goto no_page;
 
-	page = vm_normal_page(vma, address, pte);
+	walk_end = min(pmd_addr_end(address, end), vma->vm_end);
 
-	/*
-	 * We only care about anon pages in can_follow_write_pte().
-	 */
-	if ((flags & FOLL_WRITE) &&
-	    !can_follow_write_pte(pte, page, vma, flags)) {
-		ret = 0;
-		goto out;
-	}
+	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+		struct page *page;
+		struct folio *folio;
+		unsigned long batch;
 
-	if (unlikely(!page)) {
-		if (flags & FOLL_DUMP) {
-			/* Avoid special (like zero) pages in core dumps */
-			ret = -EFAULT;
-			goto out;
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
 		}
 
-		if (is_zero_pfn(pte_pfn(pte))) {
-			page = pte_page(pte);
-		} else {
-			ret = follow_pfn_pte(vma, address, ptep, flags);
-			goto out;
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
 		}
-	}
-	folio = page_folio(page);
 
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
-		ret = -EMLINK;
-		goto out;
-	}
+		if (unlikely(!page)) {
+			if (flags & FOLL_DUMP) {
+				/* Avoid special (like zero) pages in core dumps */
+				if (nr)
+					break;
+				ret = -EFAULT;
+				goto unlock;
+			}
 
-	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			     !PageAnonExclusive(page), page);
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
 
-	ret = follow_page_pte_commit(vma, address, folio, page, pte, flags,
-				     pages);
-	if (ret)
-		goto out;
-	ret = 1;
-out:
-	pte_unmap_unlock(ptep, ptl);
-	return ret;
-no_page:
-	pte_unmap_unlock(ptep, ptl);
-	if (!pte_none(pte))
-		return 0;
-	return no_page_table(vma, flags, address);
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
 }
 
 static long follow_pmd_mask(struct vm_area_struct *vma,
@@ -957,7 +1038,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -970,14 +1051,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? -ENOMEM :
-			follow_page_pte(vma, address, pmd, flags, pages);
+			follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
-- 
2.53.0-Meta


