Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF6CFEE4CB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE346B0089; Sat, 28 Feb 2026 02:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD53C6B008A; Sat, 28 Feb 2026 02:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE20B6B008C; Sat, 28 Feb 2026 02:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBD5E6B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:26:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 613C51A0B39
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:26:34 +0000 (UTC)
X-FDA: 84493032708.27.A5F0EF1
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id A906F40004
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:26:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZ8SJzEG;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772263592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wbr7DWLMow8e+4r0j50rgMHr/gw17GCDcQXr45xkp8E=;
	b=LD5zkDQdGr9xRjkXu4YF7l3yM6JsGlKizYL3sNHExgW1dOYvQvZbG0wZV+jEQSexITcGqA
	I7A5AvgcHy2d/dq6gCDhG1BPqCtVrLKHQ4TvHAqv3V64i8RllvhF+G9ohSnyP4kt7KPqNV
	vjPmiLKokZYqsVUc+1973dQfyqPyuxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772263592; a=rsa-sha256;
	cv=none;
	b=VzFlVSgRg1RG0viganbW+1QHuh8IgxfTPa0sOm+NVXRxVyQAb4a9H5bY0fF3J2IOpmCs28
	NJiskFTcx+WY8D0tFvtHxq+P6IvFnxk72w6CZUBOJXK99i1y4BqWoxRYtFOh5fBYjmFg8H
	Po1OF7U3Ox6HWqjxV67eomxzsIDp5dw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZ8SJzEG;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772263587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wbr7DWLMow8e+4r0j50rgMHr/gw17GCDcQXr45xkp8E=;
	b=RZ8SJzEGYxS2FiumGHkwZqAdZq8gnutI/dz856JfLjH7Ze9Epe3D6JZz65Jni8U0w6ARmh
	u5JAXW/1YkN43zumNj9aeMIMJhdaOqDSmFTl6PzUnEf2ACdmMNW1rk2S74KXu0AnU9fgjH
	Qk+aW6iuAaHxx7Oz3p8AH8yzo2Gm4i0=
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting non-hierarchical stats
Date: Sat, 28 Feb 2026 15:25:56 +0800
Message-ID: <20260228072556.31793-1-qi.zheng@linux.dev>
In-Reply-To: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A906F40004
X-Stat-Signature: 86gwbtsiiu59npu63j9pnsg86ftb4rn3
X-Rspam-User: 
X-HE-Tag: 1772263591-200196
X-HE-Meta: U2FsdGVkX19HOm6UdQztN5JdZmR6LIHlS7kaBbNPX2ipDO2nwHCwy48O0qWMF+zabSSx8tCjp1ud61F7BPYdPXJF/N5J16/auqsrXss4LkVmWVpr7JQDr4U0Ein/4fnoVLy0ONL+a78VjQfsJahOiUH7cyVAcKHj5nm23RtvwJvG5M2z8WAH9wGashVq4H0Js9Fsejdm3UPl25LZhdvZmNnFTZCsEc94iUw1ujTatZoNfk9DNs3Mn4sUmC+4MoOEUOZshNJ+UZWaDszsa2susEel7h7NNhrAPT+maYydvVo9qIzfmF1HMcKEmZP4Kew3yWUjlW/TaS8ieFkMZeHL7WvO3g3VwqZ7cO/ks1rVUtef6qiQl6lmbalclwJagUJJ4HHvwfix3KaD1wUzR4HGVb2RwD9NcXFUlSRaWLH6uU3KyQE+Vpus6M3ZIXsEo4vcAddQy+mr4Om4bsli8xHBWj7UovEr04mjdhdpMX4C+96+vCAJBiUhmwgrMP2uzIWzpcTAq/yMp/rqUMKxAj19fojyNO8SMT9YCVpTgfTa18PN9S6qLOTPwfpJ86S8bvg8CPZ6GcVw8M81s6vnsB/4URfcQlsTSP1h+t9XDcU7uL5TVgJFo4lgq/psWVtlxDRldp1X/tmc0Viq7eDw0YPDrOCotw9ADS4+o2pddK2l9ro6AnAPFi1HHJ2W98654MEmjWAjJMTxfGeQGSTUhpoV2fwIeDjU+FFlXQYpZdCvLCGP0/GOi7V4Ex0N68IRvz537dVO9OmccxLXfX596OmqIn0al7SinZ5iIRR50sJFrcekT2jNikamXpBgFWb9PAZnN47bxy+oIVZmK9Lzcwohbp6E5ZF94es9cqIfnP4RAPiBMIEXiC0a7yoeR5FSghJOsvJIJo0GQopmSM45zwfJM/Zfzk9WWEqJ9I1JD50+e3Hts6VJxIYjZ+5MByY4gn0E0oeqbLsTpiYoXXRz8ZG
 HwTOWumw
 7922z2yiG+FSmvP05MwCkwFAPXVUtfy8gbpyCefNnGknju1vRLntJCE6r/x69tfTMOZECk3vlFTbVOYZUesvLHJ/D4M1NZMUJR+RqZmckbzrbwNurN4s71z6G+o3rjY0OAsradxs3Bo1tmXaQhSvQSVtfNIITgDWqlByP3sEX7j5Yvub4IVnvdRMiF7DcCJ+2AH+grNeqSql7m/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

To resolve the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg. This could cause problems for non-hierarchical
stats.

As Yosry Ahmed pointed out:

