Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B0DCD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00D96B0093; Tue,  5 May 2026 23:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B5C6B0099; Tue,  5 May 2026 23:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2126B0095; Tue,  5 May 2026 23:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC1B6B0093
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:33:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37797A0668
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:14 +0000 (UTC)
X-FDA: 84735574308.20.5DFAE0A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id E8C7EC0007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="N/D/c6hx";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IdSgDyRRYncyzLLU5st/Pc62lGvEdvmHHclM/yGCMA=;
	b=sf/JLM6wy4ZorpzpI5z/Ofuo5NXetNMAu+JwkNp6ziR5yeK+UWlN9L/wRPWjvVFkeTtOlq
	k/ZbOLqjXRtxe+lKhah2inoilPE2WXTIvcHMcf96UFbhvdsgHYDq+PKM8Y/F6pvtXkfImX
	x8gawoVxn0xSE2s6vKFMQgNNrrK6bPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038392; a=rsa-sha256;
	cv=none;
	b=Jg4sQmgsxa3jpCQyEnIVNAsoRuGpHC4iG6tgVXgPCsFZoiidEf2i/IxByuXdmd3MiCkLIP
	DGvJ2k3oZv5rjRagDvmVE92iP6BOit1rty1QQgprQv9CV9QQovGnx+PdXzlAUECiuocrLm
	Yn8FZId9Yej1p/ehS2Ue7oSSZWM9oqc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="N/D/c6hx";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778038393; x=1809574393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aHVNymQuQK1hQF9n5owlycgqWuDIDx54Dow9YV/hQrc=;
  b=N/D/c6hxIHzz4dlN35qogjgNHMJgAp0PuXF+Khs593dxXh8GzpxSNSgD
   MShfF3nNviq0kZFEO7al8uvgfktHtDQs6kHVkgQYMb+jp1SfBc+la1qn+
   g7cOG/amiUdq6UimuCR231f4uVE3qyQzg3gqW+75sj+5Xtnb9xBGFXPq3
   KNLJtsZXQeplCgNFXxzXfEvFkgpPBXLkx7rabNwSYtDhoMgbT6ZmA1ysB
   r73V+SbMwFTu8CVRsYlPDUgdtdDzlde7zEksSIHwSw4gzpSlZqduGu/x1
   JolSaaUP71BGAhJWLrdLzY11wxutT1DoyfPA+Owy6+CsShQSwwa+pjYlE
   g==;
