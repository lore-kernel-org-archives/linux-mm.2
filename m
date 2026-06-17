Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63FD3CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BBB6B00A6; Wed, 17 Jun 2026 01:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEAD6B00A9; Wed, 17 Jun 2026 01:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDCB6B00AA; Wed, 17 Jun 2026 01:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 317936B00A6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:35:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A68351A032D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:35:01 +0000 (UTC)
X-FDA: 84888290802.10.8A42D45
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4EC380004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:34:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781674500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aAxel8QiDPId2bHblWUcRrTcC1FS7YWBCIYsWreR2iE=;
	b=jSuL0QpjFHcQQNxwtTsZDwpmSxcZO8592MqaSyzWPknGhMMiafRWtG0BMhx00yuJ+Cc+uG
	FpjPPK1V9PCzBUqUNts8UcsfMcI3dILJQHbfqtLGZYlV5ZWJ4pKXrc3ofPTV3JW99Wsh/D
	n97QAHfsjdjDYd8UhuVhqftgWMNunqU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781674500;
	b=pcOQ5tZRF1/6GBcizjcVDoJv24v6JLVBFUx7SczZ2QSLew5e71BSdtbqXBGofS8O+W3qu8
	BylQLCrdT40E40U90yw3CTRMD/C9BdjRkky0ZmoehG9KegKVqUlOh5/q1vZ+nzBKnu0yzQ
	VqaAXFSMu3MH8uleMCg9pQzbzBwKkYs=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Jun 2026 14:34:57 +0900
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
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v8 3/4] mm: memcontrol: add interface for swap tier selection
Date: Wed, 17 Jun 2026 14:34:46 +0900
Message-Id: <20260617053447.2831896-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260617053447.2831896-1-youngjun.park@lge.com>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4EC380004
X-Stat-Signature: 18umw8qt6aghetpaxnccfudgbzw967gw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781674498-742565
X-HE-Meta: U2FsdGVkX18ttmBgUXaxdvnAU0BEipIWdDCMZVpz1dH0GuV/Nh4hCc3Orrljc8hRBpj/KmujlvG+Duqz5KrKYIxDJisKTZHKd2eZMBooTA9N0awnecOhYx863/nMFrLPFyHvvHgtwQZtHuBON0CJ0fgiLK6fv7yV6s0KouhUKzf37GYtAy/DSvm7G2wwqqqkMPRkAwP1hZ2+5K1T6co2UMWLccrlZpQuZ/fCLcf8QIu08fKN0xN92mO81ZzP9mQqm8nX/hp8GIbx0NyVlOaLnCHOpsZGmx7uCauG76Uqf8UAkAJe5DwE3uJVM/maI0cnxyXoGuEMMtEwlbtle+c6QS4rjt9rejTD9uJsv8L91clTRDUXlwgN4hWajbegm3EkuOpm93ROO2FM7JhyPYBJMQek3JHDVh28cKrvjcJ32H+adwJIBqDtOvRmYM8msUiZoWwTCQLDn67XIfzSWjo6Dz7DjYjhBFU04GdS2f6R+A5cNy2C29n3eIQ5lWxqpsktqWFJ9+ZzFmuuHJC9EXKulQ0L3KjM1W5w6Yqq+fzIha0Rgd9SPuBbQZC1TxTeEYbJe21Cx94uaYdfuENMA47AbDA+kgwZqGiYQ6Q2SK4IQK51Jic/f3SH8YdCvdlhsR7k1ZQuzkHab0rb2w0QQ7cRxRTactSkfnWD9yebtyoTZ5nKCvTlrf3Cw8EFvl5CQhdCG9yo5uC6vCzVzMVGrSzo9HFsflOINh0j0ewfQa7R63yfNeskpW/a5nLCe9IR+xBpDUCrGreWp03bx17qT06ta/s+ktQdf68v4cprwj32bTuvSiYS9F95Hyrqi03JZ2eL8X7D6EpVZUnzoBCWMDZLwfJWhVTtKW7E2TNiaoMeeYm+ljRxS72cSCnQP6tKt+5YKTjUkBngGfbKcF5Fi2a5LxpBDjX54FyCDvy6oCUhFz71AM7ch5gaqH9jc7REkQN3/UpxHlKxWIxSAzKBIWF
 nina6jw+
 BlvvVYqNj3pCYuPz1ex0NMxaAqUMYmiQ572r5WoaJHucQ2ICMeL9TAI7mSNofA4Y+5dzXYqE/YWz6VAhS+3pM1XINwe1cqDaVs3cgKU93+pJxL+vxL83U/ibmyqB9mfxNy8BbSJhGJyTlnSsX1qeJ5NLZI59Qw+AgcsFFLwYnJmwtNYyKIiY5sSiqVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce memory.swap.tiers.max, a flat-keyed file listing each
tier defined in /sys/kernel/mm/swap/tiers with its state, "max"
(allowed, the default) or "0" (disabled).  A tier is one bit in the
cgroup's tier mask, so writing "<tier> max" or "<tier> 0" sets or
clears that bit.

Since the current use case lacks amount control, it only supports
"max" (on) and "0" (off). Therefore, it does not track per-tier swap
usage, relying instead on a fast runtime bitmask check.

We maintain both `mask` and `effective_mask`. The `effective_mask` is
strictly bounded by the parent (e.g., if a parent is "0", the child's
effective state is "0" even if its `mask` is "max"). Maintaining this
separately avoids costly cgroup tree traversals to check ancestors at
runtime.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..4843ffcfd110 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1850,6 +1850,26 @@ The following nested keys are defined.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+  memory.swap.tiers.max
+	A read-write flat-keyed file which exists on non-root
+	cgroups.  The default is "max" for every tier.
+
+	Limits the swap tiers this cgroup may swap to.  Tiers are
+	defined globally in /sys/kernel/mm/swap/tiers and listed here,
+	one per line. When read, the values are displayed in descending
+	order of the tiers (highest tier first)::
+
+	  <tier_1> max
+	  <tier_2> 0
+	  ...
+
+	Currently, only "max" and "0" are supported. "max" allows the
+	tier, "0" disables it.  Each write sets a single "<tier> max"
+	or "<tier> 0" pair.
+
+	A child may only narrow what its parent allows. A tier an
+	ancestor disabled stays disabled regardless of the value here.
+
   memory.swap.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
diff --git a/Documentation/mm/swap-tier.rst b/Documentation/mm/swap-tier.rst
index 0fb4a1153a67..addbc495de8c 100644
--- a/Documentation/mm/swap-tier.rst
+++ b/Documentation/mm/swap-tier.rst
@@ -15,6 +15,15 @@ speed to fully utilize this feature. While the current implementation is
 integrated with cgroups, the concept is designed to be extensible for other
 subsystems in the future.
 
+Use case
+---------
+
+Users can perform selective swapping by choosing a swap tier assigned according
+to speed within a cgroup.
+
+For more information on cgroup v2, please refer to
+``Documentation/admin-guide/cgroup-v2.rst``.
+
 Priority Range
 --------------
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..d53826c68562 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -283,6 +283,11 @@ struct mem_cgroup {
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
index 56cd4af08232..63259576792a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "swap_tier.h"
 
 #include <linux/uaccess.h>
 
@@ -4244,6 +4245,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	swap_tiers_memcg_inherit_mask(memcg);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -5785,6 +5788,64 @@ static int swap_events_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int swap_tier_max_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, memcg);
+	return 0;
+}
+
+static ssize_t swap_tier_max_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	char *pos, *name, *val;
+	bool enable;
+	int mask;
+	int ret = 0;
+
+	pos = strstrip(buf);
+	name = strsep(&pos, " \t\n");
+	if (!name || !*name)
+		return -EINVAL;
+	if (pos)
+		pos = skip_spaces(pos);
+	val = strsep(&pos, " \t\n");
+	if (!val || !*val)
+		return -EINVAL;
+	if (pos && *skip_spaces(pos))
+		return -EINVAL;
+
+	if (!strcmp(val, "max"))
+		enable = true;
+	else if (!strcmp(val, "0"))
+		enable = false;
+	else
+		return -EINVAL;
+
+	spin_lock(&swap_tier_lock);
+	mask = swap_tiers_mask_lookup(name);
+	if (!mask) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * tier_mask is set per memcg here; the effective mask is clamped
+	 * to the parent's in swap_tiers_memcg_sync_mask().
+	 */
+	if (enable)
+		WRITE_ONCE(memcg->tier_mask, memcg->tier_mask | mask);
+	else
+		WRITE_ONCE(memcg->tier_mask, memcg->tier_mask & ~mask);
+
+	swap_tiers_memcg_sync_mask(memcg);
+out:
+	spin_unlock(&swap_tier_lock);
+	return ret ? ret : nbytes;
+}
+
 static struct cftype swap_files[] = {
 	{
 		.name = "swap.current",
@@ -5817,6 +5878,12 @@ static struct cftype swap_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
 		.seq_show = swap_events_show,
 	},
+	{
+		.name = "swap.tiers.max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_tier_max_show,
+		.write = swap_tier_max_write,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2f382d4dcbdc..712b225509cc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -1021,6 +1021,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 	char *p, *token, *name, *tmp;
 	int ret = 0;
 	short prio;
+	int mask = 0;
 
 	tmp = kstrdup(buf, GFP_KERNEL);
 	if (!tmp)
@@ -1053,7 +1054,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 				goto restore;
 			break;
 		case '-':
-			ret = swap_tiers_remove(token + 1);
+			ret = swap_tiers_remove(token + 1, &mask);
 			if (ret)
 				goto restore;
 			break;
@@ -1063,7 +1064,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_update()) {
+	if (!swap_tiers_update(mask)) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 6b57cadb3e95..d6f0e1588dd8 100644
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
@@ -375,5 +395,89 @@ bool swap_tiers_update(void)
 		swap_tiers_assign_dev(swp);
 	}
 
+	/*
+	 * When a tier is removed, its index (bit position in the mask) becomes
+	 * free for reassignment to a future tier. If a memcg had previously
+	 * disabled this tier (cleared the bit in its swap.tiers.max file), the
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
+void swap_tiers_mask_show(struct seq_file *m, struct mem_cgroup *memcg)
+{
+	struct swap_tier *tier;
+	int mask;
+
+	spin_lock(&swap_tier_lock);
+	mask = READ_ONCE(memcg->tier_mask);
+
+	for_each_active_tier(tier)
+		seq_printf(m, "%s %s\n", tier->name,
+			   (mask & TIER_MASK(tier)) ? "max" : "0");
+	spin_unlock(&swap_tier_lock);
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
index 3e355f857363..e2f0cf32035b 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -10,22 +10,67 @@ struct swap_info_struct;
 
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
+void swap_tiers_mask_show(struct seq_file *m, struct mem_cgroup *memcg);
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
+static inline void swap_tiers_mask_show(struct seq_file *m,
+	struct mem_cgroup *memcg) {}
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


