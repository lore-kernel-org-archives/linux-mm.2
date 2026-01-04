Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EC9C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 08:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987246B008A; Sun,  4 Jan 2026 03:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9351A6B0092; Sun,  4 Jan 2026 03:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8375D6B0093; Sun,  4 Jan 2026 03:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72F716B008A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 03:54:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D92113B2C3
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 08:54:44 +0000 (UTC)
X-FDA: 84293670888.29.601529E
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C0AB1C0003
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 08:54:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QNobZtzz;
	spf=pass (imf21.hostedemail.com: domain of 30CpaaQgKCN8CJOHKJBPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--bingjiao.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30CpaaQgKCN8CJOHKJBPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767516882; a=rsa-sha256;
	cv=none;
	b=iVkcc6X03n93cMVUbEaF3i9rMvQTCAyYJoGJuKSUUd0/FTJg6QA9BZ+7yZ26gJ2bh4ZkVk
	JBgszoPSKShsPb9YEcsL/45sZJQe3ZeXaaaPOdbr2gbd8FU+kYGixDfVQ5NOGQFcTACvf5
	JdpNwljy4YFPvJ+hvtXyuPA7y5ucT9k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QNobZtzz;
	spf=pass (imf21.hostedemail.com: domain of 30CpaaQgKCN8CJOHKJBPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--bingjiao.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30CpaaQgKCN8CJOHKJBPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767516882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8elJMWPjMs0XkG/FEkWBkLMbCQyfYnBpuHl89Qv1Qc=;
	b=8IvN/hxmLnsEm2tySrdo1mhyXIIesHGVzZV1zGocDAHPX0MyNDug+froyXLBg0ZUk5grIC
	HHPWWU7/hgx1q88IV+DU7UTp6e9vZWTogao4q03B3tcqdRfD0hH/+iGWOawfPJPH+qSsiE
	paJ7zOMZnEX6wJyMQ8SJSElfELxoYio=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0f0c7a06eso276169175ad.2
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 00:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767516881; x=1768121681; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y8elJMWPjMs0XkG/FEkWBkLMbCQyfYnBpuHl89Qv1Qc=;
        b=QNobZtzzGACz2Js1JrYUs/2Oj2DKchClrsWLijBBOXHfctQ0iKCxiXa78LDrLkapeL
         xR6r9MyaU/M050jlIIHTXFd3wfUeZx7jlxXZJLbprbcyUUttE7zj/8hZvmv6GOSFGLsm
         md0QacPzjI1moB83RbTcDIjDtPGTWP8um15aOej1rGDdft6G+tc/2CuiIXIM54+FfZ/l
         Ygx/5SXeStimUqJ76UEuY7nVJaIvUnkm+qfH6oOS490gepeydKRPwLQY+tpnKQ2Ve0Mr
         bpYCX7EJpxWgarySoerkE4ocQ0GATgm68zLxCovgB8YZ5h4CG2Qg/7NMBYBc6DbwLTY0
         eh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767516881; x=1768121681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y8elJMWPjMs0XkG/FEkWBkLMbCQyfYnBpuHl89Qv1Qc=;
        b=qSny8ma0BAds2ytdRjwH01B8pALqb6cAH65j0ATdRYCVRVLiQQ4X9rCTuI8VKyl01c
         7mC2fp8oIp+GKkYXIcDtW21j6LqmZ2BOKxgbWvTDmcez4HtLz2qx0WYpmCzD67Wx8PuW
         I3cUGqq8K/8LCRxbsFv8+1TMdJeZwXnw4Z2wfmuFll+RDEFW77gHg8mB0RuumuLjh8+y
         FJdO4ZMrfYoQzW8KFeAZ8ar3b9Sa7OlIit8nM/vlHYK5EP7iJ+uqmXRUoN9oCpCWJBND
         uJVvS5nyPGEth/f7Tddx9hLZYS1u98aDOtb1NNHIJA7MECLZWNK1Z8JAWoiRtGsn8GaT
         +EdA==
X-Gm-Message-State: AOJu0YwSmwbgmsCO32nCc8MnLzjsl+iqnnnmeozMj8qkb38hQl1ukKCR
	8rS/Go3ohYZ4SN025huX2Wl9sfONv2td/A/KsdVHFu3wIXTr5Y2Xr8ic/zEl4LZku9LqcIFqZP8
	iCgNF5io2rylQAIzzGEcaS79DL9MoPiUdLMkwTef+o6uMB9RchV1XvwU7XfTSFtji3LVpFAOqHE
	86KfKrC0UkELbqqMDOdh7zWX7xbt582KroDxNuaqM29w==
X-Google-Smtp-Source: AGHT+IFkkIq48VPz0jCSFUEY3kHRMnJcthmvmoml7S8VPslj3aDivZGf4nrCSTp69Tv0P+luUh/xpxWXxsZCKw==
X-Received: from dlaj14.prod.google.com ([2002:a05:701b:280e:b0:11f:464f:4c69])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:258d:b0:11d:f464:5c97 with SMTP id a92af1059eb24-1217230621bmr41689090c88.39.1767516880809;
 Sun, 04 Jan 2026 00:54:40 -0800 (PST)
Date: Sun,  4 Jan 2026 08:54:05 +0000
In-Reply-To: <20251223212032.665731-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20251223212032.665731-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260104085439.4076810-1-bingjiao@google.com>
Subject: [PATCH v4] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gourry@gourry.net, 
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	cgroups@vger.kernel.org, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C0AB1C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: bjigz5bh351x61dmaz95hgxjwhq7j11d
X-HE-Tag: 1767516882-597943
X-HE-Meta: U2FsdGVkX1+a7ldflQssHRWmjFRVWkKZTq6Bi4wLFBhMB70KvCZUbskiYQgbYqHQ791ptK0YJwzEC0VP+VLQnIM4WQku3UGxusz0VSYePyuyyTJYuBVsMrZiqyOPyo5YMTwsyQegU5P4CDf2oV4DswUV940Qwx5PMR9u1uONQyvwhaTjmiodne4/t4E3JZFb2/VewvtfJ7yhqCmx0blxsJ4NSy2/ZfPqhAic9oBEzZ/H7vJDsGd18bXOh2XBkVnZvwOB+LeMKNF6JV5yjZwZdc0rpLD9VWMhd/8fbWkUlIKcHZ/Mnh4RvUie2Sz1UtctLu06JTrbC+2RlMCei6s9/0OkqGZcF8XkYXaE0M8mSnebSq79Gs6JAu0nOg6tYGXddtO7O15DncCUXCbi0QsdlRvlgN07XphonjmAhUHiJc9jhYhtYcmGHBhno3anIn8xWiPekKOHFwCPiOjHk/EAlv7NU6KUVDtlCeTaFoacnZFoa5blpRd9zlBCT5Xshh8l8q/6eweMV4qYvIkLNjkG710yOTwPCkIm+GTPNnp8uS2M8ezZqTwFzU/K4tkFeDHNKR2xSODkWAloRuk8rxjWHASyiSTUORm8RQs4wo2QMjS9Ax96YaFlFTPvdvCl4WV0Cz815dX1sVe4Bn1Z8xbrO4oT2rUn37FoV1jeDnfs8mMvZQI4//UtoQaMlTGHFNdLSZe9WKxrpx+et8a0JUO/gWcOS89gT4PhzOsuoC8oRmd9Nn9Bc89aVGsfLOFG6SP59hTOexPRH7xzb569pDLFBRmC/p7eZYfuU5xOE6EXiI3JwEN6ZfuDU+F4DXp+zWvif8rXbYRnHpgp0aJiTGuvjbuUF1T/4bPn+czolO71tDNSgolFW/uxfkqnxVFbznmEkJiDBkF053UB/XO0l6wAUauMovk++fMVcDcviwbz0uysSq1HMz7c5tKSgRznfk67qOkSvEITbm8Sa4SNHA6
 YW9zXJL9
 UURLxoPM9kCWGSJcwlEMCsaKW/4uA7VC3gJ5136f+RcTh0d8XTwtwhIsuLE9OjzWtfPuVjm3n0u00VDPtqnsVxFQhkMkB0hesufTxrbS8D/GgA/ba2ZoALnNim+KYZdFJ+m5H41haogLWx757UdUoSy5LnxniSx9lWz9Bk/ftfbHDXI2in52seCW9wjGpnBpTN5lFxo3+00e7vTByz3vrZgTqRGAVKfl37+n1uoPnZqpFl+J3RlxH12d3km3OqUdSdFTCa6wx3ng3MVceYOLDT+uc+A6DQPuLQ+swGOf+BILguLRH0qbdHaL/SLHXF5F+5Mne8YBugWuz2pChMqpegxDrlY9zhv5k6r7r/sQhMmIWGs5sjzj3VNhNBaa5UItFZE5JQamWujjToHuyt8BQI7JEeUlylvzrT938DU7+ZB2ChqRqfDImgLjiSks5XlMubcpbxV44djEAP5Maot+aktPhkuZjrp5eFz/o+URPrrxwebUA8rt4cApZlIpEkJKxcGqVQvgDFuLM6Z56XkavhP/+3aerQEpr5ouAzGP94KA5ydWRjX/It34vSADDYGBkg1OPBo6H2vZ+bgmICmnFw4tR/bj0gn915AL4ONkNPI07F3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two bugs in demote_folio_list() and can_demote() due to incorrect
demotion target checks in reclaim/demotion.

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to
can_demote(). However:

  1. It does not apply this check in demote_folio_list(), which leads
     to situations where pages are demoted to nodes that are
     explicitly excluded from the task's cpuset.mems.

  2. It checks only the nodes in the immediate next demotion hierarchy
     and does not check all allowed demotion targets in can_demote().
     This can cause pages to never be demoted if the nodes in the next
     demotion hierarchy are not set in mems_effective.

These bugs break resource isolation provided by cpuset.mems.
This is visible from userspace because pages can either fail to be
demoted entirely or are demoted to nodes that are not allowed
in multi-tier memory systems.

To address these bugs, update cpuset_node_allowed() and
mem_cgroup_node_allowed() to return effective_mems, allowing directly
logic-and operation against demotion targets. Also update can_demote()
and demote_folio_list() accordingly.

Bug 1 reproduction:
  Assume a system with 4 nodes, where nodes 0-1 are top-tier and
  nodes 2-3 are far-tier memory. All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Should respect node 0-2 limit.
    # Observation: Node 3 shows significant allocation (MemFree drops)
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1

Bug 2 reproduction:
  Assume a system with 6 nodes, where nodes 0-2 are top-tier,
  node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
  All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Pages are demoted to Nodes 4-5
    # Observation: No pages are demoted before oom.
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2

Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bing Jiao <bingjiao@google.com>

---
v3 -> v4:
Update functions to filter out nodes that are not in cgroup's
mems_allowed rather than returning mems_allowed directly.
It minimizes stack usage and remains versatile enough to return
mems_allowed when all possible nodes are set in the passed
nodemask_t pointer.
---

 include/linux/cpuset.h     |  7 ++++---
 include/linux/memcontrol.h |  6 +++---
 kernel/cgroup/cpuset.c     | 24 +++++++++++++++---------
 mm/memcontrol.c            |  5 +++--
 mm/vmscan.c                | 32 +++++++++++++++++++++-----------
 5 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..c937537f318a 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }

-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern void cpuset_nodes_filter_allowed(struct cgroup *cgroup,
+					nodemask_t *mask);
 #else /* !CONFIG_CPUSETS */

 static inline bool cpusets_enabled(void) { return false; }
@@ -301,9 +302,9 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }

-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+static inline void cpuset_nodes_filter_allowed(struct cgroup *cgroup,
+					       nodemask_t *mask)
 {
-	return true;
 }
 #endif /* !CONFIG_CPUSETS */

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fd400082313a..911e0c71453e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1740,7 +1740,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 	rcu_read_unlock();
 }

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);

@@ -1811,9 +1811,9 @@ static inline ino_t page_cgroup_ino(struct page *page)
 	return 0;
 }

-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
+						  nodemask_t *mask)
 {
-	return true;
 }

 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..cc0e1d42611c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4416,27 +4416,34 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	return allowed;
 }

-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+/**
+ * cpuset_nodes_filter_allowed - filter out nodes not in cgroup's mems_allowed.
+ * @cgroup: pointer to struct cgroup.
+ * @mask: pointer to struct nodemask_t to be filtered.
+ *
+ * Description: Filters out nodes that are not in mems_allowed for @cgroup.
+ * Nodes returned in @mask are not guaranteed to be online.
+ **/
+void cpuset_nodes_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	bool allowed;

 	/*
 	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
 	 * and mems_allowed is likely to be empty even if we could get to it,
-	 * so return true to avoid taking a global lock on the empty check.
+	 * so return directly to avoid taking a global lock on the empty check.
 	 */
