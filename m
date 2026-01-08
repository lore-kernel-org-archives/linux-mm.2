Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A683D185F8
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE506B0093; Thu,  8 Jan 2026 08:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91716B0095; Thu,  8 Jan 2026 08:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5186B0096; Thu,  8 Jan 2026 08:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC1196B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:37:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5334C135D9B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:37:05 +0000 (UTC)
X-FDA: 84308897610.02.C1BBDB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91C68A0009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:37:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ZeoA+uRG;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767879423; a=rsa-sha256;
	cv=none;
	b=KHfD8f602NtjrX0gvvfdfVMm/H9CQHIUz19XHLOqWwVOqLB0h5Xe65Q6rZey35kNq/w/+o
	rNN4NVruw4KTZjdPVtGrVdsr8g3H1sgMD0O+15LJt97jJeb4KDYQOToOVczMKB7UzHRU70
	HVwxYHfsAyaEd9VgKMVuy6t3iEps3AQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ZeoA+uRG;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767879423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=iuQj2q22zUmyEYu5YFZ/yWGFw9MAi15l3nal7ixpH58=;
	b=j8JC313TlQ+hmJv5Idorg7qckuZJUd7It2aPtzf0AypFA9fkTEgehqDrdZWtef43YdqzIX
	UOnaVj49P+HDTvecma8m8Sb3x0TlkPkAZviLP/ouS82JLRXvOSgFYQLSR0qMAqCfLZJLBx
	Dbrha9HgZF/9SjGQNtg1ApuT/QKEDWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCAC94394B;
	Thu,  8 Jan 2026 13:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F138C116C6;
	Thu,  8 Jan 2026 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767879422;
	bh=t7J0TVUXooyegmOpUhdvRGPufZ6P+rcP3pmOwloUk4c=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ZeoA+uRG6Sj4tnKAx+tKpMHYXcn543wheDaFE7uvRByAxfr4riMp148tZxPMaTdvy
	 VPy7yb2KI+cQzvZJB71oHclr1WOwgNCnRvNBgn9qtLR+9M2Xu/jsZtcUomj48RfDKz
	 qpkuer7bUNVwfeEgEWRuDljsY/a+Q0M3gkB+S82U=
