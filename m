Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857F8C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046766B012F; Mon, 17 Aug 2026 22:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13056B0130; Mon, 17 Aug 2026 22:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EFA6B0133; Mon, 17 Aug 2026 22:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A684B6B012F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:34:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C2581C1E82
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:54 +0000 (UTC)
X-FDA: 85112822508.23.396AD4A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id A4DC540008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787020492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/uX9eG6QH5vA4qJILrTW2Dg7h5W/JuMBQ7dSX051tk=;
	b=3jMR6i8leXjHDVCNkye9gpaQLpCOcGy2V34GrZ2cpemPA05y7zl2d6FlcZ12aSOaB3y9sR
	q3PMICJZ/q++wdcNcEcXIiU+N794VDKvMAbySZycL6jjppy97VUgVx215BlwQ/Mc8tN+Pn
	4pdFQTQ47prDfdoCyVgEyKEEt4Z1CtE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787020492;
	b=zttduSpyASfGAshHeysW9tpJhjBCArR+elMQYWNO/XEl6PExvaogP+yraCkIkVjmps3yRJ
	5jddepSlsQg2yC/VofeLzSA2JCaKLG/Aq1co8QfRbyg+1YbPT9a4RNMkU60SsANeq1N7bY
	brFh5wgT0YHiwn0LMx81fjrJyd3EV2s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
X-UUID: 5eb877b89aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:47b39f94-5733-4409-ade2-c20ebd433867,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:47b39f94-5733-4409-ade2-c20ebd433867,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:526b657b963702cc31f9e22cb15c8b3c,BulkI
	D:260818103445NRLI4JDV,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5eb877b89aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1131665455; Tue, 18 Aug 2026 10:34:43 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 7/8] mm/memcontrol: auto-derive tier high/max from memory.high/max
Date: Tue, 18 Aug 2026 10:31:20 +0800
Message-Id: <20260818023121.100613-8-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 16snxanwtqp5yagdciptyfe64jgzybxg
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4DC540008
X-HE-Tag: 1787020490-24006
X-HE-Meta: U2FsdGVkX19isOOmNEwUpuOxZB84ojAu7meURfSNCxm/KmvK+pO0l1rV7tBAH55+qupatEwft8ocEc2gTnSwi2jtipJOI6GoTcUiAHmq0GexVX51WvnKvfq7JGO+jxth1g4R+6ZNUsZqGJu/skdk2fTiWOnL9tVR13y0Utl2AnTKuSNPGnwbUuYuV0vxolKxGxivHZQVeM8r5RxCZxDQcqTrvxLfCaIDWJDQ4ruePpyPjsrYLwC3A7B9o4wJfo1oA98r2HHsoD5Y3mxP+gYHErDvjUDMU0RS2Yvz7/x6RxqTvDBTlJFTMBZP4Wn7lP8TNxySh46K69wJ1RNoYxberz1GLHpmhElfw7o9aap93sji/97Lg5ew9wL1Qi5HInv0T3LaZL/bRQ7jr4FAVOdSblmQ4TC2ZWM402gJuzjPXwNv5MiEyGbnvgDl6LD0gH8oUaj/8n1L/xXBirBYqmOAm5v8hMCOZI+kx8Aztv+2KLZBi9lICWoKf0SO1+UlLP/JIaLnSq7YbpTOdj7/OqIh0j89VWBnFQnZBZK9vAggGzPY3G27G9fgd9otJptGO6AID4ubjVbYcLp+QuYqaz7Smgr/L7PDIJgOKHIwQKDAUUPmA6s0vx4jPrPgChTtG9WFo2jBqx1HO2Y01lWUlOodIp2V8Pe0FUGH0ACYVcA3Xpnw5niiqY5jQChsw1SXCg+8kuy4B5lNwHO3ja8053kwSQQHeB+41dEXsDOOiBUBqkKQdcJjVeUbuutVX2JPDWcmDNemRXCxxSX2Lh1IacNfPinIkV980YhyM17bvfedLeEUpWQBAoYk6HOlF/kQgv6y/ly6YzkrXVdhX4c+wi8daGdUuBGdqPblQgyUF+AzZraEIc3Wpw8zs1iP0f1uBAMIA+pT/vIzxhDPBJLZ5x3Dtze4vGj01MxgHJPF15QY3OiPnGsok0YiTCYrmxZ9BWRMmJyvK06C+kaJA8hvaII
 sasikbC2
 57fPN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

Per-tier limits are derived by default from the cgroup-wide memory.high
and memory.max knobs based on the tier's capacity ratio:

  tierN.high = memory.high * tierN_capacity / total_capacity
  tierN.max  = memory.max  * tierN_capacity / total_capacity

This provides zero-config tier partitioning. Setting memory.high or
memory.max automatically splits the budget across tiers proportionally
to their physical size. For instance, a 4G cgroup on a system with a
75%/25% DRAM/CXL split automatically receives ~3G DRAM and ~1G CXL.

