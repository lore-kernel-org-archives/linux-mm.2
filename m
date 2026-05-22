Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7079CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C784F6B00A0; Thu, 21 May 2026 21:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49076B00A1; Thu, 21 May 2026 21:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FCD6B00A2; Thu, 21 May 2026 21:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A84F46B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:20:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B9FBC24EE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:20:25 +0000 (UTC)
X-FDA: 84793300410.25.6F04910
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 92B5A4000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:20:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aeFFxBqi;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779412823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlNjNHDfX0di3XL59bBl+Q1N8mPFOAdebVVOjRv4HBc=;
	b=8pqNkUMTJiRZ6QWPpXsxeqlV93OfR4WXBMr+rjM1aHZRctbFLsW6cAtFQJbeUzZJqI5xbW
	UFUnMba/8/2Kye42c8+Rie6RbqkPWtKDgkOtvc0pDmS6cvS1KWpJowNVbJv6U2jtRajRTA
	OMZWVZyrmpEB29sBworpMjimroWE2hU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aeFFxBqi;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779412823; a=rsa-sha256;
	cv=none;
	b=p0DZt/v1ZeabdSeg0hjuv96Ne2cBx36Ag4MP2Yfy4p2lVp/GWM8aV9fgICjccKs8HBTj+5
	Txq0eH2xgtzpC00uBUHa8ffkYD8SVNuPNaepqHI20ps/VGdz5QzL6dztLEHDbZFifti/ei
	DLFcpseWsZHnWmO+marV2inMntDFV+g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779412822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlNjNHDfX0di3XL59bBl+Q1N8mPFOAdebVVOjRv4HBc=;
	b=aeFFxBqiMwvPBNGunCTlbkXP6dV8fKhIvqc4g3guRjXOlvjY+erJhhFwA/mOrFRKh8UBTI
	CD7UV30JQZpdOnxg0Fn1nQNm1lcCY10X8x/iqAAaB5Cvh+HO5gWsUbmCfL0HUfTqYpYrRJ
	iEfJmO8xZUFjqZjBf8MXOFNUYu/VNVk=
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
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2 4/4] memcg: multi objcg charge support
Date: Thu, 21 May 2026 18:19:08 -0700
Message-ID: <20260522011908.1669332-5-shakeel.butt@linux.dev>
In-Reply-To: <20260522011908.1669332-1-shakeel.butt@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92B5A4000A
X-Stat-Signature: iydpmeattfo79y97e5fasnqb4ths7cwi
X-HE-Tag: 1779412823-54933
X-HE-Meta: U2FsdGVkX18ds89sectPbCFyfOAD1jtgv/ql1DacR1dwJvplCfKDNH633lKYY2u+y9tZksFmIb5CdnA7z/5Q65Xv+tqg5kvB8s08h97+6HI5gjmMmCAuekSINocxlb2mO1n/MoWVx+Dzbv55LVj+pbYHlNwpsw6gZJ3+Go9E7CVhbD1YxMYwSTZwCtYeo69039rrIct6rU+SEFQfBBQEenGv8lOGHV05GtaafGphZElZ2+kNBCxUUUuWfNqALlXFpATfkK/fa+s1UH3oaLLNqJfmGxMEntkFC3QDZrZnbCCYfFKBmJYEvh2Fv7s9VVxN4JZbt8EvO8mf5bU/45o6vIEf3h80AM2iINrfN/0XgRLCs0H9UN9zfj56842Ehohd2eqSy9mz1x5aY5YMD9m6iHIxfCXNIdi/jhaRuZJo/FgSC0NgRwR/zu8cFoQUCT+2HA+EA72GA7NYzjPC2Gn6sYTCwgwuz1ymDdfEchtwwqELlfK7IeqqacXwfs6ejibblDlOuTa09E2PtL+9kExSUkLuDCJYsw35LXlZheCeHuyLE/+w+rrWF6F5Vr0IRlqgGj38U0uK20/d0jj48ct+21ezMar4jmnT8ZBXZbu525FnDvKGEL3dKs1+fWluZSoGxh6x/97F+vmUq8rpCLvlUag7tszC03B2NMQ8Zua2cuQGkmC234ODg4cX9zEQ/ykg4KG9a4MRflWSQqn2SwAPBiTNjnvTt2TbpoWizQcMP/njAXMfp+hUG/jqhlsgmpIhrdr6wQmjukheapLoEx9LuPtH9tGnGmRZjjgA5Wi/Twd7rX1iGOaqtTj2JDVJI9otpyjg4v3dSJmMvpyvyefZfSO8wYqmrTdzsm/7qlYp5/NNen850nISDvzlBiCJ1DpAcn7ISXwo/uPOJPHhVwmYgcYXZ7OYWwCWE3aS32Uof7BVUc48PmuBnQfHQSl7SjItH0welq1t9CcIc6If5cB
 9VjUW4h/
 dMVoDC1IEoOlyquCLDRq+ghubbA+vxUL6hEaS/EL18lNfJDGL3TZ1POizc4oOlyMQUk7wcBUrM+LoJ1NhEfDaWE+9A3HSVeYcaeVL/rXWIBJRPEQWbLmjsNS4PmmFJBC9XthFKsF+SBDRciI83e9De6f8zbVhkVlQYg4o9mETJqVD9jcIjGqppEg/J9F7ZPfK94tmvr+WrT7Itiu2XyEHHFDZfIMXyyOw88HzSYn48dwiqTCFzbJM8GwgsL/cJlUoOTSvaiLyZwNzGk+H04cuh4GvSoy6GCHkIhIY1FfK5nW+c0I1YZqiTtEnxabO94SQ4lck
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
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: kernel test robot <oliver.sang@intel.com>
---

