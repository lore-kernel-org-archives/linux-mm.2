Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDB8C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DFC6B0095; Tue, 29 Sep 2026 03:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165C26B00A1; Tue, 29 Sep 2026 03:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056186B00A2; Tue, 29 Sep 2026 03:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D10336B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:59:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 624DAA03E0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:59:38 +0000 (UTC)
X-FDA: 85266050436.16.F5BA053
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id A85AA1A0003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:59:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=QEY02ljN;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf19.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2s3E1IRhko6dtq2FFyT/w1qXlnwWbE97ByaRrzqHX00=;
	b=RrTQK8bEIDh3XepoYoNSqCKuhuAvrdstHljteFsY4/E20X354X+kevey+Tpx6GBILh/UNF
	GGcabSg4z5Wep4D9wCToXNzcwg+GkW1g3hY9tW+hDMCMqARrAni41FOdCEhyA1WPEFDC5W
	JogZf7KqAhyB9QAIg1lLwBVBuZvidlE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=QEY02ljN;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf19.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668776;
	b=owVwq/Rq0mb+rlC0YCmOcqNmYgKQ48h5B2TaMjlH57MlIJwmdHG5HjXDAivm2w5FHp74cD
	R6vGGD5MltOOYWtDNAyBZ0xsbFt8uPls4BuGm0RkcxdVHuI975vlKJvJfZIJDDrPv5ZQFq
	mBK0r6sHlIImkN+W6ht38+qrn6Os9/Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668750; bh=2s3E1IRhko6dtq2FFyT/w1qXlnwWbE97ByaRrzqHX00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEY02ljN8RMROMwe1THd8oiRAzCpJH0Hxq5KSUE+izoEKTQcLTK85DPzTpiY7HMuE
	 bY141SRogOE53Pp+R3vueKUuyJ6VP5Tx1w3Hqg4GrhAoKV7bz8hSkmimNBSEkxI6Ql
	 ZpeSiKPJkvDtSpdnPnIOOVfJdl80QCY1DX7wBVT8=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id EC4A62DA; Tue, 29 Sep 2026 15:59:04 +0800
X-QQ-mid: xmsmtpt1790668744tw7eghsxn
Message-ID: <tencent_3AD5E72E543F91A7A99CACECA7B6A9AB4F09@qq.com>
X-QQ-XMAILINFO: NEco6NxS/P2H+pBZBEB1QrhbLsPi+Bg8s958rkR0UnXDSifdnyP6FZ4ehvbxvF
	 K7lihFXiZnfd6uI4RO0Y1Rrqg+MFHqFtIshYgFJJDStDK5UrnAPIXT3pdyl3MhGYCW2avrlwthhG
	 D0VL9Q0nevhrErwxfIlZEUmtkopKnf/+gFHop1fnWZJfo3Y13ZUYaIAbLfJ0mdU4BwP4zjUVI9rZ
	 sEX7Dyfz/zPftAmdEhdawUJ58OxJCROh107t8T+uIGROEKDiu0+waLpgDsALZ5A6ZI+QY4d7pQf+
	 QGqjfh0JBbICvSaTqudzcaNa/SaVZtcv7862TuRaO+t5g2902NQAFNdg3fj5zt+LCviXfdPlndeB
	 LlVMwhnpP207QOuVMjlR8cGXAQpqs4Pw9yts7/HuK6dM4MQe48dU7e9rk+Jdk6+ATzPaPg+OiKxg
	 zVnnGjtRJ7/lP16PduXvzab50vEYBmTJyUbwgk52/Mlbn7b+j8I0Xo9MnIUrs742Z39ZwAmbZgf5
	 TojBn89lKnBGmHnaNYnEe6dZx28SWHpZdJ78viUlDLVJUzvS4bw66XghZH8jUfL/66zMCYClyEZW
	 5i/HzvwW+bya06R4JM8N0rMkjtxU6ioFwkwbN7iilzQfFo8a3yhORx6LjJkoU3Fmv76laATNsfLf
	 hMqZIPVcMqfCIr/AQzZNZKiY7YS2J1pvG/WVVOjvTI2OwhdkrGcwSKk0LOyx/RDOybBKMWmB3rP3
	 baCk/qES2TDbuF6d2dRBKhvbK11wU43q5kjB6pYjexT42E1lm1dzzDxF8W6NC62EPcw+bYSinYYO
	 qBKXkrWJ4D9eoKD2WFPzfRQo1MP1UujyRXjn5cMCMjBoeEOfChoFiGDs2e8pl7vJdEfvfYNvuD4m
	 9cQGlC13Z2UEfMJ/6UhN2Qlqjes03tBje5TLv1ev6hTVw3r8kAfhxVqlc5l+eBfnjKgp5+djtZTF
	 PKB/iR+YJrHOwqfoDbWLSWTW0LTJvHkeGDMggR1iHNp2LqfGg194DNwkFTcHeVaPnBeaopOzQCgh
	 G7ZPs8Bi4xAwWaDNXB3Ldg2OnBfkXxpv7AcI/Rb3BvGmOz4wHFJBjen2N4sIBKgqKEd1D6MikdMB
	 MAuX+q2cuF94AQnqb9rTbXCZTCo+IGeycm5iRsDAc+ZGNmMN0eJRsvkF7q6lvFPYtjaruHtmlBBZ
	 520O1HjlbG+8ISTnIw2+oE+AY4DCkmcl/lc8/rjCkQMGjO2w==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Zongkun Lei <leizongkun@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 2/6] mm/hugetlb: swap-in support for anonymous hugetlb folios
