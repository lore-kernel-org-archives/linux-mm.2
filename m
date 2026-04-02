Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADFED6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA4E6B0089; Thu,  2 Apr 2026 14:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A946B008A; Thu,  2 Apr 2026 14:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC84B6B008C; Thu,  2 Apr 2026 14:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEEE76B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:33:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73CDA8C58E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:33:32 +0000 (UTC)
X-FDA: 84614463864.04.D3880A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A3F3C180008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:33:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j65zHUVH;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775154810; a=rsa-sha256;
	cv=none;
	b=ZwJ3zmTHsL7XOZkUzJ9y3/HCZkHYlWedI8eVuJs5fNqD0MvH3N2hTEX1L1vFE7EjDz+ItV
	p9hCcNqdW5Iytg8hXa+k0Fr5t+9S3mj3bQEpG56DkXWzd2IfpOhGCcAzQFV9bfVkZUETlj
	5ibTmW5kHVsYNElYAiGapD+uXExwbI8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775154810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftdSxb+/sSAGRLegpQONI8uHhIOmWARu1uVvseaoz7I=;
	b=A1VK+7tISwLQFDiJpg/Sw6ghzNKLw3qskFbgZLkWmNnTF/2LHnqIOrGRkX9Ox6akMFyQmm
	vPMe8xj6771WtWIkjz9wsvf/sWsbHicXN0pobnNx2d+gbBKaqOznzs9NHWu90uRWGxMijC
	USEHa9A6vpW7CX8PppVhveSoe7Bjo6o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j65zHUVH;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81661417BB;
	Thu,  2 Apr 2026 18:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006D7C116C6;
	Thu,  2 Apr 2026 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775154809;
	bh=XUv3Z3Jtd1F2MucMar5hI1RSUbO5dRrpr4nSj0smcv0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j65zHUVHwo5lEoQ9Vqth+zkTpszqmpL4oWe/6D0Z07y6npPuatlFRTNRVLQxFiQD6
	 2Hmr5FVcRcmYVMMIjlx+vubLa1/MRNaOyi4LplSisZRWFzlMtFGnBCmuU6K5zfNYtT
	 LrXxk1StrADXngamZmF39+yy7Uhc14+3jYKHW9p8=
Date: Thu, 2 Apr 2026 11:33:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, David Hildenbrand <david@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/mprotect: micro-optimization work
Message-Id: <20260402113328.fd0a6f0e28cf74a651fa2291@linux-foundation.org>
In-Reply-To: <20260402141628.3367596-1-pfalcato@suse.de>
References: <20260402141628.3367596-1-pfalcato@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3F3C180008
X-Stat-Signature: y9sr7518jyqyjsxn56nrw3jbzoq17xj4
X-HE-Tag: 1775154810-897658
X-HE-Meta: U2FsdGVkX18TMKDT0MDWZHHqrhcQDtbvgQ5mb9RYo9Zdce4Xj66FmG//fIvr0qIQID4nDoTKJT1uC2qMXCvhNHizD76Z6qhM+CVJiAVmJRBxfnmT4NF2cdo54tfIfOrmaTHXa12eFDMPVMFqs+b5xjGmYGxHwoKK3BP323INJKebRKccAEE/jKfFlqXFCKXBsl5eHIWs/MQuIDB+TX/7Se/WCDOiqzFaU02EWhNTJlyMyahP6nqNEr1KUqS3UdVD0szng1dIlGmwGhw6xuJny0Uqe3t041t0CY4hOijDhWVw3sA1wPtPBu9u2TBFf+7s1PSvrsKB5yfKA+MFzNj7NbrFQ8TNXvBhAFCyt7TWPN8/FYTDu810s5qAbloKV7EicNE4yle8PuzwziutD9GCs/V/qgPXREOmOfMHIra45QYPvUV/yghEJ2XuaXsSdu5JY5KKyF0o/xBdceP+6grMVjQV8TY/ufZYP49Vha8L3QvMommiz0XnsyNGYRjigF6F4sv6HelmPCwpje4xyuZIqV3CGEYVh3JT7yWSaX7uPBzgmUJ60ViDipWX8WGgLGQZEZOskUtwuebIJqiLtJsoI69rVQbSFQBaxtGQ7FeBewlA+QWQgH22BlxA9EF95xDLJSZHotsJRePIaJeWWanmY/Py+5XtCCX1J8mrO0SZC6OTovhUptxKj7Yh9kp6HlpbmEzkhpbO6QdXbm2fWv2fAhFayjtd00aYinXpq1Pdpad+xm99txAuWPzBBIC/Kc/Miunc+4Y6Za88+iT6/0coN0FIbCm1jYM2FxhJwQBm9eo6RHMCpfG1cgWcFpoHrx1yUWhAy6IhY4NzXR/3n/kgjnsGcZvQ3WxBLj1xde1AMT+/DqbzJny3Aj6EicjeIK4/usKf5AI8IWZRza1UgNOfUph6maIhfAQzyXYeK1mo4iK/dqRv5RLh8yRx5Xw8B+yi9Ac/IW1I746+D5R0L2K
 fg4NLjS5
 qEMoHJ4P58/0yvXzzILu28EM2lmzxIC0oDAEXN0/xBtWWNAbEA2Eut6LPqCMdxRXvF+DSlOwJyn8dnmWGrzxnqAyV7tbczyhmUnFr3+C5eyoQ+TPD64EjBPMHPIYgLvjagsMTSGURfc1oyer7iTAjIAetTFaiQZPy+VMaFP57koQV5txPzujcAPeIioemRNbgvyOCts6GT72604o3jYrm7/Fg974rGbiFVkFTokl1POEICfDlsBk+s1QZrPQ+eDg0E6P7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 15:16:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> Micro-optimize the change_protection functionality and the
