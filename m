Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C75AE83847
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8116B0099; Mon, 16 Feb 2026 19:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5046B009B; Mon, 16 Feb 2026 19:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C526B009D; Mon, 16 Feb 2026 19:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C20B76B0099
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:10:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8527016021E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:10:09 +0000 (UTC)
X-FDA: 84452016138.26.8106F22
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60B33C000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:10:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771287008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDwug2zO2DC8qPh0v7rbsLOe5Br2TdpdYqZsFbfkt20=;
	b=yLoVMB6tNhNqqVTqxan544aJ1xV8VOaRFfDXStrmn4d6n5opJSJf21M5AeSBaVA6cqLzN7
	GU7t2jfKrIS8KnhfTUUT+QFmO0r5aOEIMQS6P3P8i0gWOPIGjqZZ8FzaeIDi6aSGSbUMj/
	HT3CMdczk6aGQTzDl1wGmAz8YJ2ZSBY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771287008; a=rsa-sha256;
	cv=none;
	b=V8MsJ+aDrtAbxovf3JijFzTjMiRhien8RpOomnTwqfZdh9w/hJ4VjPQ1oCpf7TB6Ksujen
	yvWpn8gQjgRaYyaOAC8ky3TXsXHJqLe75z7SPR6aci0jDQ46bgx6DFPgDfi+uejw49Z80R
	dox72NKWXKjcaNlIPARrQCogKqEoWks=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Feb 2026 09:10:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	austin.kim@lge.com,
	youngjun.park@lge.com
Subject: [PATCH v4 3/4] mm: memcontrol: add interfaces for swap tier selection
Date: Tue, 17 Feb 2026 09:09:49 +0900
Message-Id: <20260217000950.4015880-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260217000950.4015880-1-youngjun.park@lge.com>
References: <20260217000950.4015880-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: r71stdnq79p1ngd4gkwyg51fsixmizbs
X-Rspam-User: 
X-Rspamd-Queue-Id: 60B33C000C
X-HE-Tag: 1771287007-733209
X-HE-Meta: U2FsdGVkX19gSbsGGyI7u0F2KLgc7AmBp+fTLeTcsYpAcalSKK8sDMYDVqyXu/5UDB707unA8A7PQCK5eAWlv9wWnlojx+UkobPrNM2MSucriSTAVVOlZncoIfKBVDHQvMgndf+HBK5Njhus62QqXgxMB0HFCjMwekKfnptaf1AKeNzpEvzf8S848hzlxjRW+wcvhTSfckB9pse4WuByvsLtKgZrYBxvemBjRcvdRwkRQjYqFsB1GY3Tp1Z95F5TNfx3TclO+mKx4rQ6wWpEnVO+lxZ1qQNRqO8/KYNlFqoEAhN5j+C3uM5XN3RJX/LCdFweu3xtFr4wdNa4ns1KR+bez+BTbsbCwl6Y5cetHYfSnV0RrjZubIGRPrU1E+2Gk4pkYICHe8pAVPW7/ClyUfGBsYVYnBRVb2JXI7m/MKO/YfKPQ7QBU4YE2a86gsA1bjc8nzr5MAYCcNLluQmwFs98cduR6JFpchdqu7ra6d8tn8nbBcTuToyuAezpcrAeyLW62eAbTUKwJLInONnqwx/fUAhqNH2EAhSnhUQb1JU0fH1tOuB4V8kHrcn/dlYkEWPL9IoLYZwxRoPSDxZ2YvzG4cq7Q4D4QmoT8h84Y2Kz4pmm17QUMMrV0NfaMmUGij+7u85h5hzj0T1/XHgqTIyAp8tjw2Ri/feGTI8ur4hdSUPoZWP6kHOa20bQuD1Udv60mtDH/kLs8OUZ/CMUb/PNirfLhrgeLYyVxsPO4SgJCPpHBsb/uApaIbe32+LOIolucXZmG6o6rsWabkXnTaVmf8ln0GnRcjwEL41HE303Pli4bD3Eki9LivUwxpzAWC8lW2B+Mu8oArnHT1nsiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate swap tier infrastructure with cgroup to allow selecting specific
swap devices per cgroup.

Introduce `memory.swap.tiers` for configuring allowed tiers, and
`memory.swap.tiers.effective` for exposing the effective tiers.
The effective tiers are the intersection of the configured tiers and
the parent's effective tiers.

Note that cgroups do not pin swap tiers, similar to `cpuset` and CPU
hotplug, allowing configuration changes regardless of usage.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 27 +++++++
 include/linux/memcontrol.h              |  3 +-
 mm/memcontrol.c                         | 95 +++++++++++++++++++++++++
 mm/swap_state.c                         |  5 +-
 mm/swap_tier.c                          | 93 +++++++++++++++++++++++-
 mm/swap_tier.h                          | 56 +++++++++++++--
 6 files changed, 268 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7f5b59d95fce..fbe96ef3517c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1848,6 +1848,33 @@ The following nested keys are defined.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+  memory.swap.tiers
