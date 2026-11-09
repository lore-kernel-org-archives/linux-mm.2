Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55D7606EE9F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sbbINGkl
Received: by kanga.kvack.org (Postfix)
	id 2EC3F6B05D3; Mon,  9 Nov 2026 07:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276156B05D4; Mon,  9 Nov 2026 07:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164706B05D5; Mon,  9 Nov 2026 07:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D18BE6B05D3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70DBC40678
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:47 +0000 (UTC)
X-FDA: 85415519574.07.BA2FCBE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A363E14000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sbbINGkl;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aa4zdS5qJ5MNUwcewWUSYcHjNM7vFuvs3Xvmr1yfVNo=;
	b=aKvyyI2IqHOwEdsesG7cXjC9q5K+RBTJRFS0LJjAkl+yLvDf+ZmV6T4XRWlo3dblhdP2o0
	dcPqIxkLztc+EvsPXgF+x34egMfqBXnM8QZbYMvU11boaiLECtFoK5JEH88gaVj59zbiEI
	xjBuSKqryVaGyExViZkuy14pZ/vfRM8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227565;
	b=VjQ6nypEpBQ43ODTDpCUFgtttenIxFOjNLnylMtS7xeHGi/XjznOS54I6pK7wnthQsWelo
	O03x3fZccHcxhKAD7NBEwXnCQOTyJ9hGYYjHPGQyCfvjW1YZBjmtmzHO56w/vTcM20x34E
	g23gJshhV3GDtcH2ucmJKmUZWoZByr4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sbbINGkl;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88271576;
	Mon,  9 Nov 2026 04:32:41 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07D273F632;
	Mon,  9 Nov 2026 04:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227564; bh=ER+X1jAhTqlAAq1n/q6+T7YpsIJ+jMMKPwo+mKWcyGw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sbbINGklh4wNgPeKOlovMPiLYmgRmv7JFaPqpXGJOgHABBEJUteS0gxjnumHJfv1R
	 //nWyHZP4JjvEEOqmSKq5FforXtM4FBsVi0qO8f1dI3hJtIiOdwntxqWDC5jIgHGVz
	 Wv+Wxum2edAjgEQQipGQRcLnG6O/AHsojTWleezY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 09 Nov 2026 12:32:29 +0000
Subject: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9150; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=ER+X1jAhTqlAAq1n/q6+T7YpsIJ+jMMKPwo+mKWcyGw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1e4he3DOP+aPMJhmIOqP39vWMVfAA2l5faH
 FzOgoPh3v+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XgAKCRBt1cPRWsUx
 M2RgC/9GTTRAYwEdw7fwVZSS6gFHwmklRdYBjNhz2XJbgq2G6DJMkW7NJ9/Z0v1K2DJupQaVaV0
 atpwQAfKnPBW7eEJ++J0EHfxKaI5R55xxWIU+WI/V5xmvN9MA7c186atMaZix49+NLTOGjcuIIu
 dv3vPQz8kCxKz+68NVXBMGV9Mz7TvOoxhoKcb/kKrhufYgKy0+Xa3oa7/qfZuxkYShk55uxP4P9
 WFY5J9RxHQp4uTEgRU4N+QjMPpmYPiupTVD3bTQUUuMInGg9M8Jr6CZevADg/uz0S2q+SFC4stO
 QTK2FZskkCgL/01m+5PbbEJD7+/IB1Qs0kGEe94/saWXL4a+O3i+GtWm0NLllKPcx0Ltf0gcquZ
 Gs1Udsw3k90pOr3kbYR40Dq0rSrJmrcmMcuWgyBGVBE2Rv5Z6AwQ3lKyeLDuVGUzlafaHzuaGXj
 G+v8mAUFOWZkrbHuc3WfI9p5y+v1SYjv8GiwSnNFiPbGv3jaoV/75ajeNTPv+afQz640o=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 614im7jkn5drkcneo4g6racgt49h3yyn
