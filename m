Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A503D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766866B0410; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC676B0417; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D011A6B0410; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 786EA6B0414
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AD40BA32C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:58 +0000 (UTC)
X-FDA: 84352495836.14.09F889F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6092A0012
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S/lOtIRxHMzz2ZqHjhrtmOnaRf1JQ4QlVJysp2Gmd14=;
	b=I7NHOzD9wn49F7miGYTzx3xZ016WSy5cf3vNBGCtV/3cVcohsthDluMqY78QvgwzP7b9EU
	uEkA4d+CaupcYO0fuE4hIA6UekCA2KnbqKqHqg0aCT4zRS/AnwR68QhoBrczADLgkolZlG
	5RelBPpBpwU+d0smZtFbeHLxiEuLAdw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=MRU61R2X3FudrgnI0pFyllg6DTCx4mQudoiLp5epcbX+MSdc2yLnU2Dm+rFo/7Ec8+krQL
	tAQ95HW5pvd9l+Yzkn+Cebs591f1urS8jjeF4qAPVvEpzQcs2PpWswwANgLMDN67Y0U8Hj
	Pwd3H8s6Oql08FNCF70iyMTZUkdJkPA=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dwTQP3fdMzKHMjv
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:56:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D56FE40574
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:46 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S3;
	Tue, 20 Jan 2026 21:57:46 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	ryncsn@gmail.com
Subject: [RFC PATCH -next 1/7] vmscan: add memcg heat level for reclaim
Date: Tue, 20 Jan 2026 13:42:50 +0000
Message-Id: <20260120134256.2271710-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Kw1UCF1DZF1xXrWDCw45Jrb_yoWkXF1DpF
	Z3JayYyws3JF13KwnIy3WUW34fAwn7Ww13J343Gr1fAr13t345Za12kr47ZFW5CF98Xr13
	J390kw1UWw4DZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUU9N3UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: B6092A0012
X-Stat-Signature: o8a95zz5nbikemdiyjzeydzctij7kq95
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768917471-104227
X-HE-Meta: U2FsdGVkX18M2OsXXyfFmvUmOqeOFBlF/DB7QvOD4OHJNdMkWTTTBVK1/AwVmq0uiWHEMuuClx5+6918IxcPWRsa0rzinqRTMBlEVxAcAVRn/ZCkPvvBfvxA0P+EqUH9x//ey6yqTvEsM7WCtEpQ3xJlBRwkvVz7p8xSeAf5oL6zETw2rfP3xm0kentnA8qFMpRji6yLYLaLAVsERUco9oSZv70xlRP59d5h2SFaMswkN9c6AeTJqZZMMGE4w4DaHW2FPmuRzu3hE+//Ty47GF5ZHnTUrkXtPY04FYkRCFPqJTZh9NYOdybIKhuDUAbAYPzOJZ5bwzYzUJ5KFlWprxnVKf7gDDYaad0E31qkybRvkCxg6K9+D4n0+q7Rz7L9+8n6IP7jAT3G5fCFnyJJU5NYpffEBt49RtaDoja8lQ1vMXuETqaVCBiiNftLtPZU4JzzCHo+KhBS08i5cX7L3XpQsqhLIlhO9wjUX2fb70+y2LjGvXNEsFLuxdUbZzcdLsnGXBvzr7R6j0I2JCxDRet7uMik/McucJCn2iNoTIpukBunNMjNx5x5mtDDHXwFGsapyTpYDgrg8jb5FxvaC0I0uZ/+mxbWaJbugmPtOxYVa3zRehtZAxM9pkwvdfO4dIu1dwIgHdM+rsCbs5LauQvwQVJHfjhDi2zMSltZyyUDB+akoTsa1G6ppRYdDiCXtS2RnFM2VFA/yjUHxh8gWCBWM3tQrVStMULdKOzpzpiC3yBYpmzC3eoB2SszhJ2VpYV/WpYYXpQyhxSlmurH3RtRJsYgCdhSy/MPhGLJfYawMzwBJeSrhNM4wiMrLncZGDdx2MakbHGFjcGofWD8wr7xb1fJlymb2OjuRi9spffGIUlUVI13hFIk63AyiKSzUuxV6qoJbKP8jU7pJ3xneZSUleaK/r11K2rcyCW5HGWnJdJN3ZkAJKoXO3GcZ41P2Hrzk/kt9OMwbRHjoqw
 4kHk+C/s
 eogipGy27WN8IXPMM9gtysqlwqK/aUfcmkpnNrWdq1TQRvVhBYI6PjbkWqJQnpl2jtCoHoftZpokT3prKt8AIOgR/jZNJlOEJe+s5QbEX7U8vMjpcPTcpVmBCwJS1U32vgMc7y74AC6YIDBSPDEgnHiPlfJOJutE9GqrG4sPYjIAtn9YmIwlYpZAU/OrX4LjumjTqCTEIr24KKfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The memcg LRU was originally introduced to improve scalability during