X-CSE-ConnectionGUID: mHUg0c9VTbiW9wUBZmd3aw==
X-CSE-MsgGUID: jhShyhMiRIiU2As3RgGahQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78829037"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78829037"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:07 -0700
X-CSE-ConnectionGUID: qPgFxjMzSgKQBpZL9lINlg==
X-CSE-MsgGUID: VGh6WgVBRTmNHKrHDo5xFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="266342147"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:06 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/5] mm: Introduce opportunistic_compaction concept to vmscan and shrinkers
Date: Tue,  5 May 2026 20:32:57 -0700
Message-Id: <20260506033300.3534883-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506033300.3534883-1-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8C7EC0007
X-Stat-Signature: ppmaqu99x4ac8ztouzapi893kdp6ewnq
X-Rspam-User: 
X-HE-Tag: 1778038391-537801
X-HE-Meta: U2FsdGVkX19VgKlBprE4P8Zj3RheX+iiwYbaoRYUsdlPDP/QYq8KnFVqq1VD2izeTFOoMNfFhIAmuo2AK0Md7QtOaJmSaKxWL3cktDEeblH11uhWvcu/CLV75D9R6wvVipkQYWFitPZuN3ZDPZCwVny3750s05hWlxg+oSjL1wnGRJP/0tyl9NEYbyUnowklqoBxLA8MC3qP/vwYK8qo/J2u3JxkEwjA6b1da7MrprY675B+VV4qhq4lht+6wbyyrudxRRYQxAcPabTLGJ6ZCfd93dGf9zS3FAIb8GWOR8g5NRy4DkKGOCWMNpaTe8328oPm18nJhibP4i0p1jq94DsEvBIviAHcvGOBn+rUsBu6HS20WUl12WyaSemSOVe/dc7r3bmimTkZxfAmTxg+YYnWadFXwTvg2fo7CIgpcJgoW4a3wPEA3c5gjjJ7SQA29yyLYcZpHZAZi6fNz/bMhH2i7x+jns4aM0e8mjgtuU25T0IksnZ1apyCv0rglyz6LjrcawkQG5AQIqTv67jE7HhXCVnP0nKXlBqDYeNwgMwnoFbMGr0rIyP0uSh+UM9mwb3HvTyHv5S4w9nOylCWqwytI68e1/kRW1ZQ4rc6QQTgHf+6zhf7TGQ7WtMtkJoFDtwQuO4CLPz03MHiYhEZg3zpkczoihSaWGN0REvxhrc7P4pbB0bEOmOmm437Hth69rcQ1o5K8MX3KMUWPxIEzcBRnLg8tM/blwPoM+ZyxyUmNsZ8V9ypHsigyx1uFs2qgFNRwFKMzUDgVpommiSEeaaCpiOyz0uVPOhL08O2/CN0iyhJJQ7kR23iM02xNKl3jNbbgwqzql3i3ntfK4fbCWGW9pc+i6Ejg18PFl3D0mlVO/TgO7cav+KYfLNe1UQIkhOMHLO8JNuRsBAew+Xi0i9X3xQ4xdD8LNB0ekkRMgWBTmnfjqr7Eji3oNY7RyRVL7gjMd7N5uPSihA6iv2
 ewk//nLD
 mwp1bK3Qo7wNjUkXEMaNNsRQjOI+IiJ9dgOrWJTbK7/tEw14h0ph+ENxsCMwq7K6KMcOexCjxzxLlzHPcUr9MJGORncR6t0w7FJCJJ80sDhTE4/9v8FLniI7P/kpDC370CiUs/mHxRYPLeZWOhoG4nryq77YNn+EPtvL3PpGjk36/2AdllMoXT72KWNqWntKzM25ovp5nDKaSLsEgy/fGGvaGfKKXZU9UJhP4NZ0L9W0W4gtRGKWJfwf/TbGCQwjwN0mmjP2ElfTHifKCuy6jxzfte3CPShYw6C98hf/Gz1nE39SLjIGV2FmiixihYMt6nRlDrDYk0LMdxpQmRsVZZ5v5uRDPLemycTOLD1+waFAjWTzcA50ueYidnr3ze+KhALJ3P8dGWwpJcln4+2cR5UMpcIeawb4FjU3+ryGLBmM1zvfLigbr3lcco2pKzR4zrjVhhkUMQpbFJMiXxfNIDmsXkLrRZ7qUpOG89XsSLpVnDbWNVlCuPggUK2/C6d9Y/xn85kLG+x8EhwgvETDHBP7jL4pufWvDV8b4+yecm834lCzi7D7V6otdjJrDTxb+cUn/ZChhqc/X9kIfUGEjNRIzdwbKavGcsoTdn2C1kB+n50HhxMnjUJxmeC2BhfCdZchO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

High-order allocations using __GFP_NORETRY or __GFP_RETRY_MAYFAIL
are often opportunistic attempts to satisfy fragmentation-sensitive
allocations rather than indications of severe memory pressure. In these
cases, kswapd reclaim may invoke shrinkers that aggressively destroy
working sets even though reclaim is unlikely to materially improve the
allocation outcome.

Some shrinkers manage expensive backing or migration operations where
reclaim can result in substantial working set disruption despite the
system having sufficient free memory overall. This is particularly
visible in fragmentation-heavy workloads where reclaim repeatedly tears
down active state while kswapd attempts to satisfy higher-order
allocations.

Introduce an opportunistic_compaction hint in shrink_control that allows
kswapd to communicate when reclaim originates from a high-order
allocation context that may be fragmentation driven rather than true
memory pressure. Shrinkers may use this hint to avoid destructive
working set reclaim while still participating normally during order-0
or stronger reclaim conditions.

The hint is propagated through shrink_slab() and derived from
high-order kswapd wakeups associated with non-failing allocation
contexts.

No functional changes are introduced for existing shrinkers.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 include/linux/mmzone.h   | 40 +++++++++++++++++++++++
 include/linux/shrinker.h | 20 ++++++++++++
 mm/internal.h            |  3 +-
 mm/shrinker.c            | 14 +++++---
 mm/vmscan.c              | 70 +++++++++++++++++++++++++++++++++++++---
 5 files changed, 137 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..1554e8058e4b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1461,6 +1461,39 @@ struct memory_failure_stats {
 };
 #endif
 
