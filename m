Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C06C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93E36B0093; Wed,  9 Sep 2026 23:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44F96B0095; Wed,  9 Sep 2026 23:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34706B0096; Wed,  9 Sep 2026 23:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7D76B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:47:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89F051403DB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:47:02 +0000 (UTC)
X-FDA: 85196466684.06.2A8AFF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A2F8D140008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:47:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kuPgYMI7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789012020;
	b=j0IQ8/LQEHvqrGVEbgpPUOLntUll6OoA1WO+N+Sz47FPSZcad2oM8mkGQ1o09nUm9He4Ps
	WkeXHru5qCRpkYAQ6TXlpxfMsxFBKJIy5edTaPx9JCJeEEtfgo5K7D2pCj+RNOa+uNantN
	1EgGpVe+vP+RQxOrliO3unLBO1ZuR0U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kuPgYMI7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789012020;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PIGQac4KJSc5ces3tXP7Yn5Rk5egSky+Bbk1BnozjxA=;
	b=lC5QLZrqqRdPvRYXb4fsOd1T5Yech6dg35W5qZyjyF/grnWBZiNaECNZe6UEDpeHb3T26/
	k7xDMWq0rkNRjK+u6IDFhIpbQl5FuX9jUfuU5ZtshgGDa7zgwdUcaPraW5QOw+jFlTfj8+
	jYaP+itaL/NHOk/zdK7vHZMql1BTpjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 113DE600CB;
	Thu, 10 Sep 2026 03:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACFD3C2BCC7;
	Thu, 10 Sep 2026 03:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789012019;
	bh=rnmFLhQ+W54V6NRlDXw9yxyyyS6OM1jdtMbAVv5lvkA=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=kuPgYMI7y3r9FhNTNN2j/mds3devLqSBkcPBny7+VF5pns+ARBL8ri3iLO6nEE774
	 sXr9CUzqodA+dc43taN3q1N6wpM1wdTBJtqWNhl/8+LBjM2j7w4FiqKhgflq6bJXXl
	 dGKVzj2ehrCCX1jsyEFfkWlQrZO1o9xtTDcJhPd82jwmpkquzQFfLIl+Qb+Nbm3Z43
	 O3AqCX4SagUVLx73QV5FU89J+GNL6qC/8FGVVOPyq0WU4nM4Pc1YPQRluj2D1c5lXl
	 e4XSUXx/O/LncjiwykCjg6dkIwpxwMLETU9Jm+clFl2yTyBGLB+hDOb73iroriH5b0
	 TQ60i2eFH7T+g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972D5C79FB9;
	Thu, 10 Sep 2026 03:46:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 10 Sep 2026 11:46:58 +0800
