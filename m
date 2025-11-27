Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1A4CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B400E6B002E; Thu, 27 Nov 2025 09:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17E76B002F; Thu, 27 Nov 2025 09:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55236B0030; Thu, 27 Nov 2025 09:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 941756B002E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:02:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B0C116018F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:02:57 +0000 (UTC)
X-FDA: 84156553194.14.A9FEE56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0295E100012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:02:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=yKSWgTlx;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=J/7N4taclzF1isdw3N2AW2TvhAOn6JA9Y42Fq0/ETAQ=;
	b=dwyW3iU4xdqCl6Hf3jDCQy8QdrM28Ebl9JkK33SVakia4dKhjR2VdcJEtnTPVXkuoUW958
	ZZn2veBg4f4dGUwANqY5jB/nHtGLNGybL8oKLQ2ge3P0QZTTyZq+y9/H6TGilSmjG/dfNs
	C0GLxhk9DzvhiuLYQlXqyWneOiu2vjk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=yKSWgTlx;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252175; a=rsa-sha256;
	cv=none;
	b=FXYRaoWS8LSRmXXEAfXgNd4P01Wd8OGNi/OIb5I81y6eGZfMnDzrMwDv8n7Frb7ks049g5
	mVtipIl9bgmRyHrhGHKhdkYgs3BZlYj3zLY/khM1wjAkSrpcE0EL5NCJAyN+GXsom+ukpD
	Y1k+tThzoZml8LMWhR6lLlPFz26XO/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65C6B417B2;
	Thu, 27 Nov 2025 14:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65EDC4CEF8;
	Thu, 27 Nov 2025 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764252173;
	bh=SrPXSMSTgoYJ8SXk6Z1uitF+95AekoJA7+7o4djyIW0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yKSWgTlxpx9OimswpWUotfZTwYgr2gvZTPIdJAeeuQTOd9TS8RA5Y9mSASIy1CuTT
	 GA5prOenGmRkagxg/O/+ES/2QpObgpN4fGLfTkgUnJbersJ8pkSOXgviIOjUPP0sic
	 7ou3YsrH9CcLzgbTqHQkLG5CQ6B40wEA1F0Fl6RQ=
