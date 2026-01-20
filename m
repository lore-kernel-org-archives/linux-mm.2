Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0638D2629C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 20:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027EA6B0005; Tue, 20 Jan 2026 15:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17196B0088; Tue, 20 Jan 2026 15:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22F76B0089; Tue, 20 Jan 2026 15:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4A446B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:30:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D44A14073F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:30:37 +0000 (UTC)
X-FDA: 84353485314.05.16FFE61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B09411C0014
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:30:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vXDZ5y5a;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768941035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO/WfFZNeNHn1GuyUKxXT/nRtMSqIdMWRVExovtJpsg=;
	b=Og9XjOpb8K3aOh7IlghhfP1bExjgYFLTcfoISyzWkmlwZwC7bbMspxtSPpYI5/gDqzUd4B
	D1r8BTvWE3XW475u7MbyCAj9v5hMVyNlV1Xe5m1j4fACpNNY10K39U0kEGQATJULCdO24/
	cuM1Spga/uWfU9OHU1Y7mhq0zvGkNOg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vXDZ5y5a;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768941035; a=rsa-sha256;
	cv=none;
	b=Fvgwh3SiuGRB+olMaY9VsNnfwhMHV/OdI9+kEw0sOBfUVa33CjDicGYPp5XTcBa/NGTGnk
	NjiY3hOeGsKO4w5Mb5RCQjw24z9/l2z+Fh0tEkL0u878Il7N1F7knXzY8XPeetS+cgFTHl
	izabvLfKMQlgucVLLk4oQmbJXzpj9dU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 971556001A;
	Tue, 20 Jan 2026 20:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C42AC16AAE;
	Tue, 20 Jan 2026 20:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768941034;
	bh=gQqT6mFfMSf2uJPK6Qy5o07DzG64JdRhARiJi+q6Ngs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vXDZ5y5aVLeXC2R4rIUZdrkYjLUf5R/CiCq8HTi/ZdjcIbrSKGXrQbdGhPflSixiE
	 DkuRq02KU+hX8OS9UL5rhBuTl5+X0OG6+HlqnhHWrPYfHxCAGYYw6onUZpiK+FETx9
	 4C8YH0/Vy7mfu8scc/+ee6cRqdujTEVaxj9Af3jk=
Date: Tue, 20 Jan 2026 12:30:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Jiayuan Chen <jiayuan.chen@shopee.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mm/vmscan: mitigate spurious kswapd_failures
 reset and add tracepoints
