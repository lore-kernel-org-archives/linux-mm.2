Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10B4CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F175A6B00A1; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD35A6B00A7; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6546B00A3; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E84C6B00A3
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 754E31A02B9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
X-FDA: 84720079038.17.6668D79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50F66100007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="o5u4Z4Z/";
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qs5XMJKLF8q7B+T9gXqtO3u9gfOzaKEEE0HSPtHL1Qs=;
	b=posWYk3ccG5W5yss+aDIuH2TbnweRP2vUQjB9xr6ZLXlj9uqJAPd4pScje4COhjtXxTtXL
	MrIX6MNR3JQenpD8UPIOEpY6UDPEn9f959yEaXYuDikye7J0/RrMDlUDr/m728kBUtp+tO
	enpCnfcbQvj2TfhNX2zS9K2v3ZBcR88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669457; a=rsa-sha256;
	cv=none;
	b=KHrRVZfwV7ZkCphXLRstTchAwNwaxfFxd8pQNnW4g8yk/NxOHawOMs6TtkKlCpffsJj9XY
	49iLmhCelgnd6feR0TrUX/EPJm0hJ5Klvnt/jYYdc4dMzOcsMDdzvPNf4ya+wwRojNOk/N
	9BmoaW86LhFxIFXXyh04plgd/2h1bMI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="o5u4Z4Z/";
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF71F44265;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC0E6C2BCFA;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=VkzoIoo4iNGRdob7TlEQIpSeG3yvGqdZ1JEVDVZwjEk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=o5u4Z4Z/3+tFnF+UV5eACSPqnwB/BROO8kRPXIjGw0VDtLxn+ri4+NVjDKqZHLHBA
	 4NUNkUNs4ou/CxO9X9u24D/8LxMS0up6HJGj8kA9nrOSFnEJnjCyxg4eK5DJW+yAKw
	 tvF/Xu6c1/8p1YwvgZGzR7Toa0DzDexZQr5o/B/LRJzwBfXzn4huTs8vej7ljMQOlr
	 eMJMiaDuSWkaKoEjr5FhlPnycQ9ApVQx94lnTIT9pYLpfJsoMhgnPMOykGv6ofo53Y
	 CjuTqM01MIbO0Ubx3FSZCGRD5Al4Ej8gMa59+z3cLLWaUC6VjthgxHTBjCOd4/mi0s
	 sqij3Gl7gGUvA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECB8CD3423;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:56 +0800
Subject: [PATCH RFC 10/32] mm: replace folio_test_workingset with
 folio_is_workingset
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-10-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=6427;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=R3jorkkLRpDVsaAXmdj3l7nh5hAt5IvzuBZ6Gm5Pqmg=;
 b=o1Oy0PnIcsoV8EG77I3PhPiNKZxsAv+s5jJS+1nT6dut/a2CmRW+2BfV8rjqYcPUVz3kSMca9
 hftH+YUfXLhAp/J5ftyLTbfP4xoKGNHQIaO26+3+L30vUaPbNdkgWH+
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50F66100007
X-Rspam-User: 
X-Stat-Signature: ypym8bubhacx77j3bp1sxo3gpoe3m4iz
X-HE-Tag: 1777669457-127480
X-HE-Meta: U2FsdGVkX1/SPp9GoQmLPLBeKlYsLfjcyLjTlqtVT+uaqzWL5kWDsVgNHBGaP3OKgs4zzh+7IZyxNSnvoFb6J7m0EfZcM02xY1UxpYRHjGcMQyMwLsB3Dd0ghLM6MK7VC61FAfHxQlemAD6lEnCrb+uugzU94/VVt3G+E0y5w3GMQfr83aRpL3+6pv0QB0SKpfODbD6qyuTs+i2rxjO84/O3ah+2+mUW9gDQiiS429KDzQL4+GjdnCbKb9IWJCYBLRrAFVA4IZngxHv+kjgmPQhGdA1kNckovc9jHL8OnMKdK7U8ur6DX8A9zdn9wQQ/bPxsJqQE1+a95lYEy36vzGWTs+VvhrxVwQu86Aa9hBTK7JAMpsET+YGp6ouTZjkecLYY7ChwDAnnrZXtU/nOpKjqf+NJrRVErSfpI1bCL2L1JxyYOSrZHmiQ+tQxDSpQYNSVK68fxDrhPwiSp/T+6imPJkdg933ZhJoq2v5r3m43VYkE2kZ65WCXvIjHIAxpRpeWW/N9eI9HiOR8c1asPviIwJB/M31ADoV1Kzf2KXhWnvp+zUrHwmHJQeVxLb4KC+49OTjuEHmYYtnVZpzNDf/EFyB2RHst++lu2lRq9XgWpicod0vrsjiAR4IJUUlZxvi+vRPGd5LdcLQg+7WH2WqKxA7dw/BKF7H2pPN5U+/8yFhywcehKQzOKcvw2WWni6kYZUdhb3RvArJwADWPW9zlsgAspUOPn2yCKDj21tKPPxsSPPNtdcODzUfcWkDFZe26khhYlEHStsTzOPwK85cMigti8G9jwsi+OBF/g3j/XGgPQdWNh1ymCwKbQ7YHXaz98XgVfBh6TDvxHtQSdC6xPIYAamJkaY0pF5+vIF+AGjat4Mw7RH/GAq6IuoCAlzunMvPQzUyUTJ6uAqxpR2LBKjUuexfYFFC//k7tiM9wjsDNrYgPaLTjBxfTVWSAih3Yr0T1LYa0MeY191e
 q7MJ8gL2
 bg/4garYmjsH/c1E+R34tx/cljeLOV8BkJPCR9xTkpPuEyOSa1jnBaTIyQaHzJJVkBfhfPIbyzyef4cat/qH1/iwQs9t5sVA0fjvYzN07224GJZ8gGF+eJ+ES4clg0QRiajhojubFSOoG+69YKIVv3hn6nmdRLJjk4uw6jXg9rmFYKmORJiJXSDhcfKbFFs5Prq+JROSs6jbmmfKCOImJlzEjAf4Tb1ZLBckGL1brfhJ2oX+cDAybBCrtmr3vopdbHHVJWAGQ3PisrHCsdT/DwBW29zO2AZiDWbJnvo8pYpCXpe7Bs2wvGxEmwIohAR+DDxDqIgsWIBYNFadokjUrs1oyoHntzw/ffZ1FSnJHwB8LrDkL3sKsUawdWJ3gp24HxBBaZB/YRb0UyNyZ1/lpf37sjSeLEOLvAw4FgKhOBaDqTy0qVg4aVM3rIKdNrQwgL97E4W3ek1vIryQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With the new folio LRU refs tracking API, a folio is considered a
