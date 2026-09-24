Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77D1C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5A46B00A4; Thu, 24 Sep 2026 14:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D1B6B00A5; Thu, 24 Sep 2026 14:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3DA6B00A6; Thu, 24 Sep 2026 14:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F20D6B00A4
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:49:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 376ABA04BC
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:49:24 +0000 (UTC)
X-FDA: 85249543848.27.2B369F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85B2C1C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:49:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkzA4Aw+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790275762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVk+J+6paKfWpDyMf+0qbJj+JcumdT6cHUdD/JaU5MU=;
	b=HVDBtgPtb8xUMifDQk/wuAKXnCJHWQXessyfYjcHgSHurOL6kO1GYQsrDim/QfeRv4qoCG
	vujtUu7M3dR//uaBlKgs3J5XPOr3ayfSBhzwrUPKkR5mep1wczUceDw9xw4i7odENuaPPJ
	E6RKadd9VP9VhujYD8BYrURRFkSHOrM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkzA4Aw+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790275762;
	b=wSna6po2K0udGWglmO+oTiNrh90PYccSM4rB/SacJK2ZKXBMOwplR9yBqys4nh65CKsZ8G
	Szk/SWp0D+BpUymtao9SVUPVJAzNdKjIaLLYI8vU7O2CEjlNFJ8ggsPl6K9bkA68BMprQ7
	INBXyDC5jVkzsQDdxGuK4xh8kSlmXEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E46F600D4;
	Thu, 24 Sep 2026 18:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13E41F00893;
	Thu, 24 Sep 2026 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275761;
	bh=iVk+J+6paKfWpDyMf+0qbJj+JcumdT6cHUdD/JaU5MU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MkzA4Aw+cQHzFciygv95Z/EZT6W6NoJYoXb74juTqpXbV+B6umLRdm7RaOmMP2+jn
	 FOtnGi3WgylnfImvI8URJnAHEzLgLQEhfW+xBEMZ2sO94rNeJ/FMYhHkKcfvJQ1sE7
	 eL7I8pSoRTcvy31Scc4P9/3XGh7hG1KjZgbwhgQxa8l5FHt1UQKhpZlimXvwAcf0SU
	 fNF4ClO/wkyJeKKJjhmEcPisE0m2uOWKFbe4fZR1BSOMU1XKGLtMw+b2m2AnvUpAnR
	 QdgMjkyC3rE3ob8Whzq+OUaLrBgpgwOaSe0/jaaz+H8++6TGtxSevOHwgbGFwU6pl+
	 GCOCNZkYZZjsA==
Message-ID: <82738d2b-9c2c-474e-b90a-60a1140b5bd6@kernel.org>
Date: Thu, 24 Sep 2026 20:46:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/memory: reuse 16 PTEs of an exclusive large
 folio on a write fault