+        A read-write file which exists on non-root cgroups.
+        Format is similar to cgroup.subtree_control.
+
+        Controls which swap tiers this cgroup is allowed to swap
+        out to. All tiers are enabled by default.
+
+          (-|+)TIER [(-|+)TIER ...]
+
+        "-" disables a tier, "+" re-enables it.
+        Entries are whitespace-delimited.
+
+        Changes here are combined with parent restrictions to
+        compute memory.swap.tiers.effective.
+
+        If a tier is removed from /sys/kernel/mm/swap/tiers,
+        any prior disable for that tier is invalidated.
+
+  memory.swap.tiers.effective
+        A read-only file which exists on non-root cgroups.
+
+        Shows the tiers this cgroup can actually swap out to.
+        This is the intersection of the parent's effective tiers
+        and this cgroup's own memory.swap.tiers configuration.
+        A child cannot enable a tier that is disabled in its
+        parent.
+
   memory.swap.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b6c82c8f73e1..542bee1b5f60 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -283,7 +283,8 @@ struct mem_cgroup {
 	/* per-memcg mm_struct list */
 	struct lru_gen_mm_list mm_list;
 #endif
-
+	int tier_mask;
+	int tier_effective_mask;
 #ifdef CONFIG_MEMCG_V1
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..fa6e2b2355fb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "swap_tier.h"
 
 #include <linux/uaccess.h>
 
@@ -3792,6 +3793,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	WRITE_ONCE(memcg->zswap_writeback, true);
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+	memcg->tier_mask = TIER_ALL_MASK;
+	swap_tiers_memcg_inherit_mask(memcg, parent);
+
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 
@@ -5352,6 +5356,86 @@ static int swap_events_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int swap_tier_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, memcg->tier_mask);
+	return 0;
+}
+
+static ssize_t swap_tier_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	char *pos, *token;
+	int ret = 0;
+	int original_mask;
+
+	pos = strstrip(buf);
+
+	spin_lock(&swap_tier_lock);
+	if (!*pos) {
+		memcg->tier_mask = TIER_ALL_MASK;
+		goto sync;
+	}
+
+	original_mask = memcg->tier_mask;
+
+	while ((token = strsep(&pos, " \t\n")) != NULL) {
+		int mask;
+
+		if (!*token)
+			continue;
+
+		if (token[0] != '-' && token[0] != '+') {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		mask = swap_tiers_mask_lookup(token+1);
+		if (!mask) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		/*
+		 * if child already set, cannot add that tiers for hierarch mismatching.
+		 * parent compatible, child must respect parent selected swap device.
+		 */
+		switch (token[0]) {
+		case '-':
+			memcg->tier_mask &= ~mask;
+			break;
+		case '+':
+			memcg->tier_mask |= mask;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		if (ret)
+			goto err;
+	}
+
+sync:
+	swap_tiers_memcg_sync_mask(memcg);
+err:
+	if (ret)
+		memcg->tier_mask = original_mask;
+	spin_unlock(&swap_tier_lock);
+	return ret ? ret : nbytes;
+}
+
+static int swap_tier_effective_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, memcg->tier_effective_mask);
+	return 0;
+}
+
 static struct cftype swap_files[] = {
 	{
 		.name = "swap.current",
@@ -5384,6 +5468,17 @@ static struct cftype swap_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
 		.seq_show = swap_events_show,
 	},
+	{
+		.name = "swap.tiers",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_tier_show,
+		.write = swap_tier_write,
+	},
+	{
+		.name = "swap.tiers.effective",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_tier_effective_show,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 513d74dc1709..b61ac73d4963 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -961,6 +961,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 	char *p, *token, *name, *tmp;
 	int ret = 0;
 	short prio;
+	int mask = 0;
 
 	tmp = kstrdup(buf, GFP_KERNEL);
 	if (!tmp)
@@ -993,7 +994,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 				goto restore;
 			break;
 		case '-':
-			ret = swap_tiers_remove(token + 1);
+			ret = swap_tiers_remove(token + 1, &mask);
 			if (ret)
 				goto restore;
 			break;
@@ -1003,7 +1004,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_update()) {
+	if (!swap_tiers_update(mask)) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 91aac55d3a8b..64365569b970 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -244,7 +244,7 @@ int swap_tiers_add(const char *name, int prio)
 	return ret;
 }
 
-int swap_tiers_remove(const char *name)
+int swap_tiers_remove(const char *name, int *mask)
 {
 	int ret = 0;
 	struct swap_tier *tier;
@@ -267,6 +267,7 @@ int swap_tiers_remove(const char *name)
 		list_prev_entry(tier, list)->prio = DEF_SWAP_PRIO;
 
 	swap_tier_inactivate(tier);
+	*mask |= TIER_MASK(tier);
 
 	return ret;
 }
@@ -327,7 +328,24 @@ void swap_tiers_assign_dev(struct swap_info_struct *swp)
 	swp->tier_mask = TIER_DEFAULT_MASK;
 }
 