Subject: [PATCH v5] mm/memcg: clear folio memcg after changing per memcg
 stats
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-memcg-swapcache-stats-fix-v5-1-033f510ba748@tencent.com>
X-B4-Tracking: v=1; b=H4sIADEoomoC/33NQWrDMBAF0KsErasgaSzHyqr3KFlIo1Gshe1gC
 bch+O6dhEJSWsys/of/5iYKzZmKOO5uYqYllzyNHOzbTmDvxzPJHDkLo0yrOtPJgQY8y/LpL+i
 xJ1mqr0Wm/CV1IEoQEXwKgveXmbh+2B8nzn0udZqvj1eLvrc/KugNddGSD1WnHYUYuva90og01
 j1Og7i7i3laTm1ahi2H3kcA1VgX/lrwapktC9g6OJtsbKxNh3+s5tWyW1bDVoTWtBEUe+m3ta7
 rN2415qqoAQAA
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789012018; l=6933;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=8n9tFaBEaZV6w7VSVd9OL8zcVOGtD1Os/VxlJVMxjmA=;
 b=u7kryou6X6EpuZcoj1fEwBBnTXHEqJB/8nmrzB3FB3H7zV3Cx6QjLZQANBvbnSkqGtXN7g5l3
 447z0fdva94CF1x0/qEmjP84l6qrAuEi4T7xL+1moF3EQxzrS3V3DuQ
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2F8D140008
X-Stat-Signature: 31iurfo18rtebuyy3zywadxwjerjpe46
X-HE-Tag: 1789012020-828169
X-HE-Meta: U2FsdGVkX1/qIy5sZCi4514ETveFsPYOUEiEA3h3lvO36EsQVHv1NphHA1MvCXfUdDXlGlSna/dyXdzEun7YaWZtsSfQqlzwQOthBoHQd2NvpVSK9Wo2jJkBP+SAVJaJVe3rcY4XZZsxENsCJAB9csTSmlv8JU1/f1sLEI7WGE0ORL0gPcmOo5eVIYL+FO3Kpa6oVodmDh+VX7BlVKj+0TyDZm4BZLg3dtIcGEATq2il5qe7CkyoNaVZChrh674bk769TMqe54F9Vuj2XH5S8TdRGr91AfynYy7Fm5F1F6ylVTjS+iXarHojVPu0IfsWMeyETSFF0AstwFAJqPjED+e8jah1fmRIZnzuH6ofL7l9ox2pJONG8pvqMl97YMNcHejG/mzBwYEhWRbEkmvqwc9qgHEdgFsb6I6vLi9XVAzr9FzoQVh+O3/xgmjy8OorZX3xI+KYow0gIwxNBFyCYIi52yQpdlzLsCCcyPRck0IF0lXmrZ5fdStTIXWoGIJkjVMNJ75RMY7U5XZbKNullrdZwILoiMThbdGhGM9RXjJhucbLJqVjjBI+psrwfvUmZ0XgiSnVQEOLLpTIA1jfwTsHa46CPbdyColdZuE+SnmkFSIJ43DjRpNx3jxEMU3vGNLtiX45D+cZI/ekeGj4Ce2QX8STr53OY2uqKqchPVYGWs5qo18o/7JOSNu3nbSDchNyBQB9SJ+0T3VaVTEPqVB3oI0qSS4uzo4h9tkJflcZqQtdiNXG++U33NW5kmNQzyfpQt1rPBgRu1QKba12JNPBvmrTYV2pzn9TEcwGcVrcnQEOTgpHGWNPai/aXSiHP/WcFsIt1CPxISJlzcYEMpbrS98xmqk2n7JTd8zt9G+CPcdKSgubKmG8emwLKwVPtAG+RlnNLUVIjsQh1mXnNj/qSh66OlkofEbTn+H2jkLgH+BIocmAP1hrJ2IfzD3d8DtKHIAmaXIwZaTMNOM
 G5Ebjbrf
 y/ZpDTvQhxv4dxzbnwedUxwFDLO4JrsFSZIbUzeK2cHVRPLmteAKlzcwid09nRPQFiGcV0l09qjyfxNMf+8mWJF1F1zaL+C0mQeTOQVC3uaEZ2WY1Htw6EftLQPyeFbcyXjFcc/SxSrfbhKp8xgvrSG62vwITf/87NrLEfqzWF4QvwrrMG4WWHSebraVSfbD3zyEJ1vlJdyTPEn8jhwJtSo7e8+nkkvjw6GywZL5tEFATpAOzabpGwBsvskhargriZ/kfaSnmr/UZfQ3jOiiJqXfuLpR4DukikjJxo0sgRip5rUqr82UbnU2MzW0fd2h3dzZpiDLMNo1BmbR9B7RLv3Q7TGEUWWKAQfLXT1XXVvNNlvYiwpOYFSyXEEPt+lE3c+EAbIVdCaX3xMxJXOIE64dRXl+OYg6ANJFVnblsMUqKyTZMOnRhLmPnLvYdDf9aGvk8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

I notice extremely high swapcached count in the per memcg level
memory.stat when running tests with cgroupv1 setup by swapping pages in
and out.  It seems that the counter never gets decreased so the value is
rather useless and confusing to users reading it. So I think fixing it
so that the value can reflect the actual swapcache usage correctly could
be helpful.

__memcg1_swapout() transfers the memsw charge of a folio to its swap
entry and clears folio->memcg_data as part of that.  In the vmscan
swapout path it runs before __swap_cache_del_folio(), which then
decrements the swapcache stats through lruvec_stat_mod_folio().  Since
folio->memcg_data has already been cleared, folio_memcg() returns NULL
and the NR_SWAPCACHE decrement only updates the node-level counter
instead of the memcg's lruvec, leaking the per-memcg swapcache count.

Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
the NR_FILE_PAGES and NR_SWAPCACHE updates but before
__swap_cache_do_del_folio() removes the folio from the swap cache.  This
keeps the stats attributed to the folio's memcg while still recording
the swap cgroup with a valid folio->swap.  Add a swapout parameter so
the plain swap_cache_del_folio() path is left unchanged.

Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Acked-by: Kairui Song <kasong@tencent.com>
---
** Testing **
The problem can be reproduced by populating 256MB of shmem pages in a
memcg and then swapping them out using pageout. After the operation, we
can still see those pages in the swapcached counter by reading
memory.stats.  After applying the given patch, the value is correctly
decreased to 0.

