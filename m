Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15859D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA486B0010; Thu, 27 Nov 2025 09:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2126B002D; Thu, 27 Nov 2025 09:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F786B002E; Thu, 27 Nov 2025 09:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF7B6B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:02:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB29086BB0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:02:52 +0000 (UTC)
X-FDA: 84156552984.15.9B2C896
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6AA4316001B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:02:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=bfDEswOg;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=K0hkvq9VuBbTlFZrHuytiDoA8qVRiHWtki1SypX5s8s=;
	b=ThceABPe2kf0GCWRlRcDnHmj2QSGg5Fvrw/K5CfSaTBIYY7FKg69bYquQPUp51SHUTAFkI
	chLR0J1VeBSZF9TDXGf1mfGVRIsesFcF+QzeSnQjtQBNK1sIT5HJWA+mMi+jOWpyeJnrpY
	EImfIWtCBvL2HXoUO43emf9vothPPTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252171; a=rsa-sha256;
	cv=none;
	b=JyvPxE0KRy/QxU20lTIOZAhliULQap8hotAp1CyYNLPOE0NGph3LQzsR/9Qey1c+hbzyLB
	X/ucf9vCO5uT8lQkbf2mlp5I1hSw1KoqBOH0/Zmp7+8VipmMFi0Fz3PjdcuYYcedpVrxFB
	/FSp0j4aKBoPez7KWKpkgu9JJi/TjFc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=bfDEswOg;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C62A0601F1;
	Thu, 27 Nov 2025 14:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AE3C4CEF8;
	Thu, 27 Nov 2025 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764252170;
	bh=6LYtCMYQlYzNEpMBFBx0K30hTbAWlKlh3+tyGL7L2W4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=bfDEswOggBzaOGZ0FKaA0iqu8x4G2WRGnyyspZaUV7SUisjBYBQ5pZpN2qvm9zAWc
	 wQFcLtmNnb/ULup2FBUuoWYO23FGFNJGtzjjYTcGpvVSft5kDrRGRMwwbG03BeXO8G
	 Naj0VoyGGaGd5XTDEHXsTBq7eDTMBK+SU9Rg2aTU=
Subject: Patch "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()" has been added to the 5.10-stable tree
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	anshuman.khandual@arm.com, apopple@nvidia.com,
	axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, christophe.leroy@csgroup.eu,
	david@kernel.org, david@redhat.com, dev.jain@arm.com,
	gregkh@linuxfoundation.org, harry.yoo@oracle.com, hch@infradead.org,
	hughd@google.com, ira.weiny@intel.com, jane.chu@oracle.com,
	jannh@google.com, jgg@ziepe.ca, kas@kernel.org,
	kirill.shutemov@linux.intel.com, lance.yang@linux.dev,
	linmiaohe@huawei.com, linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	lstoakes@gmail.com, mgorman@techsingularity.net,
	mike.kravetz@oracle.com, minchan@kernel.org, naoya.horiguchi@nec.com,
	npache@redhat.com, pasha.tatashin@soleen.com, peterx@redhat.com,
	peterz@infradead.org, pfalcato@suse.de, rcampbell@nvidia.com,
	rppt@kernel.org, ryan.roberts@arm.com, shy828301@gmail.com,
	sj@kernel.org, song@kernel.org, steven.price@arm.com,
	surenb@google.com, thomas.hellstrom@linux.intel.com, vbabka@suse.cz,
	will@kernel.org, willy@infradead.org, ying.huang@int.kvack.org,
	el.com@kvack.org, yuzhao@google.com, zackr@vmware.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 27 Nov 2025 15:02:29 +0100
