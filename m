Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D9D5CD6E41
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BB86B0095; Wed, 27 May 2026 02:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322F26B0096; Wed, 27 May 2026 02:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC366B0098; Wed, 27 May 2026 02:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 029426B0095
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:23:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 893E44037D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:23:49 +0000 (UTC)
X-FDA: 84812208978.10.E27E815
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2214540006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:23:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xZiM6xf40HP3J5nr6bxFhVWJAj1leVyCVTlzL8Z7jA0=;
	b=a73tnrXEeFaiJrpfDXXEXsBuAWuWTTGUd4t3Lml7R8eAb947QNiM0QzeSUI2nuydbw3SCo
	j2Wm9CRjazj+u9KNe69JTV2d/uX3dRZPaMroZEo18tNT6lhtf5a4l7c/TlMh7y4hUs/Njb
	OFof4eCtd/dMaJ/WEwofV2Ore2nj7nc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863027; a=rsa-sha256;
	cv=none;
	b=KCCA9nRPV2+thUoy1xccYP52WacBT2jZuk/d9JuUYkbYtbbPEu96zXD/bpc0nT3MALkAFU
	pUoA+knGOuLliauUFHBvr4ae0Lx6mLqae6ddPRZx5uGb3wH4pO50ILkiDQS6F5TQpKALPr
	4RPMXrqasb3hlXN/OgVNiGiHcEaflBU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 15:23:44 +0900
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
Subject: [PATCH v7 2/4] mm: swap: associate swap devices with tiers
Date: Wed, 27 May 2026 15:22:45 +0900
Message-Id: <20260527062247.3440692-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527062247.3440692-1-youngjun.park@lge.com>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tdgk8cpeby7zp4w735164gp66u84pb89
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2214540006
X-HE-Tag: 1779863026-263605
X-HE-Meta: U2FsdGVkX1/MEJBM/CIrbfOWxb0doqVXkDlBBI7qyurOY6yv6dKEpBfzCsNMrtr00/c8XLwkDb7lcBAOY8czpcZUzE+S8XaxgxQCgcyYfMDon38B0km1N2QxmVEgbyVLZPgRtYUKUxqZABPxjKItR0JB3cI8ChFLbhwubftwo9NNCCJenyHGMKLPcSCFrKuRIkcHMFg38BNPdl/fsgyqgDxZvhS6mdk2mIRNaUqEcKEqlLovYMfOTKp1ockc9Ce8JYepXGB74EY3Ok2iEZaZUAm1M395zbvNlRLVOxxGyXSgvT/nYbDe8VrQTo8miHBw0gBje8mY4Ae638EDMGt3rK5O72lP35ZfTPqWNY17CxP9boBI4fU27Edx4AsMHy3NZQWQjRtJ5oqwZ7nAIX7OOBdjYEhMWh5gTxrieS8OyZW8HlHZdiOq3ukRBeBeZRnpbwvwgJblv8b59wJTy0S0ACWNihs8CYw1NG9d4NhiME+CuHN2gxNlYttyosmxSgDZJmvJTRyBKjhNnxS8Y9iaFFaFIPi/yjs389s4tzCALfSAcFnJR+oJZBupYaLjJmz6VPwl+Shw0L1TfmLHGyqGQTt4UYCM9TwzMFJg76HXrBRramKSaI7nHRLDMC9/9OA4CE2ECrGZQHhvvGjQtfQXCg5wArLQj39i+tAhNHNXdgXpCecp7+zr/m3NAdSa7LAgp65F+NU6ZXT6UeXHIJ/wlTlI2B9saVPtHYRQlQ9DdzV9a9STqNOlVpSEZOx36CX4MelC+xft4a2xI24ON/PEyB74D2kh0xbMIx/tNaOLPcGRbYNdK6PLkqpg2zaje18VHmdopI6U3jQH4hTgFkYSxW5UTRiu96lwSOgTLZlPPbDlI3AJpRvOcaOOAND4IM3UBLL+H61TdpDQ90KNRp4FlpbIjFO/e4PkqyfSMOZmXu5DcL8ybD11KWT9cLiE+VZYtJXwZm0Vl782p3G7xTI
 IdlbHca1
 yRQI8STKFc2MmkJUXk7sB03BYEK2KS/5tQNSSj1vR3Aa+0KXkaL7nJebTsBcGtx9/GEf75nemNNvoE8zwb45dQvNuikDsx9yHs5rrk2rv5CI3n+aXqkgaD3+2/SWDw0B4oJw+pEQugP7MzBwjDPGiA4+/b416r9cZQNI3PoTA6T/MilE7zmz2JnG1arT8jtkehm86haih6NoFn4avNCAo03A2BV61pZw0hFFq+IJzZ9glED2GOMGot9KT8E4h/1WdZzARy816cTZNQR+IjFpU8g2UOA==
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

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/mm/index.rst     |   1 +
 Documentation/mm/swap-tier.rst | 159 +++++++++++++++++++++++++++++++++
 MAINTAINERS                    |   1 +
 include/linux/swap.h           |   1 +
 mm/swap_state.c                |   2 +-
 mm/swap_tier.c                 | 101 ++++++++++++++++++---
 mm/swap_tier.h                 |  13 ++-
 mm/swapfile.c                  |   2 +
 8 files changed, 266 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..a0d1447c5569 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -21,6 +21,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_reclaim
    swap
    swap-table
