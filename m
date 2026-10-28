Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D608606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 00:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NIdGRR+I
Received: by kanga.kvack.org (Postfix)
	id DE0AE6B092E; Tue, 27 Oct 2026 20:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AA16B092F; Tue, 27 Oct 2026 20:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31E36B0930; Tue, 27 Oct 2026 20:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5186B092E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:53:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4518160B8B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:53:11 +0000 (UTC)
X-FDA: 85370210982.10.C9C4E3D
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A9AE1C0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:53:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NIdGRR+I;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793148790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=70/2LdS5pBXpfNj8kBNHr883OekoIQf/Q1qvO8XzJk4=;
	b=dhPLX8sp+ABCrGFmaK695Tc8bhv6mhBjpsPMftJre+/qH6mUX4NKypu45VVoNRY43tQKub
	uw3QxCUmjdlX8mNDyLiA5y0O+9rAwZRVYogcA3muBQzv5We7XUT8hHAQv9SZN93U/WBtwS
	LGPjPEdE2Mamn7exBWWqeL5hPwUS3XI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793148790;
	b=dFBUGqtIAvMo1Xsj6rZfAB7F3Xs6n5rK0GSZy0R9mH4dEH/K6AeJMCuA9qJtD8YmfcuJ4j
	8Y8maUa2kUn8pJ2072coSM27J/C/FYmlMhFpvFAlkeFiE+WEWR6RPHJV2aZZiQEhF93/3t
	U89OOzy5oQJPIVwgvnO/D5PXTJ09c0Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NIdGRR+I;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793148784; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=70/2LdS5pBXpfNj8kBNHr883OekoIQf/Q1qvO8XzJk4=;
	b=NIdGRR+InXMWK2dR5YydEh3qhN6mXyFH69Q+54xOjODvPvAY1QsbveY0Q8HRS88iu0KBTZ/35oyJVC34oaQmHQtdcv2RBkhpZaY+DmhXU9+/Y/XiUKaTH79Lz+01vEJGHjQBJrXUt0DdSz55iNEKjSLpcxTn1hn8KouKUk1QFU4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XDf2cRu_1793148781;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDf2cRu_1793148781 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 08:53:01 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	jack@suse.cz,
	pfalcato@suse.de,
	ayushr@modal.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6] mm: memory: fix truncation removing mapped folios
Date: Wed, 28 Oct 2026 08:52:57 +0800
Message-ID: <14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A9AE1C0007
X-Stat-Signature: 8mdkrjtb7grqui4751cbig5kpo4t9yfy
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793148787-863157
X-HE-Meta: U2FsdGVkX18cqoQve+3wwyIU2NYaYXVHPY0Q9unP5Im+0hCyBNzOIlGDbSOQosSiymIOuY66lZ1DpmLQxn6wMpsTAAYMww82w/6erISzMAL0glhmePLAYQU22fCyI7H7NGteB/dlNqmjTRM/Z9qQzBmsMyMlzIzqJtYHmdyTs2t8M6rcMbdYDxrY/Oew/mwfDH5mO/0Q/AaBcp9LXNne/EPTyGuJEAnJzwYc261x1OAwmNRFFmlMtyiwV33PA4pX2mX+07mxUs6CMQRjbwdj65sa/v9VMPa96+kbL2KGGVgEGjGGNazdpWgXAIBRAtNy4rg6kJlLhYO9A55UC+HW7r8d1b1KME/EqoVb17BgLE/tL2tNQWFNwuX/AXAkSTYZjLR9wsX6YGaL3eh9oHg48drWHLj3TyN7VBH3a8W7nFB7dj7ZWhVynTgZpVamgckcBdWRmhaPXjx43jxUtaclGEnIg8uUlxV/yfDWMjRQEoZRa0Td9GgpbA1KVHeAo7CeppfvX6r5G/qJ9FPwiqDKyoV+qHv/tGrpOoVIwRV5/bYYTWEOUbNMjphdGTwRdm2CY8hr1R70Z4pnn26s9BPKgDqoc7hakIrFCbjgey1Os4HKLnT/ArpuzVFc15xTgmW/IWEy0U35snvUBwvJE2yHHnwHbjrcvsOdAIUoA/F9cvgVT5dpCt/Qfs2Mqp8oSI7WlQJiPNJq027+FGkRkPuIIcLVRE53uXgTxIgGYRCtmMt4xqRO+/b6C/sLlk0uJPddTFJrZ458oJaliGij9MCBtC3W7+Jvu10L52LZ+gPZ944AfBcSDaD/ZxDR+FRgOz23oBoGvAG6P2BvuQn+LiLNME5dtjjkGu0sasNpBPSqflT8oMsTdsrxQdKnCeI0gFYAG1Cdf2wNAJVJsL8Yb3URtYwS9RAcxaDlt921z0fAAcKiDS+Fv6CE8gpylhUxtrIQbGmCrZyYAOZTc7uoTCc
 2XwZ5R1g
 lZFjB3tQoEZCsGgPzFzZJ7qnDGMD+Mwz3RpkUB8rb9xOfw4ByFeQTsSKKBQWEwluPSsf28U8mDAi+pYHqmyHl9Ab9IJ67rj+EeRKZDDoz0NlrSKCJdvvsRUS66FhrGvZWqs8DP8mqmBT0810Qzt37oZKDSXwk2V2FUq5XybXYb8m9ESty0H2EKD+/jXLtpzZ52bdkSe2OD1uc7GoMqafMtkYVvhgaXUmZdWsdvuS4XHHybzqbyLXmv7uC9TWA3Ker2xKlPaVoVv7gulPDV8srvFgUvzkn6XeP5SBVUk7FtF6F7cGGhjOYnbmGtKZ5c5nvsiX9K9WGVzhWl9nTOVUi+6iGhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ayush reported an issue that shmem/tmpfs folios are still mapped when