Subject: Patch "mm/mprotect: use long for page accountings and retval" has been added to the 6.1-stable tree
To: Liam.Howlett@oracle.com,aarcange@redhat.com,akpm@linux-foundation.org,axelrasmussen@google.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,david@kernel.org,david@redhat.com,dev.jain@arm.com,gregkh@linuxfoundation.org,harry.yoo@oracle.com,hughd@google.com,jane.chu@oracle.com,jannh@google.com,jthoughton@google.com,kas@kernel.org,lance.yang@linux.dev,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mike.kravetz@oracle.com,nadav.amit@gmail.com,npache@redhat.com,peterx@redhat.com,pfalcato@suse.de,ryan.roberts@arm.com,songmuchun@bytedance.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 08 Jan 2026 14:36:38 +0100
In-Reply-To: <20260106114715.80958-2-harry.yoo@oracle.com>
Message-ID: <2026010838-rake-dotted-6c9b@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: 91C68A0009
X-Rspam-User: 
X-Stat-Signature: 4ygftoqw1czc6p6ytdss7pdryxusrniz
X-Rspamd-Server: rspam07
X-HE-Tag: 1767879423-241953
X-HE-Meta: U2FsdGVkX1/lE9r3oAy1JhpsU4NFb1QGmnMWtwkxLmFzJGFIN5Z2V63XYke8sIGbzd87POgPSvJZlerRLyJcpnJYoiDw43xgsvYPJ/Xuig3C5OSlaMjUo/asD8LRvW0+dQntnqiFqdCNej2V+m2cVvJh5cwgxhsEJBS/3phJHtCs4tBTAeA1paGy+XOqZ1VCt572rPCUwZNJk9ZdKcQF+2a+N6viB90dxiM0ZF5iwUzHSLoaPdXkxPf8d4t+w8XzIVpBgCX1ElqWFn+WnegVCy3NnRWOAIk2/V2ZKhlDil2bCHWpqivZ3K0FNk3XuAaX7PH0JhFo0MmpDnfLDckdWjQq40s7/Mx7fkiWScbhlB9ro100Y40D9EFll8jQg68WDZ6SRIbFRnthC6tUiNZ5/e0NYYMV1hO7hlzoMwCSm9eeRQ0zpbcQg2GbtnAj0dpeHMXwx16BDCxJLkE59VM/dAYLEXTZKfR+DGYH2NyWrIXZ1hwfdhO19uk0uHZ2OcOg7u1Gupw7Zg0YcXiond7MqiVp1dPWvzWfGj+zAyLpMB7aHkuNvJI2pxvMXnru/cav4GlMIfs1dGWK6lkoBsDH9+jCklOwAgo8g1Ajc/bm3ompLuqJMx4ftKtvSeLFhETAE1J0nEmLPKsHFiLjWkD2ka7OeOFkoe/Sse0sgYX+L7wF2zOYld12xDofT+RxqGCYE+PazNA7gIkqnV3+Sa7NuYXm43gXiO3+q/H1Th9KczwJ87eZHrvp+bWHp7XMT9FAE18yr6i0i231PmzGHlhWscZ8OTJWs1hVTRj0fp7bgYsGP6v+n6x3z6MNIgJY4ZZgT3dxMDDe9J0/6P8+LD75AJ58iqAtHY+/iZKNNAcvoQJTyrCo1sCd4amwukr8aqv0OcbqpdgaYwooCz/HjCNc2aybnxPVOieh7XiVTVBubHv18T3hccC7oA5y9/ksTvZK0RIEVgOaWCYRT8EQhXK
 oKozIG3C
 HiF1N+9HHnFhZDaczR0DSBSreDb1b7FptuHRfNJFINrY/yH9cTCLtfNOlERISZ5jKz1xDYZQwYVQISpsaA8W8hLsto024b5H/KW6wwx9pB4oeNb0zMUlDsg7HVEuHZHxkU0GIJsPOnQGg2AWyDX7PDx24KMV58hPi0dC96uPJkYX+Cdkfr5gpkGaoUuX6QmMTdczloqW6a+YJQ5Z60v1Ih1+VT4f4yMvTXaE3L7Cpl4ylLar5yTrz8MHbxqPl3rMe3RUTt8Se+hVfjJvrH9OEZc9UkraOgnZ68OWhRzJNo/5Nz7pXQi3fr5n/EbErsOr28MwJPkQm5oeucxjzLa2uN0f2wkks9sQjDgHdoOv92xOumgGikljGxAnPD+6qpRgfsNs5vVvbavJ24QY77bx6ww0xzg9C/1nBwKz6FHzpQY31Fmbsp5wExcEiuzqOwICzMweFj09W43j2ZOFlq+5D5Z1oCRMrQh5uNTATs/s5f4YU4Ti1wgvUJQciaEw9Yk5YXqX7wkpnh/bqNki0XIO9giwIxPyec7cVKhNuwfHwoFefSuq1nSR5l7Ifev7feN7531qHn2dBcfjqguJ355uq0iqaMeSE64+KTHTievNZm2n3DUFWrvRy7tdfRGN/0O0URK3bBLXAFmi1U2YBmrxrN/93y2a4iQNd9EH9QVlfgAQclIqZs+CJLL7oB1tYvam8qPkWkO1Bgyxjq2g6VEZJXvpEetEucRqFgtKT6XHKMUIqGRI+/o6WDLm/g1TLVs98icL4YewDesFShMzRbinvxX6gx0LbiEJTw5BnMVLhXxf4RGQ5lptYW6TABwdIafziyMPWg5pofAZHTxLEVs6zJT00Pge2ZhdfA2PZPw8tSFWrnH3NGe2HmoEZow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: use long for page accountings and retval

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-use-long-for-page-accountings-and-retval.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-205075-greg=kroah.com@vger.kernel.org Tue Jan  6 12:48:24 2026
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue,  6 Jan 2026 20:47:13 +0900
Subject: mm/mprotect: use long for page accountings and retval
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, Peter Xu <peterx@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, Muchun Song <songmuchun@bytedance.com>, Nadav Amit <nadav.amit@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Message-ID: <20260106114715.80958-2-harry.yoo@oracle.com>