+/*
+ * Per-pgdat state machine for the kswapd "opportunistic compaction" hint.
+ *
+ * wakeup_kswapd() collapses the gfp flags of all wakers that arrive between
+ * two kswapd runs into a single tri-state, which kswapd then forwards to the
+ * shrinkers via shrink_control::opportunistic_compaction:
+ *
+ *   KSWAPD_UNSET_OPPORTUNISTIC_COMPACTION
+ *	Initial state after kswapd consumes the previous value. No waker has
+ *	been observed yet for the upcoming run.
+ *
+ *   KSWAPD_NO_OPPORTUNISTIC_COMPACTION
+ *	At least one waker is an order-0 allocation, or a high-order
+ *	allocation that cannot tolerate failure (i.e., not eligible for
+ *	opportunistic behaviour). Shrinkers must do their normal best-effort
+ *	work; the hint is cleared.
+ *
+ *   KSWAPD_OPPORTUNISTIC_COMPACTION
+ *	All wakers seen so far are high-order allocations that may fail
+ *	(__GFP_NORETRY or __GFP_RETRY_MAYFAIL, without __GFP_NOFAIL). Shrinkers
+ *	may skip work that is unlikely to produce a contiguous high-order
+ *	block (e.g., evicting working-set pages).
+ *
+ * The state is sticky in the "NO" direction within a single kswapd run: once
+ * any non-eligible waker is observed, subsequent eligible wakers cannot
+ * upgrade it back to KSWAPD_OPPORTUNISTIC_COMPACTION.
+ */
+enum kswapd_opportunistic_compaction_type {
+	KSWAPD_UNSET_OPPORTUNISTIC_COMPACTION = 0,
+	KSWAPD_NO_OPPORTUNISTIC_COMPACTION,
+	KSWAPD_OPPORTUNISTIC_COMPACTION,
+};
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1525,6 +1558,13 @@ typedef struct pglist_data {
 #endif
 	struct task_struct *kswapd;	/* Protected by kswapd_lock */
 	int kswapd_order;
+	/*
+	 * Aggregated opportunistic-compaction hint for the next kswapd run.
+	 * Updated by wakeup_kswapd() based on the gfp flags / order of each
+	 * waker, and consumed (and reset) by kswapd before balance_pgdat().
+	 * See enum kswapd_opportunistic_compaction_type for the state machine.
+	 */
+	enum kswapd_opportunistic_compaction_type kswapd_opportunistic_compaction;
 	enum zone_type kswapd_highest_zoneidx;
 
 	atomic_t kswapd_failures;	/* Number of 'reclaimed == 0' runs */
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 7072f693b9be..c1a69536bcdc 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -40,6 +40,26 @@ struct shrink_control {
 	/* Allocation order we are currently trying to fulfil. */
 	s8 order;
 
+	/*
+	 * Opportunistic compaction hint.
+	 *
+	 * Set by the reclaim path to tell shrinkers that this pass is
+	 * driven by an order > 0 allocation that the caller is willing to
+	 * have fail (e.g., __GFP_NORETRY / __GFP_RETRY_MAYFAIL without
+	 * __GFP_NOFAIL). Such allocations only really benefit from
+	 * shrinking when doing so frees up a contiguous, high-order block;
+	 * thrashing working sets in the hope of producing one is typically
+	 * counter-productive.
+	 *
+	 * Shrinkers that can produce naturally-aligned high-order folios
+	 * (see shrink_control::order) should treat this as a hint to skip
+	 * costly work that is unlikely to help compaction (for example,
+	 * evicting hot/working-set pages just to free single pages).
+	 *
+	 * Only meaningful when @order > 0; ignored otherwise.
+	 */
+	bool opportunistic_compaction;
+
 	/*
 	 * How many objects scan_objects should scan and try to reclaim.
 	 * This is reset before every call, so it is safe for callees
diff --git a/mm/internal.h b/mm/internal.h
index ff8671dccf7b..a822ddfc7e5d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1760,7 +1760,8 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
-			  struct mem_cgroup *memcg, int priority);
+			  struct mem_cgroup *memcg, int priority,
+			  bool opportunistic_compaction);
 
 int shmem_add_to_page_cache(struct folio *folio,
 			    struct address_space *mapping,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index c83f3b3daa08..bdc331e8a344 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -467,7 +467,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 
 #ifdef CONFIG_MEMCG
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
-			struct mem_cgroup *memcg, int priority)
+			struct mem_cgroup *memcg, int priority, bool opportunistic_compaction)
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
@@ -530,6 +530,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
 				.nid = nid,
 				.order = order,
 				.memcg = memcg,
+				.opportunistic_compaction = opportunistic_compaction,
 			};
 			struct shrinker *shrinker;
 			int shrinker_id = calc_shrinker_id(index, offset);
@@ -589,7 +590,8 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
 }
 #else /* !CONFIG_MEMCG */
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
-			struct mem_cgroup *memcg, int priority)
+			struct mem_cgroup *memcg, int priority,
+			bool opportunistic_compaction)
 {
 	return 0;
 }
