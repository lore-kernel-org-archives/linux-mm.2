Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AF2CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0041D6B0099; Mon, 25 May 2026 23:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6686B009B; Mon, 25 May 2026 23:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C1A6B009D; Mon, 25 May 2026 23:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFBD06B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:40:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 902A81A0270
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:40:46 +0000 (UTC)
X-FDA: 84808169292.24.7174D00
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id EBECA80005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:40:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=McHK5WBs;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1B1lhPvwFLpaQnVeTjh5KbW805w3yZ9wP5YKB0Mh3YE=;
	b=5ni0Sx580v5RpaiXXby58rV1LfF85Do1KrkbrWq209x9ZOIl700Y1HuJDOTgs+pLDZoV8p
	ejxVuiizJNwS2pBbFtYA+Rc1pfIC/eG2029EboIEfFxuX8Cc1xlbPWbNim7f45URH499yo
	kSvGk2/1y/FuirNt4OAUZpfjzyA8xn4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=McHK5WBs;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766845; a=rsa-sha256;
	cv=none;
	b=JWdEADXXBvxNBBPIAehbJaYXFAzk3eHAtPkCSRSXhMfX0cN3AJmUya4pcyUqQJXAqSNaYB
	9hAqdM99y4OJm+DU/hOdIDGUbe87DL25zxi4MISh1MgGDaom7Yw1iYUkdqG3X99AIN3KRU
	ArDh0sroSGLmtygOUzgmlXgsoyS/0qQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779766843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1B1lhPvwFLpaQnVeTjh5KbW805w3yZ9wP5YKB0Mh3YE=;
	b=McHK5WBst/C+8zOowyPO2acZH+vRAYVl9AGZkF5ZIUawcncJtwTtbkjJyNsyfFBKzgvMjt
	oAyDZlKjX6ooUOBS6Ir0KFCGkOX5+1S54lVso/AZvEUIdcT6uLikNUcA5Jkk5raxooD6hT
	+6tM/kH054wVpQH+ju7iohmqUGk40SY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3 4/4] memcg: multi objcg charge support
Date: Mon, 25 May 2026 20:39:31 -0700
Message-ID: <20260526033931.1760588-5-shakeel.butt@linux.dev>
In-Reply-To: <20260526033931.1760588-1-shakeel.butt@linux.dev>
References: <20260526033931.1760588-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBECA80005
X-Stat-Signature: gixdmuocc8dh15fpzgnub9ai4brh3kgs
X-HE-Tag: 1779766844-72265
X-HE-Meta: U2FsdGVkX19H/IbnD+qs6Vhc95pUPCioZLKcE68vvsEZyEUnuREkK7gUf7ky9ErolGJ1FaaShm5azv05DVqOv0u86uNkjSQmpsBmQkEt060w55jjfxCMzRors63/GA4+nWbsHyIMRkCP7koGJPdEV+KjtWzjjiL2AWz/PS+q76bnlS4NT7sVotpyy1WFIwpFpA+WW7omakEHSBr7k/S67MQL4uPlUGDn86HG8O4znzDkQm6ivwuJ/V+KwW4uBnJA4510sXewLl3gnSlsVOhgg4COiV804pBak6xi4YXBSCA6aJY1UeqiAhMNzilA9pmhuAhZogMYj9/A8vfXtAxq3FYBj5OJMIvmYmQusJ1oT/THRPKUnmGZSISv9S2cvzqF4o/M+3UpSDZaI/LEY89UCdbsxy5eiAI3ELyrhgbkNoftEwaLSakpzYZBWH/Aq8UZltwKgjl9DHiRRkVe6VZ+lCCt8Hp81JX/B+fWI2/jWa+vUduKnbjZ4oBGLyQY84wRYHLSageXQG1j9NV9UnwJ6MALe8K+Zmxq4O1X+GaWZQbkH+Zf57I1dAfJZaCSDwgM+Z3K/zYk+vKsDdAM6Fu9BhjHCsIVYZ7TWFRvy/1uFzBwAz0AQ13ZN29m2EDrR05SuspC6LD0Oe9MyXtvajn5tyFwhHkWcXc8PNX6mlK75jLC79EADmk8Z+ePXHhoTJx7dn43ZDnRT+ZJJdESiWPbfLtSWFpyUB/5JFQfibilbZ3c63XCUDF9HpCvGIbRZ60zare8ax2IcwXt6n5gAnGHwxtpXYGCCrz8c6XbJRyDyayC7P3ROga+6I5onetZLXifaoEvhrQ7UOUQiY4xgOSJMxIsTPeHLLUJvJOFlIaU9cMPvP1sX+ojaesHP7MCRsCEvgccMNEC7IpMu7HrZ+jsek5RHQznUYhEjPZ5/jq5KU2oJ3HqBCtiwIYT0c0Y4GvP2H4XZDhumWSm4W6qX3M
 kVcd3l5P
 chG55H8HcC/X5ZT9n2esElow2v050vI2/ltS7Z6QTE/dXtDZhR1OOcWFU6LajgRs4RzqoAL90636/beiCL0b9jtErfZQkmExEkmXD+wpyGaQTKFBeWLAuCJzKyL+3zzT7BOt1wv0Sn2v8RX2g+0E6TeBPIqV0OQ5t11PwXoPqMaLODgVqRiCEd74Rj581LN55qXEmwgcsyX1B8zSMk/WPk+ZR54uq6XwbXY0udQ+tgFeYvDosFgAJ2EUS+BMS6aBnetDmN81pY8bmnuG3l9Rja6m0O5siIdzfcl9r4V7BO6fUjNKtCByCrMoSJqvT3r+kP2W8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node so that reparenting LRU folios can take per-node lru locks. As a
side effect, the per-CPU obj_stock_pcp -- which caches exactly one
cached_objcg -- thrashes on workloads where threads of the same memcg
run on different NUMA nodes. The kernel test robot reported a 67.7%
regression on stress-ng.switch.ops_per_sec from this pattern.

Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
slots on consume/refill/account, prefer empty slots when inserting,
and evict a random slot only when full. With multiple slots a CPU can
hold the per-node objcg variants of one memcg plus a few siblings
without ever forcing a drain.

A single int8_t index records which slot the cached slab stats belong
to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
= 5 the layout (verified with pahole) is:

  offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
  offset 8  : nr_bytes[5]                                     = 10B
  offset 18 : padding                                         = 6B
  offset 24 : cached[5]                                       = 40B
  offset 64 : (line 2) work_struct + flags (cold)

so consume_obj_stock, refill_obj_stock and the slab account path each
touch exactly one 64-byte cache line on non-debug 64-bit builds.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v2:
- fix comments (Muchun)

Changes since v1:
- Use round robin for drain

 mm/memcontrol.c | 200 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 142 insertions(+), 58 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 24b6519eed9d..d5687e0797a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -150,15 +150,15 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	 * However, it can be PAGE_SIZE or (x * PAGE_SIZE).
 	 *
 	 * The following sequence can lead to it:
-	 * 1) CPU0: objcg == stock->cached_objcg
+	 * 1) CPU0: objcg cached in one of stock->cached[i]
 	 * 2) CPU1: we do a small allocation (e.g. 92 bytes),
 	 *          PAGE_SIZE bytes are charged
 	 * 3) CPU1: a process from another memcg is allocating something,
 	 *          the stock if flushed,
 	 *          objcg->nr_charged_bytes = PAGE_SIZE - 92
-	 * 5) CPU0: we do release this object,
-	 *          92 bytes are added to stock->nr_bytes
-	 * 6) CPU0: stock is flushed,
+	 * 4) CPU0: we do release this object,
+	 *          92 bytes are added to stock->nr_bytes[i]
+	 * 5) CPU0: stock is flushed,
 	 *          92 bytes are added to objcg->nr_charged_bytes
 	 *
 	 * In the result, nr_charged_bytes == PAGE_SIZE.
@@ -2018,34 +2018,49 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
 };
 
+/*
+ * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
+ * (lock, accounting metadata, nr_bytes[] and cached[]) fits within a
+ * single 64-byte cache line on non-debug 64-bit builds. With 5 slots:
+ *   lock(1) + index(1) + node_id(2) + slab stats(4) + nr_bytes(10)
+ *   + pad(6) + cached(40) == 64 bytes.
+ * A CPU can thus consume/refill/account against five different objcgs
+ * (typically per-node variants of the same memcg) while incurring at
+ * most one cache miss on the stock.
+ */
+#define NR_OBJ_STOCK 5
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	struct obj_cgroup *cached_objcg;
+	int8_t index;
+	int16_t node_id;
+	int16_t nr_slab_reclaimable_b;
+	int16_t nr_slab_unreclaimable_b;
 #if PAGE_SHIFT > 16
 	/*
 	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
 	 * keep nr_bytes to unsinged int as uint16_t cannot represent the full
-	 * sub-page remainder.
+	 * sub-page remainder. Such archs are not cacheline optimization target.
 	 */
-	unsigned int nr_bytes;
+	unsigned int nr_bytes[NR_OBJ_STOCK];
 #else
-	uint16_t nr_bytes;
+	uint16_t nr_bytes[NR_OBJ_STOCK];
 #endif
-	int16_t node_id;
-	int16_t nr_slab_reclaimable_b;
-	int16_t nr_slab_unreclaimable_b;
+	struct obj_cgroup *cached[NR_OBJ_STOCK];
 
 	struct work_struct work;
 	unsigned long flags;
+	uint8_t drain_idx;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct obj_stock_pcp, obj_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.index = -1,
 	.node_id = NUMA_NO_NODE,
 };
 
 static DEFINE_MUTEX(percpu_charge_mutex);
 
+static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i);
 static void drain_obj_stock(struct obj_stock_pcp *stock);
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
@@ -3165,12 +3180,13 @@ static void unlock_stock(struct obj_stock_pcp *stock)
 		local_unlock(&obj_stock.lock);
 }
 
-/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
+/* Call after __refill_obj_stock() so a slot for objcg exists in the stock */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	int16_t *bytes;
+	int i;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3179,29 +3195,39 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 	 */
 	BUILD_BUG_ON(MAX_NUMNODES >= S16_MAX);
 
-	if (!stock || READ_ONCE(stock->cached_objcg) != objcg)
+	if (!stock)
+		goto direct;
+
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		if (READ_ONCE(stock->cached[i]) == objcg)
+			break;
+	}
+	if (i == NR_OBJ_STOCK)
 		goto direct;
 
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
-	 * accumulating over a page of vmstat data or when pgdat changes.
+	 * accumulating over a page of vmstat data or when the objcg slot or
+	 * pgdat the stats belong to changes.
 	 */
-	if (stock->node_id == NUMA_NO_NODE) {
+	if (stock->index < 0) {
+		stock->index = i;
 		stock->node_id = pgdat->node_id;
-	} else if (stock->node_id != pgdat->node_id) {
-		/* Flush the existing cached vmstat data */
+	} else if (stock->index != i || stock->node_id != pgdat->node_id) {
+		struct obj_cgroup *old = READ_ONCE(stock->cached[stock->index]);
 		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
 
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
+			mod_objcg_mlstate(old, oldpg, NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
+			mod_objcg_mlstate(old, oldpg, NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
+		stock->index = i;
 		stock->node_id = pgdat->node_id;
 	}
 
@@ -3231,10 +3257,16 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
-	    stock->nr_bytes >= nr_bytes) {
-		stock->nr_bytes -= nr_bytes;
-		return true;
+	int i;
+
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		if (READ_ONCE(stock->cached[i]) != objcg)
+			continue;
+		if (stock->nr_bytes[i] >= nr_bytes) {
+			stock->nr_bytes[i] -= nr_bytes;
+			return true;
+		}
+		return false;
 	}
 
 	return false;
@@ -3255,16 +3287,42 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 	return ret;
 }
 
-static void drain_obj_stock(struct obj_stock_pcp *stock)
+/* Flush the cached slab stats (if any) back to their owning objcg/pgdat. */
+static void drain_obj_stock_stats(struct obj_stock_pcp *stock)
+{
+	struct obj_cgroup *old;
+	struct pglist_data *oldpg;
+
+	if (stock->index < 0)
+		return;
+
+	old = READ_ONCE(stock->cached[stock->index]);
+	oldpg = NODE_DATA(stock->node_id);
+
+	if (stock->nr_slab_reclaimable_b) {
+		mod_objcg_mlstate(old, oldpg, NR_SLAB_RECLAIMABLE_B,
+				  stock->nr_slab_reclaimable_b);
+		stock->nr_slab_reclaimable_b = 0;
+	}
+	if (stock->nr_slab_unreclaimable_b) {
+		mod_objcg_mlstate(old, oldpg, NR_SLAB_UNRECLAIMABLE_B,
+				  stock->nr_slab_unreclaimable_b);
+		stock->nr_slab_unreclaimable_b = 0;
+	}
+	stock->index = -1;
+	stock->node_id = NUMA_NO_NODE;
+}
+
+static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
 {
-	struct obj_cgroup *old = READ_ONCE(stock->cached_objcg);
+	struct obj_cgroup *old = READ_ONCE(stock->cached[i]);
 
 	if (!old)
 		return;
 
-	if (stock->nr_bytes) {
-		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
-		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
+	if (stock->nr_bytes[i]) {
+		unsigned int nr_pages = stock->nr_bytes[i] >> PAGE_SHIFT;
+		unsigned int nr_bytes = stock->nr_bytes[i] & (PAGE_SIZE - 1);
 
 		if (nr_pages) {
 			struct mem_cgroup *memcg;
@@ -3290,46 +3348,43 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
 		 * so it might be changed in the future.
 		 */
 		atomic_add(nr_bytes, &old->nr_charged_bytes);
-		stock->nr_bytes = 0;
+		stock->nr_bytes[i] = 0;
 	}
 
-	/*
-	 * Flush the vmstat data in current stock
-	 */
-	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
-		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
+	/* Flush vmstat data when its owning slot is being drained. */
+	if (stock->index == i)
+		drain_obj_stock_stats(stock);
 
-		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(old, oldpg,
-					  NR_SLAB_RECLAIMABLE_B,
-					  stock->nr_slab_reclaimable_b);
-			stock->nr_slab_reclaimable_b = 0;
-		}
-		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(old, oldpg,
-					  NR_SLAB_UNRECLAIMABLE_B,
-					  stock->nr_slab_unreclaimable_b);
-			stock->nr_slab_unreclaimable_b = 0;
-		}
-		stock->node_id = NUMA_NO_NODE;
-	}
-
-	WRITE_ONCE(stock->cached_objcg, NULL);
+	WRITE_ONCE(stock->cached[i], NULL);
 	obj_cgroup_put(old);
 }
 
