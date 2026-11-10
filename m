Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE65B606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=W48ASpi6
Received: by kanga.kvack.org (Postfix)
	id BB8866B05B6; Tue, 10 Nov 2026 17:53:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91496B05B7; Tue, 10 Nov 2026 17:53:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF426B05B8; Tue, 10 Nov 2026 17:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77B1D6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DED838017C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:26 +0000 (UTC)
X-FDA: 85420712412.10.D226DEC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14C18160007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W48ASpi6;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351205;
	b=QhFedXtFCdeFhhrspgJXuhX1gkl8rnXx7/E4QNiDcy+bofoDG5oRy3qV22thJJDr2ykU0B
	pnw7cGpp5SMrPf5UJ1CqglStRfMz7DivnCjM/yz8Ca5yxXC0CguWz34+7JqcJ/OGpp9CYF
	TOtAaWy7agFR3bFvE26ZmOJxqs3w5DY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W48ASpi6;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TN71or/KqWqpJdqiFqFX6Tnqncaut5sTMTc9ncIt7D4=;
	b=kIcK5thvn4wF7Bc5t+/gphyFr5FXi9hx5KpElmxtGaqikdXTN6hYq2XGCC+CzoXesGs7nz
	/hu2G0oodluMDVoOKSJjIIOfCvaWTPtjNFXoFVeBwEa6fn6wggqLga3KMBo4vs11CGWvoA
	62iiNz4QnHfB05Fg2qECxyYIHT+8TBs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 353461C2B;
	Tue, 10 Nov 2026 14:53:21 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CA723F85F;
	Tue, 10 Nov 2026 14:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351204; bh=Nf2xRbv9ETliUUnn83Z80tcd0GYkMdI/qY22YeN4KRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=W48ASpi6VrLpYN7BavQsUOctQDc2KQUAMXzG1tc7uwAwk0hW/tlGTtWgVsMqSAhM+
	 cDpOb+LrvBbyK5l5DDYQmFPtBCJhdsnhjLUaJsyu3uKo8LlZ9xhaSBjWVje95ZlOHW
	 SwXM4Tx6nylPEQ6EW6fpkO1qQGHYaCiSjj33iwsI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 10 Nov 2026 22:52:55 +0000
Subject: [PATCH v4 5/6] mm: gup: introduce
 gup_pages_not_requiring_unshare()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refactor_gup_fast-v4-5-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9201; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=Nf2xRbv9ETliUUnn83Z80tcd0GYkMdI/qY22YeN4KRQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq86BU/nRAj4zg6lTU9p4xl1YRxVznTriXQruqB
 7mC4HZxzwyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavOgVAAKCRBt1cPRWsUx
 M8+wDACggYO4Is/3jOn4+rp4CEhD+z/iqO2USHqHgGEfxmxED6ERJ7WZrKVZZfITMr+WyXXmjeF
 bMwz2v2GNKDLj/P+l0imnkV3UuaRS1j+r4iYqG4qBnPkJ+wOUo5x5HqGSqPftOAHpR58hqCH3Lu
 kvriLkcLgGeGcjGH+21E/My7sLk+WJJXAOdAxcsc9EDb8nLj6zxZz4J2PCcqeLVR4kC4Ihp78uN
 hnKPpgAhyTrX2J7f3LbEDpSP1fzJKPCF6DrR2n4EpD7R8MZzeICgSvfQHaTYbyzENotrGLDWh5O
 ShycsDLbBs9I8qLjwubFF69erBxDj1eV8pCP8d/mdeS46VckpMV8OFx9cb3eHIU9kItnWABk5EA
 vWZy80I+XVidaU6831wSy2rea3H29udanCwEe3pVUe2xC7hbfhHl9rhL5PvlCv5uska4uKzKCT7
 ENTeZevgg+YCcnMDotvZm8Rfk/uYCYshFCQtgfNFsudGqVXRJoRvb+9Qs97vxrc7dtNmY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14C18160007
