Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD79C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899A66B0095; Thu, 27 Aug 2026 08:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73CDA6B008C; Thu, 27 Aug 2026 08:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D606B0096; Thu, 27 Aug 2026 08:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06BC66B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:33:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 938671A02E2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:17 +0000 (UTC)
X-FDA: 85146989634.20.CE6E9F6
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6BFBC20002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:33:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787833995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYtBX+eP9IXbWp0lnGfody1PHk2L9omaW9fny3ZCN5Q=;
	b=se1rzuQhJPIhY0KA3zyJ5sjQJDk48BWqap8WobLBtVbgb8jh5QxoXXicb3Od8oTaTyhNlK
	oxK3vZRSrbSYj72A2iGu97iHaZOGqGv24PXQUetG1GtA1bRVpIwgDuwOAd6lFAQxBCIQ2s
	uUUvY+GWbxi9INC1HvGesU6c5B+2VH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787833995;
	b=ZdNC33VWvFfVcD38fEnr08OOM3w2fl3P3and4akWjMBUDnsVUtmlcUlaTb58w+AtncHWSb
	FipSSAXuBUy8OoSedzHUA+V2lw41TkWzBBSiltX+MF7Vhqk+xDHOAz4Maam1xxWwLbrIWa
	76cdb7D9DFP/7fNZCmz6DDCjjwpCo3o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bt0W12zBJb6L;
	Thu, 27 Aug 2026 20:33:10 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hW1Bs4rfxzBJY4k;
	Thu, 27 Aug 2026 20:33:09 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 44773103F;
	Thu, 27 Aug 2026 20:33:02 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 27 Aug
 2026 20:33:08 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>, <justin.he@arm.com>
Subject: [RFC PATCH v2 03/23] sched/topology: Introduce a macro to traverse node
Date: Thu, 27 Aug 2026 20:27:56 +0800
Message-ID: <20260827122816.756234-4-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827122816.756234-1-wujianyong@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6BFBC20002
X-Stat-Signature: t7n1f4qkprsk6pm9dn8y8acgu1wxisrq
X-HE-Tag: 1787833994-630320
X-HE-Meta: U2FsdGVkX1+QjovWSqRnSoRYT4aY5llY8THUkHAMZN7l5wkfagmG95Fsco4VZH9EGUP0wNNS6zr/56CHA/OzQzi4iAjIu9tun4vOg9aHEv5su7bZFqR6nR9K8sPD6MrL/HKq88taAPsyasGPWOkYzduN0zMUqYaQ6QYUudvB26chELroZ1eBieW13+Aqk/5LmIe+ps8XWsV15f61HzhHNes44cykEVjWgHp34b1+HowMyiGOairZ7zLFdNfe8qXorQjF2xBLrFQ4Y1uIgqQCT39QbgD37gsvUVftNpn4rQr9WFu9iwpHX+9i7FBkvp6RXjwIDPc3NjLlUD7KeyoTEaJEiprUiKaU3o8kLLQg2+q/1wtmNyCVg5xoZlPJf+Jcp/42boOCGB1LdJDsA1fWM9QbagNR/XYmd0D/ou/ORvrm4abfSU0oqwemWyWCzMCyu6UOc3NbMNLlQoBKmckdQoDq8kzg04uTDrnyJexjDMyXq68FI/ITN3x8rbTDwTXH+beyWg0HzWveTScJHU2h+dleHRi7KSLwwtTXpt6LHh2wX3OY2DaYAJox7Tl6XCr5WUMxH1WzqAKIW8hxGoPO4lnT0J5zGbh4jL6Y1q6ZqAun/L3BXD7mzySHO8MfVTIEKh41K9r+3YJDkjOdo5D+e+UpJsWho3kLu1VrAWS7yJAYGYaSKTv0NBKvYCoTU6Y/7qX+Opj+9KJIogfuyuRc8Goeg528I2Gn7z32QIm2Yuw4DrQSdczcaATiFN7mGyuP24mrhACB+oCJMX5LVqJ+42rKgIpOv+J8OeeoJbeZXfvDzZodrdfs7vR6g1CyoP63JmpeDZl9q4Qe8WVvto9wAnS2WforfEURZBCtGUSVvaXozQq3rhlR+uvhBwtw0f4IJ5DNqn67GUfIEUYS3yU+/NuwhqDYwwFsA7NATuP8B+3pjZ/RIRZt0OXEYiQENjKrAOwaUzSeTBIWBGMmZEI
 pGC3PLMS
 FQymZr5hHED3ZtCxSE04PJEfuXRqjHuWxg2u5yKaYPO/ofuNaYeJ7LZsbC8hQYVZiLOYzLHqh70OlpxlRHb8JlMokFX05STKJjJ0kk4qD/pOryHPY4PS4+rLtt6RU7fCR/gSGmy1uFCPZYMQN9HbC/0GPW+JYspAZAXS5sWxIGjzsiNpc5nkM/YNSdNrLgeY9J92dccuSJvQK+8fbSrFUcTRIaDu6qZHAFWplFnnHxz63NoKEtqC+vBlMA9AQbRLhRjhykdxDR1aqAjgOVyAoB1mFP8cIMJrNmLbW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a node traversal macro that leverages the refined node distance matrix
introduced in the prior patch.

For a given target CPU, the macro walks NUMA nodes sorted by ascending
distance entries taken from the matching row of the refined distance matrix.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    |  16 ++++++
 kernel/sched/topology.c | 117 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 56acf502ba26..88b71e0f5ef0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4108,6 +4108,22 @@ static inline bool sched_cache_enabled(void)
 
 extern void sched_cache_active_set(void);
 