-	if (!cpuset_v2())
-		return true;
+	if (!cgroup || !cpuset_v2())
+		return;

 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
 	if (!css)
-		return true;
+		return;

 	/*
 	 * Normally, accessing effective_mems would require the cpuset_mutex
-	 * or callback_lock - but node_isset is atomic and the reference
+	 * or callback_lock - but not doing so is acceptable and the reference
 	 * taken via cgroup_get_e_css is sufficient to protect css.
 	 *
 	 * Since this interface is intended for use by migration paths, we
@@ -4447,9 +4454,8 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * cannot make strong isolation guarantees, so this is acceptable.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
+	nodes_and(*mask, *mask, cs->effective_mems);
 	css_put(css);
-	return allowed;
 }

 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75fc22a33b28..4c850805b7a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5597,9 +5597,10 @@ subsys_initcall(mem_cgroup_swap_init);

 #endif /* CONFIG_SWAP */

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 {
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+	if (memcg)
+		cpuset_nodes_filter_allowed(memcg->css.cgroup, mask);
 }

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ac16b6b984ab..919e116ddaf3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -345,18 +345,24 @@ static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
 	int demotion_nid;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	nodemask_t allowed_mask;

-	if (!numa_demotion_enabled)
+	if (!pgdat || !numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;

-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	/* Filter out nodes that are not in cgroup's mems_allowed. */
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return false;

-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
+	for_each_node_mask(demotion_nid, allowed_mask) {
 		int z;
 		struct zone *zone;
 		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
@@ -1029,7 +1035,8 @@ static struct folio *alloc_demote_folio(struct folio *src,
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
@@ -1043,7 +1050,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1051,10 +1057,14 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1576,7 +1586,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */

 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
--
2.52.0.358.g0dd7633a29-goog


