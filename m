Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 714EAC88E59
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 06:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39B06B0098; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE98C6B008A; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FF16B0098; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE8166B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27A29D3809
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:53:40 +0000 (UTC)
X-FDA: 84373199400.29.BEBEF2A
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2FE5440007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:53:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769410418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N70zZNb4dTx01yi+EkltZClXityE3zuiPz0XqnZBPBQ=;
	b=wpLzL5UJcg8iFuXLYP8SwQ62oQwaqiMvJVIdR4WqRkg2oIgYcLtKTXgUJ3YdvBTVn9ukDl
	KuI+UMBDi5lIbu+yR8BKQ2KtIi1799z8FHI2r8JzjD8gPhS7oj6YeFprwivhu180/1eJ3B
	WN2TbuqXEPzXxEUTHHEoj8uflVbvAy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769410418; a=rsa-sha256;
	cv=none;
	b=yOmMKjknSNXGgG3SRFvPMeumV4fA3keYsLVCCrOZYDW8InUPu0gSnorU/BDfU2m9cpoRUQ
	BR2Uqkgba50sOg6cTbdcj8MQDhHTfnaWICWAQZrRNLQZsp6D4B8v3ZZCTaneKlgdtwAGf5
	720JGuyOT7IGiPfwr1MagfJ+Gp5SsQs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Jan 2026 15:53:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Chris Li <chrisl@kernel.org>,
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
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	austin.kim@lge.com,
	youngjun.park@lge.com
Subject: [RFC PATCH v2 v2 3/5] mm: memcontrol: add interface for swap tier selection
Date: Mon, 26 Jan 2026 15:52:40 +0900
Message-Id: <20260126065242.1221862-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260126065242.1221862-1-youngjun.park@lge.com>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FE5440007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9fcs9cm7dywaua8fpqoaadzrf5dayguu
X-HE-Tag: 1769410417-845304
X-HE-Meta: U2FsdGVkX1/woJde/rcv/3wILUdU/EzmwoGFakLf22AXcmq9QE4TehU6fl1vHvH05sS51j3vh7I28+tIIetDMk/DMYbLDI/o32hCvwVf0LUersHHoJM5Jwp+X8utwUAM3Mg0wr2UtnzWZIoE9lEAjuH37qD3Uq9KFov6I1hQuULBasuMvah7FTmmkJB9JEOdwO3TPPzEXHa7RJKK1nMtINwQgxeTPS3z2XTo6moTtTxEZ7dzOPF/lYO5kEHg3D23hqPD1jWp0OHwPnTAHXE5bsEhM6UaTMKsIFeW8x5Rqlj81ixGlHz8nmVthziNOp6Yx3M5/ynJPS0gmn01fqhxWPICWs8MJ3NQPN8tbaH+xXuwtczArTSzt4m8/nERaSfM5gILlWG9KMNFeb95FUhzZ1KXNrQcHhlVYv55f/1ISPLtZynNrSgDVBU83Sddn/5okM9K++QhVr1ap/X/TqmFUCqFs0QFuS+zpR15AtGgwyH+DbnxVNhfavi5Pi+FX4EuGbfBXxROclX6nq2n7awR+P6jAlVDSubz+a4eqTsyBIzzU59vJigogF3dLsXLJBtSLOkP56J11lfHswaYFWKYgEx5k+Gi4eMN8SajEiseweUB7i41NGD/ZddOJFScz663AX9T+HPVH6+U0lMj3un6kjT3OVf4OTMH/UCzvvvvhmkX4fzSNMEf5s5HlPDsVh6zD1t4uETbLzGBTIKo4OG3R/8AUsnNorQVGVTb8Ix0AmQ+W7ONfBzOgpIrMTcENO0EGRugmEFfMN/A5V5OFBs8iWsqW4mX10qVD3O2G7dCkYzxlyRkYZtGq0rO4XYce5ZXFG40nDM5wPKiihqZkm1a4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch integrates the swap tier infrastructure with cgroup,
enabling the selection of specific swap devices per cgroup by
configuring allowed swap tiers.

The new `memory.swap.tiers` interface controls allowed swap tiers via a mask.
By default, the mask is set to include all tiers, allowing specific tiers to
be excluded or restored. Note that effective tiers are calculated separately
using a dedicated mask to respect the cgroup hierarchy. Consequently,
configured tiers may differ from effective ones, as they must be a subset
of the parent's.

