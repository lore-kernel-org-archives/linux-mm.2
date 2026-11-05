Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3704606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sJhi3beE
Received: by kanga.kvack.org (Postfix)
	id 355706B05B0; Wed,  4 Nov 2026 21:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306726B05B1; Wed,  4 Nov 2026 21:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C776B05B2; Wed,  4 Nov 2026 21:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9BE16B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:56:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67ED1A0925
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:56:46 +0000 (UTC)
X-FDA: 85399552812.25.4A10AF1
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E100100008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:56:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sJhi3beE;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793847404;
	b=CdNgCrpBGieIGltgYtwjcrqt/XynyRZhOFMLJqvSfuCL7BvEG3jc66A6x0z2ZnwDYGllLl
	RXl2bLGw3/JTfPXKQSn2WaexB5TBKStmdynL6eoRtMByJXMRIy7qdvKBzfxLpuve4li8Ml
	vqC7oc6KpyX8NgNVvf2dFpJCpPj7/CE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sJhi3beE;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793847404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e7HItsBXSCgxUc39U3iHUfM+8l/Wb7Jodni6FIfl/KA=;
	b=40dZKe/Xpca0viJZEuxsz/p9N9JOB6gUeInJEtDZ9wvw3OEOdKoLCnatccO5l629WULQBm
	BJ/685+bBEBEMN3jjEyXiXJIKp+5s71gzI19+b50eB8NjLOPrROxqKlNml77LxRMCG2kBC
	D5FglPsbdpQcmEJvE1f08w5kMeP+W3M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793847399; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=e7HItsBXSCgxUc39U3iHUfM+8l/Wb7Jodni6FIfl/KA=;
	b=sJhi3beEBbsEJE9qy/YnTi+EiZCxX2WyfElrwLg3DzOlo6HeMMD+4xHjp/9asCxLslZKpJjLzOYWqgDBRMgPucqE5hrjxSaqp2FmPEJF5IFz8xpAPr/P26XflXQ+NWCmqCCT0HiFytm2GRM8aEWMmqa0HJQ9By1AuYRN2rkcUNY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XE7G6W0_1793847397;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XE7G6W0_1793847397 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 10:56:38 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	qi.zheng@linux.dev,
	pfalcato@suse.de,
	ayushr@modal.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
Date: Thu,  5 Nov 2026 10:56:28 +0800
Message-ID: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8E100100008
X-Stat-Signature: jqfeaw6bawy4cej7ck5tjcyu6bh3i9nk
X-Rspam-User: 
X-HE-Tag: 1793847402-98858
X-HE-Meta: U2FsdGVkX1+S823XdYl1Wc92qcxad5MAZyqbo8gwgkvE6COTsM0HLwC+I05ENLpRv/ZeA+8Qfg70KIUDXc12n+Cgfj0o46tDGbhJZWzhXt7vVaOasZaCfZf00nMw6Q0suQ9apA6qio29fxLF/miBxfrE8d+SCrtT4fa1DDCTzbylNSfuRJj2snoJwlBy3ePrWpdIS8Eh3+neSvPApgTk1isYugkRFjEkU6vH+asaJ+oE9YIVa0XY4gPVNzOWCWlWtBdiLXSoasorm7imZqkYdb7T4D8Jb/rexeEYrBXZWhu4iluZg65FSGA63/xReEn4dftT37y+H8dkOH7bz4wMyk3j/OVM04nwxdAOj5Y3kHchJF3tKhtTfoEob0TdCe3sYJ/1hy1sfFmkV6qAq/MfBvfNrDcvksYqqp5ebtQA0x6lcUcMEM7ty18AoXt9fewsOUIemcAXJInoFyLnKklJo0miq21jnjcZd4Hfpa0PbfjswPahb8wgGSyUbrw3jmPIjfq8Z6ttn7WaGEZ6BAqRoHsL26fGclxZ25EW3dUMM1TazbIx2NVHfzXDKwQyk06x28PkeD6uf4rjyXZcl66cN7m2MLezL9y0/Rec9pWIQHnoTphJrmgYc0lAt6/EMYb2M99gOWqS6JW7q0z8GHTNeRzOf+NYEm4ftcseH//vSKpIFsud06bqPe4TKg1eIkloIfEsp3JwAkLVF0AvocAEE9Kljw7eY3/hLyX4QB2BfpY4s7R3N5BpWLrdOwLlrajFm7kRvzKPQHKvnHlfsEOpMKIX14oNmWcdOmw6DEu6gaGYklj6zCeqfwXZ4w9lkCA05Qd7v2sDhiIDKXL3dTw1N+AGlbRYWEVvKxG/R2mMP6bRc2aO819X/N2Jz1lEex+GbYtxXpO6hRITwne4mMtZCU4376ELqs9eqFU0SUJ11/6A2vHPN6cQBWqQ5aJtWD1qLMevTpMu4FRcNo8rCXZ
 GGF9hE7o
 UBO6pmKCPpAcHkTYXxyQfocXqKBkZGAWXoxV1SQSHkDIZ80yf6YptWmEjDzsxB3ZSpkpBWigbeEvNsMt6tAO8Pzmj5V5ZF2jFjjVt1b4vPKLjo5u7owbktRt4EivqkxxilSdhOeTVCY85VKP8QJyD5dBGreQAtifpGd9ewFD573DJwvVtEn7oBXC/KtX2oGQAF8IdgNgohh/RiGh7Lgp6kcIo64/+PxdxPXapluOXq8XJJXYum5oc/AXBKcdKDwEM2JFavwACR1ZASUr+2JRuJRF+Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
with concurrent page table reclamation via zap_empty_pte_table().

page_vma_mapped_walk() is used by many functions including try_to_unmap(),
try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
and try_to_migrate(), the other callers do not perform post-walk accounting
checks, so the race has no observable impact on them.

For migration, the race can cause unnecessary retries. For reclaim via
try_to_unmap(), the race can cause failure to reclaim a folio that is in
fact already unmapped (as shown below), which may lead to unexpected OOM
or increased refaults.

CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
--------------------------------    --------------------------------
folio_lock(F)
try_to_unmap(F, TTU_SYNC)
                                    zap_pte_range(full PMD range)
                                      spin_lock(ptl)
                                      clear PTEs
                                      zap_empty_pte_table()
                                        spin_trylock(pml)
                                        pmd_clear()
                                        spin_unlock(pml)

  page_vma_mapped_walk()
    observe !pmd_present(pmde)
    nr_pages < HPAGE_PMD_NR
    skip synchronization
    return false

try_to_unmap() returns
folio_mapped(F) == true
nr_unmap_fail += folio_nr_pages(F)
                                    tlb_flush_mmu_tlbonly()
                                    tlb_flush_rmaps()
                                      remove F's rmaps
                                    spin_unlock(ptl)

Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
has already moved the PMD clear operation (via zap_empty_pte_table()) to
after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
issues on weakly ordered CPUs.

Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/page_vma_mapped.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e6b6170c2f4f..8797467b6f0c 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			if ((pvmw->flags & PVMW_SYNC) &&
-			    thp_vma_suitable_order(vma, pvmw->address,
-						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
+			if (pvmw->flags & PVMW_SYNC)
 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
 			goto next_pmd;
-- 
2.47.3


