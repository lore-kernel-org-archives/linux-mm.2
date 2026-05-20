Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C8BCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C256C6B008A; Wed, 20 May 2026 01:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAEFD6B009B; Wed, 20 May 2026 01:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D7A6B009D; Wed, 20 May 2026 01:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97F196B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:32:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E5BA1C0086
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:32:17 +0000 (UTC)
X-FDA: 84786677514.22.A1FFFB2
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7DB4120002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:32:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aKP1eQ2O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYHpRVqTIOTPs8poaWY6JWzoP4/vBp/W0Ib884JadBM=;
	b=as3mSPfQp8uh+J0kply8xDxFpvXYY7nYCQCfjdw3bhpEIDOBH1yDsw1O8QohS/mcG+mlxC
	/vS+dxUoZcYA0Fj/QMKv8/ZWs2/UtFAYYusV3EIlma7rw3AAYxMlzy2p0Oga8VWLEP9+aL
	jklHXDkd2okdfHB8FbzVrL1sGVpskig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255135; a=rsa-sha256;
	cv=none;
	b=nDYam1cBS1VHBWPG6uTZACR7XDf84cdw0sEFkEz39FCvTBV5vLZCfEoeqK7GNe01FiHkWt
	yk8dM/zxDHGgZtkRvKrjc83wmGsj68RD6QW6w8hHdJYcgDctXC3wqm1jehw9C74UTyjVhu
	VMmBpbRtLOUiT3eZbYC1ueIGgRsIRcU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aKP1eQ2O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779255134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WYHpRVqTIOTPs8poaWY6JWzoP4/vBp/W0Ib884JadBM=;
	b=aKP1eQ2OWIiH+OkE2FsHyXPXO2I9NnQh9i6MNR0MBo9a3tA6SU413D11muMhrpD+zRoW1h
	ceLNN5KZkOUGqUSTUuHTVm8U5FlhPwCplfeyVwu+Zq/PCjg0YnZiA99esR4Ygx9eRtr+DG
	+1CFOdllAn4deiMztZV53eSWPUxJWs0=
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
Subject: [PATCH 4/4] memcg: multi objcg charge support
Date: Tue, 19 May 2026 22:31:22 -0700
Message-ID: <20260520053123.2709959-5-shakeel.butt@linux.dev>
In-Reply-To: <20260520053123.2709959-1-shakeel.butt@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DB4120002
X-Stat-Signature: zioj7sdrwm8fe39mqwx8e4qxw393n3d6
X-Rspam-User: 
X-HE-Tag: 1779255135-852337
X-HE-Meta: U2FsdGVkX19+eqehCCpPLR7JXw6j/sE7q+ySv6eTDg9G4JpVQ/qaAjFppc6lIH3s8KawjYnH5uUIrQUiR1JdVYid+xcdUW9gpGo4nsmOv9GsGkurQsu2s1/k7kheDHuL4I3ExVvM3uzR2qYFKGInPvHDpYxBo61bu4j2Kt0azcR3JQME1s8oJbrdVVaTp3iYnQLdiNTX3LtxFjB+a1ffxjB1SaC5hwO8YjoaLeAyzV34u3y2peljP5iAlGdXg3ecQyNlm3dGRlqQ8lPsWjVKbIwVzTX499ks/de/DyFDd0m5habNTUrgRJ3r+EaSnITxDOkaRxU96H3Of5Ts6mdQvUI1DKQjMLX9q2tlojbhVEK4ykgkFE3+6COCMuiC0UxurSlwUyajQ+DkFRsd+Fo2TqsrdWjjHPjZTpRFo+W8AJIsLg83VH3D+SCswF8QrMYMz97njJV8wtG5QCwiwmqvyqs3LfPvbAvdbtgevqfCB+9WXdVr13vfOnZKz6Bi2n6kjSfV/AgmJkMZCCYvEvHFlo+4beNE2gSkgVn1x5LCOsqKmbC2MM1O9twFdpSWjSaEw1mAZxKLCmDY7wGxzyLTGj6mEJrBnZaPotBB/VxGfd9vmLHhiYFD05s3qCYh9abgARujkUwi8i9xJP/acMHQzHYUjqleCAChxTTeAnQr3cD35YuBFa+yDSwxZxFI0fHOCkDMt+EHb/hovPkA9wjHJfsLhRYmPbIYxd8isbBr+64f8m/bjNY5EYFjjftDFJ1qYv62K4gwPyiHdoMzu4TsAYVA2fiJcgdofeIO4clKQ6A7LTKnZKrRMUW6soz+0io11jxYTssF+9SOzzEAoVowYgFI/DoEOhSzzBvlRofrrx9ooiJSOtnM70uG40zORab2zN0wCXGxOLKMGMvH2MRrmly32267B/fL6FXGVIAYBf/KgWQSzs2QW20ZhhvssTP4bu2Q/aipBddeiXZXjdC
 6IeJJROE
 Ay1psUp2jfH98xbItyNsaLQiZBN9TwQYaa6O7wWmqZf8FJCDk1fC42/zjrHsJ/klgJJpNS6g+Oer3kvukbx12lwkgfhcxvMWG4qdU69KEbfxKDi9fK7+hXCUGC0N05h+iQhLlQcY65Tr77EVJlLvMr5i/4dlr6cBfpcKyk667kKnXV9nDMMPy9dkrgKXlU2eWdYAZ81PVI0vS8Jf15kQw4dukbo2JaVaLIUX3D3QuV/G8HBah1FN0Q4KZaGtYnHYmIf3e9zcYZ2E9ktdfOASesXXXbA6bNouYGh6kWjmcJ+EJ527hHzXG3Nm868HhbwdGnHmc
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
 mm/memcontrol.c | 185 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 133 insertions(+), 52 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ed27fd06850..52104cbb8e7c 100644
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
@@ -2017,13 +2017,25 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
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
-	uint16_t nr_bytes;
-	struct obj_cgroup *cached_objcg;
+	int8_t index;
 	int16_t node_id;
 	int16_t nr_slab_reclaimable_b;
 	int16_t nr_slab_unreclaimable_b;
+	uint16_t nr_bytes[NR_OBJ_STOCK];
+	struct obj_cgroup *cached[NR_OBJ_STOCK];
 
 	struct work_struct work;
 	unsigned long flags;
@@ -2031,11 +2043,13 @@ struct obj_stock_pcp {
 
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
@@ -3153,12 +3167,13 @@ static void unlock_stock(struct obj_stock_pcp *stock)
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
@@ -3167,29 +3182,39 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
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
 
@@ -3230,10 +3255,16 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
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
@@ -3254,16 +3285,42 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
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
@@ -3289,46 +3346,43 @@ static void drain_obj_stock(struct obj_stock_pcp *stock)
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
 
@@ -3342,6 +3396,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 {
 	unsigned int nr_pages = 0;
 	unsigned int stock_nr_bytes;
+	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3350,19 +3405,45 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
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
+			slot = get_random_u32_below(NR_OBJ_STOCK);
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
 	    stock_nr_bytes >= U16_MAX) {
 		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
@@ -3384,7 +3465,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			stock_nr_bytes = kept;
 		}
 	}
-	stock->nr_bytes = stock_nr_bytes;
+	stock->nr_bytes[slot] = stock_nr_bytes;
 
 out:
 	if (nr_pages)
-- 
2.53.0-Meta