Message-Id: <20260120123033.b2f0dec292fba02d5c8aafab@linux-foundation.org>
In-Reply-To: <20260120024402.387576-1-jiayuan.chen@linux.dev>
References: <20260120024402.387576-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B09411C0014
X-Stat-Signature: 5tuk8gmencqrxuun46qgrw41841dsubi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768941035-659852
X-HE-Meta: U2FsdGVkX1+a9Y02P1qoaNjanirWBJHNEtxxZwtaXVLtjIaOaObqkZdSEKzlJyh3a1Vp7LY9cEOsQFBUKYkpdrQ9sJ7XZRz/Fhnmwds7lpLMQjCMU6M/N8ihD6M+WvRF/0s4XQpUdpx5jeIBw5o5mIzZLZzt6+FpG5WDzOfEfRBFX7gadWV44fOsMwsSD1gQ1HdVTfer0bWVi1M3txTS3zNjWUNW5VaihGoIdNT1RqHVnFmg6dc+nQwbZ+Jy4nRIy98Ntb45pWuH9MSp9mW5PfqFdr5kFKqRGyztiN9PG7CbivJ664uXjMQD5iThW0DfyR2ZrMPvHb6ZtXX2G7gRozfXw8LQD8KuO2X0RgYiBvuAvbyl9ccd8mSmWKnQx33hSj4QqiLWROww0itrrfCtIdmDNKOs+HLKm/yxrjiaz2zxvc5bVN79WL0QtkZbOCSBwFYOUwUP6gKLwDpDi/pTlywQCrQ/2UqesRAcdYSYV24zIVzAykFW2S3ZoLU4/CkV9XPJ4iLc6ZaGZXtzKdyAtyvcAebhU6v6vVhLVLtTM9/+leR5nj0lLbuJ1o2TpNZjAXTUdOBfUjSF/XrvFOsMcofuUy0PR0/TWWLT6Y2MV5VLFvXASMfPXo9LfiTWDu23dbmU3aMFbMf5TBEhtF5HV+uLYDMYykc4mXPhH1ShVdAiYlppzssZFUmJJEEEvzEZEz4llUo1yYtEBKebYjGeRxMRmXSHyt/25vFZ0KL9TotHTf0C5Yq1eoPCLc5jgATiMTlkSauX2KeMGaWcevu+qjmGVJ/Y2GcrpMt4lYFqMVPTHFItX39Y+Xm+0QHUKHqZYQ2AHj8jBfanN37TvWZSShQR4rdo3wpGmRCwFklRdXTFr1M6hnjT2fAzz7w6Nggy8JIkjb142lPgb20ji3BqDuyKk0G4ezasPCEQUhi/SCJNIdnYsm736Nqikd8HxbGiZTn0C3M2uxAmS30PNQM
 zXMvW/hc
 jcE5303LDK57/YAr+StytThr2ZExhS7o6d6r6h1N5zESfZoFnv9H8wJiet4bLV/zaD79CrH3yhF8IW+r9sqHYAzr1uMPONpQqw8cibBettQlT99vAynOz0/P6Q6PMiq3sAIkS/DWF04Sp/cijRX2gEGdtuGPFkGpdEEZV/bswhz9cPOQfJX6J2Q1phGC3hMtA0qbEDrvwFovZ+zsD2NHs/eiWSpVthw8ipzXEYnrQl9ltRWbCIus+/1wznTkO98rnp1Sm4JdqLIWuyCPZS2OEbQ3OFZh6bTh3TTAOoJ7Frusyb9o2XEtVZ3ixMtbSXkJDa3Pu69vKKBjEEYkY0iE08IyvLEf11W4CH5v6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 10:43:47 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> == Problem ==
> 
> We observed an issue in production on a multi-NUMA system where kswapd
> runs endlessly, causing sustained heavy IO READ pressure across the
> entire system.
> 
> The root cause is that direct reclaim triggered by cgroup memory.high
> keeps resetting kswapd_failures to 0, even when the node cannot be
> balanced. This prevents kswapd from ever stopping after reaching
> MAX_RECLAIM_RETRIES.
> 

Updated, thanks.

> v3 -> v4: https://lore.kernel.org/linux-mm/20260114074049.229935-1-jiayuan.chen@linux.dev/
>   - Add Acked-by tags
>   - Some modifications suggested by Johannes Weiner 

Here's how v4 altered mm.git:


 include/linux/mmzone.h        |   26 ++++++++-----
 include/trace/events/vmscan.h |   24 ++++++------
 mm/memory-tiers.c             |    2 -
 mm/page_alloc.c               |    4 +-
 mm/show_mem.c                 |    3 -
 mm/vmscan.c                   |   60 +++++++++++++++++---------------
 mm/vmstat.c                   |    2 -
 7 files changed, 64 insertions(+), 57 deletions(-)

--- a/include/linux/mmzone.h~b
+++ a/include/linux/mmzone.h
@@ -1531,26 +1531,30 @@ static inline unsigned long pgdat_end_pf
 	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
 }
 
-enum reset_kswapd_failures_reason {
-	RESET_KSWAPD_FAILURES_OTHER = 0,
-	RESET_KSWAPD_FAILURES_KSWAPD,
-	RESET_KSWAPD_FAILURES_DIRECT,
-	RESET_KSWAPD_FAILURES_PCP,
-};
-
-void pgdat_reset_kswapd_failures(pg_data_t *pgdat, enum reset_kswapd_failures_reason reason);
-
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
-void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
-		   enum zone_type highest_zoneidx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages);
 bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx,
 		unsigned int alloc_flags);
