Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8632B606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=n4ScyBza
Received: by kanga.kvack.org (Postfix)
	id 94B736B05B8; Mon, 26 Oct 2026 22:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAE56B05B9; Mon, 26 Oct 2026 22:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8118C6B05BA; Mon, 26 Oct 2026 22:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 561956B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:19:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5887808D6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:19:34 +0000 (UTC)
X-FDA: 85366799868.16.6D8920D
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70FE640005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:19:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=n4ScyBza;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ccdnAYb1+Un6I4/SsLverI+ggeaZSybTW2CMNCYr3HI=;
	b=L7Kgj19AsuhP+OcFleFYM8K0a+EK5yJRcMjTUNZNpfLHVb0QFSM8eKo2Dej5kbs4UF+DCm
	sjQkoD/4nMqTtakTcbZ0n7wY0PT69T24aPgRYNR71iBSglKzK0d0T+VgrhqOnwTGGk6oeK
	hbujPfHJKCsmatrjat65br8yHDo2J0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793067573;
	b=lrCjCFYhqMc14nB5sP2NvGYpcCZ7kjiPHsVCTzvSIQa+gJ2KEno3kjyj/W1aGPzB5EPBcv
	EXctMRUF8pFzYmF4kbTsf9K9qVSVl7lpGdfZpH9D9K3IbS2b0DZehHfdS+DscnDudbz8HB
	EvdmBze/A+M7hwWeZ0jZdTY+oD5UjuQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=n4ScyBza;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793067567; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ccdnAYb1+Un6I4/SsLverI+ggeaZSybTW2CMNCYr3HI=;
	b=n4ScyBzazG2cz7xo3Dl7caSMTkFH870zbnK5eNjPhk3Em1zA6D8+CWzZmiZ2bn3F+WHV9Ky1kjfAlanmf7RQ3smHdZkrZn/S0EeJR3GN3P9x5ayNWSNalUu0aG3X9NafgTCl6DeqfeiICCrhtucXYQEW05TeXjECD0liHgOrHoA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XDcCurx_1793067563;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDcCurx_1793067563 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 10:19:25 +0800
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
Subject: [PATCH v5] mm: memory: fix truncation removing mapped folios
Date: Tue, 27 Oct 2026 10:19:19 +0800
Message-ID: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 70FE640005
X-Stat-Signature: kty53uwi1e3e1wcgzgmjo1tcswq1bast
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793067571-294204
X-HE-Meta: U2FsdGVkX1/+D9uRI5giyYZcnmAa+414pTRoF5cAmgRSIJ1fRPKPBwpfE0+MU4x8YAOvkej5yk3SNkdAqlzhK4iixF5gLZhsYBR/19bx41xpZCBsB0agnhwlkcB8p5TUMVxFc6TUPBmJiS9zwtGvsZAnw4J821RZKmjow/OuDbdMKUCSPwcPOiEztHmJOxuzdG8sPM4OhNak+F6Ju9OIvZ9psLE5sXFRzlouPBRxUlbnt58gDpP6jeIJx0Yf4zjJCY9/ZMm3aB5t02kXa1geuZhqpBxkIZ6hdQJycL1nQVLj/+Tp9Vuq6oG0Hx7blOUEYJfpPDpE1T6ejk89GdfnddiWijoI/QacptFuKytGVvmgEL77w0aT2TcBQ8KBXkiE2nQCv2OGwgJRapNKQEdN8A4TgFbjOXVOHfFtjC7Q0dG6qCH30wzCDj6TkkAIVLXZyeFPhDss3JJDycCLywGBMkrRSFkvicr1fizAIm+5Ap9Ui4tb8SYy1AH7KRFg6FkK9Sa5O/ULApI7ze5/7nU67pwsOSu1z79gd6u8UzRzbLmL2JTkE34ICBKkzc6WH57Hox9bY15qNwN5WauXna7ORRWMC4AA2B0kLqpuXKMj3ZTHa3V7fJVDV1jc1pw0TDJfT+nX0tngkuIom40CqmgnOoswkTBNBw1a+rdQcGnfOtVemmzwLxzaa1aCNO2IiWKI1Ig+X5qeOqvA+geTM2f8VV4j96yWhlVFyHhEzWh6ELCMD7ci3v3/PJTJLKO7oI/UeZB5o9/rDG+7OMIirMvQkSGhZ9ecFvVjG2GevTCkkrnozZNXww7FN1S1P5MRDb+pUOFZbVyDMCWH5cJlwhzw5FkmoqUeG3yG7wMRRhF8K/WmekMhdQNN8pBo6gJUmMihpWVletrCBxI+MncEc69ZkON/AMODz7sGcYCYtAok6eweq2DdSd76XxtINYpRei0zrfh+95GZXFTfAPiOgA0
 sS2wZJ5e
 gDLaC3uvpM4itmVVCwwVCegSFKZbWgTgO/amGLILxLsEKzjNXA0h1s14Xaq3YKiiSgP1XOTnidAxiXfAuln/UoynSdmcAej2Tn2ACfIuaiRvXdqa2yJ4iFXGUbutxiT6gpsvAng5a8R/wiKup0mQaoDCsnPYc5tFt41avOHrXDBORRMsPKJXx988kHJNevBjJ2uMW5mG7HPpejUdKy0sjtXKRYJL7fQFO+8y+xuNamyHSW6OlO7eQdEJkkOFkdMXyV02xRCtmB1nYarzjC+RDZjMNZpPT9jJaZNaj5Uozmg2cwDPanuEzNbTDcNjbkveImaRD7/kbizvgIhGibqQ8bjYcsA==
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

[1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
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
 mm/memory.c   | 30 +++++++++++++++---------------
 2 files changed, 21 insertions(+), 19 deletions(-)

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
index e911e63ba1ed..d9c54549b85b 100644
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
@@ -2102,12 +2105,9 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 				continue;
 			}
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


