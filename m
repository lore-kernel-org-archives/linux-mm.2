Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79409C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802CF6B009B; Mon,  7 Sep 2026 23:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9A76B009D; Mon,  7 Sep 2026 23:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0C96B009E; Mon,  7 Sep 2026 23:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7746B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:41:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C02BA0386
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:57 +0000 (UTC)
X-FDA: 85189196274.20.0613FAB
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5412C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwBqBnL3;
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788838915;
	b=DDzlMH5oKBrVeCBodISjJUbvFoxXO7R9ohrXsjzej4tw8gayR+sryB+8H2SXzI8qIM0s8q
	aNdLZP/KgBxC2NYPA6x4MelyWIs06JL/Q7gyr+VGdi51r3Be2h9t7xg+gyPYKKz6yZEGXZ
	IXYGLomwYbtHwhDDuIAETk/Fsdh+tJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788838915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvUtUMBnVxAOxf82D4GmyE5Hx0QZB2VCDnA8OWIQgts=;
	b=27WNTroDBP+K2VzT+o7uFPwotkJwguW7/HFKGMg9ggoTDKy+9vlSH+gVQXBO7p9MBYBRGx
	OJ2dklw6zfQcNiboE87mQkZ3UFLyLaP8U02eIS89YB5ri1sz6E0G/H0GdffCIAriaW6Wqe
	6delD2ZmrF6pHs5z++AbU5XUvVamVyE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwBqBnL3;
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MlIZcCXSxTICdrlqvuuIMch3l/hSvENFUEtEORDa6Hc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838914; v=1; x=1789443714;
 b=MwBqBnL3ytwpnPgdbMGRuZcfvxrd0kp14PW/enIyEnE0bK5M8xEx/+P3mVSugRjiNfOy38s8
 /6DxJyQem8tlDIrbJWpX2dW94lry9A6VDFf1TfHysQ6TuB8JU6dsaxxU8CgXdGu7tF7JanEscpY
 oT/1B+2y38nwtcmYaBU8Q/hs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0e9898f317fc1207;
	Tue, 08 Sep 2026 03:41:53 +0000
X-Mizu-Trace-ID: 0e9898f317fc1207
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v4 4/4] mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2
Date: Tue,  8 Sep 2026 11:41:14 +0800
Message-ID: <4a7a64eed2b145ad535fedaea3624f8310c29d5b.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A5412C0004
X-Stat-Signature: 9kzikmqukdhxa461ogrrryedj7kh185n
X-HE-Tag: 1788838915-481862
X-HE-Meta: U2FsdGVkX1/c3D63EItzQIyuqZPwQD4GUGOamBYFbTbD8gjhtu6Qghc5N3iLA3NSE0jjTma8KYuvpI4tZ2diG1OVYK2eOc4as1Jghcm/EORDFgpRvjkeWE0VW/TzupVoN2/pvU24yM0gU4ysAjqJRxl1WCI3gGbviPKFw7xDtvrEWRybJtdz3tN8PaLRrjL1xppJzO2AXcDJieTcGBPD20wpR22OrFr2Hm0nBYLhgVF51z10ee09tDtitnwNQjORWdGQJrrZ7jqX+wA+NDvFGybpHFhYwQdUotfniNYjztWIayPYI4zpDXguVV3r6NT54FO+OLj/qjQVa7OWAkFnLQ1uzvkfkqLDzrrnN64HAa7KISu7S0f5C3903ZLgCkac6MDMy4EA9bwe81zba6F62zY10J8RXrancTIdhNDV1SE3200iFC19XJ1ycTkpz43pKTRkavthcT5G43Y2ANgpPGEEMR1ewP92B4cFlYZuXA2motcNUQN6vLt/RVIgVJeULr7ZvZZAt8brljjd6C/E1k3F4D55jOI/rat6rnWzl3/EmGEcvg8BPaqzsMcFKVWYuShp8S863FXNE6cH6i4QtIvDVBhEinXuJ9yXG6dGyQlI2yrKZf1wz8jyKdSF95LmFG42JO4pUJad7VC21+KMYSspQKa+FQNqxXqdilwLJCk6UL/uw2rgcLAU9sA8FFSJRy59G2vbhyBgrY0Cl/dRCqAUqBe0vDqcOI5fKz1ajgbBm+CxbCQF/vUWSZz7qnOyZsmqH2UDSc5m5K9Zvbhfv4F8l019gnJimgmTQeQHYGjNF0TIDaxdwE/xNTjO3JHccYTo7aHx3xg0DTzabGN3Kx0MiK/h2hHqdXYXRLr19RNF/fIV1+MU0dtCiY5fp8YtthScox2NW7AIAFn+a5vhtTxr1IdSO/HXYfQA3aiUMfR74wq4N+ofBrybQnUsB1xVYEdBZVnampOYP9tIPTx
 o6lO3c6/
 Mx4gbGfaqf8xvNEuo+IVhN8rCQ9LWCjCT9ngIvveZ90XGCKAeDbB2Ga4Jyxyx3iBPuFM/FguMpUI38a4f+oQyHX90ImQ6GkXETdGK1BJVfIRhEtpuEUxuJzQj/He4sl0R25mIKOIu7N59QyEGCZyz9wnMA/d5KtIcm4PbUp+RYl+iApvg9d0hfptJJglL8agGPZnSGkfUZSDO27KJ8FgdgMbnbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