Date: Tue, 29 Sep 2026 15:59:00 +0800
X-OQ-MSGID: <1fb02d72bb4f95156bac3033f1b6118ba6386f3e.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790663399.git.leizongkun@qq.com>
References: <cover.1790663399.git.leizongkun@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ypjbdyri1de6wghcfoyha39jgae5p6ze
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A85AA1A0003
X-HE-Tag: 1790668774-764243
X-HE-Meta: U2FsdGVkX1+0fP0zMkkqL6dsSTiFQVY2DfnX0lnfSjAGafNJsG1XWm+/7TgOOeCoF1PnqZAzyo6yjXC0zmUHAsJL6GURVrYb4XToUU/R2nRRhP8GfIuQHrycu7K56dzW9Hwpldrq+LUjA+GuOVgP5L0/ffJS0n04JPBWqjzPG0IHkuwP1vcEXgfWyUWebKVkIJEpbXzgBToptE/B3M0nPoxHViuEpAdC4Nhj9rwRKpPtzJ3HnoeKEcrBJoeEQvltKsCMC500IFaudyd2W+f3nWwIz9OBZ+2lmkrvC0lBzYHK4thA8aenB92LvnSTCAAoHihUQ/tzMFvgK+5VJMlnzBm5QZltK5ED4QCo1e7S8zgJ5Dq+kKtdhtTAKK/9Ms5/Rfy5Xjm4OaEI4/VTL3RVV9rgGzk6bb1AAsdz7OgPwjZ7NryrL4SGV8K6EA5IFbE8BpYSv7PenEnu++0Re4cGfbMBL8JOTZ4LkzxI2xPmKtANS7rfILuZlbLfCzEwBJvhCkA14jxR9BRGhwBqL7VY9vMyyIi8nvPmkTJ/EeDKqI/GLPAfOWbjIxWtt6tHrBpgaT0QelT1CV+aKeS5o9XaaEYkMqMuHBZxdUvit7kuLnuwqUb1w8ngjNGEOZ3gxTIY0mW5ks3KH8hKfWnPugunoHUyLONTz/HRbLTUzfcReroexfi3pBeHXQ+avnN2k19XfL9mNSYjFXdAbxZqdO+XX1Q6KUz5zfLEsfk9LViozWlnTPVTuI3x9R+Wne9e/RNIf6gVwbNVeQuuzCYUU7kz9hIK0lYgE7JYwmAKEVo4HgArSHhQrpZObGnkQQC5esba1FYPxoiVezwkmLQAYNP57fnCntrH7vQvhjnlwF84HbXRBPatjqplfBENP2Xeh73u6Emk+ydtA5PbOuNnuwBlEHdBryeYmug/xOpKB+FgijSp5FMO8d6Df3JlVAtLrGtIh2rriNyNedSWjDxX0II
 oa7d5m6J
 oUNi6gwiZcQGlHswAJyNOJrYHqAL4xBRWNUXxeu3SftLTBK6DYw0OVfR/y/GzKxZSDa9h+okMfwnW0OA9Y2Jm1vXQ/oS0ZmAzKZOvU2bhXcYGV5YW4veY2h8+KjklpFwrb8TOcidGU4px4EdzYA5ZkQkWDmY8qfQx0aYAtVCyFgBA4ekKLkAEoBq0oiYA+DyvxAC5c9goLZbgb+LE1uCwbTrWkxkCIKNZl7Vz6qYA7DdT0EXAh89sTzDgkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach the hugetlb fault path to recognize swap entries and read them
