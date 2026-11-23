Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020A5606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Wtis5iKu
Received: by kanga.kvack.org (Postfix)
	id 595E36B05C4; Mon, 23 Nov 2026 00:36:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546B36B05C5; Mon, 23 Nov 2026 00:36:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C16C6B05C6; Mon, 23 Nov 2026 00:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0580B6B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CD15407F7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:57 +0000 (UTC)
X-FDA: 85465274874.09.C92AA41
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id C00341C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wtis5iKu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412216;
	b=ReBBV6ah8eJtsnJGpEWAHQdDnuUkN+bTOHbkPTnTiJZga23+Po6qPwC5Depswsu10X0S+z
	pJGT16jn/kj3e/kMT0v4EbZw8RpT18Ru6Cs6rv1/0qsYauaE5KEJQQRY+zcawjMvEDjedG
	FxZkynB/+cvz27DprhWvBgbUJSMKs0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDRtJkHxTc2fWneNIcPtskVuMMgBJtQjPl6polScnoY=;
	b=BHkuyrdWNuZt8LTH6GHt96QHEEK4umuCSms/hRvRFwmN8uIx8XNEeJqXFfMREoBO+XvzlH
	6Ts8a+tLQYzjqn3nmuYBKoUkYJAjGOb78GMTMjX84zlYRmFjG+6nnPcZ7IIt/qGbq24IaQ
	Clk0I+g+rFpXilsgsacALg21nvMofPY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wtis5iKu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F6071692;
	Sun, 22 Nov 2026 21:36:52 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 665BB3F632;
	Sun, 22 Nov 2026 21:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412215; bh=KOtutp3l94to1LtsYGDNwuEuPBuQYw08/y1XS1Ft0o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wtis5iKuuWzOu+Ms75KOuaBv44KS7lwWCCkuYqoVxTnp+PqjJAHpkDULPYMVaZIU8
	 FI8iwaLTRVOmpf+DnbFmQIdDiJCE7MQx2WV81/IzFD/jif8xmaeWJdeXuYe9w2wMob
	 wdrokWRtiuYcNEkVcSxucDPw//5tjKhRGAjLrNWI=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 8/8] mm/rmap: batch unmap anonymous swap-backed large folios
Date: Mon, 23 Nov 2026 05:35:42 +0000
Message-ID: <20261123053543.295467-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uqz11z8n5h68axny3dhfy4i6b8j5znsd
X-Rspam-User:
X-Rspamd-Queue-Id: C00341C0005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795412215-82494
X-HE-Meta: U2FsdGVkX18uFF71E1fKMOc0zlxdc4/N6rfQ9XnYmwZmyHy8BnNoUHevLmOKG+tgvUQl/2EUXZIOsIcf7hZgwTYoHbLlLuhC2gOzKMQZxV6t5irUi2TlQyoY74ae+UX610HhvmMv6By3zZsR6ZG7R0Zv+OjEVwgR7cBH1azvoc4jzmhaATImjXn1oZz45rPoIwZj/H1j0RPAImYFqqJCTnhkMEoh8LrUVYziYK2ET9nJTC5GT978DmXQACphFUVd+wSF1/AMMUwd3pubO9Ld/2lyKFG8at/XiXHbzcl8btrfrJCpQyFolp24x3zD6sGcZSU357Huul9m+T5GK57VSIvt8dgovDa/lORzzjITtPG1iCfppREnubyZxTSfvU9XCaySodxspT9r34iEC+d/AjC+hZJhE1Ye506v/tNYqfKNpLFPiToGXOLeuIJaH2R4tUe3PRp7Q7g1Sj5JtRb69DYtbCregMjaDLMMlt3FJuxxmN+or7ztif1Zn/S8fZtepLkIHB3FsH/yqpCkw5eysqSJHMrOmjGwBCV8B0ZS8k8dIMJCMjM65GVbC2FrRxI+n8w0H6PFoSoStuKlAgMTY7NJmfIchR+zMq2EKqk3NhBrzUAHJuKVsGiVpcXGsWPBFqSzY9NqDs2GY9p44fLlEDEI08nGJS2qo+OSRgfOgYZFf2SJIPkxH1pzNkC03KSxjK6ka3xK2pL8sZ9g2ZRknRsbi3coITY4jhAay8ndPhYLY5Im+KWQaXgg37TgPgDQPDfFggGLNq67XUlSGVFyZBsENmuC4dBiXJC9K0luvNI3qd/OBFX4ppeNHgpQPxJuAq8wtbtM8mFFv2HtXUaF3yjbZSBC7o9oMG8FpYtwCUvRz3ucxKEtI0rU0TNuHqvzT6mkVY3YHvvgAwNhyelMiZX3orWdCtNxbq6Bc6eFvDbSRc5LUKLzmvS+WEUIyISWjHrZAQArTIyLUOyKb0m
 y0rUKLos
 dIMQRh77VZ6gqAGddzHIP3sSiPxpKgrmYi3go9Ds8VCWkVTIV0S2eJsTV2sNUT02i3Ky8vcwI77YqrVwsrhi1TYiPZo63iBVGEhuKj+9CuJstzicCbDkMovU/lkhIijzpiOaBHJcaB3xH3ZY/kXJ2XgMtDBQb1KCzNZh7UQyIJxYSedd3biFNQYeGyY8lsFTeLzuhLyBvrikQJEmUpS/0puRzEjoZz8GaI/qTmWG8euVF/C27XQ3k+BpGYq9Kvw5XpJ5J7R1QYIAKcgeAmoe2bkoSUsW5QMVEv1DdYb4E0WP/qofR1PfwoUA8eJM2DrPHAPBbU15kVNlvYd11vXM4oW9DFX96enRD4uZ/yrIX/nv1iGybD4t3JCh2jDP4LlZdvQfcrS6HmBhYLdpuK+mJxCG5w0vd3CB9GsqolQynZk7PAEOfr7uq7haHBsZDQNwBJf9X5xecM5z4rQUGLqysvX/LUGscsI5HMQN0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enable batch clearing of PTEs and batch swap setting of PTEs for anon