> change_pte_range() routine. This set of functions works in an incredibly
> tight loop, and even small inefficiencies are incredibly evident when spun
> hundreds, thousands or hundreds of thousands of times.

Thanks, I updated mm.git's mm-unstable branch to this version.

The update is rather large.  If people think it best to spill this work
into next -rc1 then please advise.

> 
> v3:
>  - Collapse a few lines into a single line in patch 1 (David)
>  - Bring the inlining to a higher level (David)
>  - Pick up David's patch 1 ACK (thank you!)
>  - Pick up Luke Yang's Tested-by (thank you!)
>  - Add Luke's results and akpmify the Links: a bit (cover letter)

Here's how v3 altered mm.git:

 mm/mprotect.c |   98 +++++++++++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 42 deletions(-)

--- a/mm/mprotect.c~b
+++ a/mm/mprotect.c
@@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_a
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
 	/* No underlying folio, so cannot batch */
@@ -143,7 +143,7 @@ static __always_inline void prot_commit_
  * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
  * that the ptes point to consecutive pages of the same anon large folio.
  */
-static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
 		struct page *first_page, bool expected_anon_exclusive)
 {
 	int idx;
@@ -177,13 +177,6 @@ static __always_inline void commit_anon_
 	int sub_batch_idx = 0;
 	int len;
 
-	/* Optimize for the common order-0 case. */
-	if (likely(nr_ptes == 1)) {
-		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
-				       0, PageAnonExclusive(first_page), tlb);
-		return;
-	}
-
 	while (nr_ptes) {
 		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
 		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
@@ -195,7 +188,7 @@ static __always_inline void commit_anon_
 	}
 }
 
-static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
+static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -234,8 +227,7 @@ static long change_softleaf_pte(struct v
 		 * just be safe and disable write
 		 */
 		if (folio_test_anon(folio))
-			entry = make_readable_exclusive_migration_entry(
-					     swp_offset(entry));
+			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
 		else
 			entry = make_readable_migration_entry(swp_offset(entry));
 		newpte = swp_entry_to_pte(entry);
@@ -246,8 +238,7 @@ static long change_softleaf_pte(struct v
 		 * We do not preserve soft-dirtiness. See
 		 * copy_nonpresent_pte() for explanation.
 		 */
-		entry = make_readable_device_private_entry(
-					swp_offset(entry));
+		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpte = swp_entry_to_pte(entry);
 		if (pte_swp_uffd_wp(oldpte))
 			newpte = pte_swp_mkuffd_wp(newpte);
@@ -286,6 +277,45 @@ static long change_softleaf_pte(struct v
 	return 0;
 }
 
+static __always_inline void change_present_ptes(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		int nr_ptes, unsigned long end, pgprot_t newprot,
+		struct folio *folio, struct page *page, unsigned long cp_flags)
+{
+	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	pte_t ptent, oldpte;
+
+	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
+	ptent = pte_modify(oldpte, newprot);
+
+	if (uffd_wp)
+		ptent = pte_mkuffd_wp(ptent);
+	else if (uffd_wp_resolve)
+		ptent = pte_clear_uffd_wp(ptent);
+
+	/*
+	 * In some writable, shared mappings, we might want
+	 * to catch actual write access -- see
+	 * vma_wants_writenotify().
+	 *
+	 * In all writable, private mappings, we have to
+	 * properly handle COW.
+	 *
+	 * In both cases, we can sometimes still change PTEs
+	 * writable and avoid the write-fault handler, for
+	 * example, if a PTE is already dirty and no other
+	 * COW or special handling is required.
+	 */
+	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
+	     !pte_write(ptent))
+		set_write_prot_commit_flush_ptes(vma, folio, page,
+			addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	else
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent,
+			nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -296,7 +326,6 @@ static long change_pte_range(struct mmu_
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	int nr_ptes;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
@@ -317,7 +346,6 @@ static long change_pte_range(struct mmu_
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
 			struct page *page;
-			pte_t ptent;
 
 			/* Already in the desired state. */
 			if (prot_numa && pte_protnone(oldpte))
@@ -343,34 +371,20 @@ static long change_pte_range(struct mmu_
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
-			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
-			ptent = pte_modify(oldpte, newprot);
-
-			if (uffd_wp)
-				ptent = pte_mkuffd_wp(ptent);
-			else if (uffd_wp_resolve)
-				ptent = pte_clear_uffd_wp(ptent);
-
 			/*
-			 * In some writable, shared mappings, we might want
-			 * to catch actual write access -- see
-			 * vma_wants_writenotify().
-			 *
-			 * In all writable, private mappings, we have to
-			 * properly handle COW.
-			 *
-			 * In both cases, we can sometimes still change PTEs
-			 * writable and avoid the write-fault handler, for
-			 * example, if a PTE is already dirty and no other
-			 * COW or special handling is required.
+			 * Optimize for the small-folio common case by
+			 * special-casing it here. Compiler constant propagation
+			 * plus copious amounts of __always_inline does wonders.
 			 */
-			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
-			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio, page,
-				addr, pte, oldpte, ptent, nr_ptes, tlb);
-			else
-				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
+			if (likely(nr_ptes == 1)) {
+				change_present_ptes(tlb, vma, addr, pte, 1,
+					end, newprot, folio, page, cp_flags);
+			} else {
+				change_present_ptes(tlb, vma, addr, pte,
+					nr_ptes, end, newprot, folio, page,
+					cp_flags);
+			}
+
 			pages += nr_ptes;
 		} else if (pte_none(oldpte)) {
 			/*
_


