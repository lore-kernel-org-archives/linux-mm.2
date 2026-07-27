Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29975C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387CF6B0095; Mon, 27 Jul 2026 12:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339166B0099; Mon, 27 Jul 2026 12:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2034C6B009B; Mon, 27 Jul 2026 12:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED7446B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:26:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C47040128
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:26:12 +0000 (UTC)
X-FDA: 85035083784.03.C2E208B
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD3D74000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:26:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ixQWk19v;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785169571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwLRE88/T88bbZWERmNBLA5mHYgHg0FYmvx8DEB65+s=;
	b=g6wmX5hXLGq8mvIuwohKwfzARoD7sSAQO26WPOq+4FDN/+F8foMenbA0LiPJp8plo9rpWP
	EFgt1cox39h6uVfPkAXv/8f2TgPOZHu6KmjgYb56hwmyGg+AxqzCX49Di5o334pLgUyVZX
	DrdbjozPknVILylbGs+QPDYBCR/vnIY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ixQWk19v;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785169571;
	b=xbNf0sCEfo8cSQcQ2R1Dk1wTrOJBFkBtnKV4Lgxf0SMWkV6QiMxcWmOlffighgC+0uYN6o
	0UuLzZL+fc321lSaWm8qzKrJmHpB/E6OdJ1JPgGKp+U8X6VRpl+lyCBEZRob2WXvFDBR4o
	H3JAbNdxaRWCu9Sfk1IxrQckknpkeoM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785169569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwLRE88/T88bbZWERmNBLA5mHYgHg0FYmvx8DEB65+s=;
	b=ixQWk19vJRhPbhkajL5ZNMHVNzQTQjQ3BPzO6umHXfkwhwGDg2qk1X374bVkOpZcSS7cHX
	frk6ANZ4tBsncXMwlK3Ar3BvzpYsLsVIPXPYqXIbGmJONsgGi6aQ57I+0LQ19zV0QmzyBM
	gyknjNHi1n+HeCDaHl+YgCGSF01UHOY=
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
Subject: [PATCH v5 1/3] mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
Date: Mon, 27 Jul 2026 09:23:23 -0700
Message-ID: <20260727162550.2032-2-usama.arif@linux.dev>
In-Reply-To: <20260727162550.2032-1-usama.arif@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DD3D74000C
X-Rspam-User: 
X-Stat-Signature: zefjje1x1yszb9tf3hpxabs9c5pb64gz
X-Rspamd-Server: rspam04
X-HE-Tag: 1785169570-610234
X-HE-Meta: U2FsdGVkX18QTVbnb1ctbrpx65c6Q6Banwxdfj0dYIINUOlia3nsr66zisVUfU7c5VZJTzZZWHysnrtbZ0lSTH+TdaU0OLB3vO6u2CGGmwK3ddtSm+BBVn06BDWWw8YGpBGm6Ewxd3O7BymFiwqtG1Y/4OhPv70bKRmsmfJqhQRCx6G9mG2mqMcD4Hhmyx69UnFmKwskf/XLmQhr3a7/1JvtdRlAcpRpeeBv/DJZ4/i+t6Ccr5zrLk8mK9+OxvqVogH4NNMwXdGkBLhoy7WH5AGejeTfNtWflfjNRGXD+J/ewjdrYZnPPJ+pY/ki/LPSealdZQDJnrHs/rPYPy0gQ99GrXwvG5DZzbzGFmNkrfALohb1Dp80/OCHquv1vEHht8uggcMHkYpUVnVkaa7/DLwU3C9Pxd9UxXwybqMFFXcFaKOCmVAQwCwvLgKmx6ynB5dtAAF/bzpEgd3u2006RIohMGchWaHlwob/pP9mCu+UO6eZH6i/hv3uT2H7saxmSXc6BYtAXMTOH3zKTzIkgKeEebeeWlxWjcM0+HMRz71NJlVCAV7PQMQSZZdAOdHLRhE0hPA1dfotu41XJCnoVGbdYCJFwO8P9numwPGh12Tgs4MBoa5hYEQQkpoE7Sz8Tax+3c9pkPRHY8sXFKQtWaqPasaDmXfXJ1Mrjad7onKHP3KXkfCYyooTrQrj1NPYU3Bi9+oIyZtM+A635ETS7D9KShtyvjYJj5WMY75+BScn4IazrBlDBmvp7x3b/Y2iY4PVcmABQe48lHTKowMeZ6iFJGEx0eoW1J1ziO4uucDoh/jrnfshG9yuUS4AJHS9tN6hLVfG7Mqb7wCS4+EG8i4LPUrYgv6K24MB2IgvH14Lq6NyJ8u45PC8Qm1VF2coTW0iv+n9EMP0BKBt86H2VAjmNpA/logon4ChX3N9Vxke2ncb5agGxnvMQrvZvjBKhTrydPbG3tNmq5PCAeh
 iq1qqZbe
 mwJ2DJ2yTsRvPu22voDaqsRgwFMi0zfb+MHM+SAZ/jrjYnWpjBwZ6B0h6wYOwXePpDcrOJfkzGiG6pL2s2ZKYi91fOYnEG/Nn/nCpAj4iAxfshYrUBWjqyOjhb/XonHse+bxRlOlPdhUsU6VGIjCuPuWWBVDP3AIswNf4b9LnTNDS3uGdwO8PpZ7r8t80iFOgFlzQvH0pkHLcNosVMRX3pkPqkcxVmQ1F706qG81mZrzTG+hZys5QwWkeV+gwW9ggYF/eqooet43vvJSaWDyVZCxavLbkVaXJsTbyYOzEWHDlcM6UdzWfTIzEkA==
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

This is a prerequisite for a later patch which
replaces the producer-side anon_cost/file_cost accumulators with a
read-side accumulator in prepare_scan_control() that samples
monotonic per-LRU vmstat counters (PGROTATE_*, NR_VMSCAN_WRITE,
WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
their unsigned modular deltas into lruvec->cost[].count.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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
index 56cd4af08232..de84c399cea2 100644
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
+ * XXX: This helper (and its node/global peers) exists because some
+ * monotonically-incremented event counters are stored in
+ * enum node_stat_item.
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


