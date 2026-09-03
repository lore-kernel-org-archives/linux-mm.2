Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234D2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 21:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CD06B0088; Thu,  3 Sep 2026 17:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E046B008A; Thu,  3 Sep 2026 17:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CFB6B008C; Thu,  3 Sep 2026 17:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBAB6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:56:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E64E1A06BD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:56:35 +0000 (UTC)
X-FDA: 85173810750.22.7FA524D
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36D75C0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:56:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMVyvrTe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788472594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V6x2A4XACvWMSkpNxGFvQMuExZ9LJ7tgOiNXZV9kzeM=;
	b=kRx25am1qZHrBa4rooz25xZmulr9Egd9J+bpcVhu1NWZBtJFhQS27WZVnpSE/eIq6h/9Wk
	2oIDqJ8VYSpoA0cRqoF6BulUA+8CGkJU283erRvaELKjbApcc4RNb5/wCCAywG3lAOSBkv
	T6uY5PGXVjdGjWWP8jVa0zEuPsCUo60=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMVyvrTe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788472594;
	b=QIOYr00kt/ivXP/bGin+ggAtaOGzIiqHEa90pN+/zR4YtwXiCvhKPtMQTCvSEQvtlMGCRD
	9J8nXoOhIgJ2TLXXT9mZP/E46BDmCrG0XLWoHml2KhGNBYMMz6qBo5cTyUDo4tEkBhxWHO
	h0uEDj4kK/kwg1jwu5Yd2+6m+GcMV1I=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7f4ea388ba6so298786a34.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 14:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472593; x=1789077393; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V6x2A4XACvWMSkpNxGFvQMuExZ9LJ7tgOiNXZV9kzeM=;
        b=CMVyvrTexwqMuoghmpFBwPnTuH7/FHOC2oIdX0VeRSNuGj0tMTdd66+2pmKh4dqGiJ
         udPcpmNzU7u5+Av55zeeEIkjpGMmq8L1wIcyPf/RCwqrAsv3UbdLkaZqeVNh6FOOYClK
         oZOcjjpFXwamo3tC0VH5LNP5uXAbZayQC+IGlSN5x6j/nWF7G25XVhKvLzp+4M1CX/SG
         x/sB1MMjdkwIouGos5ypAc6KYxhPuHyenzMybQGnEODwxap1RwiaQdcr2b+RyKHy5TaT
         KJUSNGgSIUVPBvj13dXiC4fIb29x4HkfprrWQ35KmIWvO/C9dXbo0BtlMVz5+3WvH9Jh
         SERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472593; x=1789077393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V6x2A4XACvWMSkpNxGFvQMuExZ9LJ7tgOiNXZV9kzeM=;
        b=JP139ece/sWPB/R/EtrWJtmnBN91Bl/WpxDpPc19PeqTiaQ/xDv4NxeflW6zcUjzBA
         vgG1MCVX7CKouJGGaF+rU3HTuvyq+5WMnbArkhLqB4hx7ksfx0/ziLLqPQdRxN6EfMkn
         xIEngJduMiCBQhwHXA84QjB0qWyTkYK41stjcgxOorAc4nlvR+0LMBiWIhxhy4xzyGXp
         lQwKjvduR4LXcJCQfeebhWd8UTBjGyG1lNPLUEuE176zfj6UYe08UrbBeV+MB4A1wJjE
         WujHmvol6W6OYmF7XTtCXdavNHpnvflTiXwdEuIcreNdMZU53f9kH184pPhrmBM8COsL
         Unuw==
X-Forwarded-Encrypted: i=1; AKwUvByAG2ilPJqvQNhXDokYxBViiYI3SaNyRvr1xZiW2CK7ZdxJsQqqyx6015qC90GxCt73sd72Ve4bTQ==@kvack.org
X-Gm-Message-State: AFuF++kbSWJO1p2wie9ioq/B0vsoGK34cg3XnIhkqRRLC488XRIdXJ5X
	1pNsAPPE3Bc4DcVt3vU+T0pKNVG16UbI2DUXzoxHvFiXiRynpHkqG1yg
X-Gm-Gg: AYBFou1K0DjEtV/yuSO5OZcrVbb25pN8aurd2kwM/5W4LVKuXWtGSbfbK8UuW97Q6VN
	Gg7szel/80cI8rcAoSM0BgGIHIiNgAgWa64Q26FBg3qo9V4BkkyySSmok7sKlZHnIFfRZdrE4hF
	NQgN2khxlm9eC1WqvcuWyb3Xaj2PnHWe1QtVjc5XeKVopOsz2dyVOrJZN1kSahHp7n8r9mfXAv1
	CNpb3dFZ2xxCsgAQBsHxAfBDHDoHOglhZENaBYbD9EZxhQsY1SSJcGDb0H7dm//Qs+G/B0hqnSS
	yGwn/AF4jcWBwvx/M3hEypjzFSKveBRKCUkEOX8x2YXsshWzbp7O5v9o9338HhTwCHMmIh1q7zO
	RxXl0LVHIS36inm8DIzd6YuM0Zue41N5NkLabSq6G2OcVK8V9rBd4dkzepUNMEbBDQ0YnuRZ/M/
	PvNREztHLXL2CyhzYFIGjuGikdjmOVZpfAFo5ZiMo0WYG2iEYpPTU2bqUun3i20ajMc5qAWRa82
	tJUcx/zde6d62CfJRUgcaaxqTxsxzW7SD0Ajbp5
