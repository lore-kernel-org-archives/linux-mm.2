Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451EB606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=mP0ywnjY
Received: by kanga.kvack.org (Postfix)
	id 4198D6B097F; Wed, 28 Oct 2026 00:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9F76B0981; Wed, 28 Oct 2026 00:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFCF6B0982; Wed, 28 Oct 2026 00:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3126B097F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:15:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F367240A59
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:15:30 +0000 (UTC)
X-FDA: 85370720820.02.F8745DC
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id C179320008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:15:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mP0ywnjY;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160929;
	b=MOFv4OxocgqDSb+UkXLH4odsyL0zY5/rC5K9lJZdclxiJXJZkXcpFkM9JUhvFkutTRTqpw
	8VSWAV0oMjs+vR3QyVIyGCK5RApELnpnCbe/ROlMeP+ZaEC26oy8jLIowaNB4gaeJQa3fo
	eo7U4+nf8vVDtj9d9AqFpt9l9vchEaQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mP0ywnjY;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfDs06NpzHyL1TD0z072gNMA7YWDkCnN/RbTxmf/C60=;
	b=Mck83N/qhkaI8IXrUlPOKXQSpun2ZOAitlFQR5hxqg9+DpygeDXUwI2RO7fw63Yxx/U6Cb
	mCVwor+wF7ri1uqF3ASuDTN0fs3DRghaLKJ//fTUS7l59wnpz2l7oM7KLgvsoXnysRG4HH
	LrC/tUv/C2foakP9RPsu0UXOXbhhO3M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793160919; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EfDs06NpzHyL1TD0z072gNMA7YWDkCnN/RbTxmf/C60=;
 b=mP0ywnjY0MiBeKD+TLL/PcteYTbXxRJD97x5jkUgYiS7WyPZdzeL+zXUDCW3mkNUBE2COq
 CbbtT0Nd24bmvvYYepNaRU6venqLfBQRsSUnt/6czk3jR9TKQF1Gb0epEhi6Fea/+CT/QZ
 qXui/qTNMNCB62rIGalLEjXSB2vraaBgDPnw2O5GcvyFyGkqpPBgSuAkhZoSneuQV989wA
 GZC7vvEOGN21NbgsD7H5cZYq3nAOqJE+4J64BgRuVr0Ec0GVZ+thjxsFLK4jtLMZQbBWbS
 TXrlBtdByJYN4z5O99qkJjr/cv/KTcnXm3F2FScaceZXtHqmx7SR7ydSpzIUeA==
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ae176d5+9695b8+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20261028041253.74839-1-lizhe.67@bytedance.com>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Message-Id: <20261028041253.74839-4-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH v2 3/3] sched/numa: fix scan-period adjustment for tiering-only mode
Date: Wed, 28 Oct 2026 12:12:53 +0800
X-Stat-Signature: q4eb1wua9x88ut8r5qbfydmhwaanyn3f
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C179320008
X-Rspam-User: 
X-HE-Tag: 1793160928-732426
X-HE-Meta: U2FsdGVkX1+GeXdL18H3RHnZXDGM+qokDUuSd1vrFMw/GWhlJMiMqL3VYP1pWHUcvc0r41bjerC0c2PwcJ7gjjAQVCcUxPeo4Nfj04YaU0Xg+3uOBef7/rJ0Hkg8VlrAWo90uQu5fxHVaMP7FRV9aEAv74U1vb+7IBp/WreIn6djHfhlDS6J6OYoR50bo9oTP9TNo9uBks8mOvkA26TyZEo65qRgd8CIsBZ7uSguTVC78dTM7DUIxNqsxgpakclz5X/Jv/EtJev2QnH32X21HwmUZkNphS5We3rpgR54AFTxbbQMs9upD7SyHlMaj767wEJIVVrJU/XFxj7i69Rmah4pY2yFgUiL3CHzjE4Lu4tXTP5RQZrppQ8s6CQhqey7bXuX4wYehzetX7p+Ahv2OZ8n5hj7K7qi6mdUkb0SvpR/uwLkNi4Nk0BlCyFK05AggVcZy5RV3iAeG0G5zSh+dFnb01RXGBEWgb5+QVN1gmbNfa/o6naGgkUQpvBZ+5u9ORGIjh3KrRI/GElEYEJCWWYV0++7DjQXqstUjXY2EXIfYEn4CR8oMSveGpeLE278V3G1iuKeAmo8i3T24zvVGGMWJmv4PuMgCuRvZ3McjQDaE2x6x/sWKHxuvGk789ab9f9iKST30FbIqYjSCpsHdpWe4QZFZyJ7+soNWu/8I2KOVk+2SRGI/yioEQsg0CFn0Q1RDaVttpObTU9ZBBQSVHaEtP1Y5Durev1UNBf5d1qfBvkJQQ5s/mGGRC4kso3BgcHceTDGPv+Md6Ryzjao+GWJ3zY0mCZYkJ3Buzuty/GQVnt96Ftrc11d1/FKg3eJfCT38T3m344ZYt7n/vgiyyAON+dptHvDD+MpAMUUU2Z5S0hiOD+/z/AUtDQWTSg7fR1uAfa4uziAK/KjMbzdlrU2rWxQ6WEzEjlAC6vJ5AqmxSwXShJwyKcJuFej3u2AI3/TEpJdxiI5UCW1mwu
 YvgAfQDO
 riazuVetp/1euQWQMnUG8zzN/IBK+snlbsb+8yggq0RbbanjbZyu0ZTXgGI7YygSoxip6YgCjvA8ixTMV7b7p+iDbMXSvBQ/wBYB3endJgZWuZKsXURy5ags8pMDp0nqZ8tEV3OHNapF5xmB1bGXzh6LxmhLueWbWINpDoIfWnzkCFM4Gu57KTf22EfvtTHwC6F5jFcCnVFD/2AmUKpaQHiejzB46xnUdu2fHK2k+IYeM3OaQrD0vHEevTWBUSeyFxZ7Kv7n+jPuSUsAI4tsHJkB3eG6Oc0aCYQJlw2fKN4euZO2HF0ZMT80Lnx1jUczq3+hpaKAcQwkItkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When automatic NUMA balancing runs in memory-tiering-only mode, NUMA hint