truncating them on production:
"
BUG: Bad page cache in process ...  pfn:...
page dumped because: still mapped when deleted
"

I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
branch, and I got the following crash info. From the dump message, we can
see that truncate_inode_folio() is really trying to remove mapped folios,
which is incorrect.

"
[  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
index:0x3880 pfn:0x191647
[  189.171995] memcg:ffff0000cc073d40
[  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
[  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
.......
[  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
[  189.172026] ------------[ cut here ]------------
[  189.172027] kernel BUG at mm/filemap.c:155!
[  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
.......
[  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
7.3.0-rc4+ #277 PREEMPT(lazy)
.......
[  189.183986] Call trace:
[  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
[  189.184391]  __filemap_remove_folio+0x34/0x160
[  189.184633]  filemap_remove_folio+0x4c/0xb0
[  189.184859]  truncate_inode_folio+0x34/0x58
[  189.185087]  shmem_undo_range+0x220/0x658
[  189.185308]  shmem_fallocate+0x2f0/0x470
[  189.185527]  vfs_fallocate+0x128/0x328
......
[  189.187078]  el0t_64_sync+0x184/0x188
"

After analysis, I believe the race exists between truncation and MADV_DONTNEED,
and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
MADV_DONTNEED synchronously releases the pagetable page before calling
tlb_flush_rmaps(), this could cause another thread's truncation to skip
zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
as non-zero. A possible race scenario is as follows:

CPU 0                           CPU 1
shmem_fallocate                 madvise_dontneed_single_vma
  unmap_mapping_range            .......
  ......
  (filemap_map_pages() remap folios)
				  zap_pte_range
  truncate_inode_folio		    zap_empty_pte_table(pmd clear)
    unmap_mapping_folio
    ......
      zap_pmd_range (saw pmd none, skip)

  filemap_remove_folio
    BUG_ON(folio_mapped)
                                    tlb_flush_rmaps(remove rmaps)

To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
concurrent zapping, so that when we find a pmd_none() while unmapping a folio
without holding the PTL, the folio's mappings are guaranteed to have been
removed via tlb_flush_rmaps().

Meanwhile move the second pmd_none() check to where it belongs: if splitting
zapped the PMD.

[1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Andrew, sorry for the trouble caused by the several iterations:).

Changes from v5:
 - Keep the 2nd pmd_none() check (per David).
 - Add Cc: stable (per Andrew).
Changes from v4:
 - Put the pmd_none() check in the 'else if' branch (per David).
Changes from v3:
 - Collect review tags from Qi, Pedro and Lorenzo. Thanks.
 - Update the related comments per Lorenzo.
Changes from v2:
 - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
Changes from v1:
 - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
---
 mm/internal.h | 10 ++++++----
 mm/memory.c   | 35 ++++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b1b0f29d2216..ffb8eaec90e3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 /**
- * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
+ * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
  *
  * When we find a pmd_none() while unmapping a folio without holding the PTL,
- * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
- * indicate that it's unmapped. Skipping the PMD without synchronization could
- * make folio unmapping code assume that unmapping failed.
+ * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
+ * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
+ * for the table have been removed, but nothing orders the pmd_none() read
+ * against later mapcount reads. Skipping the PMD without synchronization
+ * could make folio unmapping code assume that unmapping failed.
  *
  * Wait for concurrent zapping to complete by grabbing the PTL.
  */
diff --git a/mm/memory.c b/mm/memory.c
index e911e63ba1ed..e0fef107a022 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
+	add_mm_rss_vec(mm, rss);
+	lazy_mmu_mode_disable();
+
+	/* Do the actual TLB flush before dropping ptl */
+	if (force_flush) {
+		tlb_flush_mmu_tlbonly(tlb);
+		tlb_flush_rmaps(tlb, vma);
+	}
+
 	/*
 	 * Fast path: try to hold the pmd lock and unmap the PTE page.
 	 *
@@ -2043,18 +2052,12 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * to hold the pmd lock failed, then we need to recheck all pte entries
 	 * to ensure they are still none, thereby preventing the pte entries
 	 * from being repopulated by another thread.
+	 *
+	 * Clear the PMD after the rmaps for the table have been removed, in case
+	 * an incorrect mapcount is observed after unmapping the folio.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
-
-	add_mm_rss_vec(mm, rss);
-	lazy_mmu_mode_disable();
-
-	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		tlb_flush_mmu_tlbonly(tlb);
-		tlb_flush_rmaps(tlb, vma);
-	}
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
@@ -2101,13 +2104,15 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 				addr = next;
 				continue;
 			}
+			/* We already synchronized with concurrent zapping. */
+			if (pmd_none(*pmd)) {
+				addr = next;
+				continue;
+			}
 			/* fall through */
-		} else if (details && details->single_folio &&
-			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			sync_with_folio_pmd_zap(tlb->mm, pmd);
-		}
-		if (pmd_none(*pmd)) {
+		} else if (pmd_none(*pmd)) {
+			if (details && details->single_folio)
+				sync_with_folio_pmd_zap(tlb->mm, pmd);
 			addr = next;
 			continue;
 		}
-- 
2.47.3


