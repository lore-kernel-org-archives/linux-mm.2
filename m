Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410ECC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5602F6B012D; Mon, 13 Jul 2026 12:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5379A6B0130; Mon, 13 Jul 2026 12:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44DCC6B0132; Mon, 13 Jul 2026 12:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4BF6B012D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72ADA401F5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:34:57 +0000 (UTC)
X-FDA: 84984302634.25.91EFE61
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id B8CCC1C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:34:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GZZhPMMG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960495;
	b=bW7QRKrat2DKwArSmqZtrDmlhwQaMDTtp0Zw1GXc/MjpCHzsFpv52IdAmBIGnWCkIWF/E8
	bwDOjiEvebsD+TYDIggsXGINqHk3iVUY+vorsZYpinnNBSOknTpinu5YTwWG7ZS0KDx+hU
	3JBXCHxIn9M6CabESTxxbyJkPpGY/g0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GZZhPMMG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQqWDk7T6a/RKrLzEIPkgohpPGLwCcrs/s+nPh+3mLg=;
	b=ny4CTn3ilTxpulKZel3Ij4NfFJVXluLT+vb1Wy5Cg8KaJia+ev/Nt4GFV6Utaq7DGZiWVS
	Zdhr8whLJI8ajwed1my5f7ckVvoL+QgMGBRzIwd+O0xS4Hzb+CCuyoF6F9H02LMUdd3t1h
	dbu/B7oCiIX02o1iRxhCg/PmX5Q3pZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783960494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQqWDk7T6a/RKrLzEIPkgohpPGLwCcrs/s+nPh+3mLg=;
	b=GZZhPMMG+PoZWuQyTJm1Ciu9Wp1K7Yf1opm9huRmJYIAv9HpvrJmcAkhxcmAjRVWmwIr68
	CayjRenm0iCU2tW5cfpXtQkz+v1Eg/tuU1QDCYv1eqlqrCDDhp9CAV4K9KbnCkIEy3qoej
	gEt+6pC583S0cEvnjNUnSJCfrA2f6O4=
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
Subject: [PATCH v2 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
Date: Mon, 13 Jul 2026 09:34:16 -0700
Message-ID: <20260713163443.3562378-2-usama.arif@linux.dev>
In-Reply-To: <20260713163443.3562378-1-usama.arif@linux.dev>
References: <20260713163443.3562378-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B8CCC1C0002
X-Rspam-User: 
X-Stat-Signature: 9h5te9y7k16ie98fknf7j9tuugqb69zy
X-Rspamd-Server: rspam03
X-HE-Tag: 1783960495-910960
X-HE-Meta: U2FsdGVkX1+OQEnYnhl7wQLSzNJgTUp6MgHpt17Y5eZ7orwYPptnJKctXfgpEo/H03FY8KQy9D6kZlGcoCOldeDlScItlFUp/BGyPPUnvBilyEGgRYW7D1nVCs6Ed2DDwSbWw7K6DrOTkxBr0MEHrWa4rLFxEFqVuUmb6NNsqNwOIpCfQQJBFFnzgsY5d3SAa+VhI3A2PBDkLDKc4Xgykzpm5y7NsZWNzkdt5T4a2DOfceIUlq0pPzJcGD9B3q/YNiFMDy5wpPe4B/4A/90hRsHkOhAhj+peeyIwpLfQFBtFxDu0LPdAAoDsL0suORtKJN2hnAr867ihiZore2a/YPsYSUOXrx0aTlRQlwXUVYG0Bg547IeANRGfPutRRDLaFAwkZvnWRHV/DkJO2uIpVQ8saqzHSewQF7eXJNXmrQJh6CXkoydBR+S5YDIjhR1urqzeOuMcqt+vScRsOLFVQVNuBnmF89a8wZnrZNkl04Zca/g0ozZoytcHK5ePHDmK7k46mS6gkIAfRMJ8Hipd2oFDVd/g0Gb74ziCe8kycS2zJgR5DmB30BhvNZ+XG7i5iQgNM8Eq7KT9UAaKl+wpDI0GI+13uccxqPwmyb/cpRqhWmy9BHiryFHGh4reTjFRJkYz9oeiq/dDIl8Lf2QmbGEXU3WSm94lm0M9jmi6Fne1MJFL6EYIYJn1o80eBwhPlvHLo49Ao7LDiJ/1nfIWRgB0ARuRepjtP85rtrPT7hEpi/ZXphdd4vOWV/d2ZTUbuz3E44tE6hDMnoIkw8jWVR6WAuCh2qkNSpVElC+31dxQSzsJaXk2RXnYoErim8r4g7a6h1mSknjPi1x0UGMz5RveA7v3co+R1+mRR0iY1mshP8vjPSG+rgDWK+ZyRrao6ZRRV7NEIPLg9NwoRSn2yJArmZIhoyjJxKdbfRHbR6hpnlsBSulx7CKXXLSit14IZyANB+anmTJbFEZb+no
 6WCJlZY7
 jnbHF3tcCgT0Y47QykseptK8KolnV8nfoB4HmQHTFaGuyVPeeT/+KCM5AOgvhplripkGnRWLyUN3nMHk1ufwGLnH8AXo3cnRmgwS7WZNeBoDe5E8+y7EjYhZnras+Q4WlaNkSXFDDeuC7v45eaItbdGIWAd4a7zCBCEs34ds+Vtp+DGYewtjxSNT8yWe/k/lrzl+E+eDJyZ4nVrAK+8kZbgCTkqMxh1AqLSM37aanBCL5dCBVdLCxMf0fmg==
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


