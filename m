Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC9FCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66676B009B; Thu, 15 Oct 2026 21:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17CE6B009D; Thu, 15 Oct 2026 21:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D3B6B009E; Thu, 15 Oct 2026 21:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A83696B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:48:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 263361C274F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:48:24 +0000 (UTC)
X-FDA: 85326804528.11.0604629
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB84FA0008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:48:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OcqyarB8;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792115302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LLaEFGzjefQlmmxbLZnWE7wdh2FWfwhycK6l3OIcEbM=;
	b=V8k3R5eRel7//azuv0O7mIDMUlfuRK7ermZvTL++6/vv70q0uA0/4W3kn5slUAWRPhF4Sa
	pa7i4LYxgSRVTyhqGo497dIUbYJYj6BpU4mwlvpBBkJ0iM7P/vrsHX0Hrtqbz8nzn02IAR
	+j4OODlhH44vV0eYn/OW64s5+nOHt2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792115302;
	b=gYWacyWdt9RPAT29/El43NqxoBbuZFQ9QPKxiyX36Hj8js60IF32k7OyGU9dFamo37L5c0
	VrdbSquqhvpSRemHAUbq3ELOESKC37QSvhwgk4rXilK6ApjcQxrZrKzkDzjj7LOS6YwvWj
	sE8XEGoV5z8S4CxCBC2P5o6XJE9YDD0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OcqyarB8;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792115297; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=LLaEFGzjefQlmmxbLZnWE7wdh2FWfwhycK6l3OIcEbM=;
	b=OcqyarB8rPINVJ8xmAcNwJNAO7+tTQUHJU1tpMo08O8ps6vh0UKlLFcCCILXJi9YI+GqsB33dF5C7oT1qbAknrWQM4q/1kHRx0LI26QQn2Y/68NjYq4kJNWPxK9FrGw9Lx3++LRyEQf0oo5RZTVUwYZ7d8RR1YcqERK2L62zSoM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XCsyeaM_1792115294;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCsyeaM_1792115294 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 09:48:15 +0800
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
Subject: [PATCH v3] mm: memory: fix truncation removing mapped folios
Date: Fri, 16 Oct 2026 09:48:08 +0800
Message-ID: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB84FA0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4k1uw9juoysdj9d69ph4qpxj7jk4sb5t
X-HE-Tag: 1792115300-166066
X-HE-Meta: U2FsdGVkX1/CeKfpjsQJzB79jyLT7c2/QJeNMIrokxYvhMHwgQ2DoorPMVnpBmxaA9XRiXsfVy9tgh5bBqu9v2dPp00QIBLj+jhyLvobedi//zfnb4eWXqxC21P1m3hKEKgcHxLQrh7LLxZqRsDP1ceeL1JL+aKrL1aMcPQcrufovSuG4xFU1SwxigxJqzISOZUYEgewej16letGH0zlJiO4JY9NETujTFp+1QoWdcVllIPJ88mfJZ0XkPabxG1rEqmQWFLYeR5o6H3aE8f0227F+24r0ltvU9eshOvIDzyiYhT40aoDkeN6XJ7fqZu/N7CY+REYRtq41e3hAXR2oL23xtnwVGLbrCG0OP2MwMefJf3ZFDNe6pwuZ6L+hady89xbj3W+PgCzpPx7qZrd0zrTGkXMvVURy+RhcB7bunMj/fKadzwjtY4AHiBZ8PuJ3cTpfW3pyowfKyVvwjnueBYYNv9dXgh/p6HzRWeGYS1TZzFm2XrTNYTRezeWwrTaqbjQ71SLKqkW9j7Tb2C/s9oWqbcD3afBa6nQsk0R7cizSlrFFbFkcJpxSXN42xjv9wtW5425iRH/Owdwv8OCwDDCBxURAuVx+3TGEx8SHaPzKQkgwr0ajioz2WZd0prYkbHnoISO7ukenjb0UjfPPFnayANyGkU0o8NbxwiZZUgoDm3m0hKYKyFLyz0PYzq2Yr1oPrBMfElUlGK3njnkKLJ1tPStBcwNT7y3HxRW/+Qr8S6s9m8Iuh/1cxRioGJZ5XKi/lLFLYEayneegcfXoSuDChZFonGxc/DLSlpZVmgQwWwE+CxsCvUSvjCqWEF0Fbw2sqjvpOSHfkUTX60ftrA0a85I1PpA/p4iP0Ypc2YdKtyls7ESJECG8mNHNSpdlzkk61e5LSLfSgDY3pJ/pS2a7SNThO2F8vbUEyohuvDN21OSS161UvIl5h3yhaDdsr650p7aQvtqKXmLQxn
 UuU+cejd
 wIdc0xo1XUb7MPVNLMrAEaGISNJOx1Iqe9LXudgymbuU3V0O1HqCM6pgAMnlCIoqSIY/eBvvHTu6rxD1jvj/J2rwK8xd6QqwTzAVf1Jt6DbiiqCAD6gxR5BUNeepg5UI7nwLwu0yqL28yY6tu/bN65c62gZ5ieaiG1zET0AAbBmJ/WULQXkW3HIYXIblpKAh95VNJwYpCvNaRkkV3Q2ARlpAeOF5R2vQV3ri8YMRJ1Fqoq4/8LNdKnQz58P79/BjEx67WYen02k4YEGKN6+lbU/rYQ0AEYQukIC+rOG3HXmkPMG/D3lBuzLo+m0NzkxkMVI0OEqnSydj2ACcCOu4dVKWTiw==
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
to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
concurrent zapping, so that when we find a pmd_none() while unmapping a folio
without holding the PTL, the folio's mappings are guaranteed to have been
removed via tlb_flush_rmaps().

[1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v2:
 - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
Changes from v1:
 - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
---
 mm/internal.h |  9 +++++----
 mm/memory.c   | 25 ++++++++++++-------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0434dfcfc36f..6d8f494296a4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -585,14 +585,15 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
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
+ * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
+ * yet modified the mapped folios to indicate they are unmapped. Skipping the
+ * PMD without synchronization could make folio unmapping code assume that
+ * unmapping failed.
  *
  * Wait for concurrent zapping to complete by grabbing the PTL.
  */
diff --git a/mm/memory.c b/mm/memory.c
index 6a8e7772b8d6..8f7ba427371b 100644
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
@@ -2046,15 +2055,6 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
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
@@ -2102,12 +2102,11 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 				continue;
 			}
 			/* fall through */
-		} else if (details && details->single_folio &&
-			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
+
 		if (pmd_none(*pmd)) {
+			if (details && details->single_folio)
+				sync_with_folio_pmd_zap(tlb->mm, pmd);
 			addr = next;
 			continue;
 		}
-- 
2.47.3


