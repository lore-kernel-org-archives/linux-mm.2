Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B157D606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02066B05BC; Tue,  3 Nov 2026 07:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD92B6B05BD; Tue,  3 Nov 2026 07:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14F76B05BE; Tue,  3 Nov 2026 07:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 788606B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:29:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 002AB160389
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:55 +0000 (UTC)
X-FDA: 85393739550.20.49A8711
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1442B40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="BBrNWs3/";
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikdsUf5143hpiDaILAuysJHFLeRnHTQHDNJjwBmFwLY=;
	b=zKJnOp9Ske7173ezoY+m0zV6lnby2DhIlQU0CPwtCcUmXAhelf9SUL+/3/PQBQyXhqfZyW
	mSEdcxiGCRpii0pVHek10N0UVsqx8VAiMS0WyFIMgLQlFyT6L9ULC7w+7b1a21GufoHbT9
	ph5bPf/WldfxOVWq5x3zF5V91Bp7r8s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708994;
	b=wkxEco5ao7UIT2GKqhR7vHVConKhduqvjzOGKXqZIkTFFeWh4DaFpwwg7v+gb0vFXMiHo/
	H232raOVQuFP8wX0SPrW6F+lUjU36dRJKbiwKmp+o0flJB9HgSREBTfgmYudifFKLjP1z7
	In6wqlsNjUjjkGwVgjzNykmJqPk2JI0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="BBrNWs3/";
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793708983; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ikdsUf5143hpiDaILAuysJHFLeRnHTQHDNJjwBmFwLY=;
 b=BBrNWs3/gz8szEJoKNfnRRDZFTzpsfBmk33UQk0FFlGPSJ3xUEbx3x35XCl17IxWpgNI5d
 XK4hvYrC3TWoucupfpWDtjMFMZwn6Na+Cq//MDIMuOlxR2A63HudmbQvUBUS2luuhmMLdd
 jC1S+JyCvGaD/Mqrbn0Ayrepv5kpQv60bRf8pSmszvlMRnPo6+SqR063M2RCHuMPIzaAgV
 RcFkOmOtlO4YFM1MEjOmn8fEN7yBXFpJ1ZArDMZmJKAMBr5pkqWa9Jd33jIFt3QRLYEoum
 DvJY52y6TQfh9XVs9B9QGNV/M6EdPqyIinX/zvxBhQkpwUcNnBrm3xbGtNg8SQ==
Message-Id: <20261103122816.48037-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Subject: [PATCH 2/3] mm/mempolicy: add cgroup weighted interleave plumbing
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Date: Tue,  3 Nov 2026 20:28:15 +0800
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae9d3b5+ee5f3f+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: z5tc95wosmq4b914r9nebs5sgmxeh3fs
X-Rspamd-Queue-Id: 1442B40004
X-Rspam-User: 
X-HE-Tag: 1793708993-201994
X-HE-Meta: U2FsdGVkX19uN+WOGuABD9WoOyHYS30DVBr3OkIS9Aw3rGVuPkW0ALgTV1v9B+RGmnd0S5oOddvhXXHHzyi//P/laAuFXnduhkNNAl7Yq7J40McBgOafrESEpGkxND3EBjEN16sMkk2r+Apw2mFUzpHk6OxCo/gPNUT2Or1Rp+jL7syR3qdaQZKtarU/ekCw1sNVc3sieUkZA7cX+ZWR+hUTAK55KpSGAgBfFo1EXRECd5DqUGpnqr02UfeRa2P0GShhcNQXa3TIT9FJffQvyWT2YfMU+nIbi0BeeRagvcGwTYTrn8WVRCAzZRC0r12Lme7/7yF6m1nPPoW1R9rKldpqBNDRBQpBYH7oUBbvA6CTPrDLe5iJCF1+91hGnIT8jzLlHnEBCIrf19Db/CsqjZZ9NUMSDCrYjo7YboJpqog2RXzoZuFfHmzXynqAHDq9IdF73z8Df25cb+qiU7sUk6wTfojlH27BAiyCs53ZBfMQp139e+OV72c1qvVTlPR8ON0tiHt8ZSZ6x6o2SVVjLF64BrN3IcAuCyNAKRWRUQcgfTeV+sZxJh+iBTMiAd7mnVjygqaccuyDeV/ItpRVN9mwqVNYAtiOZzEr0PXfO3U74TyEiA1s10wOyuk6ojnR1TtgAD01AQmurEtXhw16BW9iytpzqOsarlrhWDFluwwnCRGjZgNxUbLmENxAHrSs76vQt/LA8TdSt992Ail+zbhrncFEUUkbuqzsqlHJQF/+BdtdSVDc5lLn4DrcLhIP21LsVb3GeF5gIGUa8wU0Dlq7Inz+FDwxOOkxUzQVPxlErFOADCZ3QaVpi6x67bzOOZultATUAptyULQUII68slxg17xWS9dimbD3GK1D5qtgwkzjxDAz4vuyD15rM1dkluqOWZidkM4EfcRgbE/rd5MoXT/hZxN+Z9B0H/TunsJgVjA6zdzz0+9MwgufOz1DKheQ27ZHrxoxh31sCuJ
 oIDewMdF
 Bna80DpcQbW5rr7tla3JZ+qDNe239ZIw1rBa5ozmU1zMaiQVAlZjlbjyQgjmHmAnsIG8b6NMSz0ajL1ff8G/87VrB5TCburoHiasuqv1IusVBmC85aZO3sEy8ajMQhxQmQzbAGvIuzpbZW3uE7AeOgtuoU+sC8FcmnpgiYHWrYlPxMUlPkNv86wL1ebmywdepZtx7dwQLWg67OpxbwVjlAuBDTbSTnhC9mV5e+Vruh99M5umDC3iPxRzuuaCPlbfzalrQDq1HhL48yDMwReCB/Y+yyYVoJGKRVL7h/wZCXj0oKzZHq4P+ys8jqz1a4UtneqkTKi1g0Y4eN1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the kernel-side storage and lookup plumbing for per-cgroup weighted
