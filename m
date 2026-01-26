Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6B9C88E57
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 07:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2BDD6B009E; Mon, 26 Jan 2026 02:08:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2686B00A1; Mon, 26 Jan 2026 02:08:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD2F6B00A2; Mon, 26 Jan 2026 02:08:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C08DC6B009E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 02:08:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78D66C25B9
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:08:41 +0000 (UTC)
X-FDA: 84373237242.25.C18894A
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19C464000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:08:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769411319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBsJP3CAgK6LvRBAGpz4tnMx9iFkpbSbcNmomps2w5o=;
	b=yGz/+AdrfFXiYbAdZg89FSJ3dYM8SRyPRlFwFAK8UQ+fimqknOJQLSg7sF+vAr5wAFKEtb
	9DuT94UxqV7yhBUL70n8UIH7XZB78DrqmnfqG1N9rnbzIDi0hBHdH9AFmnvJSRz6MyYgJh
	K2CjRchkYuVoOC4J0nwWmzoIyIdbGMc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769411319; a=rsa-sha256;
	cv=none;
	b=yuZMmjrSFnIRhEY7VMcm7MNyHxggeG6PmGVGE7gOXaOd7ff2jH2agjRbQ7KYDBjZ8RVePv
	g2JW5XWB7jj+EtBIkuV1nBY43TH+EH1fP2SaD9XAImfX859Il0pWssZrzrFmCUK71o4lXE
	MVRk7X7ww5+7YTPkutYwRYtWBkWRnqU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Jan 2026 15:53:36 +0900
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
Subject: [RFC PATCH v2 v2 5/5] mm, swap: introduce percpu swap device cache to avoid fragmentation
Date: Mon, 26 Jan 2026 15:52:42 +0900
Message-Id: <20260126065242.1221862-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260126065242.1221862-1-youngjun.park@lge.com>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19C464000B
X-Stat-Signature: 67snn1scsfeprmijxxkco57m3roe8fzn
X-Rspam-User: 
X-HE-Tag: 1769411318-628602
X-HE-Meta: U2FsdGVkX19zKGJxPLQ9GXPd+IwAF9MJn7TtM0pv77MS6zh6CldXnhOuif9qAngsIUlDHGX5t00sB9IeVJaWVN2f8Bv6wbJN5uz/GrNS10cxRhBlMTSVSAcMZbLpP4WTTrKwNSsNNYrMZmouojMn887E9hFhkZYOJ+dqaAV7s9l2JSOpyecIk+Fqcr2wUtj/OTMsm+GhqvQ246LOJWnm2y+DKMm/gnvynuJd8KwlTrwVnT2stWielMsuKMOCDixxcKeVlXakYWHvYOs6W5I/wDDrZcXU+z5jL0Fo8Eew7uDpt5nSq67h9pXrc0U17MgQFQeWkpVgVzmNo6dISMais2J97y/hsLC2aiMqyqVEuoHBS9/4vHISu3euHbf+9bfVyUeVyWZguNXKfGKbGuipEkXKFQaQmGm9vMqQ/Z2/Xus4PjBVIjaV9f2W06GqjrkKyQvAmbg7IQ7r6+kEvFHer7eiHxyjWjZx1LChnW/bvWMXRqVyQvaS1GMHPmDpg1mDL/gHTmqUQS6/pV/mNgKJuWlz7Zr15poyRsQqnWQYeK97kbdomIuT2RbMkayV76887tGv4NMxhC/FhRlKm9msvg46bUjzA2CPbfELbBV+A7+46ryjwyoclxyXpcOnnRQV/s8QrlxeG92OEmElrzDIq7Em/WkCqXeuNPnpx2UI+EDrgbMHg04DStEbokNZj0C9KYA3RqGicT7v3ggbYH4JXUtYXkuxYkfPsfKbLvr3a4OSdOEo2bxz6Ci39xf7CRfwU/UJnJTxGcpua4n6UFwSNa0bBuqGN4sCnaOcy23G1acnrM1Khxyb8T7tAebIzi2Dvk00zay1pZcX7PIgMUQyzaMMC0yz4WzrLQQ98TBVAjgip4jL42rYhvgKTskvuI3wcYWgiR5D/QzKo4M3sb272jh1Bk5s6kxsJXKfgMtRfoD5mgtyt+ALMR34XnkQqi2yKGYI+n8mf7lZtFWJ6Sx
 wG+M1Xnu
 KFY6+gLB9C4ZsbVlMf10bIXOgY/tpBpjZjRL9HPEFYZ0hJmx4gDyDuh3YHzsSHrF+CCNOY2JQzsCSMoKW5GsePbxdJnxfnUdwUvGGzyfiIMc2+RR2S1ovg3Lo9WoQc2hf4c71EqSH+LcCw5tf5683dTBaF4x0vCBGg9Y5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using per-device percpu clusters (instead of a global one),
a naive allocation logic triggers swap device rotation on every
allocation. This behavior leads to severe fragmentation and performance
regression.

To address this, this patch introduces a per-cpu cache for the swap
device. The allocation logic is updated to prioritize the per-cpu
cluster within the cached swap device, effectively restoring the
traditional fastpath and slowpath flow. This approach minimizes side
effects on the existing fastpath.

With this change, swap device rotation occurs only when the current
cached device is unable to satisfy the allocation, rather than on
every attempt.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 78 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 66 insertions(+), 13 deletions(-)

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
index 5e3b87799440..0dcd451afee5 100644
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
@@ -465,7 +475,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
 	lockdep_assert_held(&ci->lock);
-	lockdep_assert_held(this_cpu_ptr(&si->percpu_cluster->lock));
+	lockdep_assert_held(this_cpu_ptr(&percpu_swap_device.lock));
 
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
@@ -484,7 +494,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster->lock);
-	local_unlock(&si->percpu_cluster->lock);
+	local_unlock(&percpu_swap_device.lock);
 
 	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
 
@@ -496,7 +506,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&si->percpu_cluster->lock);
+	local_lock(&percpu_swap_device.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_lock(&si->global_cluster->lock);
 	spin_lock(&ci->lock);
@@ -941,9 +951,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
@@ -1041,7 +1052,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 
 	if (si->flags & SWP_SOLIDSTATE) {
 		/* Fast path using per CPU cluster */
-		local_lock(&si->percpu_cluster->lock);
 		offset = __this_cpu_read(si->percpu_cluster->next[order]);
 	} else {
 		/* Serialize HDD SWAP allocation for each device. */
@@ -1119,9 +1129,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
+	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster->lock);
 
 	return found;
@@ -1303,8 +1311,27 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
+static bool swap_alloc_fast(struct folio *folio)
+{
+	unsigned int order = folio_order(folio);
+	struct swap_info_struct *si;
+
+	/*
+	 * Once allocated, swap_info_struct will never be completely freed,
+	 * so checking it's liveness by get_swap_device_info is enough.
+	 */
+	si = this_cpu_read(percpu_swap_device.si[order]);
+	if (!si || !get_swap_device_info(si))
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
 	int mask = folio_memcg(folio) ?
@@ -1482,7 +1509,11 @@ int folio_alloc_swap(struct folio *folio)
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
@@ -1901,7 +1932,9 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * Grab the local lock to be compliant
 			 * with swap table allocation.
 			 */
+			local_lock(&percpu_swap_device.lock);
 			offset = cluster_alloc_swap_entry(si, NULL);
+			local_unlock(&percpu_swap_device.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);
 		}
@@ -2705,6 +2738,27 @@ static void free_cluster_info(struct swap_cluster_info *cluster_info,
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
@@ -2788,6 +2842,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
+	flush_percpu_swap_device(p);
 
 	destroy_swap_extents(p);
 	if (p->flags & SWP_CONTINUED)
@@ -3222,7 +3277,6 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 			cluster = per_cpu_ptr(si->percpu_cluster, cpu);
 			for (i = 0; i < SWAP_NR_ORDERS; i++)
 				cluster->next[i] = SWAP_ENTRY_INVALID;
-			local_lock_init(&cluster->lock);
 		}
 	} else {
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
-- 
2.34.1


