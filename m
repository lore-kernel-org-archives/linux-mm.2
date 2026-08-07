Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F4AC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80106B0092; Fri,  7 Aug 2026 16:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D012B6B0093; Fri,  7 Aug 2026 16:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57206B0095; Fri,  7 Aug 2026 16:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 892196B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11EAA120124
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:08 +0000 (UTC)
X-FDA: 85075592616.13.BD5051B
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3448314000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OlFNMe2P;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Veey7tCntVTCDMITmGRXBJciLEPyIkZpuk6PEQ2O088=;
	b=2+wOOBtdRyxpZjFs6qeQziHBGjCErcp+MXl1Gfmdk09RTK3jR8iu60TCYz9QhoRtsdpyWp
	nXJLWhtqGqT/KhpsxXi+TkZdV1/3MY1FJBhT3hwIg0za3h+csxoRTSPNDXmK0rha3VcE30
	TvnQLhGYCW4ONEc8WUP484El4bCKSu4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134066;
	b=A08FCv7gULf1Ugn3RCooV/cgFtxKj/WOSWQHHQpQV8wVx8R6ZAoYczjpOy0m0f+HWmxwak
	58PCEwBZz2G8ef0v2e8UVLRMoZzVALs2g+IS3d+JQkDeaiGrLYdJwqIK72Oa6tA6UUBsu6
	4pChtEXafMFFckZUqO8pFGWegB3uBD0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OlFNMe2P;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-495b98b4f6aso1429291b6e.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134065; x=1786738865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Veey7tCntVTCDMITmGRXBJciLEPyIkZpuk6PEQ2O088=;
        b=OlFNMe2PvkNahech8n2lVRXCIrp8NomZr8msezquD2JIsaLZ4jX6Tv+YiltoKb1Syf
         AOYRpkcokOa5Nbtc+G4XBq1K/UFKwYpOfglOQthv4jjCBclrUC57OtYJ+CLb1mIVUMJC
         JucDGHjSSXs+ZF3eplDZCNzfw5NhjUk2mOb3KCDLE6RbwqgyADY44Ya2tMMkJjKI1t5S
         T430PScRTxZHFZIO2rSEFBFKO1W6hGsUNZl/e5IapmfOyqJ07kvvG2dFXmFU1VV64i5W
         gbJA8c8Bw3SV7bXfdYVNGCQHeriU6DP/93AFmI0RI8g/5OvdNTC8g/E7hKi5PJNfoY3u
         ePiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134065; x=1786738865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Veey7tCntVTCDMITmGRXBJciLEPyIkZpuk6PEQ2O088=;
        b=tVID8dNeeBg2fQFjjdw8dzXjCiN/XvbpKrQeW4gqtT5+r8pfPe9aRuMK6tQhBP6jz/
         1LCUsyLWzmKyR3O9B/vXKJK4UHe05wFRzmXm9MXJr0AaUcj6PwDBo+h9IcJwDkM+eYsF
         HIWrjj1g+vaqYV32hr2u9fLKU6jKry9quP6tevnZVsFgVM5whDuhl29wnmuSOzu15srT
         k0qR8yWLoNnmfNH4HwoSkOPfiSTNoDA14FkBuZmXhqfkyshnjnpMm/xXQgCtWSZT1VUg
         BsKD0tbD0whWa8CoZhr8ZvJ5KfEBMxIL/rv1n+uUsl6ruo9NYV724v3g7Uvk9oxbvjZL
         SlbQ==
X-Forwarded-Encrypted: i=1; AHgh+RrI9lLx/hkAwc56qpy4dxqnekXc2Av2e2WA+qgyO8ZsFSCezhlB5Q3wyoGgS102MDJUX9Cq9ZnvVQ==@kvack.org
X-Gm-Message-State: AOJu0YyadKTbvVyJH5AJIoXZc0v6ulQk38Nn14cVBRFlFBzNf+c60TIy
	heQiQwOW7nEGhh5cCFRQl8PA6wgL9/p/cjcWxPvLeRL+kj7sIUQgzbwN
X-Gm-Gg: AR+sD109rZIfzdPhMdFdcEqAZ9Sw5yQt73i6zzmrPthQRWnz3tZO7DianKx1omFe03h
	MFKV7mkjvIIgZoGVmC5ERhr7rHD+y0LyXIJFx6TRQflCXBvKemeDdPfF5h/wqarJ59n/Sd6twcT
	frAafMESl1HaExHvi73ALZb2RLzbIR8m+Jsj9FOZeWZ306ZzzmkP8Saa8zWF06P/OugfpiLEvyP
	Vo7hewRQTDZWE8h06Tp96DRoJLUINcR0yucw0BQ+lH57pbXgb/DPM4Bx3v+hRP2rkTvWGWi2Y+i
	gCW4IteXIN6LvW/4f2Z3vBNd2FUlYzeCrUX/eAzinGX5NhXopQyHFY15pSJB0IVsoXwSaDqcYib
	SsInwEATVvpcvxdKgx0riGpTye+/vfYFp48Uj02NhbIoN0TXkt4UdIvBilli3wpCwHEw1GRvjEx
	6iDN7CaLpXGwIx2ybL301RUG5iTq0S7gKpNF3FCOgQ3Gd8lqU1Ht4orZcj+Nx66iGDrdgtqCg5i
	hWj/NUMdxqwTDKkYA==