faults identify slow-memory pages that are worth promoting. They are not
normal task-placement feedback.

Without separate tiering feedback, successful tiering promotions are fed
to update_task_scan_period() as private remote faults. That leaves
local == 0 and shared == 0, so the function hits its early slow-down path
and doubles p->numa_scan_period. Repeated promotion feedback can therefore
drive the scan period towards the maximum.

Track memory-tiering feedback separately from normal task-placement stats.
Successful free-space bypass promotions are not counted as tiering scan
feedback because they did not pass the hotness and rate-limit checks. Cold,
hot, and throttled feedback is generated only by the hotness/rate-limit
path, while migration failures slow scanning like the normal placement
heuristic does.

Use the same 70% threshold style as the normal scan-period heuristic. A
hot-dominated window speeds scanning up, a cold-dominated window slows it
down, and a throttled ratio of at least 30% also slows it down. If a
window has no tiering feedback, for example because promotions used the
free-space bypass, double the scan period, following the same
no-useful-signal slow-down direction as normal scan-period adjustment.

Evaluate the tiering window when a scan sequence completes as well as when
tiering faults are reported. This lets an empty window back off the scan
period after qualifying tiering feedback stops.

On a CXL system with node0 as DRAM and node3 as slow-tier memory, a
STREAM Triad-derived OpenMP workload was used to model a
bandwidth-sensitive working-set shift. It first accessed one 100G range,
then switched to another 100G range. The workload was first-touch placed
on node3 and then run from node0 with memory-tiering-only mode enabled.

