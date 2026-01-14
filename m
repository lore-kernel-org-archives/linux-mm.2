Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D7DD31A1E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA996B008C; Wed, 14 Jan 2026 02:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282C86B0092; Wed, 14 Jan 2026 02:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1821D6B0093; Wed, 14 Jan 2026 02:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 078486B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:41:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B48271BA12
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:31 +0000 (UTC)
X-FDA: 84329774382.29.214B375
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8355180004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EwIKnBY0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768376490; a=rsa-sha256;
	cv=none;
	b=Rlv5p9lA5gqbXCjOMJ2yOCa1/CCWPV2Rh55VRaPz+Dh5sI0II0R459Bz1BjIKCQA+xHBtk
	WSxT6u8pe/lO3WODCFk32fl7Ot/LOjHzs0MueCFYB1pvRHGjob9J/nQBdO/FW+B/j7JUls
	OGNCpEN2OTTLPqoy4Ct7KEySTXG5nIA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EwIKnBY0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768376490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8x3YqP9ZG6FyL2JK7Cc+pkWrJriDPOZs61tUnMuCISM=;
	b=SULdnDAnx9IchAzZSYAz7EcPJqRY6ECg0rRnzqXedzhmZKala0idajgEVBlWMENhcrgba1
	KIEj/e54z/RnWZKOssDaOri3fszfbMNOLetlzGoPsaZEP51gkr+zUSZwHICwJ3s5E8dAAZ
	48ukrVsoiMpjjRDBW72X0lQWkuPQFJA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768376488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8x3YqP9ZG6FyL2JK7Cc+pkWrJriDPOZs61tUnMuCISM=;
	b=EwIKnBY0ptJt79ezcxQtB+XpWywMpIAhrAHe/965yMbyYfj/AB6iOJvD0YLPcAWnpaGVYn
	l66Gxdy+0N1R+XFSDbjz5JWdK7Ki2JexfGflIoyCyuwprwpCp0UCIqd4CR/GmwGRvOVK1e
	M+iUSM9aWzMnwm043wnCZkMuRFMmgf0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org,
	shakeel.butt@linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] mm/vmscan: add tracepoint and reason for kswapd_failures reset
Date: Wed, 14 Jan 2026 15:40:36 +0800
Message-ID: <20260114074049.229935-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260114074049.229935-1-jiayuan.chen@linux.dev>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C8355180004
X-Rspamd-Server: rspam06
X-Stat-Signature: knzsug87h1841oy4buz5qm1asfxzt7dq
X-Rspam-User: 
X-HE-Tag: 1768376489-637069
X-HE-Meta: U2FsdGVkX19BJa4OiAE1KLyzqSpLu0lkRi3/Rp/1vRtVmGhIeo0dihYaUOH4rOW4+FMgU65WiD+O5u/rnuA/h9lFiUyfbsC9dX4DV+9xsSLbhX7s9yVSbf0wHME321PCbxwplvs0rdSW2z8CzRBh29kjWe1J/n984mrXmf+mCC03xPxB51Lbe0Hd72USUz5pI6ymUUg6IoiWDirZWcrC2hcSlNw0ZNAyOyCkX+Wbyf3GHRulEq5DyTIycuJmOVIihJfUN0AP58qTYYALS80388bzZHb7qmSB+fb8Wj9wlwSDiFGq+hI/N+tDDmyPNVutiub8f3ro/Ey6M4rYsFW0FeTiOsubyBPsQs6a5ch9YKZeLHN5FVgnC23s5ZBXEDdAHpMX2xHLC2P3jfdLZi+twRs7q5G71wMfy5AnuPhw0i6LMKCoShrdDf/03zGkXTtKduMICFNAYfLDlTh64f2igS1+Ax4jC8FgMvs2NUONd1UbNl44db7VzZ7wmZU9WPnKXYT7RYtnXh1ZjL66BeToJfi3H7t9Je8RSPKQkOlC3NSMWUl3AEG5u/U+F+qQbbvCzQAtvqy2vqjkTuqRLGC+W5qfOQp+vW4NCvycOKj2zgejJkqHn3iiGu0o293Klr4GWzCsd4E/PcLlkZYh6pt8tHzIqDR4ACpICUImKF2I0lmB/MJm5b9kYdg+gPVvD7LNVfFVfyPCFmaIGzOKQoRXbbpAu+74ytLOwF477DuHWuJf19UA/aNjg7Yov6K6+X3ioU8ZybEzWt8hunMj/sGoASeENh33EjlZh+Y6+4S0u6ziLOcatlRRka4IGP/FQE3249TYRYlQIe+8MlTSHtd4NT0xXxH1VmidnUiN8atwxw+o0sppMHqhQhsbL84JfBMDSZUAQi6deG2DzLwEgyWY5+xg8fL7MNVrVyP6ZhIPpihpGEDWy2SGZbEqA2VNlDaioiQniA3a+MErj4N7Jz4
 G6HfRygo
 PJdztq4SzKz70Ef8s3YP+QaroPbEeDxRFHnJMoAB/M1aCEFiJlOJ5Wq6/sM6Vg51Gx6H10a1556mtI9Stb1WK9VcRjNSuW2DgFhLaTRJnGj/PTaM1fiqLGcUA10fBfSlSJwLxl2YJa/TJxGSMa7KtDdWkWiOokaq3bVSpAtDTA9FEUuPO6TzW3RhdYzobUkbBRhgECyBmxYYIDtTivR/IcBFjhDt95jHddePZvfTERgLSLevUzRlKCqR6CFneXJ/um4jlABHd38qwpkcQlS47PD24HbODUgnmfR87Mbs0YGdaMw+lNShnGS3f/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Currently, kswapd_failures is reset in multiple places (kswapd,
direct reclaim, PCP freeing, memory-tiers), but there's no way to
trace when and why it was reset, making it difficult to debug
memory reclaim issues.

