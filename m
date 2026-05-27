Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D663CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D966B009B; Wed, 27 May 2026 02:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4506B009E; Wed, 27 May 2026 02:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3796B009F; Wed, 27 May 2026 02:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D39A6B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:38:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F1121A0534
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:38:52 +0000 (UTC)
X-FDA: 84812246904.28.0EF61BE
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id C562E1A0002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:38:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v4gQIHBW1H1F3/1NrzYVDuLUhCG6gmB6p1DKWMMdEzs=;
	b=e8ilLVVaqUL5lmbVzib0KdzsPz7TVkphmJ9sWpsugpVuCQCQvkKluB+Hv8wN51N8p8jRTn
	GaH0jNBZNWmQGsxjcoRG3ytQhkvhdKfdWQ8ll8I3hGQAxwhYU/d+HFiM8hg7VyCPKB8aN9
	Kuh/OKpmsuQQT8CtqA9GX8aYz04Gwro=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863930; a=rsa-sha256;
	cv=none;
	b=L2CpvSW4E77+qhROVyZioLCY0tKyUv834uNONmpeT4w7jNMFNGuqZO5gm6l3H/AeS+OOal
	4Zw3eNhGN9ppT3ZKggtcROFFJ0yjZNNbaN/XwoyZ4/pYdzJHisjAnU3wX8EUYhEI2zOzcP
	qR0HRoUgnr4P9b1XuvFZVE+K4FinhDQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 15:23:47 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v7 3/4] mm: memcontrol: add interfaces for swap tier selection
Date: Wed, 27 May 2026 15:22:46 +0900
Message-Id: <20260527062247.3440692-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527062247.3440692-1-youngjun.park@lge.com>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ff4g8izt4xo8z679ujms55hp3n4csb1x
X-Rspam-User: 
X-Rspamd-Queue-Id: C562E1A0002
X-HE-Tag: 1779863929-106633
X-HE-Meta: U2FsdGVkX1+ZV+9kdy6Fytxg40pk6joiPmYnZup/cO/R6Qhwt3Mj5DAumsAqpONqjXd6kufWZfxOCSHuxQfb1nermwLSyJIEZv+QSso22jz/j9Ci24EFVZcH1QEVHd+jy+t1fuPprsqWKXGCoaOt9/3jFKRjKCy9TD8kCHU4o8vIoJNKu1VN3Cyb3oMzHSUiqMHEY/Qbq+YJZJkFyxVfH9R4F+6wvGuyd4FgQbmd2C7C7uhTdOvHQ3gPCIu/u2OkqQVCC9hZX8heWWgHtGM46aIK71DmUPv7LI4eu6Ogwpd4M0vGMenmy7ARWdIq4r/WZBYZQhP05dpMDyrz2ZwmrH4XV6B9iKwg+gvnXTaDiEGlgmdcU6Do7wRAiEJU8u7IKvPEA6a3C4FjGI56BOHNoVl4xawJpXoU6FHu2AT3aaW3W6rHW89V4NaJgxYLg8Bx/i56ummviVEE2RooVJqt6Ck1ywPx9wDtqBPzYkwNjeqCXosiSTp2646dE9dFcKlq72rDO3zzELbp1yB4TPg9qrEFP7i3lkp6ZfEb4K7Tn2T+uTBarM90uxsZlolHBBU7jOR374HFeAywkQDcQl/NBH35whdShDJ+tRdphsB7TfXzCeN4oHHwlknGHrTcYnB9kTexWOxS0ZwPEUsmivt25Hn/brW9fncL4AyPCj/vl5/jYikeiNagrKXHVZ/T6OLpagtLvIKnDewqXctBBNviPpXDLG8QTMl+KQeoCUgC1OzCkEtpiuejJdo+IW/aeXx1L5ej/cbeSTwv5O4yOtyaNElbpcfi9/VdmRxzNBe7zDtck0iGgMCRuFJY6M3DG5Y2gRrbPRaaBK5GlKTIe79NcKzGt6DIud/pQI3VClTMG/iTXUQW9qFKq2SjSQVyIsq/0RXPrmYdgr9tm0K1qu/khyxDmUyXvOiwe9DxVSac4bDboIGPz2EbuxJ3RZb6sO2ByGSdDLamrI78QzfRmSP
 p7nRhQJO
 MV4m00s6a61ccqbjz+wkeC3yu1XWsd/i9WiQShuelpxqEhOymRZeP1VtCMPOfl7/Fnp/y/6mqBwiGuMfVGFNvrMXnhOeTr/ceoYW1JPcjdkuiv56ld8q1Aykoog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate swap tier infrastructure with cgroup to allow selecting