back, together with the full consumer-side lifecycle of such entries.
This is the consumer half of hugetlb swap support; the producer
(swap-out via MADV_PAGEOUT) arrives in a later patch, so every path
added here is provably unreachable until then - which is exactly why
it lands first: with swap-out first, a fault on a swapped-out hugetlb
page would hit the 'ret = 0' fall-through in hugetlb_fault() and
livelock.

* hugetlb_anon_swapin(), mirroring do_swap_page(): get_swap_device()
  pins the device, swap_cache_get_folio() finds in-flight folios, and
  on a miss the folio is allocated from the hugetlb pool and added to
  the swap cache via the new generic swap_cache_add_folio() helper
  (hugetlb folios cannot come from the buddy allocator, so
  __swap_cache_alloc() cannot be used).  Pool exhaustion retries
  briefly, then fails with SIGBUS, matching the reservation contract
  of the no-page path.  A hwpoisoned swapcache folio kills the
  faulter with VM_FAULT_HWPOISON_LARGE instead of being delivered.

* Fork: copy_hugetlb_page_range() duplicates the slot references of a
  swapped-out page with the new swap_dup_entries_direct() helper (the
  swap cache folio cannot be used: it is freed back to the pool once
  writeback completes while its slots stay pinned by the entries) and
  clears the exclusive bit on both sides, like copy_nonpresent_pte().

* Zap: __unmap_hugepage_range() returns the slot references with
  swap_put_entries_direct(); its present-folio branch additionally
  drains a leftover swapcache copy (anon, unmapped, non-poisoned) via
  folio_free_swap(), since hugetlb folios never sit on an LRU and
  vmscan cannot reclaim them later.

* hugetlb_wp() refuses to reuse a swapcache folio in place unless
  folio_free_swap() proves no slot is referenced anymore (fork may
  have duplicated the entries); hugetlb_change_protection() passes
  swap entries through, only the uffd-wp bit may change.

* MM_SWAPENTS follows the mainline contract (+N at swapout and fork,
  -N at swapin and zap, N = pages per huge page) so VmSwap stays
  meaningful.

* swapoff: hugetlb_unuse_vma() walks one VMA's swap entries of the
  dying type and swaps them in through the same worker, wired into
  unuse_mm(); try_to_unuse() must be able to drain every kind of
  swapped-out page.

* pagemap: report hugetlb swap entries with PM_SWAP, soft-dirty and
  uffd-wp bits, like small-page swap entries.

Signed-off-by: Zongkun Lei <leizongkun@qq.com>
---
 fs/proc/task_mmu.c      |  11 ++
 include/linux/hugetlb.h |   2 +
 include/linux/swap.h    |   1 +
 mm/hugetlb.c            | 414 +++++++++++++++++++++++++++++++++++++++-
 mm/swap.h               |   6 +
 mm/swap_state.c         |  32 ++++
 mm/swapfile.c           |  66 +++++++
 7 files changed, 531 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e671b4fd8ded..7f4c5b385acb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2161,6 +2161,17 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 		if (pm->show_pfn)
 			frame = pte_pfn(pte) +
 				((addr & ~hmask) >> PAGE_SHIFT);
+	} else if (softleaf_is_swap(softleaf_from_pte(pte))) {
+		softleaf_t entry = softleaf_from_pte(pte);
+
+		if (pte_swp_soft_dirty(pte))
+			flags |= PM_SOFT_DIRTY;
+		if (pte_swp_uffd_any(pte))
+			flags |= PM_UFFD_WP;
+		if (pm->show_pfn)
+			frame = swp_type(entry) |
+				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
+		flags |= PM_SWAP;
 	} else if (pte_swp_uffd_any(pte)) {
 		flags |= PM_UFFD_WP;
 	}
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 900c95e346b2..b751cba214be 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1377,4 +1377,6 @@ hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
 	return huge_pte_offset(vma->vm_mm, addr, sz);
 }
 
+int hugetlb_unuse_vma(struct vm_area_struct *vma, unsigned int type);
+
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 677081238811..c2f52bb76af5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,6 +414,7 @@ sector_t swap_folio_sector(struct folio *folio);
  * a swap count > 1. See comments of folio_*_swap helpers for more info.
  */
 int swap_dup_entry_direct(swp_entry_t entry);
