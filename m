Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC77ECA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990036B008A; Sat, 10 Oct 2026 03:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940A96B008C; Sat, 10 Oct 2026 03:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FB46B0095; Sat, 10 Oct 2026 03:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6241D6B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:22:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76336160805
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:22:32 +0000 (UTC)
X-FDA: 85305873744.07.6356E6E
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9F181C0002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:22:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=imxhWruT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791616951;
	b=T2hmQKVJwAgMs61FBtmHbFIM1J7Wmm/ra2MXai/0wqe1snHWp6f7C9z2tJk0TFzrv6pJDg
	HTGMoV8VRZS/RDJU+4aKGvaN0NuzXHxt8Z9qwtmaoM/p+m5AXBLDsZtSoDaJTWH8w+QMac
	y2zRCJUYKqJCaoL+/lRHxgIrEqx4S7c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=imxhWruT;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791616951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B59eKz48QTnX2ARPpq8qFAJINrZhesaJWeIJztf6e88=;
	b=1ENj5PCHBx3NLJfROplW7ssusAkdQTnjpUERlVBI9LWUX0DEfbT1s7ys7xk+zRBmQLbji9
	9tfFtJ/jBjYgnCmbQbBkE3ML8Fb1Wa/TTqdU6EEkOOgHX9hGEyBr73bso7r9JRPMR6/UbO
	IWhurKd1SHGcZ/iSavaxP7KE6cN5Xl8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791616944; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=B59eKz48QTnX2ARPpq8qFAJINrZhesaJWeIJztf6e88=;
	b=imxhWruTmi77blY1Ok90wj5W+xSEQG+T0g0y4fEbD1b5eoVXV1K6EPUY5iO53xpEiq6PNoLefCxIHHkh41LZWIlto7ZM0Cu8cXafBSMmASzWVcOGstr51/Zwb24GwTfSBfVi46FTzvGsAfiNvajuWKEr80RnLCdothJUXXquAaE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XCVONvN_1791616943;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCVONvN_1791616943 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 15:22:23 +0800
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
Subject: [PATCH v2] mm: memory: fix truncation removing mapped folios
Date: Sat, 10 Oct 2026 15:22:18 +0800
Message-ID: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qfhshdjwuk114t4nr8gbijsdd43xpm8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9F181C0002
X-HE-Tag: 1791616949-2981
X-HE-Meta: U2FsdGVkX1+NZ0JG9UxiW6HP4Lkxu3cT04s8YcCCNYc3HFgPCM1/JTcwfYAH2ILJ1W4tDkEb5mEOmVwzs/BFGzyrO0yhXPHbzj8ZkVfNccFmdekkQ5D9pbZh0i+e7cjtHWXOhQxl7xfAE3MRBYkoz65WHGvgD3dpZRFUne8oXkT2WWyOeP0G6Nc3CUhPO3Qu0tygYCg+nHjcCA/4PxdLSDEYbSHiwU6BxiCrnsCRNYhWd7/g7/X2sUdGx/IkHUee37o3k8DfE/vhZypPa24MYQ0zd8bC3+Q4oWTNLLagwROM5c5GMswoHnThEIlsvTJzbWG0ICb8a2Uv3dQtKho6EHeWNJendWkahl4O6Th29EHrslnzYF8wvQulvAKtohtc8Stm14T7ZwJN2I1SYQUpiPiCHoc/IHKZWUvzk2Aez/OcPlBzLC3rPdcoEpOKdwSPPdBaZW8aHoP26W3XsBj0Sk6R2TW6gAWUcvR3+1K0Zx+owFgPOVbWeRF+2Xk4qLwo5JbVRxFWGmK+nRWBYlI3KyWouaWVdVo1/5EWVKnC4Frgc1bueQkrwqfwrUpjakDFB0/GoNGZq3FbpjGMriBnVjMdPGeywcBQ3Kflzm2W+W8ros9oQtG3G+ZXFy94X2EZPlhpfLhCLI3nOvIz3pZtblx1Wj9RM3Hsmt6ljEBm4CSsd0zme28pAnK1SDiIpk7lxWrRH8D+uyUvc8azF6kwLKdHN4YHr237zWLNepyAiAN5iBrk0bs5hZhaPafFvdLGOavnT9s8Y1DeOSLmh9fAnoLrz36oCqijFgVgYI1BAx5TjSWKbXgKB8J4gNVj09pL5ZpFzopRx+teGJzKkLae/LDXjDAI1rgPiqqEPBaacz+N7lLqlecR7WuO1nSm8RPCNbJ/T9urLGTKEwJiQllz0DUm2rVMtp2aKzC0BTnxmoH+G2NwTOwHPpb/ryG2u+lw2qlhUMx54iIE1xNobEB
 LoHC3IK7
 H1s+ZpcRBAPKBoaeYxuJm7DiwwzFd7/05ylbP4kTt78sdYmoQ8MYL+zbMY1TC7HGhwdXQM2fX8Lr9ahki7X5XThJYur3YobQdjjX4jUlaYsbFht9IgERqdjh+Kqj6W0IecVJ7PdLNYObpXfax6aev/2tfFwNcOJes63MkYsFTupJfl4KMblq/GmLyPfm4sJTeGZEXgjehM+PGeen1zwXWIkzUI8NYLgTEdEJAMZkNT1hTrvkS4fRkt6TWPlMcJJBAWQYpvPKsQ4u73fBQV0Jg6pVrD0s3ipomDOepfqDCtvGmhIcr3g/z0KdDyrikF9ijsB7jVPzopGxeiSI9UuVE9xJgNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
to after tlb_flush_rmaps() and add smp_wmb()/smp_rmb() memory barriers, so that
when we find a pmd_none() while unmapping a folio without holding the PTL, the
folio's mappings are guaranteed to have been removed via tlb_flush_rmaps().

[1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
 - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
---
 mm/memory.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6a8e7772b8d6..c3a1faf580c8 100644
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
@@ -2044,16 +2053,13 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * to ensure they are still none, thereby preventing the pte entries
 	 * from being repopulated by another thread.
 	 */
-	if (can_reclaim_pt && direct_reclaim && addr == end)
+	if (can_reclaim_pt && direct_reclaim && addr == end) {
+		/*
+		 * The rmap changes need to be observed before PTEs get zapped.
+		 * Pairs with smp_rmb() in zap_pmd_range().
+		 */
+		smp_wmb();
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
-
-	add_mm_rss_vec(mm, rss);
-	lazy_mmu_mode_disable();
-
-	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		tlb_flush_mmu_tlbonly(tlb);
-		tlb_flush_rmaps(tlb, vma);
 	}
 	pte_unmap_unlock(start_pte, ptl);
 
@@ -2108,6 +2114,11 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
 		if (pmd_none(*pmd)) {
+			/*
+			 * Order this PMD read before the folio's mapcount read.
+			 * Pairs with smp_wmb() in zap_pte_range().
+			 */
+			smp_rmb();
 			addr = next;
 			continue;
 		}
-- 
2.47.3


