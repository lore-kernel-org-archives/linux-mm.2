Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90C1D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8E56B00BF; Wed, 14 Jan 2026 06:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BD96B00C1; Wed, 14 Jan 2026 06:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EF36B00C2; Wed, 14 Jan 2026 06:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06DF06B00BF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:36:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5CF9160486
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:01 +0000 (UTC)
X-FDA: 84330365322.07.C3051B4
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11159120004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M6fCdsWR;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrIiGmzrPddCzyrKZdqDkSj0MgSt0dRpJv5I1+lcafw=;
	b=PLSpaSKnNW7eDUtf6XUYfFjyy4WutVyCTi60d8lc6BefyrVE6lpCGnPlZQucKRpbL/DpDP
	8sjO630XgefQptklYHcFIO9fO0cjzen7CRHfhlDYnjUA9qSOhi/4l7VNOo3RckZ7Gp/gJp
	XZW4PMiUHOZJSaGtmlrwyVfSo2z1Iow=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M6fCdsWR;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390560; a=rsa-sha256;
	cv=none;
	b=gnX0D1Io8N8L3d70/FH2S0y8DPDj82Z/652aIaOy3FBytR9gZmxAo7rwOM8yaLusyh9J6j
	2/xQ5qdijx/Yl6rNvL8LDP6vqSM0TEDAsSz8pp+MpjpT2uvhJbBAsn9sVkaejPY1WMZCWj
	LLBxEGNWWixG+Ca8D3KtNzdd0sI0amA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrIiGmzrPddCzyrKZdqDkSj0MgSt0dRpJv5I1+lcafw=;
	b=M6fCdsWRiOPynPpGQoKa+M9QMkaiLufFtqZyCqB7CkCQpzXxZ/BaAInFTO+f3iCBtlui1E
	5QrID4zcWlG2j+JEofg84xWeLhlxNLt/TAw94oXPVS2ieVCRgFvI0wTkiJKx1zof1gwJwl
	1OrjEB74AwD5y9miusJ0SyiNPwMEqck=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional LRU folios
Date: Wed, 14 Jan 2026 19:32:52 +0800
Message-ID: <3adb367000706f9ef681b34d0a2b0eb34c494c84.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fkf83h9ue18pr1mukcs759eyh5w7jdde
X-Rspamd-Queue-Id: 11159120004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768390559-111970
X-HE-Meta: U2FsdGVkX18gx+SGAw5ZK7UJdy85bVcZ0cALYBMBAcOWQO0qdA4VcTJXmsTSV/o+ev4SRim2itngVoUMB6FtAVN67FQE65ySrG7gx1LXn08fBefks6ETXZent9cFEekTFAgkACTF51EjdeCT/rWWfPx9NanIM2iB3VfcUcvD7fk8eeVJorVCQLZKbOK0n+ka7eSE9Q1wbDOAVWzJfL0B0WcpXfWoT6EiGQHRloC2r63W5sMz7/s8Mn4TVknDPoKUgc/BM21HAcnGIvWkWVN6asu6zBYzJAoGJ4wGI04GBsZZSL7KIg8kPCBBeExpvsdHA+msgUYxHGoXJeEi7y/mMPKBCPB0OD8T/VlhgvEm6MGXubudU5H3WhI+iKJHgCBGjxhJaJ02rvkI03iUg+e3Jvvi1BUKOUEu/hk+jO2EfvYL/JEQmv4T9pJUAZJQBMQKFHySbOmL8dYC6Sagzx8/FSWYqZseb7cyBqZuVLZ29AFxh8A4SQm/A3R2YtzJvBee7eOzycoSflALMZinBqe9BtAc7xbLN+LFMR+dFHYLqCOoIDEsExat7W5o8Yaq913heycmaaR5Iu5DJyDJQTgFJGk0R/YcIT8Vbl04q4P8njajO0fGz5wE/BIuZ/IIrMAwnTz3D1mQnZrh+3tGgz9i6H++LUl5PEMSLfrIvFs/kpw93HoZ1vNNxsBsE3NmOER/1MHGhufyxCaincNVO61nIwoGLHLRHNrWJ2fraAiyqlmqbgF7SUno2Dja2weYjb3kuCD5Qcd3y39d14ipPRdluboNyA+1it8Jf7e7lbOKzV79s08l6qlquEnL36u4pzFPRKEKPYEf9LJEujyIiad0oWrtEdO0qLFyZK+ufCSKuJGPMUOKXvbGM/nY3wbntRi8YNdWWTx1OOHBXeCTi7tUz2w1Ml6/3IY6+ysnDdTyAjpV33IikOdsF2mqP6xVP0zdZ2c8MtokiZot6TihSBe
 yICqochG
 PKXm/fuAfaMqWTZxUDLGy/TIpfe59wf5NLSfErQatgt3GG4A9HSElYg+oxMOIcRDbBULBLQ0d4PhRHIxquekFBno4xBhgkVU41gZAGG4vpzjXYIq0gz6LhIWEfoSGVnJQFv7TCaeBJdeHvSOUuuyD4fka1BWhJfgn6PVvaWC3CLlDivh71LTkhGjY0tH+6NJufdrwFLFBKdrfazF/8/P9eThF+MarDLhddPLMh2PIhAHVmBZx5S+t+gVBsOnSCHEX93vlSe8tSjvhk3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