global reclaim. However, it is complex and only works with gen lru
global reclaim. Moreover, its implementation complexity has led to
performance regressions when handling a large number of memory cgroups [1].

This patch introduces a per-memcg heat level for reclaim, aiming to unify
gen lru and traditional LRU global reclaim. The core idea is to track
per-node per-memcg reclaim state, including heat, last_decay, and
last_refault. The last_refault records the total reclaimed data from the
previous memcg reclaim. The last_decay is a time-based parameter; the heat
level decays over time if the memcg is not reclaimed again. Both last_decay
and last_refault are used to calculate the current heat level when reclaim
starts.

Three reclaim heat levels are defined: cold, warm, and hot. Cold memcgs are
reclaimed first; only if cold memcgs cannot reclaim enough pages, warm
memcgs become eligible for reclaim. Hot memcgs are reclaimed last.

While this design can be applied to all memcg reclaim scenarios, this patch
is conservative and only introduces heat levels for traditional LRU global
reclaim. Subsequent patches will replace the memcg LRU with
heat-level-based reclaim.

Based on tests provided by YU Zhao, traditional LRU global reclaim shows
significant performance improvement with heat-level reclaim enabled.

The results below are from a 2-hour run of the test [2].

Throughput (number of requests)		before	   after	Change
Total					1734169    2353717	+35%

Tail latency (number of requests)	before	   after	Change
[128s, inf)				1231	   1057		-14%
[64s, 128s)				586	   444		-24%
[32s, 64s)				1658	   1061		-36%
[16s, 32s)				4611	   2863		-38%

