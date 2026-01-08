Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA35D185FC
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B923A6B0092; Thu,  8 Jan 2026 08:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15C56B0093; Thu,  8 Jan 2026 08:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED736B0095; Thu,  8 Jan 2026 08:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D16C6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:58:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CF57136829
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:58:29 +0000 (UTC)
X-FDA: 84308951538.21.31FA73C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A0B5B1C000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:58:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=SEtf9alV;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767880707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=WKjzHpa2jqobpNE2qGTE6AytMNUa1r+7TG9ycm+1WFo=;
	b=fCswlE0MuT7sD3c2azQBOi9BSFWBRR63wCZq5Cj9aIHZIN6sJyiHixjAx9TKPYD7ArNSeT
	R3jAcXTvmmIJa8r5PPmg+icaz/6uzGFHMIlWVV5exbD/65RWAp0bDvs4/8ZHs2KufDGXbF
	lq0jUar3Bf3ZXqXJjKAqBCMmQIIqLvw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=SEtf9alV;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767880707; a=rsa-sha256;
	cv=none;
	b=LBvycVFUGc9aw7rM9/7F3DJZXIT8jbMjssuE4d6ITEfeAIFUhykS/7LLuetoB4DIlriLkk
	bUdCs8JyAZohIPuikk3UWMnyfAIQo3iRgY4JEF64a8Z7BBGk7g6MM2USmsPdDkAsL4Hnra
	LUtRrwXNqOL68tN6GQ9LAA5gOSN2RD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDF3C60133;
	Thu,  8 Jan 2026 13:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C15C116C6;
	Thu,  8 Jan 2026 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767880706;
	bh=ygLuu9SncPx2l2+lwFeCzp9/qVTiZrVv0OyxC85gL+Q=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=SEtf9alVmuFRzbQHu/RyFdxMkh0UmcKZSJafVgnyIC2fPtBTTtfWo9MsMi9VTxL12
	 6YFbP4x6a1XW5NDaduOQ/4ROTN12ezwZRIv/BuV3+a5YbQe+UDig4WI0WNCUr8OGyK
	 ZRa4dJj9ahvNgDHOoKFhbHwZ93OnaxSS0vsrqSOY=
Subject: Patch "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()" has been added to the 5.15-stable tree
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
Date: Thu, 08 Jan 2026 14:56:33 +0100
In-Reply-To: <20260106115036.86042-3-harry.yoo@oracle.com>
Message-ID: <2026010833-unhook-cork-d371@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0B5B1C000D
X-Stat-Signature: hhu15mhtzdpepdaxz5s9eny4egdkf6kt
X-HE-Tag: 1767880707-270701
X-HE-Meta: U2FsdGVkX1/uhgEjdj8m0M2vIM4sd7RyajtGMFTo/eQEp+jf4Upr4AyqfVKxCo8Yi9hHG8szAI6GeJxxLRfipt6ZeNvXLrqDHIQLDTfldGTlzEDWhpK77F0JtVmKA3LF5MoHAFk9Krcj0O4ZaLh9AQrKJi6QbhZga2reqdulwLQgdIiZ7JdOOoqEfiNjaQjZ5zrijFc2wmhJclM0lG27OEuoh+aSxtCr/knsBkjHEdld0zEouyHMQ+9ZWxze5VxC8VxMnSLYEJmli0hk1h6Mc2g4yJZCwkOzxfV0Nnm5UiUTfpQAXltuYMOUvpTULKC14Fb79WeQNWnzkRZhBx0M9/2EGcIMV5botdJAoPJqAtMkWjTxw8AETVa5o+2bI5tglV/tC5+HnEZQkpyCpckxw1JVJiBq8jQ/5k89fm7DcCLT+ouvfh8zwfyRrcqdTp0/JwrAjY/f3eslQUvOqxfc3VbAdBTN/kr3VXhwEg56iTuYn8ImAMF9SckB15vXkvFUFpW5UL2aYhx3fUNQ5l48kRQ/kA96nnRIby9bdJXd6elwl/MQ8D1Z9sDTvdEjM48EHVBQ9AgzfZa+NySryuOyxLtH43qUvbARdL39+QMxgILO6aWYsZUF+pQUmKF1xfvvoRF9pKDka0PhJt32/YhDE2/CN4tAX9dnUv3MnI2giZiS6KU4WDZ+iB2rwtIkz47OFPJJITCF0uG1Ea5xAGSo1gs2VFU3yTwAmsw/HckW7CQLPEiTyF/VOKS6cY9013cCfE2PbNCmtoBJa/vwuDsgyzWiZpvIt1zsF8EkXL60hDsx6h+p73foeGlPQ4MRN7cmSgOp/NO3FGxUPL4qgCBuVhy/fKB4thuK9kGQoGSgJZRJ2pszYboHFUM0nVY9ReavZ0TPmjLm+4bcD2QkNRD4E5yMGlCwU70l6L+LZvNWhQC5OXVPzWmMoBhEPkCjoxXwvtkgBLxjeMqIGMGjlOL
 ZoxY7Zbn
 pRgC7gJSX6MrxZjkI1c+Rzd4P0eKfl4ivNFX/eSfgNUe8U5zRz7HU5Do/NTew5MgCPrT3pPJwoZJ0h6qNCRTrO2h7m6a6tnwxB8SKLu5Z5bZLpNCJ6UT5LXyPOiOIdAA826VA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-205078-greg=kroah.com@vger.kernel.org Tue Jan  6 12:59:03 2026
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue,  6 Jan 2026 20:50:36 +0900
Subject: mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
To: stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, hughd@google.com, jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com, "Alistair Popple" <apopple@nvidia.com>, "Anshuman Khandual" <anshuman.khandual@arm.com>, "Axel Rasmussen" <axelrasmussen@google.com>, "Christophe Leroy" <christophe.leroy@csgroup.eu>, "Christoph Hellwig" <hch@infradead.org>, "David Hildenbrand" <david@redhat.com>, "Huang, Ying" <ying.huang@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Lorenzo Stoakes" <lstoakes@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Mel Gorman" <mgorman@techsingularity.net>, "Miaohe Lin" <linmiaohe@huawei.com>, "Mike Kravetz" <mike.kra
 vetz@ora
 cle.com>, "Mike Rapoport" <rppt@kernel.org>, "Minchan Kim" <minchan@kernel.org>, "Naoya Horiguchi" <naoya.horiguchi@nec.com>, "Pavel Tatashin" <pasha.tatashin@soleen.com>, "Peter Xu" <peterx@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>, "Ralph Campbell" <rcampbell@nvidia.com>, "SeongJae Park" <sj@kernel.org>, "Song Liu" <song@kernel.org>, "Steven Price" <steven.price@arm.com>, "Suren Baghdasaryan" <surenb@google.com>, "Thomas Hellström" <thomas.hellstrom@linux.intel.com>, "Will Deacon" <will@kernel.org>, "Yang Shi" <shy828301@gmail.com>, "Yu Zhao" <yuzhao@google.com>, "Zack Rusin" <zackr@vmware.com>, "Harry Yoo" <harry.yoo@oracle.com>