+int swap_dup_entries_direct(swp_entry_t entry, int nr);
 void swap_put_entries_direct(swp_entry_t entry, int nr);
 
 /*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8fa1bafa03d9..fc2077a03744 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -26,6 +26,7 @@
 #include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
+#include <linux/swap_ops.h>
 #include <linux/leafops.h>
 #include <linux/jhash.h>
 #include <linux/numa.h>
@@ -48,6 +49,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "page_alloc.h"
+#include "swap.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
@@ -4968,6 +4970,50 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			if (marker)
 				set_huge_pte_at(dst, addr, dst_pte,
 						make_pte_marker(marker), sz);
+		} else if (unlikely(softleaf_is_swap(softleaf))) {
+			/*
+			 * A swap entry of a swapped-out private hugetlb
+			 * page.  Share it with the child like an anonymous
+			 * swap entry: duplicate the slot references of
+			 * the whole huge page and account one more
+			 * swapped huge page.
+			 *
+			 * The swap cache folio cannot be used for this:
+			 * once pageout writeback completes, the huge page
+			 * is freed back to the hugetlb pool and leaves the
+			 * swap cache, while its slots stay pinned by this
+			 * very entry.  So duplicate the slot references
+			 * directly under the page table locks, like
+			 * copy_nonpresent_pte() does with
+			 * swap_dup_entry_direct().
+			 */
+			pte_t swp_pte = entry;
+			bool exclusive = pte_swp_exclusive(entry);
+
+			if (unlikely(swap_dup_entries_direct(softleaf,
+						pages_per_huge_page(h)) < 0)) {
+				spin_unlock(src_ptl);
+				spin_unlock(dst_ptl);
+				ret = -ENOMEM;
+				break;
+			}
+
+			mm_prepare_for_swap_entries(dst);
+			add_mm_counter(dst, MM_SWAPENTS, pages_per_huge_page(h));
+
+			/*
+			 * The entry is shared by two processes now, so
+			 * drop the exclusive bit on both sides, like
+			 * copy_nonpresent_pte() does for swap entries.
+			 */
+			if (exclusive) {
+				entry = pte_swp_clear_exclusive(entry);
+				set_huge_pte_at(src, addr, src_pte, entry, sz);
+				swp_pte = entry;
+			}
+			if (!userfaultfd_protected(dst_vma))
+				swp_pte = pte_swp_clear_uffd(swp_pte);
+			set_huge_pte_at(dst, addr, dst_pte, swp_pte, sz);
 		} else {
 			entry = huge_ptep_get(src_vma->vm_mm, addr, src_pte);
 			pte_folio = page_folio(pte_page(entry));
@@ -5236,6 +5282,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
+			const softleaf_t softleaf = softleaf_from_pte(pte);
+
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to
@@ -5249,6 +5297,27 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 						sz);
 			else
 				huge_pte_clear(mm, address, ptep, sz);
+
+			if (softleaf_is_swap(softleaf)) {
+				/*
+				 * A swapped-out private hugetlb page: this
+				 * pte held one reference on the folio-sized
+				 * swap slot range.  Return it (reclaiming
+				 * the swap cache once the last reference is
+				 * gone), like zap_pte_range() does for small
+				 * swap entries, and drop the accounting.
+				 */
+				swap_put_entries_direct(softleaf,
+						pages_per_huge_page(h));
+				/*
+				 * pages_per_huge_page() returns unsigned int,
+				 * so negating it stays unsigned and would
+				 * zero-extend to a huge positive long here;
+				 * cast to a signed type before negating.
+				 */
+				add_mm_counter(mm, MM_SWAPENTS,
+					       -(long)pages_per_huge_page(h));
+			}
 			spin_unlock(ptl);
 			continue;
 		}
@@ -5329,6 +5398,25 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				vma_add_reservation(h, vma, address);
 		}
 
