Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D32B8CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F1B6B00F3; Fri, 26 Jun 2026 06:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01816B00F4; Fri, 26 Jun 2026 06:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFE46B00F5; Fri, 26 Jun 2026 06:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD6B6B00F3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:14:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB292167522
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:16 +0000 (UTC)
X-FDA: 84921653712.18.07BF549
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id 093A4120003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468855;
	b=tiyGsiNiBBKWowfT/gJXGAwl3CoVSItFx7tu7Yic0s1lija/hucmmK3bGL0nknu3gqlOMy
	BIEK5O8ZC1tONaXhrKbMQBrMCmDqo+QvOBvA5tecElvNpy14/w4sdwj652dl3dg6D433A0
	cg9XUf6601WMNNqTjLVpHi0XZCAfAzo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8xZ5Eg1d8rMU6UALyA13SDN7lD6PBBpM6tye3vIR6eQ=;
	b=dKpC00fsleRXN8dka7sq9Lzxgshof/RXUnET5qMwc9BRMCjkwllcslT5cXJugCEshjNhnH
	ypIixonlaJTs6dyJwhTQZI3nsLDMOz3G5ahKZl5DkakZYKBwAH6iR9WhAsasySMqJK8l0/
	LFMNinzd9PBa+1XFwwhY4iguYXwFFnE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 900CA1FCF0;
	Fri, 26 Jun 2026 10:14:09 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH v2 2/9] memcg: charge kmem pages and slab objects against per-node objcg
Date: Fri, 26 Jun 2026 12:09:29 +0200
Message-ID: <20260626101356.1599643-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626101356.1599643-1-alex@ghiti.fr>
References: <20260626101356.1599643-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTENOVM442mkDl9M7BOuxltKQt2rH08OLXMzqLdhHVnWXMdzNF01vIBStS5Nt4iilqFom901QuMuOF1Pq9t07VEFmuzCqBKDEHbzEAlauPxApG+nWsCnMt7DIs1AYrUJE1sXk7vUU87iB6IwD5JsImN5e9/A90WwduRMgnPXKLGVRrOJB97wbtTbX5BPEM1IF4F+NnAgfDBum8ZtTuGNN2u0mEW4pJ89gvJjUtCv8kzFp2gdioWSRcms4UFBYzWw0CGA0i1fxwBPKq/iqwbV5k5uxwvv85pN9nYRpVEik0e92v04sZgzysdmTkSmvo6Mqwp5rbG3T5ww4TyQK0PsaXiPavXed4NHz5kXSbiT0IMRX//zAt3ztlESCANNdQX5iA3zpNl+nPKm9QaNHFA91cbT4eZj7cIgdkpa4EB1zpCMIKLPYUe61r/ekG9HFSg97ZzJM5ByBCmtv+z7T3VMvy7ifGJohkztBGe4pNelJCB7SXJjm/Y4tyXYzOyieHWTedWKujWKtbI3lLyg59YXQyz1r/a9h+P24HTHskNNlxv1BJ9fYUMQ+gHERBnvT8hv6IsjltCepmiURtxKxbRG5tpHNZP1wqxFiwG7ru1d3jRz9TAeHcEaiVdN29CV4PJAxw+Yk3ZLeTSkSxesw6lijApcerRS1Q9ozIqSAzLj2wmCJg
X-Rspamd-Queue-Id: 093A4120003
X-Stat-Signature: xf78go78pn1wandjjfp4ayfpp1ut8wbf
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782468854-145122
X-HE-Meta: U2FsdGVkX18gPNVqCLJBnNUAenVZmBrgeNtSe14jK6ESQt0KKdDA0Mxm4behKOkqwoeXMuTj2FaxTozqwY9VtL1oA8EOXut7UM8h25Z7S59bUGXe7Yi4oLF4axvdWvj/HyK9Aqz26Vm+UznjVyL+F+j/oqF2YLUkk9a9J+6mF6UJ5OEWIhK/zOcZOQisgEc6/sog4WqexzRjG/lqgmA/tB72YXOC3x+9JEOi8kabc/AzWfgL3TKBTkh2hfBjqScymktypIEKwBIU9pGvfqT+UZ7/a9VFMeXCC3eH7zS556ux+v8LFwg3byDaSJpXfD9VIN/SbKbnPi9JDDUySE367BvQL14EYoWBijSM1SqnERCVn0PIHBi70BS3k09ynLKjZ97xZTnkZRIxGKs9y9xX3yr5ZD1GX0ZJ+GL5rcREp00kq3mDbKWA2Ag/1ytJHXQ/PC5RK+7e0HaK/CRQXRLzGJIVtnfRvZ6UxXpgdUM4/gsPNyGlOwvkE9+eybwgVGtH24bLuW8Rncnv96Ph/tq0kbbPE/ORmoOdGlh9brUwIUA24ce1pEi5vR7YHGIBwc1Mifi8Z21Tcm9xvZvrce+VE5O+gYo2tAMK1LunsabEjx524U6MmJC1DxezDTl7SlDEsjp9DsMVFBUWYKASncxb0W4rDac7UpS29zdHqewspzpBRlQlVvK5SqHRCiieeKC2I3FJOt/Q9LqkNt+8mzuAQ5gdQtYKze98pAydqomGYif69uKKYIv41bL3WceI9+Uqw5fvmJtN2Lw6i3llkL4PWyYElQgCCSTCY5DZMuieGF+M1NG/HzDSAu52PbtGnpN+M2BXo3LppAN0aCTZHe53Y8YgDy8frtAMw4HljCExIkTehQZ6+AGCD/I9ehNDcN/Q4Z6qUOl6Bfm28RNi+fmYCCZBNNLQr6pb5VCVUqhy6RIp5uiXXQ5yxv/DuuXLxM4BTlZFSt0KlROaT+8iQcS
 n4GRYWjs
 Qy4eJQIB2a5sXuyxw6n0ZjxrQwumSg6l4vbMHbLtVD+d7PU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shakeel Butt <shakeel.butt@linux.dev>