@@ -602,6 +604,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
  * @order: order of allocation
  * @memcg: memory cgroup whose slab caches to target
  * @priority: the reclaim priority
+ * @opportunistic_compaction: do compaction opportunistically (e.g., do not swap working sets)
  *
  * Call the shrink functions to age shrinkable caches.
  *
@@ -617,7 +620,8 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
  * Returns the number of reclaimed slab objects.
  */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
-			  struct mem_cgroup *memcg, int priority)
+			  struct mem_cgroup *memcg, int priority,
+			  bool opportunistic_compaction)
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
@@ -630,7 +634,8 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
 	 * oom.
 	 */
 	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
-		return shrink_slab_memcg(gfp_mask, nid, order, memcg, priority);
+		return shrink_slab_memcg(gfp_mask, nid, order, memcg, priority,
+					 opportunistic_compaction);
 
 	/*
 	 * lockless algorithm of global shrink.
@@ -660,6 +665,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
 			.nid = nid,
 			.order = order,
 			.memcg = memcg,
+			.opportunistic_compaction = opportunistic_compaction,
 		};
 
 		if (!shrinker_try_get(shrinker))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a54d14ecad25..57b8e1af6300 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -96,6 +96,14 @@ struct scan_control {
 	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
 	int *proactive_swappiness;
 
+	/*
+	 * Opportunistic compaction hint snapshotted from the pgdat at the
+	 * start of this reclaim pass. Forwarded to shrinkers through
+	 * shrink_control::opportunistic_compaction so they can skip
+	 * non-productive work for failable high-order allocations.
+	 */
+	enum kswapd_opportunistic_compaction_type kswapd_opportunistic_compaction;
+
 	/* Can active folios be deactivated as part of reclaim? */
 #define DEACTIVATE_ANON 1
 #define DEACTIVATE_FILE 2
@@ -412,7 +420,7 @@ static unsigned long drop_slab_node(int nid)
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		freed += shrink_slab(GFP_KERNEL, nid, 0, memcg, 0);
+		freed += shrink_slab(GFP_KERNEL, nid, 0, memcg, 0, false);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	return freed;
@@ -5069,7 +5077,8 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	success = try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, sc->order, memcg,
-		    sc->priority);
+		    sc->priority, sc->kswapd_opportunistic_compaction ==
+		    KSWAPD_OPPORTUNISTIC_COMPACTION);
 
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
@@ -6172,7 +6181,8 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 		shrink_lruvec(lruvec, sc);
 
 		shrink_slab(sc->gfp_mask, pgdat->node_id, sc->order, memcg,
-			    sc->priority);
+			    sc->priority, sc->kswapd_opportunistic_compaction ==
+			    KSWAPD_OPPORTUNISTIC_COMPACTION);
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
@@ -7105,8 +7115,14 @@ clear_reclaim_active(pg_data_t *pgdat, int highest_zoneidx)
  * found to have free_pages <= high_wmark_pages(zone), any page in that zone
  * or lower is eligible for reclaim until at least one usable zone is
  * balanced.
+ *
+ * @kswapd_opportunistic_compaction is the aggregated hint produced by
+ * wakeup_kswapd() for this run; it is propagated into scan_control so that
+ * shrinkers can skip costly work that is unlikely to help compaction when
+ * all wakers are failable high-order allocations.
  */
-static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
+static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx,
+			 enum kswapd_opportunistic_compaction_type kswapd_opportunistic_compaction)
 {
 	int i;
 	unsigned long nr_soft_reclaimed;
@@ -7120,6 +7136,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		.gfp_mask = GFP_KERNEL,
 		.order = order,
 		.may_unmap = 1,
+		.kswapd_opportunistic_compaction = kswapd_opportunistic_compaction,
 	};
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
@@ -7442,6 +7459,7 @@ static int kswapd(void *p)
 	unsigned int highest_zoneidx = MAX_NR_ZONES - 1;
 	pg_data_t *pgdat = (pg_data_t *)p;
 	struct task_struct *tsk = current;