+static void drain_obj_stock(struct obj_stock_pcp *stock)
+{
+	int i;
+
+	for (i = 0; i < NR_OBJ_STOCK; ++i)
+		drain_obj_stock_slot(stock, i);
+}
+
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
 {
-	struct obj_cgroup *objcg = READ_ONCE(stock->cached_objcg);
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool flush = false;
+	int i;
 
 	rcu_read_lock();
-	if (objcg) {
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		objcg = READ_ONCE(stock->cached[i]);
+		if (!objcg)
+			continue;
 		memcg = obj_cgroup_memcg(objcg);
-		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
+		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg)) {
 			flush = true;
+			break;
+		}
 	}
 	rcu_read_unlock();
 
@@ -3343,6 +3398,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 {
 	unsigned int nr_pages = 0;
 	unsigned int stock_nr_bytes;
+	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3351,16 +3407,44 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	stock_nr_bytes = stock->nr_bytes;
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
-		drain_obj_stock(stock);
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
+
+		if (!cached) {
+			if (empty_slot == -1)
+				empty_slot = i;
+			continue;
+		}
+		if (cached == objcg) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot == -1) {
+		slot = empty_slot;
+		if (slot == -1) {
+			slot = stock->drain_idx++;
+			if (stock->drain_idx == NR_OBJ_STOCK)
+				stock->drain_idx = 0;
+			drain_obj_stock_slot(stock, slot);
+		}
 		obj_cgroup_get(objcg);
+		/*
+		 * Keep the xchg result in the unsigned int local; storing
+		 * it directly into stock->nr_bytes[slot] (uint16_t) would
+		 * silently truncate values >= U16_MAX and bypass the flush
+		 * guard below, leaking page-counter charges.
+		 */
 		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
-		WRITE_ONCE(stock->cached_objcg, objcg);
+		WRITE_ONCE(stock->cached[slot], objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
+	} else {
+		stock_nr_bytes = stock->nr_bytes[slot];
 	}
+
 	stock_nr_bytes += nr_bytes;
 
 	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
@@ -3368,7 +3452,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
 		stock_nr_bytes &= (PAGE_SIZE - 1);
 	}
-	stock->nr_bytes = stock_nr_bytes;
+	stock->nr_bytes[slot] = stock_nr_bytes;
 
 out:
 	if (nr_pages)
-- 
2.53.0-Meta