With the free-space bypass disabled, so that promotions have to pass the
hotness and rate-limit checks, a kernel with only the bypass control was
used as the no-feedback baseline. Tiering scan-period feedback improved
the transition window after the active range switch:

                              no feedback       tiering feedback
  first 80s after switch       122.4 GB/s             129.3 GB/s  (+5.7%)
  200-240s after switch        139.9 GB/s             140.6 GB/s  (+0.5%)

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/sched.h                |  17 ++++
 include/linux/sched/numa_balancing.h |   9 +++
 kernel/sched/fair.c                  | 113 ++++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e..c4959747374b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -833,6 +833,16 @@ struct task_ipi_mask {
 struct task_ipi_mask { };
 #endif
 
+#ifdef CONFIG_NUMA_BALANCING
+enum numa_tiering_fault_stats {
+	NUMA_TIERING_FAULT_COLD,
+	NUMA_TIERING_FAULT_HOT,
+	NUMA_TIERING_FAULT_THROTTLED,
+	NUMA_TIERING_FAULT_MIGRATE_FAIL,
+	NR_NUMA_TIERING_FAULT_STATS
+};
+#endif
+
 struct task_struct {
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	/*
@@ -1433,6 +1443,13 @@ struct task_struct {
 	 */
 	unsigned long			numa_faults_locality[3];
 
+	/*
+	 * Memory tiering faults are tracked separately from normal NUMA
+	 * placement statistics. In tiering-only mode, slow-memory hint faults
+	 * are used to decide promotion, not task placement.
+	 */
+	unsigned long			numa_tiering_faults[NR_NUMA_TIERING_FAULT_STATS];
+
 	unsigned long			numa_pages_migrated;
 #endif /* CONFIG_NUMA_BALANCING */
 
diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 200f50075d5c..12f31ed56d66 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 
 #define TNF_MIGRATED	0x01
 #define TNF_NO_GROUP	0x02
@@ -16,6 +17,14 @@
 #define TNF_MIGRATE_FAIL 0x10
 #define TNF_ACCESS_TIME	0x20
 
+static inline bool numa_balancing_tiering_only(void)
+{
+	int mode = sysctl_numa_balancing_mode;
+
+	return (mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	       !(mode & NUMA_BALANCING_NORMAL);
+}
+
 enum numa_vmaskip_reason {
 	NUMAB_SKIP_UNSUITABLE,
 	NUMAB_SKIP_SHARED_RO,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 136207b62d87..1d9efc2b7427 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2760,6 +2760,32 @@ static inline bool cpupid_valid(int cpupid)
 	return cpupid_to_cpu(cpupid) < nr_cpu_ids;
 }
 
+static void task_numa_tiering_placement(struct task_struct *p);
+
+static bool task_numa_tiering_update(struct task_struct *p)
+{
+	if (!numa_balancing_tiering_only() || !p->mm)
+		return false;
+
+	task_numa_tiering_placement(p);
+	return true;
+}
+
+static void task_numa_tiering_no_feedback(struct task_struct *p)
+{
+	task_numa_tiering_update(p);
+}
+
+static void task_numa_tiering_fault(struct task_struct *p,
+				    enum numa_tiering_fault_stats stat,
+				    unsigned long pages)
+{
+	if (!task_numa_tiering_update(p))
+		return;
+
+	p->numa_tiering_faults[stat] += pages;
+}
+
 /*
  * For memory tiering mode, if the target fast memory node has enough free
  * pages, recently accessed slow memory pages can bypass the normal hotness
@@ -2887,6 +2913,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		pgdat = NODE_DATA(dst_nid);
 		if (numa_balancing_promote_free_space_bypass &&
 		    pgdat_free_space_enough(pgdat)) {
+			task_numa_tiering_no_feedback(p);
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
 			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
@@ -2899,10 +2926,18 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 		th = pgdat->nbp_threshold ? : def_th;
 		latency = numa_hint_fault_latency(folio);
-		if (latency >= th)
+		if (latency >= th) {
+			task_numa_tiering_fault(p, NUMA_TIERING_FAULT_COLD, nr);
+			return false;
+		}
+
+		if (numa_promotion_rate_limit(pgdat, rate_limit, nr)) {
+			task_numa_tiering_fault(p, NUMA_TIERING_FAULT_THROTTLED, nr);
 			return false;
+		}
 
-		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
+		task_numa_tiering_fault(p, NUMA_TIERING_FAULT_HOT, nr);
+		return true;
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
@@ -3708,6 +3743,48 @@ static void update_task_scan_period(struct task_struct *p,
 	       sizeof(p->numa_faults_locality));
 }
 
+/*
+ * Memory tiering uses NUMA hint faults to identify recently accessed slow
+ * memory that should be promoted. In tiering-only mode, those faults are not
+ * normal task-placement feedback, so use tiering-specific outcomes to adjust
+ * the scan period.
+ */
+static void update_task_tiering_scan_period(struct task_struct *p)
+{
+	unsigned long cold, hot, throttled, failed;
+	unsigned long total;
+	s64 period, period_slot;
+	s64 diff = 0;
+
+	cold = p->numa_tiering_faults[NUMA_TIERING_FAULT_COLD];
+	hot = p->numa_tiering_faults[NUMA_TIERING_FAULT_HOT];
+	throttled = p->numa_tiering_faults[NUMA_TIERING_FAULT_THROTTLED];
+	failed = p->numa_tiering_faults[NUMA_TIERING_FAULT_MIGRATE_FAIL];
+	total = cold + hot + throttled + failed;
+
+	period = p->numa_scan_period;
+	period_slot = DIV_ROUND_UP_ULL(period, NUMA_PERIOD_SLOTS);
+
+	if (!total) {
+		diff = period;
+	} else if (failed) {
+		diff = period_slot;
+	} else if (throttled * NUMA_PERIOD_SLOTS >=
+		   total * (NUMA_PERIOD_SLOTS - NUMA_PERIOD_THRESHOLD)) {
+		diff = period_slot;
+	} else if (cold * NUMA_PERIOD_SLOTS >=
+		   total * NUMA_PERIOD_THRESHOLD) {
+		diff = period_slot;
+	} else if (hot * NUMA_PERIOD_SLOTS >=
+		   total * NUMA_PERIOD_THRESHOLD) {
+		diff = -period_slot;
+	}
+
+	p->numa_scan_period = clamp_t(s64, period + diff,
+				      task_scan_min(p), task_scan_max(p));
+	memset(p->numa_tiering_faults, 0, sizeof(p->numa_tiering_faults));
+}
+
 /*
  * Get the fraction of time the task has been running since the last
  * NUMA placement cycle. The scheduler keeps similar statistics, but
@@ -3974,6 +4051,22 @@ static void task_numa_placement(struct task_struct *p)
 	update_task_scan_period(p, fault_types[0], fault_types[1]);
 }
 
+static void task_numa_tiering_placement(struct task_struct *p)
+{
+	int seq;
+
+	if (!p->mm)
+		return;
+
+	seq = READ_ONCE(p->mm->numa_scan_seq);
+	if (p->numa_scan_seq == seq)
+		return;
+	p->numa_scan_seq = seq;
+	p->numa_scan_period_max = task_scan_max(p);
+
+	update_task_tiering_scan_period(p);
+}
+
 static inline int get_numa_group(struct numa_group *grp)
 {
 	return refcount_inc_not_zero(&grp->refcount);
@@ -4105,6 +4198,8 @@ void task_numa_free(struct task_struct *p, bool final)
 	unsigned long flags;
 	int i;
 
+	memset(p->numa_tiering_faults, 0, sizeof(p->numa_tiering_faults));
+
 	if (!numa_faults)
 		return;
 
@@ -4158,6 +4253,11 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)) {
 			if (migrated)
 				p->numa_pages_migrated += pages;
+			if (numa_balancing_tiering_only() &&
+			    (flags & TNF_MIGRATE_FAIL))
+				task_numa_tiering_fault(p,
+						NUMA_TIERING_FAULT_MIGRATE_FAIL,
+						pages);
 			return;
 		}
 	}
@@ -4529,6 +4629,14 @@ static void task_numa_work(struct callback_head *work)
 		reset_ptenuma_scan(p);
 	mmap_read_unlock(mm);
 
+	/*
+	 * Tiering-only placement feedback is still scan-window based. Consume
+	 * the window when a scan sequence completes, so an empty tiering
+	 * window can back off after qualifying tiering faults stop.
+	 */
+	if (numa_balancing_tiering_only())
+		task_numa_tiering_placement(p);
+
 	/*
 	 * Make sure tasks use at least 32x as much time to run other code
 	 * than they used here, to limit NUMA PTE scanning overhead to 3% max.
@@ -4562,6 +4670,7 @@ void init_numa_balancing(u64 clone_flags, struct task_struct *p)
 	p->numa_faults			= NULL;
 	p->numa_pages_migrated		= 0;
 	p->total_numa_faults		= 0;
+	memset(p->numa_tiering_faults, 0, sizeof(p->numa_tiering_faults));
 	RCU_INIT_POINTER(p->numa_group, NULL);
 	p->last_task_numa_placement	= 0;
 	p->last_sum_exec_runtime	= 0;
-- 
2.20.1

