Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77465606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgJTmamX
Received: by kanga.kvack.org (Postfix)
	id 9BD856B05B8; Wed, 18 Nov 2026 04:21:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995FD6B05B9; Wed, 18 Nov 2026 04:21:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884F26B05C4; Wed, 18 Nov 2026 04:21:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62E0F6B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:21:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A00AA0347
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:47 +0000 (UTC)
X-FDA: 85447697454.24.7344DDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 857AE20007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgJTmamX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+A+DaVuQhI2BpuaRmABmCIOJxadlMBJlLIpCJggjeU4=;
	b=iH1LvpLlp0NL3/gG3Vay48XNKUO4K1Hi5Ri6h+M8VGofhMiJYBCacVWwha50lDa+y8Se7y
	3XyyLI8KJOv8KUeHvblO1sSxX8owRsK6auBvxmzw4iAxuie0TTA+8E6x1Elm7Je90Z77WW
	vg+woKFdJmWbBvG0vWrJlWg7zgpqQ7A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgJTmamX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993705;
	b=aKu/dSYDHdw1BKwHtpm5jQl7KsqIVbBdGo6ys0brL7Ja0w2OB+MnSOLaz2wvy+XCvmkjHj
	HQi1OPAGunA2yR7Uaap7vZZiVyQnRXD91EduXDJoHH351Olh6hHO6yDNfCgldoLPcZQ2kL
	cQr+Bd8WSZsm35vg7fClObRDuyXh6e4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1891561E99;
	Wed, 18 Nov 2026 09:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0FC1F000C5;
	Wed, 18 Nov 2026 09:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993704;
	bh=+A+DaVuQhI2BpuaRmABmCIOJxadlMBJlLIpCJggjeU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HgJTmamXcwBkMFxTwdykgx7KqlV4Ktekk+Qe4xLRjXPqboOoKSeqoYV1GFf0OMUF5
	 JtAOInPU+60WggS4ut7zIKa/dJvBCN15zcdvLrgv9vkstJvQztZ//S/nbx+Be6iJ1C
	 6bCELygGMS95/1npJTaM+YkIKoIlPq/peyKQ6HFiIoZ7oMAhfHRk5tyW32CiA4KwEb
	 cDGHj6o/mpIlqUubU4B5a8o0cIR603JITxUdlkNzYSYuKJkYaraWeIaUYThmJSWaFO
	 G9KEPEIIfhfk+6wnnqOO6c+6+3om+zsg/F8BNc3Wwv/ZJa/HGwIzq0J3DYwpHIDxnE
	 7D9oYQZyeWB0w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 10:20:38 +0100
Subject: [PATCH 3/4] RFC: mm/rmap: don't defer TLB flushes when unmapping
 lazyfree folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-file_folio_flush-v1-3-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
In-Reply-To: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, 
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>, 
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, 
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, 
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3960; i=david@kernel.org;
 h=from:subject:message-id; bh=ONBH5D/i+VTsWjjM57E4YzlaWuBVMuDrbAIt1Zwyipg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+5v4UllTgfdLg97P48S/GDg/BkpdPNQRcjoud3dYSY
 d/ptG5CRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABM5k8nIMCNpsWeVtukXplm7
 ZQ/8WtQY7W/U837tdJfDh1NulV1WamZkONY+qdhs6qULUu8dA04+OKP1Xuowy+WuuzzsysLVq0+
 28AMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 857AE20007
