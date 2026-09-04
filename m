Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FB9C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F48D6B0095; Fri,  4 Sep 2026 02:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCB76B0096; Fri,  4 Sep 2026 02:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E22E6B0098; Fri,  4 Sep 2026 02:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1F06B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:53:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3AD1A456F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:53:01 +0000 (UTC)
X-FDA: 85175162562.24.A8F7A6E
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4847C16000D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:52:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GXFyrjGY;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788504780;
	b=ppWRdEy4YLVqmIuohviny6tbDc9WEVwiKfA1eMLSYUmW9nO8WU4+mfmMQ9+z/GTL1cqrhf
	aoHjK0n3jXU978L5H/yadozRie768Q0DErdjNkTvmvN0ijOdyUhHbQIsn7EIjQKspWyh0Z
	KLcjNRIVj9L9xe2w48cjuJujKdW1c8M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788504780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bwsx8xw1uGSa604nTul98ImcISUH3wPbbepzNoJwis=;
	b=voKTf0o1vYauKX7lyeV5f/UzxlJvz0Tt6zrvE1ml8K0xOLTNtgovNaVTNNDqmlIbY24G3p
	WzpWekGFBEbFEVybN1xDAzykNPsXIBRoj5CXTpOyvt587/vw42kYcUoGIEvVNykkhTiSW0
	BPCJTlz1rqd/1f1lggFsH81DtQLPgB0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GXFyrjGY;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788504771; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=4bwsx8xw1uGSa604nTul98ImcISUH3wPbbepzNoJwis=;
 b=GXFyrjGYuyXi5uSSzzXrQI8CxNNPFtrUNHiwu6DjgR+hLMqR1PNMT6QPIyRDmz1Or4hLaF
 TVx3oTbjGH63k36L0x/hjwxrlBICSFMktXYj4eZJllEIUkAhD9556HRzsn6j0wtUj7aEv7
 3D5rqHpId493sSi/Cs91AESDbEnFuHbep/oQGyGevBhJHQoF2Sm6Dg8Hbtx5fMvlaYLAaW
 M2socuZmq5JTapJMmbp1WSrKTt+UzUCPNFtbfi/BPZzu2tp0gTvMQAVz00x2G+aYD05LWC
 jfx6W5AMH/bai8cNHLKdFgUsw2hUq2+WaIDlqhwNZNqQhk/+hEdq187lbLwUZg==
Message-Id: <20260904065159.34409-2-lizhe.67@bytedance.com>
In-Reply-To: <20260904065159.34409-1-lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC 1/2] mm: add goal=evict to memory.reclaim
Date: Fri,  4 Sep 2026 14:51:58 +0800
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a9a6ac1+f44d94+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260904065159.34409-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <qi.zheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4847C16000D
X-Stat-Signature: wxpstxfzha3scnpyqfxzbmbttupxnrqh
X-HE-Tag: 1788504779-527496
X-HE-Meta: U2FsdGVkX1+79ndaLlLhiG0VZjpWXqfUMDBy6X9cua/px0v5cEHcweua7VTQQwoqo4jJdxIyTi/NKpNy7OiFkG3AMw72GqfcVCudwfmjA8TME2ZFxtljI/tZcZqIbTH/pquVqkt9VHb8+eRsLGpfufoz9BjoXtXL0JD4sV4nNoEhbB8twTIzeGvTv0LHo2shJElE/3rL87PbxxZpe7fprHE/b81pGR3ycvzLDiUuitVyYniJ1nPk8JP44JoeKwrZNv/N8ZaN+Z5sj312cYyGGBcZ8ZCcngS10TO5e9n5IFhfmwnHM2mZ6wU0uZb5PhdkHe372eNGpfEIAobWGRnN7UI2LiNeQdED4tzgekhGMM4ovTYcxEvQbm2VtFBfQrotVsylAc6tQS8Lh+CKtCWpw8/1Xd8HPvAX2bD7Nu0mHnuohFaEIfTYtlXBKnXpoa03dOyXilQYaekcL2wTjxrezalAV5gmCGZ7Rg3soBXJmCdJDjXWjcwvM601nVayzH8Qkl7x17AB2AGairC00NXNf7fb/xFl8Rm3jMSnAp9IdeW0VN1X+Z3ZRTsUCqOLVZfYdQ7/9HKDhYRVfLMC1EeS9e3oqrxtFrarh4gVUE5Bb6v0JXPJWYrrS8B+jpqpSV0FKQ/lNg5iKLFgo3zzCkjT4cE1NmzriG/XQoNZxrIStUAy2OlNIuc8cV5gW1Kzgd2+TOyCXUFsTT8Uxw+9ed9iTkLzrE7q8eW36xMx2gfddE0a3WmXYbO/ppCyfFTcD0cPJRjWl/qX2GPK+5fWWsauCbZdJtE5PvSl+0ri3XQ+qi8YjlYDiVALE/+FKvOHezlOaILW4tIeSXCz1b7xETsRPMM++su6vmiG+LnHwoCUn8CZL0x16BEExPksHwPmGvks7/slkuasQxhieVAMXKr7HSpGyWX4o0tw0z4Tfl22lZbE1cftlDfZuviDNPdCKdSpEHzXGPpwNIjKiophwem
 80S5gU+1
 R8/dHkY4B09o1DlL9R8Y4U9a/2Je2l27GZJRJ3lgEOLuqdRYyb8lbuMjARgW/zFaxYdPX468EWVDIWFXvOfNCRte/7fRu5fuVe9ti86iq7UngLWOzy53py4VnifPgeejjJEZHxx6p5hy8tSmILCXRxy0xKSToJ+7RHIpd2o3WmLGY2ivqOFzQHIkDa/b2wGwe1WlqDXDYAbRHgk8Cg1eYYCXoZCBz6E51KFCzmlH4EiMdp2mmAaTXcyrbSrHcevXvroXS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On tiered memory systems, reclaim can demote cold folios from a faster
