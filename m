Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE7FBC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 20:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8AAD6B008C; Wed,  2 Sep 2026 16:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3BB36B00B6; Wed,  2 Sep 2026 16:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CB16B00B7; Wed,  2 Sep 2026 16:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD2A6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:56:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1566980349
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:56:33 +0000 (UTC)
X-FDA: 85170030666.22.BE758DE
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F4D240004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:56:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eILaJgRN;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788382591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L0HzSKuqv/KV9cbmP7FkA9jDEFtUZ8WtgRJiztbD2Xk=;
	b=2NI7DhWJ0Z9Yqre/u2zBVd1ynW6qT+d76kcIpQWULWnledp+dPacuSZI+v/pxSoeb8bLZF
	pfjHaENLJ3XSFT+9hq0UQ4ogHBL9Owqb4sVddWPyEFYKsv99Z+YnVCPNEo4SfOSbom4l+/
	+ri2u7G5oeiix80Ntjzc2H74COLt3rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788382591;
	b=kWPUlCTCAx+A4TQ4lCAiXoKdgYBzPvDa+1GqClF57zvdtmba3Vey0odO4GqcwOKAVm4gn8
	R3SFtpB7/O00vo3ak6z7RcjROW4wOrDmOBqLq/AVlwqM/vwyVJIyerWeJhVh7Bt86Pwjx1
	s/htZq32kk/dLBMEosY8ii9Dzp9ia2M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eILaJgRN;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6b1b9c3af5cso1135255eaf.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788382590; x=1788987390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L0HzSKuqv/KV9cbmP7FkA9jDEFtUZ8WtgRJiztbD2Xk=;
        b=eILaJgRNZj0edpHlO40ceoRTKAXLEKfsEk9xLd9AuDXokn2cts+8dPHZgHtULYLVsz
         hh1agOQ+KHThCB/XUfCucvY7BMUMVy2qnpywflpXQ3sVZh+Wa6y781ytdVeeVBa6A8lO
         zDqVCulmGN5Sg0xRvX27n5JOuXJe/4JsO7lUsmDA7a5y3nIuPaYEKD3Hth/dSKUvwEj+
         H4r2tbFkHcl2s1cD10GtwRiRip3QJAYhg/KCsZv1TBTTqkx5Zd5yxlwh1kBl5a+5TCG8
         DN3gQteU2YE5lOhYeTLVd+m66VN0IuyRC3r0yStwaDSq39IPft+NkwrbGvh4i/+6e8+l
         w0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788382590; x=1788987390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L0HzSKuqv/KV9cbmP7FkA9jDEFtUZ8WtgRJiztbD2Xk=;
        b=ZMfiOXip12JVXsaTnn3VINKMcbPRucJSZWjtriw36KetQst9erbiz43yCwx6cmp8wg
         54xobROiyfLIU3qLHUkVwy5LZYF12KuJoVW9dkQu2pJG7A30hd43t5hliaV6TXXs7T5n
         EFIFdPnIu6uizSGCTrMAVkDQNVMHiNi8ZBXFjyXvu2kHF8gIG8YW1LanjvBZI3X8dqwB
         OWYVvH+i6kafF9V2CxADHKotiJPNa8HMe9x1H2p04OuTYRi87dpdGzoAikAHGEnFIwsw
         FMZB83jtvfIgSc9PlWz0y2WBrU4Fx9sP5LX0ejBnzEo4O59FTycgY/497jezpmdbX1JJ
         AFJw==
X-Forwarded-Encrypted: i=1; AHgh+RqWLbC/Bquh5X02yhzkSy+dZpQl3uGi04AueQ6tkfrhlTkLCkbUaV60AfZhYcJceQancpB8bVD5NQ==@kvack.org
X-Gm-Message-State: AFuF++lTYxI/1mosKnYw2Bxg2Qof1XjIu6tRlbBEj8ceH8v0JRzaH2+G
	Qj2IBMX4ImyWq70CjEtjNWjplGowX35WU2VV8OT0cjzcIoPb17+gaK9v
X-Gm-Gg: AR+sD12SY1nHL7zb1ygERkCsOdaPv6KPNrSZC3wSxSmkyor3sSIakfC7+9mDEmqG6L7
	jgWBM9iWQaeebXgRNrwP7rRjZvpJlXYXs8m0lCnPaAWmFDC02kVdMfC2CYojA9ny6ZVu73O9bwc
	Ml9Fnk4MuCe8qflXKb3X+O6VWaUwIitcvmzG7ctxfb+79wKk7Rn3NtNWOa2h+l2dQs8FpIeSARN
	Rs1IlnpgAXcI6btwlTV1iIwGLCcI2zZqNnjESo3jQWBunuPTXvlOmBr/rFSRLUmrm4A1VSN/amL
	Swfr1va4VHqHiMSu8ZVJGowSHcTwx+KVmA9WvN+ZA/p1Tkd/m7Bi5N+aBAdZB63xTZ39IKGUonS
	6SQaRxg/ckhg5bpC9Yb9FwP7mQllYuL9hQWPsPNa4UdB2Z2KwFeeXlx7XoIPmLucWJw8DxsOMBz
	vxAh/R2w3NWkngpdwzjzFJbj5CekRqR/Tm2aK3zHsDa2S3r9/J8zjlpV4BHJYhiLobRUYY32PZH
	vqZ2rE98p31Nv+R70sjawzSfXspeR3L4YVfS2T9
X-Received: by 2002:a05:6820:4dfb:b0:6b1:b639:12f2 with SMTP id 006d021491bc7-6b480a4894emr6073552eaf.17.1788382589237;
        Wed, 02 Sep 2026 13:56:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b40c8381b7sm3877884eaf.8.2026.09.02.13.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 13:56:27 -0700 (PDT)
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
Subject: [PATCH v2] mm/memcontrol: skip non-hierarchical memcg-wide stats on the default hierarchy
Date: Wed,  2 Sep 2026 13:54:06 -0700
Message-ID: <20260902205406.624782-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7a7k6zgjy5u6qicn7ipdnhm67ubm4zcb
X-Rspamd-Queue-Id: 5F4D240004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788382591-802627
X-HE-Meta: U2FsdGVkX19Gizui9I/5hXJptjs7G1UxUTdecnuw5xV3yxEGVgkW2QnhqKFY2I3Yg64Bub9vTtWNqjBZTF3uOtrkfkO2sEA8mWJyWZdTst9GgXS7Bwu1PR8e6RC/4Ta60ImMRbtY3a7+MJY6ihWOtVSV8hoxiC2bP8DJDh1A8hARPtVlcFVHPhnTlUNCgfLxg3apS0Bn0Xf/1B3qEoLLUwAp1L01fJHbTy98GIS+duiNFa/goeAiOWPjLOTLmjLapekeAUcQjpZstBfFdEpndPS26fSEHlA9br7AGvOfRGLGJLXIwV14Tazy1896xClDxmbPtx5GamosvV3w/QotvHzCFnetQ3mf5DXqShLxqmLIviY0IQcn3Ow5DyEOO8K56MWwJgfSsnJZie3maDP7Pahc5kz25au/dygMEE7MtmzFwjM5jDGwSDhz+UASNCYgks+okElIv11mW5tWSFPdwYuMdA3vE88vIAQMitDoeCSX3cPJ8xlAF/6mNO2a5xMjeylUAEJiI60iFzZDzt1Vay/1VvsTA09uQ1KsZp3BskBCS3D1gaB/KxtK6pHBet+MYfWNDpSUFKBnDwidnVPx7bdjPPecNnnCbhQ9rMsUj/iWYUG/kNEkb/E5VxwnJuE9Ng5OjGVKFozvK0p+PMb5CWGpsvj6gGSs45lCYbZxE3I+rHynI/e6iByVATzhgwZuigikz5oP4ligcDJDTJ4f4+x62dHJDA8177HxsvV6Vfc0CuDW1Azv3Pt/aBoGuOVYTRm1kcYxX7e69pj+rM47dGRta/3nfaFkcj/SBIgaxvkcManw1a8sLW58/HRDzPPa4+AXFHBw7lvBnwEw2eS/g+7mRfSessdRDQNCFzmQdvo2xWVu3fC2pkOd0gdpzjjm8erQxTeKBV7weAUQf8Y6dLtofXyx+PHUd5gyAA1R3H8KZLVW0n8Kr9YFyg03nJ0HK1Chu0j0O74FYH9oLjB
 u77BV4nO
 2J6BHOCzBQNxxr9ghQed5sfseIuY0Hm0DZWtDKFVbtOqhFYzxfdS0u7e/XqySMbEZt+vLSr9VVOOE0RCRUdG9p4d4O8Xq2PgTnJTXLJy3mEk7vN7NvJ69Tp2nxZ66TKrd/2QOGeuCRgMtNM4DPtvcpy7dU9rLEgTF4lf4iVVdK/kgVr1ZSD40/yrALckPkqNpU/09f+gF0GDOFWdVRDbnxyUJDmTWLgzipz7Rk6lMHMqpbYZUR4z0XE5lLF9CRR6R//jZzmJQamGpaLis5qChzs+38XJkiwY6Jg7zNb7WjqqpQgZSkpx8nEB9rNIGB8MwGwa4LcVxEFlFOzy18K/yFldjzWfGtRHW02dk86nw/bcP7EpSgC6PkZgIpsw678wbwRzRxI0yXn4iQewwCzHXDTj4N0WXl16qK/8YCLB6uA/oF1s+zrvvhCpYBo8w4ByOeeXnXrYNvqZiz6naiT4m5cifctNn8VHTsNlHe6gD7FWiuIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
and event alongside the hierarchical one. The only readers however are
the legacy memory.stat and memory.numa_stat, and reparenting on offline,
which are only used when on the legacy v1 hierarchy.

On the default hierarchy, memcg_vmstats's non-hierarchical arrays are
written to on every rstat flush, despite their values never being read /
accessed.

Instead, skip non-hierarchical memcg-wide stats on the default hierarchy.
This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i]. When on the default hierarchy,
nothing else accesses state_local or events_local, so those cachelines
were getting pulled in solely for the writes, and they are separate from
the ones the loop is already walking / accessing.

There is the unlikely case where a controller can be moved from the
default hierarchy to the legacy v1 hierarchy at runtime, which means the
non-hierarchical memcg-wide arrays will need to be populated with the
correct values. This can be handled through the bind callback, which
gets called by rebind_subsystems(). We can copy over the counters from
the hierarchical arrays since rebinding is only allowed when the root is
the only memcg, so the hierarchical arrays and the non-hierarchical
arrays values should be the same.

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
v1: https://lore.kernel.org/linux-mm/20260901232834.22221-1-joannelkoong@gmail.com/
Changes since v1:
  * Change from gating on builds w/out CONFIG_MEMCG_V1 to gating on the
    default hierarchy so CONFIG_MEMCG_V1=y kernels that do not use v1 benefit
    too (Yosry)

 mm/memcontrol.c | 89 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf126..196e1791c10d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -687,6 +687,29 @@ struct memcg_vmstats {
 	atomic_long_t		stats_updates;
 };
 
+/*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and by reparenting on offline, both of which are v1-only.
+ * They are skipped if the controller sits on the default hierarchy
+ * (mem_cgroup_bind() populates them if it is later moved onto the legacy
+ * hierarchy).
+ */
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return NULL;
+
+	return memcg->vmstats->state_local;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return NULL;
+
+	return memcg->vmstats->events_local;
+}
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -4468,7 +4491,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
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
@@ -4507,7 +4533,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4521,6 +4547,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4528,7 +4555,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4550,7 +4578,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4563,7 +4592,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4588,7 +4618,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4599,7 +4629,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
@@ -5183,6 +5213,50 @@ static struct cftype memory_files[] = {
 	{ }	/* terminate */
 };
 
+#ifdef CONFIG_MEMCG_V1
+/*
+ * Called after the controller has moved between hierarchies, with the on_dfl
+ * key already in its new state.
+ *
+ * If the controller is moving from the default hierarchy to the legacy
+ * hierarchy, vmstats's state_local and events_local arrays need to be populated
+ * since they get read by the legacy hierarchy. Those values can just be taken
+ * from the vmstats's state and events arrays since rebind_subsystems() only
+ * allows the move when the root is the only memcg.
+ */
+static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(root_css);
+	int i;
+
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	/*
+	 * The flush is necessary because there might be descendants that got
+	 * destroyed right before the rebind that may have left counts in the
+	 * pending arrays that haven't yet been folded into the state and events
+	 * arrays
+	 */
+	__mem_cgroup_flush_stats(memcg, true);
+
+	/*
+	 * Not serialized against a concurrent flush. The periodic flusher runs
+	 * on root_mem_cgroup without cgroup_mutex and a flush increments state
+	 * and state_local together. If the flush happens in between when we
+	 * read state and write to state_local, its state_local increment is
+	 * overwritten and the counter stays short, but the difference would be
+	 * a single CPU's accumulated charges since the last flush and the
+	 * counters are approximate values.
+	 */
+	for (i = 0; i < MEMCG_VMSTAT_SIZE; i++)
+		memcg->vmstats->state_local[i] = memcg->vmstats->state[i];
+
+	for (i = 0; i < NR_MEMCG_EVENTS; i++)
+		memcg->vmstats->events_local[i] = memcg->vmstats->events[i];
+}
+#endif /* CONFIG_MEMCG_V1 */
+
 struct cgroup_subsys memory_cgrp_subsys = {
 	.css_alloc = mem_cgroup_css_alloc,
 	.css_online = mem_cgroup_css_online,
@@ -5196,6 +5270,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
 	.exit = mem_cgroup_exit,
 	.dfl_cftypes = memory_files,
 #ifdef CONFIG_MEMCG_V1
+	.bind = mem_cgroup_bind,
 	.legacy_cftypes = mem_cgroup_legacy_files,
 #endif
 	.early_init = 0,
-- 
2.52.0