specific swap devices per cgroup.

Introduce memory.swap.tiers for configuring allowed tiers, and
memory.swap.tiers.effective for exposing the effective tiers.
The effective tiers are the intersection of the configured tiers
and the parent's effective tiers.

Note that cgroups do not pin swap tiers, similar to cpuset and CPU
hotplug, allowing configuration changes regardless of usage.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  29 +++++++
 include/linux/memcontrol.h              |   5 ++
 mm/memcontrol.c                         |  96 +++++++++++++++++++++
 mm/swap_state.c                         |   5 +-
 mm/swap_tier.c                          | 107 +++++++++++++++++++++++-
 mm/swap_tier.h                          |  56 +++++++++++--
 6 files changed, 288 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..08253072a252 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1850,6 +1850,35 @@ The following nested keys are defined.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+  memory.swap.tiers
+        A read-write file which exists on non-root cgroups.
+        Format is similar to cgroup.subtree_control.
+
+        Controls which swap tiers this cgroup is allowed to swap
+        out to. All tiers are enabled by default.
+
+        ::
+
+            (-|+)TIER [(-|+)TIER ...]
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
index bf1a6e131eca..eb33c8e30c9e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -287,6 +287,11 @@ struct mem_cgroup {
 	struct lru_gen_mm_list mm_list;
 #endif
 
+#ifdef CONFIG_SWAP
+	int tier_mask;
+	int tier_effective_mask;
+#endif
+
 #ifdef CONFIG_MEMCG_V1
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e24114a4493a..cbc7a519a24d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "swap_tier.h"
 
 #include <linux/uaccess.h>
 
@@ -4249,6 +4250,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	swap_tiers_memcg_inherit_mask(memcg);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -5791,6 +5794,88 @@ static int swap_events_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int swap_tier_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, READ_ONCE(memcg->tier_mask));
+	return 0;
+}
+
+static ssize_t swap_tier_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	char *pos, *token;
+	int ret = 0;
+	int original_mask = 0;
+
+	pos = strstrip(buf);
+
+	spin_lock(&swap_tier_lock);
+	if (!*pos) {
+		WRITE_ONCE(memcg->tier_mask, TIER_ALL_MASK);
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
+		/*
+		 * tier_mask can be modified independently at each memcg.
+		 * However, the effective mask is restricted to a subset of
+		 * the parent's mask in swap_tiers_memcg_sync_mask().
+		 */
+		switch (token[0]) {
+		case '-':
+			WRITE_ONCE(memcg->tier_mask,
+				   memcg->tier_mask & ~mask);
+			break;
+		case '+':
+			WRITE_ONCE(memcg->tier_mask,
+				   memcg->tier_mask | mask);
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
+		WRITE_ONCE(memcg->tier_mask, original_mask);
+	spin_unlock(&swap_tier_lock);
+	return ret ? ret : nbytes;
+}
+
+static int swap_tier_effective_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, READ_ONCE(memcg->tier_effective_mask));
+	return 0;
+}
+
 static struct cftype swap_files[] = {
 	{
 		.name = "swap.current",
@@ -5823,6 +5908,17 @@ static struct cftype swap_files[] = {
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
index de285b36e31c..2fda6b61e2de 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -1011,6 +1011,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 	char *p, *token, *name, *tmp;
 	int ret = 0;
 	short prio;
+	int mask = 0;
 
 	tmp = kstrdup(buf, GFP_KERNEL);
 	if (!tmp)
@@ -1043,7 +1044,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 				goto restore;
 			break;
 		case '-':
-			ret = swap_tiers_remove(token + 1);
+			ret = swap_tiers_remove(token + 1, &mask);
 			if (ret)
 				goto restore;
 			break;
@@ -1053,7 +1054,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_update()) {
+	if (!swap_tiers_update(mask)) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 6b57cadb3e95..9c180f55a4e9 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -253,7 +253,7 @@ int swap_tiers_add(const char *name, int prio)
 	return ret;
 }
 
-int swap_tiers_remove(const char *name)
+int swap_tiers_remove(const char *name, int *mask)
 {
 	int ret = 0;
 	struct swap_tier *tier;
@@ -276,6 +276,7 @@ int swap_tiers_remove(const char *name)
 		list_prev_entry(tier, list)->prio = DEF_SWAP_PRIO;
 
 	swap_tier_inactivate(tier);
+	*mask |= TIER_MASK(tier);
 
 	return ret;
 }
@@ -344,7 +345,26 @@ void swap_tiers_assign_dev(struct swap_info_struct *swp)
 	swp->tier_mask = TIER_DEFAULT_MASK;
 }
 
-bool swap_tiers_update(void)
+#ifdef CONFIG_MEMCG
+static void swap_tier_memcg_propagate(int mask)
+{
+	struct mem_cgroup *child;
+
+	rcu_read_lock();
+	for_each_mem_cgroup_tree(child, root_mem_cgroup) {
+		WRITE_ONCE(child->tier_mask, child->tier_mask | mask);
+		WRITE_ONCE(child->tier_effective_mask,
+			   child->tier_effective_mask | mask);
+	}
+	rcu_read_unlock();
+}
+#else
+static void swap_tier_memcg_propagate(int mask)
+{
+}
+#endif
+
+bool swap_tiers_update(int mask)
 {
 	struct swap_tier *tier;
 	struct swap_info_struct *swp;
@@ -375,5 +395,88 @@ bool swap_tiers_update(void)
 		swap_tiers_assign_dev(swp);
 	}
 
+	/*
+	 * When a tier is removed, its index (bit position in the mask) becomes
+	 * free for reassignment to a future tier. If a memcg had previously
+	 * disabled this tier (cleared the bit in its swap.tiers file), the
+	 * effective mask would keep that bit clear -- meaning the new tier at
+	 * the same index would be silently unavailable, an invisible cgroup
+	 * constraint left behind by a tier that no longer exists.
+	 *
+	 * To prevent this, OR the removed tier's mask bit into every memcg's
+	 * tier_mask and tier_effective_mask. This resets the bit so the new
+	 * tier is accessible by default; users who want to restrict it must
+	 * explicitly disable it after the tier is re-created.
+	 */
+	if (mask)
+		swap_tier_memcg_propagate(mask);
+
 	return true;
 }