X-Received: by 2002:a05:6808:150b:b0:496:b7c:274b with SMTP id 5614622812f47-4afae16a91fmr12782189b6e.19.1786134065034;
        Fri, 07 Aug 2026 13:21:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b1af5e4fc0sm422662b6e.11.2026.08.07.13.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:04 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 03/14] mm/memory-tiers: Introduce a mapping from nid to tier_slot
Date: Fri,  7 Aug 2026 13:20:46 -0700
Message-ID: <20260807202059.2620949-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3448314000B
X-Stat-Signature: w6wth55a8ezz3n51kgrhiwrwgou8bzq1
X-HE-Tag: 1786134066-630449
X-HE-Meta: U2FsdGVkX18TetSgfF4Ju36CYF4baTLti6uNwvE1z4VDYq5KMFEc7zeYL0YStRo0Mn9DSK2+eVr5gJA5plaLGMRJ0yi9EC5iPv84MZp5REpYajiCzm1diF+8CFne83k30FQW+Vb3bcmtkYnbo5gcwbRld7jtekTQittuhfybL/GwqD330810fbeI5I7ouFFJjKiIZzTzNEwPT4+t0Car+27OOz3iwPubo/DiTRLqJOijO0h0OM63tRLLKESXRSHNt71YDdGHgb0t8F8zCI6/T+CtjxfSV+IIybEbLOzFJJpI54pUO0CNRgbxQhxMaCPlz1W0H3trViiQiu2dqVCjkGrLDutq4XW0jtS11ryfnA/pQXBJ73MpvdHAzKLgqKOEL1RMIN8TOKK0ElXUOseEtswkOgMBtzrLdhBDY9RCQL+TKcPd2zdbuvWNsaEpSMsCT9GHxm9eX0OZSx3u0ykD7xfBQVkOjPWrzerebvtE5kY6VJC2jZKqjFbe62W08B3DPY3SpNGFYuRKs5KgrdKFEJTJNB5MuFxYlqNLHqIcyY1MvF1BYqhMVeqQ9n4PLBACbQ7P3QcPp/ypPZVeLldEj7bZZQaAfh9QLpsCD/Ho0hBRHGy98471hdy/Is5ZK46L0sURhNtpzvD3S4DH6y0eFye0ocFv8z391vXp4eaTp0F+Kor0XEYAdzJTilkrBrJT56TYSLF7gfzY3OudmuKFNayQPUId3LdRbxJKflj8y0qiqNCwdW+O0/et6Ls/BMh8MwQhOLgpsaQS+HhuFReu8auIhpfcIbR09w2mCura8F8c4x9YB+Leg2GC9mPGT1HHEYS6cU5Zr2N7hI+HWYxnNVzul0PVdx6SSN2VxIG64neB9z59I8/yI66EQiIAGha4eEdEPIkUhASlHLTKSsALt+H/Z6yH/xVkHZI+xn1eqow7H4S8MK94wh/p7M0tHO9QeSHdkjl5jItO/7wPFLb
 9aqFKtIh
 8K1Rdl3ZvdH1g/Mx8Me/AhtNtJhAF/3odY2Fq8ccUI4xz/ViyJOhmbeEuEXRB8EVb/F0eRs2QXQKMU5YHlM0ILdHi25d2NAR8tn98TnjyNV4cNlzFop4LlZMmRWYV+ONpuGCYgO/836n4AJRbjmzp5AWP2oDhsseeIhSctO7+i2bS6yHaI3HEyDpEFv1w9pO1a9idf/803v8kTNkzKtpwzbiezjfTrmREeBRHjmZOI9BdjC4WGB7Mq4kseeRiizlyCbL3qz5qCzEiIzj3Fd0Fhhtrza3KJzJ/kaN+0y3r0qkEF5ANOCVX2/xdwjrEIACvpa/igr7L8zA4dGA85XBtj148iBBOVkkmU2zJ8haIluOsD8dKJblHxB24dBdxWyvaW2/kQwK6fwdYFylHYht6cV99Fc1twlr3zChTa4gjAcGnNs5cBTz8iwPTCNGmcjKC7mCgV+DKwrpMgvfJuClghLxeVlhwm5dLbyX37hoZIlPnG63fEVjqNuKqc9JrDwkvjyhGaOQa2XH5+b/XdeIqpml7q9zVCfJkhVwkfEAdr6+dExQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Establishing tiered memcg limits will require an ordering of tiers, as
well as a way to account how much memory is present in each tier.
This will need to be done starting at boot, so that all memory becomes
properly accounted.

However, tiers can come online and offline at runtime due to DAX memory
whose nodes can be hotplugged / hot-unplugged, and these nodes' tiers
are not available at boot.

Therefore, to establish a fixed mapping from nid to tier that isn't
sparse like the tier_ids, introduce a new "tier_slot" which is a dense
index that does not change once a tier comes online.

