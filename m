Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848C2606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB2A6B05B7; Wed, 28 Oct 2026 22:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA24C6B05B8; Wed, 28 Oct 2026 22:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B88B6B05B9; Wed, 28 Oct 2026 22:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 836486B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:28:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F61FA0274
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:28:19 +0000 (UTC)
X-FDA: 85374079518.16.88356CD
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4283A100003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:28:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1GbYdbaiGfxxITdI36MsaSn6x9+xGnsrtdyhtRu9O8k=;
	b=crZpBQfGEhsmhgMFziqfh+PpryiukTu1vu6nOyF2ZqEQUgWoEwuycxoFaJmqT5Sp1Qgjim
	FXjG73fdN7kObU9yzQV1a61+0rCaZ2neXB+DAwZyUxyQXmSZpSb8jQiEXnAKKZ6MOKHous
	ks1ZJEGCw3mOtJf8TTrDWbPdrHOH0RI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240897;
	b=WS9tTrolkwcX9gPKz57J/wyNNpxwX1FcEl0Gr1PWCbXTthbceAwGC8zEX0moe1ByMxB3ZL
	AOK0C/BM1XnRNtwti9uDBHZVraMQ5Hl4foPEfaLMRMeeFgNfc3H9+niGYQV14TVXVVlWt4
	Y8gjSCxIjVb5UKwjzuPQK37t1FM8W+8=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSnl6ym1z171YM;
	Thu, 29 Oct 2026 10:28:11 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jFSnj4Sfzz171ZL;
	Thu, 29 Oct 2026 10:28:09 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id C687C16DE;
	Thu, 29 Oct 2026 10:28:02 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 29 Oct
 2026 10:28:08 +0800
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
 Hildenbrand <david@kernel.org>, <maddy@linux.ibm.com>, Michael Ellerman
	<mpe@ellerman.id.au>, <ljs@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wujianyong@hygon.cn>, <jianyong.wu@outlook.com>,
	<zhongyuan@hygon.cn>, <huangsj@hygon.cn>, <wangfengyu@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: [RFC PATCH v3 03/17] sched/topology: Add an iterator for cached NUMA node affinity rows
Date: Thu, 29 Oct 2026 10:20:21 +0800
Message-ID: <20261029022036.4002331-4-wujianyong@hygon.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029022036.4002331-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4283A100003
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: x3rtynfmgjx4nhjzbm5mb58t4n4db9o1
X-HE-Tag: 1793240896-526692
X-HE-Meta: U2FsdGVkX19MGrdSIfZDDGsiTmi7Q5R6cdtw8xOW2iluuhwNEYrfY2QVnBYsLVv7fRv4gpO7+XBhUrBqZV0pqQIafQ2KEFrWVz5lXNzV5CTLU/YKZeA0YuwDg860h4M9sHUoy5sT84Cjm9oHzRB84fqPhd/aNGUiy7cWfPjJJyb2bvXaSuz8mFxqX6QIJlLsXc83I7C7UovVIbal6S7eho0Ou3LMILmNX1g0g5F4Uzut27O6e99Fc6B5TGXJrqzecS4poTUidudLRI/FOw2r+uQsZuyEESf4lCxCZVFTQ7Qp25jaX/aYnjLRihXyjrZ2+Wk91/If7PbVWztCFyYbLbCPmobIECCSET2jNnNoAV9PXE+lX9KVTGMzrVmd0L7IV0+S4tDRwwWJYYUqX1O+Jd+cCib8rdvcLCE1UHsKjpIaYOhXO3Mu4w6l4ocO00DG3KoPtzAU0Lw6b9uT4pvo5mIaQO8HC0VGFlxJrHMGewmrIPPPX01wiiXfxYAw7PSsNO+7mLLVXTPrG0DYc9t/iJ4uGMuzAnSz9W6uO6ATWg0yUoenG8i4yinbEVxUa0/3FLhrkGTFIC1GMenJuT0fpsLItu5e2/h1p0SiWafB9iTy3NlNcdckOcnQbt/CNqrfxim+cdfJKIBSTbqSDVtW4Lqk8WSkMhnYg2NEILN8y+hYnMAveV8u5HsxV/yRFZdE3gxBlf44KIC3uaL39bYxewDyGJ0WXHTgu3wgZdRpWdeO2M5f45da3PLiPeGQ45FjKWEBsZPjmlDSV17mz5CbgGr9fzRA2BFB+uhzRV4Sibio5BmT7y6MogvDvZNT7meZaQN0iC306zSY1AWYl2fHg7t7+7p/48+EdauPD9wnzaVafFsIHXeX/1tVLZ9XMQx8ExPfTKj3RaLoCx1xX92srn1JCYdXYpoCxQf0axNIBbYkpWdpW3B33griLp41GEwu9xCNlIf5pK+gqbuzxFB
 omUKgjHD
 SLN/JnSktDYpSsIGo/sNbzhLaBuYNISmI1j7ChlstQoH5tRm40LBiW4jUjbinA3vW9+9C3/qp7lU80eW394jXDF6X9Cml6rlwTMG1m0dR3d7fp7pSSYhCOv4ALruFqKLeXQ0BNEpuHInqtawJXMEUHWaMlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Provide for_each_affi_node() to walk the cached node affinity sequence.
