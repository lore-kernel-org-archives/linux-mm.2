Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41519C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E856B00A4; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A0C6B00A2; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961486B009D; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA766B00A2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9DFF1C0F6D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:28 +0000 (UTC)
X-FDA: 85060992576.21.E74D2B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E68DC40004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uo+RiEy4;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786447;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40FP2Vax27duoAlpNGLS6Can4DBuhOs55Uj8AffpRKo=;
	b=pHin+RTza4P9DI5QS3NXMNbIAqWHS5mEMzEYeu0LOKimPz8B3vTCguGOYJWNWVq0KBtlZv
	WGckaI/MjI6M9E0RD1hgETV1h5B8U2+3Wh+xqgq8hgJ+UGLDSEvsdFJL/4Qv19LPH3jeww
	Hx7OKdhvBzc9MnCQuNdELjhO8vA6/BM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uo+RiEy4;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786447;
	b=ab5CO214gnV2Hwvl4NK/vQoZRt5r3MMGQzHOayfeZj7Z3i1AHmmeyfLFZ6veh0lOrn+AGs
	lX+0E0AL6m1f358/uFDl4x62xw2B9t4I0UX0nsONq7Ncp3rbIfMoBt60fh+l4Nzm/T33Xp
	s13Mbik55khrB7busYpNk0KjEBiZ9ik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 49D7643C50;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 271B3C2BD05;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=9OIzYG9v5ayIbesiCljJXQsRCZ3b0ppcAUlzxbinN9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uo+RiEy4b/s/f7OV8igrBPb+6kmSRLVoYXNapHhJR9A0cHDGv9Mu1MZ+AAvGMPwN+
	 zWbMdBQHs7Wg/yLxiDO1btNE6L9Kp6ZTESKJEfMoYeLw9wbNhk5208pQBV4FZrbAIZ
	 Um1R58QjeGm3VFfflOatSM+BZI/mcz8vw95b3SCCixa3s3YXilW8eNZmgpyuudRaWj
	 j8ux8M0UoDDVtzvLKzywZeH4DvMyxfoPCXx01eiiWLeajQiR8/1vxA9Vk8tmkZ4azd
	 AjxEK50uddf3Xfhalntmw6DTdC6pTw/kL4sbZ8GvDOx4l5MzL1W1upf7RIBPsCUUZM
	 uWPecPaa2MXHA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121B6C55843;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:07 +0800
Subject: [PATCH RFC 11/15] mm/mglru: replace folio workinset check and
 update with new helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-11-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=7823;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ps3GPccJmNKKFg75e7bKrntkjE3H1Gau9WECQyN6J8c=;
 b=SsYlfhIoI9qTSRrpCosoUsyZvOU0ul0m78d3Qr/DFKMMXzkq44g4dt3l0QbyqaioklkvikIIo
 XQr9zDOideJDFLJAUTIr+IvQonmZ1XL5DQ4gdvvRSPbhot5/9ELDycb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E68DC40004