X-Received: by 2002:a05:6830:6a93:b0:7fa:5c49:5240 with SMTP id 46e09a7af769-7fa5c4954a3mr84931a34.25.1788472592944;
        Thu, 03 Sep 2026 14:56:32 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f4615a20sm1108008a34.1.2026.09.03.14.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 14:56:31 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev
Cc: yosry@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats when v1 is unavailable
Date: Thu,  3 Sep 2026 14:56:16 -0700
Message-ID: <20260903215616.1456239-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36D75C0004
X-Stat-Signature: bzc7hcoepqbbh6whm16he458hhibt4ju
X-Rspam-User: 
X-HE-Tag: 1788472594-435632
X-HE-Meta: U2FsdGVkX1/eca3uHrpGapVv6sQ7UgUsTloik6C2Zx0/SCgqQZ0yFXV0yR7D8PsBTdy/3z22N2dkMDBaqLu6J3jTIxfavcrctAh+1a8m6S91tGj51YtQwUZVsKa5Ur9YC/EyDvXcpHMwHirfojNlwclC0rDNB2nXp32UZwIhcxeyxGNDI12+bn5D8XdG03/0+AmpbgpIExG0BFoikOFJmsEPffNRMNLDNmUgBrY5sjJqIChQZ0H/T2a+3XFpJIo5mAuzgWOlUViSeSO2v8x1uxcxmHYsGYp6Zg584gzU/NwEgIYUYJqYXj7pR+JpYyc1qokUdGSCWZYVLcunAXxZ7pekF8A2V/R4PfMqv1uPr2PuJtQzPiSBy2puVQFut1u/u6jmPzyYf3CLdvZSrxJ99Sw6g3Qh1BZ86Ml4xeoFHo7hYNoQgfg0en43YN/yiwzkmvVeVesV6FXIXT9pa8Qu34gzWvMnPBV0k7ukWqxannpX6pamQWYFxNuluUJJxRleh6OjLbMogFqrzypnqCPhRUGm41e/O9DQGxLsCrMhuuBqkJFawSOUTglSNpqNiuLeQYPhtIdu8qqAf5E9J8GBjGpacoFCu1IuY1MPXQVynRWAdyIHXvvoWS7RbR1KY7Xsy4hNAJ6uavLezyV4HhWaMVkKIlkXLEWtJLBgJWc94Km1Dgv67qVR5E6lp14aAL6Bx/Q+0xMMaG8hmbn9UDhRrJc1GVU86I+P1ub8JwQJBjmO0ovJwRfGOWJW40Chi5Eyjt3KU+IkyBG60xeC0FHLMdQLAGG2gEnyIWqICvfMAdvli2rt+pZiAGpa3lfvtHo5/mvEKK1vXJ0Vn90DH8oHvfv7/rBNcC+iCGDP7EvbgUXLSIJ+8e0dBBTnunmO1SdxLW0fO0bZU+w4vXQIlysLMvZvP4F4QVHaHm3CNAvmwtmcAcdtmXfhyYFNpjffZ+BlAf3E2yQ7kGNyYTknmLM
 kFTTnuQC
 tB93TJMqODuozRQUISYMOpfTMTgZmrul7nykVuKSbwJIc80XrafEeFXHnAMJdZgIESgw+Dq5lCfBNLN0oNuFwXwPwO1+csVEwK6jysSAfZ/G24NSL2h9HCs5GDay/ATY+rGnHNAMxw62uDiOQF+sW1CQXI2105uu5PnDgElWWNnIQ3zWBuu5cXp9d9Zl2M7KGeABs4A+uQLWR12cv5NsdtjzGogHiRb9eLrd8qzPz7umsrZcsZ9l2k1tSPIyYmLHjbXH7kdZl7G0nWc4RPR0swe4A7qZ/mKOubtsSWQgZP35MVVBWq7Ov5S/cLCMG9+fIXwOi7w5Uoh0flP/qc1MjPlRpeO4w4CKYSIo3ewqYzNF6Xg/ZJqOCfna7xJif00Uq+LBGKtTbgCAXxPOQuO89UvwJH4ad+1nykN/9mhC8kKGK92R4+ckx2MdXt7RLrCLJ1jMr5a6r08gybhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