Changes since v1:
- Use round robin for drain

 mm/memcontrol.c | 188 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 136 insertions(+), 52 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 78c02451312b..ba17633b0bd0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -150,14 +150,14 @@ static void obj_cgroup_release(struct percpu_ref *ref)
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
 	 * 5) CPU0: we do release this object,
-	 *          92 bytes are added to stock->nr_bytes
+	 *          92 bytes are added to stock->nr_bytes[i]
 	 * 6) CPU0: stock is flushed,
 	 *          92 bytes are added to objcg->nr_charged_bytes
 	 *
@@ -2017,25 +2017,40 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
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
-	uint16_t nr_bytes;
+	int8_t index;
 	int16_t node_id;
 	int16_t nr_slab_reclaimable_b;
 	int16_t nr_slab_unreclaimable_b;
+	uint16_t nr_bytes[NR_OBJ_STOCK];
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
@@ -3153,12 +3168,13 @@ static void unlock_stock(struct obj_stock_pcp *stock)
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
@@ -3167,29 +3183,39 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
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
 
@@ -3230,10 +3256,16 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
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
@@ -3254,16 +3286,42 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 	return ret;
 }
 
-static void drain_obj_stock(struct obj_stock_pcp *stock)
+/* Flush the cached slab stats (if any) back to their owning objcg/pgdat. */
+static void drain_obj_stock_stats(struct obj_stock_pcp *stock)
 {
-	struct obj_cgroup *old = READ_ONCE(stock->cached_objcg);
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
+{
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
@@ -3289,46 +3347,43 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
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
-
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
+	/* Flush vmstat data when its owning slot is being drained. */
+	if (stock->index == i)
+		drain_obj_stock_stats(stock);
 
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
 
@@ -3342,6 +3397,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 {
 	unsigned int nr_pages = 0;
 	unsigned int stock_nr_bytes;
+	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3350,19 +3406,47 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
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
 
-	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
+	/* nr_bytes[] is uint16_t; flush if we would refill >= U16_MAX. */
 	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
 	    stock_nr_bytes > U16_MAX) {
 		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
@@ -3384,7 +3468,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			stock_nr_bytes = kept;
 		}
 	}
-	stock->nr_bytes = stock_nr_bytes;
+	stock->nr_bytes[slot] = stock_nr_bytes;
 
 out:
 	if (nr_pages)
-- 
2.53.0-Meta


