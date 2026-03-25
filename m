Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC7B109C050
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44F86B008A; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5F66B008C; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72296B0092; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 952076B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F10B1A09C9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:03 +0000 (UTC)
X-FDA: 84585336486.08.21081B2
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf20.hostedemail.com (Postfix) with ESMTP id 042771C000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774461301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/MYBih8YM4nE9+mbmwR5+qAwMPN41VaNtBm/hS+jVyo=;
	b=rp4kTIrMJ/Ybgj88ZFBTfVGBWhvlV4wX56GBS/vNqZBQzd4zOJIULpRBUbgGTFt2fa9zdw
	7cC/L7dxffQMD/JB6YWe8WjVGtARiZHxP3Kl5l7xWun9P4nRq+cVxM3IKkBn5sdqgD+ojP
	nTKvGO0CjN06Jgc5MLEd/6qessqEULY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774461301; a=rsa-sha256;
	cv=none;
	b=X9JdutW2RRYCIGP1NBm47P3I//929YTZawNdjrmzsZ9AQQT9w2iu720ZcEUe8kXduH46YV
	a744z50nQJ7CzCsr1QktTbPs2GcTUFWvq94SxcnzaclYFd6E76Hy2W0zDie5ma4CVCyr5W
	X9NPcnQD3Mj5UyoPk3q1hk+CvtzIYao=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 02:54:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
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
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com
Subject: [PATCH v5 2/4] mm: swap: associate swap devices with tiers
Date: Thu, 26 Mar 2026 02:54:51 +0900
Message-Id: <20260325175453.2523280-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325175453.2523280-1-youngjun.park@lge.com>
References: <20260325175453.2523280-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 042771C000C
X-Stat-Signature: d8g9g5emddhtmd6t379au35mihsuyc6g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774461300-765774
X-HE-Meta: U2FsdGVkX1+1cxzGdJR20YzEjp5m7iqCWovcDtJoh6B1YVRlgOB2V9XYtNEvB0VAtLm363vzvTxuNFiXvEkVcqu0u2Nye7XXLuMTBWm2aFdf8cXW84/ixRElkOJrNfCiTCR10A6vfWYzbudSyZ7fsC7XkRkE5dg3D8RLa46alUCz46uHPALFgVZWxwW+W7sOjLwny9gDxdetbMulgNym+TgzSJZ1cVnubu4EE4yS6YnzWSg72IVF/0KGWP/CFKaZnhf/2oSINT6B9th1ubTGtAdKWFDdigg5HnGczZiIn6dVMPJsiJJcktXOCPBj/g/VF92WU8G+R/gw3HJbalhmaRBbF1xgRbW9OPCtGb6HBb8MbokWDs3bCbTi5kuy27QtgRaaMD6QijQTdt4diOVwM/5u/1mrjd21SaLq/lczXsb5OQYHIoFFysDgGkQ2yw0Wz9WeYSocGAkQUnGte+lcbIymq43KNY5tFu7m+F2/N2HpabUsm8iHYxnhP16HznO5X7OqEHpbPjaTx39hao2UswIm3LG+j8ciQTYd6XeeVHsuDAWDHKzRtLHKlvcZRkheJyVR4QfKGg6JsBchBySGq+1YNRtkza414zkzkAd1XWk4XFte5GYsaQ3vINzZbWOwDg6MZjIAaaqXJUXzQIKDe3AbnjVxvg4GWvk1YbmdWOP8WaGAk/B0Y/AVfHn2WFvnFoFQeds/xHWZbGY5JMw9/y4yvpJ9r0Tv1dzpOrX3hXamkvpk6A2FMtaAE/gGoMH5WvsG0ft34FRf1b1m5e1+8866mnSdRgF3hwnsaysJUmr5zvGGPVehhAXY3/ntxJXnz2RH1S8Uo7JX8OzfvNY6j/6J4ShpnFxoPKCIbQ3MqyijJVT/MKQsl3o4bIcmPtFqFk965gEl5rWGZSVqZkmpIy9khLfmI96fdiCPaGmx5zmnYv9jCB/CCFV9ZPpL0NrH74xLtLbQuBzCSFunppg
 CBA7UphU
 knThC/yHkhnt6VjgS1R7RuLqJO1LVNJdJ5vRbIg+9sh8Q4DDlwUYzjRqJ75Vr66v1S8MZ4ZvNhxrMNbmWp9KoJwDsQfYOt/uDKkmRe7jc/yTxZUu57RuOTgXe23PhpWllh94ifNzRfIQoZ8+iUXv1qsQ5MvZzS+om8R64qMKnFnbUyWa81D6s6Zz2xMskFuteqdCCm08th4JpMO9+S5cS3qxg6wl6hjyLz29+KzdHdV3R9rf76+qbXj8+qgv3mc9bN8WdDtQl1b2IoJ5Ck1TJOAIT8Q==
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
index f3b07f1fa38a..62a177983799 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16908,6 +16908,7 @@ R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
+F:	Documentation/mm/swap-tier.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1930f81e6be4..3bc06a1a4a17 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -250,6 +250,7 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
+	int tier_mask;			/* swap tier mask */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index bfdc0208e081..847096e2f3e5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -980,7 +980,7 @@ static ssize_t tiers_store(struct kobject *kobj,
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
index 03bf2a0a42ac..645e10c3af28 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2914,6 +2914,8 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	/* Add back to available list */
 	add_to_avail_list(si, true);
+
+	swap_tiers_assign_dev(si);
 }
 
 /*
-- 
2.34.1