+	enum kswapd_opportunistic_compaction_type kswapd_opportunistic_compaction;
 
 	/*
 	 * Tell the memory management that we're a "memory allocator",
@@ -7459,6 +7477,7 @@ static int kswapd(void *p)
 	set_freezable();
 
 	WRITE_ONCE(pgdat->kswapd_order, 0);
+	WRITE_ONCE(pgdat->kswapd_opportunistic_compaction, KSWAPD_UNSET_OPPORTUNISTIC_COMPACTION);
 	WRITE_ONCE(pgdat->kswapd_highest_zoneidx, MAX_NR_ZONES);
 	atomic_set(&pgdat->nr_writeback_throttled, 0);
 	for ( ; ; ) {
@@ -7474,10 +7493,13 @@ static int kswapd(void *p)
 
 		/* Read the new order and highest_zoneidx */
 		alloc_order = READ_ONCE(pgdat->kswapd_order);
+		kswapd_opportunistic_compaction = READ_ONCE(pgdat->kswapd_opportunistic_compaction);
 		highest_zoneidx = kswapd_highest_zoneidx(pgdat,
 							highest_zoneidx);
 		WRITE_ONCE(pgdat->kswapd_order, 0);
 		WRITE_ONCE(pgdat->kswapd_highest_zoneidx, MAX_NR_ZONES);
+		WRITE_ONCE(pgdat->kswapd_opportunistic_compaction,
+			   KSWAPD_UNSET_OPPORTUNISTIC_COMPACTION);
 
 		if (kthread_freezable_should_stop(&was_frozen))
 			break;
@@ -7500,7 +7522,8 @@ static int kswapd(void *p)
 		trace_mm_vmscan_kswapd_wake(pgdat->node_id, highest_zoneidx,
 						alloc_order);
 		reclaim_order = balance_pgdat(pgdat, alloc_order,
-						highest_zoneidx);
+						highest_zoneidx,
+						kswapd_opportunistic_compaction);
 		if (reclaim_order < alloc_order)
 			goto kswapd_try_sleep;
 	}
@@ -7510,6 +7533,22 @@ static int kswapd(void *p)
 	return 0;
 }
 
+/*
+ * Is @gfp_flags a high-order allocation that is eligible for the
+ * "opportunistic compaction" treatment in kswapd / shrinkers?
+ *
+ * The caller must be willing to tolerate failure (__GFP_NORETRY or
+ * __GFP_RETRY_MAYFAIL) and must not have set __GFP_NOFAIL. For such
+ * allocations there is little value in burning working-set pages just to
+ * scrape together a single high-order block: if compaction can't easily
+ * succeed, the caller would rather see the allocation fail.
+ */
+static bool gfp_kswapd_opportunistic_compaction(gfp_t gfp_flags)
+{
+	return (gfp_flags & (__GFP_NORETRY | __GFP_RETRY_MAYFAIL)) &&
+		!(gfp_flags & __GFP_NOFAIL);
+}
+
 /*
  * A zone is low on free memory or too fragmented for high-order memory.  If
  * kswapd should reclaim (direct reclaim is deferred), wake it up for the zone's
@@ -7538,6 +7577,27 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 	if (READ_ONCE(pgdat->kswapd_order) < order)
 		WRITE_ONCE(pgdat->kswapd_order, order);
 
+	/*
+	 * Fold this waker into the per-pgdat opportunistic-compaction hint
+	 * that kswapd will pick up at the start of its next run.
+	 *
+	 * The state is sticky in the "NO" direction: once any waker in this
+	 * batch is order-0 or a non-failable high-order allocation, the hint
+	 * stays cleared until kswapd consumes it. Only when every waker so
+	 * far is a failable high-order allocation do we set
+	 * KSWAPD_OPPORTUNISTIC_COMPACTION, asking shrinkers to skip work
+	 * that won't realistically help compaction.
+	 */
+	if (READ_ONCE(pgdat->kswapd_opportunistic_compaction) !=
+	    KSWAPD_NO_OPPORTUNISTIC_COMPACTION) {
+		if (!order || !gfp_kswapd_opportunistic_compaction(gfp_flags))
+			WRITE_ONCE(pgdat->kswapd_opportunistic_compaction,
+				   KSWAPD_NO_OPPORTUNISTIC_COMPACTION);
+		else if (order && gfp_kswapd_opportunistic_compaction(gfp_flags))
+			WRITE_ONCE(pgdat->kswapd_opportunistic_compaction,
+				   KSWAPD_OPPORTUNISTIC_COMPACTION);
+	}
+
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
 
-- 
2.34.1