On cgroup v2, reparent_state_local() returns early and never moves the
dying memcg's non-hierarchical state_local base counts to its parent.
Meanwhile memcg_reparent_objcgs() rewrites objcg->memcg to the parent,
so when the reparented folios are freed later, the negative deltas land
on the parent's lruvec.  The parent therefore receives the uncharges
without ever having received the matching charges, and its state_local
(NR_LRU_BASE + lru, MEMCG_SOCK, NR_SLAB_RECLAIMABLE_B,
NR_SLAB_UNRECLAIMABLE_B) permanently underflows.  Since
lruvec_page_state_local() clamps negative values to zero, the underflow
masks the parent's own legitimate pages.

count_shadow_nodes() is the only reader of these non-hierarchical
state_locals on cgroup v2, so the underflow directly distorts the
workingset shadow node budget.

Fix this by reparenting the lruvec state_locals on cgroup v2 as well,
mirroring what cgroup v1 already does.  Only the lruvec stats consumed
by count_shadow_nodes() are moved; the memcg-level stats are left alone
because on v2 they are exposed through the rstat hierarchical tree and
are not read from state_local.

Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol-v1.h |  5 +++--
 mm/memcontrol.c    | 42 ++++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 1e394269c613d..0578b7076764d 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -25,6 +25,9 @@ int memory_stat_show(struct seq_file *m, void *v);
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -73,8 +76,6 @@ void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgr
 
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9995f3d2aae1b..f13030f75fa54 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -232,14 +232,29 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+/*
+ * Reparent the non-hierarchical lruvec stats that count_shadow_nodes() reads
+ * to approximate the shadow node budget.  They are not exposed to userspace
+ * on cgroup v2, but they must follow the reparented folios; otherwise the
+ * ancestor would only receive the negative deltas when the folios are freed
+ * without ever having received the positive base, and its local stats would
+ * permanently underflow.
+ */
+static void reparent_v2_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, NR_LRU_BASE + i);
+
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_RECLAIMABLE_B);
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_UNRECLAIMABLE_B);
+}
 
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	/*
 	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
 	 * to read its stats accurately , and conservatively flush @parent's
@@ -248,17 +263,18 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
 	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
-	/* The following counts are all non-hierarchical and need to be reparented. */
-	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		reparent_v2_lruvec_state_local(memcg, parent);
+	} else {
+#ifdef CONFIG_MEMCG_V1
+		/* The following counts are all non-hierarchical and need to be reparented. */
+		reparent_memcg1_state_local(memcg, parent);
+		reparent_memcg1_lruvec_state_local(memcg, parent);
+#endif
+	}
 
 	__mem_cgroup_flush_stats(parent, true);
 }
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-}
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
 {
@@ -570,7 +586,6 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, long val);
 
@@ -592,7 +607,6 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
-#endif
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
-- 
2.43.0