memory tier to a slower memory tier before they are eventually evicted.
This is part of the aging pipeline: reclaiming directly from a faster
source tier can skip colder folios that have already aged into lower tiers.
Counting demotion as reclaim progress keeps the default memory.reclaim
behavior aligned with that tiered aging model.

However, this makes memory.reclaim completion observably different from
systems without demotion. Without demotion, completing a proactive memcg
reclaim request usually means that the charged footprint was reduced by
eviction. With memory tiering enabled, the same request can complete on
successful demotion alone: folios move to a lower tier, but memory.current
does not drop. Callers that use memory.reclaim to drive memcg footprint
reduction then have to issue repeated short requests to make eviction
progress.

Add goal=evict as an explicit opt-in for eviction-oriented memcg proactive
reclaim. Demotion remains enabled and can still happen as part of reclaim
aging, but successfully demoted folios do not count toward completing the
requested reclaim amount. The default remains goal=progress, preserving
the existing tiered aging behavior and using the existing nr_reclaimed
accounting unchanged. nr_demoted is a subset of nr_reclaimed and is
subtracted only for the evict-goal stop condition.

If the target cgroup has no usable demotion target, treat goal=evict as
goal=progress before reclaim starts. In that case demotion cannot satisfy
the request anyway, so the new key does not need special completion
accounting and reclaim keeps the same behavior as today's memory.reclaim.

goal=evict does not change folio selection or disable demotion. When a
selected folio has an allowed lower-tier target, shrink_folio_list() still
tries to demote it first. The new accounting only prevents those demoted
folios from satisfying an eviction-oriented request by themselves.

The scan limit is deliberately narrow. After an inner reclaim batch has
already demoted at least the batch target, reclaim skips only the top
tier(s) in the cgroup's allowed demotion hierarchy: tiers that can demote
to a lower allowed tier, but are not themselves targets of any higher
allowed tier. Intermediate tiers continue to be scanned so pages already
demoted there can age further downward, and the lowest tier(s) continue
to be scanned so eviction can satisfy the request.

goal=evict is only accepted for memcg memory.reclaim. The per-node
proactive reclaim path uses the same parser, but its reclaim target is a
node capacity target where demotion progress can be the desired outcome.
Reject the new goal key there rather than giving it a different meaning.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  15 ++++
 include/linux/memory-tiers.h            |  13 +++
 mm/internal.h                           |   1 +
 mm/memory-tiers.c                       |  35 +++++++-
 mm/vmscan.c                             | 110 ++++++++++++++++++++++--
 5 files changed, 166 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7c2a8ed80071..ed87d45cfe21 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1448,6 +1448,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  goal                  Reclaim request goal
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1458,6 +1459,20 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	The goal key controls what kind of progress satisfies the requested
+	reclaim amount. The default is goal=progress, which uses the kernel's
+	normal reclaim progress accounting. On tiered memory systems this can
+	include both eviction and demotion progress.
+
+	goal=evict keeps memory tier demotion enabled as part of reclaim aging,
+	but does not count successfully demoted pages toward completing the
+	requested reclaim amount. Demotion may still be performed on the way,
+	but demotion-only progress is not sufficient to satisfy the request.
+	If no demotion target is available to the cgroup, this behaves like
+	goal=progress. This does not select source or target memory tiers and
+	does not disable demotion. This is best-effort and does not bypass memory
+	protection or other reclaim constraints.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629ee..5d869f74deab 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -55,6 +55,7 @@ void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
+void node_get_allowed_sources(pg_data_t *pgdat, nodemask_t *sources);
 bool node_is_toptier(int node);
 #else
 static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