```
In short, if memory is charged to a dying cgroup at the time of
reparenting, when the memory gets uncharged the stats updates will occur
at the parent. This will update both hierarchical and non-hierarchical
stats of the parent, which would corrupt the parent's non-hierarchical
stats (because those counters were never incremented when the memory was
charged).
```

Now we have the following two types of non-hierarchical stats, and they
are only used in CONFIG_MEMCG_V1:

a. memcg->vmstats->state_local[i]
b. pn->lruvec_stats->state_local[i]

To ensure that these non-hierarchical stats work properly, we need to
reparent these non-hierarchical stats after reparenting LRU folios. To
this end, this commit makes the following preparations:

1. implement reparent_state_local() to reparent non-hierarchical stats
2. make css_killed_work_fn() to be called in rcu work, and implement
   get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
   between mod_memcg_state()/mod_memcg_lruvec_state()
   and reparent_state_local()

Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 kernel/cgroup/cgroup.c |   8 +--
 mm/memcontrol-v1.c     |  16 +++++
 mm/memcontrol-v1.h     |   7 ++
 mm/memcontrol.c        | 146 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 173 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index be1d71dda3179..74344e3931743 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6044,8 +6044,8 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
  */
 static void css_killed_work_fn(struct work_struct *work)
 {
-	struct cgroup_subsys_state *css =
-		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup_subsys_state *css = container_of(to_rcu_work(work),
+				struct cgroup_subsys_state, destroy_rwork);
 
 	cgroup_lock();
 
@@ -6066,8 +6066,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	if (atomic_dec_and_test(&css->online_cnt)) {
-		INIT_WORK(&css->destroy_work, css_killed_work_fn);
-		queue_work(cgroup_offline_wq, &css->destroy_work);
+		INIT_RCU_WORK(&css->destroy_rwork, css_killed_work_fn);
+		queue_rcu_work(cgroup_offline_wq, &css->destroy_rwork);
 	}
 }
 
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index fe42ef664f1e1..51fb4406f45cf 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1897,6 +1897,22 @@ static const unsigned int memcg1_events[] = {
 	PGMAJFAULT,
 };
 
+void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
+		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
+}
+
+void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int i;
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, i);
+}
+
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	unsigned long memory, memsw;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 4041b5027a94b..05e6ff40f7556 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -77,6 +77,13 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
+void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
+void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
+
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx);
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5929e397c3c31..7b61bb663042b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -226,6 +226,34 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
 	return objcg;
 }
 
+#ifdef CONFIG_MEMCG_V1
+static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
+
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	/*
+	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
+	 * to read its stats accurately , and conservatively flush @parent's
+	 * stats after reparenting to avoid hiding a potentially large stat
+	 * update (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
+	 */
+	__mem_cgroup_flush_stats(memcg, true);
+
+	/* The following counts are all non-hierarchical and need to be reparented. */
+	reparent_memcg1_state_local(memcg, parent);
+	reparent_memcg1_lruvec_state_local(memcg, parent);
+
+	__mem_cgroup_flush_stats(parent, true);
+}
+#else
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+}
+#endif
+
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	spin_lock_irq(&objcg_lock);
@@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
+#ifdef CONFIG_MEMCG_V1
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx, int val);
+
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx)
+{
+	int i = memcg_stats_index(idx);
+	int nid;
+
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return;
+
+	for_each_node(nid) {
+		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
+
+		__mod_memcg_lruvec_state(child_lruvec, idx, -value);
+		__mod_memcg_lruvec_state(parent_lruvec, idx, value);
+	}
+}
+#endif
+
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
 #ifdef CONFIG_MEMCG_V1
@@ -718,6 +770,42 @@ static int memcg_state_val_in_pages(int idx, int val)
 		return max(val * unit / PAGE_SIZE, 1UL);
 }
 
+#ifdef CONFIG_MEMCG_V1
+/*
+ * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
+ * reparenting of non-hierarchical state_locals.
+ */
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return memcg;
+
+	rcu_read_lock();
+
+	while (memcg_is_dying(memcg))
+		memcg = parent_mem_cgroup(memcg);
+
+	return memcg;
+}
+
+static inline void get_non_dying_memcg_end(void)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	rcu_read_unlock();
+}
+#else
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
+{
+	return memcg;
+}
+
+static inline void get_non_dying_memcg_end(void)
+{
+}
+#endif
+
 /**
  * mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -763,6 +851,64 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 #endif
 	return x;
 }
+
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
+{
+	int i = memcg_stats_index(idx);
+	int cpu;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	cpu = get_cpu();
+
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val, cpu);
+	trace_mod_memcg_state(memcg, idx, val);
+
+	put_cpu();
+}
+
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+	struct mem_cgroup *memcg;
+	int i = memcg_stats_index(idx);
+	int cpu;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	memcg = pn->memcg;
+
+	cpu = get_cpu();
+
+	/* Update memcg */
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
+
+	/* Update lruvec */
+	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
+
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val, cpu);
+	trace_mod_memcg_lruvec_state(memcg, idx, val);
+
+	put_cpu();
+}
+
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx)
+{
+	int i = memcg_stats_index(idx);
+	unsigned long value = memcg_page_state_local(memcg, idx);
+
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return;
+
+	__mod_memcg_state(memcg, idx, -value);
+	__mod_memcg_state(parent, idx, value);
+}
 #endif
 
 static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-- 
2.20.1


