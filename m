Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B158CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8326B00E2; Tue, 30 Jun 2026 07:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE506B00E3; Tue, 30 Jun 2026 07:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF4C6B00E4; Tue, 30 Jun 2026 07:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDF16B00E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:26:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8E8A140345
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:41 +0000 (UTC)
X-FDA: 84936351402.04.7FF0076
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id E61C9180009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GyBv7bIh;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782818800;
	b=GHwRUdbzJmNTcADfurG0zp7K2aIlFLMRme4FfOZlkAl0TBJTwIqquoruVQOmMl+4egy5kL
	nosxC+iMiUIH0tfsWPC2s+A9dW1R0tITxi/ovKHSShMp7dTXa+1l0A83ACbB7z+xWJZtZZ
	5D+6Jxuqz3fGoKrhGa7DytRmxubMWb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782818800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90pCU2U8VlICxiHhRLi/+OTw/qSDu8RLadh21IDXS28=;
	b=YjKsqCROw5MSYKMxvfzcOnSOFjS0F7PrnzQ3mU6IWmjpfG5VSKuRVJfjg6X9dD6MMJ8Wt+
	n721NOyF8C0O8hRXDkLkKlFE3Mm6/NnGaFvY5BKZygFDJwt1GPPmBmf6gnS3dSTOzADX4c
	VWnX1d3QA2Z8GRjpapUruYZV64HAr/k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GyBv7bIh;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782818798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=90pCU2U8VlICxiHhRLi/+OTw/qSDu8RLadh21IDXS28=;
	b=GyBv7bIhxouZ4PbZP+orCwW8qIFlr3in/eemyJ8hKBhkxHQ+BxgbtpAb7cWOBk5aixHZTC
	9O8aQAvZi6zh3jzN7R/UZpW6ibmPVxXeStZuzEeRkDDuFditMvfX5qIvGRAN8HTMwhLvy4
	++syvDCltCr1/XqxZ2JdLZCrk9Zhl+A=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	tj@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 2/2] mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c
Date: Tue, 30 Jun 2026 04:23:33 -0700
Message-ID: <20260630112617.1198623-3-usama.arif@linux.dev>
In-Reply-To: <20260630112617.1198623-1-usama.arif@linux.dev>
References: <20260630112617.1198623-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: pd5brtsrntg5686nzbhsubmzqriqxdzj
X-Rspamd-Queue-Id: E61C9180009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782818799-170418
X-HE-Meta: U2FsdGVkX19RvQZJGfJGuadxJ4m7n1s766RIWUZwJRRnFmVEeRDspE/OdJHIKwTI6qETXELwbrR5+0XNGqaDL0Z6qIl9H6EsOCvKuDs2ufSwlF9o4XHlXQ8aoXd5tgER8kv02E7QE/VU3bSjmYaOJYrXpsVmTKE3W8NEAwt+1bHWbibVQnS2DV9cDHbg7iQbWrWmqaCM2hM6nkbzKvsIs2NgdlbdZZuWttK4CUPM4eJD83PaE2/Nk78n7FazFr+u+nGV+k2TOZItOkDIPGMBKdRsEqOPN8Yqmk7Kvdvc1Cfr4rIoDFVTkgb/MjisRFP02UpmaM+7arQc5qLJpJVKHfhnBL/LBIg0XPLUnCMjDrSzb0y7jKLtZ9Nv3ysDZgVor3OxQrJh8y81cn5MCuEKWA7g99Dzbyz/mh33jnR7C9PUovzn6QTw/98ovYQLtyqdGCI/g5gGZlhMNcQkcQjVk0OlJ3xNvXm4rGVql8KYzCYLhW8InGCkx9WmZqleaGq2yMV0kvziBmdtuGt9tvpkCS8/HNgd4zCFmdO6NWRVjBo4j3ddLN23MI8ZvQ9uRNpwwZZ9qFSx+sC/slZwThJHB8W1r2NV8jyJ3UUvOxXdUoEDt54DmMbDdjT+tADtvWSTAB54e8loPLjXRcOnPykFgR2QyH0UWCBLTEDsGQgk2Js5Huen6qFd2eeAdp1Omm6oJxGF+OgSEGlX/cZVWl1LRwOcqPjNrQVNGgr5YP0ar4xMHVsg8nJCvTiPMP1dToPf7i1hUN4Ysc3nrRvZaZvN2UKmALdcu5jMp2r4FN7Nif3FCAwJvC058mP3Kdas9GOELipIsU7WR4WSzUrccDxuj2PLestFfSDt/xxwYD7ik1qoz+7fKl9Y0o4nCZlZJZAsTbmv+RIQj8M0qMicKr8huXPGL8qv0x3lsFHIsV78GHqgersaNAMiy/PgN29pZmmuNBhNiTRn6ivxrOEwCd5
 xlM0R5yo
 GmG/AnV/gTXHvstRgCHTC31sNlK5WSv6LpC7tt4dVTnx7gF0ZJ/JoveTur1QMvXdY79WgVMIN4naVevtnLfsK6bRPF73ShG61IeKxWj2SARuJxPPU1teUBtKxw7rPgcOJ3ho6SQ272LmsV1e4zEIUWcomTSOEPueNG77O8EKirrf8rQ2286VYLtEbaSlblyzypL7DgSofPKSusR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clean up mm/vmpressure.c by separating the cgroup v1 userspace eventfd