[1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
[2] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/memcontrol.h |   7 ++
 mm/memcontrol.c            |   3 +
 mm/vmscan.c                | 227 +++++++++++++++++++++++++++++--------
 3 files changed, 192 insertions(+), 45 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index af352cabedba..b293caf70034 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -76,6 +76,12 @@ struct memcg_vmstats;
 struct lruvec_stats_percpu;
 struct lruvec_stats;
 
+struct memcg_reclaim_state {
+	atomic_long_t heat;
+	unsigned long last_decay;
+	atomic_long_t last_refault;
+};
+
 struct mem_cgroup_reclaim_iter {
 	struct mem_cgroup *position;
 	/* scan generation, increased every round-trip */
@@ -114,6 +120,7 @@ struct mem_cgroup_per_node {
 	CACHELINE_PADDING(_pad2_);
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
+	struct memcg_reclaim_state	reclaim;
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* slab stats for nmi context */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f2b87e02574e..675d49ad7e2c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3713,6 +3713,9 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 
 	lruvec_init(&pn->lruvec);
 	pn->memcg = memcg;
+	atomic_long_set(&pn->reclaim.heat, 0);
+	pn->reclaim.last_decay = jiffies;
+	atomic_long_set(&pn->reclaim.last_refault, 0);
 
 	memcg->nodeinfo[node] = pn;
 	return true;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4aa73f125772..3759cd52c336 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5978,6 +5978,124 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 	return inactive_lru_pages > pages_for_compaction;
 }
 
+enum memcg_scan_level {
+	MEMCG_LEVEL_COLD,
+	MEMCG_LEVEL_WARM,
+	MEMCG_LEVEL_HOT,
+	MEMCG_LEVEL_MAX,
+};
+
+#define MEMCG_HEAT_WARM		4
+#define MEMCG_HEAT_HOT		8
+#define MEMCG_HEAT_MAX		12
+#define MEMCG_HEAT_DECAY_STEP	1
+#define MEMCG_HEAT_DECAY_INTERVAL	(1 * HZ)
+
+static void memcg_adjust_heat(struct mem_cgroup_per_node *pn, long delta)
+{
+	long heat, new_heat;
+
+	if (mem_cgroup_is_root(pn->memcg))
+		return;
+
+	heat = atomic_long_read(&pn->reclaim.heat);
+	do {
+		new_heat = clamp_t(long, heat + delta, 0, MEMCG_HEAT_MAX);
+		if (atomic_long_cmpxchg(&pn->reclaim.heat, heat, new_heat) == heat)
+			break;
+		heat = atomic_long_read(&pn->reclaim.heat);
+	} while (1);
+}
+
+static void memcg_decay_heat(struct mem_cgroup_per_node *pn)
+{
+	unsigned long last;
+	unsigned long now = jiffies;
+
+	if (mem_cgroup_is_root(pn->memcg))
+		return;
+
+	last = READ_ONCE(pn->reclaim.last_decay);
+	if (!time_after(now, last + MEMCG_HEAT_DECAY_INTERVAL))
+		return;
+
+	if (cmpxchg(&pn->reclaim.last_decay, last, now) != last)
+		return;
+
+	memcg_adjust_heat(pn, -MEMCG_HEAT_DECAY_STEP);
+}
+
+static int memcg_heat_level(struct mem_cgroup_per_node *pn)
+{
+	long heat;
+
+	if (mem_cgroup_is_root(pn->memcg))
+		return MEMCG_LEVEL_COLD;
+
+	memcg_decay_heat(pn);
+	heat = atomic_long_read(&pn->reclaim.heat);
+
+	if (heat >= MEMCG_HEAT_HOT)
+		return MEMCG_LEVEL_HOT;
+	if (heat >= MEMCG_HEAT_WARM)
+		return MEMCG_LEVEL_WARM;
+	return MEMCG_LEVEL_COLD;
+}
+
+static void memcg_record_reclaim_result(struct mem_cgroup_per_node *pn,
+					struct lruvec *lruvec,
+					unsigned long scanned,
+					unsigned long reclaimed)
+{
+	long delta;
+
+	if (mem_cgroup_is_root(pn->memcg))
+		return;
+
+	memcg_decay_heat(pn);
+
+	/*
+	 * Memory cgroup heat adjustment algorithm:
+	 * - If scanned == 0: mark as hottest (+MAX_HEAT)
+	 * - If reclaimed >= 50% * scanned: strong cool (-2)
+	 * - If reclaimed >= 25% * scanned: mild cool (-1)
+	 * - Otherwise:  warm up (+1)
+	 */
+	if (!scanned)
+		delta = MEMCG_HEAT_MAX;
+	else if (reclaimed * 2 >= scanned)
+		delta = -2;
+	else if (reclaimed * 4 >= scanned)
+		delta = -1;
+	else
+		delta = 1;
+
+	/*
+	 * Refault-based heat adjustment:
+	 * - If refault increase > reclaimed pages: heat up (more cautious reclaim)
+	 * - If no refaults and currently warm:     cool down (allow more reclaim)
+	 * This prevents thrashing by backing off when refaults indicate over-reclaim.
+	 */
+	if (lruvec) {
+		unsigned long total_refaults;
+		unsigned long prev;
+		long refault_delta;
+
+		total_refaults = lruvec_page_state(lruvec, WORKINGSET_ACTIVATE_ANON);
+		total_refaults += lruvec_page_state(lruvec, WORKINGSET_ACTIVATE_FILE);
+
+		prev = atomic_long_xchg(&pn->reclaim.last_refault, total_refaults);
+		refault_delta = total_refaults - prev;
+
+		if (refault_delta > reclaimed)
+			delta++;
+		else if (!refault_delta && delta > 0)
+			delta--;
+	}
+
+	memcg_adjust_heat(pn, delta);
+}
+
 static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
@@ -5986,7 +6104,8 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	};
 	struct mem_cgroup_reclaim_cookie *partial = &reclaim;
 	struct mem_cgroup *memcg;
-
+	int level;
+	int max_level = root_reclaim(sc) ? MEMCG_LEVEL_MAX : MEMCG_LEVEL_WARM;
 	/*
 	 * In most cases, direct reclaimers can do partial walks
 	 * through the cgroup tree, using an iterator state that
@@ -5999,62 +6118,80 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	if (current_is_kswapd() || sc->memcg_full_walk)
 		partial = NULL;
 
-	memcg = mem_cgroup_iter(target_memcg, NULL, partial);
-	do {
-		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		unsigned long reclaimed;
-		unsigned long scanned;
-
-		/*
-		 * This loop can become CPU-bound when target memcgs
-		 * aren't eligible for reclaim - either because they
-		 * don't have any reclaimable pages, or because their
-		 * memory is explicitly protected. Avoid soft lockups.
-		 */
-		cond_resched();
+	for (level = MEMCG_LEVEL_COLD; level < max_level; level++) {
+		bool need_next_level = false;
 
-		mem_cgroup_calculate_protection(target_memcg, memcg);
+		memcg = mem_cgroup_iter(target_memcg, NULL, partial);
+		do {
+			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+			unsigned long reclaimed;
+			unsigned long scanned;
+			struct mem_cgroup_per_node *pn = memcg->nodeinfo[pgdat->node_id];
 
-		if (mem_cgroup_below_min(target_memcg, memcg)) {
-			/*
-			 * Hard protection.
-			 * If there is no reclaimable memory, OOM.
-			 */
-			continue;
-		} else if (mem_cgroup_below_low(target_memcg, memcg)) {
 			/*
-			 * Soft protection.
-			 * Respect the protection only as long as
-			 * there is an unprotected supply
-			 * of reclaimable memory from other cgroups.
+			 * This loop can become CPU-bound when target memcgs
+			 * aren't eligible for reclaim - either because they
+			 * don't have any reclaimable pages, or because their
+			 * memory is explicitly protected. Avoid soft lockups.
 			 */
-			if (!sc->memcg_low_reclaim) {
-				sc->memcg_low_skipped = 1;
+			cond_resched();
+
+			mem_cgroup_calculate_protection(target_memcg, memcg);
+
+			if (mem_cgroup_below_min(target_memcg, memcg)) {
+				/*
+				 * Hard protection.
+				 * If there is no reclaimable memory, OOM.
+				 */
 				continue;
+			} else if (mem_cgroup_below_low(target_memcg, memcg)) {
+				/*
+				 * Soft protection.
+				 * Respect the protection only as long as
+				 * there is an unprotected supply
+				 * of reclaimable memory from other cgroups.
+				 */
+				if (!sc->memcg_low_reclaim) {
+					sc->memcg_low_skipped = 1;
+					continue;
+				}
+				memcg_memory_event(memcg, MEMCG_LOW);
 			}
-			memcg_memory_event(memcg, MEMCG_LOW);
-		}
 
-		reclaimed = sc->nr_reclaimed;
-		scanned = sc->nr_scanned;
+			if (root_reclaim(sc) && memcg_heat_level(pn) > level) {
+				need_next_level = true;
+				continue;
+			}
 
-		shrink_lruvec(lruvec, sc);
+			reclaimed = sc->nr_reclaimed;
+			scanned = sc->nr_scanned;
 
-		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
-			    sc->priority);
+			shrink_lruvec(lruvec, sc);
+			if (!memcg || memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B))
+				shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
+					    sc->priority);
 
-		/* Record the group's reclaim efficiency */
-		if (!sc->proactive)
-			vmpressure(sc->gfp_mask, memcg, false,
-				   sc->nr_scanned - scanned,
-				   sc->nr_reclaimed - reclaimed);
+			if (root_reclaim(sc))
+				memcg_record_reclaim_result(pn, lruvec,
+						    sc->nr_scanned - scanned,
+						    sc->nr_reclaimed - reclaimed);
 
-		/* If partial walks are allowed, bail once goal is reached */
-		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
-			mem_cgroup_iter_break(target_memcg, memcg);
+			/* Record the group's reclaim efficiency */
+			if (!sc->proactive)
+				vmpressure(sc->gfp_mask, memcg, false,
+					   sc->nr_scanned - scanned,
+					   sc->nr_reclaimed - reclaimed);
+
+			/* If partial walks are allowed, bail once goal is reached */
+			if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+				mem_cgroup_iter_break(target_memcg, memcg);
+				break;
+			}
+		} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
+
+		if (!need_next_level)
 			break;
-		}
-	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
+	}
 }
 
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
-- 
2.34.1