Note that cgroups do not pin swap tiers. This is similar to the
`cpuset` controller, which does not prevent CPU hotplug. This
approach ensures flexibility by allowing tier configuration changes
regardless of cgroup usage.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 27 +++++++++
 include/linux/memcontrol.h              |  3 +-
 mm/memcontrol.c                         | 80 +++++++++++++++++++++++++
 mm/swap_tier.c                          | 66 ++++++++++++++++++++
 mm/swap_tier.h                          | 21 +++++++
 mm/swapfile.c                           |  5 ++
 6 files changed, 201 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7f5b59d95fce..776a908ce1b9 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1848,6 +1848,33 @@ The following nested keys are defined.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+  memory.swap.tiers
+        A read-write nested-keyed file which exists on non-root
+        cgroups. The default is to enable all tiers.
+
+        This interface allows selecting which swap tiers a cgroup can
+        use for swapping out memory.
+
+        The effective tiers are inherited from the parent. Only tiers
+        effective in the parent can be effective in the child. However,
+        the child can explicitly disable tiers allowed by the parent.
+
+        When read, the file shows two lines:
+          - The first line shows the operation string that was
+            written to this file.
+          - The second line shows the effective operation after
+            merging with parent settings.
+
+        When writing, the format is:
+          (+/-)(TIER_NAME) (+/-)(TIER_NAME) ...
+
+        Valid tier names are those configured in
+        /sys/kernel/mm/swap/tiers.
+
+        Each tier can be prefixed with:
+          +    Enable this tier
+          -    Disable this tier
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
index 007413a53b45..c0a0a957a630 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "swap_tier.h"
 
 #include <linux/uaccess.h>
 
@@ -3691,6 +3692,7 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
+	swap_tiers_memcg_sync_mask(memcg);
 	__mem_cgroup_free(memcg);
 }
 
@@ -3792,6 +3794,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	WRITE_ONCE(memcg->zswap_writeback, true);
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+	memcg->tier_mask = TIER_ALL_MASK;
+	swap_tiers_memcg_inherit_mask(memcg, parent);
+
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 
@@ -5352,6 +5357,75 @@ static int swap_events_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int swap_tier_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, memcg->tier_mask);
+	swap_tiers_mask_show(m, memcg->tier_effective_mask);
+
+	return 0;
+}
+
+static ssize_t swap_tier_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	char *pos, *token;
+	int ret = 0;
+
+	pos = strstrip(buf);
+
+	spin_lock(&swap_tier_lock);
+	if (!*pos) {
+		memcg->tier_mask = TIER_ALL_MASK;
+		goto sync;
+	}
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
+	__swap_tiers_memcg_sync_mask(memcg);
+err:
+	spin_unlock(&swap_tier_lock);
+	return ret ? ret : nbytes;
+}
+
 static struct cftype swap_files[] = {
 	{
 		.name = "swap.current",
@@ -5384,6 +5458,12 @@ static struct cftype swap_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
 		.seq_show = swap_events_show,
 	},
+	{
+		.name = "swap.tiers",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_tier_show,
+		.write = swap_tier_write,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index d90f6eccb908..e860c87292e2 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -384,3 +384,69 @@ bool swap_tiers_update(void)
 
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
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent)
+{
+	spin_lock(&swap_tier_lock);
+	__swap_tier_memcg_inherit_mask(memcg, parent);
+	spin_unlock(&swap_tier_lock);
+}
+
+void __swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *child;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	if (memcg == root_mem_cgroup)
+		return;
+
+	for_each_mem_cgroup_tree(child, memcg)
+		__swap_tier_memcg_inherit_mask(child, parent_mem_cgroup(child));
+}
+
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg)
+{
+	spin_lock(&swap_tier_lock);
+	memcg->tier_mask = TIER_ALL_MASK;
+	__swap_tiers_memcg_sync_mask(memcg);
+	spin_unlock(&swap_tier_lock);
+}
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index de81d540e3b5..8652a7f993ab 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -46,4 +46,25 @@ bool swap_tiers_update(void);
 /* Tier assignment */
 void swap_tiers_assign_dev(struct swap_info_struct *swp);
 
+/* Memcg related functions */
+void swap_tiers_mask_show(struct seq_file *m, int mask);
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent);
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg);
+void __swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg);
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
 #endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4f8ce021c5bd..dd97e850ea2c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1348,10 +1348,15 @@ static bool swap_alloc_fast(struct folio *folio)
 static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	int mask = folio_memcg(folio) ?
+		folio_memcg(folio)->tier_effective_mask : TIER_ALL_MASK;
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
-- 
2.34.1


