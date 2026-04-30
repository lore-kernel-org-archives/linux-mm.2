Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC14ECD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BDDD6B0088; Thu, 30 Apr 2026 15:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16EA76B008A; Thu, 30 Apr 2026 15:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E0F6B008C; Thu, 30 Apr 2026 15:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E93B66B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:18:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A3B11A021D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:18:18 +0000 (UTC)
X-FDA: 84716183076.27.2A0B608
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id BACAE100002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:18:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AtXrISt1;
	spf=pass (imf05.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777576696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZwnLUHiG8O1MdjM0kmnnyc0flpcKXirYcVgal6csgw=;
	b=MiF1PDME39RK8qG8ILSQVj+6uHe/XuuEyHt2hEUBQoTdrX3RpJh7AzJrxStpKuCC4DsMLs
	tk3vYCTUgv6jr9vlOW8ofKwcTW4AO5wZG5PuHX3oWTy5WYaKzeYVbZPckwwiMdX9dPLVN5
	i4kqw/sFvAY+98rYiQBfrqjOWOrNv04=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AtXrISt1;
	spf=pass (imf05.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777576696; a=rsa-sha256;
	cv=none;
	b=JBmGTcPA7PH1R/ErkRlG6Q8TXNLyhYBQYVnJQ4zk/2kYSjLBI5Pz8F8uhraHJKkCGuqaKw
	6xJsv3FFwMkcubXSyibgfjFy3InjfPGtZ7ZY2BSGYvMRqZZtuIWKYojzQ4Y+dwCtST01Ep
	etpDtO5WJvpbLmKg5V9w7UgFGbYycw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777576696; x=1809112696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9xRAWwj3pLrZDo4tNzwycq0hBG1zi6qAVrT2yqbpHvs=;
  b=AtXrISt1O7OBus6Uy02pGn+gXhfjLGJqG1l73q4G1ah7dtUclPid7YNo
   EmKQNoG/q03rhC1mC0jb8xhfJyTFSgadqmf1+kfcqRlkaFIZihBtGM7m5
   Uh6Z3fow8453ioU6lNrh92cML3LDUjWw61SHGLAdLG0qkK7cnHNybl5XR
   XA74ejM9Scyqi+1ZYdMvXj9W+PBDi0umxGMrgOaG67144hRaABDDE+zqN
   Q5eEm5T20xa3/64OuGtbS+PzSvzgI2JZmPNv0r0ELL68GgOFYjdYi8m9Y
   IIuqGMqz+sqXSoyL269JqqONBwJl0WlqBKk52mBaxvLscTd/3fqgIf2fE
   A==;
X-CSE-ConnectionGUID: 79dwpyDRQG+h+0U8esusqw==
X-CSE-MsgGUID: U2rV2hj+R/O6w6StgNWkNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="77706727"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77706727"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:18:14 -0700
X-CSE-ConnectionGUID: G4Aw1cICSPK90A0Mm/dydg==
X-CSE-MsgGUID: XveSe6U/SHmUsLCOnwuzvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="233801144"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:18:14 -0700
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
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH v4 1/6] mm: Wire up order in shrink_control
Date: Thu, 30 Apr 2026 12:18:04 -0700
Message-Id: <20260430191809.2142544-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260430191809.2142544-1-matthew.brost@intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BACAE100002
X-Stat-Signature: xps9zd1rahtjaj33jwbmu1drc8fw7p6i
X-HE-Tag: 1777576695-221578
X-HE-Meta: U2FsdGVkX18Q1DgMFyiQAdoK7xbJlywJHevuZcQ1S84BKMd2G0p+0gi2HeT8VFTuXzVNz+cRhppspeBw5T2DYEKTkycFo2nVL7DL2miokW3MwT0Ajo/syK3rxGIK+7fg1wcthVu4rxOUFt7RrIE6HuQWB6UVdjj7hfuvypvgkfqoZBV+K7WQPEhq6TKVrlAHggNg9hvezo7m0QoStC3C1rz/okpc7eYT5N2d2zGnvdWcLU1BYLFmroR8+OW6IghVpOLnDcl+ZoNgOcrTvYztAN0WcWybwd4OIqofLYkOH8pZb2blwf2kZa9oHVTh244TKrjDC39+YYxL8OzSwq0SFzd+7Fn+DmuFxCAdjG3aDFQZScaeISWfhCnw022wrrzeZdFpbXfjUQAdtmk7UIet0luT0OzANi14fdf8odQwHWd5IEzhC34ITbJAAWwTx77GNWbrBqrLh7GVr1tazHLjOlafGH5hlESj1lnGAkAuBiHCmN6vN3pWIX5j0hCBWmNMTszyrXK7IfvRtKgF974lbGJK+B6DFlw2Lxgz1X74PEmnmhx0FVzPXlSxzPcnqAfAA3zWgrqlNyXZKQxvo/kL3NuOk7at97raPia5UzU4+4898Fa2EkyP0iZDJT7i1KpxF1fmJbOFOSW0IYqkA0m5XfafAhUHbrf0b5nbM2kiEsduZhzn1Dfp9Q46P+qqmiUWqcEZKM2HCWhQT5qP92QkF3dOnVj5AL+aNBtXyMEcWoQxLhNJTUBSZwNvFugK3izOZsE/ao10+50ZBmzVKNK20NjH7qaFqk4t2Drm1+zfsP3cGGzaWxE+6AjezGPAjWoszlnIBJtXChiyOKHi48Ty4PCf8g6QCafGAlIked0kSwEVtm76tJs4nEw5s3jtXxNe309NdIrEVT/xvvu0n+ClVaXypmeUUQtD2bm/K1NIOygYYZcEykJrDly31D6hOT3XwZDhitt4EyCqKuzA4B9
 LhEqBSwo
 tDvOLZIlUAaW+vTNYLPvWT1qW6a0806MLrWCoiMTEwupt/bRHi3nPwEW56rt2dqaVUVDjo7nzBk8FZ9HElN1ZIlqVmBi3KUuLSdk7v777Xi0gV9bxy5twyvcIkjUihfQzpMaPcrqA+tO5Vv5heZ9wShQkzEHcmkq537iCCDGmHhkXKGqzKvz2btTB61/LxwZ93KxgapLBC5oTg4tO0mvIhzgshwxcTJGSkk0piBTq5vETByfBrcz7qhMP349Uf9Kfc17sa/gEe/XBEl51i/vfsbE0/CH/s5Y9KsrNQs7KnryMHpAtgbzLU6ab5K3kMB5IIZIby80zWdK55+etb3oNgsPazhVvPfBdpJbfqCOHTwTyr62q3UxOx+dAbRafultnDsReEZkpmMHXGZlANstofQUuX7FbTMugVT0i5TyuFV+WWkF7S19FvcOwBnOMg7OKgh1k7LWM9fm6NKels1e5mfNJdCSGCAav0CEo3Mu1INa3Iu3VJZLc4HnLt6STJVV5wLayCZTunwkE4hwAs8E8F7qz1qKL4CZ0zegoZcLqcw/cAuKxJu6vSTkfvp9WWmHGPOrqZFqFohesFDLWYqMFsrd1usvXGy23HDDqFbtjY/PehNCvE9zK8YVVihjkCNpcEaG4rCCg/kL7HLhfZ0QyBIJ9HmkcrDgQYLdlgRfhZpysxp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass the allocation order through shrink_control so shrinkers have
visibility into the order that triggered reclaim.

This allows shrinkers to implement better heuristics, such as detecting
high-order allocation pressure or fragmentation and avoiding eviction
of working sets when reclaim is invoked from kswapd.

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
Suggested-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>

---
v4: Fix build without CONFIG_MEMCG (CI)
---
 include/linux/shrinker.h |  3 +++
 mm/internal.h            |  4 ++--
 mm/shrinker.c            | 13 ++++++++-----
 mm/vmscan.c              |  7 ++++---
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a..7072f693b9be 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -37,6 +37,9 @@ struct shrink_control {
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
 
+	/* Allocation order we are currently trying to fulfil. */
+	s8 order;
+
 	/*
 	 * How many objects scan_objects should scan and try to reclaim.
 	 * This is reset before every call, so it is safe for callees
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..ff8671dccf7b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1759,8 +1759,8 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
-unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
-			  int priority);
+unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
+			  struct mem_cgroup *memcg, int priority);
 
 int shmem_add_to_page_cache(struct folio *folio,
 			    struct address_space *mapping,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 76b3f750cf65..c83f3b3daa08 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -466,7 +466,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 }
 
 #ifdef CONFIG_MEMCG
-static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
+static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
 			struct mem_cgroup *memcg, int priority)
 {
 	struct shrinker_info *info;
@@ -528,6 +528,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
 				.nid = nid,
+				.order = order,
 				.memcg = memcg,
 			};
 			struct shrinker *shrinker;
@@ -587,7 +588,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	return freed;
 }
 #else /* !CONFIG_MEMCG */
-static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
+static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
 			struct mem_cgroup *memcg, int priority)
 {
 	return 0;
@@ -598,6 +599,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
  * shrink_slab - shrink slab caches
  * @gfp_mask: allocation context
  * @nid: node whose slab caches to target
+ * @order: order of allocation
  * @memcg: memory cgroup whose slab caches to target
  * @priority: the reclaim priority
  *
@@ -614,8 +616,8 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
  *
  * Returns the number of reclaimed slab objects.
  */
-unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
-			  int priority)
+unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
+			  struct mem_cgroup *memcg, int priority)
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
@@ -628,7 +630,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 	 * oom.
 	 */
 	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
-		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
+		return shrink_slab_memcg(gfp_mask, nid, order, memcg, priority);
 
 	/*
 	 * lockless algorithm of global shrink.
@@ -656,6 +658,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
+			.order = order,
 			.memcg = memcg,
 		};
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..a54d14ecad25 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -412,7 +412,7 @@ static unsigned long drop_slab_node(int nid)
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
+		freed += shrink_slab(GFP_KERNEL, nid, 0, memcg, 0);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	return freed;
@@ -5068,7 +5068,8 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	success = try_to_shrink_lruvec(lruvec, sc);
 
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
+	shrink_slab(sc->gfp_mask, pgdat->node_id, sc->order, memcg,
+		    sc->priority);
 
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
@@ -6170,7 +6171,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		shrink_lruvec(lruvec, sc);
 
-		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
+		shrink_slab(sc->gfp_mask, pgdat->node_id, sc->order, memcg,
 			    sc->priority);
 
 		/* Record the group's reclaim efficiency */
-- 
2.34.1