From: Peter Xu <peterx@redhat.com>

commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.

Switch to use type "long" for page accountings and retval across the whole
procedure of change_protection().

The change should have shrinked the possible maximum page number to be
half comparing to previous (ULONG_MAX / 2), but it shouldn't overflow on
any system either because the maximum possible pages touched by change
protection should be ULONG_MAX / PAGE_SIZE.

Two reasons to switch from "unsigned long" to "long":

  1. It suites better on count_vm_numa_events(), whose 2nd parameter takes
     a long type.

  2. It paves way for returning negative (error) values in the future.

Currently the only caller that consumes this retval is change_prot_numa(),
where the unsigned long was converted to an int.  Since at it, touching up
the numa code to also take a long, so it'll avoid any possible overflow
too during the int-size convertion.

Link: https://lkml.kernel.org/r/20230104225207.1066932-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Adjust context ]
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    4 ++--
 include/linux/mm.h      |    2 +-
 mm/hugetlb.c            |    4 ++--
 mm/mempolicy.c          |    2 +-
 mm/mprotect.c           |   26 +++++++++++++-------------
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -233,7 +233,7 @@ void hugetlb_vma_lock_release(struct kre
 
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags);
 
@@ -447,7 +447,7 @@ static inline void move_hugetlb_state(st
 {
 }
 
-static inline unsigned long hugetlb_change_protection(
+static inline long hugetlb_change_protection(
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot,
 			unsigned long cp_flags)
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2148,7 +2148,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
-extern unsigned long change_protection(struct mmu_gather *tlb,
+extern long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      unsigned long cp_flags);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6668,7 +6668,7 @@ long follow_hugetlb_page(struct mm_struc
 	return i ? i : err;
 }
 
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
@@ -6677,7 +6677,7 @@ unsigned long hugetlb_change_protection(
 	pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	unsigned long pages = 0, psize = huge_page_size(h);
+	long pages = 0, psize = huge_page_size(h);
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -628,7 +628,7 @@ unsigned long change_prot_numa(struct vm
 			unsigned long addr, unsigned long end)
 {
 	struct mmu_gather tlb;
-	int nr_updated;
+	long nr_updated;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -72,13 +72,13 @@ static inline bool can_change_pte_writab
 	return true;
 }
 
-static unsigned long change_pte_range(struct mmu_gather *tlb,
+static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
-	unsigned long pages = 0;
+	long pages = 0;
 	int target_node = NUMA_NO_NODE;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
@@ -346,13 +346,13 @@ uffd_wp_protect_file(struct vm_area_stru
 		}							\
 	} while (0)
 
-static inline unsigned long change_pmd_range(struct mmu_gather *tlb,
+static inline long change_pmd_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 	unsigned long nr_huge_updates = 0;
 	struct mmu_notifier_range range;
 
@@ -360,7 +360,7 @@ static inline unsigned long change_pmd_r
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		unsigned long this_pages;
+		long this_pages;
 
 		next = pmd_addr_end(addr, end);
 
@@ -430,13 +430,13 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct mmu_gather *tlb,
+static inline long change_pud_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	pud = pud_offset(p4d, addr);
 	do {
@@ -451,13 +451,13 @@ static inline unsigned long change_pud_r
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct mmu_gather *tlb,
+static inline long change_p4d_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
@@ -472,14 +472,14 @@ static inline unsigned long change_p4d_r
 	return pages;
 }
 
-static unsigned long change_protection_range(struct mmu_gather *tlb,
+static long change_protection_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -498,12 +498,12 @@ static unsigned long change_protection_r
 	return pages;
 }
 
-unsigned long change_protection(struct mmu_gather *tlb,
+long change_protection(struct mmu_gather *tlb,
 		       struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       unsigned long cp_flags)
 {
-	unsigned long pages;
+	long pages;
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-6.1/mm-simplify-folio_expected_ref_count.patch
queue-6.1/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-6.1/mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
queue-6.1/mm-mprotect-use-long-for-page-accountings-and-retval.patch
queue-6.1/mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch

