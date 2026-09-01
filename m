Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D7BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D686B00A2; Tue,  1 Sep 2026 19:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEA86B00A3; Tue,  1 Sep 2026 19:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6786B00A4; Tue,  1 Sep 2026 19:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 291B06B00A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:32:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAF161A056F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:32:12 +0000 (UTC)
X-FDA: 85166794104.02.267051D
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id E2C361A0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:32:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yd51OrmI;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305530;
	b=i1fQfO4RL7eJ2nG66b98LdyuCwR5ptT/gfYXq37Ky6WoeTq2QzdwwvLYg5c4Lc2oq6XRPB
	wQav61yjJhgSCpd05qQETA9pIw4CW3kKd6pMG59zXfocEKI2qk4HUXiEnSe60LEts2TN24
	uXeOrMxVByndBvJR0GiO2+FLvxoQFxc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yd51OrmI;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6FwLx62sj4L4VsnfgFBa8Hxb6mCsZ767qZJ6mrMig5c=;
	b=fi1Pg/oqYo+jN7vG4eG/kNq2RGyY6f2L9XJsW73P8CrIqEC2Z0Sx4tECZdU81JQRQkTvdb
	AhWnqYIV0vigiTf1982telgbsn2EGmSWjjTlenOdd4zFMMr/oELy2pW21GPhKm3/FCEixV
	+rqBmG4D5zYm3HugAK8FgOQt4shB60Q=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7f4f53975e6so279212a34.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 16:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788305530; x=1788910330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6FwLx62sj4L4VsnfgFBa8Hxb6mCsZ767qZJ6mrMig5c=;
        b=Yd51OrmIzAz2p/0Nqp1AcwJrnIdlgA32TvXJNg3aFtSVNE6Cnqxg5Du8/z6+Un+xlC
         1LoeutfGWPiXItj38u/vazjjpt/AyfycUo9bUTDxywPL4cQcxf4NYaWrLYU9uTpT6+Ku
         LX4cfhY7Zpk/0GqwkXrDIsQfDs+Z7uUUC3K/h6L83EyufEtlVimSO+3GOVfT1pSbmSu+
         65XqRD/fYRwQ0oiVWAenNcXxdcCZLxNszEsgWRUzyDTsgPO+weagB6cv9u3OLfnK2cPV
         mnJcAC2JISOwFY9dUoE0IGOYG57IxQx+ujZuBMOi/z+AFqtopw854tGgRJd5pEaDiHi+
         P95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788305530; x=1788910330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6FwLx62sj4L4VsnfgFBa8Hxb6mCsZ767qZJ6mrMig5c=;
        b=MHYQg/uEdNue6yxPrwHJ5PsCb3c/NdDnAUcvTE9MuGDntVetgZEfc8BapjA30rsq9x
         OJDwifNnV6qgg5hA61vAS7E7RIFXV3PWcw0Y+xenzmxX84OdZes8xcJiGd7F2X/GQRPE
         1eIjKz0qzXhujc7T6rFXu8g9Iok0rY32Hih2LFazYjBa9ST4qVnpTqFcHVS7jqUmX7GQ
         GUgbjGOe261vnz8r7Afea0hZ/u4rcEmDkbXV0q43ywRFU+8xoSVimBE8xWPCbVuDr2cx
         Xwm2zUaOXXaEo32ZHaDaFtdGzFsXyyQ1R7/UlMbN5fyjDsz1jfixeBIw+BIEEp5n5zo7
         C8Bg==
X-Forwarded-Encrypted: i=1; AHgh+RoDTG8CNkj6ZbvDuwsU4Sp413HYyNGqI0PtfVBaOgp7zFcJOSLz/5xDtaJaRGjrJsqlkzYiLwhnXw==@kvack.org
X-Gm-Message-State: AFuF++lg2wkG6Gf6ZuiHzZFF1r/I1/n385IU3IM+DhwVnb1qqUA94NDh
	vVTnETy5FFpXYPScSULNx6pALbU7kerOcYezjS6VZ45oFgDrQ+1N5jET
X-Gm-Gg: AR+sD12rQKu247m2xwARkjbwAiW4FG8QC4c976VOhMizROhhdN1qxIULsaeD0PDi5rm
	k8mFU05STEYQYbFCB7eJYQOHII5rXs4u++kt8EJ0ndl9WNDNb5WqvBw9HIprgIi/1sVS8tQPf+a
	DtRJWnBshoIRW6p4GQSFWAS1H//0vj0w6Y1mL2nZuZzGT4bXbhDVNKIHNLQyF/NZrtGVNWcbAsD
	baDu87mKbjm27MlCdvHI9h32JVACgOpjCLuxG+lpTBK5w0ULBKl0TOjapwwo5xgwAaS+24+gO89
	3cOUTlp//KSulFQDrJe9MQqJ9YH3iV5XXgk0YJUxQZ2YIHDe/TQxRnZJ8NrUk4Y7TwXmcfr8l8c
	1oIhSSnyxv0Xh+7bq69eQfNIkNdQa/JCrNkKXxj2uOuyjmXXMgJONfP5y7rIhQ9TZzcgHbHSG+i
	Lc0IEN9sdkPrfVomfwiVp0YKqwSac10r9NwCWC5ME3jZ6ZYN38txjGuITk9oHOwPfij8IxTh06p
	RLuANlB4XeqZqegqa2CY6QRS7JoF9qDRCYph5g=