Message-ID: <20260106115036.86042-3-harry.yoo@oracle.com>

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
[ Background:

    It was reported that a bad pmd is seen when automatic NUMA balancing
    is marking page table entries as prot_numa:

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
    Unlike mainline, pte_offset_map_lock() does not check if the pmd
    entry is a migration entry or a hugepage; acquires PTL unconditionally
    instead of returning failure. Therefore, it is necessary to keep the
    !is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() check before
    acquiring the PTL.

    After acquiring it, open-code the mainline semantics of
    pte_offset_map_lock() so that change_pte_range() fails if the pmd value
    has changed (under the PTL). This requires adding one more parameter
    (for passing pmd value that is read before calling the function) to
    change_pte_range(). ]

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |   99 ++++++++++++++++++++++++----------------------------------
 1 file changed, 42 insertions(+), 57 deletions(-)

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
+	pmd_t _pmd;
 	spinlock_t *ptl;
 	long pages = 0;
 	int target_node = NUMA_NO_NODE;
@@ -48,21 +49,16 @@ static long change_pte_range(struct vm_a
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
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	/* Make sure pmd didn't change after acquiring ptl */
+	_pmd = pmd_read_atomic(pmd);
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+	barrier();
+	if (!pmd_same(pmd_old, _pmd)) {
+		pte_unmap_unlock(pte, ptl);
+		return -EAGAIN;
+	}
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
@@ -194,31 +190,6 @@ static long change_pte_range(struct vm_a
 	return pages;
 }
 
-/*
- * Used when setting automatic NUMA hinting protection where it is
- * critical that a numa hinting PMD is not confused with a bad PMD.
- */
-static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
-{
-	pmd_t pmdval = pmd_read_atomic(pmd);
-
-	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	barrier();
-#endif
-
-	if (pmd_none(pmdval))
-		return 1;
-	if (pmd_trans_huge(pmdval))
-		return 0;
-	if (unlikely(pmd_bad(pmdval))) {
-		pmd_clear_bad(pmd);
-		return 1;
-	}
-
-	return 0;
-}
-
 static inline long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
@@ -233,21 +204,33 @@ static inline long change_pmd_range(stru
 
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
@@ -257,15 +240,15 @@ static inline long change_pmd_range(stru
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
-				int nr_ptes = change_huge_pmd(vma, pmd, addr,
+				ret = change_huge_pmd(vma, pmd, addr,
 							      newprot, cp_flags);
 
-				if (nr_ptes) {
-					if (nr_ptes == HPAGE_PMD_NR) {
+				if (ret) {
+					if (ret == HPAGE_PMD_NR) {
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
@@ -276,9 +259,11 @@ static inline long change_pmd_range(stru
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
-					      cp_flags);
-		pages += this_pages;
+		ret = change_pte_range(vma, pmd, _pmd, addr, next,
+					      newprot, cp_flags);
+		if (ret < 0)
+			goto again;
+		pages += ret;
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);


Patches currently in stable-queue which might be from harry.yoo@oracle.com are

queue-5.15/mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
queue-5.15/mm-balloon_compaction-we-cannot-have-isolated-pages-in-the-balloon-list.patch
queue-5.15/mm-mprotect-use-long-for-page-accountings-and-retval.patch
queue-5.15/mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch

