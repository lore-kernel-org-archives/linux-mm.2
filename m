Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D494FD79768
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 12:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FF86B0093; Sat, 31 Jan 2026 07:56:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476D86B0096; Sat, 31 Jan 2026 07:56:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C0D6B0093; Sat, 31 Jan 2026 07:56:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8266B0093
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:56:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF8411B1CED
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:31 +0000 (UTC)
X-FDA: 84392257782.08.78AA615
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf06.hostedemail.com (Postfix) with ESMTP id C434C180005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dfhLuaR9znVC6S1xisEZDzCrFNHcV3eNwfRTaFE2+Fc=;
	b=X+q59s0dDDnzlbeQXEZz+KUN7BMNIzQeFzcDePTM3EjBziXD69PV13Qu9U5YJWjPdxs4SW
	2rEs06f7BRTmg9kfH4d6Ltk/FZ97giBOnNYAfh45PeVPPeZhf9Z9+K7q62peTzUv6ksxAt
	c3W9XRdCrfCouJP79rcB6yei1S0ecK8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769864190; a=rsa-sha256;
	cv=none;
	b=whhSXqXj2woMq5rD38Tt7Y5z5ijM6gIiNF1iKLsBukIize1izthcqTQAuszo2X9YRTODoe
	H4MZ+QZGbJ3rLZh82+Qi0sNs9mcECuKdBVLlBuZ/xn1TXP1hbUEjF11HaEj1r21rXVV2/0
	0GFvgDPZJFwHKugggVj6xh2khLuEaXY=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Jan 2026 21:56:27 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
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
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH v3 5/5] mm, swap: introduce percpu swap device cache to avoid fragmentation
Date: Sat, 31 Jan 2026 21:54:54 +0900
Message-Id: <20260131125454.3187546-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260131125454.3187546-1-youngjun.park@lge.com>
References: <20260131125454.3187546-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 931kytdmrzrhph6bqnrd78ojt4dj8qz9
X-Rspam-User: 
X-Rspamd-Queue-Id: C434C180005
X-HE-Tag: 1769864189-824694
X-HE-Meta: U2FsdGVkX18cWPLtza7R99VLeQU/POnRhyWzZm9cSAskuvMGV94evqXgV0OD69vptu/iPnu+/94mSW8F/8GumtxhSF4aDs7z/fVkWdS+vxnUXdx5LcfxYC1qh3UneXjus8dJdSZjdq6uDfzer+K9EZ7csG/T4UBiiTeezuBxlV2ck8Lrlq0CWZukCm2DSVcscnvp/qDIPxfJ7JmB5SZh+NU96RFtljGpPfVZCSLuX25WCAJt5ceWTZqbk8kctArkDHLPZDknGLuvqSu926+5T04v8qliO+3HJ0PMMN56Xd76kzCFwalTkIaE9LyHg4Eg9pxLxm5A+XyH+gf4ml+vBuaCrzf+vvCY1BbwJ+r0ungo3A7Db8QLmgrYjS2EpnNvruMB8xoCniLjeYp4U9W2gN1kIdkCQAQsrfYZsp/Re5FbXz93rYOJgSMg3Spu8tqyYIpK30i280kibS76gpTB/DSVtn/QP/mK1t+b6MaLJ0405Qi6dy1Oi5dx/MYiWTNp9pvZRZHIQlFnjk1pGeUW7P79doqsuH+T3ujc2WdUxSSyzTisjYhUe5VMBtkT4Fu0vOSWshD+1fhSlJqSJfw1wHQFLy6SEZf0A3H3cI6vJRmXr6VF4UG8KBcB4m1GEiLU0DjJLIaxVO+Q4Pf/LASaNeNHA48e0ourLzjZKXbdS7O1OQO6UTcdGApjhS73sn/6CNyn1y15izxf/0iS6Xo5i0GrUugCnkVVAGFgAaUglX2TG0fYpTU21jeC2phrhsmcNDqiRnMpwSArSduQ/6wyHABnJ2dXwHg6NP1IOAnfD7PZGJ/lMm6IZsYY4hn/bjqBkX9bh3SAiPWXJdvIuCS20DJBnYWMkwOfjQlNYEU2rxUetdsw469FYju0viDRJpRpAuhd9zdX4xsM7ohTaFQ4ouNUN9XarRpHgm5FA2zIMJHpbRmWfqw/xFtfxUtD627T79U0h0WasohqGEVcu8p
 gYhubGcB
 HQMKl9yaL5mfIyqndi9jc+i8ZQnkCVDjXJoq9UHoOJQkiWXMVcvQdLZXdjExFi1g65KOKnGaElhEEVXgMqhFczoxDwIauaKuw1bC7lgNGiZ7lmuN1zVgUmhzO2VZyz/2duXUzBjdozU7BqoaRTLuOLR+/VSLNVUnxrTC3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the previous commit that introduced per-device percpu clusters,
the allocation logic caused swap device rotation on every allocation
when multiple swap devices share the same priority. This led to
cluster fragmentation on every allocation attemp.

To address this issue, this patch introduces a per-cpu swap device
cache, restoring the allocation behavior to closely match the
traditional fastpath and slowpath flow.

With swap tiers, cluster fragmentation can still occur when a CPU's
cached swap device doesn't belong to the required tier for the current
allocation - this is the intended behavior for tier-based allocation.

With swap tiers and same-priority swap devices, the slow path
triggers device rotation and causes initial cluster fragmentation.
However, once a cluster is allocated, subsequent allocations will
continue using that cluster until it's exhausted, preventing repeated
fragmentation. While this may not be severe, there is room for future
optimization.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 87 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6921e22b14d3..ac634a21683a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -253,7 +253,6 @@ enum {
   * throughput.
   */
 struct percpu_cluster {
-	local_lock_t lock; /* Protect the percpu_cluster above */
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4708014c96c4..fc1f64eaa8fe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -106,6 +106,16 @@ PLIST_HEAD(swap_active_head);
 static PLIST_HEAD(swap_avail_head);
 static DEFINE_SPINLOCK(swap_avail_lock);
 
+struct percpu_swap_device {
+	struct swap_info_struct *si[SWAP_NR_ORDERS];
+	local_lock_t lock;
+};
+
+static DEFINE_PER_CPU(struct percpu_swap_device, percpu_swap_device) = {
+	.si = { NULL },
+	.lock = INIT_LOCAL_LOCK(),
+};
+
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
 static struct kmem_cache *swap_table_cachep;
@@ -465,10 +475,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
 	lockdep_assert_held(&ci->lock);
-	if (si->flags & SWP_SOLIDSTATE)
-		lockdep_assert_held(this_cpu_ptr(&si->percpu_cluster->lock));
-	else
-		lockdep_assert_held(&si->global_cluster->lock);
+	lockdep_assert_held(this_cpu_ptr(&percpu_swap_device.lock));
+
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
 
@@ -484,10 +492,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * the potential recursive allocation is limited.
 	 */
 	spin_unlock(&ci->lock);
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	local_unlock(&percpu_swap_device.lock);
 
 	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
 
@@ -499,7 +504,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&si->percpu_cluster->lock);
+	local_lock(&percpu_swap_device.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_lock(&si->global_cluster->lock);
 	spin_lock(&ci->lock);
@@ -944,9 +949,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
-	if (si->flags & SWP_SOLIDSTATE)
+	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(si->percpu_cluster->next[order], next);
-	else
+		this_cpu_write(percpu_swap_device.si[order], si);
+	} else
 		si->global_cluster->next[order] = next;
 
 	return found;
@@ -1044,7 +1050,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 
 	if (si->flags & SWP_SOLIDSTATE) {
 		/* Fast path using per CPU cluster */
-		local_lock(&si->percpu_cluster->lock);
 		offset = __this_cpu_read(si->percpu_cluster->next[order]);
 	} else {
 		/* Serialize HDD SWAP allocation for each device. */
@@ -1122,9 +1127,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
+	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster->lock);
 
 	return found;
@@ -1306,8 +1309,29 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
+static bool swap_alloc_fast(struct folio *folio)
+{
+	unsigned int order = folio_order(folio);
+	struct swap_info_struct *si;
+	int mask = folio_tier_effective_mask(folio);
+
+	/*
+	 * Once allocated, swap_info_struct will never be completely freed,
+	 * so checking it's liveness by get_swap_device_info is enough.
+	 */
+	si = this_cpu_read(percpu_swap_device.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
+		!get_swap_device_info(si))
+		return false;
+
+	cluster_alloc_swap_entry(si, folio);
+	put_swap_device(si);
+
+	return folio_test_swapcache(folio);
+}
+
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_entry(struct folio *folio)
+static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
 	int mask = folio_tier_effective_mask(folio);
@@ -1484,7 +1508,11 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	swap_alloc_entry(folio);
+	local_lock(&percpu_swap_device.lock);
+	if (!swap_alloc_fast(folio))
+		swap_alloc_slow(folio);
+	local_unlock(&percpu_swap_device.lock);
+
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
@@ -1903,7 +1931,9 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * Grab the local lock to be compliant
 			 * with swap table allocation.
 			 */
+			local_lock(&percpu_swap_device.lock);
 			offset = cluster_alloc_swap_entry(si, NULL);
+			local_unlock(&percpu_swap_device.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);
 		}
@@ -2707,6 +2737,27 @@ static void free_cluster_info(struct swap_cluster_info *cluster_info,
 	kvfree(cluster_info);
 }
 
+/*
+ * Called after swap device's reference count is dead, so
+ * neither scan nor allocation will use it.
+ */
+static void flush_percpu_swap_device(struct swap_info_struct *si)
+{
+	int cpu, i;
+	struct swap_info_struct **pcp_si;
+
+	for_each_possible_cpu(cpu) {
+		pcp_si = per_cpu_ptr(percpu_swap_device.si, cpu);
+		/*
+		 * Invalidate the percpu swap device cache, si->users
+		 * is dead, so no new user will point to it, just flush
+		 * any existing user.
+		 */
+		for (i = 0; i < SWAP_NR_ORDERS; i++)
+			cmpxchg(&pcp_si[i], si, NULL);
+	}
+}
+
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -2790,6 +2841,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
+	flush_percpu_swap_device(p);
 
 	destroy_swap_extents(p);
 	if (p->flags & SWP_CONTINUED)
@@ -3224,7 +3276,6 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 			cluster = per_cpu_ptr(si->percpu_cluster, cpu);
 			for (i = 0; i < SWAP_NR_ORDERS; i++)
 				cluster->next[i] = SWAP_ENTRY_INVALID;
-			local_lock_init(&cluster->lock);
 		}
 	} else {
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
-- 
2.34.1


