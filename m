Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90115CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2816B0089; Thu, 27 Nov 2025 09:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52646B008A; Thu, 27 Nov 2025 09:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41686B008C; Thu, 27 Nov 2025 09:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE6296B0089
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:05:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94BEF160165
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:05:20 +0000 (UTC)
X-FDA: 84156559200.09.85E927F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id ACDEC100015
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:05:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Qx2E87AA;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RLvWjQfMix2ZMVtAmK3mNxibuO3UNV5sEoWy2nnRHrE=;
	b=kiPvhiObCOAmlv9LLs5bWdmEOQcbnO6JIuPOVZdx9G46JiGe4c/8/Rrh6BtaYg1H8nHVKh
	fhS0bO393rvgXxZPYnoDb6LYn6RPpa4URSqGZxplY17TbpgDovgu0RzFmF8L5W41Wcc1l1
	fj84mc0X4mB1HPlERh49UGLV82676sU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252318; a=rsa-sha256;
	cv=none;
	b=FkYJcijEQBIqmAFazaQuPxSrqLoO1doL8J0FMnrBFaQyPbaym958fpUq/kQPoqS9IsmQ3Z
	Z9B4iN4WwR+aSPTH6YbA6dLssSPBQp5uj9g0Cg1+cYGpyrhK7Xag506xnoczaXDtgoLYsO
	KzMZvkCMVy7v9DrdinrzRDQCP2eV+yM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Qx2E87AA;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C566B41A45;
	Thu, 27 Nov 2025 14:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E45C4CEF8;
	Thu, 27 Nov 2025 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764252317;
	bh=IJfjmz3Gcj96vm3VIxigtEgGsTAGMo5lb1bIabJI8Lg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Qx2E87AAecZEjbKskSSPLiA372rXkvtf3IAU4TYvN2bxD+kfa7riHWIceeVfKgCXG
	 s5hxuWIE7piDyWh0aJ+BNEzM42frSZ6/4TClJ3qCIgfUUdLrANENr1fuUpnmU7kkdu
	 bUZnhWq3QAZwVgYmL+3CCCarIi2L3m0gP/kgfM5Y=