After 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") current_obj_cgroup() returns the per-node objcg of the
task's memcg for numa_node_id(). Two callers in the kmem accounting
path always know the actual target node — the page being charged in
__memcg_kmem_charge_page() and each slab being charged in
__memcg_slab_post_alloc_hook() — but were using current_obj_cgroup()
and so charged against an objcg whose nid did not match the
allocation's physical node. The per-objcg vmstat batching (keyed by
objcg->nid) and per-node charge attribution were both routed to the
wrong sibling of the same memcg whenever the allocating CPU's node
differed from the allocation's node.

Factor the per-node objcg lookup into __current_obj_cgroup(int nid)
and keep current_obj_cgroup() as a one-line wrapper that passes
numa_node_id(), preserving all other callers. Use the new helper in:

  - __memcg_kmem_charge_page(): pass page_to_nid(page).
  - __memcg_slab_post_alloc_hook(): re-fetch inside the loop using
    slab_nid(slab) so each slab in a bulk allocation is charged
    against its own node's objcg. The early per-task root/NULL check
    above the loop remains (all per-node objcgs of a memcg share the
    same root-ness, so it is still a valid fast path); the in-loop
    check guards the transient drain window where one node's entry
    may be NULL.

Update the stale slab_pgdat(slab) reference in the TODO comment to
slab_nid(slab); slab_pgdat is no longer relevant after the
obj_stock_pcp cached_pgdat removal.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/memcontrol.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ee47427de9e2..3bcc20e72914 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2987,12 +2987,11 @@ static struct obj_cgroup **current_objcg_update(void)
 	return objcgs;
 }
 
-__always_inline struct obj_cgroup *current_obj_cgroup(void)
+__always_inline static struct obj_cgroup *__current_obj_cgroup(int nid)
 {
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 	struct obj_cgroup **objcgs;
-	int nid = numa_node_id();
 
 	if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi())
 		return NULL;
@@ -3036,6 +3035,11 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 	return rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 }
 
+__always_inline struct obj_cgroup *current_obj_cgroup(void)
+{
+	return __current_obj_cgroup(numa_node_id());
+}
+
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	struct obj_cgroup *objcg;
@@ -3143,7 +3147,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 	struct obj_cgroup *objcg;
 	int ret = 0;
 
-	objcg = current_obj_cgroup();
+	objcg = __current_obj_cgroup(page_to_nid(page));
 	if (objcg && !obj_cgroup_is_root(objcg)) {
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
@@ -3536,7 +3540,9 @@ static inline size_t obj_full_size(struct kmem_cache *s)
 {
 	/*
 	 * For each accounted object there is an extra space which is used
-	 * to store obj_cgroup membership. Charge it too.
+	 * to store obj_cgroup membership. Charge it too. In addition, we
+	 * allocate obj_exts array on the same node as slab_nid(), so per-node
+	 * kmem accounting is fine.
 	 */
 	return s->size + sizeof(struct obj_cgroup *);
 }
@@ -3594,6 +3600,16 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 			continue;
 		}
 
+		/*
+		 * Charge against the per-node objcg matching the slab's node
+		 * so the stock's per-objcg vmstat batch (keyed by objcg->nid)
+		 * aligns with the physical slab. May transiently fall back to
+		 * root if the per-node entry is being drained.
+		 */
+		objcg = __current_obj_cgroup(slab_nid(slab));
+		if (!objcg || obj_cgroup_is_root(objcg))
+			continue;
+
 		/*
 		 * if we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
@@ -3602,7 +3618,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		 * for larger sizes, kmem_cache_free_bulk() will uncharge
 		 * any objects that were already charged and obj_ext assigned
 		 *
-		 * TODO: we could batch this until slab_pgdat(slab) changes
+		 * TODO: we could batch this until slab_nid(slab) changes
 		 * between iterations, with a more complicated undo
 		 */
 		stock = trylock_stock();
-- 
2.54.0