X-Stat-Signature: kcdsnjjtp3qce8cxju6dwxukp5j17a6k
X-HE-Tag: 1785786446-584837
X-HE-Meta: U2FsdGVkX1/Z6NbXk5+en4ANbUIkskZmbCwIakGHdbn8UX7Qf79GLhA6ZDMmItTN732blJveKgNmWKeqqW6bEOI6oUtP5opMei2bkaLuWBup0uNdhkDqBrVmbapNt2ENJvqMKYWqisSwrWTgKQGtLNjIKQ7RBosVBWjTIR28eMnedgH1VhViCLd+ECenZuMekjeCw1W3ZhErIBHvW1g0BYv2aZpt3T9L7E5JDKq6cGubreJLsC+9/qh0IZK9ykb6nVa2DPGnYngadETaMwQD+8OmjceVzwbMAYtr+pxaxtak/KkfgNIdrKLthsvm3cFKJq+P+sDdHGwJUrxErtoN1PeC2d+rftYMS4Kjun96in/OjX+vK0D4Q9+tnptSVTd1FfYcjdyOLcLUKoS/LQtF7fYfNFMpKOBnp9g1RGtavqmM9M+9Y60ConGkkqKY17OzXhkzKr+85F+oQP2+hWQxN5HGaYoG4h2jhcplwTP+KzMt21sEcTwUyueFJWeEw/DSH7WyGr/HXTMNbE1TswoyH0Ko0P7THl6Zrg4FE+58rmO9wRChaK8gpWl1oOCqduKp6dXcCJoR8quHwXdOpDfwWfZbQc9oW/wI7ZBiosm4AK2rk+Lks16AW3Z3xqOc1ew/XsEl1NGsk0opXppJgHsrtElAYkBWyiOeN9agUPDHlaq8uKVlEpuJvr2YbnYLrgEKuYBGUisAVbREN76+CRrUAQ2eEnzLcWxS6T7r+NINO0PihjPVx8NrRtTj+0GhV++NMl4nKvKZvytxre32QWPfTJQVO+ISgTbeIX3ygv+epTduBsI/Pjp++K9dBG3gHBGQRQSt+np8+n8dCA7vZ24qw/1FW3Y7mLSl8hTQY9AKawGsYqxB3f8VqPBKJ8Ou/CJpS4yaYjnb9X/6L6oSWWGKH/n8jMsQUhP6FCXAjgQxA1ryEcPIErlDBgDpeO5k/a8qkpqstPzy1gSsaditcy6
 ljwOmEMO
 8EHcPq/8UaNQwBowMuYT8HyS5oCssZrVkgaBtJKv24a5hf1lq88xyCACIyy0V+BT61dO4cjBKiVl2FJTmT90tWstPFz4HGwS8s4t4qqN3qbUmFmh8B5z4LGzZoQcgp6lWPD4iI5IihBuhTR3WYXbF/94zrZUN46IPEq7np6u+AQCl978v1wX9pj2W/Nc3b9XfeGt0RlDiHOR0OVErOQZjIO8qv6HsaPruxSGZZMVn0Mb/tiLkuHXUILfXz+E7b9bhiEL8d0cHuS+1a/xdi8fXNFNYe3OsliYiOUls63bFpkDuyafmalTnPVSA4a2jXqPnmYPf8/ypUSgbCnEQ2mPOZv3bdL+LBWF82OQEZwBX67eAud5E2yfFUm4QaFmLZRzD6Bu/MZEWO5EgH23m9JcVX3qTfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With the new folio LRU refs tracking API, when MGLRU enabled, a folio
is considered a workingset folio if its referenced count > 1. This is
compatible with classical LRU and reasonable in many ways:

The PG_referenced and PG_workingset are used as the lower bits of the
LRU refs counter, and MGLRU will make use of extra bits as higher bits.

So when MGLRU is disabled, all higher bits are always 0, making the
check bit-wise equal to the old behavior. Active/inactive LRU sets
PG_workingset explicitly for folios moved from active list to inactive
list, and that makes the LRU refs tracking API (folio_is_workingset)
report a referenced number > 1. Clearing PG_workingset will always
return a value <= 1.

When MGLRU is enabled, a folio referenced twice is considered a
workingset folio, which is basically the same as how active/inactive LRU
used to promote a file page to the active list. Note for
active/inactive, the folio has to be marked inactive and PG_workingset
before eviction, but MGLRU doesn't have a demotion process, so this
simplified check ensures we have a stable definition and accurate
readings in PSI and readaheads just like before.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/btrfs/compression.c | 3 ++-
 mm/filemap.c           | 8 ++++----
 mm/madvise.c           | 4 ++--
 mm/page_io.c           | 3 ++-
 mm/readahead.c         | 8 ++++----
 mm/vmscan.c            | 2 +-
 mm/workingset.c        | 4 ++--
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ffb6b52863a7..e756403e8bd5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -21,6 +21,7 @@
 #include <linux/sched/mm.h>
 #include <linux/log2.h>
 #include <linux/shrinker.h>