swap-backed folio unmapping.

Processing all PTEs of a large folio in one go helps us batch across
atomics (add_mm_counter() etc), barriers in __folio_try_share_anon_rmap(),
and repeated calls to page_vma_mapped_walk(). In general, batching helps
execute similar code together, making the path more memory and CPU
friendly.

On arm64-contpte, batching also helps avoid redundant ptep_get() calls
and TLB flushes while breaking the contpte mapping.

The handling of anon-exclusivity is very similar to commit cac1db8c3aad
("mm: optimize mprotect() by PTE batching"). Since
folio_unmap_pte_batch() does not look at the bits of the underlying page,
process sub-batches of PTEs pointing to pages with the same exclusivity
state, and batch set only those PTEs to swap PTEs in one go.

Disable batching for sparc (because of arch_unmap_one), we will batch this
later.

Rmap accounting and reference accounting must happen when anon folio unmap
succeeds. If a large folio is only partially batched or a later sub-batch
fails, account only the pages that were actually unmapped.

If the batch length is less than the number of pages in the folio, skip
over this batch. page_vma_mapped_walk() handles this: check_pte() returns
true only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the
PTE. Swap PTEs have no underlying PFN, so check_pte() returns false until
the walk reaches the next present PTE to unmap.

Remove the finish_unmap label since no goto callers are left now.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 118 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 32 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 98690947ef19..818aecfa820b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1982,12 +1982,13 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pte_table_clamped_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree or file folios batching for now ... */
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
+	if (pte_unused(pte))
 		return 1;
 
-	if (pte_unused(pte))
+#ifdef __HAVE_ARCH_UNMAP_ONE
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+#endif
 
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
@@ -2158,16 +2159,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
 	return swp_pte;
 }
 
-static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+static void finish_folio_unmap_batch(struct vm_area_struct *vma,
+		struct folio *folio, struct page *page, unsigned long nr_pages)
+{
+	folio_remove_rmap_ptes(folio, page, nr_pages, vma);
+	if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
+		mlock_drain_local();
+	folio_put_refs(folio, nr_pages);
+}
+
+static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long address,
-		pte_t *ptep, pte_t pteval)
+		pte_t *ptep, pte_t pteval, unsigned long nr_pages,
+		bool anon_exclusive)
 {
-	const bool anon_exclusive = folio_test_anon(folio) &&
-				    PageAnonExclusive(page);
 	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
+	pte_t swp_pte;
 
-	if (folio_dup_swap_pages(folio, page, 1) < 0)
+	if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
 		return false;
 
 	/*
@@ -2176,25 +2186,61 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	 * so we'll not check/care.
 	 */
 	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-		folio_put_swap_pages(folio, page, 1);
+		VM_WARN_ON(nr_pages != 1);
+		folio_put_swap_pages(folio, page, nr_pages);
 		return false;
 	}
 
 	/* See folio_try_share_anon_rmap(): clear PTE first. */