+		/*
+		 * An anonymous folio swapped in by a read fault keeps its
+		 * swapcache copy and slots pinned (only write faults and
+		 * swap-full free them at swapin time).  Unlike small pages,
+		 * hugetlb folios never sit on an LRU, so vmscan cannot drain
+		 * such a copy later; once the last mapping is gone this is
+		 * the only chance to free it.  Best effort: folio_free_swap()
+		 * rechecks swapcache/writeback/occupancy under the folio
+		 * lock and simply fails in any race, leaving the slots for
+		 * swapoff.  Keep poisoned copies: they exist to kill their
+		 * remaining owners via the swapin hwpoison interception.
+		 */
+		if (folio_test_anon(folio) && !folio_mapped(folio) &&
+		    folio_test_swapcache(folio) && !folio_test_hwpoison(folio) &&
+		    folio_trylock(folio)) {
+			folio_free_swap(folio);
+			folio_unlock(folio);
+		}
+
 		tlb_remove_page_size(tlb, folio_page(folio, 0),
 				     folio_size(folio));
 		/*
@@ -5508,8 +5596,16 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * we run out of free hugetlb folios: we would have to kill processes
 	 * in scenarios that used to work. As a side effect, there can still
 	 * be leaks between processes, for example, with FOLL_GET users.
+	 *
+	 * A swapped-in folio that is still in the swap cache may back swap
+	 * slots referenced from other address spaces (fork() duplicates the
+	 * swap entries of a swapped-out page); reusing it in place would
+	 * corrupt the copy those slots still promise.  Try to free the swap:
+	 * it succeeds only when no slot is referenced anymore, in which case
+	 * reuse is safe; otherwise we have to copy.
 	 */
-	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
+	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio) &&
+	    (!folio_test_swapcache(old_folio) || folio_free_swap(old_folio))) {
 		if (!PageAnonExclusive(&old_folio->page)) {
 			folio_move_anon_rmap(old_folio, vma);
 			SetPageAnonExclusive(&old_folio->page);
@@ -5985,6 +6081,10 @@ u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx)
 }
 #endif
 
+static vm_fault_t hugetlb_anon_swapin(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long haddr,
+		pte_t *ptep, pte_t old_pte, unsigned int flags, u32 hash);
+
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags)
 {
@@ -6077,8 +6177,14 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (softleaf_is_hwpoison(softleaf)) {
 			ret = VM_FAULT_HWPOISON_LARGE |
 			    VM_FAULT_SET_HINDEX(hstate_index(h));
+			goto out_mutex;
 		}
 
+		/* Swapped out: read it back in. */
+		if (softleaf_is_swap(softleaf))
+			return hugetlb_anon_swapin(mm, vma, vmf.address,
+					vmf.pte, vmf.orig_pte, flags, hash);
+
 		goto out_mutex;
 	}
 
@@ -6588,6 +6694,23 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			    (uffd_wp_resolve || uffd_rwp_resolve))
 				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
+		} else if (unlikely(softleaf_is_swap(entry))) {
+			/*
+			 * A swap entry of a swapped-out private hugetlb
+			 * page: permissions do not apply to a non-present
+			 * entry, only the uffd-wp bit may change (like the
+			 * migration entry case above).  Anything else must
+			 * be left untouched or the swap entry encoding
+			 * would be corrupted.
+			 */
+			pte_t newpte = pte;
+
+			if (uffd_wp || uffd_rwp)
+				newpte = pte_swp_mkuffd(newpte);
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
+				newpte = pte_swp_clear_uffd(newpte);
+			if (!pte_same(pte, newpte))
+				set_huge_pte_at(mm, address, ptep, newpte, psize);
 		} else {
 			pte_t old_pte;
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
@@ -7427,3 +7550,292 @@ void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 	if (is_vm_hugetlb_page(vma))
 		clear_vma_resv_huge_pages(vma);
 }