+
+#ifdef CONFIG_MEMCG
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
+	int parent_mask = parent
+		? READ_ONCE(parent->tier_effective_mask)
+		: TIER_ALL_MASK;
+
+	WRITE_ONCE(memcg->tier_effective_mask,
+		   parent_mask & READ_ONCE(memcg->tier_mask));
+}
+
+/* Computes the initial effective mask from the parent's effective mask. */
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg)
+{
+	spin_lock(&swap_tier_lock);
+	rcu_read_lock();
+	memcg->tier_mask = TIER_ALL_MASK;
+	__swap_tier_memcg_inherit_mask(memcg, parent_mem_cgroup(memcg));
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
+#endif
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index 3e355f857363..49433dcaa1ce 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -10,22 +10,66 @@ struct swap_info_struct;
 
 extern spinlock_t swap_tier_lock;
 
-#define TIER_ALL_MASK		(~0)
-#define TIER_DEFAULT_IDX	(31)
-#define TIER_DEFAULT_MASK	(1U << TIER_DEFAULT_IDX)
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
 
+#define TIER_ALL_MASK		(~0)
+#define TIER_DEFAULT_IDX	(31)
+#define TIER_DEFAULT_MASK	(1U << TIER_DEFAULT_IDX)
+
+#if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG)
+/* Memcg related functions */
+void swap_tiers_mask_show(struct seq_file *m, int mask);
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg);
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg);
+int swap_tiers_mask_lookup(const char *name);
+static inline int folio_tier_effective_mask(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	int mask = TIER_ALL_MASK;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (memcg)
+		mask = READ_ONCE(memcg->tier_effective_mask);
+	rcu_read_unlock();
+
+	return mask;
+}
+#else
+static inline void swap_tiers_mask_show(struct seq_file *m, int mask) {}
+static inline void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg) {}
+static inline void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg) {}
+static inline int swap_tiers_mask_lookup(const char *name)
+{
+	return 0;
+}
+static inline int folio_tier_effective_mask(struct folio *folio)
+{
+	return TIER_ALL_MASK;
+}
+#endif
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
 #endif /* _SWAP_TIER_H */
-- 
2.34.1