@@ -67,6 +68,12 @@ static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *target
 	*targets = NODE_MASK_NONE;
 }
 
+static inline void node_get_allowed_sources(pg_data_t *pgdat,
+					    nodemask_t *sources)
+{
+	*sources = NODE_MASK_NONE;
+}
+
 static inline bool node_is_toptier(int node)
 {
 	return true;
@@ -111,6 +118,12 @@ static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *target
 	*targets = NODE_MASK_NONE;
 }
 
+static inline void node_get_allowed_sources(pg_data_t *pgdat,
+					    nodemask_t *sources)
+{
+	*sources = NODE_MASK_NONE;
+}
+
 static inline bool node_is_toptier(int node)
 {
 	return true;
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..40cb5900f857 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -74,6 +74,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
+#define MEMCG_RECLAIM_GOAL_EVICT (1 << 3)
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200
 
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..ec0560228b62 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -24,6 +24,8 @@ struct memory_tier {
 	struct device dev;
 	/* All the nodes that are part of all the lower memory tiers. */
 	nodemask_t lower_tier_mask;
+	/* All the nodes that are part of all the higher memory tiers. */
+	nodemask_t higher_tier_mask;
 };
 
 struct demotion_nodes {
@@ -317,6 +319,22 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 	rcu_read_unlock();
 }
 
+void node_get_allowed_sources(pg_data_t *pgdat, nodemask_t *sources)
+{
+	struct memory_tier *memtier;
+
+	/*
+	 * See node_get_allowed_targets() for the lifetime rules.
+	 */
+	rcu_read_lock();
+	memtier = rcu_dereference(pgdat->memtier);
+	if (memtier)
+		*sources = memtier->higher_tier_mask;
+	else
+		*sources = NODE_MASK_NONE;
+	rcu_read_unlock();
+}
+
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
@@ -385,8 +403,10 @@ static void disable_all_demotion_targets(void)
 		 * to access pgda->memtier.
 		 */
 		memtier = __node_get_memory_tier(node);
-		if (memtier)
+		if (memtier) {
 			memtier->lower_tier_mask = NODE_MASK_NONE;
+			memtier->higher_tier_mask = NODE_MASK_NONE;
+		}
 	}
 	/*
 	 * Ensure that the "disable" is visible across the system.
@@ -428,7 +448,7 @@ static void establish_demotion_targets(void)
 	struct demotion_nodes *nd;
 	int target = NUMA_NO_NODE, node;
 	int distance, best_distance;
-	nodemask_t tier_nodes, lower_tier;
+	nodemask_t tier_nodes, lower_tier, higher_tier;
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
@@ -514,6 +534,17 @@ static void establish_demotion_targets(void)
 		memtier->lower_tier_mask = lower_tier;
 	}
 
+	/*
+	 * Build the higher_tier mask for each node collecting node mask from
+	 * all memory tiers above it.
+	 */
+	higher_tier = NODE_MASK_NONE;
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		tier_nodes = get_memtier_nodemask(memtier);
+		memtier->higher_tier_mask = higher_tier;
+		nodes_or(higher_tier, higher_tier, tier_nodes);
+	}
+
 	dump_demotion_targets();
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..cdaab8ad54ac 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -123,6 +123,9 @@ struct scan_control {
 	/* Proactive reclaim invoked by userspace */
 	unsigned int proactive:1;
 
+	/* Eviction-oriented proactive reclaim goal */
+	unsigned int evict_goal:1;
+
 	/*
 	 * Cgroup memory below memory.low is protected as long as we
 	 * don't threaten to OOM. If any cgroup is reclaimed at
@@ -166,9 +169,12 @@ struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
 
-	/* Number of pages freed so far during a call to shrink_zones() */
+	/* Number of pages reclaimed, including demotions */
 	unsigned long nr_reclaimed;
 
+	/* Number of reclaimed pages that were demoted */
+	unsigned long nr_demoted;
+
 	struct {
 		unsigned int dirty;
 		unsigned int congested;
@@ -181,6 +187,17 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+static unsigned long reclaim_progress(struct scan_control *sc)
+{
+	if (!sc->evict_goal)
+		return sc->nr_reclaimed;
+
+	if (WARN_ON_ONCE(sc->nr_demoted > sc->nr_reclaimed))
+		return 0;
+
+	return sc->nr_reclaimed - sc->nr_demoted;
+}
+
 #ifdef ARCH_HAS_PREFETCHW
 #define prefetchw_prev_lru_folio(_folio, _base, _field)			\
 	do {								\
@@ -342,6 +359,53 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
+static bool memcg_has_demotion_target(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (can_demote(nid, NULL, memcg))
+			return true;
+	}
+
+	return false;
+}
+
+static bool memcg_node_is_demotion_target(int target_nid,
+					  struct mem_cgroup *memcg)
+{
+	struct pglist_data *pgdat = NODE_DATA(target_nid);
+	nodemask_t source_mask, target_mask;
+
+	if (!pgdat || !numa_demotion_enabled)
+		return false;
+
+	target_mask = nodemask_of_node(target_nid);
+	mem_cgroup_node_filter_allowed(memcg, &target_mask);
+	if (nodes_empty(target_mask))
+		return false;
+
+	node_get_allowed_sources(pgdat, &source_mask);
+	mem_cgroup_node_filter_allowed(memcg, &source_mask);
+	return !nodes_empty(source_mask);
+}
+
+static bool reclaim_skip_node(pg_data_t *pgdat, struct scan_control *sc)
+{
+	if (!sc->evict_goal || sc->nr_demoted < sc->nr_to_reclaim)
+		return false;
+	if (!can_demote(pgdat->node_id, sc, sc->target_mem_cgroup))
+		return false;
+
+	/*
+	 * Skip tiers that can demote but are not demotion targets from any
+	 * higher tier allowed to the cgroup once this batch's demotion work is
+	 * done. Other tiers keep aging toward lower tiers or eviction.
+	 */
+	return !memcg_node_is_demotion_target(pgdat->node_id,
+					      sc->target_mem_cgroup);
+}
+
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
@@ -1546,6 +1610,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
+	sc->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
@@ -5022,7 +5087,11 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (unlikely(sc->proactive && signal_pending(current)))
 		return true;
 
-	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
+	if (reclaim_progress(sc) >=
+	    max(sc->nr_to_reclaim, compact_gap(sc->order)))
+		return true;
+
+	if (reclaim_skip_node(lruvec_pgdat(lruvec), sc))
 		return true;
 
 	/* check the order to exclude compaction-induced reclaim */
@@ -6228,8 +6297,13 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
+		if (reclaim_skip_node(pgdat, sc)) {
+			mem_cgroup_iter_break(target_memcg, memcg);
+			break;
+		}
+
 		/* If partial walks are allowed, bail once goal is reached */
-		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+		if (partial && reclaim_progress(sc) >= sc->nr_to_reclaim) {
 			mem_cgroup_iter_break(target_memcg, memcg);
 			break;
 		}
@@ -6500,6 +6574,8 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
+		if (reclaim_skip_node(last_pgdat, sc))
+			continue;
 		shrink_node(zone->zone_pgdat, sc);
 	}
 
@@ -6564,7 +6640,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		shrink_zones(zonelist, sc);
 
-		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
+		if (reclaim_progress(sc) >= sc->nr_to_reclaim)
 			break;
 
 		if (sc->compaction_ready)
@@ -6591,8 +6667,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 
 	delayacct_freepages_end();
 
-	if (sc->nr_reclaimed)
-		return sc->nr_reclaimed;
+	if (reclaim_progress(sc))
+		return reclaim_progress(sc);
 
 	/* Aborted reclaim to try compaction? don't OOM, then */
 	if (sc->compaction_ready)
@@ -6872,6 +6948,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.evict_goal = !!(reclaim_options &
+					MEMCG_RECLAIM_GOAL_EVICT),
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -7947,11 +8025,15 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_GOAL_PROGRESS,
+	MEMORY_RECLAIM_GOAL_EVICT,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_GOAL_PROGRESS, "goal=progress"},
+	{ MEMORY_RECLAIM_GOAL_EVICT, "goal=evict"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
@@ -7960,6 +8042,7 @@ int user_proactive_reclaim(char *buf,
 {
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	bool evict_goal = false;
 	int swappiness = -1;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
@@ -7991,11 +8074,24 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_GOAL_PROGRESS:
+			if (!memcg)
+				return -EINVAL;
+			evict_goal = false;
+			break;
+		case MEMORY_RECLAIM_GOAL_EVICT:
+			if (!memcg)
+				return -EINVAL;
+			evict_goal = true;
+			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+	if (nr_to_reclaim && evict_goal && !memcg_has_demotion_target(memcg))
+		evict_goal = false;
+
 	while (nr_reclaimed < nr_to_reclaim) {
 		/* Will converge on zero, but reclaim enforces a minimum */
 		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
@@ -8027,6 +8123,8 @@ int user_proactive_reclaim(char *buf,
 
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
+			if (evict_goal)
+				reclaim_options |= MEMCG_RECLAIM_GOAL_EVICT;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-- 
2.20.1