This patch:

1. Introduce pgdat_reset_kswapd_failures() as a wrapper function to
   centralize kswapd_failures reset logic.

2. Add reset_kswapd_failures_reason enum to distinguish reset sources:
   - RESET_KSWAPD_FAILURES_KSWAPD: reset from kswapd context
   - RESET_KSWAPD_FAILURES_DIRECT: reset from direct reclaim
   - RESET_KSWAPD_FAILURES_PCP: reset from PCP page freeing
   - RESET_KSWAPD_FAILURES_OTHER: reset from other paths

3. Add tracepoints for better observability:
   - mm_vmscan_reset_kswapd_failures: traces each reset with reason
   - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure

---
Test results:

$ trace-cmd record -e vmscan:mm_vmscan_reset_kswapd_failures -e vmscan:mm_vmscan_kswapd_reclaim_fail
$ # generate memory pressure
$ trace-cmd report
cpus=4
kswapd1-73  [002]  24.863112: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=1
kswapd1-73  [002]  24.863472: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=2
kswapd1-73  [002]  24.863813: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=3
kswapd1-73  [002]  24.864141: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=4
kswapd1-73  [002]  24.864462: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=5
kswapd1-73  [002]  24.864779: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=6
kswapd1-73  [002]  24.865103: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=7
kswapd1-73  [002]  24.865421: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=8
kswapd1-73  [002]  24.865737: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=9
kswapd1-73  [002]  24.866070: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=10
kswapd1-73  [002]  24.866385: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=11
kswapd1-73  [002]  24.866701: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=12
kswapd1-73  [002]  24.867016: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=13
kswapd1-73  [002]  24.867333: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=14
kswapd1-73  [002]  24.867649: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=15
kswapd1-73  [002]  24.867965: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=16
kswapd0-72  [001]  25.020464: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
kswapd0-72  [001]  25.021054: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
kswapd0-72  [001]  25.021628: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
kswapd0-72  [001]  25.022217: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
kswapd0-72  [001]  25.022790: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
kswapd0-72  [001]  25.023366: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
kswapd0-72  [001]  25.023937: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
kswapd0-72  [001]  25.024511: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
kswapd0-72  [001]  25.025092: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
kswapd0-72  [001]  25.025665: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
kswapd0-72  [001]  25.026249: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
kswapd0-72  [001]  25.026824: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
kswapd0-72  [001]  25.027398: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
kswapd0-72  [001]  25.027976: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
kswapd0-72  [001]  25.028554: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
kswapd0-72  [001]  25.029140: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
ann-416     [002]  25.577925: mm_vmscan_reset_kswapd_failures: nid=0 reason=PCP
dd-417      [002]  35.111721: mm_vmscan_reset_kswapd_failures: nid=1 reason=DIRECT

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/linux/mmzone.h        |  9 +++++++
 include/trace/events/vmscan.h | 51 +++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c             |  2 +-
 mm/page_alloc.c               |  2 +-
 mm/vmscan.c                   | 16 +++++++----
 5 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..3f4d2928d8dc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1531,6 +1531,15 @@ static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
 	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
 }
 