-	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
-		folio_put_swap_pages(folio, page, 1);
+	if (anon_exclusive &&
+	    folio_try_share_anon_rmap_ptes(folio, page, nr_pages)) {
+		folio_put_swap_pages(folio, page, nr_pages);
 		return false;
 	}
 
 	mm_prepare_for_swap_entries(mm);
-	dec_mm_counter(mm, MM_ANONPAGES);
-	inc_mm_counter(mm, MM_SWAPENTS);
-	set_pte_at(mm, address, ptep,
-		   swp_pte_prepare(entry, pteval, anon_exclusive));
+	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+	add_mm_counter(mm, MM_SWAPENTS, nr_pages);
+	swp_pte = swp_pte_prepare(entry, pteval, anon_exclusive);
+	set_softleaf_ptes(mm, address, ptep, swp_pte, nr_pages);
 	return true;
 }
 
-static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+static unsigned long ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *first_page,
+		unsigned long address, pte_t *ptep, pte_t pteval,
+		unsigned long nr_pages)
+{
+	unsigned long batch_idx = 0;
+	unsigned long nr_to_unmap = nr_pages;
+
+	while (nr_pages) {
+		bool exclusive;
+		unsigned long len = page_anon_exclusive_batch(batch_idx,
+				nr_pages, first_page, &exclusive);
+
+		if (!__ttu_anon_swapbacked_folio(vma, folio,
+				first_page + batch_idx, address, ptep, pteval,
+				len, exclusive)) {
+			/* Restore the remaining PTEs that were cleared. */
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return nr_to_unmap - nr_pages;
+		}
+
+		nr_pages -= len;
+		if (!nr_pages)
+			break;
+
+		pteval = pte_advance_pfn(pteval, len);
+		address += len * PAGE_SIZE;
+		batch_idx += len;
+		ptep += len;
+	}
+
+	return nr_to_unmap;
+}
+
+static unsigned long ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 		struct page *page, unsigned long address, pte_t *ptep,
 		pte_t pteval, unsigned long nr_pages)
 {
@@ -2203,15 +2249,21 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 	 * See handle_pte_fault() ...
 	 */
 	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
-			 folio_test_swapcache(folio)))
-		return false;
+			 folio_test_swapcache(folio))) {
+		set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+		return 0;
+	}
 
-	if (!folio_test_swapbacked(folio))
-		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+	if (!folio_test_swapbacked(folio)) {
+		if (!ttu_anon_lazyfree_folio(vma, folio, nr_pages)) {
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return 0;
+		}
+		return nr_pages;
+	}
 
-	/* nr_pages > 1 not supported yet */
 	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
-					 pteval);
+					 pteval, nr_pages);
 }
 
 /*
@@ -2380,13 +2432,18 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			if (!ttu_anon_folio(vma, folio, page, address,
-					    pvmw.pte, pteval, nr_pages)) {
-				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+			unsigned long nr_unmapped = ttu_anon_folio(vma, folio,
+						    page, address, pvmw.pte,
+						    pteval, nr_pages);
+
+			if (!nr_unmapped)
 				goto walk_abort;
-			}
 
-			goto finish_unmap;
+			/* partial success: finish for nr_unmapped and abort. */
+			if (nr_unmapped < nr_pages) {
+				finish_folio_unmap_batch(vma, folio, page, nr_unmapped);
+				goto walk_abort;
+			}
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2401,11 +2458,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-finish_unmap:
-		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
-			mlock_drain_local();
-		folio_put_refs(folio, nr_pages);
+
+		finish_folio_unmap_batch(vma, folio, page, nr_pages);
 
 		/*
 		 * If we are sure that we batched the entire folio and cleared
-- 
2.43.0


