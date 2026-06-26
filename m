Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE28CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550616B0105; Fri, 26 Jun 2026 06:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501166B0106; Fri, 26 Jun 2026 06:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB2A6B0107; Fri, 26 Jun 2026 06:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 094EA6B0105
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:26:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E32E1203EF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:26:29 +0000 (UTC)
X-FDA: 84921684498.07.5AF9013
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9C3554000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:26:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469587;
	b=7hHToksAUiT8Q8rpkeGboYC/2pmra/39QFn6QuY1etz0QVKPHv0LN5uMnYyhkU5NyZgZZa
	HuBzQhXBFYodvbAm6M6gFOS8BQMbeG7deLsm7iIA0y2ferprkKHmmvQ4kv+1fohMZRurtb
	R46UZgjLuq0IE2n+b24rF5vaIgWC5Ws=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8xZ5Eg1d8rMU6UALyA13SDN7lD6PBBpM6tye3vIR6eQ=;
	b=v9gCb6FSsCsSQOlxMjjf+o4pLBjXGhzXx7lkChuu1kAvmXMbeGrJNkYQyrxFxppueXD8MM
	MlAHs9y+38R6i/pfzzMhuX6LHZXWn6bbs5+yoBgIFHVUGEWfYeVoxkos78t9bRMTzHVvj+
	zosjAoUjJUZZU+5E2FM0ggnhDLX1T78=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id CDD153EBFE;
	Fri, 26 Jun 2026 10:26:18 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
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
Subject: [PATCH v2 2/9] memcg: charge kmem pages and slab objects against per-node objcg
Date: Fri, 26 Jun 2026 12:20:51 +0200
Message-ID: <20260626102358.1603618-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTFilqhOMXToAz/+gNdVKTxHRLavAczJtQ6fU64KH+lF2vkD6tw/iDgQXjhpHB5KEzd/dhU0FR5U7NLGKc+kze3Yd4z5yM7SzW2g38NVzcUbh7Bi280+j7Pwgwze/T7Xezbi0avOoCHg9Agp2B4VsPEZg0Pe+zE3KqBIKbVVfO+pPA7VF068h8hAVGLigEAJqQMAfxAXDxSQRnN6HLgy0sV9WDEI5cElrhqcUCInbpyl2UnqzXx1Hot7ncShsRn/QOdYuZaK4mX1gbrSnFEPnR0oUjPGEaH2gqxRCqT8ROg5bkk51r5Fi81YBaCKsfO7reIkwe+CYd0WYgge08+VXt0SsWuUNEv510K/mjnT0QlTJ28O3Zly/R3M0IV1u38J0dYc0Whpp1wC66RFwaI8QgLapQl9pScXF87j0GGVBT6JOOnYHNQTIJX22C7Y+s4qVApL52sZ4nJxo6MNDZwxZN8FR3g+iGQ0+uUdwCk5vpa1cvcqhkQdt2sq6CxJle/Q/45BtHu1yWG7zpMwUEoakKF5LMTquEYYbSO4C8RgS8X3ZdJEK+WtBWxlzZtyyW4b2FSzRUgFsmZPSQXw0mMtexoGZ91kfpc+ahiN1PGtfyOcv3lhvrF65v3X5/5wE3uEpHnMLFooDoeeklceAyVsMY04/2i4dY6i7sPaqdhn6ZzgpQ
X-Rspam-User: 
X-Stat-Signature: mrxejxrybr1njnkwofpqby4w9ihiyruh
X-Rspamd-Queue-Id: 9C3554000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782469587-542952
X-HE-Meta: U2FsdGVkX1+I9/11SSEXPWDVxp2TbN7X07AYlKIkcPPKzAJrE6YXYOrWsOUba5vNtQVv0SWASznE3GLFz1i/8xSBdYME2qpMpBRnV2/Sa5kEDQ+XUoDo7LmZQd9soWrUBBjuOPVeTRXtTcZtuyhnhf2Isi6ZQBVU/Ahv0YwD34PysXEszlkak8Cn1vywV97xqRQdKUZkxPQAVSh0aL4sWKKdApyIn+zlPO+SQLlER0hJQGalcxT499GbNxJEjG2EP9naJKp+MJZ9bK+xoug3B71iXY1W7DdaXiTCyQ3dtS7AHMeD6vHAiLA9SDr46vQS09J8U/rOiL/eat/O2Vi4zvDWoqvsOEJXaM2xfKoLFu20oQDqi8s9TfKe+t6bK0I+wobscdpxbdx4lwKCEtdQb/5dCJFL8YZgBrhOLKux2yZZl5N08gYqb3kagnXM80nlIfxeEOb6FFnnhFJQAKMV0m7jnFesUL6inKaF1jpDzLVhd1bqDhSRyL37OYR2xrAFGFVeTn/gNBVlXDSzMDValTWlNlwKzOFaaqKqq6eem1faA9OYTCNH26py5hUz3DhU1vRcbSSYv4NEebk9qMRZqAJWqeWclsf2UD6jO+tJh8hSfsnOagat/bkKYRPYrte1LXAbhMFSnx+QJdViIAUUSUGuvEZbVFjZw1uMkQ48ysFqm3odqvho6khLHqRuVT318JYrkoFCown+66voW8ycW9wlnWtFxXhjVAdRjursvi1uaGUwKE9cqESim7ncRk5e2GNQ+5MNz89BZ0rsrzSBcFrYyFsoAOWgLbm26QgICKHVXVbBbjQj6Yk9HjJXCtpkaCHDcDJJ3AlDnIDOd2yoZ22pedvDmAwhTQUvCuM4r3qX2bvdBWSJTAlrFLMGo7BgE94i3oG6Ftp3StQAsgwTLFTHcB+AEs5LK2G63CGxdPIMOrKzpKySIjXETkw+TwKQjGTE4TzyDzNqVNyklGv
 j6Yxo0m8
 oSC9hJt0vjxkEyis++FrMTnzF3uNt2r8bx9Qzm2RMIBWG0vM=
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