interface from the shared and v2 in-kernel code.

Currently, almost half of mm/vmpressure.c exists to serve tree=true:
struct vmpressure_event, the events list and its mutex, the work_struct
and vmpressure_work_fn that drains tree_scanned/tree_reclaimed, the
parent walk, vmpressure_event(), vmpressure_register_event(),
vmpressure_unregister_event(), and vmpressure_prio() (which always
calls vmpressure() with tree=true).

Move it all into mm/memcontrol-v1.c (built only when CONFIG_MEMCG_V1=y)
as a single contiguous block, following the per-component layout already
used by that file. Keeping the v1 vmpressure code with the rest of the
deprecated cgroup v1 memory controller makes the full footprint of the
CONFIG_MEMCG_V1 option easy to see in one place, which matters more
than component-level file separation for code that has no active
development.

vmpressure.c keeps the shared bits (constants, vmpressure_calc_level,
the runtime hierarchy check, the tree=false body, init/cleanup
plumbing) and calls into three small v1 hooks for the tree=true
accumulator and the v1 portions of init/cleanup. The hooks have
static-inline no-op stubs in include/linux/vmpressure.h for the
!MEMCG_V1 case, so callers don't need ifdefs. vmpressure_prio() gets
the same treatment, which means vmscan.c's call site disappears at
compile time on v2-only kernels.

The only #ifdef CONFIG_MEMCG_V1 in source remains around the v1-only
fields inside struct vmpressure itself.

Memory savings on CONFIG_MEMCG_V1=n (measured with pahole):

  struct vmpressure :  112B ->   24B
  struct mem_cgroup : 1664B -> 1536B

This split is the first step toward eventually making vmpressure
CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
(tree=false) cannot be removed today immediately: PSI is not an
exact replacement for vmpressure, and switching networking socket-buffer
back-off to PSI may regress networking performance or increase memory
pressure in workloads that today rely on vmpressure's hysteresis. The
medium-term plan is to introduce a PSI-based socket-pressure path, keep
vmpressure available for v2 behind a defconfig as an opt-out for several
releases, and only then drop the tree=false path entirely, at which point
everything that remains of the vmpressure block in mm/memcontrol-v1.c is
the whole subsystem.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/vmpressure.h |  46 +++++-
 mm/memcontrol-v1.c         | 292 +++++++++++++++++++++++++++++++++++++
 mm/vmpressure.c            | 292 ++-----------------------------------
 3 files changed, 343 insertions(+), 287 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index faecd5522401..b4d13457bc2a 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -13,18 +13,31 @@
 struct vmpressure {
 	unsigned long scanned;
 	unsigned long reclaimed;
+	/* The lock is used to keep the scanned/reclaimed in sync. */
+	spinlock_t sr_lock;
 
+#ifdef CONFIG_MEMCG_V1
+	/*
+	 * tree=true accumulators feed the v1 userspace eventfd interface
+	 * (memory.pressure_level). Drained by @work. v2 has no equivalent
+	 * interface, so this state is omitted on CONFIG_MEMCG_V1=n builds.
+	 */
 	unsigned long tree_scanned;
 	unsigned long tree_reclaimed;
-	/* The lock is used to keep the scanned/reclaimed above in sync. */
-	spinlock_t sr_lock;
-
 	/* The list of vmpressure_event structs. */
 	struct list_head events;
 	/* Have to grab the lock on events traversal or modifications. */
 	struct mutex events_lock;
 
 	struct work_struct work;
+#endif
+};
+
+enum vmpressure_levels {
+	VMPRESSURE_LOW = 0,
+	VMPRESSURE_MEDIUM,
+	VMPRESSURE_CRITICAL,
+	VMPRESSURE_NUM_LEVELS,
 };
 
 struct mem_cgroup;