The capacity cache and the derived limits are refreshed on node memory
hotplug, both when node memory is added and when it is removed.

Writing an explicit value pins the limit and disables auto-derivation
for that tier, decoupling it from subsequent memory.high/max updates.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/memcontrol.h |   2 +
 mm/memcontrol.c            | 162 +++++++++++++++++++++++++++++++++----
 2 files changed, 150 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fa944e4bc5ad..8848bc5eeb24 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -205,6 +205,8 @@ struct memcg_tier_counter {
 	int tier_id;
 	struct list_head list;
 	struct rcu_head rcu;
+	bool max_derived;	/* true: derive from memory.max by capacity ratio */
+	bool high_derived;	/* true: derive from memory.high by capacity ratio */
 };
 
 struct mem_cgroup {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a6c6057f0e4f..f39a702d2301 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2443,6 +2443,8 @@ static int memcg_tier_counter_create(struct mem_cgroup *memcg,
 	page_counter_init(&new->counter, parent_cnt, false);
 	page_counter_set_high(&new->counter, PAGE_COUNTER_MAX);
 	INIT_LIST_HEAD(&new->list);
+	new->max_derived = true;
+	new->high_derived = true;
 
 	spin_lock(&memcg->tier_lock);
 	if (memcg_tier_counter_find(memcg, tier_id)) {
@@ -2514,6 +2516,115 @@ reclaim_tier(struct mem_cgroup *memcg, unsigned int nr_pages, gfp_t gfp_mask,
 	return nr_reclaimed;
 }
 
+/* Global per-tier capacity cache.
+ * Populated at boot and on node hotplug (walks online nodes only, no memcg touch).
+ * Stores (tier_id, capacity) pairs to support sparse tier IDs (e.g., 4, 22, 52)
+ * without requiring a dense index.
+ */
+#define NR_TIER_CAP_ENTRIES 16
+struct tier_cap_entry {
+	int tier_id;
+	unsigned long capacity;
+};
+static struct tier_cap_entry tier_cap_entries[NR_TIER_CAP_ENTRIES];
+static int nr_tier_entries;
+static unsigned long tier_total_capacity;
+/* Guards the per-tier capacity cache. */
+static DEFINE_SPINLOCK(tier_cap_lock);
+
+static void update_tier_capacity_cache(void)
+{
+	int nid;
+	int i;
+
+	spin_lock(&tier_cap_lock);
+	nr_tier_entries = 0;
+	tier_total_capacity = 0;
+	for (i = 0; i < NR_TIER_CAP_ENTRIES; i++) {
+		tier_cap_entries[i].tier_id = -1;
+		tier_cap_entries[i].capacity = 0;
+	}
+
+	for_each_online_node(nid) {
+		int tid = node_to_tier_id(nid);
+		unsigned long cap;
+
+		if (tid < 0)
+			continue;
+		cap = node_present_pages(nid);
+		for (i = 0; i < nr_tier_entries; i++)
+			if (tier_cap_entries[i].tier_id == tid) {
+				tier_cap_entries[i].capacity += cap;
+				tier_total_capacity += cap;
+				break;
+			}
+		if (i == nr_tier_entries && nr_tier_entries < NR_TIER_CAP_ENTRIES) {
+			tier_cap_entries[nr_tier_entries].tier_id = tid;
+			tier_cap_entries[nr_tier_entries].capacity = cap;
+			nr_tier_entries++;
+			tier_total_capacity += cap;
+		} else if (i == nr_tier_entries) {
+			pr_warn_ratelimited("memcg: tier capacity cache full (>%d tiers), tier %d not tracked\n",
+					    NR_TIER_CAP_ENTRIES, tid);
+		}
+	}
+	spin_unlock(&tier_cap_lock);
+}
+
+/* Push derived high/max limits to tier counters of @memcg.
+ * Invoked on memory.high/max writes and capacity changes (hotplug).
+ */
+static void tier_update_derived_limits(struct mem_cgroup *memcg)
+{
+	struct memcg_tier_counter *tc;
+	struct tier_cap_entry local_entries[NR_TIER_CAP_ENTRIES];
+	unsigned long total;
+	int i, nr_entries;
+
+	spin_lock(&tier_cap_lock);
+	total = tier_total_capacity;
+	nr_entries = nr_tier_entries;
+	memcpy(local_entries, tier_cap_entries, sizeof(local_entries));
+	spin_unlock(&tier_cap_lock);
+
+	if (total == 0)
+		return;
+
+	/* Serialize flag check + limit store against memory.tier writes. */
+	spin_lock(&memcg->tier_lock);
+	list_for_each_entry_rcu(tc, &memcg->tier_counters, list,
+				lockdep_is_held(&memcg->tier_lock)) {
+		unsigned long cap = 0;
+
+		for (i = 0; i < nr_entries; i++)
+			if (local_entries[i].tier_id == tc->tier_id) {
+				cap = local_entries[i].capacity;
+				break;
+			}
+		if (cap == 0)
+			continue;
+		if (READ_ONCE(tc->max_derived)) {
+			unsigned long mem_max = READ_ONCE(memcg->memory.max);
+
+			if (mem_max == PAGE_COUNTER_MAX)
+				xchg(&tc->counter.max, PAGE_COUNTER_MAX);
+			else
+				xchg(&tc->counter.max,
+				     mul_u64_u64_div_u64(mem_max, cap, total));
+		}
+		if (READ_ONCE(tc->high_derived)) {
+			unsigned long mem_high = READ_ONCE(memcg->memory.high);
+
+			if (mem_high == PAGE_COUNTER_MAX)
+				xchg(&tc->counter.high, PAGE_COUNTER_MAX);
+			else
+				xchg(&tc->counter.high,
+				     mul_u64_u64_div_u64(mem_high, cap, total));
+		}
+	}
+	spin_unlock(&memcg->tier_lock);
+}
+
 static void tier_high_work_func(struct work_struct *work)
 {
 	struct mem_cgroup *memcg;
@@ -4841,6 +4952,8 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
 		page_counter_set_max(&tc->counter, PAGE_COUNTER_MAX);
 		page_counter_set_high(&tc->counter, PAGE_COUNTER_MAX);
+		WRITE_ONCE(tc->max_derived, true);
+		WRITE_ONCE(tc->high_derived, true);
 	}
 	rcu_read_unlock();
 }
@@ -5251,6 +5364,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_high(&memcg->memory, high);
+	tier_update_derived_limits(memcg);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
@@ -5303,6 +5417,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		return err;
 
 	xchg(&memcg->memory.max, max);
+	tier_update_derived_limits(memcg);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
@@ -5390,10 +5505,17 @@ static ssize_t memory_tier_write(struct kernfs_open_file *of,
 	if (!tier_id_to_nodemask(tier_id, &nodes) && !nodes_empty(nodes))
 		nmp = &nodes;
 
-	if (!strcmp(knob, "high"))
+	if (!strcmp(knob, "high")) {
+		spin_lock(&memcg->tier_lock);
+		WRITE_ONCE(tc->high_derived, false);
 		page_counter_set_high(&tc->counter, val);
-	else
+		spin_unlock(&memcg->tier_lock);
+	} else {
+		spin_lock(&memcg->tier_lock);
+		WRITE_ONCE(tc->max_derived, false);
 		xchg(&tc->counter.max, val);
+		spin_unlock(&memcg->tier_lock);
+	}
 
 	if (of->file->f_flags & O_NONBLOCK)
 		return nbytes;
@@ -6145,18 +6267,28 @@ static int __meminit memcg_tier_hotplug_cb(struct notifier_block *self,
 	struct mem_cgroup *memcg;
 	int tid;
 
-	if (action != NODE_ADDED_FIRST_MEMORY)
-		return notifier_from_errno(0);
-
-	tid = node_to_tier_id(nn->nid);
-	if (tid < 0)
-		return notifier_from_errno(0);
-
-	for_each_mem_cgroup(memcg) {
-		if (!mem_cgroup_is_root(memcg) &&
-		    memcg_tier_counter_create(memcg, parent_mem_cgroup(memcg), tid))
-			pr_warn_ratelimited("memcg: tier %d counter alloc failed;"
-					     " tier accounting degraded\n", tid);
+	switch (action) {
+	case NODE_ADDED_FIRST_MEMORY:
+		tid = node_to_tier_id(nn->nid);
+		if (tid < 0)
+			return notifier_from_errno(0);
+
+		update_tier_capacity_cache();
+		for_each_mem_cgroup(memcg) {
+			if (!mem_cgroup_is_root(memcg) &&
+			    memcg_tier_counter_create(memcg, parent_mem_cgroup(memcg), tid))
+				pr_warn_ratelimited("memcg: tier %d counter alloc failed;"
+						     " tier accounting degraded\n", tid);
+		}
+		for_each_mem_cgroup(memcg)
+			tier_update_derived_limits(memcg);
+		break;
+	case NODE_REMOVED_LAST_MEMORY:
+		/* Node memory removed: refresh capacity and derived limits. */
+		update_tier_capacity_cache();
+		for_each_mem_cgroup(memcg)
+			tier_update_derived_limits(memcg);
+		break;
 	}
 	return notifier_from_errno(0);
 }
@@ -6181,6 +6313,8 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
+	update_tier_capacity_cache();
+
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
 	hotplug_node_notifier(memcg_tier_hotplug_cb, MEMCG_TIER_NODE_PRI);
 #endif
-- 
2.43.0