To: Yuan-Hao Hsu <aa9736195201@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260918064238.868-1-aa9736195201@gmail.com>
 <20260919073134.639-1-aa9736195201@gmail.com>
 <20260919073134.639-2-aa9736195201@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260919073134.639-2-aa9736195201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: jrb4qmsfj9xw8jeq7qe581erhtitfp5a
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85B2C1C0003
X-HE-Tag: 1790275762-291933
X-HE-Meta: U2FsdGVkX1/rgp5SQcDruBP/IH4jt5AuzcY9d4xn6K0BTae2OeATUz+V1CsLjPDskpsD7P0VAUmQhvKKfaWAqOj+0gFw6KoyQq7PyQ/rCJGOBwnzyI0MZFxP41PmO8++YfyS6ZxguDS3MMPX4O0K7lfRR9l19P5uP2YnkvrX7GVZkwMrZGDsaxU6utnp/6nSEtcMbeLw4wmFjcH2XAQAbTQnEGBAOPlvXqNr6a53SCdlKUG/iArohatcfRE+APOnJ/OjBcsDPxElbXxDAneDP+wWITEF2XL9ZZocPMshfNfdV9GcwlEjJup/6GXYU/GWTG4HStNBwQiU9sr958mvjK/dv1NyB0Q/R+bvYR1nvkvYwS0VCLqEsYvl4MnaNZXe+djpAiPBIVhxd9IlruqyC5nSSXSOeoxk/GVyJxNiuDoD3WjIuvRTCWBvH8fJJ+08Xmcri+XhQYQEpiQ3eozq6tpZxGJA3AEfXZSbv8XZTZ3tMA+Zmw67Jr7tibH6bojH05flf3jk1RpDHsDDAAIELmR2SC3LQOpHmioMjxQj5C9YB3wEIU513LelJV5Nh+CQvB/nov0JFjCGxzEjoF0qgKYaXL2UdKyt86huseqsgiPxwL1KztXFO1UjRV9oKNvqPzSll3zh5Rpp0qpJLL2tkSfbPCMpxOWCMlocFALjDAAvxD30Cp9wEBQtHrCY/mRX7QiMgEyQvKI+6xUq556LDKgwb/HAPlt4wEpbAksxQBRshyimh8bCcimg/vPWSH95U+cc5PIRM4/VAV95Bqb7MF2joIGHoWD/JyG+1tmd2AN/Uu9/lyH4JWCumFUXmg7BGONGsnbP7c4coaEjwpGA1pX/kunkMF/MuUHQYejRlwX3Jqp9dwIrs7qm8SWscXhGrVkmGmVs26Qh6cSJ5tEcERivMAiW7AL1YhTHFNfbhbZ8eQ0g60GTW/b9GEHGJronumXN0slk9VklvHEG8oR
 RpNR8GAl
 lyvthofkQJ/uYDrqOFbCm3WRODwhPiPTVO2VMpN5oru4jGelXoEt/b482P9Gr4ZMuYZnURRe0EmIHq5X/PYOlviHgeIqfF+7iMQKWqr/UDVg7yfoimOge2F523rb1bHL6uTsb0Eo7serkWrCPx0hrAr3Xe1a0KE+MFrnudBAchCT+3iiiUpsboSwWHDd5hMPT6Z1ha4IETB+DYqDyOiUX7zFKlqFxiuEnhW+6MW2h+XTO/P3Wnc1IzM9Qn8IIe285T47spRtIFzOppXi3eWru7I8m7dZCVIOtpXWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 09:31, Yuan-Hao Hsu wrote:
> fork() maps the anonymous pages of the parent read-only and clears
> PageAnonExclusive on them.  Once the child has exec'ed or exited, the
> parent's write fault takes the reuse path of do_wp_page():
> wp_can_reuse_anon_folio() finds that all references to the folio come
> from this MM, the page is marked exclusive again and its PTE is made
> writable.
> 
> For a large folio that check is about the folio and holds for every
> page of it, but only the page that faulted is marked exclusive and
> made writable.  Each other page takes a write fault of its own and
> takes the large mapcount lock to find out the same thing again: 16
> faults for a 64K folio.  The same THP mapped by a PMD is reused by one
> fault in do_huge_pmd_wp_page(), and do_swap_page() maps all PTEs of an
> exclusive large folio writable at once.
> 
> Barry proposed reusing the whole mTHP from one fault in 2024 [1].  The
> reservations then were the latency of the individual write fault and
> how far to go around the faulting PTE: a contpte-sized block was fine,
> anything bigger not yet convincing (David's replies, linked below).
> Commit 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for
> PTE-mapped THP") then added the per-folio check and left faulting
> around for later.

I'm fine with the original idea of limiting this to reasonable chunk
sizes, reducing the work we do in a single page fault.

The patch needs work. I disagree with various decisions
either you or the LLM came up with like

* Uglifying do_wp_page
* Not handling unshare
* Calling wp_reuse_large_anon_folio() to do some batching to then call 
  wp_reuse_page in same page fault
* Batching multiple pieces in a loop
* Using can_change_pte_writable()

I tried to see how to implement it cleaner. I think we should definitely
start with:

From 3d16faebcbbd1b970edb51ef2f710ca51e9709af Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 24 Sep 2026 19:43:15 +0200
Subject: [PATCH 1/2] mm/memory: factor out anon reuse logic into
 wp_try_reuse_anon_page()

Let's move the core logic from do_wp_page() into
wp_try_reuse_anon_page() to prepare for further changes.

No functional change intended.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 338fce99e7119..67fcf67bc64fd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4414,6 +4414,34 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	return true;
 }
 
