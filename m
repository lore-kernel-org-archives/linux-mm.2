Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D463E83844
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D8D6B0096; Mon, 16 Feb 2026 19:10:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0EE6B0099; Mon, 16 Feb 2026 19:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4456B009B; Mon, 16 Feb 2026 19:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 665136B0096
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:10:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD73C8D3BA
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:10:06 +0000 (UTC)
X-FDA: 84452016012.17.603E62C
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id EEF96180004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:10:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771287005; a=rsa-sha256;
	cv=none;
	b=RV8+Rv/QFEY2CUGe/EUv9Lolg2KJH2KiuA358FJHAKnDrCCwsJ4sfiObKpzGcA8uDRfXaZ
	nd7hXFSHt7vnrE4sTWJXz1D+KMknRi/cz1noM2hix56GDe66XN3VARfZLosJ9WpjyY3CAs
	MdBREh0Oqo1tryOWG+JOID3d1bnmUyU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771287005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QkrrO/WWX8OhWUYV43BS+EIxoHv6Dny6p6zRyx2+4iw=;
	b=swZxtWU1COCWl6gc8PXUUiBaTZlYgo8KabgDUhKh5tktUwf+YLWuyzmbE03MhDGCqJ9DkG
	ggwkFOGwq81Fj0hMwFdxbOWd/GuWK4UxVOcdNolwW9TlH+OOcCVuKdSd/c84bWyOuQBbdz
	1deevKngd88mNDUK1wxlrMUD+pPR8cw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Feb 2026 09:09:58 +0900
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
Subject: [PATCH v4 2/4] mm: swap: associate swap devices with tiers
Date: Tue, 17 Feb 2026 09:09:48 +0900
Message-Id: <20260217000950.4015880-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260217000950.4015880-1-youngjun.park@lge.com>
References: <20260217000950.4015880-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EEF96180004
X-Stat-Signature: uafur4zfifgzkrbw17zh3696t5xk6rqi
X-HE-Tag: 1771287000-107319
X-HE-Meta: U2FsdGVkX18YpsExteosKDh4aKirWLx2IOg5OHfmmwmjnsJzdG5tSh30zssWlJVtMeQQjvndFsf66cAeciq9/obtY65X6yeCkMSZ4Y41IONLUUq8zN0oFLn9zqdmkBBL1TAIkmU2N8nyICuCXrDtqLS00H4DytZvEdp2hHAiuDEFjeIisQ6SI6kmR2el03EIrFABkx0VZcywUj5tHJK+JeV3zaPjDbRjJVW46oRoM3/gGPCjS+UgKbsiLYLzfjjHekhA9x742/w0tZd/nxjYtqOQo+yCPBV0kJuSg6LuX68tEC+6ToAMrEbkObYrbjZ88uRS9x14KQjdmnvavWEpj8W9uF3P2Hw8mCsvlD4zgxvVMfjQyj68CxgfAwimpCvFVnV8CUNEa7cXN4Gd+Fb8e9ReSNDn3ehAEllT8ESs1w8PCcFhZ3EHzj4hpT2zIa7wKUvMQAwhhXMX4ygyiQhuXL1ipGJLU8FEQxSU0N0SN+bY4I34UaUFGQMQUykjfkcdZf5nGuvYSKIMquOLP9/i/gerS7mH/eM/CTkjgKsXCr6Xxe58GxlkBcbGdJripz7CYxLX1SQlyWmRUlkIxWBci2V70/xYHh58hy5dq/3oeg94cWk6WMKElrbcEfzJmDUyxVYQV/8aXTRfLzp3Pu9vshKlCkuDoPM0KRf0ikuvK16RAPoa1zbG9Po2aSBDIEOSaGACn/IPNTNadWQY/+80Va6vpmFggOw2da887cC4JS5QVFjFMuEY/dW4l6cvbvdkN5RoafhiIFWHNFMoUqByUkeez2f14mG0U8pRHmo4upOb0NGf4wPeBvjxJtUuvA/afuO7eoq9CaPkBPVzgsQl1O4HxmzqHyxMm90Pa5zVxOkDZwG5ICbeoRmyZ4z7lcvg1B/XPp4BIQDdsPGPb92dYa/OaKH+FNplqfS3alqvx8JdtoIgho+wVRrv/zu+QZNSDuX+Xq8YkjL7+EYWlEs
 Kvw2Iqgt
 XElEZto8JU52lMXU3OHrLnZJDrsz5sf5l0/xIuERZPzUxn7EPTG6cidhvD5QRVHPQuAZ2N5uLCmHrAQ0F8Yr3awBQ24nZZayjR7jecC5+XAanIJTcXqewJJkAG9+aYHIsXQInU96SkOf1HQuIx7FH1FKU3+u/O2zL6Oaen9HYk9xh9d/LTiBDrSVFBQgTIGeUADhDL/o9MP/SUaEdycWSCOvfqJHgM2roV5n+sJkErHH7+qOrFx/fTz+lQmX7rahKgi+oghZ717OwWcOdHxW3VKKPaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch connects swap devices to the swap tier infrastructure,
