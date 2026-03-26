Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E64109E52F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F5D6B0089; Wed, 25 Mar 2026 20:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320076B008C; Wed, 25 Mar 2026 20:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235A86B0092; Wed, 25 Mar 2026 20:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9B46B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:25:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DEF18CB7E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:25:06 +0000 (UTC)
X-FDA: 84586319412.23.C9D86E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C024C180016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:25:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r5mCPAkQ;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774484705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Dg8NgY0Z9WlM1M+isZ3vRyRJPtPFXjoO/ekkGVD53k=;
	b=5I8rr/v6rQJfQ6KZ5RIKAMBCH2GSdWkqS1NFI/WdZHACAjbyKGuOGO0Gt6VcO5fuxg/Yym
	i30fN8wwkter1jYb1vRmS9hpJO/W58LamXrIzHPabpljdAHJ5XncnqqTjzCNmdZclysdGU
	yx2gWCXk+bH5I7YYVglLl5J8o2eP5P4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r5mCPAkQ;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774484705; a=rsa-sha256;
	cv=none;
	b=dwX2MPjR1DR2FrEoWZbSogZVmR/bRVsT+jmoJn/X/0miqHc0fN2kW8r+yCqliSo1y0wsBK
	EfFkjAXHWpA2OJz7oPpzGME6XVw5HnRU95hYS94QiZU8iGVkPkQ/uUu5cZOpJ4cs3cScWH
	qXfzBX8V5p1VYu1KKdCQW8EDaCde9Kw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4572C4424C;
	Thu, 26 Mar 2026 00:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A18C4CEF7;
	Thu, 26 Mar 2026 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774484703;
	bh=jw10rFuWh7AsZhfu1sKiKIvAy3LPVihvatPrrfiKFLc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r5mCPAkQne0USNTuu/AZVcKbCG0T9TWkBm8kbK/GAKN3MTLKUZy0npSosa5zlCJl7
	 V5A26W0Eq8bPTwdGZ5W0f+0VVhJUmi5EFHJ1iaxH5S6Jj56Dbn/aaCXy4XZ4PKFNyx
	 aZXWKHTumk2XC+gW+wI0O8ZTM6EhI9pW+t9cMKmg=
Date: Wed, 25 Mar 2026 17:25:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
 hughd@google.com, jackmanb@google.com, jack@suse.cz, jannh@google.com,
 jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
 lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, Roman
 Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH mm-unstable v4 0/5] mm: khugepaged cleanups and mTHP
 prerequisites
Message-Id: <20260325172500.990e240d813a4b2db300e0e9@linux-foundation.org>
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
References: <20260325114022.444081-1-npache@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C024C180016
X-Stat-Signature: dagje5415qcwia56x8i8facr79636ux8
X-Rspam-User: 
X-HE-Tag: 1774484704-951246
X-HE-Meta: U2FsdGVkX18fxRHcT0FEHBeJB5dDeuHmPfw7YX/PjvxHNeILExopab27SMPc3XpHiBH8zxnsKc1b6PkheRc93O7DXXIjrI9wULYjHCQnqY/sYsG6lQ86L/EViXeFV/JfMWPwirYetGfc8O9lVqdxcVHX+Gj/NCtmE9BZ562Dp110s7MFaTl29t9QrXJ+dinQKzVUnyPAe145s459e8XS4kdluuIkI2CX055btUXbjPNlmDDOuurQ4alItTK/DVs/Lfp09U1gnEbJ+8z7M3JeVZIecNfQke880+FnU1/xei+kigjydjkzlaCJAJ8vQgvS7zZuEkWQhUpAga+/rIR/XQ48PeKK1qB+xG0OZmsT+PjpB7yU/XXs7fTdr5UCnc3x+LVzoraq//vPa10VMdC1uzXA00Wx6CJD2PspmHJVo2rF4wSl4PAquCRgBTfRIZOtRxsB6PJCIZk80z43YrG/DPBC7RMM7K5yo6wMA+Q91gsocjigjHHSrk3uIJbFm7v5V0QNgWurlpBoVtSGt/FWeqLdVLD8S4nnEayHjcsWnusj2RP29aWx4k1RuD5h8/UlreDityQFVGe8eP+hQXDFIGV95pOhxNTrfz1ob4VI9V50ciswx9ib7BIil1BhaZzUV9X6pvioziU94sfATEg1HZKjXmcAUX4H8X1mBz+Zl2owY3gw0Kz0CQ8zamEHAuLyL/O4EE2HBdtfKJYW7E9/MrSadpArR1bO7dxLfoV+9aeg99HVuq3E3+JUoVvACiZgvd98Xhi6XHX1flDQf11cGEmXKbynjEwrBoAdUx4+X4eMJm5ohjONbi+LFSkS8UJVYli6efouCLdejYxQgc6yPsj8kwrcnfibuljB47MHL82y2mgVuHjaYEPsA1nsSTCPGL8VC8DWGKn9W4VmjBWocr4wnPAblBMr5ehy4AlS0z49w7AnuuTM4FU6wjUCpx9USks6tSb55XpmaqYmexv
 DpXMZ3p8
 VyxjpTpZPksCX6r8zabx5+n+R5ohUjSPi57fPy40mh7SzsB1ok7ilaECG2IdxEGQ5bNUTBFlYyUWz5fVg6EpW2z18zCg51zLZIUcdvhKW9Zm7uGkpqMpPp932m9hBuz6RYgbMbcy8ujzhR5Fd8HKFdinyzUD23ktVWZ6SxR0QRQH6iz+YxFBd882gCpMhHtXA9MwPz+QvrSPeADUieMFU7agNfXxNMpEO06BhtPjxA3MjsCm/btkIb3hts8kNyToVAkwucUXXA6Z+37NTEUCcuTVrHhQ1dPZWukLz7sgQzW5T99RX1zzGmgLFFfcCyRMYv4oYd68Cg03QU3iZPr6QkuvZ6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 05:40:17 -0600 Nico Pache <npache@redhat.com> wrote:

