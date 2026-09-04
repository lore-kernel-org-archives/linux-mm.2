Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B197C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E5A6B0096; Fri,  4 Sep 2026 02:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075F86B0098; Fri,  4 Sep 2026 02:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED06E6B0099; Fri,  4 Sep 2026 02:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5E366B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:53:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6344EA0775
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:53:18 +0000 (UTC)
X-FDA: 85175163276.05.7F87314
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf31.hostedemail.com (Postfix) with ESMTP id 78D0E20005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:53:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=V4Y+HsG3;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788504796;
	b=fCfUM7TOrCPY+ItAPzCh36iDntcMbGKMipd3b/Q2t0/N1TaJW/3P3poyAMH1HmSEMN6PpH
	Xf50+GX97M7z5S/fBk7Y4SIDUJpvEg6N1nRTsFh3eU9n7FmZ5IlHNrq91WgAV60dMxD8Lz
	sKLFNn//shWMuDFINX8CyYYNa9Z6yPE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=V4Y+HsG3;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788504796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPTOxwIC+jr/FMV+UNx0z3S+Ti/laXItlILymntanHY=;
	b=U2LR8x3o/QlDnWERUQbCsWCujHqsEzRcqF8wfApMWlFjOe5ZOXIMYycd8SfODyv7fbCWy2
	3APzm5ORcQXDyoz4zE0H5+h+6PkivrhRoQ9D4vltk0G74zxq8EoGOZdKLIR0YmnuSlNFKA
	Wd+cTcJ6448JK8ntJo2tqhV34KgC15M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788504791; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=mPTOxwIC+jr/FMV+UNx0z3S+Ti/laXItlILymntanHY=;
 b=V4Y+HsG3crXlBb3yPWZi6+FSOQbqRRifsFgQD00UAvsT2ypE/oR8tbzsZcEZEgeTBKR7WL
 nSslbtzVrHCnPkgAqPCzeAjTfob+v6hvCwOgHeLS2qjWJhIeYtQIEQgCWmewajlNFOpc8H
 1XspAzr8pS+58eSeqcJc5ftpIzxNflIulcVjLCZCDvetClVkhdUyxjei4bMxyJxBS921F2
 yu3uti6COgl3zTT4mqo3AVXPB+FQXA5qZZ2hgTsyzTcIjz0e+pQ31fkP7x5t1HYgsltgIk
 C02Eqks6kYc+q8oDOumKtLv5cqJKxT4mrt6i45+3vGLU9utSljsiyOwtxHc8YA==
Date: Fri,  4 Sep 2026 14:51:59 +0800
X-Lms-Return-Path: <lba+26a9a6ad5+1c1431+kvack.org+lizhe.67@bytedance.com>
Message-Id: <20260904065159.34409-3-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260904065159.34409-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <qi.zheng@linux.dev>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC 2/2] mm: add goal=demote to memory.reclaim
References: <20260904065159.34409-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 78D0E20005
X-Stat-Signature: g36pnwanccuxo5p4n7whq3s3q8kwoiqi
X-Rspam-User: 
X-HE-Tag: 1788504796-138841
X-HE-Meta: U2FsdGVkX19qCtjv9iEZWQqCnzyrQDfUEF2fjT22t5QaZkn9sCN4x814FDmXdstG0IhnagBAGmDSB00yCpKhPMkAQKtQeSdXSJWMPjSc6MJlq0OUrCzUMetAs0nVq53s8BZaoJi0WGezp2u/sukHF2L6tyQeuBxk0iQtJBnEySlazK0ZMVjTQHnNkM/tix8N8aP18rQTIwRPrYzkbW4nRVPB2RzaMxEXOpprvSE1uAXAP4u55/JW8wCKPOGM9Ah6h6VeC3xYxXn00CX/HIcA7EKapE3G09JNfxJEpA/4ny4XUjvhU7TLlgxdNN7QM4gndGv6lXSL7GyII1+vH8bjiJExfrWXDqqHSC0RRCcWI5O8c/uj26++57R6jCwFiIxGZPAw69bPDpQtft0xHP8jB0hZ2QeJTcHTQPIapXZVepk3FWhbkXAlwXqKl10iTH/PNgDmUk8GHCjkRPNB5B2F7gbdyV9R6pQSFOIA0wVLcm6ZoF+xq2CkFxGmrUuyQUzOLvKQZDh6xJSju6iNMb0DeuHw+7sxdVys3QVcnIvkA4ZFuD0Wse7KcZ83lP2iw9tz83kU8qKYyxC0sW2HXhl1KBoQXMqgEMxwL4pEYyEr5wHUCAi33hQPylTaOKppaPxo68Ux4d+jHen/7fA+Cq3YdhFxHbGNmVCQVJ1PELzcR8N/6DFnqvBY7TpgEu8kPVI0G+fnS+s/6IC5l6S0Sv4K/nlMabNA9127HsaTtS78R23Q1wxiacSRCQfoPi45ZQNzUPS8yVJ/ijMKtw6z90LgEVgTxOxio8CKiTFSFWwG3/LgxCkeZxnia3afq/LeC19rlzHPg0ezR97jblVNA/bFoE4637PdAwUekruKM023erIEfPhgRwyBBLxru6r0cFy1rAc+/UhvrX89UPFu7UF1PBnEI/0kMOaDWT5nMO96tEkR4iutq7XgwK3830qyD/ZhO9PA8GyblcHNJV6p3cf
 Iv5+4gpD
 BkBXJ5mng5aq+DzHde3GMPgmMauD7JCyhFS4PPiF0WAI18HCqmclHRt9yto9UnyB2Aqq1G2Qoeukno+yOOhFwv9wlgr6rudVc8FCW1NhsO5I7lzPWORsvAd68igqr0KOZNzj8DRIYr8RAgbtzrK4IvsotTLiTSYSCfHNT6+9lMiO/yxf+oIcRkUrO3fo1Zn/Y2gKyJZ+DB/xfqsI4lG00eb6mZZmmlxr0KtAS/pJ9Gc5yOkVfCVK6jwYaJB2ZwyTT2VD/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory.reclaim normally runs the reclaim engine with the normal set of