ensuring that devices are correctly assigned to tiers based on their
priority.

A `tier_mask` is added to identify the tier membership of swap devices.
Although tier-based allocation logic is not yet implemented, this
mapping is necessary to track which tier a device belongs to. Upon
activation, the device is assigned to a tier by matching its priority
against the configured tier ranges.

The infrastructure allows dynamic modification of tiers, such as
splitting or merging ranges. These operations are permitted provided
that the tier assignment of already configured swap devices remains
unchanged.

This patch also adds the documentation for the swap tier feature,
covering the core concepts, sysfs interface usage, and configuration
details.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/mm/swap-tier.rst | 159 +++++++++++++++++++++++++++++++++
 MAINTAINERS                    |   1 +
 include/linux/swap.h           |   1 +
 mm/swap_state.c                |   2 +-
 mm/swap_tier.c                 | 101 ++++++++++++++++++---
 mm/swap_tier.h                 |  12 ++-
 mm/swapfile.c                  |   2 +
 7 files changed, 264 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst

diff --git a/Documentation/mm/swap-tier.rst b/Documentation/mm/swap-tier.rst
new file mode 100644
index 000000000000..7b29b0e4e414
--- /dev/null
+++ b/Documentation/mm/swap-tier.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Chris Li <chrisl@kernel.org> Youngjun Park <youngjun.park@lge.com>
+
+==========
+Swap Tier
+==========
+
+Swap tier is a collection of user-named groups classified by priority ranges.
+It acts as a facilitation layer, allowing users to manage swap devices based
+on their speeds.
+
+Users are encouraged to assign swap device priorities according to device
+speed to fully utilize this feature. While the current implementation is
+integrated with cgroups, the concept is designed to be extensible for other
+subsystems in the future.
+
+Use case
+-------
+
+Users can perform selective swapping by choosing a swap tier assigned according
+to speed within a cgroup.
+
+For more information on cgroup v2, please refer to
+``Documentation/admin-guide/cgroup-v2.rst``.
+
+Priority Range
+--------------
+
+The specified tiers must cover the entire priority range from -1
+(DEF_SWAP_PRIO) to SHRT_MAX.
+
+Consistency
+-----------
+
+Tier consistency is guaranteed with a focus on maximizing flexibility. When a
+swap device is activated within a tier range, the tier covering that device's
+priority is guaranteed not to disappear or change while the device remains
+active. Adding a new tier may split the range of an existing tier, but the
+active device's tier assignment remains unchanged.
+
+However, specifying a tier in a cgroup does not guarantee the tier's existence.
+Consequently, the corresponding tier can disappear at any time.
+
+Configuration Interface
+-----------------------
+
+The swap tiers can be configured via the following interface:
+
+/sys/kernel/mm/swap/tiers
+
+Operations can be performed using the following syntax:
+
+* Add:    ``+"<tiername>":"<start_priority>"``
+* Remove: ``-"<tiername>"``
+
+Tier names must consist of alphanumeric characters and underscores. Multiple
+operations can be provided in a single write, separated by commas (",") or
+whitespace (spaces, tabs, newlines).
+
+When configuring tiers, the specified value represents the **start priority**
+of that tier. The end priority is automatically determined by the start
+priority of the next higher tier. Consequently, adding a tier
+automatically adjusts the ranges of adjacent tiers to ensure continuity.
+
+Examples
+--------
+
+**1. Initialization**
+
+A tier starting at -1 is mandatory to cover the entire priority range up to
+SHRT_MAX. In this example, 'HDD' starts at 50, and 'NET' covers the remaining
+lower range starting from -1.
+
+::
+
+    # echo "+HDD:50, +NET:-1" > /sys/kernel/mm/swap/tiers
+    # cat /sys/kernel/mm/swap/tiers
+    Name             Idx   PrioStart   PrioEnd
+    HDD              0     50          32767
+    NET              1     -1          49
+
+**2. Adding a New Tier (split)**
+
+A new tier 'SSD' is added at priority 100, splitting the existing 'HDD' tier.
+The ranges are automatically recalculated:
+
+* 'SSD' takes the top range (100 to SHRT_MAX).
+* 'HDD' is adjusted to the range between 'NET' and 'SSD' (50 to 99).
+* 'NET' remains unchanged (-1 to 49).
+
+::
+
+    # echo "+SSD:100" > /sys/kernel/mm/swap/tiers
+    # cat /sys/kernel/mm/swap/tiers
+    Name             Idx   PrioStart   PrioEnd
+    SSD              2     100         32767
+    HDD              0     50          99
+    NET              1     -1          49
+
+**3. Removal (merge)**
+
+Tiers can be removed using the '-' prefix.
+::
+
+    # echo "-SSD" > /sys/kernel/mm/swap/tiers
+
+When a tier is removed, its priority range is merged into the adjacent
+tier. The merge direction is always upward (the tier below expands),
+except when the lowest tier is removed — in that case the tier above
+shifts its starting priority down to -1 to maintain full range coverage.
+
+::
+
+    Initial state:
+    Name             Idx   PrioStart   PrioEnd
+    SSD              2     100         32767
+    HDD              1     50          99
+    NET              0     -1          49
+
+    # echo "-SSD" > /sys/kernel/mm/swap/tiers
+
+    Name             Idx   PrioStart   PrioEnd
+    HDD              1     50          32767       <- merged with SSD's range
+    NET              0     -1          49
+
+    # echo "-NET" > /sys/kernel/mm/swap/tiers
+
+    Name             Idx   PrioStart   PrioEnd
+    HDD              1     -1          32767       <- shifted down to -1
+
+**4. Interaction with Active Swap Devices**
+
+If a swap device is active (swapon), the tier covering that device's
+priority cannot be removed. Splitting the active tier's range is only
+allowed above the device's priority.
+
+Assume a swap device is active at priority 60 (inside 'HDD' tier).
+
+::
+
+    # swapon -p 60 /dev/zram0
+
+    Name             Idx   PrioStart   PrioEnd
+    HDD              0     50          32767
+    NET              1     -1          49
+
+    # echo "-HDD" > /sys/kernel/mm/swap/tiers
+    -bash: echo: write error: Device or resource busy
+
+    # echo "+SSD:60" > /sys/kernel/mm/swap/tiers
+    -bash: echo: write error: Device or resource busy
+
+    # echo "+SSD:100" > /sys/kernel/mm/swap/tiers
+
+    Name             Idx   PrioStart   PrioEnd
+    SSD              2     100         32767
+    HDD              0     50          99          <- device (prio 60) stays here
+    NET              1     -1          49
diff --git a/MAINTAINERS b/MAINTAINERS
index 501bf46adfb4..fa05a39d9ad1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16735,6 +16735,7 @@ R:	Barry Song <baohua@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
+F:	Documentation/mm/swap-tier.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..1e68c220a0e7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -262,6 +262,7 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
+	int tier_mask;			/* swap tier mask */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8129d714a44a..513d74dc1709 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -1003,7 +1003,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_validate()) {
+	if (!swap_tiers_update()) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 62b60fa8d3b7..91aac55d3a8b 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -38,6 +38,8 @@ static LIST_HEAD(swap_tier_inactive_list);
 	(!list_is_first(&(tier)->list, &swap_tier_active_list) ? \
 	list_prev_entry((tier), list)->prio - 1 : SHRT_MAX)
 
+#define MASK_TO_TIER(mask) (&swap_tiers[__ffs((mask))])
+
 #define for_each_tier(tier, idx) \
 	for (idx = 0, tier = &swap_tiers[0]; idx < MAX_SWAPTIER; \
 		idx++, tier = &swap_tiers[idx])
@@ -59,6 +61,26 @@ static bool swap_tier_is_active(void)
 	return !list_empty(&swap_tier_active_list) ? true : false;
 }
 