and event alongside the hierarchical one. The only readers however are
the legacy memory.stat and memory.numa_stat, and reparenting on offline.
All of them live under CONFIG_MEMCG_V1, and their accessors
(memcg_page_state_local() and memcg_events_local()) are already compiled
out with it. This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
non-hierarchical arrays are written to on every rstat flush, despite
their values never being read / accessed.

The same holds when the kernel does support v1 but the controller has
been blocked from v1 hierarchies with the boot param
cgroup_no_v1={memory,all}. A v1 mount is refused in that case, so the
legacy memory.stat can never exist and the arrays are just as unread /
unaccessed.

Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
not set. If it is set but cgroup_no_v1= has blocked the controller, skip
updates on the arrays.

This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i]. Nothing else accesses state_local or
events_local, so those cachelines were getting pulled in solely for the
writes and they are separate from the ones the loop is already walking.

On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
flush showed roughly

                         before   after    delta
memcg-wide aggregation   1231     1180     -4.1%
overall flush function   2452     2397     -2.2%

These numbers are from taking the median of 70 samples, one per 20s
window on each kernel. The 95% intervals observed on the two deltas are
[-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
timing overhead itself, so only the delta is meaningful here.

Counting the items that actually changed, a median of 1.5 of the 77
memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
each flush, which means the benchmarks above are with one or two fewer
cachelines pulled in per flush. The count is low because the benchmark
reads memory.stat in a loop to keep the flush rate up. For cases where
flushes are triggered only by the 2s periodic worker, more changes will
have accumulated between flushes, so more cachelines are skipped and the
per-flush saving should be larger.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
v2: https://lore.kernel.org/linux-mm/20260902205406.624782-1-joannelkoong@gmail.com/
Changes since v2:
  * Drop the default hierarchy gating which added extra complexity and just
    add additional gate on boot param, as recommended by Yosry

v1: https://lore.kernel.org/linux-mm/20260901232834.22221-1-joannelkoong@gmail.com/
Changes since v1:
  * Change from gating on builds w/out CONFIG_MEMCG_V1 to gating on the
    default hierarchy so CONFIG_MEMCG_V1=y kernels that do not use v1 benefit
    too (Yosry)

 include/linux/cgroup.h          |  3 +++
 kernel/cgroup/cgroup-internal.h |  1 -
 mm/memcontrol.c                 | 48 ++++++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5dfa915a630e..2afb4cb2bb4f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -154,6 +154,9 @@ struct cgroup *cgroup_get_from_path(const char *path);
 struct cgroup *cgroup_get_from_fd(int fd);
 struct cgroup *cgroup_v1v2_get_from_fd(int fd);
 
+/* Was this controller blocked from v1 hierarchies by cgroup_no_v1= ? */
+bool cgroup1_ssid_disabled(int ssid);
+
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 58797123b752..7c367c8d0cbe 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -285,7 +285,6 @@ extern struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 extern const struct fs_parameter_spec cgroup1_fs_parameters[];
 
 int proc_cgroupstats_show(struct seq_file *m, void *v);
-bool cgroup1_ssid_disabled(int ssid);
 void cgroup1_pidlist_destroy_all(struct cgroup *cgrp);
 void cgroup1_release_agent(struct work_struct *work);
 void cgroup1_check_for_release(struct cgroup *cgrp);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf126..e02f968504e1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -675,9 +675,11 @@ struct memcg_vmstats {
 	long			state[MEMCG_VMSTAT_SIZE];
 	unsigned long		events[NR_MEMCG_EVENTS];
 
+#ifdef CONFIG_MEMCG_V1
 	/* Non-hierarchical (CPU aggregated) page state & events */
 	long			state_local[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_local[NR_MEMCG_EVENTS];
+#endif
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_VMSTAT_SIZE];
@@ -687,6 +689,31 @@ struct memcg_vmstats {
 	atomic_long_t		stats_updates;
 };
 
+/*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and memory.numa_stat, and by reparenting on offline, all of which
+ * are v1-only. If the kernel is built without CONFIG_MEMCG_V1, or if the boot
+ * param cgroup_no_v1= has blocked the memory controller from v1 hierarchies,
+ * then nothing reads them and writers can skip the updates.
+ */
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup1_ssid_disabled(memory_cgrp_id))
+		return memcg->vmstats->state_local;
+#endif
+	return NULL;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup1_ssid_disabled(memory_cgrp_id))
+		return memcg->vmstats->events_local;
+#endif
+	return NULL;
+}
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -4468,7 +4495,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 struct aggregate_control {
 	/* pointer to the aggregated (CPU and subtree aggregated) counters */
 	long *aggregate;
-	/* pointer to the non-hierarchichal (CPU aggregated) counters */
+	/*
+	 * pointer to the non-hierarchical (CPU aggregated) counters or NULL to
+	 * skip updating them (see memcg_state_local_array())
+	 */
 	long *local;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
@@ -4507,7 +4537,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4521,6 +4551,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4528,7 +4559,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4550,7 +4582,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4563,7 +4596,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4588,7 +4622,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4599,7 +4633,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
-- 
2.52.0