Subject: Patch "mm/mprotect: use long for page accountings and retval" has been added to the 5.4-stable tree
To: Liam.Howlett@oracle.com,aarcange@redhat.com,akpm@linux-foundation.org,axelrasmussen@google.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,david@kernel.org,david@redhat.com,dev.jain@arm.com,gregkh@linuxfoundation.org,harry.yoo@oracle.com,hughd@google.com,jane.chu@oracle.com,jannh@google.com,jthoughton@google.com,kas@kernel.org,lance.yang@linux.dev,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mike.kravetz@oracle.com,nadav.amit@gmail.com,npache@redhat.com,peterx@redhat.com,pfalcato@suse.de,ryan.roberts@arm.com,songmuchun@bytedance.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 27 Nov 2025 15:04:45 +0100
In-Reply-To: <20251125050926.1100484-2-harry.yoo@oracle.com>
Message-ID: <2025112744-reexamine-excusably-3fd1@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: ACDEC100015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 3pm6ffntrcczmi5mkgxrmoe1d7g4zcia
X-HE-Tag: 1764252318-730920
X-HE-Meta: U2FsdGVkX1+f1SOf8Rcv7GxgTAFd5PZM+MFzcXc4Si2Em3YkpuCMAdzhlPK0W5qkl9Ke/aCSEh77ebs5hXYhTbTKAUepxJvz2Mzg9VGGyf8A+V0qS6pVFr5TBnqJSEExr/HJnA69Bj3P/Mq6NuU31bz8ywWTV/Id7FYa8LDEOR+3kGOomcT1asV1HRRgCYRxEydVc7eQg1D9vhU/VlGDUsL1FGFsW3ILn0og+u98BMkzFrPsrqpepYM2dSAtP8MPv/sA2u05YVRbtyRmXv9H5IHwFagG7hn5mquLvedTBM/bu0G2we/58nJVYMmSgQuUL1RRHFfhJfKfpy7+7v0nv6tfceMtR+eYT46OfrMUgC3ZOc3xFpv+9hFhztAvWMHYvdbkHnB2GMl36iAP3TvBhdGHh14k+V1Q9WmLECxR2QOqkwR77KVyWKt1MN1thTQ2s4XKityjlGT5lng9AGRuljKYgqdu6mK9WByMgL8TManHNpkO5RZbhcWdqXUrhMhPzlfU0VHlpda1DMib6uM7W76xzi56nf3yYUd6d67Zy1fhIHxlA0VsK0OfHsRdnP1a3Gxk9VHXjzRcEiMI4I425VrqQrHTai27yiVaDzOmtP4HAAh+SP1oZzVo3h0wrF7NoZUiMJ7HZENhqB37iU6EZ87tX6Re/2LZ1z0hsE8m6Qa2PuuoG/mvvsTHdc0NGfj9ip7VRV9seEW/07HysmRNnMMvdgDU1JG5iJ5E1E21W9Ffn7MrwD3ijW4ag7y908CXUc8UI7Z5NXnT7cAS1tzvJENJJHuW/kRNoidkxCDdk2tSMujMQhVLyeUXrAm8kFctNch6WXGE1XLVC1VtZx+W277ANmMHZZ8MO4ML6/XCz0uWvwUbDdPWISima8jUen19UUCTzVpYIsIDMOKfQ5VzlmgzZG7MQRRBb9ed7FEA5r0ZjGi9el2V9gbwc5Y/QqEADeY0gTlIaLtmMaGK1rI
 gFMZyznK
 2iGNe+TkYa4QCq7fL8y6EHfdXX7pkPyFjWpPqRjGKIHx0C2eM61VbbByWNrwSD4By5hiWH0Bq7aNCUbJIukkv/vPJVKFoYKTSco5k9Dma9pRlo3b1GInXDx1lJef/hAINdsplSvA/PKFq1JlwJqkjPOPfe5X8+7vbqNLvcsuyMlt4VInJBPQHtwd0kKHOBot+5Pi/yh4nRnmBo1giKDouFl2ECaIAIMcYFT2EDmqUgWks21wem+DPA3c9dX9oXYmlB9KPbnkGkQlWFBODBGszEsJN61qqtVgaJc4MVVkFvI7GHwYv4zPwyrdXP0Ei5CBOUaR9w2K9ZviN9GpfGH1i0nrzcbtLOeK6WEdIHE0BZ3LdApUdNUREWnnnZjdWlN6D2fg0yZOzMoKhDl6Razxny1aR4+lt6ghbhVfaYTX+CRDeNQzNSIl4WZHnyP2AZh5miHkGErfj5TYQiCsy2sVGRh+CwF+ypodS7z3q996m3BtmWsv+0tMMgTXeUfDYlI/UNbYxSPPgpECRitTLpfcfCP+SPUpceFr0DeOYZEp4Ps1UZopLpTKQMRAAR4iJspLPCLJjbm57gJ9qhF3D4fnm7T8nWGL915gFoSGmV6DZkoj+N+upzwFINcKRiGBEA1t8XcbRkgOVh/WAHuGYgr55FtTyhlKrMiG+memOK9Jh2ialTEEe9/mAoiB5PvJ8jj2KzdMGVvT5jzPfnEDtLQARf/P8xT8PKlecDnJwsgBH5yN2jEMJI8/TuvJWaRTj+Nak51bpwtdLUXcr3/cltdOS9K+JIFyAAon6o2WdrNXMhYi2V/hzK/ldDB8NDTzP2sp9lkwb+jFaxiobNoR2QQ7C43+m1WyAKP75iTONlWJC8GuB/bBxiiO9G4MFwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: use long for page accountings and retval

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-use-long-for-page-accountings-and-retval.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-196860-greg=kroah.com@vger.kernel.org Tue Nov 25 06:10:31 2025
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue, 25 Nov 2025 14:09:25 +0900
Subject: mm/mprotect: use long for page accountings and retval
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, Peter Xu <peterx@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, Muchun Song <songmuchun@bytedance.com>, Nadav Amit <nadav.amit@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Message-ID: <20251125050926.1100484-2-harry.yoo@oracle.com>

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
@@ -137,7 +137,7 @@ struct page *follow_huge_pgd(struct mm_s
 
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
@@ -195,7 +195,7 @@ static inline bool isolate_huge_page(str
 #define putback_active_hugepage(p)	do {} while (0)
 #define move_hugetlb_state(old, new, reason)	do {} while (0)
 
-static inline unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+static inline long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
 {
 	return 0;
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1657,7 +1657,7 @@ extern unsigned long move_page_tables(st
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
 		bool need_rmap_locks);
-extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+extern long change_protection(struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      int dirty_accountable, int prot_numa);
 extern int mprotect_fixup(struct vm_area_struct *vma,
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4635,7 +4635,7 @@ same_page:
 #define flush_hugetlb_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
 #endif
 
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -4643,7 +4643,7 @@ unsigned long hugetlb_change_protection(
 	pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	unsigned long pages = 0;
+	long pages = 0;
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -595,7 +595,7 @@ unlock:
 unsigned long change_prot_numa(struct vm_area_struct *vma,
 			unsigned long addr, unsigned long end)
 {
-	int nr_updated;
+	long nr_updated;
 
 	nr_updated = change_protection(vma, addr, end, PAGE_NONE, 0, 1);
 	if (nr_updated)
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -35,13 +35,13 @@
 
 #include "internal.h"
 
-static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable, int prot_numa)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
-	unsigned long pages = 0;
+	long pages = 0;
 	int target_node = NUMA_NO_NODE;
 
 	/*
@@ -186,13 +186,13 @@ static inline int pmd_none_or_clear_bad_
 	return 0;
 }
 
-static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
+static inline long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pmd_t *pmd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 	unsigned long nr_huge_updates = 0;
 	struct mmu_notifier_range range;
 
@@ -200,7 +200,7 @@ static inline unsigned long change_pmd_r
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		unsigned long this_pages;
+		long this_pages;
 
 		next = pmd_addr_end(addr, end);
 
@@ -258,13 +258,13 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct vm_area_struct *vma,
+static inline long change_pud_range(struct vm_area_struct *vma,
 		p4d_t *p4d, unsigned long addr, unsigned long end,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pud_t *pud;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	pud = pud_offset(p4d, addr);
 	do {
@@ -278,13 +278,13 @@ static inline unsigned long change_pud_r
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct vm_area_struct *vma,
+static inline long change_p4d_range(struct vm_area_struct *vma,
 		pgd_t *pgd, unsigned long addr, unsigned long end,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	p4d_t *p4d;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
@@ -298,7 +298,7 @@ static inline unsigned long change_p4d_r
 	return pages;
 }
 
-static unsigned long change_protection_range(struct vm_area_struct *vma,
+static long change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable, int prot_numa)
 {
@@ -306,7 +306,7 @@ static unsigned long change_protection_r
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long start = addr;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -328,11 +328,11 @@ static unsigned long change_protection_r
 	return pages;
 }
 
-unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+long change_protection(struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       int dirty_accountable, int prot_numa)
 {
-	unsigned long pages;
+	long pages;
 
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot);


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-5.4/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-5.4/mm-mprotect-use-long-for-page-accountings-and-retval.patch