In-Reply-To: <20251125045442.1084815-3-harry.yoo@oracle.com>
Message-ID: <2025112729-simply-plausibly-ac94@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6AA4316001B
X-Stat-Signature: eegeb7yudkpwugguya4ejcnussk8xox4
X-HE-Tag: 1764252171-922969
X-HE-Meta: U2FsdGVkX19LSVEMJkPK4cnAj9wzdGgQ3du2PCPDXLH03KbeQ3Xi+EWk2vwhcJpAoXMNGr5YOPE/a+A2G+tmtzFzYagGZ30Zdl6U8MebS6ozmq96GpmIeqyOxvHXM2YS3OW7ijjyG+PbjjQXpJRbS4T2Yh5AuDtBIMd9EIOSXNrIggtMWYe8pX9LQ72xGl4sqKIQdLzW8GoQxZPKKmQcRH6FKijLFSx3I7yf7NoQPhT4hmrENg3EorsZ2CE1LRC7Tr4bdOQEO0xSm0WXww0hoso7yVZidAUmoUKHur9S/yWTzt2oVO65UTNvvVB/x2NorjwJCtOoxhPZCO86n2ixNaO3XzxSP2lLjVAfuPnpnPZlSeurw2Hx/l4oF07hNFtNJovI02e2GX11fPXoj3jmMTYnniw65jPhp5SNz1hgNKIGk2BA3XBtxcEwNj26qVyhCZycAy+4HlaSJKqKd8y8deqiS3jioXfNlY7CMGmbOEmryTC1czNXxCyB6gsQdONsEVtNgINwa4KtkbAvfN15H3USyAZlLOFCAK/Hml6SpbwxMsFoHq/i9+fAwFrIK+3faPKioiFF3QLytiECHwE9ePiyUnhKOScq6bZUHn1K5gd1wMI/7wQxo6GFQfVJkTDpkwg/IseQfVH0hwuV9heS5qwe1VooxiYNK/8H2ujXUb11/2Xn92g4CrJaoON8qh7WE3R9Mru0RwjuF7QBjIlhr+gea1DEZS3TAwMDASrWcWMRGCe5rbPJiuWAcfPeGP4gF3QYRSFq0uCH06Y+4KwVv3fdimq9R0Znf7py2kpfl2amFDXeDm3zmFroAVbnApazhafPVyLAJMhrvNO9WpGaDfSQPReimGgM1bsiwbi0TEgUBKTAkJ7TQn0LtHZgxnptFsduKCYNJarbH9XB2TvXcqOdwfesAUrdpEac4mB/ZEqHBu5NMcVUl8zudNa7lMrz9CfyzfM7m8Hr2OfM+Gj
 wDXR1yrH
 zwajCaIuIsJP1wmZQ2Qump07e+/M7zmBQ10MA6tq/tgTRWobL7E2DKRrrybbOO4ci9eKlL6iOclkUOwXnFWWM8ZJ1jutzKQgKNNcutKAp/Sop87sUo2zhIlICMbKjl7PmpBks
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-196858-greg=kroah.com@vger.kernel.org Tue Nov 25 05:56:26 2025
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue, 25 Nov 2025 13:54:42 +0900
Subject: mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, "Alistair Popple" <apopple@nvidia.com>, "Anshuman Khandual" <anshuman.khandual@arm.com>, "Axel Rasmussen" <axelrasmussen@google.com>, "Christophe Leroy" <christophe.leroy@csgroup.eu>, "Christoph Hellwig" <hch@infradead.org>, "David Hildenbrand" <david@redhat.com>, "Huang, Ying" <ying.huang@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Lorenzo Stoakes" <lstoakes@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Mel Gorman" <mgorman@techsingularity.net>, "Miaohe Lin" <linmiaohe@huawei.com>, "Mike Kravetz" <mike.kra
 vetz@ora
 cle.com>, "Mike Rapoport" <rppt@kernel.org>, "Minchan Kim" <minchan@kernel.org>, "Naoya Horiguchi" <naoya.horiguchi@nec.com>, "Pavel Tatashin" <pasha.tatashin@soleen.com>, "Peter Xu" <peterx@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>, "Ralph Campbell" <rcampbell@nvidia.com>, "SeongJae Park" <sj@kernel.org>, "Song Liu" <song@kernel.org>, "Steven Price" <steven.price@arm.com>, "Suren Baghdasaryan" <surenb@google.com>, "Thomas Hellström" <thomas.hellstrom@linux.intel.com>, "Will Deacon" <will@kernel.org>, "Yang Shi" <shy828301@gmail.com>, "Yu Zhao" <yuzhao@google.com>, "Zack Rusin" <zackr@vmware.com>
Message-ID: <20251125045442.1084815-3-harry.yoo@oracle.com>

From: Hugh Dickins <hughd@google.com>

commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.

change_pmd_range() had special pmd_none_or_clear_bad_unless_trans_huge(),
required to avoid "bad" choices when setting automatic NUMA hinting under
mmap_read_lock(); but most of that is already covered in pte_offset_map()
now.  change_pmd_range() just wants a pmd_none() check before wasting time
on MMU notifiers, then checks on the read-once _pmd value to work out
what's needed for huge cases.  If change_pte_range() returns -EAGAIN to
retry if pte_offset_map_lock() fails, nothing more special is needed.