+enum reset_kswapd_failures_reason {
+	RESET_KSWAPD_FAILURES_OTHER = 0,
+	RESET_KSWAPD_FAILURES_KSWAPD,
+	RESET_KSWAPD_FAILURES_DIRECT,
+	RESET_KSWAPD_FAILURES_PCP,
+};
+
+void pgdat_reset_kswapd_failures(pg_data_t *pgdat, enum reset_kswapd_failures_reason reason);
+
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 490958fa10de..0747ad2f7932 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -40,6 +40,16 @@
 		{_VMSCAN_THROTTLE_CONGESTED,	"VMSCAN_THROTTLE_CONGESTED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_OTHER);
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_KSWAPD);
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_DIRECT);
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_PCP);
+
+#define reset_kswapd_src				\
+	{RESET_KSWAPD_FAILURES_KSWAPD,	"KSWAPD"},	\
+	{RESET_KSWAPD_FAILURES_DIRECT,	"DIRECT"},	\
+	{RESET_KSWAPD_FAILURES_PCP,	"PCP"},		\
+	{RESET_KSWAPD_FAILURES_OTHER,	"OTHER"}
 
 #define trace_reclaim_flags(file) ( \
 	(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
@@ -535,6 +545,47 @@ TRACE_EVENT(mm_vmscan_throttled,
 		__entry->usec_delayed,
 		show_throttle_flags(__entry->reason))
 );
+
+TRACE_EVENT(mm_vmscan_kswapd_reclaim_fail,
+
+	TP_PROTO(int nid, int failures),
+
+	TP_ARGS(nid, failures),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, failures)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->failures = failures;
+	),
+
+	TP_printk("nid=%d failures=%d",
+		__entry->nid, __entry->failures)
+);
+
+TRACE_EVENT(mm_vmscan_reset_kswapd_failures,
+
+	TP_PROTO(int nid, int reason),
+
+	TP_ARGS(nid, reason),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, reason)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->reason = reason;
+	),
+
+	TP_printk("nid=%d reason=%s",
+		__entry->nid,
+		__print_symbolic(__entry->reason, reset_kswapd_src))
+);
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..8188f341bd77 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -956,7 +956,7 @@ static ssize_t demotion_enabled_store(struct kobject *kobj,
 		struct pglist_data *pgdat;
 
 		for_each_online_pgdat(pgdat)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			pgdat_reset_kswapd_failures(pgdat, RESET_KSWAPD_FAILURES_OTHER);
 	}
 
 	return count;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..cadf2c8b06a5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2918,7 +2918,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 */
 		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			pgdat_reset_kswapd_failures(pgdat, RESET_KSWAPD_FAILURES_PCP);
 	}
 	return ret;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6fd100130987..8d9f3d29fe3b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2650,9 +2650,11 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			  lruvec_memcg(lruvec));
 }
 
-static void pgdat_reset_kswapd_failures(pg_data_t *pgdat)
+void pgdat_reset_kswapd_failures(pg_data_t *pgdat, enum reset_kswapd_failures_reason reason)
 {
-	atomic_set(&pgdat->kswapd_failures, 0);
+	/* Only trace actual resets, not redundant zero-to-zero */
+	if (atomic_xchg(&pgdat->kswapd_failures, 0))
+		trace_mm_vmscan_reset_kswapd_failures(pgdat->node_id, reason);
 }
 
 /*
@@ -2666,7 +2668,8 @@ static inline void pgdat_try_reset_kswapd_failures(struct pglist_data *pgdat,
 						   struct scan_control *sc)
 {
 	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
-		pgdat_reset_kswapd_failures(pgdat);
+		pgdat_reset_kswapd_failures(pgdat, current_is_kswapd() ?
+			RESET_KSWAPD_FAILURES_KSWAPD : RESET_KSWAPD_FAILURES_DIRECT);
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -7153,8 +7156,11 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	 * watermark_high at this point. We need to avoid increasing the
 	 * failure count to prevent the kswapd thread from stopping.
 	 */
-	if (!sc.nr_reclaimed && !boosted)
-		atomic_inc(&pgdat->kswapd_failures);
+	if (!sc.nr_reclaimed && !boosted) {
+		int fail_cnt = atomic_inc_return(&pgdat->kswapd_failures);
+		/* kswapd context, low overhead to trace every failure */
+		trace_mm_vmscan_kswapd_reclaim_fail(pgdat->node_id, fail_cnt);
+	}
 
 out:
 	clear_reclaim_active(pgdat, highest_zoneidx);
-- 
2.43.0