-bool swap_tiers_update(void)
+/*
+ * When a tier is removed, set its bit in every memcg's tier_mask and
+ * tier_effective_mask. This prevents stale tier indices from being
+ * silently filtered out if the same index is reused later.
+ */
+static void swap_tier_memcg_propagate(int mask)
+{
+	struct mem_cgroup *child;
+
+	rcu_read_lock();
+	for_each_mem_cgroup_tree(child, root_mem_cgroup) {
+		child->tier_mask |= mask;
+		child->tier_effective_mask |= mask;
+	}
+	rcu_read_unlock();
+}
+
+bool swap_tiers_update(int mask)
 {
 	struct swap_tier *tier;
 	struct swap_info_struct *swp;
@@ -357,6 +375,77 @@ bool swap_tiers_update(void)
 			break;
 		swap_tiers_assign_dev(swp);
 	}
+	/*
+	 * XXX: Unused tiers default to ON, disabled after next tier added.
+	 * Use removed tier mask to clear settings for removed/re-added tiers.
+	 * (Could hold tier refs, but better to keep cgroup config independent)
+	 */
+	if (mask)
+		swap_tier_memcg_propagate(mask);
 
 	return true;
 }
+
+void swap_tiers_mask_show(struct seq_file *m, int mask)
+{
+	struct swap_tier *tier;
+
+	spin_lock(&swap_tier_lock);
+	for_each_active_tier(tier) {
+		if (mask & TIER_MASK(tier))
+			seq_printf(m, "%s ", tier->name);
+	}
+	spin_unlock(&swap_tier_lock);
+	seq_puts(m, "\n");
+}
+
+int swap_tiers_mask_lookup(const char *name)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	for_each_active_tier(tier) {
+		if (!strcmp(name, tier->name))
+			return TIER_MASK(tier);
+	}
+
+	return 0;
+}
+
+static void __swap_tier_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent)
+{
+	int effective_mask
+		= parent ? parent->tier_effective_mask : TIER_ALL_MASK;
+
+	memcg->tier_effective_mask
+		= effective_mask & memcg->tier_mask;
+}
+
+/* Computes the initial effective mask from the parent's effective mask. */
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent)
+{
+	spin_lock(&swap_tier_lock);
+	rcu_read_lock();
+	__swap_tier_memcg_inherit_mask(memcg, parent);
+	rcu_read_unlock();
+	spin_unlock(&swap_tier_lock);
+}
+
+/*
+ * Called when a memcg's tier_mask is modified. Walks the subtree
+ * and recomputes each descendant's effective mask against its parent.
+ */
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *child;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	rcu_read_lock();
+	for_each_mem_cgroup_tree(child, memcg)
+		__swap_tier_memcg_inherit_mask(child, parent_mem_cgroup(child));
+	rcu_read_unlock();
+}
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index 6f281e95ed81..329c6a4f375f 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -10,21 +10,65 @@ struct swap_info_struct;
 
 extern spinlock_t swap_tier_lock;
 
-#define TIER_ALL_MASK		(~0)
-#define TIER_DEFAULT_IDX	(31)
-#define TIER_DEFAULT_MASK	(1 << TIER_DEFAULT_IDX)
-
 /* Initialization and application */
 void swap_tiers_init(void);
 ssize_t swap_tiers_sysfs_show(char *buf);
 
 int swap_tiers_add(const char *name, int prio);
-int swap_tiers_remove(const char *name);
+int swap_tiers_remove(const char *name, int *mask);
 
 void swap_tiers_snapshot(void);
 void swap_tiers_snapshot_restore(void);
-bool swap_tiers_update(void);
+bool swap_tiers_update(int mask);
 
 /* Tier assignment */
 void swap_tiers_assign_dev(struct swap_info_struct *swp);
+
+#ifdef CONFIG_SWAP
+/* Memcg related functions */
+void swap_tiers_mask_show(struct seq_file *m, int mask);
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent);
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg);
+#else
+static inline void swap_tiers_mask_show(struct seq_file *m, int mask) {}
+static inline void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent) {}
+static inline void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg) {}
+static inline void __swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg) {}
+#endif
+
+/* Mask and tier lookup */
+int swap_tiers_mask_lookup(const char *name);
+
+/**
+ * swap_tiers_mask_test - Check if the tier mask is valid
+ * @tier_mask: The tier mask to check
+ * @mask: The mask to compare against
+ *
+ * Return: true if condition matches, false otherwise
+ */
+static inline bool swap_tiers_mask_test(int tier_mask, int mask)
+{
+	return tier_mask & mask;
+}
+
+#define TIER_ALL_MASK		(~0)
+#define TIER_DEFAULT_IDX	(31)
+#define TIER_DEFAULT_MASK	(1 << TIER_DEFAULT_IDX)
+
+#ifdef CONFIG_MEMCG
+static inline int folio_tier_effective_mask(struct folio *folio)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+
+	return memcg ? memcg->tier_effective_mask : TIER_ALL_MASK;
+}
+#else
+static inline int folio_tier_effective_mask(struct folio *folio)
+{
+	return TIER_ALL_MASK;
+}
+#endif
+
 #endif /* _SWAP_TIER_H */
-- 
2.34.1


