Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C642AC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17BD6B00AE; Fri, 11 Sep 2026 04:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFB06B00AF; Fri, 11 Sep 2026 04:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05D06B00B0; Fri, 11 Sep 2026 04:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD266B00AE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:02:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 382B01C0403
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:01 +0000 (UTC)
X-FDA: 85200738042.27.A32581C
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5020540009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r+oGFJjp;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113719;
	b=ntVxP3Gim9b5FCBUCUq360RBYT6FjMdWxZOmI2XEvfPs55h+cl3fu/XxnamWKqRJUrznJw
	yshI017OYL7/7BPCTOfVcwIwbpn9shrW+zIOFfMV1U6f38KvY5T5x8M/SX/fxg5rkVx9lL
	mERHok6LqR9xy17CNecSTVMJih7twLE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r+oGFJjp;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvUtUMBnVxAOxf82D4GmyE5Hx0QZB2VCDnA8OWIQgts=;
	b=pvCkefYFk4HPSVIDW76QIlOpFbL60rIPhJJtP3oEDfqcl2rSi90wfIcm/YzH8dvZ4Rfw6k
	LRrNX0z6B9Ut4vDlOB2Fj5oS4n012I5fcVlyIMFb0liCNx8I7XfC24Rl8xrAmJUxsVncge
	pTEVngp3UVK2m4Vv+5F/Yw+EBXvowSQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MlIZcCXSxTICdrlqvuuIMch3l/hSvENFUEtEORDa6Hc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113718; v=1; x=1789718518;
 b=r+oGFJjpjPNVoTAMB21ph5+IOjt5CEFIzmZVsSjBVVoaEcDyEXELWyEFEXn+bB1X7FOC+v9Z
 1ctT4+tf7gBXDaiGuroot1tLxpdzApgdqgQXXbyMumsT8sY6NVGZtGuKLvYxv2VNtUOeeoo8u0t
 hYMxOEaPdYT+Xofg5mejiX5g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0c3212cca3ab0784;
	Fri, 11 Sep 2026 08:01:57 +0000
X-Mizu-Trace-ID: 0c3212cca3ab0784
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
Subject: [PATCH v5 4/4] mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2
Date: Fri, 11 Sep 2026 16:00:51 +0800
Message-ID: <4a7a64eed2b145ad535fedaea3624f8310c29d5b.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5020540009
X-Rspam-User: 
X-Stat-Signature: o7mhk5o9zeagjs6jb4umk8yqb46kbawj
X-HE-Tag: 1789113719-680675
X-HE-Meta: U2FsdGVkX19H4Va4exAE4ZAdzinXLBOJQng6jNH3f0v6jIXHfLVjM2YiGzZdW1StCapRS5eZEtCb5OqEllfyxt0VlEpt3MFRaH8DKr1VdhHNgrZaMqqhpWtjwrpcTi0wg/Dk747RzTep5YDAfXVPG7/q5MBb0lVmbEMRK5gsemt5qBr9Uw1VonyV/BvyxicWiMYy3zS47F850VG2/GT7q5mtYz4usIVkm+Ckc8dhe5qFJuDa9nZlzuJuvsMGVru4AvKTst+oCBsUGMGunUUE5LX7rTllTGhcPvWCtccfY9l3Z6TvCsUcolpCZMg7mVGLlzHv72BNghG16WFX7vad9YnkpSna8wUpAL0fudMo3nhzX9PqpWOWtM2VmORVVcFyyV2Pz7fcpcX2uSsCDzuxwgGOqURIPKqUdwGxhhOSsxCbSmjmqMZ7IBKR/nt7DGOppY6720JdtadJNO4VeEcNklflpwFo32JD0mkbpLvxtmobIF+DRn/KV+gr7WuHKkk9ZV+s85kdijv1++Ri6jZDtwHBXufVlnfZj6by3gxf3tbZ4lNk1mL72C8ysdfJ4qXCS/uIWVuJkzZCy5mjaX9/VI54kHebkcPtZGLLOai1EJHzScrnPOyHqGBXmdpWaOGQIA7iwNxzGxIea4tPqGzeW7n6wfcvgmXRzJMgBH/2V3ArWpbl8FUCkWqkloTDPj9EuykYtkqoQbn8iNkc2HftPoDUiCuPcxyaLJ/IIadCI/dmX3zZ0SkoOudc9EEnf2nts02fl7u0R9r2YoxYAY+/9fjQnhLfZVxRwoLvVB+aD3DelM0tBig9mryHLcxbgjMQl2/9N740rUoaZ8j+kJkqfLyy7ImPTSUXNH4RB2iHeFLP4lBfDLtWcbW+B5gQBwwsrcOUso+18GkPmSexzYBUiMUKsmA6FGDlOuhTZf16QlLohb+rpVG3Kpa2YBi9V6JBVDAr4YX2+IpeLj9yesd
 sWw14AWI
 u2rTItGWkpw9bP4dDdutKmSWSOlhh53/4jfe/g2uAWyRFhLMq57q7NnS/vNoSIYzgA/agdJc3jeGCZj3sb8QXUv4HtFuGsUJcepYTkc+rI7X0ZEZVRblkrDmll50DnHLc91h6p/pCm/kU4qZYK5+9hS/2dv+li+iAeD3yjugNp2M+FuORpeIKHxarVE+FVg6VlxGduREUdC7HLbaLUleGaZiIMQ==
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


