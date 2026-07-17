Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C84EC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095AA6B00B3; Fri, 17 Jul 2026 12:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0455F6B00B5; Fri, 17 Jul 2026 12:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4DE6B00B6; Fri, 17 Jul 2026 12:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6A56B00B3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:24:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9527B140149
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:58:24 +0000 (UTC)
X-FDA: 84998423328.21.36738B2
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 944A412000D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:58:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BQH8fDzN;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqMnQVIkWoxb+RrEs+jMVyYBu0LSbT8WfW7w+P6K7uQ=;
	b=n6Y1OQkPd7gtnvZqVIGCxni5g9UE+RvAb0uWgidTNVzvUKQLY89QBxOZ4qwoLo8b1daNU7
	btZFsJtQlJiGUSJnpvjqiPxc94sCK7I7tvlgrxkXUPHRx93CYARvPoauFtF0zzRQK2enbC
	9Xarau180PcDgTrQvDzJ3lJ6DJvrcLg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BQH8fDzN;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296703;
	b=R0VOU5NPJ9y0gQgPq7DNX5NkF0a8s6/smNBb4RhiyJe2BTUWfSgoAS7H/LMcOgwmg6yAKF
	LLhNqGcxzeDiZYdZ7t0BfjaoAfMHVH31WMoUru+8pc+fQZJbKZzmMV03GsSGnMMRY3Da/r
	pTBoSWV0yeuD51b6vpy7nYIxCfxz5ds=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784296700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EqMnQVIkWoxb+RrEs+jMVyYBu0LSbT8WfW7w+P6K7uQ=;
	b=BQH8fDzNw+7fX6l53zgJKMNPTm58Wps204K497VQJvc6p4JEudtm1C3FFC/osYBApzBJcT
	Y3zHfGv2q5slUXb3D6pw4PUPHQSluLV1fSGLz2+HSeatRltowwRh/58hzw/vJomJjkCDol
	P4t/o5az3Asty1gJGvenhqTKIikBRwo=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
Date: Fri, 17 Jul 2026 06:57:31 -0700
Message-ID: <20260717135807.3476029-2-usama.arif@linux.dev>
In-Reply-To: <20260717135807.3476029-1-usama.arif@linux.dev>
References: <20260717135807.3476029-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bm1qj1qswu9ewgdz5sto1918ftryuioy
X-Rspamd-Queue-Id: 944A412000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784296702-133871
X-HE-Meta: U2FsdGVkX1+TbjZb/VRF19n78hWDrpQmR24jqO3QzaVczZqMLLxPhGi9iWpycQUPq8meDax6qV8jXRJ4ouiSrRiBb1k6hQpyhrioX6FtEjGbHUcevW5tH7qi5YOfPV/udfajm4v27h0/Xkhj2BtkqIn60X9TOfDPSJth+E9kgOd/67zVpu1om2fuzBo8ZBxo1ulxhFRo2sFqRn97csl8yGNzyUuvbqVXpW1Vzsja1wSG95qUAQBK2te40TLLoZRNo33ygHl3i7GUbHp5JFLUcvfWbU5ipZv04qiLX+EoQMia9q9RK7MHUgSPk29au7KPiOOjt0WMFo++9FXKjDIRpy/mW029NZRIC0TbqUMWE20b49et6OCw2gZhR13kpWHxarSQsCWI97opYR2TeVCFQLXUrq93cPH1VXBvUBNHoJZoludlQBETZHmaH/V0ISbnLHGnwD6sqXYpQc6Srm27UIsYYDxFaTrcmIYv9GjckvnAXdoQBaaBeQ61U+VM7MNmckgjBvlQbIEEC54ngmPJDWDfV3vRpKfFwmlh4amQfCzK7dZjoumT89nxcZgMQZTn7hHjVwA3axN0u3bJqpI539RI3UqsF3BVOh/rMtqLj26BkkwC9WAP66Q4Arf/IXA9yIXDm4W/j4MnCICnnivqN0hPttL0SoOEJxhGPWnjX5u5p65mn+NgoyHEmh489XN14vq1bZkHvXdFUFQNCsldz18X3JsWgUXzcR3RFvFmLuCdi4DUHvbMjdBZS0uBhi6JLAm9OHTROPda8p5XOMUON7qtHcsuBrUMoAlxH7j6Pm9/Ge5Z81GdAqS71HWO45QUBUEnl9YO3cm+N5Y8Hw9TaFWWr09kxw2yJ5MuCYakrK+5SUeqZhmzzKrAubNm7dTMBXk5Kpe5/9x5ZlBCxnReUAsLWHsHQlv18gPN69Wrd8boKqze4/qeaYxmZETsMRPD2urqJ51nBEsqiOwP/mF
 kjEcy4Cr
 xElSsjUUyW+aE6coT9NBCmuEPwHHIohzhv9qnDEh2V0IH9R7tm7RwmqLCiK6OCVV2mTb/zrm7zJxKq6G37IpyzKsR0WaU/nwhHcb/e/+2E20RvMk7+KfnghCDrR8bV35hl1077PvXryfzEzNwCLbJtw/m+0DyhwzDoGkG9r71PmgX6n4nong4EDKH5PkabSbDkwjTdcghyAj5r+wRlgaZngv+ZiuAJBQQyigoBrKRPV5I1w86lAEiZBDQTmMcM6GHUMvcwbKU1X7KZtwslXKGJouRwzuzYltjdWbp+jdvqXNJXGTqGjKKQLgw7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lruvec_page_state(), node_page_state(), and global_node_page_state()