X-Stat-Signature: acz74bcjz7rkpfu7ajk84xi9s4xmikk9
X-Rspam-User: 
X-HE-Tag: 1794351204-621401
X-HE-Meta: U2FsdGVkX1+yB857Rw8N/iuTW3dk1dCVykqN4Xj8knwf9EmK/36gFnljXyUE/EeshE8I9vk9FGKSFO1JqAG/DAe6p4v2XDtZoAGGYiGcPvTnyJtJdrLSr4qC5HL1miOyS1LaOZ42iVClqtmuaVPi3ZG1x1T/WBkXzMLRQAmxFCoWixGXFwecB9WK3Hv+jjnoAEsJTmLzOXmuGi3c9GCUObc9OR331GMtf7Hlj3dlmOTinKxzgxd7MytrbbL8GEEElAmI6px51v+tC7+G0C/dH/nJ0kykUj0WWwIXT1gLUgLJEm+cTIBGhGdIJp0wG3mudHKIm3tX17X7mLUlviqhcXUVv3VKJBPIURttGAwEdidI1XY7CtLahACKfSgoqBqvja1MOS/ezKc11XDD6bMhhTeI6U0bk1RIwTpuyvQ4l06VZM8xpjQdImULrxsf4IWHbn8/x0SwP0SvhuMiqtdF7syQEUd61W2yUIfG/h8ChvafitpTo7JEroI9rb/WF7458MBq16pvT8uJoc+t6Rq5zerJjKlOxEgkNeRtV66WhEb8+B0YZgBUWKB0X0LqVFPkz9e+KYgmzt7sDtlLX5cZPB1i0LxRbD4KhfvkjT+3RpdB+xXSkfOt+IUL3MhIa6ty4YicJ7/n2Tfu6+3mXN0cv7enp+YaVhuNPYqcDIJGlCpSDhfAdPgsDamUjRZMBiwzcY47HSmty8DQxqh3nyXqm6XDFccHkMCtiVrn15tyXXU7AJ5wgbb25BXerywbsM6efPCsJeM9z4yWnoAfgT9BaDpxpQaoOwddWCTiyrMNnCyhu1Ixvd8hYk/TtO79kHkgnLIVqGfxfUv4zKqym2s3wlojv+K+n2LNTfhkIlCzZWHhK/xAV4c2yHMF/QujGmGPiN1tom2srn3mNMbM9P5U5xs38UzzOboVObhIL5qbdJYnge903d777GS4BNzBOFDkfRT/0HJxe5fST5lGH1i
 8vHAIkz/
 flAayJLVVZgQyI/yVdvn/PHrliuUjWBh+YTyAFvr9LJ5yy1LR45FGZCsvP9Scz6OErItsMkxJrsg0T2LxogvyJVoxC1Q9Z9ut80wBFZlDGClXL3tF0GYAxIz0XCCYl4mkzpOBC4h1+mJtQ+sgB9DsYl1FF7TJRICZexQ/ucmhhwv0JtOjGqLG9A4o0fRJ4P8HL7PjTgsMZocAWuymmQuDKvCx4YDeNXGMZPVQCcZDzj3G7dLgHYgpvlA9qnad+9hEzlxEL7SXVPCtHnczuI+jwh9HFxhU0T33FKqH1w1aon8fZtNEZ927btOCeRY4f80paqNzer2qIK+eATJbk7NP0NiOd3badGUiQXNQbSQDVVdZpR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is preparatory patch to make gup_fast_pte_range() batchable.

Introduce gup_pages_not_requiring_unshare() to count consecutive pages
within a folio that do not require unsharing, and use it to implement
gup_must_unshare().

Also add a folio argument to gup_must_unshare() so callers can reuse an
existing folio and avoid the compound_head() call implicit in PageAnon().

Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c | 111 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 45 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ccdce67ef300..8ef41353afe8 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -633,58 +633,39 @@ static struct page *no_page_table(struct vm_area_struct *vma,
 	return NULL;
 }
 