+static bool wp_try_reuse_anon_page(struct vm_fault *vmf, struct folio *folio)
+	__cond_releases(true, vmf->ptl)
+{
+	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
+
+	VM_WARN_ON_ONCE(!folio_test_anon(folio));
+
+	/*
+	 * Private mapping: create an exclusive anonymous page copy if reuse
+	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
+	 *
+	 * If we encounter a page that is marked exclusive, we must reuse
+	 * the page without further checks.
+	 */
+	if (!PageAnonExclusive(vmf->page)) {
+		if (!wp_can_reuse_anon_folio(folio, vmf->vma))
+			return false;
+		SetPageAnonExclusive(vmf->page);
+	}
+
+	if (unlikely(unshare)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return true;
+	}
+	wp_page_reuse(vmf, folio);
+	return true;
+}
+
 /*
  * This routine handles present pages, when
  * * users try to write to a shared page (FAULT_FLAG_WRITE)
@@ -4499,24 +4527,9 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 		return wp_page_shared(vmf, folio);
 	}
 
-	/*
-	 * Private mapping: create an exclusive anonymous page copy if reuse
-	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
-	 *
-	 * If we encounter a page that is marked exclusive, we must reuse
-	 * the page without further checks.
-	 */
 	if (folio && folio_test_anon(folio) &&
-	    (PageAnonExclusive(vmf->page) || wp_can_reuse_anon_folio(folio, vma))) {
-		if (!PageAnonExclusive(vmf->page))
-			SetPageAnonExclusive(vmf->page);
-		if (unlikely(unshare)) {
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			return 0;
-		}
-		wp_page_reuse(vmf, folio);
+	    wp_try_reuse_anon_page(vmf, folio))
 		return 0;
-	}
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-- 
2.43.0


And the maybe go into this direction, where we really only try to
batch exactly once, and include in that patch out PTE of interest. IOW, optimize
for the common case and also take care of unsharing.


Some things I am not sure about
* Hardcoding WP_REUSE_MAX_NR_PTES, likely should be determine differently.
* Marking all 16 PTEs young+dirty. It's somewhat the same thing as we do in
  map_anon_folio_pte_pf(). On arm64 it's already fuzzy with cont-pte. With
  transparent coalescing we'd actually allow it directly. So it does feel like the right thing.

I also wonder whether some part of the function could be factored out as helpers for
other code to use in the future. I also suspect that there are more cleanups to be had.

Long story short, needs more work, but I am out of time.

Entirely untested:


From 1db2c61661cc854eabb8619a2717d1ddf43a95f5 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 24 Sep 2026 20:03:01 +0200
Subject: [PATCH 2/2] mm/memory: reuse 16 PTEs of an exclusive large folio on a
 write fault

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 120 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 115 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 67fcf67bc64fd..dab2a274783bf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4414,10 +4414,78 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	return true;
 }
 