+#include <linux/mm_inline.h>
 #include "misc.h"
 #include "ctree.h"
 #include "fs.h"
@@ -448,7 +449,7 @@ static noinline int add_ra_bio_folios(struct inode *inode, u64 compressed_end,
 			continue;
 		}
 
-		if (!*memstall && folio_test_workingset(folio)) {
+		if (!*memstall && folio_is_workingset(folio)) {
 			psi_memstall_enter(pflags);
 			*memstall = 1;
 		}
diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..a88a6140ed09 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1259,7 +1259,7 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	bool in_thrashing;
 
 	if (bit_nr == PG_locked &&
-	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+	    !folio_test_uptodate(folio) && folio_is_workingset(folio)) {
 		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
 		thrashing = true;
@@ -1414,7 +1414,7 @@ void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 	struct folio *folio = softleaf_to_folio(entry);
 
 	q = folio_waitqueue(folio);
-	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+	if (!folio_test_uptodate(folio) && folio_is_workingset(folio)) {
 		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
 		thrashing = true;
@@ -2510,7 +2510,7 @@ static void filemap_get_read_batch(struct address_space *mapping,
 static int filemap_read_folio(struct file *file, filler_t filler,
 		struct folio *folio)
 {
-	bool workingset = folio_test_workingset(folio);
+	bool workingset = folio_is_workingset(folio);
 	unsigned long pflags;
 	int error;
 
@@ -3981,7 +3981,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
-		    !folio_test_workingset(folio) &&
+		    !folio_is_workingset(folio) &&
 		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 			unsigned short mmap_miss;
 
diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad..abb17760b8b5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -427,7 +427,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			folio_mark_workingset_by_bit(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -542,7 +542,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			folio_mark_workingset_by_bit(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..e7efc5bff668 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -25,6 +25,7 @@
 #include <linux/sched/task.h>
 #include <linux/delayacct.h>
 #include <linux/zswap.h>
+#include <linux/mm_inline.h>
 #include "swap.h"
 #include "swap_table.h"
 
@@ -452,7 +453,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
-	bool workingset = folio_test_workingset(folio);
+	bool workingset = folio_is_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 558c92957518..3ab796af6490 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -302,7 +302,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		}
 		if (i == mark)
 			folio_set_readahead(folio);
-		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_workingset |= folio_is_workingset(folio);
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -474,7 +474,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 	}
 
 	ractl->_nr_pages += 1UL << order;
-	ractl->_workingset |= folio_test_workingset(folio);
+	ractl->_workingset |= folio_is_workingset(folio);
 	return 0;
 }
 
@@ -817,7 +817,7 @@ void readahead_expand(struct readahead_control *ractl,
 			folio_put(folio);
 			return;
 		}
-		if (unlikely(folio_test_workingset(folio)) &&
+		if (unlikely(folio_is_workingset(folio)) &&
 				!ractl->_workingset) {
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
@@ -846,7 +846,7 @@ void readahead_expand(struct readahead_control *ractl,
 			folio_put(folio);
 			return;
 		}
-		if (unlikely(folio_test_workingset(folio)) &&
+		if (unlikely(folio_is_workingset(folio)) &&
 				!ractl->_workingset) {
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c8d9e3af375..913e69eae534 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2268,7 +2268,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		}
 
 		folio_clear_active(folio);	/* we are de-activating */
-		folio_set_workingset(folio);
+		folio_mark_workingset_by_bit(folio);
 		list_add(&folio->lru, &l_inactive);
 	}
 
diff --git a/mm/workingset.c b/mm/workingset.c
index 452fe8554990..568a3e44cd5e 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -438,7 +438,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-			   folio_test_workingset(folio), file);
+			   folio_is_workingset(folio), file);
 }
 
 /**
@@ -609,7 +609,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 
 	/* Folio was active prior to eviction */
 	if (workingset) {
-		folio_set_workingset(folio);
+		folio_mark_workingset_by_bit(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
 out:

-- 
2.55.0