+/*
+ * Mirror of should_try_to_free_swap() in mm/memory.c for the hugetlb
+ * swapin path; keep in sync.  The exclusive test differs: hugetlb
+ * approximates it with the folio refcount (1 + nr_pages when only the
+ * swapcache pins the folio).
+ */
+static inline bool should_try_to_free_swap(struct swap_info_struct *si,
+					   struct folio *folio,
+					   struct vm_area_struct *vma,
+					   unsigned int flags)
+{
+	if (!folio_test_swapcache(folio))
+		return false;
+	/*
+	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
+	 * cache can help save some IO or memory overhead, but these devices
+	 * are fast, and meanwhile, swap cache pinning the slot deferring the
+	 * release of metadata or fragmentation is a more critical issue.
+	 */
+	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		return true;
+	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
+		folio_test_mlocked(folio))
+		return true;
+
+	return (flags & FAULT_FLAG_WRITE) &&
+		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
+}
+
+static vm_fault_t hugetlb_anon_swapin(struct mm_struct *mm,
+			struct vm_area_struct *vma, unsigned long haddr,
+			pte_t *ptep, pte_t old_pte,
+			unsigned int flags, u32 hash)
+{
+	struct swap_info_struct *si = NULL;
+	struct hstate *h = hstate_vma(vma);
+	int nr_pages = pages_per_huge_page(h);
+	swp_entry_t entry = softleaf_from_pte(old_pte);
+	struct folio *swapcache, *folio = NULL;
+	struct swap_io_ctx ctx = {};
+	bool new_folio = false;
+	spinlock_t *ptl;
+	pte_t new_pte;
+	vm_fault_t ret = 0;
+
+	/* Prevent swapoff from happening to us, and reject a bad entry. */
+	si = get_swap_device(entry);
+	if (IS_ERR_OR_NULL(si)) {
+		if (IS_ERR(si))
+			ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+	folio = swap_cache_get_folio(entry);
+	swapcache = folio;
+	if (likely(!folio)) {
+		int retries = 3;
+
+		/*
+		 * Swapping out releases the huge page back to the pool,
+		 * so swap-in has to compete for pool memory again.  If
+		 * the pool is exhausted, retry briefly (userspace may be
+		 * paging out cold pages right now) and then fail with
+		 * SIGBUS, matching the reservation-exhaustion contract
+		 * of the no-page fault path.  The fault path must not
+		 * block indefinitely.
+		 */
+		for (;;) {
+			folio = alloc_hugetlb_folio(vma, haddr, 1);
+			if (!IS_ERR(folio))
+				break;
+			if (!hugetlb_pte_stable(h, mm, haddr, ptep, old_pte)) {
+				/* Raced with swapin/unmap: drop and retry. */
+				folio = NULL;
+				goto out;
+			}
+			if (PTR_ERR(folio) != -ENOMEM) {
+				ret = vmf_error(PTR_ERR(folio));
+				goto out;
+			}
+			if (!retries--) {
+				ret = VM_FAULT_SIGBUS |
+					VM_FAULT_SET_HINDEX(hstate_index(h));
+				goto out;
+			}
+			schedule_timeout_uninterruptible(1);
+		}
+
+		new_folio = true;
+		__folio_set_locked(folio);
+		nr_pages = folio_nr_pages(folio);
+		__folio_set_swapbacked(folio);
+
+		/*
+		 * If the slot got cached or freed concurrently,
+		 * just drop the fault and let it retry.
+		 */
+		if (swap_cache_add_folio(folio, entry))
+			goto out_page;
+		swapcache = folio;
+
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+		folio_wait_locked(folio);
+	} else if (folio_test_hwpoison(folio)) {
+		/*
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
+		 */
+		ret = VM_FAULT_HWPOISON_LARGE |
+				VM_FAULT_SET_HINDEX(hstate_index(h));
+		goto out_release;
+	}
+
+	if (!folio_trylock(folio))
+		goto out_release;
+
+	if (swapcache) {
+		/*
+		 * Make sure folio_free_swap() or swapoff did not release the
+		 * swapcache from under us. The page pin, and pte_same test
+		 * below, are not enough to exclude that. Even if it is still
+		 * swapcache, we need to check that the page's swap has not changed.
+		 */
+		if (unlikely(!folio_matches_swap_entry(folio, entry)))
+			goto out_page;
+	}
+
+	/*
+	 * If we are going to COW a private mapping later, we examine the
+	 * pending reservations for this page now. This will ensure that
+	 * any allocations necessary to record that reservation occur outside
+	 * the spinlock.
+	 */
+	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+		if (vma_needs_reservation(h, vma, haddr) < 0) {
+			ret = VM_FAULT_OOM;
+			goto out_page;
+		}
+		/* Just decrements count, does not deallocate */
+		vma_end_reservation(h, vma, haddr);
+	}
+
+	ptl = huge_pte_lock(h, mm, ptep);
+	if (unlikely(!pte_same(huge_ptep_get(mm, haddr, ptep), old_pte)))
+		goto out_nomap;
+
+	if (unlikely(!folio_test_uptodate(folio))) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_nomap;
+	}
+
+	arch_swap_restore(folio_swap(entry, folio), folio);
+
+	if (should_try_to_free_swap(si, folio, vma, flags))
+		folio_free_swap(folio);
+
+	add_mm_counter(mm, MM_SWAPENTS, -nr_pages);
+	hugetlb_count_add(nr_pages, mm);
+	/*
+	 * For a swap-cache hit on an already-anon folio (e.g. another task
+	 * faulted it in first), add a new rmap reference and carry the
+	 * anon-exclusive marker from the swap PTE. Otherwise this is a fresh
+	 * allocation that becomes anon here.  A shared swap entry (e.g.
+	 * duplicated by fork) must not make the folio anon-exclusive: the
+	 * folio still backs slots referenced from other address spaces, so
+	 * writes have to COW.
+	 */
+	if (swapcache && folio_test_anon(folio))
+		hugetlb_add_anon_rmap(folio, vma, haddr,
+				      pte_swp_exclusive(old_pte) ? RMAP_EXCLUSIVE : 0);
+	else {
+		hugetlb_add_new_anon_rmap(folio, vma, haddr);
+		if (!pte_swp_exclusive(old_pte))
+			ClearPageAnonExclusive(&folio->page);
+	}
+
+	new_pte = make_huge_pte(vma, folio, ((vma->vm_flags & VM_WRITE)
+				&& (vma->vm_flags & VM_SHARED)));
+	if (pte_swp_soft_dirty(old_pte))
+		new_pte = pte_mksoft_dirty(new_pte);
+	if (pte_swp_uffd(old_pte))
+		new_pte = huge_pte_mkuffd(new_pte);
+	set_huge_pte_at(mm, haddr, ptep, new_pte, huge_page_size(h));
+	spin_unlock(ptl);
+	/*
+	 * Drop the swap slot references after mapping, so raced page
+	 * faults will likely see the folio in swap cache and wait on
+	 * the folio lock.
+	 */
+	folio_put_swap(folio, NULL);
+	if (new_folio)
+		folio_set_hugetlb_migratable(folio);
+	folio_unlock(folio);
+
+out:
+	if (si)
+		put_swap_device(si);
+
+	hugetlb_vma_unlock_read(vma);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	return ret;
+
+out_nomap:
+	spin_unlock(ptl);
+out_page:
+	folio_unlock(folio);
+out_release:
+	if (si)
+		put_swap_device(si);
+
+	folio_put(folio);
+	hugetlb_vma_unlock_read(vma);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	return ret;
+}
+
+/*
+ * hugetlb_unuse_vma - swapin anonymous hugetlb pages from one VMA
+ * Called from hugetlb_unuse_mm() during swapoff.
+ */
+int hugetlb_unuse_vma(struct vm_area_struct *vma, unsigned int type)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct hstate *h = hstate_vma(vma);
+	unsigned long addr = vma->vm_start;
+	unsigned long end = vma->vm_end;
+	unsigned long sz = huge_page_size(h);
+	unsigned long last_addr_mask = hugetlb_mask_last_page(h);
+	struct address_space *mapping;
+	pte_t *ptep;
+	pte_t pte;
+	spinlock_t *ptl;
+	swp_entry_t entry;
+	int ret = 0;
+	u32 hash;
+	pgoff_t idx;
+	vm_fault_t error;
+
+	for (; addr < end; addr += sz) {
+start:
+		ptep = hugetlb_walk(vma, addr, sz);
+		if (!ptep) {
+			addr |= last_addr_mask;
+			continue;
+		}
+
+		ptl = huge_pte_lock(h, mm, ptep);
+		pte = huge_ptep_get(mm, addr, ptep);
+
+		entry = softleaf_from_pte(pte);
+
+		/* Skip non-swap leaf entries: migration, hwpoison, device, markers */
+		if (!softleaf_is_swap(entry)) {
+			spin_unlock(ptl);
+			continue;
+		}
+
+		/* Check if this entry is from the swap device we're disabling */
+		if (swp_type(entry) != type) {
+			spin_unlock(ptl);
+			continue;
+		}
+
+		spin_unlock(ptl);
+
+		mapping = vma->vm_file->f_mapping;
+		idx = hugetlb_linear_page_index(vma, addr);
+		hash = hugetlb_fault_mutex_hash(mapping, idx);
+		/*
+		 * We found a swap entry matching the type. Need to swap it in.
+		 * This is similar to the swapin code in hugetlb_fault().
+		 */
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+		hugetlb_vma_lock_read(vma);
+		error = hugetlb_anon_swapin(mm, vma, addr, ptep, pte, 0, hash);
+		/* hugetlb_anon_swapin() releases vma_lock and fault_mutex */
+		if (error) {
+			ret = vm_fault_to_errno(error, 0);
+			break;
+		}
+
+		/* Sometimes, hugetlb_anon_swapin() would return 0 for retry */
+		cond_resched();
+		goto start;
+	}
+
+	return ret;
+}
diff --git a/mm/swap.h b/mm/swap.h
index 19c260353e08..5e5a581cb030 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -314,6 +314,7 @@ bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry);
 struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				     unsigned long orders, struct vm_fault *vmf,
 				     struct mempolicy *mpol, pgoff_t ilx);