Visit the local node first, then remote nodes by raw NUMA distance and
triangular tie rank. Include possible nodes without CPUs and skip holes
in the node ID space.

Pin one immutable row under RCU for the entire walk so rebuilding the
table cannot change the ordering midway through a migration decision.
If the table is unavailable, visit only the local node.

Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
---
 kernel/sched/sched.h    | 24 ++++++++++++++++++++++++
 kernel/sched/topology.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4dba127f1d4f..5d3fa5d70d16 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4140,6 +4140,30 @@ sched_cache_numa_key_cmp(struct sched_cache_numa_key a,
 	return 0;
 }
 
+struct affi_node_order_iter {
+	const int *order;
+	int root;
+	int nr_nodes;
+	int index;
+};
+
+/* Hold RCU continuously from begin() through the last next() call. */
+extern struct affi_node_order_iter affi_node_order_begin(int cpu);
+extern int affi_node_order_next(struct affi_node_order_iter *iter);
+
+/*
+ * Walk possible nodes, local first, then by raw NUMA distance and triangular
+ * tie rank. Pin one immutable row under RCU for the entire walk. The body
+ * must not sleep; break and return release the scoped lock. If the cached
+ * order is unavailable, visit only the local node.
+ */
+#define for_each_affi_node(cpu, node)					\
+	scoped_guard(rcu)						\
+		for (struct affi_node_order_iter __sn_iter =		\
+			     affi_node_order_begin((cpu));		\
+		     ({ int __sn_node = affi_node_order_next(&__sn_iter); \
+			__sn_node >= 0 && ((node) = __sn_node, true); });)
+
 /* Node IDs in, zero-based rank out; -1 if unavailable or invalid. */
 extern int affi_node_rank_of(int prefer_node, int node);
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 6b7b38eb7cd3..8d0fd0f8a67a 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1101,6 +1101,38 @@ void __init sched_cache_init_node_order(void)
 	sched_cache_numa_distance_update_end(true);
 }
 
+struct affi_node_order_iter affi_node_order_begin(int cpu)
+{
+	struct affi_node_order_topology *topo;
+	struct affi_node_order_iter iter = { };
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(), "node order read without RCU");
+	if (cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu))
+		return iter;
+
+	iter.root = cpu_to_node(cpu);
+	if (iter.root < 0 || iter.root >= nr_node_ids || !node_possible(iter.root))
+		return iter;
+
+	iter.nr_nodes = 1;
+	topo = rcu_dereference_all(affi_node_order);
+	if (topo && iter.root < topo->size) {
+		iter.nr_nodes = topo->nr_nodes;
+		iter.order = topo->order + (size_t)iter.root * iter.nr_nodes;
+	}
+	return iter;
+}
+
+int affi_node_order_next(struct affi_node_order_iter *iter)
+{
+	int idx = iter->index;
+
+	if (idx >= iter->nr_nodes)
+		return -1;
+	iter->index++;
+	return iter->order ? iter->order[idx] : iter->root;
+}
+
 /*
  * Return @node's zero-based rank in @prefer_node's affinity order, with
  * @prefer_node itself ranked first. Both arguments are node IDs, not CPUs.
-- 
2.34.1