> MAINTAINER NOTE: This is based on mm-unstable with the coresponding
> patches reverted then reapplied.

Unfortunately the update-in-place trick fooled AI review, which might
have been useful.  Oh well.  In retrospect we could have avoided that
by you asking me to drop v3 a couple of days before mailing out v4.

otoh, this series *does* apply to the mm-stable branch.  Roman, I
though Sashiko is attempting that?

> The following series contains cleanups and prerequisites for my work on
> khugepaged mTHP support [1]. These have been separated out to ease review.

And boy that's a lot of reviewers!  Aren't you a lucky ducky ;)

> The first patch in the series refactors the page fault folio to pte mapping
> and follows a similar convention as defined by map_anon_folio_pmd_(no)pf().
> This not only cleans up the current implementation of do_anonymous_page(),
> but will allow for reuse later in the khugepaged mTHP implementation.
> 
> The second patch adds a small is_pmd_order() helper to check if an order is
> the PMD order. This check is open-coded in a number of places. This patch
> aims to clean this up and will be used more in the khugepaged mTHP work.
> The third patch also adds a small DEFINE for (HPAGE_PMD_NR - 1) which is
> used often across the khugepaged code.
> 
> The fourth and fifth patch come from the khugepaged mTHP patchset [1].
> These two patches include the rename of function prefixes, and the
> unification of khugepaged and madvise_collapse via a new
> collapse_single_pmd function.
> 
> Patch 1:     refactor do_anonymous_page into map_anon_folio_pte_(no)pf
> Patch 2:     add is_pmd_order helper
> Patch 3:     Add define for (HPAGE_PMD_NR - 1)
> Patch 4:     Refactor/rename hpage_collapse
> Patch 5:     Refactoring to combine madvise_collapse and khugepaged
> 

Thanks, I updated mm.git's mm-unstable branch to this version.

> V4 Changes:
>  - added RB and SB tags
>  - Patch1: commit message cleanup/additions
>  - Patch1: constify two variables, and change 1<<order to 1L<<..
>  - Patch1: change zero-page read path to use update_mmu_cache varient
>  - Patch5: remove dead code switch statement (SCAN_PTE_MAPPED_HUGEPAGE)
>  - Patch5: remove local mmap_locked from madvise_collapse()
>  - Patch5: rename mmap_locked to lock_dropped in ..scan_mm_slot() and
>    invert the logic. the madvise|khugepaged code now share the same 
>    naming convention across both functions.
>  - Patch5: add assertion to collapse_single_pmd() so both madvise_collapse
>    and khugepaged assert the lock.
>  - Patch5: Convert one of the VM_BUG_ON's to VM_WARN_ON