@@ -396,6 +397,11 @@ static inline bool folio_matches_swap_entry(const struct folio *folio, swp_entry
 	return false;
 }
 
+static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry)
+{
+	return -EINVAL;
+}
+
 static inline void show_swap_cache_info(void)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 516052efbf62..43212df961bb 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -258,6 +258,38 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
 
+/**
+ * swap_cache_add_folio - Add an externally allocated folio to the swap cache.
+ * @folio: The folio to add, must be locked and swapbacked.
+ * @entry: The target swap entry, will be rounded down to the folio size.
+ *
+ * Mirrors __swap_cache_alloc() for callers that allocate the folio
+ * themselves, e.g. hugetlb whose folios must come from the hugetlb pool.
+ *
+ * Context: Caller must ensure @entry is valid and stabilize the swap
+ * device, e.g. via get_swap_device().
+ * Return: 0 on success, -ENOENT if the slot is not swapped out, -EEXIST
+ * if it is already cached, -EBUSY on a conflicting concurrent operation.
+ */
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry)
+{
+	struct swap_cluster_info *ci;
+	unsigned long nr_pages = folio_nr_pages(folio);
+	int err;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE(nr_pages > SWAPFILE_CLUSTER);
+
+	entry.val = round_down(entry.val, nr_pages);
+	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
+	err = __swap_cache_add_check(ci, entry, nr_pages, NULL, NULL);
+	if (!err)
+		__swap_cache_add_folio(ci, folio, entry);
+	swap_cluster_unlock(ci);
+
+	return err;
+}
+
 static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 				      struct folio *folio,
 				      swp_entry_t entry, void *shadow)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c01bb490f4fc..280a31c43c81 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2699,6 +2699,10 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
