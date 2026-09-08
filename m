Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1992EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F8F6B009F; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0A26B00A1; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEA06B00A0; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 733CA6B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E4FD140647
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:07 +0000 (UTC)
X-FDA: 85190733894.25.1CC3CDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E56FC0009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMph5lxd;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AChODC5AHZLUdfC+ioRgIkad6KpONv/acCA4JtBhMak=;
	b=49k+m34qK3Sxbm0k2mPxFs30v+VNtgau+eek3cnXhCMzosRdKDpO+8AIm1+okv51LgjHvt
	Hv9/o0xqx2yl4CGixN2qp0t1DvOzey0A9x24lbL7rFn1C79+g+q8aeFDHdGA8Hy6XD1r4q
	Uiz3uW5DqcOAx6zeEOZ+G5WM3Z/Nb/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMph5lxd;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875525;
	b=73VX5fdRVs72bMvLJ2nBt8KaKr1p+2LWzvaVcB5HexePG0gWAlVoFtlPLW2coNXf/9eA/2
	a+pItL6s8yvuE6hc5vUx3ceScRXTVX6mGML0T/0+NQax/URclIN13ZGXofLHbHBQZbJzxe
	qFseMl5imE3ZEIGPoRVyJ0f/s5aEVBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2738601FB;
	Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC801F00A3F;
	Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875524;
	bh=AChODC5AHZLUdfC+ioRgIkad6KpONv/acCA4JtBhMak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMph5lxdwJPFP27MCU5ckrGtAumdEQ53z1H3ThxtpdEwMOOIpqKEJUuSpfL+ejXL4
	 I/+huYYYGxVpn2d5Q1DcUtlw7rlZ2IU0C5KErJIsm2i2qYU/TAjg+Ta0otZloeIdm6
	 GkPabVyGquEO4w29MHJui6yuNwFjVSfkIYMhy8YNxgZRoVQ9Tf80ks3n45prLoeMbu
	 eEuMVzLrteuNpqsCd1daSvIEHkMg86PHi4ss2sRY5Fp2PGCan1Yo3j1TisitL9KGaf
	 TD/okaz5/bW1iwY2fLJTnykbuw+EtfphToMcCVl1NOEthVd+0ZPUfLsrzcYaZQQoox
	 WoxJLRbo8QQZQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krishna Iyer <kiyer@crusoe.ai>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
Date: Tue,  8 Sep 2026 06:51:54 -0700
Message-ID: <20260908135156.97481-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908135156.97481-1-sj@kernel.org>
References: <20260908135156.97481-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pgbqgsrn1it4gqnrfiogtib3uw1h5j6z
X-Rspamd-Queue-Id: 6E56FC0009
X-Rspamd-Server: rspam07
X-HE-Tag: 1788875525-218876
X-HE-Meta: U2FsdGVkX187a8g5msaPxxLiXPO5jSpc0yOWEBlxUOY+caRBWQeKZ9NIO7/976S8zdXo98M3DGzPia2c0yKxn8VVWIxap88nZGOhyNbQ1kwJ0mhB5rXpBl46TGzVjQUSDskPO1oJww3Og41AJxPKNF8f305pVjYx0AD0NPIxm67ISNmoo4CPNnUb0OnM50CqrW6yGivuie4QHjYxV19sz22/wmb0KqI0ejU0a5fGBo9u2838Wy8vT/YPr1WZQ0GDLuzh1qqcgj3UHG0Xezjv5H2Pleco7wSX117ZnUH7z0M8vxEsJdQz8Uxksz/jxhWE6As0OdMSMhUwbYunFTkwEXFsQCUxjFhY+DPdAXwLDG/Drtq4ldnIyNWFOxwS5zDmxQ6dvqQdHoJUuPMKa78AZHtxu5odIPKgHixm9jHunCEY3WhevTDMqjgte4kLRZuK/1M1ad1apYXrD6shDwwr2bG4FYNYe+qPQvSiOYaZfqhicGgkplBKI96xi4SZ+RWch357u5YTiN38B2b/gZysuotNVMXNehARw6oE8TfWPXPD4fi3vHmo4veuLKHbh5G1e9Jk6FjgbxXXfsoEyUIQoSNNxN0KtdB+QoISln67FUjVgU8bi+ltMu3P/3ut0rBNqBzoJBEzUrDYgDz26gDUjNjTLfWpiI96KVUn4VBERinHWLWws19QaeZGaTY/RsILYl30IKln6lUKCEiyb0HQn7BIRFbJMNBG8ghHgZWYnn3EtBYR2yEkAyhGr4uN9pJsFNqKiOLP1nuPOVl62smQdZHt+Y+tWWr9MV9Z8geTNfNmRALaNQvvygR5SM92WGBDdYBPHnSzGDBU8RJxbcoWs99T6Wl61u6xyFZsbybhzn8FbBszWVE0dxnOlA59CKDb/f+TyO7mrbLjYu+HAs8GrCRFRimYWkSYWAu41FxMAdlsMg6i5kgr289cogOMHnSj0CxOxGaUdWL1qlnbtm0
 w2VfoiXO
 0Vw3ME9XPNfboQ6GBE9PTqXgHWb110HXkrLHSlzFBEpZVQkQLa7hcU45SKcrX62uqjERCREfsMtpeeGkUcKhPpxRQatWW2Jwe3ZWzNmjz0Q4kSpNBDZ92uJ5K3u2PYTpjhOJ9B1+kc3nCvdLO5X6T9Ha8wjuVcXg6wNWuvhmRwxaQb0HnHwKEPoOw3zfEuc94RtwkYH0JIeFLGUCgwcH5kJV0P7C51G+w0qQUpq3x3RR8UkHMk484YVEoXW7uDN/tf1oc5hIez5zDACk+OHlkQMkJOKVs7G+zo+rq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Krishna Iyer <kiyer@crusoe.ai>