workingset folio if its referenced count > 1. This is compatible and
reasonable in many ways:

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
 fs/btrfs/compression.c |  3 ++-
 mm/filemap.c           | 10 +++++-----
 mm/page_io.c           |  3 ++-
 mm/readahead.c         |  8 ++++----
 mm/workingset.c        |  2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b2393a48a8fe..ac7bfb0017c6 100644
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
@@ -461,7 +462,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			continue;
 		}
 
-		if (!*memstall && folio_test_workingset(folio)) {
+		if (!*memstall && folio_is_workingset(folio)) {
 			psi_memstall_enter(pflags);
 			*memstall = 1;
 		}
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..50897ca1d74e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1254,7 +1254,7 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	bool in_thrashing;
 
 	if (bit_nr == PG_locked &&
-	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+	    !folio_test_uptodate(folio) && folio_is_workingset(folio)) {
 		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
 		thrashing = true;
@@ -1409,7 +1409,7 @@ void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 	struct folio *folio = softleaf_to_folio(entry);
 
 	q = folio_waitqueue(folio);
-	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
+	if (!folio_test_uptodate(folio) && folio_is_workingset(folio)) {
 		delayacct_thrashing_start(&in_thrashing);
 		psi_memstall_enter(&pflags);
 		thrashing = true;
@@ -2492,7 +2492,7 @@ static void filemap_get_read_batch(struct address_space *mapping,
 static int filemap_read_folio(struct file *file, filler_t filler,
 		struct folio *folio)
 {
-	bool workingset = folio_test_workingset(folio);
+	bool workingset = folio_is_workingset(folio);
 	unsigned long pflags;
 	int error;
 
@@ -3787,7 +3787,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
 		 */
-		if (!folio_test_workingset(folio))
+		if (!folio_is_workingset(folio))
 			(*mmap_miss)++;
 
 		/*
@@ -3845,7 +3845,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 		goto out;
 
 	/* See comment of filemap_map_folio_range() */
-	if (!folio_test_workingset(folio))
+	if (!folio_is_workingset(folio))
 		(*mmap_miss)++;
 
 	/*
diff --git a/mm/page_io.c b/mm/page_io.c
index 70cea9e24d2f..a78a4e753650 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -25,6 +25,7 @@
 #include <linux/sched/task.h>
 #include <linux/delayacct.h>
 #include <linux/zswap.h>
+#include <linux/mm_inline.h>
 #include "swap.h"
 
 static void __end_swap_bio_write(struct bio *bio)
@@ -614,7 +615,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
-	bool workingset = folio_test_workingset(folio);
+	bool workingset = folio_is_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..f3b03d6e7828 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -291,7 +291,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		}
 		if (i == mark)
 			folio_set_readahead(folio);
-		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_workingset |= folio_is_workingset(folio);
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -460,7 +460,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 	}
 
 	ractl->_nr_pages += 1UL << order;
-	ractl->_workingset |= folio_test_workingset(folio);
+	ractl->_workingset |= folio_is_workingset(folio);
 	return 0;
 }
 
@@ -797,7 +797,7 @@ void readahead_expand(struct readahead_control *ractl,
 			folio_put(folio);
 			return;
 		}
-		if (unlikely(folio_test_workingset(folio)) &&
+		if (unlikely(folio_is_workingset(folio)) &&
 				!ractl->_workingset) {
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
@@ -826,7 +826,7 @@ void readahead_expand(struct readahead_control *ractl,
 			folio_put(folio);
 			return;
 		}
-		if (unlikely(folio_test_workingset(folio)) &&
+		if (unlikely(folio_is_workingset(folio)) &&
 				!ractl->_workingset) {
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
diff --git a/mm/workingset.c b/mm/workingset.c
index bdee91f54e61..fa644948c80e 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -415,7 +415,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-			   folio_test_workingset(folio), file);
+			   folio_is_workingset(folio), file);
 }
 
 /**

-- 
2.54.0