+static bool swap_tier_prio_in_range(struct swap_tier *tier, short prio)
+{
+	if (tier->prio <= prio && TIER_END_PRIO(tier) >= prio)
+		return true;
+
+	return false;
+}
+
+static bool swap_tier_prio_is_used(short prio)
+{
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio == prio)
+			return true;
+	}
+
+	return false;
+}
+
 static struct swap_tier *swap_tier_lookup(const char *name)
 {
 	struct swap_tier *tier;
@@ -96,6 +118,7 @@ void swap_tiers_init(void)
 	int idx;
 
 	BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER);
+	BUILD_BUG_ON(MAX_SWAPTIER > TIER_DEFAULT_IDX);
 
 	for_each_tier(tier, idx) {
 		INIT_LIST_HEAD(&tier->list);
@@ -146,17 +169,29 @@ static struct swap_tier *swap_tier_prepare(const char *name, short prio)
 	return tier;
 }
 
-static int swap_tier_check_range(short prio)
+static int swap_tier_can_split_range(short new_prio)
 {
+	struct swap_info_struct *p;
 	struct swap_tier *tier;
 
 	lockdep_assert_held(&swap_lock);
 	lockdep_assert_held(&swap_tier_lock);
 
-	for_each_active_tier(tier) {
-		/* No overwrite */
-		if (tier->prio == prio)
-			return -EINVAL;
+	plist_for_each_entry(p, &swap_active_head, list) {
+		if (p->tier_mask == TIER_DEFAULT_MASK)
+			continue;
+
+		tier = MASK_TO_TIER(p->tier_mask);
+		if (!swap_tier_prio_in_range(tier, new_prio))
+			continue;
+
+		/*
+		 * Device sits in a tier that spans new_prio;
+		 * splitting here would reassign it to a
+		 * different tier.
+		 */
+		if (p->prio >= new_prio)
+			return -EBUSY;
 	}
 
 	return 0;
@@ -190,7 +225,11 @@ int swap_tiers_add(const char *name, int prio)
 	if (!swap_tier_validate_name(name))
 		return -EINVAL;
 
-	ret = swap_tier_check_range(prio);
+	/* No overwrite */
+	if (swap_tier_prio_is_used(prio))
+		return -EBUSY;
+
+	ret = swap_tier_can_split_range(prio);
 	if (ret)
 		return ret;
 
@@ -217,6 +256,11 @@ int swap_tiers_remove(const char *name)
 	if (!tier)
 		return -EINVAL;
 
+	/* Simulate adding a tier to check for conflicts */
+	ret = swap_tier_can_split_range(tier->prio);
+	if (ret)
+		return ret;
+
 	/* Removing DEF_SWAP_PRIO merges into the higher tier. */
 	if (!list_is_singular(&swap_tier_active_list)
 		&& tier->prio == DEF_SWAP_PRIO)
@@ -227,13 +271,15 @@ int swap_tiers_remove(const char *name)
 	return ret;
 }
 
-static struct swap_tier swap_tiers_snap[MAX_SWAPTIER];
 /*
- * XXX: When multiple operations (adds and removes) are submitted in a
- * single write, reverting each individually on failure is complex and
- * error-prone. Instead, snapshot the entire state beforehand and
- * restore it wholesale if any operation fails.
+ * XXX: Static global snapshot buffer for batch operations. Small
+ * and used once per write, so a static global is not bad.
+ * When multiple adds/removes are submitted in a single write,
+ * reverting each individually on failure is error-prone. Instead,
+ * snapshot beforehand and restore wholesale if any operation fails.
  */
+static struct swap_tier swap_tiers_snap[MAX_SWAPTIER];
+
 void swap_tiers_snapshot(void)
 {
 	BUILD_BUG_ON(sizeof(swap_tiers_snap) != sizeof(swap_tiers));
@@ -265,9 +311,29 @@ void swap_tiers_snapshot_restore(void)
 	}
 }
 