+   swap-tier
    page_cache
    shmfs
    oom
diff --git a/Documentation/mm/swap-tier.rst b/Documentation/mm/swap-tier.rst
new file mode 100644
index 000000000000..addbc495de8c
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
+---------
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
index e3cbfedbaa5f..c008014663b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17041,6 +17041,7 @@ R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
+F:	Documentation/mm/swap-tier.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6d72778e6cc3..21286945770a 100644
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
index e609bbdf7e13..de285b36e31c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -1053,7 +1053,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_validate()) {
+	if (!swap_tiers_update()) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index ac7a3c2a48cb..6b57cadb3e95 100644
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
 	return !list_empty(&swap_tier_active_list);
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
@@ -99,6 +121,7 @@ void swap_tiers_init(void)
 	int idx;
 
 	BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER);
+	BUILD_BUG_ON(MAX_SWAPTIER > TIER_DEFAULT_IDX);
 
 	for_each_tier(tier, idx) {
 		INIT_LIST_HEAD(&tier->list);
@@ -149,17 +172,29 @@ static struct swap_tier *swap_tier_prepare(const char *name, short prio)
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
@@ -199,7 +234,11 @@ int swap_tiers_add(const char *name, int prio)
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
 
@@ -226,6 +265,11 @@ int swap_tiers_remove(const char *name)
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
@@ -236,13 +280,15 @@ int swap_tiers_remove(const char *name)
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
@@ -282,10 +328,30 @@ void swap_tiers_snapshot_restore(void)
 	}
 }
 
-bool swap_tiers_validate(void)
+void swap_tiers_assign_dev(struct swap_info_struct *swp)
 {
 	struct swap_tier *tier;
 
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
+{
+	struct swap_tier *tier;
+	struct swap_info_struct *swp;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
 	/*
 	 * Initial setting might not cover DEF_SWAP_PRIO.
 	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
@@ -298,5 +364,16 @@ bool swap_tiers_validate(void)
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
index a1395ec02c24..3e355f857363 100644
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
+#define TIER_DEFAULT_MASK	(1U << TIER_DEFAULT_IDX)
+
 /* Initialization and application */
 void swap_tiers_init(void);
 ssize_t swap_tiers_sysfs_show(char *buf);
@@ -16,5 +23,9 @@ int swap_tiers_remove(const char *name);
 
 void swap_tiers_snapshot(void);
 void swap_tiers_snapshot_restore(void);
-bool swap_tiers_validate(void);
+bool swap_tiers_update(void);
+
+/* Tier assignment */
+void swap_tiers_assign_dev(struct swap_info_struct *swp);
+
 #endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3f7225dbc6cd..9a86ebe992f4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3036,6 +3036,8 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	/* Add back to available list */
 	add_to_avail_list(si, true);
+
+	swap_tiers_assign_dev(si);
 }
 
 /*
-- 
2.34.1