-/*
- * Indicates for which pages that are write-protected in the page table,
- * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
- * GUP pin will remain consistent with the pages mapped into the page tables
- * of the MM.
- *
- * Temporary unmapping of PageAnonExclusive() pages or clearing of
- * PageAnonExclusive() has to protect against concurrent GUP:
- * * Ordinary GUP: Using the PT lock
- * * GUP-fast and fork(): mm->write_protect_seq
- * * GUP-fast and KSM or temporary unmapping (swap, migration): see
- *    folio_try_share_anon_rmap_*()
- *
- * Must be called with the (sub)page that's actually referenced via the
- * page table entry, which might not necessarily be the head page for a
- * PTE-mapped THP.
- *
- * If the vma is NULL, we're coming from the GUP-fast path and might have
- * to fallback to the slow path just to lookup the vma.
- */
-static inline bool gup_must_unshare(struct vm_area_struct *vma,
-				    unsigned int flags, struct page *page)
+static unsigned long gup_pages_not_requiring_unshare(
+		struct vm_area_struct *vma, unsigned int flags,
+		struct folio *folio, struct page *page, unsigned long nr_pages)
 {
+	unsigned int i;
+
 	/*
 	 * FOLL_WRITE is implicitly handled correctly as the page table entry
 	 * has to be writable -- and if it references (part of) an anonymous
 	 * folio, that part is required to be marked exclusive.
 	 */
 	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
-		return false;
-	/*
-	 * Note: PageAnon(page) is stable until the page is actually getting
-	 * freed.
-	 */
-	if (!PageAnon(page)) {
+		return nr_pages;
+
+	/* folio_test_anon(folio) is stable until folio gets freed. */
+	if (!folio_test_anon(folio)) {
 		/*
 		 * We only care about R/O long-term pining: R/O short-term
 		 * pinning does not have the semantics to observe successive
 		 * changes through the process page tables.
 		 */
 		if (!(flags & FOLL_LONGTERM))
-			return false;
+			return nr_pages;
 
 		/* We really need the vma ... */
-		if (!vma)
-			return true;
+		if (!vma || vma_is_cow_mapping(vma))
+			return 0;
 
 		/*
 		 * ... because we only care about writable private ("COW")
 		 * mappings where we have to break COW early.
 		 */
-		return vma_is_cow_mapping(vma);
+		return nr_pages;
 	}
 
 	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
@@ -695,7 +676,38 @@ static inline bool gup_must_unshare(struct vm_area_struct *vma,
 	 * Note that KSM pages cannot be exclusive, and consequently,
 	 * cannot get pinned.
 	 */
-	return !PageAnonExclusive(page);
+	for (i = 0; i < nr_pages; i++) {
+		if (!PageAnonExclusive(page + i))
+			return i;
+	}
+
+	return nr_pages;
+}
+
+/*
+ * Indicates for which pages that are write-protected in the page table,
+ * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
+ * GUP pin will remain consistent with the pages mapped into the page tables
+ * of the MM.
+ *
+ * Temporary unmapping of PageAnonExclusive() pages or clearing of
+ * PageAnonExclusive() has to protect against concurrent GUP:
+ * * Ordinary GUP: Using the PT lock
+ * * GUP-fast and fork(): mm->write_protect_seq
+ * * GUP-fast and KSM or temporary unmapping (swap, migration): see
+ *    folio_try_share_anon_rmap_*()
+ *
+ * Must be called with the (sub)page that's actually referenced via the
+ * page table entry, which might not necessarily be the head page for a
+ * PTE-mapped THP.
+ *
+ * If the vma is NULL, we're coming from the GUP-fast path and might have
+ * to fallback to the slow path just to lookup the vma.
+ */
+static inline bool gup_must_unshare(struct vm_area_struct *vma,
+		unsigned int flags, struct folio *folio, struct page *page)
+{
+	return gup_pages_not_requiring_unshare(vma, flags, folio, page, 1) != 1;
 }
 
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
@@ -717,6 +729,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
+	struct folio *folio;
 	pud_t pud = *pudp;
 	unsigned long pfn = pud_pfn(pud);
 	int ret;
@@ -729,11 +742,12 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 
 	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
 	page = pfn_to_page(pfn);
+	folio = page_folio(page);
 
-	if (!pud_write(pud) && gup_must_unshare(vma, flags, page))
+	if (!pud_write(pud) && gup_must_unshare(vma, flags, folio, page))
 		return ERR_PTR(-EMLINK);
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	ret = try_grab_folio(folio, 1, flags);
 	if (ret)
 		page = ERR_PTR(ret);
 	else
@@ -768,11 +782,14 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
 	struct page *page;
+	struct folio *folio;
 	int ret;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
 	page = pmd_page(pmdval);
+	folio = page_folio(page);
+
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pmd(pmdval, page, vma, flags))
 		return NULL;
@@ -784,13 +801,13 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	if (pmd_protnone(*pmd) && !gup_can_follow_protnone(vma, flags))
 		return NULL;
 
-	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, page))
+	if (!pmd_write(pmdval) && gup_must_unshare(vma, flags, folio, page))
 		return ERR_PTR(-EMLINK);
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	ret = try_grab_folio(folio, 1, flags);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -908,7 +925,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	folio = page_folio(page);
 
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
+	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
 		page = ERR_PTR(-EMLINK);
 		goto out;
 	}
@@ -2973,7 +2990,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			goto pte_unmap;
 		}
 
-		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
+		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -3020,7 +3037,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	struct page *page;
+	struct page *mapped_page, *page;
 	struct folio *folio;
 	unsigned long nr_pages, i;
 
@@ -3035,7 +3052,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		return 0;
 
 	nr_pages = (end - addr) >> PAGE_SHIFT;
-	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	mapped_page = pmd_page(orig);
+	page = mapped_page + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, nr_pages, flags);
 	if (!folio)
@@ -3050,7 +3068,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
-	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pmd_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio, mapped_page)) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
@@ -3065,7 +3084,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	struct page *page;
+	struct page *mapped_page, *page;
 	struct folio *folio;
 	unsigned long nr_pages, i;
 
@@ -3076,7 +3095,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 
 	nr_pages = (end - addr) >> PAGE_SHIFT;
-	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	mapped_page = pud_page(orig);
+	page = mapped_page + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, nr_pages, flags);
 	if (!folio)
@@ -3092,7 +3112,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 	}
 
-	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pud_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio, mapped_page)) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}

-- 
2.43.0