To resolve the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg. For traditional LRU list, each lruvec of every
memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
is feasible to transfer the LRU lists from a memcg to its parent memcg
during the reparenting process.

This commit implements the specific function, which will be used during
the reparenting process.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mmzone.h |  4 ++++
 include/linux/swap.h   | 19 +++++++++++++++++++
 mm/swap.c              | 37 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c            | 19 -------------------
 4 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a7db0fee54a3..1014b5a93c09c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -366,6 +366,10 @@ enum lruvec_flags {
 	LRUVEC_NODE_CONGESTED,
 };
 
+#ifdef CONFIG_MEMCG
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent);
+#endif /* CONFIG_MEMCG */
+
 #endif /* !__GENERATING_BOUNDS_H */
 
 /*
diff --git a/include/linux/swap.h b/include/linux/swap.h
index e60f45b48e74d..4449d1f371a56 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -636,5 +636,24 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
 }
 #endif
 
+/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
+ * and including the specified highidx
+ * @zone: The current zone in the iterator
+ * @pgdat: The pgdat which node_zones are being iterated
+ * @idx: The index variable
+ * @highidx: The index of the highest zone to return
+ *
+ * This macro iterates through all managed zones up to and including the specified highidx.
+ * The zone iterator enters an invalid state after macro call and must be reinitialized
+ * before it can be used again.
+ */
+#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
+	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
+	    (idx) <= (highidx);					\
+	    (idx)++, (zone)++)					\
+		if (!managed_zone(zone))			\
+			continue;				\
+		else
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/swap.c b/mm/swap.c
index 7e53479ca1732..cb40e80da53cd 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1090,6 +1090,43 @@ void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
 	fbatch->nr = j;
 }
 
+#ifdef CONFIG_MEMCG
+static void lruvec_reparent_lru(struct lruvec *child_lruvec,
+				struct lruvec *parent_lruvec,
+				enum lru_list lru, int nid)
+{
+	int zid;
+	struct zone *zone;
+
+	if (lru != LRU_UNEVICTABLE)
+		list_splice_tail_init(&child_lruvec->lists[lru], &parent_lruvec->lists[lru]);
+
+	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+	}
+}
+
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int nid;
+
+	for_each_node(nid) {
+		enum lru_list lru;
+		struct lruvec *child_lruvec, *parent_lruvec;
+
+		child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+		parent_lruvec->anon_cost += child_lruvec->anon_cost;
+		parent_lruvec->file_cost += child_lruvec->file_cost;
+
+		for_each_lru(lru)
+			lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
+	}
+}
+#endif
+
 static const struct ctl_table swap_sysctl_table[] = {
 	{
 		.procname	= "page-cluster",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c48ff6e05e004..e738082874878 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -270,25 +270,6 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 }
 #endif
 
-/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
- * and including the specified highidx
- * @zone: The current zone in the iterator
- * @pgdat: The pgdat which node_zones are being iterated
- * @idx: The index variable
- * @highidx: The index of the highest zone to return
- *
- * This macro iterates through all managed zones up to and including the specified highidx.
- * The zone iterator enters an invalid state after macro call and must be reinitialized
- * before it can be used again.
- */
-#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
-	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
-	    (idx) <= (highidx);					\
-	    (idx)++, (zone)++)					\
-		if (!managed_zone(zone))			\
-			continue;				\
-		else
-
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
-- 
2.20.1


