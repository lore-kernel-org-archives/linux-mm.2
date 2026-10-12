Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABDFCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A1E6B008C; Mon, 12 Oct 2026 15:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11ACF6B009F; Mon, 12 Oct 2026 15:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009456B00A0; Mon, 12 Oct 2026 15:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1E016B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:02:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40AA1C1272
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:02:30 +0000 (UTC)
X-FDA: 85314895260.03.21F056C
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id 73C621C0005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:02:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b="K9WMZc/y";
	spf=pass (imf21.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831748;
	b=R68Dxy7LoOsq1LMh8tVmb/dxyOkU02u8DfTdrvr6gmRXAqEHcBiL12QAU9MusabyFn68Nq
	X5FT3W8VDaVuuQOSDfSlfiSI5gZvQ1H4L0bzgJ56OCvJzrU8/7UniyJeUu8+YdhVMMMUDX
	DybtJS+3+IzBLDNV6sQdY40IcpKcwf8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b="K9WMZc/y";
	spf=pass (imf21.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rpUxj5+cK+J5FYBmGR/RKb3KIHKIOL+5k8cmo33kkU=;
	b=KiwPbYkQt8g1XklAJlW6EC1lTyfAkPdIZvZO6wfyKPq9h/5o1yHO9GLkyiY0QJMGu1LLiK
	Rta6mLUzuPxn4Pl/uQg/C0aS4ZwufM0Of0eVVSfsJ+hvUXs4RTg5IyLOl7psLGcCsBe8Pk
	x+zT5ododSedwGBP5ptBy/j7sOy1OQM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=1rpUxj5+cK+J5FYBmGR/RKb3KIHKIOL+5k8cmo33kkU=; b=K9WMZc/yZDIsHsyUubc
	e8o2AqKfL8r472yeKgADfnsnsN1LznVhRsncripZxcVVutqyQCxDv+BwrwywXZc7PQDvuiwgU9p+W
	GZBfOfO18VUfVLoy8wO532HHT2u/14HBWSGx0/ZVRnhfDRKhXwSptpMt6ExpNS2W5cmQOKhB8KKiN
	mrX0rZ+b7EvbtgCNSpIHnQIkmBETIj0rmjn3Q5VC8Kb/MmEh1HYVC7aETyOiLTLpFEPOhx+obXfkD
	9sWT3MeS4SUHlNP6rhEXAfEelTJVqCIH13h3zVWHvw42eusQoziOZ+clE5aUEDeeCADpt9YInAygZ
	4hZs3azYVhb4CZg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLEZ-007syj-0b;
	Mon, 12 Oct 2026 21:02:12 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 12 Oct 2026 21:02:14 +0200
Subject: [PATCH 2/2] mm/shrinker: allocate the per-memcg shrinker units on
 demand
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-2-5a7608393b7a@virtuozzo.com>
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
In-Reply-To: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12284;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=aJw1rGLsnXWkHoN9DEyky9J/+kGWZREd6gFxYzI+e4I=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS67g6wQ9GAkom/eKHrzDdDNWl0cvqCRKRMAb
 bNXRZPyuDmJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uuwAKCRBRlgpH+WFc
 KrA+EADFzH7AlhM4wMQ8hNt/hgwZBJO3petVqYAjC1vkb/XoQthec5rmr3Q1SOqdfU5GSS1Xb91
 qWbz62OY1Kmaqca+MWg6n4at3RQYtmA07PyM3CGOAfSPBVStlZK/TyC+n4m67LhtwvdAMHa7X9z
 7ihjwgF1H0YnA/r1Osd8nqQcC1/fDTtOMI/YgJnzLc16Q6ySoY1Z1XQUW2nIW6BFt/X4qZk4/Ex
 qor1zJp4lSSQc7TA08An3RTb5rhCkITRpGDXz1uD8c9ot7mlE55XiKRugVAWYBwOUQJhE8ben9t
 biVGmDAPs6b/DyPUBLr+iip1rgsP3SI8sAXCedZYrpRD1HtByupOiM1iINKSnyBluD8MovA4zwq
 FZZg6eMDgf7ztyrSxLw2gvjxysL3TnQwa2dgPRiSFFxmrF41x4A67nXe3So7r/iBynp2EaxCJoA
 MTKYYYyvA5t3HoTi8ZAUDBypM0QNrWwxFZp/A3GGVrPT5zYs+ANQQFEsLNT97X+mXi18SKucsM/
 M8kCV0TvIDkHDkhYdEGwARPmfwsxrKnJXxPK1FxFsLyAPD4EGxjVpYYg73nWhVHTPM97L3i9DC9
 /uAJTL2rNAfZpNCrMKTawTNGbRw6cEiso3ntsuBNZpOkHOLSQdk85xLnBxoupJ621oERBmRAYRX
 Nr2Twu0PknheYHA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 73C621C0005
X-Stat-Signature: qayqjmna9u9rzmews8u9a4jkqcd3zh7k
X-HE-Tag: 1791831748-290657
X-HE-Meta: U2FsdGVkX183UKDK9NP8OfRjpysBdOcugw+Wji44VU3DV8tQX3LZvBGvwhqY6BkWvGbDfa9dg7FlMo5hZtH+ZfF3efKG+kDeSGIq69IsO2NoCGZa3317LBG2o9EpltkvaCEUkzRhJKPIna3KRiv3G9QQmP+EF4amT1h1KjzQUwBjHlbxE6JbgbzpZpPZZ24XnthMijf8zvJIvj3oJRQBq6NIHNQtVmuhAirOakj5VJrlemL2JnO65G5pweUHPHINLmH9j4aMCVvGOLIzaXb2pPcL1aR61pgVdsUvUe8z6Mtr0ATyxIW40aeYI+3v1CGe33NL10fRLbj9y3/rXH47hR8WGcX7qx0Ypb8pH0bh2QMc6POygs3QZfkbUAjfARiBzlth/Akh8EiyWtz7WTOL8Zly34kY/tfkCDF5vdbLYgCDNbl5CaDNSExEAgDQLhaYe6ZOSQVDa2JdKdHZj+UfSFXpuMZdij0/58mDKYqRjRjQEA0sGPdOjeIL4bWc1rWw8H3fRLXPmRQOWVouISr1aMazGSxzp3LhRrH1+n2bOezMnCDvOIn1OUhIoHGCOxi0YFys3y8g2P9c6U6i/R5hK8PNxpoR1TYUIg/9dv15Rnk3S8bmtLXuat323GlegXD7Y6ImlkRaHa7JxebFAJIygBXHM1bUB36b489RR38bLOdY+qaxfBchJaKEsmmHfuw1L1LZoNclqN/c8TK5IFC9wJ9Z+U9m5ToOAFogAxfAfaFMgXBU5TADlywQ4KxlG2OiOt/L9GIiweWbvErCtRVOsiYK2I6Lmj9XiH9a2RAGOvgULhn1h3GdpojLdlc2pX5P8ojojLitYcOI5dDl5DCTB7r75Gug0n0Op2WhS10dqxN3K1eo8NE9D3rBJDC5nGd0pppmy4/U2+VIMRBdpxqGIFuJQ1lj0Dg5mhPVbL66sx9hK0XDq/Ah5lLROganE8AX8GuEasNjUTLWUwXqwH2
 tHQ8cvSC
 nnF5qFZ3hrgJyitC3Z6Nfl8+Q0P7ukJjZnckXNjVqq0kgLatLq6f1J/WQXEieF0Ds3ZOxdLyhEI1OcBkxRhwMJbGj9YJPGUoEf4PocAzSfliI27r0tx3owbtmzQxA4g+uYY5ULIp3wTP5BPAsFUqUb/dQRq+/xga8bVTKftmOsta0xUR5xNDagXd7z0tiq9NPrvtuVMcuIM9WNCEb/27x/F+ia2dSGEAYn9fsY4cfmLAV7wIQ8tvJ0BUF7Il2SUOQyqBykwjWnstcys89kOpuygOQua6baEituTl3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A memory cgroup allocates a shrinker_info_unit for every
SHRINKER_UNIT_BITS ids up to shrinker_nr_max on every NUMA node when it
comes online, whether or not it will ever hold objects of those
shrinkers. Every superblock registers a memcg-aware shrinker, so on a
host with many mounts each new cgroup pays for all of them while its
tasks touch a few.

A map bit is only ever set on a memcg that holds a list_lru list of
that shrinker. So the point where a memcg gets such a list is the one
place a unit can be installed ahead of its first use, and that is where
it is installed.

The rule the code now relies on:

  A non-root memcg that has a list on a list_lru has the unit of that
  list's shrinker, on every node.

It holds because:

  - the unit is installed before the list is published;
  - a unit lives until the memcg is freed.

So set_shrinker_bit() always finds the unit. A reader that finds none
knows the memcg never held objects of that shrinker: there is nothing
to walk and no deferred work.

There is one case where a memcg has no list: with cgroup.memory=nokmem
a list_lru is never per-memcg, but a SHRINKER_MEMCG_AWARE shrinker that
also has SHRINKER_NONSLAB still gets an id. If such a shrinker keeps
lists of its own and sets map bits itself, it has to call
memcg_shrinker_unit_alloc() first. No shrinker in the tree does.

The install runs with the gfp of the list allocation, possibly atomic,
so it cannot take shrinker_mutex. A spinlock orders it against the info
replacement in expand_one_shrinker_info() instead, so a unit cannot be
installed into an info that is being copied out of.

The root memcg keeps all its units: global reclaim keeps the deferred
work of memcg-aware shrinkers there, and root has no list allocation to
install them from.

The units of a memcg now scale with the number of shrinkers it and its
descendants hold objects of, not with shrinker_nr_max.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |   2 +
 mm/list_lru.c              |   6 ++
 mm/shrinker.c              | 159 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 138 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a88..a14f43c3a1b01 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1676,6 +1676,8 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
 #endif
 
 int alloc_shrinker_info(struct mem_cgroup *memcg);
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..7247b7c081b4c 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -597,6 +597,12 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			parent = parent_mem_cgroup(pos);
 		}
 
+		if (!css_is_dying(&pos->css) &&
+		    memcg_shrinker_unit_alloc(pos, lru_shrinker_id(lru), gfp)) {
+			kfree(mlru);
+			return -ENOMEM;
+		}
+
 		if (!mlru) {
 			mlru = memcg_init_list_lru_one(lru, gfp);
 			if (!mlru)
diff --git a/mm/shrinker.c b/mm/shrinker.c
index a9418072a509e..79f48fb7fa261 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -13,6 +13,14 @@ DEFINE_MUTEX(shrinker_mutex);
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
 
+/*
+ * Orders installing a unit against the pointer copy in
+ * expand_one_shrinker_info(). Installs run from the list_lru allocation
+ * path with the caller's gfp and cannot wait for shrinker_mutex; they can
+ * nest in the i_pages lock, which is taken from interrupts.
+ */
+static DEFINE_SPINLOCK(shrinker_unit_lock);
+
 static inline int shrinker_unit_size(int nr_items)
 {
 	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct shrinker_info_unit *));
@@ -30,9 +38,6 @@ static inline void shrinker_unit_free(struct shrinker_info *info, int start)
 	nr = DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
 
 	for (i = start; i < nr; i++) {
-		if (!unit[i])
-			break;
-
 		kfree(unit[i]);
 		unit[i] = NULL;
 	}
@@ -96,7 +101,13 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 		if (!info)
 			goto err;
 		info->map_nr_max = shrinker_nr_max;
-		if (shrinker_unit_alloc(info, NULL, nid)) {
+		/*
+		 * Global reclaim keeps the deferred work of memcg-aware
+		 * shrinkers in the root's units, and root has no list_lru
+		 * allocation to install them from.
+		 */
+		if (mem_cgroup_is_root(memcg) &&
+		    shrinker_unit_alloc(info, NULL, nid)) {
 			kvfree(info);
 			goto err;
 		}
@@ -124,6 +135,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 {
 	struct shrinker_info *new, *old;
 	struct mem_cgroup_per_node *pn;
+	unsigned long flags;
 	int nid;
 
 	for_each_node(nid) {
@@ -143,13 +155,20 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 
 		new->map_nr_max = new_nr_max;
 
-		memcpy(new->unit, old->unit, old_size);
-		if (shrinker_unit_alloc(new, old, nid)) {
+		if (mem_cgroup_is_root(memcg) &&
+		    shrinker_unit_alloc(new, old, nid)) {
 			kvfree(new);
 			return -ENOMEM;
 		}
 
+		/*
+		 * A unit installed meanwhile lands in old before the copy or
+		 * in new after the publish.
+		 */
+		spin_lock_irqsave(&shrinker_unit_lock, flags);
+		memcpy(new->unit, old->unit, old_size);
 		rcu_assign_pointer(pn->shrinker_info, new);
+		spin_unlock_irqrestore(&shrinker_unit_lock, flags);
 		kvfree_rcu(old, rcu);
 	}
 
@@ -204,21 +223,26 @@ static inline int calc_shrinker_id(int index, int offset)
 
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
-	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
-		struct shrinker_info *info;
+	struct shrinker_info_unit *unit;
+	struct shrinker_info *info;
 
-		rcu_read_lock();
-		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
-			struct shrinker_info_unit *unit;
-
-			unit = info->unit[shrinker_id_to_index(shrinker_id)];
-			/* Pairs with smp mb in shrink_slab() */
-			smp_mb__before_atomic();
-			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
-		}
-		rcu_read_unlock();
-	}
+	if (shrinker_id < 0 || !memcg || mem_cgroup_is_root(memcg))
+		return;
+
+	rcu_read_lock();
+	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+	if (WARN_ON_ONCE(shrinker_id >= info->map_nr_max))
+		goto unlock;
+
+	unit = READ_ONCE(info->unit[shrinker_id_to_index(shrinker_id)]);
+	if (WARN_ON_ONCE(!unit))
+		goto unlock;
+
+	/* Pairs with smp mb in shrink_slab() */
+	smp_mb__before_atomic();
+	set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
+unlock:
+	rcu_read_unlock();
 }
 
 static DEFINE_IDR(shrinker_idr);
@@ -263,14 +287,16 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
 static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 				   struct mem_cgroup *memcg)
 {
+	int offset = shrinker_id_to_offset(shrinker->id);
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
 
 	rcu_read_lock();
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
+	unit = READ_ONCE(info->unit[shrinker_id_to_index(shrinker->id)]);
+	/* No unit: this memcg never held objects of this shrinker. */
+	nr_deferred = unit ? atomic_long_xchg(&unit->nr_deferred[offset], 0) : 0;
 	rcu_read_unlock();
 
 	return nr_deferred;
@@ -279,20 +305,83 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 				  struct mem_cgroup *memcg)
 {
+	int offset = shrinker_id_to_offset(shrinker->id);
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
 
 	rcu_read_lock();
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred =
-		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
+	unit = READ_ONCE(info->unit[shrinker_id_to_index(shrinker->id)]);
+	nr_deferred = unit ? atomic_long_add_return(nr, &unit->nr_deferred[offset]) : 0;
 	rcu_read_unlock();
 
 	return nr_deferred;
 }
 