X-Stat-Signature: mezjreut76tn39wdrifyw4ds9s7em7mz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794993705-52636
X-HE-Meta: U2FsdGVkX19Yk7HIl+WKnDN9pPdaz3T/vs/hHj4zzdcaBYV4ws2/9XTtLdt9V3KNm3FRCep2zGjsyzmHw4No7t5SWw5Atq2aJQJBfulmxNd09ek7ptgxzvyStsRxRJgJ6QHSOj0C+plvXBJ1Tpy1RWhrpCZmFEgyoC0xn4Mt67pFrzqtFBpc+koq6uS3/2A5r4z9zQ2nP/vxGxuYh5WDI1d+L/ZkMmZHSvUJCW1WiV257vEQuAtux7nqqpwPJN5JbzU/iHPJl5Ec0eMBTDbUM6Emc1dH+c+wJocCEUjnVKERtTu1i/PjfhUSe0xx+ybe6HfqjApxTyCt8l27FuQqtv+hu9ARLYlwDV1noMgtJcGQCqYYRtjqAF5QvC6KIWhKZPqkfX82tWPN6Y48gPN6WvBelIH3sRxCOgsz5wKMp0JuqYlOeGW8TPuHP/VBCUvpRLDQcNKV3Q1C3rEYWceehMBtzP1JmCQKQLM+Eo22MqBwmaP2/S84M0kLwUGKA8OiiB5Z+AMkpG5QX4Vv69ISub9ZcU9MumjYdb2aXsPG7pvSlpzcfVRnl/pdCK9QjBrM4lqWLwDrFJCyk1wqcNN8md2HxtIncKVT1hcZS+GDbdsdai24YM6frSKlUq+mVyZG+otqh6TBJLZHYNAf/1ryI2Ce7cGV47hXDNXMtQavhLCpf+oo4a0UH9c1nkDOnXRLqmays3lXnkBBnE48WLlYqaDzV/Un/J8pCYZdYBLaHB0vta1AL1W1+5xgQFNm06owykPabKTWsuYEksoroSLPRXOxW0bCSk9HSTv02Biad871KsW3qlFfcZfvdAuk1x1DR8W0kSD7FQbxxRrUUx3ZeQ7hhv1yM7Nxwl6x7DHX66AF5Fjn/zqdWLuef40SoMS//vkMF/qvD0yP2AS+cUE0EhC0s8gzjcTmG6a+2hQzKRPaHvIf7wNH1NLgsIwAykSE1FpVGYiGHJ/I16BHeHn
 a4roFG5U
 6oD3csvMEVcIQh3mkDc90elGVhrPZ/IpGeHIvgzGVQG4OPTZA2mBEVLVfLl/Ez3dk2MQK9pqIiPFVKerQFIe9Ufm1+pjDuWzjeBMB97C/in+pX4JInwQ8OgVGPwvdRESWlVIM/DIa5r07/Tp2JGnVSWQSU/TsGc2B6ko2iUlGyLTpsnoupaW01v2yjBw00wMxG89CKlVDf4dEybRs45oYi7k/wirJFKZ5xan4x4x9BMSO99gr1ZNb7KfH0dxqrLoMzrk6w6HL/dPUSoQwvK/xbX3s29tgws1ZM0TspzBJ/4nI03YS/Q3hPWSJqyduWDwJ+DqeOafK5/dGQ0V5YfpTRX46mxcC4YSfYRoDg/mc5JtIbX2uKQpEvYXYDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When reclaim discards a lazyfree folio, it clears the PTE but delays the
TLB flush. Until flushed, mapping a new folio into the now-none PTE
can leave some CPUs still reading from the old folio while others
already write to the new folio.

This is hard to trigger in practice and would mostly look like a weird
use-after-free bug in an allocator that uses MADV_FREE, but it can be
reproduced reliably with three threads pinned to different CPUs:

(1) Thread A populates the pages, MADV_FREE's them and then
    MADV_PAGEOUT's them.
(2) Thread B reads all pages to keep TLB entries cached and verifies the
    content of pages published by thread C.
(3) Thread C waits until mincore() indicates that a page is no longer
    present, writes a new value to it, and publishes it to thread B.

Thread B can then read the old value after the new folio was mapped and
the content updated.

One way to handle it would be adding conditional flushes to
do_anonymous_page(), migrate_vma_insert_page(), UFFDIO_COPY and
UFFDIO_MOVE ... essentially anywhere we install new anonymous folios,
which would mean that these places flush quite frequently on concurrent
reclaim.

To perform targeted flushes, we'd have to keep some PTE markers behind,
which is also rather nasty and not an easy fix.

So let's not defer the TLB flush for lazyfree folios, which includes
folios in VM_DROPPABLE mappings.

To avoid flushing if the folio was redirtied or has additional
references, perform all non-deferred TLB flushes only once we know that
we won't restore the PTEs, right before removing the rmap.

The downside is that we no longer batch TLB flushes when discarding
lazyfree folios, which harms performance, but is the right thing to do
for now.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 09c33b9ec5850..3935eed23a361 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2228,6 +2228,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
+	bool flush;
 	unsigned long pfn;
 	int ptes = 0;
 
@@ -2253,6 +2254,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		nr_pages = 1;
+		flush = false;
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
@@ -2339,11 +2341,18 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * architecture must guarantee that a clear->dirty
 			 * transition on a cached TLB entry is written through
 			 * and traps if the PTE is unmapped.
+			 *
+			 * If we don't defer the flush, we flush only once we
+			 * know that we won't restore the PTEs below. We never
+			 * defer the flush for lazyfree folios: if we discard
+			 * them, the PTE will be none, and a page fault could
+			 * map a new folio while stale TLB entries still exist.
 			 */
-			if (should_defer_flush(mm, flags))
+			if (!folio_test_lazyfree(folio) &&
+			    should_defer_flush(mm, flags))
 				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
 			else
-				flush_tlb_range(vma, address, end_addr);
+				flush = true;
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
 		} else {
@@ -2402,6 +2411,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 finish_unmap:
+		if (flush)
+			flush_tlb_range(vma, address, end_addr);
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
 		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();

-- 
2.56.1