interleave overrides. Each cgroup stores only an explicit override
table. Cgroups without one inherit the nearest ancestor override and
otherwise use the existing global weighted-interleave state.

The BPF control plane is built through a hidden derived Kconfig symbol,
so it follows the BPF syscall and BTF prerequisites without adding a
user-visible weighted-interleave knob.

Per-task weighted-interleave state continues to cache the current node
and the remaining dynamic weight quota. Weight changes and cgroup
migration are observed when that quota is refilled; the hot allocation
path does not revalidate the cached quota on every allocation.

Bulk weighted-interleave allocations continue to use wi_srcu for
concurrency protection.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/cgroup-defs.h |   5 ++
 include/linux/mempolicy.h   |  10 ++++
 kernel/cgroup/cgroup.c      |   2 +
 mm/Kconfig                  |   6 +++
 mm/mempolicy.c              | 104 ++++++++++++++++++++++++++++++++----
 5 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index cbfe8937647c..2dc1cb7336a5 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -29,6 +29,7 @@ struct cgroup;
 struct cgroup_root;
 struct cgroup_subsys;
 struct cgroup_taskset;
+struct weighted_interleave_state;
 struct kernfs_node;
 struct kernfs_ops;
 struct kernfs_open_file;
@@ -647,6 +648,10 @@ struct cgroup {
 #ifdef CONFIG_EXT_SUB_SCHED
 	struct scx_sched __rcu *scx_sched;
 #endif
+#ifdef CONFIG_BPF_WEIGHTED_INTERLEAVE
+	/* Explicit weighted-interleave override for this cgroup. */
+	struct weighted_interleave_state __rcu *wi_state;
+#endif
 
 	/* All ancestors including self */
 	union {
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2..59bfb272da31 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -16,6 +16,7 @@
 #include <linux/pagemap.h>
 #include <uapi/linux/mempolicy.h>
 
+struct cgroup;
 struct mm_struct;
 
 #define NO_INTERLEAVE_INDEX (-1UL)	/* use task il_prev for interleaving */
@@ -304,4 +305,13 @@ static inline bool mpol_is_preferred_many(struct mempolicy *pol)
 }
 
 #endif /* CONFIG_NUMA */
+
+#ifdef CONFIG_BPF_WEIGHTED_INTERLEAVE
+void weighted_interleave_cgroup_free(struct cgroup *cgrp);
+#else
+static inline void weighted_interleave_cgroup_free(struct cgroup *cgrp)
+{
+}
+#endif
+
 #endif
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a284225f8dc9..705bb2e85571 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -35,6 +35,7 @@
 #include <linux/magic.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
+#include <linux/mempolicy.h>
 #include <linux/pagemap.h>
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
@@ -5733,6 +5734,7 @@ static void css_free_rwork_fn(struct work_struct *work)
 			cgroup1_pidlist_destroy_all(cgrp);
 		cancel_work_sync(&cgrp->release_agent_work);
 		bpf_cgrp_storage_free(cgrp);
+		weighted_interleave_cgroup_free(cgrp);
 
 		if (cgroup_parent(cgrp)) {
 			/*
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..43190060f25f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1530,6 +1530,12 @@ config ARCH_HAS_PTDUMP
 config PTDUMP
 	bool
 
+config BPF_WEIGHTED_INTERLEAVE
+	def_bool y
+	depends on NUMA
+	depends on CGROUPS
+	depends on BPF_SYSCALL
+	depends on DEBUG_INFO_BTF
 
 source "mm/damon/Kconfig"
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index fb9962302664..751a5e90a4e1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -96,6 +96,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/compat.h>
+#include <linux/cgroup.h>
 #include <linux/ptrace.h>
 #include <linux/swap.h>
 #include <linux/seq_file.h>
@@ -112,6 +113,7 @@
 #include <linux/printk.h>
 #include <linux/leafops.h>
 #include <linux/gcd.h>
+#include <linux/jump_label.h>
 #include <linux/srcu.h>
 
 #include <asm/tlbflush.h>
@@ -170,6 +172,11 @@ static unsigned int *node_bw_table;
  */
 static DEFINE_MUTEX(wi_state_lock);
 
+#ifdef CONFIG_BPF_WEIGHTED_INTERLEAVE
+static DEFINE_STATIC_KEY_FALSE(wi_cgroup_weights_set);
+static DEFINE_MUTEX(wi_cgroup_lock);
+#endif
+
 /* Readers that sleep while walking iw_table hold this instead */
 DEFINE_STATIC_SRCU_FAST(wi_srcu);
 
@@ -212,18 +219,90 @@ static void wi_state_init_from(struct weighted_interleave_state *dst,
 }
 #endif
 
-static u8 get_il_weight(int node)
+static inline u8 wi_state_weight(const struct weighted_interleave_state *state,
+				 int node)
+{
+	return state ? state->iw_table[node] : 1;
+}
+
+#ifdef CONFIG_BPF_WEIGHTED_INTERLEAVE
+static struct weighted_interleave_state *wi_cgroup_state_rcu(struct cgroup *cgrp)
+{
+	struct weighted_interleave_state *state;
+
+	for (; cgrp; cgrp = cgroup_parent(cgrp)) {
+		state = rcu_dereference(cgrp->wi_state);
+		if (state)
+			return state;
+	}
+	return NULL;
+}
+
+static struct weighted_interleave_state *wi_task_state_rcu(void)
+{
+	if (static_branch_unlikely(&wi_cgroup_weights_set) && in_task())
+		return wi_cgroup_state_rcu(task_dfl_cgroup(current));
+	return NULL;
+}
+
+void weighted_interleave_cgroup_free(struct cgroup *cgrp)
+{
+	struct weighted_interleave_state *old_wi_state;
+
+	mutex_lock(&wi_cgroup_lock);
+	old_wi_state = rcu_dereference_protected(cgrp->wi_state,
+						 lockdep_is_held(&wi_cgroup_lock));
+	if (old_wi_state) {
+		rcu_assign_pointer(cgrp->wi_state, NULL);
+		static_branch_dec(&wi_cgroup_weights_set);
+	}
+	mutex_unlock(&wi_cgroup_lock);
+
+	wi_state_retire(old_wi_state);
+}
+#else
+static struct weighted_interleave_state *wi_task_state_rcu(void)
+{
+	return NULL;
+}
+
+#endif
+
+static struct weighted_interleave_state *wi_effective_state_rcu(void)
+{
+	struct weighted_interleave_state *state;
+
+	state = wi_task_state_rcu();
+	if (state)
+		return state;
+	return rcu_dereference(wi_state);
+}
+
+static u8 get_effective_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
-	u8 weight = 1;
+	u8 weight;
+
+	rcu_read_lock();
+	state = wi_effective_state_rcu();
+	weight = wi_state_weight(state, node);
+	rcu_read_unlock();
+	return weight;
+}
+
+#ifdef CONFIG_SYSFS
+static u8 get_global_il_weight(int node)
+{
+	struct weighted_interleave_state *state;
+	u8 weight;
 
 	rcu_read_lock();
 	state = rcu_dereference(wi_state);
-	if (state)
-		weight = state->iw_table[node];
+	weight = wi_state_weight(state, node);
 	rcu_read_unlock();
 	return weight;
 }
+#endif
 
 /*
  * Convert bandwidth values into weighted interleave weights.
@@ -2144,7 +2223,7 @@ static unsigned int weighted_interleave_nodes(struct mempolicy *policy)
 		if (node == MAX_NUMNODES)
 			return node;
 		current->il_prev = node;
-		current->il_weight = get_il_weight(node);
+		current->il_weight = get_effective_il_weight(node);
 	}
 	current->il_weight--;
 	return node;
@@ -2228,8 +2307,8 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 
 	rcu_read_lock();
 
-	state = rcu_dereference(wi_state);
-	/* Uninitialized wi_state means we should assume all weights are 1 */
+	state = wi_effective_state_rcu();
+	/* Uninitialized effective state means we should assume all weights are 1 */
 	if (state)
 		table = state->iw_table;
 
@@ -2734,10 +2813,15 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	me->il_weight = 0;
 	prev_node = node;
 
-	/* The page allocator may sleep, pin the weight table with SRCU */
+	/*
+	 * The page allocator may sleep. Pin the selected weight table with
+	 * SRCU, but choose the task/cgroup effective table under RCU.
+	 */
 	scp = srcu_read_lock_fast(&wi_srcu);
-	state = srcu_dereference(wi_state, &wi_srcu);
+	rcu_read_lock();
+	state = wi_effective_state_rcu();
 	table = state ? state->iw_table : NULL;
+	rcu_read_unlock();
 
 	/* calculate total, detect system default usage */
 	for_each_node_mask(node, pol->nodes)
@@ -3683,7 +3767,7 @@ static ssize_t node_show(struct kobject *kobj, struct kobj_attribute *attr,
 	u8 weight;
 
 	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
-	weight = get_il_weight(node_attr->nid);
+	weight = get_global_il_weight(node_attr->nid);
 	return sysfs_emit(buf, "%d\n", weight);
 }
 
-- 
2.20.1