+extern int sched_node_order_count(int cpu);
+extern int sched_node_order_at(int cpu, int idx);
+
+/*
+ * Walk every NUMA node in the system starting from @cpu's own node,
+ * nearest-first by the de-duplicated sched_cache_node_distance()
+ * matrix (topology.c), until every node has been yielded. @node
+ * receives the node id at each step (index 0 is always @cpu's own
+ * node).
+ */
+#define for_each_sched_node(cpu, node)					\
+	for (int __sn_idx = 0, __sn_nr = sched_node_order_count((cpu)); \
+	     __sn_idx < __sn_nr &&					\
+	     ((node) = sched_node_order_at((cpu), __sn_idx)) >= 0;	\
+	     __sn_idx++)
+
 #endif
 
 void sched_domains_free_llc_id(int cpu);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 4c68dfe86019..166ff4e65a99 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -701,6 +701,7 @@ static void rebuild_llc_node_map(int size);
 static int __rcu *sched_cache_node_dist_matrix;
 static int sched_cache_node_dist_size;
 static void rebuild_node_distance_matrix(int size);
+static void rebuild_node_order(int size);
 #endif
 
 static void update_top_cache_domain(int cpu)
@@ -1147,6 +1148,121 @@ static void rebuild_node_distance_matrix(int size)
 	kfree(matrix);
 }
 
+struct sched_node_order_topology {
+	int nr_node;
+	int *order;
+};
+
+static struct sched_node_order_topology __rcu *sched_node_order_topo;
+
+static void free_node_order_topology(struct sched_node_order_topology *topo)
+{
+	if (!topo)
+		return;
+	kfree(topo->order);
+	kfree(topo);
+}
+
+/*
+ * Generic {distance, id} sort key: candidates are ranked by @dist, with
+ * @id as a deterministic tie-break when two candidates land on the same
+ * @dist.
+ */
+struct dist_key {
+	int dist;
+	int id;
+};
+
+static int dist_key_cmp(const void *a, const void *b)
+{
+	const struct dist_key *ka = a, *kb = b;
+
+	if (ka->dist != kb->dist)
+		return ka->dist - kb->dist;
+	return ka->id - kb->id;
+}
+
+static void rebuild_node_order(int size)
+{
+	struct sched_node_order_topology *topo, *old;
+	struct dist_key *cand;
+	int root, i, k;
+
+	if (size <= 0)
+		return;
+
+	topo = kzalloc_obj(*topo);
+	if (!topo)
+		return;
+
+	topo->nr_node = size;
+	topo->order = kmalloc_array((size_t)size * size, sizeof(int), GFP_KERNEL);
+	cand = kmalloc_array(size, sizeof(*cand), GFP_KERNEL);
+	if (!topo->order || !cand) {
+		kfree(cand);
+		free_node_order_topology(topo);
+		return;
+	}
+
+	for (root = 0; root < size; root++) {
+		for (i = 0; i < size; i++) {
+			cand[i].id = i;
+			cand[i].dist = sched_cache_node_distance(root, i);
+		}
+
+		/* sched_cache_node_distance() guarantees no ties within a row. */
+		sort(cand, size, sizeof(*cand), dist_key_cmp, NULL);
+
+		for (k = 0; k < size; k++)
+			topo->order[root * size + k] = cand[k].id;
+	}
+	kfree(cand);
+
+	old = rcu_dereference_protected(sched_node_order_topo,
+					lockdep_is_held(&sched_domains_mutex));
+	rcu_assign_pointer(sched_node_order_topo, topo);
+	synchronize_rcu();
+	free_node_order_topology(old);
+}
+
+/*
+ * Return the total number of steps in @cpu's for_each_sched_node() walk,
+ * i.e. the number of nodes in the system. 1 if the topology cache isn't
+ * populated yet (e.g. very early boot).
+ */
+int sched_node_order_count(int cpu)
+{
+	struct sched_node_order_topology *topo = rcu_dereference_all(sched_node_order_topo);
+	int root = cpu_to_node(cpu);
+
+	if (root < 0)
+		return 0;
+	if (!topo || root >= topo->nr_node)
+		return 1;
+
+	return topo->nr_node;
+}
+
+/*
+ * Return the node id at position @idx (0-indexed, 0 == @cpu's own node)
+ * in @cpu's node's ascending sched_cache_node_distance() order. -1 if
+ * @idx is out of range, which ends the for_each_sched_node() walk.
+ */
+int sched_node_order_at(int cpu, int idx)
+{
+	struct sched_node_order_topology *topo = rcu_dereference_all(sched_node_order_topo);
+	int root = cpu_to_node(cpu);
+
+	if (root < 0)
+		return -1;
+	if (!topo || root >= topo->nr_node)
+		return idx == 0 ? root : -1;
+	if (idx < 0 || idx >= topo->nr_node)
+		return -1;
+
+	return topo->order[root * topo->nr_node + idx];
+}
+
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
  * can use. A CPU within a cpuset partition can only use a proportion
@@ -1218,6 +1334,7 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 
 	rebuild_llc_node_map(max_lid + 1);
 	rebuild_node_distance_matrix(nr_node_ids);
+	rebuild_node_order(nr_node_ids);
 	return true;
 err:
 	for_each_cpu(i, cpu_map) {
-- 
2.34.1