X-Rspamd-Queue-Id: A363E14000A
X-Rspam-User: 
X-HE-Tag: 1794227565-272864
X-HE-Meta: U2FsdGVkX1/lrQsKm/flO0DeVsmsWjHvve6K+d7AHXVrZ3yp/+RAh4RQ5I3DHsSZt/MXx37xbCs0LL3x+4Uv+xR2/QYX1DEFTEY+etHBRzPnJoZq+hwOdLLq/x0c7R3Z3BRKCnhNVSlZDO8sHp3Vge4j7jeyU6S82nFgd9DtcNSZ7Lnd2fbZXyPTMvHkkOI+xFMC8w87wazjNlfkmNONJmE4LTdRDvdBI2bpfrsffCcnWtSACzcQAUUYJAWdeg2LwY0UltVth2W1bhPTdjTu3Pl20ndDfU6nmF+VneRQu/2mo+dU+uOLtj0v5tqAf6Lxe4V3x8Y6WtJas2QKqeaJhzseu9Zj4oUC9L13qzv1iKoYffTIg/mO2pOi/6cNogBenzThz1j/U2K14IlafrHs9gdJ8rrmQjNlcGVeTrmrrFamec0EYUpsguTTOc5GB+sXRrhXX+5HJCyBiVKG/RCRo5Ytqz4sWAMXBMKFYx3VmjIm7TtDsUv4q1f46kE1neahx/q10vGcw8cqdKovVPNQRtR/AuZ7EgQJLdYZajfkCVlMOsUvmj2kGxAcAbdGDCvvqLm3x95cMxysEjZ5wri5rjVvjEkDCvbiAPwqDmiAb9JOijNNyTyPzkJkTS2CZ1d2KukDUsQ+RtROJRFQJc2ITIfwFyq+zfmyoDIkTx1ubHXL4fyYa8DKnYmvBPtVozGQO9U8vro5UFeW4UCOjdceLM3Tu+vAbgdzXqx+JCN2cd+Jg+79K2g2G2qOehFWhdyPwUR8xBZGLurFHyWTd8SIGdp5ovXHIrhtocUIeRy63Pu6bql+etc0+i/NX51W/wf00rMxLMsmTDLRv4ujLqwVYq3JXL4vjTuB1oeorK6338K6unDPNGsHNUbVbfAh2LRlUw5avd+m1pNlJFpq2C1b0OOKpXhZDGsATC2xj/2//yWrGISJPM5ZBkRHdD2exd3D+EBUvJhpNiuafinypID
 jCHfWtN8
 r9phCWuoQkG+YQFR8d76BWRcm+bKm3KzdQENV9960KqXo6Rim3huz9Rqt3Z2jmobq7+DV+YRvd3P/AdJFuhKDIx+CS18mYnoYt3HL1lDTtXIQXK8LQiYc1/ANYuwbOmSO+2R6Bw5EBArkhaQ6NDhN9YAQKoHMqIh2oh+mfPMeIx6+2puK9pWbsx7BNGIpElpQw1rL+hLwS/RBYmNjCTNJ/OLyIsiV7QQ9MJbW441Wh0weYYK1SwBWWcECyyIO5JwX+LZYjqTs295g+q/EnkiYLNgkw0gwp6Tr/1ujz3466M6F3ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is preparatory patch to make gup_fast_pte_range() batchable.

Introduce gup_unshared_pages() to count consecutive pages within a folio
that do not require unsharing, and use it to implement gup_must_unshare().

Also add a folio argument to gup_must_unshare() so callers can reuse an
existing folio and avoid the compound_head() call implicit in PageAnon().

There is no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c | 111 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 45 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index bfe83ce1411d5..c863bae33e2f1 100644
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
+static unsigned long gup_unshared_pages(struct vm_area_struct *vma,
+		unsigned int flags, struct folio *folio,
+		struct page *page, unsigned long nr_pages)
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
+	return gup_unshared_pages(vma, flags, folio, page, 1) != 1;
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
@@ -732,11 +745,12 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 
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
@@ -771,11 +785,14 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
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
@@ -787,13 +804,13 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
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
 
@@ -911,7 +928,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	folio = page_folio(page);
 
-	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
+	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
 		page = ERR_PTR(-EMLINK);
 		goto out;
 	}
@@ -2969,7 +2986,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			goto pte_unmap;
 		}
 
-		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
+		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -3016,7 +3033,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	struct page *page;
+	struct page *mapped_page, *page;
 	struct folio *folio;
 	unsigned long nr_pages, i;
 
@@ -3031,7 +3048,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		return 0;
 
 	nr_pages = (end - addr) >> PAGE_SHIFT;
-	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	mapped_page = pmd_page(orig);
+	page = mapped_page + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, nr_pages, flags);
 	if (!folio)
@@ -3046,7 +3064,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
-	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pmd_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio, mapped_page)) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
@@ -3061,7 +3080,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	struct page *page;
+	struct page *mapped_page, *page;
 	struct folio *folio;
 	unsigned long nr_pages, i;
 
@@ -3072,7 +3091,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 
 	nr_pages = (end - addr) >> PAGE_SHIFT;
-	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	mapped_page = pud_page(orig);
+	page = mapped_page + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, nr_pages, flags);
 	if (!folio)
@@ -3088,7 +3108,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
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