+		} else if (vma->anon_vma && is_vm_hugetlb_page(vma)) {
+			ret = hugetlb_unuse_vma(vma, type);
+			if (ret)
+				break;
 		}
 
 		cond_resched();
@@ -3904,6 +3908,68 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
 }
 
+/*
+ * swap_dup_entries_direct() - Increase reference count on a range of swap
+ *                             entries.
+ * @entry: First entry of range.
+ * @nr: Number of entries in range.
+ *
+ * For each swap entry in the contiguous range [entry.offset, entry.offset + nr),
+ * increase the swap count by one.  Used when duplicating a large (multi-page)
+ * swap entry, e.g. when forking a mm with swapped-out hugetlb pages, where
+ * the swap cache folio may already be gone and folio_dup_swap() cannot be
+ * used.  The range may span multiple swap clusters.
+ *
+ * Context: Same as swap_dup_entry_direct(): the caller must ensure there is
+ * no race condition on the reference owner, e.g. by holding the PTL of a PTE
+ * containing the entries, and every slot must have a count >= 1.
+ *
+ * Return: 0 on success.  -ENOMEM if the swap count maxed out and an extended
+ * table could not be allocated, -EINVAL if any entry is a bad entry.  On
+ * failure all references added so far are rolled back.
+ */
+int swap_dup_entries_direct(swp_entry_t entry, int nr)
+{
+	const unsigned long start_offset = swp_offset(entry);
+	const unsigned long end_offset = start_offset + nr;
+	unsigned long offset, cluster_end;
+	struct swap_info_struct *si;
+	int err;
+
+	si = swap_entry_to_info(entry);
+	if (WARN_ON_ONCE(!si)) {
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
+		return -EINVAL;
+	}
+	if (WARN_ON_ONCE(end_offset > si->max))
+		return -EINVAL;
+
+	offset = start_offset;
+	do {
+		cluster_end = min(round_up(offset + 1, SWAPFILE_CLUSTER),
+				  end_offset);
+		err = swap_dup_entries_cluster(si, offset,
+					       cluster_end - offset);
+		if (unlikely(err))
+			goto failed;
+		offset = cluster_end;
+	} while (offset < end_offset);
+	return 0;
+
+failed:
+	/* Roll back the references added in previous clusters. */
+	while (offset > start_offset) {
+		unsigned long cluster_start;
+
+		cluster_start = max(round_down(offset - 1, SWAPFILE_CLUSTER),
+				    start_offset);
+		swap_put_entries_cluster(si, cluster_start,
+					 offset - cluster_start, false);
+		offset = cluster_start;
+	}
+	return err;
+}
+
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static bool __has_usable_swap(void)
 {
-- 
2.53.0