The test script and source can be found from v4 (below).

** Test Results **

before the patch

```
== before reclaim ==
swapcached 0
allocated and dirtied 256 MiB, paging out...
paged out; sleeping so memory.stat can be read. pid=4778
== after reclaim (swap cache should drain to ~0) ==
swapcached 268435456

LEAK DETECTED: swapcached = 268435456 bytes (expected ~0)  [BUGGY kernel]
```

after the patch

```
== before reclaim ==
swapcached 0
allocated and dirtied 256 MiB, paging out...
paged out; sleeping so memory.stat can be read. pid=2601
== after reclaim (swap cache should drain to ~0) ==
swapcached 0

OK: swapcached = 0 bytes  [FIXED kernel]
```
---
Changes in v5:
- Refine the param description. (Kairui)
- Collect Acked-by tags.
- Link to v4: https://lore.kernel.org/r/20260905-memcg-swapcache-stats-fix-v4-1-d3626d305d4f@tencent.com

Changes in v4:
- Update and use the correct fixes tag. (Kairui)
- Briefly describe the context for @swapout param in the kdoc. (Kairui)
- Cc the stable list. (Kairui)
- Link to v3: https://lore.kernel.org/r/20260902-memcg-swapcache-stats-fix-v3-1-795f5d455f7b@tencent.com

Changes in v3:
- Add doc for the new parameter.
- Link to v2: https://lore.kernel.org/r/20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com

Changes in v2:
- Update the commit message to describe the problem in the beginnning.
- Change function declaration for !CONFIG_SWAP as well.
- Link to v1: https://lore.kernel.org/r/20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com
---
 mm/swap.h       |  6 ++++--
 mm/swap_state.c | 13 ++++++++++---
 mm/vmscan.c     |  3 +--
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 0b5d507739bcb..b3b54c28929a1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -319,7 +319,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry, void *shadow);
+			    struct folio *folio, swp_entry_t entry, void *shadow,
+			    bool swapout);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
 
@@ -452,7 +453,8 @@ static inline void swap_cache_del_folio(struct folio *folio)
 }
 
 static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
-		struct folio *folio, swp_entry_t entry, void *shadow)
+		struct folio *folio, swp_entry_t entry, void *shadow,
+		bool swapout)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 305877e1f4d7b..625c185a1ca4d 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -306,21 +306,28 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
  * @folio: The folio.
  * @entry: The first swap entry that the folio corresponds to.
  * @shadow: shadow value to be filled in the swap cache.
+ * @swapout: whether this folio is being reclaimed after swapout.
  *
  * Removes a folio from the swap cache and fills a shadow in place.
  * This won't put the folio's refcount. The caller has to do that.
  *
  * Context: Caller must ensure the folio is locked and in the swap cache
  * using the index of @entry, and lock the cluster that holds the entries.
+ * If @swapout is set, the folio should be in reclaim path and IRQs
+ * should be disabled.
  */
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
-			    swp_entry_t entry, void *shadow)
+			    swp_entry_t entry, void *shadow, bool swapout)
 {
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	__swap_cache_do_del_folio(ci, folio, entry, shadow);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+
+	if (swapout)
+		__memcg1_swapout(folio, ci);
+
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
 }
 
 /**
@@ -339,7 +346,7 @@ void swap_cache_del_folio(struct folio *folio)
 	swp_entry_t entry = folio->swap;
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	__swap_cache_del_folio(ci, folio, entry, NULL);
+	__swap_cache_del_folio(ci, folio, entry, NULL, false);
 	swap_cluster_unlock(ci);
 
 	folio_ref_sub(folio, folio_nr_pages(folio));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b289..29bced43b0ce6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -755,8 +755,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__memcg1_swapout(folio, ci);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
+		__swap_cache_del_folio(ci, folio, swap, shadow, true);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);

---
base-commit: b5529903123d9535bcf74386c1f4e185e8632dd9
change-id: 20260828-memcg-swapcache-stats-fix-1beef3dc3afb

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