X-Received: by 2002:a05:6830:67d2:b0:7e6:f2ef:e231 with SMTP id 46e09a7af769-7f77f3d22d3mr1244281a34.2.1788305529607;
        Tue, 01 Sep 2026 16:32:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f74d0b9f77sm880492a34.9.2026.09.01.16.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 16:32:09 -0700 (PDT)
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
Subject: [PATCH v1] mm/memcontrol: drop non-hierarchical memcg-wide stats in non-v1 kernels
Date: Tue,  1 Sep 2026 16:28:34 -0700
Message-ID: <20260901232834.22221-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2C361A0007
X-Stat-Signature: z86nqtogbxc1djqx344ffy8gfp5brhb3
X-Rspam-User: 
X-HE-Tag: 1788305530-118721
X-HE-Meta: U2FsdGVkX19ZUwnI44EC7Tn+3gbHvPGcPlR2fm5edsIew2K4qcZPdan56B+UUWpUXu7drJFR5TRcCT2QZ07rnqjAYclCHhALhS2oUVO8HP9oEIEGwSjZImywdqHYx0fHdiBu9QWQyYseInaTWQPCZseqcHeA7vMukOT2AG3O94B3JRsB44/dHtCvKGyqcCLDmlC6ilzmU3wkU6V4eVHuthq17A1EWUcDG2tCMdcyIa/tvNG2PZVWORyrbDQsaiHkmaXRf9WPvXsoBNFmaiAYke99j0NnPAaO1P8qMHeALomM4WuL2peFDnjeNpu+gXxgbR0aPwTGczvMjw4DAXKtAdxFdi6T9kF2Dx5+U9vRNwJe8LCsq7wLjI+zDAai46sbN93/zuIWpA4J3IoZPy0OHjYR2XW1tpUVRuuoDqwXZttrG7gCRKhfjjH8MwdIjv/NcATFnRZXe3pv0Sj0nIwnNrK46VaIposqqxn49EZ3gJnKlTOXxaaUk1URIprwNv1aLirrX9kOqOE1x+Eo8Nh8KsqCp0hXQ4s56K/i5Vof1j5xOfcSCMTaQrv49vomy5lQQqOcY/XB3EKodH6LybRrm97ylj1DFmbQQ1kNdubobIhDkaO2w2s/2c6dvMDpCwu+EC4ZvQ2TYueWLfCSCOgU6mmmuM6u+WPKWOFjYM6g/f2I4mfRjE9I2B89xOFYxz55QPgGM7H8r1qko7evMN6+cOx22Hov7F3BzheEleyBgguuHTy8X9BsiZfJD4hh9gZTL+RGpmpTbn5qbmzOTGd8nMmkMXYGnRpgM+Y0dg4LxjsEVdYKgY2NNGn9WLIPbw2rfP3jjufW+5jRORJ2bNWXBsp/OcntQ6Hq5NSsVOvZbIgS+sGxfOdE9KdnGbyFJz8mzVpflqv/fmis7xftzUCz6AYS1f9CMzisVNFxod1KBuNXK2HSG/DPxTKtTLOFLmdd21AIO5ARXlaeVwA4zB7
 b2ovmHso
 dimhkP0/9KBEydcBl+zpJxKxZej+B92T9hPsMxN+A4mBFBUiZDnALAqjV0JqytfUoNHPIOx8FFJk9RmX58wazjqd0RHOd8UleR2icACFJZzrORNMCwQLNLqc3aLEbvTM3m+eV5vHFpUg+EkzV9WcQlr5KoNbT0Tg30VwXWPkOUaG4KgxRqWAmg8g74ScIwCEZ7x3yiaJ7OJ7q4/E5C4bP1Yq4riafExvHLROD0ncS8t93pvcKojIBc6PODDFcVx1iXYXbY2zMh+Ze3X2AOFKvlzn7AP8oqhEyJOS/78H3m+e7ItoLihHIqqSe64/l88u2j8GpSg+ffCA7x1gykQ98ClqFvbYQMPgpau4lsLOVxM6d9iRYnOH9fOhB/j95/vMOO97bfsUsoMfupVjzU8k1Eqm3JDmWt6FFFBID6N90I+A9UkuayVTClrJ+zhaaV9yI5UKVFV0AX0ytK/isEi1WuyiBdw==
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
non-hierarchial arrays are written to on every rstat flush, despite
their values never being read / accessed.

Compile this out and only carry the non-hierarchical memcg-wide stat
arrays if the kernel actually supports v1.

This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i]. Nothing else on a kernel with
CONFIG_MEMCG_V1=n accesses state_local or events_local, so those
cachelines get pulled in solely for the writes, and they are separate
from the ones the loop is already walking / accessing.

On a 80-cpu x86_64 machine with 500 cgroups each running a workload that
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

Please note that the per-node lruvec array is left unchanged, as that is
not v1-only (count_shadow_nodes() needs to read
lruvec_page_state_local() under CONFIG_MEMCG rather than
CONFIG_MEMCG_V1).

This adds no functional changes to kernel builds with CONFIG_MEMCG_V1=y.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf126..b98b2d68c62b 100644
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
@@ -687,6 +689,32 @@ struct memcg_vmstats {
 	atomic_long_t		stats_updates;
 };
 
+/*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and by reparenting on offline, both of which are v1-only.
+ */
+#ifdef CONFIG_MEMCG_V1
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+	return memcg->vmstats->state_local;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+	return memcg->vmstats->events_local;
+}
+#else
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+	return NULL;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+	return NULL;
+}
+#endif
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -4468,7 +4496,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
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
@@ -4507,7 +4538,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4521,6 +4552,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4528,7 +4560,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4550,7 +4583,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4563,7 +4597,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4588,7 +4623,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4599,7 +4634,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
-- 
2.52.0