all clamp negative reads to zero on CONFIG_SMP so that a transient
per-CPU delta skew presents as zero pages rather than
as a garbage unsigned value. This is the right behaviour for
non-monotonic page-count readers.

It is however incorrect for callers that snapshot a monotonically-
incremented event counter and compute a delta from two samples.
Once the underlying signed long wraps past LONG_MAX, the clamped read
drops to zero while the previously-recorded snapshot still holds the
pre-wrap value; the unsigned subtraction then underflows into a
~2^31 spurious delta for 32-bit architecture and corrupts the
caller's accumulator.

Add non-clamping siblings that return the underlying state value
cast to unsigned long:

  global_node_page_state_monotonic()
  node_page_state_monotonic()
  lruvec_page_state_monotonic()

With both samples read via the _monotonic variant, unsigned modular
subtraction stays correct across a signed-long wraparound as long
as the true growth between two samples fits in unsigned long
(< 2^32 on 32-bit, < 2^64 on 64-bit); the 32-bit bound is the
practically-reachable one that motivates this helper.

The variants are only safe for monotonically-incremented counters.
Non-monotonic page-count readers must keep using the existing
clamped helpers so transient negative reads still present as zero.

This is a prerequisite for the following patch which
replaces the producer-side anon_cost/file_cost accumulators with a
read-side accumulator in prepare_scan_control() that samples
monotonic per-LRU vmstat counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*,
WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
the unsigned modular delta into a per-lruvec cost_accum[].

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/memcontrol.h |  8 ++++++++
 include/linux/vmstat.h     | 16 ++++++++++++++++
 mm/memcontrol.c            | 36 ++++++++++++++++++++++++++++++++++++
 mm/vmstat.c                | 11 +++++++++++
 4 files changed, 71 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..b40bc4f6fe4a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -931,6 +931,8 @@ unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
+unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+					  enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
@@ -1378,6 +1380,12 @@ static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+							enum node_stat_item idx)
+{
+	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+}
+
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 						    enum node_stat_item idx)
 {
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..fb8c76289e02 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -194,6 +194,19 @@ unsigned long global_node_page_state_pages(enum node_stat_item item)
 	return x;
 }
 
+/*
+ * Non-clamping variant of global_node_page_state() intended for callers that
+ * snapshot a monotonically-incremented counter and subtract two samples.
+ * Returns the raw wrapping value so that unsigned modular subtraction stays
+ * correct across a signed-long overflow (a real hazard on 32-bit) that the
+ * clamp in global_node_page_state() would otherwise turn into a huge spurious
+ * delta. Do NOT use for non-monotonic page-count reads.
+ */
+static inline unsigned long global_node_page_state_monotonic(enum node_stat_item item)
+{
+	return (unsigned long)atomic_long_read(&vm_node_stat[item]);
+}
+
 static inline unsigned long global_node_page_state(enum node_stat_item item)
 {
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
@@ -259,11 +272,14 @@ extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
 extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
 					   enum node_stat_item item);
+extern unsigned long node_page_state_monotonic(struct pglist_data *pgdat,
+					       enum node_stat_item item);
 extern void fold_vm_numa_events(void);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
 #define node_page_state(node, item) global_node_page_state(item)
 #define node_page_state_pages(node, item) global_node_page_state_pages(item)
+#define node_page_state_monotonic(node, item) global_node_page_state_monotonic(item)
 static inline void fold_vm_numa_events(void)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..b4a357c5f7e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -502,6 +502,42 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
 	return x;
 }
 
+/**
+ * lruvec_page_state_monotonic - non-clamping lruvec stat read for delta sampling
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * Returns the raw state[idx] value cast to unsigned long, skipping the
+ * clamp-negative-to-zero step in lruvec_page_state(). Intended for callers
+ * that snapshot a monotonically-incremented counter and subtract two
+ * samples: unsigned modular arithmetic then yields the correct delta across
+ * a signed-long wraparound (a real hazard on 32-bit) that the clamp would
+ * otherwise turn into a huge spurious delta.
+ *
+ * Do NOT use for non-monotonic page-count reads where a transient negative
+ * reading from per-CPU delta skew must present as zero.
+ *
+ * XXX: This helper (and its node/global peers) exists because we place
+ * monotonically-incremented event counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*)
+ * into enum node_stat_item.
+ */
+unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+					  enum node_stat_item idx)
+{
+	struct mem_cgroup_per_node *pn;
+	int i;
+
+	if (mem_cgroup_disabled())
+		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+
+	i = memcg_stats_index(idx);
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return 0;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
+}
+
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..c4364f0eb08a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1024,6 +1024,17 @@ unsigned long node_page_state(struct pglist_data *pgdat,
 
 	return node_page_state_pages(pgdat, item);
 }
+
+/*
+ * Non-clamping variant of node_page_state() intended for callers that
+ * snapshot a monotonically-incremented counter and subtract two samples.
+ * See global_node_page_state_monotonic() for the rationale.
+ */
+unsigned long node_page_state_monotonic(struct pglist_data *pgdat,
+					enum node_stat_item item)
+{
+	return (unsigned long)atomic_long_read(&pgdat->vm_stat[item]);
+}
 #endif
 
 /*
-- 
2.53.0-Meta