Below is how v4 altered mm,git:

 mm/khugepaged.c |   34 +++++++++++++++-------------------
 mm/memory.c     |   11 +++++------
 2 files changed, 20 insertions(+), 25 deletions(-)

--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -1250,7 +1250,7 @@ out_nolock:
 
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, struct collapse_control *cc)
+		bool *lock_dropped, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1425,7 +1425,7 @@ out_unmap:
 		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
@@ -2422,7 +2422,7 @@ static enum scan_result collapse_scan_fi
  * the results.
  */
 static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *mmap_locked,
+		struct vm_area_struct *vma, bool *lock_dropped,
 		struct collapse_control *cc)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -2431,8 +2431,10 @@ static enum scan_result collapse_single_
 	struct file *file;
 	pgoff_t pgoff;
 
+	mmap_assert_locked(mm);
+
 	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
+		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 		goto end;
 	}
 
@@ -2440,7 +2442,7 @@ static enum scan_result collapse_single_
 	pgoff = linear_page_index(vma, addr);
 
 	mmap_read_unlock(mm);
-	*mmap_locked = false;
+	*lock_dropped = true;
 retry:
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
@@ -2537,21 +2539,21 @@ static void collapse_scan_mm_slot(unsign
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool mmap_locked = true;
+			bool lock_dropped = false;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
-			VM_BUG_ON(khugepaged_scan.address < hstart ||
+			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
-						      vma, &mmap_locked, cc);
+						      vma, &lock_dropped, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (!mmap_locked)
+			if (lock_dropped)
 				/*
 				 * We released mmap_lock so break loop.  Note
 				 * that we drop mmap_lock before all hugepage
@@ -2826,7 +2828,6 @@ int madvise_collapse(struct vm_area_stru
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_locked = true;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2849,10 +2850,10 @@ int madvise_collapse(struct vm_area_stru
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
-		if (!mmap_locked) {
+		if (*lock_dropped) {
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_locked = true;
+			*lock_dropped = false;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2862,12 +2863,8 @@ int madvise_collapse(struct vm_area_stru
 
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
-		mmap_assert_locked(mm);
-
-		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
 
-		if (!mmap_locked)
-			*lock_dropped = true;
+		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
 
 		switch (result) {
 		case SCAN_SUCCEED:
@@ -2876,7 +2873,6 @@ int madvise_collapse(struct vm_area_stru
 			break;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_NO_PTE_TABLE:
-		case SCAN_PTE_MAPPED_HUGEPAGE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
@@ -2897,7 +2893,7 @@ int madvise_collapse(struct vm_area_stru
 
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (!mmap_locked)
+	if (*lock_dropped)
 		mmap_read_lock(mm);
 out_nolock:
 	mmap_assert_locked(mm);
--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -5201,7 +5201,7 @@ void map_anon_folio_pte_nopf(struct foli
 		struct vm_area_struct *vma, unsigned long addr,
 		bool uffd_wp)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	const unsigned int nr_pages = folio_nr_pages(folio);
 	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
 
 	entry = pte_sw_mkyoung(entry);
@@ -5221,10 +5221,10 @@ void map_anon_folio_pte_nopf(struct foli
 static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr, bool uffd_wp)
 {
-	unsigned int order = folio_order(folio);
+	const unsigned int order = folio_order(folio);
 
 	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1 << order);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1L << order);
 	count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);
 }
 
@@ -5239,7 +5239,7 @@ static vm_fault_t do_anonymous_page(stru
 	unsigned long addr = vmf->address;
 	struct folio *folio;
 	vm_fault_t ret = 0;
-	int nr_pages = 1;
+	int nr_pages;
 	pte_t entry;
 
 	/* File mapping without ->vm_ops ? */
@@ -5279,8 +5279,7 @@ static vm_fault_t do_anonymous_page(stru
 		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
 
 		/* No need to invalidate - it was non-present before */
-		update_mmu_cache_range(vmf, vma, addr, vmf->pte,
-				       /*nr_pages=*/ 1);
+		update_mmu_cache(vma, addr, vmf->pte);
 		goto unlock;
 	}
 
_