@@ -32,18 +45,41 @@ struct mem_cgroup;
 #ifdef CONFIG_MEMCG
 void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		unsigned long scanned, unsigned long reclaimed);
-extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
-
 extern void vmpressure_init(struct vmpressure *vmpr);
 extern void vmpressure_cleanup(struct vmpressure *vmpr);
 extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
 extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
+
+/* Shared with the v1 vmpressure block in mm/memcontrol-v1.c. */
+extern const unsigned long vmpressure_win;
+extern enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
+						    unsigned long reclaimed);
+
+#ifdef CONFIG_MEMCG_V1
+extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
 extern int vmpressure_register_event(struct mem_cgroup *memcg,
 				     struct eventfd_ctx *eventfd,
 				     const char *args);
 extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
 					struct eventfd_ctx *eventfd);
+
+/* v1 hooks called from mm/vmpressure.c; no-ops below when !MEMCG_V1. */
+extern void vmpressure_v1_init(struct vmpressure *vmpr);
+extern void vmpressure_v1_cleanup(struct vmpressure *vmpr);
+extern void vmpressure_v1_account_tree(struct vmpressure *vmpr,
+				       unsigned long scanned,
+				       unsigned long reclaimed);
 #else
+static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
+				   int prio) {}
+static inline void vmpressure_v1_init(struct vmpressure *vmpr) {}
+static inline void vmpressure_v1_cleanup(struct vmpressure *vmpr) {}
+static inline void vmpressure_v1_account_tree(struct vmpressure *vmpr,
+					      unsigned long scanned,
+					      unsigned long reclaimed) {}
+#endif /* CONFIG_MEMCG_V1 */
+
+#else /* !CONFIG_MEMCG */
 static inline void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg,
 			      bool tree, unsigned long scanned,
 			      unsigned long reclaimed) {}
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 765069211567..135622b6172b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -6,6 +6,7 @@
 #include <linux/pagewalk.h>
 #include <linux/backing-dev.h>
 #include <linux/eventfd.h>
+#include <linux/log2.h>
 #include <linux/poll.h>
 #include <linux/sort.h>
 #include <linux/file.h>
@@ -1476,6 +1477,297 @@ void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked)
 		mem_cgroup_oom_unlock(memcg);
 }
 