damon_folio_mkold_one() and damon_folio_young_one() assume the folios
they walk are mapped by normal PTEs or THP PMDs.  When the folio is a
hugetlb folio, page_vma_mapped_walk() returns the huge PTE in pvmw.pte
with its page table lock held, but the walkers treat it as a normal
PTE: they read and age it with PAGE_SIZE-granularity helpers, which is
wrong for huge PTEs (up to PUD level), and notify secondary MMUs for
only PAGE_SIZE of the mapping.

Add hugetlb branches to both walkers.  The mkold walker reuses
damon_hugetlb_mkold(), which the virtual address space operations set
has been using for hugetlb aging: it clears the young bit of the huge
PTE via set_huge_pte_at() and calls mmu_notifier_clear_young() spanning
the whole huge page size.  The young walker gets an equivalent new
helper, damon_hugetlb_young(), which reads the huge PTE with
huge_ptep_get() and consults the page idle flag and
mmu_notifier_test_young() like the existing PTE branch.

Locking mirrors what page_vma_mapped_walk() provides: the huge PTE's
page table lock is held inside the walk, and for shared hugetlb
mappings (the only ones subject to huge PMD sharing), rmap_walk_file()
already holds i_mmap_rwsem, satisfying hugetlb_walk()'s locking
requirements.

This is currently dead code: both rmap walkers are only reachable
through damon_get_folio(), which rejects hugetlb folios since they are
not on the LRU lists.  A following commit will let the physical address
space monitoring primitives opt in to hugetlb folios.

Link: https://lore.kernel.org/20260902025700.17975-3-kiyer@crusoe.ai
Cc: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 61 +++++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 995cc1f3b9f32..349e1604cc1b1 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -205,10 +205,15 @@ static bool damon_folio_mkold_one(struct folio *folio,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
-		if (pvmw.pte)
-			damon_ptep_mkold(pvmw.pte, vma, addr);
-		else
+		if (pvmw.pte) {
+			if (folio_test_hugetlb(folio))
+				damon_hugetlb_mkold(pvmw.pte, vma->vm_mm, vma,
+						addr);
+			else
+				damon_ptep_mkold(pvmw.pte, vma, addr);
+		} else {
 			damon_pmdp_mkold(pvmw.pmd, vma, addr);
+		}
 	}
 	return true;
 }
@@ -233,27 +238,55 @@ void damon_folio_mkold(struct folio *folio)
 
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = huge_ptep_get(vma->vm_mm, addr, pte);
+
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+#else
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	return false;
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
+static bool damon_pte_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = ptep_get(pte);
+
+	/*
+	 * PFN swap PTEs, such as device-exclusive ones, that actually map
+	 * pages are "old" from a CPU perspective. The MMU notifier takes care
+	 * of any device aspects.
+	 */
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+
 static bool damon_folio_young_one(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	bool *accessed = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
-	pte_t pte;
 
 	*accessed = false;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			pte = ptep_get(pvmw.pte);
-
-			/*
-			 * PFN swap PTEs, such as device-exclusive ones, that
-			 * actually map pages are "old" from a CPU perspective.
-			 * The MMU notifier takes care of any device aspects.
-			 */
-			*accessed = (pte_present(pte) && pte_young(pte)) ||
-				!folio_test_idle(folio) ||
-				mmu_notifier_test_young(vma->vm_mm, addr);
+			if (folio_test_hugetlb(folio))
+				*accessed = damon_hugetlb_young(pvmw.pte, vma,
+						addr, folio);
+			else
+				*accessed = damon_pte_young(pvmw.pte, vma,
+						addr, folio);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t pmd = pmdp_get(pvmw.pmd);
-- 
2.47.3