Subject: Patch "mm/mprotect: use long for page accountings and retval" has been added to the 5.10-stable tree
To: Liam.Howlett@oracle.com,aarcange@redhat.com,akpm@linux-foundation.org,axelrasmussen@google.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,david@kernel.org,david@redhat.com,dev.jain@arm.com,gregkh@linuxfoundation.org,harry.yoo@oracle.com,hughd@google.com,jane.chu@oracle.com,jannh@google.com,jthoughton@google.com,kas@kernel.org,lance.yang@linux.dev,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,mike.kravetz@oracle.com,nadav.amit@gmail.com,npache@redhat.com,peterx@redhat.com,pfalcato@suse.de,ryan.roberts@arm.com,songmuchun@bytedance.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 27 Nov 2025 15:02:29 +0100
In-Reply-To: <20251125045442.1084815-2-harry.yoo@oracle.com>
Message-ID: <2025112729-qualified-bunkbed-122e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0295E100012
X-Stat-Signature: e4fi7uoy6zzn9unihhuo67pnm7dt37um
X-Rspam-User: 
X-HE-Tag: 1764252174-129519
X-HE-Meta: U2FsdGVkX1/ZSbWtLckt/Jos8meDEvGu03XvvMkE5sUvkgNE877u0fShXHW6ELojRd1eCVUhOEWDjLDR7e0/9gOlk3k/lS/Fafmb2oFAgaDO2meF02D4+Lu8iiTzdS0buPLIw+RdZSTH9oNdp0Xl3LTcFL7DCyn+qAoNUvRCKI3jI1ifvmYND4XBqftbKP5lK6wGKHOpYmGFiV0CP75dl6fgdxXgm6khvyo1HJBsy9HIABElpOJOPgvjD9Ka72Jsbph8su+XTRpK8k4ElYRhlxGawm6plLcue35cGcVwbhkrdAY4bdMDOpRnpa/kUQPYxkq5kQGCRPK3AeVXaUatgpzZxbZMPiBDprZkiR1EemJWBlEZNOBUyHSYQGzMvxrVdGsi5VWPLURIvGqI6sZF/Z0wrWR/BDv3Uh9ryVlDgu1nE3AXLoV/tCXCelg8G4/ADyk50Z0PSdZ7EpklQmCAP/uLnTS9QivftL6p0aouX7n3NjF2U24hFhQaLjhrG3Hn03wpy8aRj+EK/uSTh7j7+1veDJUvJ1grWaDN1Mal73FYmLlZYs1sg0JQm7VMXp5ITaqRt1+e4N1Bf7r4FmBbNFpKQOByAhGDCgKYTUnPbklDMj9yFd6HX2ZddAMupGjGG+EcaTL75GzlyZs0r/H7TGQojT23Eegk/HXHhjj68DlvoR442+S2pJpqjHKi/jq66/4Hvu/9yabe4oBqXWe2Cmygr8un9BlWu5APcj/Tu4rpMX/vK+tdMPXGXFsY/M/Vo1GtPG2vMri4LJCepPMiQMnNxcJtrD7PW0sd4W7rrY6YjVRft8WQe9/krKjX6VVwcVbKBTt4+uc17o7maxUPnyGb744Q0SkzgAHtf0pso/vMkVmxJhcMPAz46DaVZbrtfx8rW3SluLc3ek+VOBdRChcAO1rN/G/iGvv+bJcpaf0THByxN60uME1BqIPFyIW/XuOJwsPrv0CPgVKjKR2
 P0Q4W0Au
 /Y3qr55Z6OcQBBsK4MPRfXuh12uugG4/oSsVD1aPCOBUGhE8HlGzjTzxEEsl9K+Ke4MN66cnjwFHdi8w3Z/v6RmnCE5r9mXrrC3f7pZ9VguEeoQWuIiLyEaDSDM8D+bXDf37dFLiaxujG/p8QhgMkRPjThwJ2WdM8hIv2xWaKQmHOBvzmDgJVEdQWQEb52ZaB62KeH3gL4NiSbfVWlIY/iIxXIinfteMXuJsZKHh3+n3dEP9CQbSx53yVjfrLrtDjZ/UdXbzt4y04jHQIuhfkcqpI5ZP1Io91ewlEyMNsCUpS0ilDQOV/Jqw9ueX9rEFstusfVBQlGRrds0DSIW4mJKWNytetDlGlFY6kDRfomTIvjAto3UU/yuylOOJMRmjKRyHhbJPUBuWN0hQxUp6UJ4ypkZMCwG0bT0bS1mhhF4aAxAw5Wt63RD+epoJ/MghJEDJmo2OmFGKjrmd8YaBV65Xk3bsnUVyHChrvUs6ow4jL/PMoG6dJ2lZ883lz8V2eJYnfg3ABinI2mx/70lXdI+4nrpQ1IT5Acrsfi1LtHQOr+Y/Lb0d65Na3CEpbw/E4t8rlxWiX2iK6D1naNGMcmPCpStcp5dIekCPoCZm05BnWcPJPKXGiXjgeG0w1uTGWFv7YXBvTWDwLWh5wKQQEBJhVSId6Lm4eRLXWhhutk99dVysH6BlAdo2/BrIMMrD6rwWslm5rJ+2IgTid1PkmNWw1C6IPoCmTN6Oxnlue/nSBnHSFEY1+QxAJ6u5npSp6aYZhcIUvU3OPzhsT+8Z8TjMqHA4nQQgPqSlueJdQQOW/xSe4ez/gS8N7HOXSXdURwPLfS9h+IiouYhgX/eGsBrV6HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: use long for page accountings and retval

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-use-long-for-page-accountings-and-retval.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-196859-greg=kroah.com@vger.kernel.org Tue Nov 25 05:56:33 2025
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue, 25 Nov 2025 13:54:41 +0900
Subject: mm/mprotect: use long for page accountings and retval
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, Peter Xu <peterx@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, Muchun Song <songmuchun@bytedance.com>, Nadav Amit <nadav.amit@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Message-ID: <20251125045442.1084815-2-harry.yoo@oracle.com>

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
 mm/mprotect.c           |   34 +++++++++++++++++-----------------
 5 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -184,7 +184,7 @@ struct page *follow_huge_pgd(struct mm_s
 
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
@@ -342,7 +342,7 @@ static inline void move_hugetlb_state(st
 {
 }
 
-static inline unsigned long hugetlb_change_protection(
+static inline long hugetlb_change_protection(
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned long end, pgprot_t newprot)
 {
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1876,7 +1876,7 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
-extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+extern long change_protection(struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      unsigned long cp_flags);
 extern int mprotect_fixup(struct vm_area_struct *vma,
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5051,7 +5051,7 @@ same_page:
 #define flush_hugetlb_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
 #endif
 
-unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
+long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -5059,7 +5059,7 @@ unsigned long hugetlb_change_protection(
 	pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	unsigned long pages = 0;
+	long pages = 0;
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
 
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -653,7 +653,7 @@ unlock:
 unsigned long change_prot_numa(struct vm_area_struct *vma,
 			unsigned long addr, unsigned long end)
 {
-	int nr_updated;
+	long nr_updated;
 
 	nr_updated = change_protection(vma, addr, end, PAGE_NONE, MM_CP_PROT_NUMA);
 	if (nr_updated)
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -35,13 +35,13 @@
 
 #include "internal.h"
 
-static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
-	unsigned long pages = 0;
+	long pages = 0;
 	int target_node = NUMA_NO_NODE;
 	bool dirty_accountable = cp_flags & MM_CP_DIRTY_ACCT;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
@@ -209,13 +209,13 @@ static inline int pmd_none_or_clear_bad_
 	return 0;
 }
 
-static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
+static inline long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 	unsigned long nr_huge_updates = 0;
 	struct mmu_notifier_range range;
 
@@ -223,7 +223,7 @@ static inline unsigned long change_pmd_r
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		unsigned long this_pages;
+		long this_pages;
 
 		next = pmd_addr_end(addr, end);
 
@@ -281,13 +281,13 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct vm_area_struct *vma,
-		p4d_t *p4d, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline long change_pud_range(struct vm_area_struct *vma, p4d_t *p4d,
+		unsigned long addr, unsigned long end, pgprot_t newprot,
+		unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	pud = pud_offset(p4d, addr);
 	do {
@@ -301,13 +301,13 @@ static inline unsigned long change_pud_r
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct vm_area_struct *vma,
-		pgd_t *pgd, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline long change_p4d_range(struct vm_area_struct *vma, pgd_t *pgd,
+		unsigned long addr, unsigned long end, pgprot_t newprot,
+		unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	p4d = p4d_offset(pgd, addr);
 	do {
@@ -321,7 +321,7 @@ static inline unsigned long change_p4d_r
 	return pages;
 }
 
-static unsigned long change_protection_range(struct vm_area_struct *vma,
+static long change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags)
 {
@@ -329,7 +329,7 @@ static unsigned long change_protection_r
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long start = addr;
-	unsigned long pages = 0;
+	long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
@@ -351,11 +351,11 @@ static unsigned long change_protection_r
 	return pages;
 }
 
-unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+long change_protection(struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       unsigned long cp_flags)
 {
-	unsigned long pages;
+	long pages;
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-5.10/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-5.10/mm-mprotect-use-long-for-page-accountings-and-retval.patch