+/*
+ * cgroup v1 userspace vmpressure interface (memory.pressure_level /
+ * cgroup.event_control). Kept here so v2-only kernels (CONFIG_MEMCG_V1=n)
+ * drop the whole eventfd accumulator, its work item, and the per-memcg
+ * state it requires.
+ *
+ * When there are too little pages left to scan, vmpressure() may miss the
+ * critical pressure as number of pages will be less than "window size".
+ * However, in that case the vmscan priority will raise fast as the
+ * reclaimer will try to scan LRUs more deeply.
+ *
+ * The vmscan logic considers these special priorities:
+ *
+ * prio == DEF_PRIORITY (12): reclaimer starts with that value
+ * prio <= DEF_PRIORITY - 2 : kswapd becomes somewhat overwhelmed
+ * prio == 0                : close to OOM, kernel scans every page in an lru
+ *
+ * Any value in this range is acceptable for this tunable (i.e. from 12 to
+ * 0). Current value for the vmpressure_level_critical_prio is chosen
+ * empirically, but the number, in essence, means that we consider
+ * critical level when scanning depth is ~10% of the lru size (vmscan
+ * scans 'lru_size >> prio' pages, so it is actually 12.5%, or one
+ * eights).
+ */
+static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
+
+enum vmpressure_modes {
+	VMPRESSURE_NO_PASSTHROUGH = 0,
+	VMPRESSURE_HIERARCHY,
+	VMPRESSURE_LOCAL,
+	VMPRESSURE_NUM_MODES,
+};
+
+static const char * const vmpressure_str_levels[] = {
+	[VMPRESSURE_LOW] = "low",
+	[VMPRESSURE_MEDIUM] = "medium",
+	[VMPRESSURE_CRITICAL] = "critical",
+};
+
+static const char * const vmpressure_str_modes[] = {
+	[VMPRESSURE_NO_PASSTHROUGH] = "default",
+	[VMPRESSURE_HIERARCHY] = "hierarchy",
+	[VMPRESSURE_LOCAL] = "local",
+};
+
+struct vmpressure_event {
+	struct eventfd_ctx *efd;
+	enum vmpressure_levels level;
+	enum vmpressure_modes mode;
+	struct list_head node;
+};
+
+static struct vmpressure *work_to_vmpressure(struct work_struct *work)
+{
+	return container_of(work, struct vmpressure, work);
+}
+
+static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
+{
+	struct mem_cgroup *memcg = vmpressure_to_memcg(vmpr);
+
+	memcg = parent_mem_cgroup(memcg);
+	if (!memcg)
+		return NULL;
+	return memcg_to_vmpressure(memcg);
+}
+
+static bool vmpressure_event(struct vmpressure *vmpr,
+			     const enum vmpressure_levels level,
+			     bool ancestor, bool signalled)
+{
+	struct vmpressure_event *ev;
+	bool ret = false;
+
+	mutex_lock(&vmpr->events_lock);
+	list_for_each_entry(ev, &vmpr->events, node) {
+		if (ancestor && ev->mode == VMPRESSURE_LOCAL)
+			continue;
+		if (signalled && ev->mode == VMPRESSURE_NO_PASSTHROUGH)
+			continue;
+		if (level < ev->level)
+			continue;
+		eventfd_signal(ev->efd);
+		ret = true;
+	}
+	mutex_unlock(&vmpr->events_lock);
+
+	return ret;
+}
+
+static void vmpressure_work_fn(struct work_struct *work)
+{
+	struct vmpressure *vmpr = work_to_vmpressure(work);
+	unsigned long scanned;
+	unsigned long reclaimed;
+	enum vmpressure_levels level;
+	bool ancestor = false;
+	bool signalled = false;
+
+	spin_lock(&vmpr->sr_lock);
+	/*
+	 * Several contexts might be calling vmpressure(), so it is
+	 * possible that the work was rescheduled again before the old
+	 * work context cleared the counters. In that case we will run
+	 * just after the old work returns, but then scanned might be zero
+	 * here. No need for any locks here since we don't care if
+	 * vmpr->reclaimed is in sync.
+	 */
+	scanned = vmpr->tree_scanned;
+	if (!scanned) {
+		spin_unlock(&vmpr->sr_lock);
+		return;
+	}
+
+	reclaimed = vmpr->tree_reclaimed;
+	vmpr->tree_scanned = 0;
+	vmpr->tree_reclaimed = 0;
+	spin_unlock(&vmpr->sr_lock);
+
+	level = vmpressure_calc_level(scanned, reclaimed);
+
+	do {
+		if (vmpressure_event(vmpr, level, ancestor, signalled))
+			signalled = true;
+		ancestor = true;
+	} while ((vmpr = vmpressure_parent(vmpr)));
+}
+
+/*
+ * Tree-mode accumulator: accumulate per-memcg scanned/reclaimed and
+ * schedule the work that walks the parent chain and signals registered
+ * eventfd listeners once we cross the window threshold.
+ */
+void vmpressure_v1_account_tree(struct vmpressure *vmpr,
+				unsigned long scanned,
+				unsigned long reclaimed)
+{
+	spin_lock(&vmpr->sr_lock);
+	scanned = vmpr->tree_scanned += scanned;
+	vmpr->tree_reclaimed += reclaimed;
+	spin_unlock(&vmpr->sr_lock);
+
+	if (scanned < vmpressure_win)
+		return;
+	schedule_work(&vmpr->work);
+}
+
+void vmpressure_v1_init(struct vmpressure *vmpr)
+{
+	mutex_init(&vmpr->events_lock);
+	INIT_LIST_HEAD(&vmpr->events);
+	INIT_WORK(&vmpr->work, vmpressure_work_fn);
+}
+
+void vmpressure_v1_cleanup(struct vmpressure *vmpr)
+{
+	/*
+	 * Make sure there is no pending work before eventfd infrastructure
+	 * goes away.
+	 */
+	flush_work(&vmpr->work);
+}
+
+/**
+ * vmpressure_prio() - Account memory pressure through reclaimer priority level
+ * @gfp:	reclaimer's gfp mask
+ * @memcg:	cgroup memory controller handle
+ * @prio:	reclaimer's priority
+ *
+ * This function should be called from the reclaim path every time when
+ * the vmscan's reclaiming priority (scanning depth) changes.
+ *
+ * This function does not return any value.
+ */
+void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
+{
+	/*
+	 * We only use prio for accounting critical level. For more info
+	 * see comment for vmpressure_level_critical_prio variable above.
+	 */
+	if (prio > vmpressure_level_critical_prio)
+		return;
+
+	/*
+	 * OK, the prio is below the threshold, updating vmpressure
+	 * information before shrinker dives into long shrinking of long
+	 * range vmscan. Passing scanned = vmpressure_win, reclaimed = 0
+	 * to the vmpressure() basically means that we signal 'critical'
+	 * level.
+	 */
+	vmpressure(gfp, 0, memcg, true, vmpressure_win, 0);
+}
+
+#define MAX_VMPRESSURE_ARGS_LEN	(strlen("critical") + strlen("hierarchy") + 2)
+
+/**
+ * vmpressure_register_event() - Bind vmpressure notifications to an eventfd
+ * @memcg:	memcg that is interested in vmpressure notifications
+ * @eventfd:	eventfd context to link notifications with
+ * @args:	event arguments (pressure level threshold, optional mode)
+ *
+ * This function associates eventfd context with the vmpressure
+ * infrastructure, so that the notifications will be delivered to the
+ * @eventfd. The @args parameter is a comma-delimited string that denotes a
+ * pressure level threshold (one of vmpressure_str_levels, i.e. "low", "medium",
+ * or "critical") and an optional mode (one of vmpressure_str_modes, i.e.
+ * "hierarchy" or "local").
+ *
+ * To be used as memcg event method.
+ *
+ * Return: 0 on success, -ENOMEM on memory failure or -EINVAL if @args could
+ * not be parsed.
+ */
+int vmpressure_register_event(struct mem_cgroup *memcg,
+			      struct eventfd_ctx *eventfd, const char *args)
+{
+	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+	struct vmpressure_event *ev;
+	enum vmpressure_modes mode = VMPRESSURE_NO_PASSTHROUGH;
+	enum vmpressure_levels level;
+	char *spec, *spec_orig;
+	char *token;
+	int ret = 0;
+
+	spec_orig = spec = kstrndup(args, MAX_VMPRESSURE_ARGS_LEN, GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	/* Find required level */
+	token = strsep(&spec, ",");
+	ret = match_string(vmpressure_str_levels, VMPRESSURE_NUM_LEVELS, token);
+	if (ret < 0)
+		goto out;
+	level = ret;
+
+	/* Find optional mode */
+	token = strsep(&spec, ",");
+	if (token) {
+		ret = match_string(vmpressure_str_modes, VMPRESSURE_NUM_MODES, token);
+		if (ret < 0)
+			goto out;
+		mode = ret;
+	}
+
+	ev = kzalloc_obj(*ev);
+	if (!ev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ev->efd = eventfd;
+	ev->level = level;
+	ev->mode = mode;
+
+	mutex_lock(&vmpr->events_lock);
+	list_add(&ev->node, &vmpr->events);
+	mutex_unlock(&vmpr->events_lock);
+	ret = 0;
+out:
+	kfree(spec_orig);
+	return ret;
+}
+
+/**
+ * vmpressure_unregister_event() - Unbind eventfd from vmpressure
+ * @memcg:	memcg handle
+ * @eventfd:	eventfd context that was used to link vmpressure with the @cg
+ *
+ * This function does internal manipulations to detach the @eventfd from
+ * the vmpressure notifications, and then frees internal resources
+ * associated with the @eventfd (but the @eventfd itself is not freed).
+ *
+ * To be used as memcg event method.
+ */
+void vmpressure_unregister_event(struct mem_cgroup *memcg,
+				 struct eventfd_ctx *eventfd)
+{
+	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+	struct vmpressure_event *ev;
+
+	mutex_lock(&vmpr->events_lock);
+	list_for_each_entry(ev, &vmpr->events, node) {
+		if (ev->efd != eventfd)
+			continue;
+		list_del(&ev->node);
+		kfree(ev);
+		break;
+	}
+	mutex_unlock(&vmpr->events_lock);
+}
+
 static DEFINE_MUTEX(memcg_max_mutex);
 
 static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index c82cee1ab43b..14470141bbe6 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -7,16 +7,15 @@
  *
  * Based on ideas from Andrew Morton, David Rientjes, KOSAKI Motohiro,
  * Leonid Moiseichuk, Mel Gorman, Minchan Kim and Pekka Enberg.
+ *
+ * Tree-mode (cgroup v1 userspace eventfd) bookkeeping lives in
+ * mm/memcontrol-v1.c; this file holds the shared code and the in-kernel
+ * (tree=false) socket-pressure path that runs on cgroup v2.
  */
 
 #include <linux/cgroup.h>
-#include <linux/fs.h>
 #include <linux/log2.h>
-#include <linux/sched.h>
 #include <linux/mm.h>
-#include <linux/vmstat.h>
-#include <linux/eventfd.h>
-#include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/printk.h>
 #include <linux/vmpressure.h>
@@ -35,7 +34,7 @@
  * TODO: Make the window size depend on machine size, as we do for vmstat
  * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
 
 /*
  * These thresholds are used when we account memory pressure through
@@ -46,68 +45,6 @@ static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
 static const unsigned int vmpressure_level_med = 60;
 static const unsigned int vmpressure_level_critical = 95;
 
-/*
- * When there are too little pages left to scan, vmpressure() may miss the
- * critical pressure as number of pages will be less than "window size".
- * However, in that case the vmscan priority will raise fast as the
- * reclaimer will try to scan LRUs more deeply.
- *
- * The vmscan logic considers these special priorities:
- *
- * prio == DEF_PRIORITY (12): reclaimer starts with that value
- * prio <= DEF_PRIORITY - 2 : kswapd becomes somewhat overwhelmed
- * prio == 0                : close to OOM, kernel scans every page in an lru
- *
- * Any value in this range is acceptable for this tunable (i.e. from 12 to
- * 0). Current value for the vmpressure_level_critical_prio is chosen
- * empirically, but the number, in essence, means that we consider
- * critical level when scanning depth is ~10% of the lru size (vmscan
- * scans 'lru_size >> prio' pages, so it is actually 12.5%, or one
- * eights).
- */
-static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
-
-static struct vmpressure *work_to_vmpressure(struct work_struct *work)
-{
-	return container_of(work, struct vmpressure, work);
-}
-
-static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
-{
-	struct mem_cgroup *memcg = vmpressure_to_memcg(vmpr);
-
-	memcg = parent_mem_cgroup(memcg);
-	if (!memcg)
-		return NULL;
-	return memcg_to_vmpressure(memcg);
-}
-
-enum vmpressure_levels {
-	VMPRESSURE_LOW = 0,
-	VMPRESSURE_MEDIUM,
-	VMPRESSURE_CRITICAL,
-	VMPRESSURE_NUM_LEVELS,
-};
-
-enum vmpressure_modes {
-	VMPRESSURE_NO_PASSTHROUGH = 0,
-	VMPRESSURE_HIERARCHY,
-	VMPRESSURE_LOCAL,
-	VMPRESSURE_NUM_MODES,
-};
-
-static const char * const vmpressure_str_levels[] = {
-	[VMPRESSURE_LOW] = "low",
-	[VMPRESSURE_MEDIUM] = "medium",
-	[VMPRESSURE_CRITICAL] = "critical",
-};
-
-static const char * const vmpressure_str_modes[] = {
-	[VMPRESSURE_NO_PASSTHROUGH] = "default",
-	[VMPRESSURE_HIERARCHY] = "hierarchy",
-	[VMPRESSURE_LOCAL] = "local",
-};
-
 static enum vmpressure_levels vmpressure_level(unsigned long pressure)
 {
 	if (pressure >= vmpressure_level_critical)
@@ -117,8 +54,8 @@ static enum vmpressure_levels vmpressure_level(unsigned long pressure)
 	return VMPRESSURE_LOW;
 }
 
-static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
-						    unsigned long reclaimed)
+enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
+					     unsigned long reclaimed)
 {
 	unsigned long scale = scanned + reclaimed;
 	unsigned long pressure = 0;
@@ -147,74 +84,6 @@ static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
 	return vmpressure_level(pressure);
 }
 