+static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index,
+				 gfp_t gfp)
+{
+	struct shrinker_info_unit *unit;
+	struct shrinker_info *info;
+	unsigned long flags;
+
+	rcu_read_lock();
+	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+	/* Online memcgs have an info, and ids are expanded into it first. */
+	if (WARN_ON_ONCE(!info ||
+			 index >= shrinker_id_to_index(info->map_nr_max)) ||
+	    READ_ONCE(info->unit[index])) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+
+	unit = kzalloc_node(sizeof(*unit), gfp, nid);
+	if (!unit)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&shrinker_unit_lock, flags);
+	/* memcg is pinned: only expand replaces info, and it holds the lock */
+	info = rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
+					 lockdep_is_held(&shrinker_unit_lock));
+	if (!info->unit[index]) {
+		/* Walkers read the pointer locklessly: publish a zeroed unit. */
+		smp_store_release(&info->unit[index], unit);
+		unit = NULL;
+	}
+	spin_unlock_irqrestore(&shrinker_unit_lock, flags);
+
+	kfree(unit);
+	return 0;
+}
+
+/*
+ * Called before @memcg gets a list on a list_lru of shrinker @shrinker_id,
+ * from the path that allocates the list. A map bit is only ever set on a
+ * memcg that has the list, so set_shrinker_bit() always finds the unit.
+ * A shrinker that sets map bits without a list_lru, such as a NONSLAB
+ * one under cgroup.memory=nokmem, must call this first.
+ */
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp)
+{
+	int nid, ret;
+
+	if (shrinker_id < 0 || mem_cgroup_is_root(memcg))
+		return 0;
+
+	for_each_node(nid) {
+		ret = shrinker_unit_install(memcg, nid,
+					    shrinker_id_to_index(shrinker_id),
+					    gfp);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
 	int nid, index, offset;
@@ -307,8 +396,17 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
 		for (index = 0; index < shrinker_id_to_index(child_info->map_nr_max); index++) {
-			child_unit = child_info->unit[index];
-			parent_unit = parent_info->unit[index];
+			child_unit = READ_ONCE(child_info->unit[index]);
+			if (!child_unit)
+				continue;
+
+			if (!READ_ONCE(parent_info->unit[index]))
+				shrinker_unit_install(parent, nid, index, GFP_KERNEL);
+			parent_unit = READ_ONCE(parent_info->unit[index]);
+			/* Drop the debt rather than fail the cgroup teardown. */
+			if (!parent_unit)
+				continue;
+
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
 				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
@@ -529,10 +627,13 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	if (index < shrinker_id_to_index(info->map_nr_max)) {
 		struct shrinker_info_unit *unit;
 
-		unit = info->unit[index];
+		unit = READ_ONCE(info->unit[index]);
 
 		rcu_read_unlock();
 
+		if (!unit)
+			goto next;
+
 		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
@@ -587,7 +688,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			freed += ret;
 			shrinker_put(shrinker);
 		}
-
+next:
 		index++;
 		goto again;
 	}

-- 
2.43.0