-bool swap_tiers_validate(void)
+void swap_tiers_assign_dev(struct swap_info_struct *swp)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+
+	for_each_active_tier(tier) {
+		if (swap_tier_prio_in_range(tier, swp->prio)) {
+			swp->tier_mask = TIER_MASK(tier);
+			return;
+		}
+	}
+
+	swp->tier_mask = TIER_DEFAULT_MASK;
+}
+
+bool swap_tiers_update(void)
 {
 	struct swap_tier *tier;
+	struct swap_info_struct *swp;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
 
 	/*
 	 * Initial setting might not cover DEF_SWAP_PRIO.
@@ -281,5 +347,16 @@ bool swap_tiers_validate(void)
 			return false;
 	}
 
+	/*
+	 * If applied initially, the swap tier_mask may change
+	 * from the default value.
+	 */
+	plist_for_each_entry(swp, &swap_active_head, list) {
+		/* Tier is already configured */
+		if (swp->tier_mask != TIER_DEFAULT_MASK)
+			break;
+		swap_tiers_assign_dev(swp);
+	}
+
 	return true;
 }
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index a1395ec02c24..6f281e95ed81 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -5,8 +5,15 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 
+/* Forward declarations */
+struct swap_info_struct;
+
 extern spinlock_t swap_tier_lock;
 
+#define TIER_ALL_MASK		(~0)
+#define TIER_DEFAULT_IDX	(31)
+#define TIER_DEFAULT_MASK	(1 << TIER_DEFAULT_IDX)
+
 /* Initialization and application */
 void swap_tiers_init(void);
 ssize_t swap_tiers_sysfs_show(char *buf);
@@ -16,5 +23,8 @@ int swap_tiers_remove(const char *name);
 
 void swap_tiers_snapshot(void);
 void swap_tiers_snapshot_restore(void);
-bool swap_tiers_validate(void);
+bool swap_tiers_update(void);
+
+/* Tier assignment */
+void swap_tiers_assign_dev(struct swap_info_struct *swp);
 #endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f93df281ede..2f956b6a5edc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2672,6 +2672,8 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	/* Add back to available list */
 	add_to_avail_list(si, true);
+
+	swap_tiers_assign_dev(si);
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-- 
2.34.1