Also introduce a helper to retrieve the nodemask associated with a tier.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memory-tiers.h | 18 ++++++++
 mm/memory-tiers.c            | 86 +++++++++++++++++++++++++++++++++++-
 2 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629eeb..0e49645cdd1a9 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -41,6 +41,8 @@ extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
+int mt_nr_tier_slots(void);
+int nid_tier_slot(int nid);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
 void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 int register_mt_adistance_algorithm(struct notifier_block *nb);
@@ -52,6 +54,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+const nodemask_t *mt_tier_nodes(int slot);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -151,5 +154,20 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline int mt_nr_tier_slots(void)
+{
+	return 0;
+}
+
+static inline int nid_tier_slot(int nid)
+{
+	return -1;
+}
+
+static inline const nodemask_t *mt_tier_nodes(int slot)
+{
+	return NULL;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..36187c0ea9ded 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -43,6 +43,16 @@ static LIST_HEAD(memory_tiers);
  */
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
+
+/*
+ * nr_tier_slots and tier_slot_ids are written with memory_tier_lock and
+ * read locklessly. nr_tier_slots is monotonically increasing.
+ */
+static int nr_tier_slots;
+static int tier_slot_ids[MAX_NUMNODES]   = {[0 ... MAX_NUMNODES - 1] = -1,};
+static int node_tier_slots[MAX_NUMNODES] = {[0 ... MAX_NUMNODES - 1] = -1,};
+static nodemask_t tier_nodemasks[MAX_NUMNODES];
+
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
 
@@ -273,6 +283,65 @@ static struct memory_tier *__node_get_memory_tier(int node)
 				     lockdep_is_held(&memory_tier_lock));
 }
 
+/* Caller must hold memory_tier_lock */
+static int tier_id_slot(int tier_id)
+{
+	int slot, free_slot = -1;
+
+	for (slot = 0; slot < nr_node_ids; slot++) {
+		if (tier_slot_ids[slot] == tier_id)
+			return slot;
+		if (tier_slot_ids[slot] == -1 && free_slot == -1) {
+			free_slot = slot;
+			tier_slot_ids[slot] = tier_id;
+		}
+	}
+
+	return free_slot;
+}
+
+static void establish_tier_slots(void)
+{
+	int old_nr_tier_slots = mt_nr_tier_slots();
+	int highest_slot = old_nr_tier_slots;
+
+	lockdep_assert_held_once(&memory_tier_lock);
+
+	for (int slot = 0; slot < old_nr_tier_slots; slot++)
+		nodes_clear(tier_nodemasks[slot]);
+
+	for (int nid = 0; nid < nr_node_ids; nid++) {
+		struct memory_tier *memtier = NULL;
+		int slot = -1;
+
+		if (node_state(nid, N_MEMORY))
+			memtier = __node_get_memory_tier(nid);
+		if (memtier) {
+			slot = tier_id_slot(memtier->dev.id);
+			highest_slot = max(highest_slot, slot + 1);
+		}
+
+		WRITE_ONCE(node_tier_slots[nid], slot);
+
+		if (slot != -1)
+			node_set(nid, tier_nodemasks[slot]);
+	}
+	WRITE_ONCE(nr_tier_slots, highest_slot);
+}
+
+int mt_nr_tier_slots(void)
+{
+	return READ_ONCE(nr_tier_slots);
+}
+
+int nid_tier_slot(int nid)
+{
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return -1;
+
+	return READ_ONCE(node_tier_slots[nid]);
+}
+
 #ifdef CONFIG_NUMA_MIGRATION
 bool node_is_toptier(int node)
 {
@@ -729,6 +798,7 @@ static int __init memory_tier_late_init(void)
 	}
 
 	establish_demotion_targets();
+	establish_tier_slots();
 	put_online_mems();
 
 	return 0;
@@ -878,6 +948,14 @@ int mt_calc_adistance(int node, int *adist)
 }
 EXPORT_SYMBOL_GPL(mt_calc_adistance);
 
+const nodemask_t *mt_tier_nodes(int slot)
+{
+	if (slot < 0)
+		return NULL;
+
+	return &tier_nodemasks[slot];
+}
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
@@ -887,15 +965,19 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 	switch (action) {
 	case NODE_REMOVED_LAST_MEMORY:
 		mutex_lock(&memory_tier_lock);
-		if (clear_node_memory_tier(nn->nid))
+		if (clear_node_memory_tier(nn->nid)) {
 			establish_demotion_targets();
+			establish_tier_slots();
+		}
 		mutex_unlock(&memory_tier_lock);
 		break;
 	case NODE_ADDED_FIRST_MEMORY:
 		mutex_lock(&memory_tier_lock);
 		memtier = set_node_memory_tier(nn->nid);
-		if (!IS_ERR(memtier))
+		if (!IS_ERR(memtier)) {
 			establish_demotion_targets();
+			establish_tier_slots();
+		}
 		mutex_unlock(&memory_tier_lock);
 		break;
 	}
-- 
2.53.0-Meta