reclaim actions. On tiered memory systems this can age cold folios by
demoting them first, but the same request can continue into eviction when
demotion is unavailable or when lower-tier nodes are scanned. That makes
memory.reclaim unsuitable for callers that want to use the existing
reclaim scanner only to move cold folios from DRAM to CXL. For example,
swappiness=0 biases selection toward file-LRU folios, but it still allows
file cache to be evicted if the request keeps reclaiming after demotion
progress.

Add goal=demote as an explicit memcg memory.reclaim goal for best-effort
tier demotion without LRU folio eviction. Successful demotions count
toward the requested amount. The reclaim walk skips nodes that do not have
demotion targets and keeps folios that are not queued for demotion instead
of reclaiming them. The default remains goal=progress, preserving the
existing behavior.

Fail goal=demote with -EAGAIN before reclaim starts when the target cgroup
has no usable demotion target. The option is valid in that case, but the
requested goal cannot make progress; returning early avoids retrying the
reclaim loop just to discover that every node is skipped.

This is useful for userspace controllers that want to manage top-tier
headroom and maintain a desired DRAM/CXL occupancy ratio according to
application policy and current system state. The controller can
proactively move cold folios to lower tiers and adjust the demotion amount
as workload placement, tier occupancy, bandwidth pressure, and latency
targets change. Demoted folios remain charged to the cgroup, so the goal
is placement control rather than memory.current reduction. It does not
provide strict file-only or target-tier placement; it remains best effort
and subject to reclaim eligibility and demotion target availability.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
 mm/internal.h                           |  1 +
 mm/vmscan.c                             | 48 ++++++++++++++++++++++---
 3 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index ed87d45cfe21..518a3eafe5d9 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1473,6 +1473,17 @@ The following nested keys are defined.
 	does not disable demotion. This is best-effort and does not bypass memory
 	protection or other reclaim constraints.
 
+	goal=demote performs best-effort memory tier demotion for LRU folios:
+	successful demotion counts toward the requested amount, nodes without
+	demotion targets are skipped, and folios that cannot be demoted are kept
+	on the LRU instead of being evicted by this request. Slab shrinking is
+	also skipped, as it cannot contribute demotion progress. Demoted folios
+	remain charged to the cgroup, so this is intended for placement control
+	rather than memory.current reduction. It can be combined with swappiness
+	to use the existing anon/file reclaim balancing, for example
+	swappiness=0 to prefer file-LRU folios. If no demotion target is available
+	to the cgroup, this returns -EAGAIN.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/mm/internal.h b/mm/internal.h
index 40cb5900f857..33d75f6a5c3d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -75,6 +75,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
 #define MEMCG_RECLAIM_GOAL_EVICT (1 << 3)