Link: https://lkml.kernel.org/r/725a42a9-91e9-c868-925-e3a5fd40bb4f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas HellstrÃ¶m <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Background: It was reported that a bad pmd is seen when automatic NUMA
  balancing is marking page table entries as prot_numa:

      [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
      [2437548.235022] Call Trace:
      [2437548.238234]  <TASK>
      [2437548.241060]  dump_stack_lvl+0x46/0x61
      [2437548.245689]  panic+0x106/0x2e5
      [2437548.249497]  pmd_clear_bad+0x3c/0x3c
      [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
      [2437548.259537]  change_p4d_range+0x156/0x20e
      [2437548.264392]  change_protection_range+0x116/0x1a9
      [2437548.269976]  change_prot_numa+0x15/0x37
      [2437548.274774]  task_numa_work+0x1b8/0x302
      [2437548.279512]  task_work_run+0x62/0x95
      [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
      [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
      [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
      [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
      [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b

    This is due to a race condition between change_prot_numa() and
    THP migration because the kernel doesn't check is_swap_pmd() and
    pmd_trans_huge() atomically:

    change_prot_numa()                      THP migration
    ======================================================================
    - change_pmd_range()
    -> is_swap_pmd() returns false,
    meaning it's not a PMD migration
    entry.
                                      - do_huge_pmd_numa_page()
                                      -> migrate_misplaced_page() sets
                                         migration entries for the THP.
    - change_pmd_range()
    -> pmd_none_or_clear_bad_unless_trans_huge()
    -> pmd_none() and pmd_trans_huge() returns false
    - pmd_none_or_clear_bad_unless_trans_huge()
    -> pmd_bad() returns true for the migration entry!

  The upstream commit 670ddd8cdcbd ("mm/mprotect: delete
  pmd_none_or_clear_bad_unless_trans_huge()") closes this race condition
  by checking is_swap_pmd() and pmd_trans_huge() atomically.

  Backporting note:
    Unlike the mainline, pte_offset_map_lock() does not check if the pmd
    entry is a migration entry or a hugepage; acquires PTL unconditionally
    instead of returning failure. Therefore, it is necessary to keep the
    !is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() check before
    acquiring the PTL.

    After acquiring the lock, open-code the semantics of
    pte_offset_map_lock() in the mainline kernel; change_pte_range() fails
    if the pmd value has changed. This requires adding one more parameter
    (to pass pmd value that is read before calling the function) to
    change_pte_range(). ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |   75 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -36,10 +36,11 @@
 #include "internal.h"
 
 static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		unsigned long cp_flags)
+		pmd_t pmd_old, unsigned long addr, unsigned long end,
+		pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
+	pmd_t pmd_val;
 	spinlock_t *ptl;
 	long pages = 0;
 	int target_node = NUMA_NO_NODE;
@@ -48,21 +49,15 @@ static long change_pte_range(struct vm_a
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
-	/*
-	 * Can be called with only the mmap_lock for reading by
-	 * prot_numa so we must check the pmd isn't constantly
-	 * changing from under us from pmd_none to pmd_trans_huge
-	 * and/or the other way around.
-	 */
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
-	/*
-	 * The pmd points to a regular pte so the pmd can't change
-	 * from under us even if the mmap_lock is only hold for
-	 * reading.
-	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	/* Make sure pmd didn't change after acquiring ptl */
+	pmd_val = pmd_read_atomic(pmd);
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+	barrier();
+	if (!pmd_same(pmd_old, pmd_val)) {
+		pte_unmap_unlock(pte, ptl);
+		return -EAGAIN;
+	}
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
@@ -223,21 +218,33 @@ static inline long change_pmd_range(stru
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		long this_pages;
-
+		long ret;
+		pmd_t _pmd;
+again:
 		next = pmd_addr_end(addr, end);
+		_pmd = pmd_read_atomic(pmd);
+		/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		barrier();
+#endif
 
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
-		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
-		 * check leading to a false positive and clearing.
-		 * Hence, it's necessary to atomically read the PMD value
-		 * for all the checks.
+		 * between pmd_trans_huge(), is_swap_pmd(), and
+		 * a pmd_none_or_clear_bad() check leading to a false positive
+		 * and clearing. Hence, it's necessary to atomically read
+		 * the PMD value for all the checks.
 		 */
-		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
-		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
-			goto next;
+		if (!is_swap_pmd(_pmd) && !pmd_devmap(_pmd) && !pmd_trans_huge(_pmd)) {
+			if (pmd_none(_pmd))
+				goto next;
+
+			if (pmd_bad(_pmd)) {
+				pmd_clear_bad(pmd);
+				goto next;
+			}
+		}
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
@@ -247,15 +254,15 @@ static inline long change_pmd_range(stru
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
-				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-							      newprot, cp_flags);
+				ret = change_huge_pmd(vma, pmd, addr, newprot,
+						      cp_flags);
 
-				if (nr_ptes) {
-					if (nr_ptes == HPAGE_PMD_NR) {
+				if (ret) {
+					if (ret == HPAGE_PMD_NR) {
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
@@ -266,9 +273,11 @@ static inline long change_pmd_range(stru
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
-					      cp_flags);
-		pages += this_pages;
+		ret = change_pte_range(vma, pmd, _pmd, addr, next, newprot,
+				       cp_flags);
+		if (ret < 0)
+			goto again;
+		pages += ret;
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-5.10/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-5.10/mm-mprotect-use-long-for-page-accountings-and-retval.patch