+
+enum kswapd_clear_hopeless_reason {
+	KSWAPD_CLEAR_HOPELESS_OTHER = 0,
+	KSWAPD_CLEAR_HOPELESS_KSWAPD,
+	KSWAPD_CLEAR_HOPELESS_DIRECT,
+	KSWAPD_CLEAR_HOPELESS_PCP,
+};
+
+void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
+		   enum zone_type highest_zoneidx);
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx);
+void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason);
+bool kswapd_test_hopeless(pg_data_t *pgdat);
+
 /*
  * Memory initialization context, use to differentiate memory added by
  * the platform statically or via memory hotplug interface.
--- a/include/trace/events/vmscan.h~b
+++ a/include/trace/events/vmscan.h
@@ -40,16 +40,16 @@
 		{_VMSCAN_THROTTLE_CONGESTED,	"VMSCAN_THROTTLE_CONGESTED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
-TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_OTHER);
-TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_KSWAPD);
-TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_DIRECT);
-TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_PCP);
-
-#define reset_kswapd_src				\
-	{RESET_KSWAPD_FAILURES_KSWAPD,	"KSWAPD"},	\
-	{RESET_KSWAPD_FAILURES_DIRECT,	"DIRECT"},	\
-	{RESET_KSWAPD_FAILURES_PCP,	"PCP"},		\
-	{RESET_KSWAPD_FAILURES_OTHER,	"OTHER"}
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_OTHER);
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_KSWAPD);
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_DIRECT);
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_PCP);
+
+#define kswapd_clear_hopeless_reason_ops		\
+	{KSWAPD_CLEAR_HOPELESS_KSWAPD,	"KSWAPD"},	\
+	{KSWAPD_CLEAR_HOPELESS_DIRECT,	"DIRECT"},	\
+	{KSWAPD_CLEAR_HOPELESS_PCP,	"PCP"},		\
+	{KSWAPD_CLEAR_HOPELESS_OTHER,	"OTHER"}
 
 #define trace_reclaim_flags(file) ( \
 	(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
@@ -566,7 +566,7 @@ TRACE_EVENT(mm_vmscan_kswapd_reclaim_fai
 		__entry->nid, __entry->failures)
 );
 
-TRACE_EVENT(mm_vmscan_reset_kswapd_failures,
+TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 
 	TP_PROTO(int nid, int reason),
 
@@ -584,7 +584,7 @@ TRACE_EVENT(mm_vmscan_reset_kswapd_failu
 
 	TP_printk("nid=%d reason=%s",
 		__entry->nid,
-		__print_symbolic(__entry->reason, reset_kswapd_src))
+		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
 );
 #endif /* _TRACE_VMSCAN_H */
 
--- a/mm/memory-tiers.c~b
+++ a/mm/memory-tiers.c
@@ -955,7 +955,7 @@ static ssize_t demotion_enabled_store(st
 		struct pglist_data *pgdat;
 
 		for_each_online_pgdat(pgdat)
-			pgdat_reset_kswapd_failures(pgdat, RESET_KSWAPD_FAILURES_OTHER);
+			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_OTHER);
 	}
 
 	return count;