+#define MEMCG_RECLAIM_GOAL_DEMOTE (1 << 4)
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index cdaab8ad54ac..1a98e83f35c4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -126,6 +126,9 @@ struct scan_control {
 	/* Eviction-oriented proactive reclaim goal */
 	unsigned int evict_goal:1;
 
+	/* Demotion-only proactive reclaim goal */
+	unsigned int demote_goal:1;
+
 	/*
 	 * Cgroup memory below memory.low is protected as long as we
 	 * don't threaten to OOM. If any cgroup is reclaimed at
@@ -189,6 +192,9 @@ struct scan_control {
 
 static unsigned long reclaim_progress(struct scan_control *sc)
 {
+	if (sc->demote_goal)
+		return sc->nr_demoted;
+
 	if (!sc->evict_goal)
 		return sc->nr_reclaimed;
 
@@ -392,6 +398,12 @@ static bool memcg_node_is_demotion_target(int target_nid,
 
 static bool reclaim_skip_node(pg_data_t *pgdat, struct scan_control *sc)
 {
+	if (sc->demote_goal) {
+		if (sc->nr_demoted >= sc->nr_to_reclaim)
+			return true;
+		return !can_demote(pgdat->node_id, sc, sc->target_mem_cgroup);
+	}
+
 	if (!sc->evict_goal || sc->nr_demoted < sc->nr_to_reclaim)
 		return false;
 	if (!can_demote(pgdat->node_id, sc, sc->target_mem_cgroup))
@@ -1316,6 +1328,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			continue;
 		}
 
+		if (sc->demote_goal)
+			goto keep_locked;
+
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
@@ -5185,7 +5200,8 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
+	if (!sc->demote_goal)
+		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, sc->order, memcg, false,
@@ -6288,8 +6304,9 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		shrink_lruvec(lruvec, sc);
 
-		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
-			    sc->priority);
+		if (!sc->demote_goal)
+			shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
+				    sc->priority);
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
@@ -6950,6 +6967,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
 		.evict_goal = !!(reclaim_options &
 					MEMCG_RECLAIM_GOAL_EVICT),
+		.demote_goal = !!(reclaim_options & MEMCG_RECLAIM_GOAL_DEMOTE),
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -8027,6 +8045,7 @@ enum {
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
 	MEMORY_RECLAIM_GOAL_PROGRESS,
 	MEMORY_RECLAIM_GOAL_EVICT,
+	MEMORY_RECLAIM_GOAL_DEMOTE,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
@@ -8034,6 +8053,7 @@ static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
 	{ MEMORY_RECLAIM_GOAL_PROGRESS, "goal=progress"},
 	{ MEMORY_RECLAIM_GOAL_EVICT, "goal=evict"},
+	{ MEMORY_RECLAIM_GOAL_DEMOTE, "goal=demote"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
@@ -8043,6 +8063,7 @@ int user_proactive_reclaim(char *buf,
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	bool evict_goal = false;
+	bool demote_goal = false;
 	int swappiness = -1;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
@@ -8078,19 +8099,34 @@ int user_proactive_reclaim(char *buf,
 			if (!memcg)
 				return -EINVAL;
 			evict_goal = false;
+			demote_goal = false;
 			break;
 		case MEMORY_RECLAIM_GOAL_EVICT:
 			if (!memcg)
 				return -EINVAL;
 			evict_goal = true;
 			break;
+		case MEMORY_RECLAIM_GOAL_DEMOTE:
+			if (!memcg)
+				return -EINVAL;
+			demote_goal = true;
+			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
-	if (nr_to_reclaim && evict_goal && !memcg_has_demotion_target(memcg))
-		evict_goal = false;
+	if (evict_goal && demote_goal)
+		return -EINVAL;
+
+	if (nr_to_reclaim && (evict_goal || demote_goal)) {
+		bool has_demotion_target = memcg_has_demotion_target(memcg);
+
+		if (demote_goal && !has_demotion_target)
+			return -EAGAIN;
+		if (evict_goal && !has_demotion_target)
+			evict_goal = false;
+	}
 
 	while (nr_reclaimed < nr_to_reclaim) {
 		/* Will converge on zero, but reclaim enforces a minimum */
@@ -8125,6 +8161,8 @@ int user_proactive_reclaim(char *buf,
 					  MEMCG_RECLAIM_PROACTIVE;
 			if (evict_goal)
 				reclaim_options |= MEMCG_RECLAIM_GOAL_EVICT;
+			if (demote_goal)
+				reclaim_options |= MEMCG_RECLAIM_GOAL_DEMOTE;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-- 
2.20.1

