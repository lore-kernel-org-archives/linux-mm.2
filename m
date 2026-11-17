Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555BA606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 03:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=csZmWHhe
Received: by kanga.kvack.org (Postfix)
	id 6EB5B6B00EF; Mon, 16 Nov 2026 22:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673D46B05B0; Mon, 16 Nov 2026 22:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C526B05B1; Mon, 16 Nov 2026 22:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2636D6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:40:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E58C1C36D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:40:42 +0000 (UTC)
X-FDA: 85443209124.04.17201C5
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf11.hostedemail.com (Postfix) with ESMTP id 895ED40005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:40:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=csZmWHhe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794886841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BCD+ZeAlR3HyVI1Lid6kcHhyKTsbSvUwBV1vWEpv/80=;
	b=AVVzuGK7AV+sAMaD+5CgXIFz3ORi1CR+ywZyhNtqFkSvVt6YUqcygh0+AHS3aAxTey1RKD
	4K1Xrfg6RBaDPYO+dC+ZMRcKyGsw1gBC/gBNRcvzjg7QPSsBXxQqFABdyIWsted8b6takf
	DiMbLxA/KxtWM15GeUwZeMPPp17KdxI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=csZmWHhe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794886841;
	b=pck9ebHiaXyR1+KRN0+l/01kaRJV10IF435Ey2xZGLjsHXrFIwG6qQAAWatm6STeFk2Qaf
	JnEGFczSzjmd70JjJ/I5Dw0IY/QxVywdCkd/vpjR0xda+BBwrYIekd/rOkccxZw+TV0bkp
	42LC6fIUtqZkmc+GCgeC7Bh2qfSvGbg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794886836; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BCD+ZeAlR3HyVI1Lid6kcHhyKTsbSvUwBV1vWEpv/80=;
	b=csZmWHhenxebsDrRkKilpGU83URGAgSuwSWjbIN1AZfum1ws+t8DWNPqLCJsNnoYptn1FCp4kwax7OlOuwLGJbpZZuI+tXREar1I40hrF/RSr10JSYaHoHtpR6Rd3VKv/VQZ4gny4ew82kWuiNcs0fujCGIzXL2Y0PCXzxW+29U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEwzRFI_1794886835;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEwzRFI_1794886835 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Nov 2026 11:40:35 +0800
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
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: synchronize with PTE table reclaim for all folio sizes
Date: Tue, 17 Nov 2026 11:40:22 +0800
Message-ID: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 895ED40005
X-Rspam-User: 
X-Stat-Signature: jjbm9a6h4ktbrc5frh76g53j8in1x5xj
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794886839-789476
X-HE-Meta: U2FsdGVkX1/Uosk+d3owIKXF23eDvCVAWBOwuOXp7e+hxzJMEHn43ChB3xVx37+tLSp0EDdJHkzP5tpK54KQA+oF88Bq5tgw4XQojlpI/kFKLqwT3P3Y09uk++ZjLTKodNkVCHWD9tIH81pAGQu0melupYS95IW7xstDspJ8XFNPzxCMfGq0VasJ/G0qktZa4jtM1o4m6Me+yzIdLOZNmvQGu3p66lWrdaLxa6630YQHo2AS2UYg4wliPqeJ2NqMeLHwEgCIQUXnkHVt9x1cLA78+SNM2YtXVVyuWN6Xb3YhtLeyutdZFgNIhYI9a1I3jc7UhtvilZtmb2GnXI/6CIlPm24Fn2RXbQZfV7o3tov28o85ft7ilTKBJBprHgaYO0B0AkuenjsEXoRrd0tgzlnZM5GTZt1EfqB4owKSht3m0bj4g5Nf2IFubksqZ8RIatZ3I3BWzkKawYCZpQyB+rS6turmqChyUrnvBewy5utv6zqnCLpDyWjAaTOSO00L1nPsjI23Nu2HUPoYcuEUCAUN+nTlMaDgg6SfFSfRHNf1s+5yNEOjZeJ1afnHMPqem6Ua0sZK5r/o7M6iW0G1VibSGHUNeOYgssb8TKDnBIwHqzNarlvkrDbjti/It+wqrMoO1wWpvg2KXrKSmfQZVGZbo3pgwcoUcxi8wQ/nv/PPV3/YEd7jqzXEMFnod8RScqWCbc2ouziDR0uC76P+q6O+DtlTrGid/wEYmjXjshqSYQ1GjBxFTD+mptvC+gU0RqBalqNKp5a6Up3bcUpay62UUIx8o7Ss2InTu1tM92zW532aSWPsHQbZKaJUwo26RAwHFf1xzuYYy1UtE0moh3EE0Ifcc0GyRgLYDRQriCIiQaYg7G7lKx21vIXISh02YidBz7FaevFrERenc63EDAFvMivHhdjNwIEgGb8uwRZC7Q+gFZ/qmJepiMWWmhCjqOe15EM3LK31yEvG8QO
 fjwCqlKS
 HXtNbqfeoVmKI8X4bpQdtAverPkxLEm0K6gUhK8Q8A4wFugikLDWP8G3NQkzFiWWrBL6xHeBZca42VBJnQZDyj1/y4bVXlbGTEfWXeas5ZLDWGKWkBj+OQR+BY+308SnYpW1oeMvkQryAV4ujpNKp8akCytYfRnuHwB1Ab9z02SyffEd1F8eOrdaPlTykNRpyssW+Z0Y9bRIKjAcW9biMFynbU9RclLNd4T6dAfrV5EMrnttffG/8Kkfr0boc7D9d34iyRJ30PaYI0WwL5/t0YKi8bw==
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
fact already unmapped (as shown below), which may cause cold/hot inversion
(e.g., in MGLRU) and increase refaults. In extreme cases, failing to
reclaim unmapped large folios could even cause OOM in theory.

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

Regarding performance, evaluated the impact on try_to_unmap(). Mapped a file
to generate clean large folios, then used MADV_PAGEOUT to reclaim 1G of mapped
clean large folios, repeated 5 times, with no measurable performance impact.
Before: 16.031 ms over 5 loops
After: 16.303 ms over 5 loops

While the race scenario described in the patch may theoretically affect
performance, the actual impact in real workloads is likely limited I think.
Anyway, will use memory barriers to sync for non PMD-sized folios in a
follow-up.

Lance also reported the possible racy check for small folios[1]. However,
whether to set TTU_SYNC for small folios should be done in a separate patch
(this is a pre-existing issue) with proper measurement (though it may be
hard to measure the actual impact).

[1] https://lore.kernel.org/all/0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev/
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
Changes from v1:
 - Update commit message per David.
 - Add reviewed tags from Qi and Lance. Thanks.
---
 mm/page_vma_mapped.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index d45d52436f99..a931243ca42b 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -294,10 +294,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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