-struct vmpressure_event {
-	struct eventfd_ctx *efd;
-	enum vmpressure_levels level;
-	enum vmpressure_modes mode;
-	struct list_head node;
-};
-
-static bool vmpressure_event(struct vmpressure *vmpr,
-			     const enum vmpressure_levels level,
-			     bool ancestor, bool signalled)
-{
-	struct vmpressure_event *ev;
-	bool ret = false;
-
-	mutex_lock(&vmpr->events_lock);
-	list_for_each_entry(ev, &vmpr->events, node) {
-		if (ancestor && ev->mode == VMPRESSURE_LOCAL)
-			continue;
-		if (signalled && ev->mode == VMPRESSURE_NO_PASSTHROUGH)
-			continue;
-		if (level < ev->level)
-			continue;
-		eventfd_signal(ev->efd);
-		ret = true;
-	}
-	mutex_unlock(&vmpr->events_lock);
-
-	return ret;
-}
-
-static void vmpressure_work_fn(struct work_struct *work)
-{
-	struct vmpressure *vmpr = work_to_vmpressure(work);
-	unsigned long scanned;
-	unsigned long reclaimed;
-	enum vmpressure_levels level;
-	bool ancestor = false;
-	bool signalled = false;
-
-	spin_lock(&vmpr->sr_lock);
-	/*
-	 * Several contexts might be calling vmpressure(), so it is
-	 * possible that the work was rescheduled again before the old
-	 * work context cleared the counters. In that case we will run
-	 * just after the old work returns, but then scanned might be zero
-	 * here. No need for any locks here since we don't care if
-	 * vmpr->reclaimed is in sync.
-	 */
-	scanned = vmpr->tree_scanned;
-	if (!scanned) {
-		spin_unlock(&vmpr->sr_lock);
-		return;
-	}
-
-	reclaimed = vmpr->tree_reclaimed;
-	vmpr->tree_scanned = 0;
-	vmpr->tree_reclaimed = 0;
-	spin_unlock(&vmpr->sr_lock);
-
-	level = vmpressure_calc_level(scanned, reclaimed);
-
-	do {
-		if (vmpressure_event(vmpr, level, ancestor, signalled))
-			signalled = true;
-		ancestor = true;
-	} while ((vmpr = vmpressure_parent(vmpr)));
-}
-
 /**
  * vmpressure() - Account memory pressure through scanned/reclaimed ratio
  * @gfp:	reclaimer's gfp mask
@@ -283,14 +152,7 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		return;
 
 	if (tree) {
-		spin_lock(&vmpr->sr_lock);
-		scanned = vmpr->tree_scanned += scanned;
-		vmpr->tree_reclaimed += reclaimed;
-		spin_unlock(&vmpr->sr_lock);
-
-		if (scanned < vmpressure_win)
-			return;
-		schedule_work(&vmpr->work);
+		vmpressure_v1_account_tree(vmpr, scanned, reclaimed);
 	} else {
 		enum vmpressure_levels level;
 
@@ -332,134 +194,6 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 	}
 }
 
-/**
- * vmpressure_prio() - Account memory pressure through reclaimer priority level
- * @gfp:	reclaimer's gfp mask
- * @memcg:	cgroup memory controller handle
- * @prio:	reclaimer's priority
- *
- * This function should be called from the reclaim path every time when
- * the vmscan's reclaiming priority (scanning depth) changes.
- *
- * This function does not return any value.
- */
-void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
-{
-	/*
-	 * We only use prio for accounting critical level. For more info
-	 * see comment for vmpressure_level_critical_prio variable above.
-	 */
-	if (prio > vmpressure_level_critical_prio)
-		return;
-
-	/*
-	 * OK, the prio is below the threshold, updating vmpressure
-	 * information before shrinker dives into long shrinking of long
-	 * range vmscan. Passing scanned = vmpressure_win, reclaimed = 0
-	 * to the vmpressure() basically means that we signal 'critical'
-	 * level.
-	 */
-	vmpressure(gfp, 0, memcg, true, vmpressure_win, 0);
-}
-
-#define MAX_VMPRESSURE_ARGS_LEN	(strlen("critical") + strlen("hierarchy") + 2)
-
-/**
- * vmpressure_register_event() - Bind vmpressure notifications to an eventfd
- * @memcg:	memcg that is interested in vmpressure notifications
- * @eventfd:	eventfd context to link notifications with
- * @args:	event arguments (pressure level threshold, optional mode)
- *
- * This function associates eventfd context with the vmpressure
- * infrastructure, so that the notifications will be delivered to the
- * @eventfd. The @args parameter is a comma-delimited string that denotes a
- * pressure level threshold (one of vmpressure_str_levels, i.e. "low", "medium",
- * or "critical") and an optional mode (one of vmpressure_str_modes, i.e.
- * "hierarchy" or "local").
- *
- * To be used as memcg event method.
- *
- * Return: 0 on success, -ENOMEM on memory failure or -EINVAL if @args could
- * not be parsed.
- */
-int vmpressure_register_event(struct mem_cgroup *memcg,
-			      struct eventfd_ctx *eventfd, const char *args)
-{
-	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
-	struct vmpressure_event *ev;
-	enum vmpressure_modes mode = VMPRESSURE_NO_PASSTHROUGH;
-	enum vmpressure_levels level;
-	char *spec, *spec_orig;
-	char *token;
-	int ret = 0;
-
-	spec_orig = spec = kstrndup(args, MAX_VMPRESSURE_ARGS_LEN, GFP_KERNEL);
-	if (!spec)
-		return -ENOMEM;
-
-	/* Find required level */
-	token = strsep(&spec, ",");
-	ret = match_string(vmpressure_str_levels, VMPRESSURE_NUM_LEVELS, token);
-	if (ret < 0)
-		goto out;
-	level = ret;
-
-	/* Find optional mode */
-	token = strsep(&spec, ",");
-	if (token) {
-		ret = match_string(vmpressure_str_modes, VMPRESSURE_NUM_MODES, token);
-		if (ret < 0)
-			goto out;
-		mode = ret;
-	}
-
-	ev = kzalloc_obj(*ev);
-	if (!ev) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ev->efd = eventfd;
-	ev->level = level;
-	ev->mode = mode;
-
-	mutex_lock(&vmpr->events_lock);
-	list_add(&ev->node, &vmpr->events);
-	mutex_unlock(&vmpr->events_lock);
-	ret = 0;
-out:
-	kfree(spec_orig);
-	return ret;
-}
-
-/**
- * vmpressure_unregister_event() - Unbind eventfd from vmpressure
- * @memcg:	memcg handle
- * @eventfd:	eventfd context that was used to link vmpressure with the @cg
- *
- * This function does internal manipulations to detach the @eventfd from
- * the vmpressure notifications, and then frees internal resources
- * associated with the @eventfd (but the @eventfd itself is not freed).
- *
- * To be used as memcg event method.
- */
-void vmpressure_unregister_event(struct mem_cgroup *memcg,
-				 struct eventfd_ctx *eventfd)
-{
-	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
-	struct vmpressure_event *ev;
-
-	mutex_lock(&vmpr->events_lock);
-	list_for_each_entry(ev, &vmpr->events, node) {
-		if (ev->efd != eventfd)
-			continue;
-		list_del(&ev->node);
-		kfree(ev);
-		break;
-	}
-	mutex_unlock(&vmpr->events_lock);
-}
-
 /**
  * vmpressure_init() - Initialize vmpressure control structure
  * @vmpr:	Structure to be initialized
@@ -470,9 +204,7 @@ void vmpressure_unregister_event(struct mem_cgroup *memcg,
 void vmpressure_init(struct vmpressure *vmpr)
 {
 	spin_lock_init(&vmpr->sr_lock);
-	mutex_init(&vmpr->events_lock);
-	INIT_LIST_HEAD(&vmpr->events);
-	INIT_WORK(&vmpr->work, vmpressure_work_fn);
+	vmpressure_v1_init(vmpr);
 }
 
 /**
@@ -484,9 +216,5 @@ void vmpressure_init(struct vmpressure *vmpr)
  */
 void vmpressure_cleanup(struct vmpressure *vmpr)
 {
-	/*
-	 * Make sure there is no pending work before eventfd infrastructure
-	 * goes away.
-	 */
-	flush_work(&vmpr->work);
+	vmpressure_v1_cleanup(vmpr);
 }
-- 
2.53.0-Meta


