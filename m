Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35913C44524
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8AC6B008A; Mon, 20 Jul 2026 12:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88CB6B008C; Mon, 20 Jul 2026 12:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78096B0092; Mon, 20 Jul 2026 12:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 995AF6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:42:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFB5A1A0229
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:42:28 +0000 (UTC)
X-FDA: 85009723176.23.7A40F5E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E838C000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:42:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bSf73LT6;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784565747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqMnQVIkWoxb+RrEs+jMVyYBu0LSbT8WfW7w+P6K7uQ=;
	b=Rphwr4QYG4Hcrly3ukSL9vDMIvrI/mOwDD5JrS+nq7gDCGfdVy0E3gdq0rD04kd1pdM24s
	NRyCtgOD3d44e7/lGUCnrR0xsgBbh5k5ClRtijzcXbxfMgxwW2HKRxDh5ACCPlwZsf6oAN
	CWL9bCuZ0YE5cKOo1OUwHFUjxUZ1ziA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784565747;
	b=fpiH3D6al1neIk79qoVube/DBOEt07jEEIN88UIJgN14n68XRhUGGofRsJTYZTswWAmiqg
	kWYI1ZhTJuHTfouyii4ChFguxkFLUzKqERlsJIU/rXu5ekE5cSXUStV5gC/KgYFMW5gtct
	KAVNCpg3byYcq3vz7IXwXYR67hAAtNQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bSf73LT6;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784565743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EqMnQVIkWoxb+RrEs+jMVyYBu0LSbT8WfW7w+P6K7uQ=;
	b=bSf73LT6zmv6iHRzh1nyG6HQ5XmmTwZZ07TNO0fiFD3dsGWdYHcv3gwPKWOmvfUK0/+1eJ
	3meZXRvGIYrzUoY7rsap1WGZOkw9i86k/1/MJkiRzvub+OTV74RSAJfuouRFSJPCf3BpGf
	Q316LzrD3OIedsEgeruFH6ijtO5euzc=
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
Subject: [PATCH v4 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
Date: Mon, 20 Jul 2026 09:41:22 -0700
Message-ID: <20260720164207.450685-2-usama.arif@linux.dev>
In-Reply-To: <20260720164207.450685-1-usama.arif@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E838C000D
X-Stat-Signature: gj3b55xr75o5dpy3ideq36sonouo9j4q
X-Rspam-User: 
X-HE-Tag: 1784565747-536789
X-HE-Meta: U2FsdGVkX1/VuzvDWLXfHSPb6dAhHUNA7LQ1ygc2pVuQ6QX3cbEifAzg1w1+qGHg6WcjQVQ3XSx4mCURPq8htkvBo0Up0ZPch0E6TNJHSIRP42/9zWfP4x9O5OJKLmG560pi64Nj8jzEj/Oi/DWvJ6qD4/fBVrcZHTJUNz5cJnPPQ/MZ7CzCheAQPHKHw4Ul3wn5tJ4slPDWPAU+vHOZsgHPBRthvTWtEr8LJ2b2uWH5dMx4ToSkt/hTatwQo32uvldXz4t0RVLMVdt40KaFp4yjTBjCEVR3RdtGlB/2ACxw9qt0ebJTrBDnNqjg4eB8YpwnwddBQceJz++crDTD62mUJN+EZge/ZqM0yNixgzOO+Xh5zqPbpp8vgqFMHCUHeZVnCSRPXIBe5qxQmr42DSEwhpzClZD92ftVWxuq5cD7lpswoN+cQvht5eMbPE9S6Oa0tAAQTLtZdJrJOin2FlzkZjiPeCVRpeGixNISGEEPY1XrAoXm6VKNNmW4v1uGdB4haPHTMPKX9hwIAfwUHjwUHgcSnJIJnzEMjkCUe5zZ9nDRYAYJ10kXzmRTWkk7lISPHWeSYUQxyFmm/nXRUsjqyIg9u+8lT4WE471BA0XZkYgTpQtsvaiTnkhwnw/REP4X28KqxaIimVIIcLLFSF96HyTsOlpWuSb/xFwZos73bMryuT6dkDdW3jPPd6CVmR/5P7fviVxiPIv7j6t2LEDOL9D+kt1LvQGwIhQWi8WTlfzMvZ5W+A2FtKGIgtpE0CDE7jykpwgaFRAzllXCoNQtu5RhTmIc1+4zmclg6hEqK2sVJDTnQgKeNJfNIu/MYRzZQIs+uLKRDtO7/XL5J50pq0EFD4tW0on9Bu5TBHaKJvguGtcmxpUA68IDHTAGiqkNvNB96itr35Svu07ZC9WVlGLiA+CcxtwV7TT7e4225BDmfCHPH9ek4qW/Q2HDq1USdiTvZj8ViE2H/we
 ENFgDzOS
 MaUypXz1blKi6BF/7+nXx0fBPFBJCZcaMXEMsSTyCcy+m1Pd3cI0mL8FRrJVrBZW4SVoCbKLcDdvb6shBjYQMA/2NA7Xq7owmpKJC8t2xGk0B+NF9dlGb94kFJa5CP+kkA0GeUFVVGi2q65CJ1czbayRIbZe9fQcqmFgHGy0lVEKyJOuMdtS7uP6et3wW9vwEVuLTOI2vgjnGXkJtH18OjJrcoI0mwiG5tSASSqtlF3/CoILDwKm9gBxayLaNDFsWIdhqrmLbz5MqOGFrqgetwD8He/yOX/AmPKbGXeDG2dTuSWo7YFlp6nZgBg==
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