+#define WP_REUSE_MAX_NR_PTES	16
+
+static unsigned int wp_anon_folio_pte_batch(struct vm_fault *vmf,
+		struct folio *folio, unsigned long *addr, struct page **page,
+		pte_t *pte, pte_t **ptep)
+{
+	/* modify_prot_start_ptes() needs most PTE bits to match. */
+	const fpb_t flags = FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY;
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long batch_start_addr, batch_size, folio_idx, nr_before;
+	unsigned int batch_nr_pages;
+	pte_t *batch_start_ptep;
+	pte_t batch_start_pte, expected_pte;
+
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
+	    !folio_test_large(folio))
+		return 1;
+
+	/*
+	 * We'll try batching in a naturally aligned block surrounding our
+	 * faulting PTE.
+	 */
+	batch_nr_pages = min(folio_large_nr_pages(folio), WP_REUSE_MAX_NR_PTES);
+	batch_size = batch_nr_pages << PAGE_SHIFT;
+	batch_start_addr = ALIGN_DOWN(*addr, batch_size);
+	folio_idx = folio_page_idx(folio, *page);
+	nr_before = (*addr - batch_start_addr) >> PAGE_SHIFT;
+
+	/* Stay within the folio. */
+	if (nr_before > folio_idx ||
+	    folio_idx - nr_before + batch_nr_pages > folio_large_nr_pages(folio))
+		return 1;
+
+	/* Stay within the VMA. */
+	if (batch_start_addr < vma->vm_start ||
+	    batch_start_addr + batch_size > vma->vm_end)
+		return 1;
+
+	batch_start_ptep = *ptep - nr_before;
+	batch_start_pte = ptep_get(batch_start_ptep);
+
+	expected_pte = pte_advance_pfn(batch_start_pte, nr_before);
+	if (!pte_same(__pte_batch_clear_ignored(expected_pte, flags),
+		      __pte_batch_clear_ignored(*pte, flags)))
+		return 1;
+
+	if (folio_pte_batch_flags(folio, NULL, batch_start_ptep,
+				  &batch_start_pte, batch_nr_pages,
+				  flags) != batch_nr_pages)
+		return 1;
+
+	/*
+	 * Our faulting PTE is guaranteed to be part of the batch, and all
+	 * PTE bits are compatible.
+	 */
+	*addr = batch_start_addr;
+	*page = *page - nr_before;
+	*pte = batch_start_pte;
+	*ptep = batch_start_ptep;
+	return batch_nr_pages;
+}
+
 static bool wp_try_reuse_anon_page(struct vm_fault *vmf, struct folio *folio)
 	__cond_releases(true, vmf->ptl)
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address;
+	struct page *page = vmf->page;
+	pte_t new_pte, pte = vmf->orig_pte;
+	pte_t *ptep = vmf->pte;
+	unsigned int i, nr = 1;
 
 	VM_WARN_ON_ONCE(!folio_test_anon(folio));
 
@@ -4426,14 +4494,56 @@ static bool wp_try_reuse_anon_page(struct vm_fault *vmf, struct folio *folio)
 	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
 	 *
 	 * If we encounter a page that is marked exclusive, we must reuse
-	 * the page without further checks.
+	 * the page without further checks. Don't process more than a single
+	 * PTE in that case.
 	 */
-	if (!PageAnonExclusive(vmf->page)) {
-		if (!wp_can_reuse_anon_folio(folio, vmf->vma))
-			return false;
-		SetPageAnonExclusive(vmf->page);
+	if (PageAnonExclusive(page))
+		goto reuse_single_page;
+
+	if (!wp_can_reuse_anon_folio(folio, vma))
+		return false;
+
+	/* We can use any folio page that is mapped in this page table. */
+	nr = wp_anon_folio_pte_batch(vmf, folio, &addr, &page, &pte, &ptep);
+	if (nr == 1) {
+		SetPageAnonExclusive(page);
+		goto reuse_single_page;
 	}
 
+	for (i = 0; i < nr; i++)
+		if (!PageAnonExclusive(page + i))
+			SetPageAnonExclusive(page + i);
+
+	/* Careful: don't mark unrelated PTEs soft-dirty by batching. */
+	if (unlikely(pte_needs_soft_dirty_wp(vma, pte)))
+		goto reuse_single_page;
+
+	if (unlikely(unshare)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return true;
+	}
+
+	/* See wp_page_reuse() */
+	folio_xchg_last_cpupid(folio, (1 << LAST_CPUPID_SHIFT) - 1);
+
+	for (i = 0; i < nr; i++)
+		flush_cache_page(vma, addr + (i << PAGE_SHIFT), pte_pfn(pte) + i);
+
+	pte = modify_prot_start_ptes(vma, addr, ptep, nr);
+	new_pte = maybe_mkwrite(pte_mkdirty(pte_mkyoung(pte)), vmf->vma);
+	modify_prot_commit_ptes(vma, addr, ptep, pte, new_pte, nr);
+
+	/* Remove stale read-only TLB entry for the faulting PTE only. */
+	flush_tlb_fix_spurious_fault(vma, vmf->address, vmf->pte);
+
+	/* But update the MMU cache of all changed PTEs. */
+	update_mmu_cache_range(vmf, vma, addr, ptep, nr);
+
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	count_vm_event(PGREUSE);
+	return true;
+
+reuse_single_page:
 	if (unlikely(unshare)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return true;
-- 
2.43.0



-- 
Cheers,

David