--- a/mm/page_alloc.c~b
+++ a/mm/page_alloc.c
@@ -2945,9 +2945,9 @@ static bool free_frozen_page_commit(stru
 		 * 'hopeless node' to stay in that state for a while.  Let
 		 * kswapd work again by resetting kswapd_failures.
 		 */
-		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		if (kswapd_test_hopeless(pgdat) &&
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-			pgdat_reset_kswapd_failures(pgdat, RESET_KSWAPD_FAILURES_PCP);
+			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
 }
--- a/mm/show_mem.c~b
+++ a/mm/show_mem.c
@@ -278,8 +278,7 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
-				   MAX_RECLAIM_RETRIES),
+			str_yes_no(kswapd_test_hopeless(pgdat)),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -506,7 +506,7 @@ static bool skip_throttle_noprogress(pg_
 	 * If kswapd is disabled, reschedule if necessary but do not
 	 * throttle as the system is likely near OOM.
 	 */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	/*
@@ -2647,28 +2647,6 @@ static bool can_age_anon_pages(struct lr
 			  lruvec_memcg(lruvec));
 }
 
-void pgdat_reset_kswapd_failures(pg_data_t *pgdat, enum reset_kswapd_failures_reason reason)
-{
-	/* Only trace actual resets, not redundant zero-to-zero */
-	if (atomic_xchg(&pgdat->kswapd_failures, 0))
-		trace_mm_vmscan_reset_kswapd_failures(pgdat->node_id, reason);
-}
-
-/*
- * Reset kswapd_failures only when the node is balanced. Without this
- * check, successful direct reclaim (e.g., from cgroup memory.high
- * throttling) can keep resetting kswapd_failures even when the node
- * cannot be balanced, causing kswapd to run endlessly.
- */
-static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx);
-static inline void pgdat_try_reset_kswapd_failures(struct pglist_data *pgdat,
-						   struct scan_control *sc)
-{
-	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
-		pgdat_reset_kswapd_failures(pgdat, current_is_kswapd() ?
-			RESET_KSWAPD_FAILURES_KSWAPD : RESET_KSWAPD_FAILURES_DIRECT);
-}
-
 #ifdef CONFIG_LRU_GEN
 
 #ifdef CONFIG_LRU_GEN_ENABLED
@@ -5086,7 +5064,7 @@ static void lru_gen_shrink_node(struct p
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		pgdat_try_reset_kswapd_failures(pgdat, sc);
+		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
 }
 
 /******************************************************************************
@@ -6153,7 +6131,7 @@ again:
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		pgdat_try_reset_kswapd_failures(pgdat, sc);
+		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -6458,7 +6436,7 @@ static bool allow_direct_reclaim(pg_data
 	int i;
 	bool wmark_ok;
 
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
@@ -6867,7 +6845,7 @@ static bool prepare_kswapd_sleep(pg_data
 		wake_up_all(&pgdat->pfmemalloc_wait);
 
 	/* Hopeless node, leave it to direct reclaim */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	if (pgdat_balanced(pgdat, order, highest_zoneidx)) {
@@ -7395,7 +7373,7 @@ void wakeup_kswapd(struct zone *zone, gf
 		return;
 
 	/* Hopeless node, leave it to direct reclaim if possible */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES ||
+	if (kswapd_test_hopeless(pgdat) ||
 	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
 	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
 		/*
@@ -7415,6 +7393,32 @@ void wakeup_kswapd(struct zone *zone, gf
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
+void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason)
+{
+	/* Only trace actual resets, not redundant zero-to-zero */
+	if (atomic_xchg(&pgdat->kswapd_failures, 0))
+		trace_mm_vmscan_kswapd_clear_hopeless(pgdat->node_id, reason);
+}
+
+/*
+ * Reset kswapd_failures only when the node is balanced. Without this
+ * check, successful direct reclaim (e.g., from cgroup memory.high
+ * throttling) can keep resetting kswapd_failures even when the node
+ * cannot be balanced, causing kswapd to run endlessly.
+ */
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx)
+{
+	if (pgdat_balanced(pgdat, order, highest_zoneidx))
+		kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
+			KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);
+}
+
+bool kswapd_test_hopeless(pg_data_t *pgdat)
+{
+	return atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES;
+}
+
 #ifdef CONFIG_HIBERNATION
 /*
  * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
--- a/mm/vmstat.c~b
+++ a/mm/vmstat.c
@@ -1840,7 +1840,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  start_pfn:           %lu"
 		   "\n  reserved_highatomic: %lu"
 		   "\n  free_highatomic:     %lu",
-		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
+		   kswapd_test_hopeless(pgdat),
 		   zone->zone_start_pfn,
 		   zone->nr_reserved_highatomic,
 		   zone->nr_free_highatomic);
_


