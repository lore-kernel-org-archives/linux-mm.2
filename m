Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A8D606A336
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z124371L
Received: by kanga.kvack.org (Postfix)
	id F30B26B05B2; Mon,  2 Nov 2026 01:01:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07FC6B05B3; Mon,  2 Nov 2026 01:01:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DA06B05B4; Mon,  2 Nov 2026 01:01:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B92C26B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:01:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32499C0B9C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:01:27 +0000 (UTC)
X-FDA: 85389131814.06.627638D
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1071F120005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:01:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z124371L;
	spf=pass (imf29.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793599285;
	b=yMboqHU4JaarJrh6J4nn1m4K8UlCZsooRHz0WH57DPVdgc1aNlXKrvjFXKEEZXBysr+Y8d
	qKf7ApOzvldaj0+mTpUXuegrOVVrdmjBCn+UR3k+th3dzB9imCruPciEU4E6/ratOcPGSR
	YUV9r4NDAdaPXRtfKSEfBLn258nUL8A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z124371L;
	spf=pass (imf29.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793599285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zkWB/cOtydtBhPPyDLXOtqau6H5u3XxrtiKgDnaVXk=;
	b=Hj1qda+HnXE1nyJRQ3Tf1nBYP+PJO1nObwfZ4TUVW1A8tNHvUgPcx+pKoNoTEnQPa88ror
	GdzQXPXtQihagl3RAlgFeXsv0RVJF44dYRD9vwO+Wf098DLQaGhzxivroTQ66BcF8tnUoL
	0ludU8PfcLlISI6ZohZY2yepwVd2pqo=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so4967804eec.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 22:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793599284; x=1794204084; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+zkWB/cOtydtBhPPyDLXOtqau6H5u3XxrtiKgDnaVXk=;
        b=Z124371LWr5GK6yxkbPZbxzFMdhVNY383KWFNI6YQICFgNFotUG2WjrlEZ5L2hzWbL
         eAuwPNA/6ghYbEaYu5RpHU30c2/81xZy14h2KEgZt4CaY6SUU7IH3nFRJ0YpW0WGVyai
         jtByf/BrneYfY6QVjOYutRZMwl4MDzdpwmsDke9/4UPFH+pTwcR8HKVOwjg6eZBTTgQi
         4HhuZ8supxVElvzUXWocE2OR/EAIzi///689oimxV0UVtlVyUqzaw6lbbQAbeisDyHSi
         xQmKk/R4YPCH70TDzkT79XKAwgDtVwHvbKO/QG1MXk64xD3sK+LuMoawPVy3Lef50QM2
         pTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793599284; x=1794204084;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+zkWB/cOtydtBhPPyDLXOtqau6H5u3XxrtiKgDnaVXk=;
        b=GAw3d1g8NcHEmLmcTuDUJhE2OEEgHMrAnCuzLBLLLtwSx/o58QvJKyIgj0wtYYeWRW
         Cg/NcrpeC5jBx+2WZ6hzl704Ng7ycv2XxyykBei6mSUZF54q5mPlObIxYQhEx6z88UAW
         9Dn7Z+8zBq6GV0oTZJ3z0SBZOX4VGpQD/cMRa279okmh/LcXJodSyzmJWssknbNxmvuu
         9IP0BEDf8vfzF33AXgpRLSkq0STm3n+cJe6aks58iBkT10qrNq5aHf7ULv2JSMZAGXIm
         itsOwcxDSzS1Wl6EfhCp3LpAkPe7jl2fzBoGrNoBx4N6yCxkKNGVp3nWl8a7fg5AInfy
         1/0A==
X-Gm-Message-State: AFq9FYL28fA12037nbKByTVZshqER0VfM70PxSbHtqTLIGWbMJJJOFqt
	vEcKLI/AbQMwHm6d26qJfJUoZq8AzZiDyHQu3RC8Yb5CvNSYXePpq3EQ
X-Gm-Gg: AYBFou0dGqFFI5dfx6wr4k7tncm++VjiNWmmK31zAc91wirIRm+p3Z5G5l/JKWRcEDO
	fD7fd81/EBRGCWURrVV7Y9fr/VRRE9Ylcx7hxPr7f+kShSiYZ8mY2GSYaDAl0BOO4EVwtdWnuKr
	84PGxhBgPxUIxCx9jTmJIIiXcOR2f0i/x1aWdKywbuSc8EIWSTYcWmfmH2Rwr5iNWKA48jflLOX
	pkbaGzt8ylLYOwSKEko4xBrgaBeMqxxvlP6hhJK0teEZgeJpMrd1dWN8Fd23H3izCcdXn4wwoa5
	lBjxWzIX5skzkpZ+v1UIqg4dNAftcDsczyb796Js4rgR2wISMSCBFPh7Zm6Ta41jUON6WqpOkhC
	/876t5kMaPNTX7dc+L3kxHBHBkbyYa5k6b7zrSONxDeaLhqokMteF3MQj/QOnRBiE2fmfKszc1J
	+3oOzjNQI4EnC1CenpQK2KSrYtoLkjbdYG3DzS3NLNlVY1J/4/y+5Lctmz7VWQNMDDORBcf6Pni
	hkZkZsIH8EHD2umEkCJ0CyyQ/rpYfwlwuD7ZtzWCz6KkJU0mP4zBbsJOFu2xF2IYWjUeo/Pa2A6
	pRVwch1pGwPAiK/89P/xL8/G3nNR55cPmAS06Jv0UP9Zdg==
X-Received: by 2002:a05:7022:eb44:10b0:154:dc96:c1d8 with SMTP id a92af1059eb24-1ac56c9fda4mr14180646c88.2.1793599283639;
        Sun, 01 Nov 2026 22:01:23 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm28755363eec.4.2026.11.01.22.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:01:23 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 02 Nov 2026 01:01:07 -0500
Subject: [PATCH v2 1/2] mm/compaction: keep compaction deferral state per
 migration mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-bug-mm-thp-async-compact-defer-v2-1-b407e974db54@gmail.com>
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
In-Reply-To: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 1071F120005
X-Stat-Signature: dz8rib5uzpnzyxbw538g9otkz4gesqd5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793599284-823070
X-HE-Meta: U2FsdGVkX18xBO4eEfDxtxRZZ3IhNbFi0cdxp4RGMpIu7psUlOT/VQ0aeuJMoFVQiELCoX4z7b51HEXcpaKaPK+e81orI/lYDb1CrayKY6b77NiFR/mJFb49lqtxkRR0DPZr4ysR62pqZaELSBCAF8JgrGB03JbIEHMobQViFk8d9ei1jM6WQstMhljT+qI41E32yTqQvB3ubmTcO64oDl9strZqXCOYofoLn6WjhMhwsh2BhvFBJOpT6RHJ4kMLCchs0aRmllfI8kmiYT7adkbtihyg3M/6/TIk3DmXYl062u0blehILKz/hCdSWPdZuSbVMOav7ETuxgsB9SdEaTEUj5QP8WfNP0TdqofD1KCwFnqRLKucePxtzuoJVhKenCKbuSa9nJIZTIMMarzcby91+bmDjwsSiLA+arS4Md3h34KF9TuiM+kcoSVHLsCV5+RtOZfrMIZrWLHmt2rszIuIm1AT29SkGHhOj4u2czfIjqnrSbw6HrOJFLMSkvIjQR4ppByUjp6WSMel/DbsCIrYeBPSuLaO7j0q2LQvEJAN2b2GvRLarY/guRColMC/LXirii2r3EeaCEC8tut4hI2Mua1wXFl9gRXY/BsdeYKrxfzQ0EFuyUJ0gcuM1DcKEh4K9QQ7Lb12yQ6DLe0lJxjHvlzfcQbVJq2wDwgoTRsj5gsphTqGON318mNJrS9kWSyxVz/ELnz6+Y8nIq8cU/bv9VlxCYSJAsmAq1WIIEns4Yvl9robfbqwSSYmy4TLSMmCPPLHFxUZh83nYbw8tPKnBDcxHMis7o3ZrZWh5wuFtjL3MOBsMUk+RvJOhI3A2aW6Z4tZAQV/j2PkYnt6Z8CySv7IARNvHwLq4+tMLx8mVpNs5G48Ur5XL1EPrqpk/LU1yfncuJGZFFHqkq4MW4CxXOpPfbKu2XnrnqFYI+Vz/qgBhD/z0+HMaizqDe6uU4aCIY0HFG4LWoKIG1x
 CPNNMlq0
 sypqoVQCNekb8fm0jY+eBditegiBmSPWHnvQYexs9ROsN4Y/178hrgh6VcuvpRtp4F5AZj8fkmp5OEJL+ObT5zwCreRYJMXK7dUmFExG0cXtw8If3HXlzbEZ6HX30Ahrrm9wt6nrHyBohPzv3ebj938I/dbIPl0XkRO8QM1+NDSddXwlT6f94yskkM4NC+wFEm7ZSAEwDJD3Onbm24FYynmjVPNEEUFjXMqxzhhaMG49AQOzfV9QiN8krK+HlnXNF3QOLeq/EjmDXwap8+n8r+j0TjXRGkaKl1DWuy2ngkwM8nXumXC97MtWGzm9xMbMNavC4KNiAHXkgtQAKswY2PPSb48zltDvdn/b6jef4XzjPE+bZJZiEgrvloh8BHJe0x7iNiUHgh4Bl0pP2nqLeXu4Dt+Peq18HB/xghAYI2s4l/thfQ6W5K44KvPwl1aEztmTyz5uMdwuNjZXBW/SRTtjiFkP88UkApiplsdRR3UnMY17+92HSPqkiYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A zone keeps one compaction deferral state, compact_considered,
compact_defer_shift and compact_order_failed, for all migration modes.
Only sync compaction failures defer a zone, so a failed async direct
compaction is never deferred.

Deferring async compaction on that shared state would defer sync
compaction along with it, though sync compaction can still succeed on
the pageblocks async compaction skips.

Turn the three fields into arrays indexed by sync, like
compact_cached_migrate_pfn, and pass the mode to the deferral helpers.
All callers use the sync state for now, and a reset clears both. Add a
sync field to the deferral tracepoints, and emit
mm_compaction_defer_reset once for each state a reset clears.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 include/linux/mmzone.h            |  7 +++--
 include/trace/events/compaction.h | 27 +++++++++--------
 mm/compaction.c                   | 62 +++++++++++++++++++++------------------
 3 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756c..73da870fff975 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1150,10 +1150,11 @@ struct zone {
 	 * are skipped before trying again. The number attempted since
 	 * last failure is tracked with compact_considered.
 	 * compact_order_failed is the minimum compaction failed order.
+	 * Indexed by sync, like compact_cached_migrate_pfn.
 	 */
-	unsigned int		compact_considered;
-	unsigned int		compact_defer_shift;
-	int			compact_order_failed;
+	unsigned int		compact_considered[ASYNC_AND_SYNC];
+	unsigned int		compact_defer_shift[ASYNC_AND_SYNC];
+	int			compact_order_failed[ASYNC_AND_SYNC];
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index d05759d185389..23ac6e1750623 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -238,14 +238,15 @@ DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_suitable,
 
 DECLARE_EVENT_CLASS(mm_compaction_defer_template,
 
-	TP_PROTO(struct zone *zone, int order),
+	TP_PROTO(struct zone *zone, int order, bool sync),
 
-	TP_ARGS(zone, order),
+	TP_ARGS(zone, order, sync),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
 		__field(enum zone_type, idx)
 		__field(int, order)
+		__field(bool, sync)
 		__field(unsigned int, considered)
 		__field(unsigned int, defer_shift)
 		__field(int, order_failed)
@@ -255,15 +256,17 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_template,
 		__entry->nid = zone_to_nid(zone);
 		__entry->idx = zone_idx(zone);
 		__entry->order = order;
-		__entry->considered = zone->compact_considered;
-		__entry->defer_shift = zone->compact_defer_shift;
-		__entry->order_failed = zone->compact_order_failed;
+		__entry->sync = sync;
+		__entry->considered = zone->compact_considered[sync];
+		__entry->defer_shift = zone->compact_defer_shift[sync];
+		__entry->order_failed = zone->compact_order_failed[sync];
 	),
 
-	TP_printk("node=%d zone=%-8s order=%d order_failed=%d consider=%u limit=%lu",
+	TP_printk("node=%d zone=%-8s order=%d sync=%d order_failed=%d consider=%u limit=%lu",
 		__entry->nid,
 		__print_symbolic(__entry->idx, ZONE_TYPE),
 		__entry->order,
+		__entry->sync,
 		__entry->order_failed,
 		__entry->considered,
 		1UL << __entry->defer_shift)
@@ -271,23 +274,23 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_template,
 
 DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_deferred,
 
-	TP_PROTO(struct zone *zone, int order),
+	TP_PROTO(struct zone *zone, int order, bool sync),
 
-	TP_ARGS(zone, order)
+	TP_ARGS(zone, order, sync)
 );
 
 DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_defer_compaction,
 
-	TP_PROTO(struct zone *zone, int order),
+	TP_PROTO(struct zone *zone, int order, bool sync),
 
-	TP_ARGS(zone, order)
+	TP_ARGS(zone, order, sync)
 );
 
 DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_defer_reset,
 
-	TP_PROTO(struct zone *zone, int order),
+	TP_PROTO(struct zone *zone, int order, bool sync),
 
-	TP_ARGS(zone, order)
+	TP_ARGS(zone, order, sync)
 );
 
 TRACE_EVENT(mm_compaction_kcompactd_sleep,
diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb2016..e7a450b2be757 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -124,35 +124,35 @@ static unsigned long release_free_list(struct list_head *freepages)
  * allocation success. 1 << compact_defer_shift, compactions are skipped up
  * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
-static void defer_compaction(struct zone *zone, int order)
+static void defer_compaction(struct zone *zone, int order, bool sync)
 {
-	zone->compact_considered = 0;
-	zone->compact_defer_shift++;
+	zone->compact_considered[sync] = 0;
+	zone->compact_defer_shift[sync]++;
 
-	if (order < zone->compact_order_failed)
-		zone->compact_order_failed = order;
+	if (order < zone->compact_order_failed[sync])
+		zone->compact_order_failed[sync] = order;
 
-	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
-		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
+	if (zone->compact_defer_shift[sync] > COMPACT_MAX_DEFER_SHIFT)
+		zone->compact_defer_shift[sync] = COMPACT_MAX_DEFER_SHIFT;
 
-	trace_mm_compaction_defer_compaction(zone, order);
+	trace_mm_compaction_defer_compaction(zone, order, sync);
 }
 
 /* Returns true if compaction should be skipped this time */
-static bool compaction_deferred(struct zone *zone, int order)
+static bool compaction_deferred(struct zone *zone, int order, bool sync)
 {
-	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
+	unsigned long defer_limit = 1UL << zone->compact_defer_shift[sync];
 
-	if (order < zone->compact_order_failed)
+	if (order < zone->compact_order_failed[sync])
 		return false;
 
 	/* Avoid possible overflow */
-	if (++zone->compact_considered >= defer_limit) {
-		zone->compact_considered = defer_limit;
+	if (++zone->compact_considered[sync] >= defer_limit) {
+		zone->compact_considered[sync] = defer_limit;
 		return false;
 	}
 
-	trace_mm_compaction_deferred(zone, order);
+	trace_mm_compaction_deferred(zone, order, sync);
 
 	return true;
 }
@@ -165,24 +165,28 @@ static bool compaction_deferred(struct zone *zone, int order)
 void compaction_defer_reset(struct zone *zone, int order,
 		bool alloc_success)
 {
-	if (alloc_success) {
-		zone->compact_considered = 0;
-		zone->compact_defer_shift = 0;
-	}
-	if (order >= zone->compact_order_failed)
-		zone->compact_order_failed = order + 1;
+	int sync;
+
+	for (sync = 0; sync < ASYNC_AND_SYNC; sync++) {
+		if (alloc_success) {
+			zone->compact_considered[sync] = 0;
+			zone->compact_defer_shift[sync] = 0;
+		}
+		if (order >= zone->compact_order_failed[sync])
+			zone->compact_order_failed[sync] = order + 1;
 
-	trace_mm_compaction_defer_reset(zone, order);
+		trace_mm_compaction_defer_reset(zone, order, sync);
+	}
 }
 
-/* Returns true if restarting compaction after many failures */
+/* Return true if restarting sync compaction after many failures */
 static bool compaction_restarting(struct zone *zone, int order)
 {
-	if (order < zone->compact_order_failed)
+	if (order < zone->compact_order_failed[true])
 		return false;
 
-	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
-		zone->compact_considered >= 1UL << zone->compact_defer_shift;
+	return zone->compact_defer_shift[true] == COMPACT_MAX_DEFER_SHIFT &&
+		zone->compact_considered[true] >= 1UL << zone->compact_defer_shift[true];
 }
 
 /* Returns true if the pageblock should be scanned for pages to isolate. */
@@ -2855,7 +2859,7 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 				continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
-					&& compaction_deferred(zone, order)) {
+					&& compaction_deferred(zone, order, true)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
 		}
@@ -2893,7 +2897,7 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			 * so we defer compaction there. If it ends up
 			 * succeeding after all, it will be reset.
 			 */
-			defer_compaction(zone, order);
+			defer_compaction(zone, order, true);
 
 		/*
 		 * We might have stopped compacting due to need_resched() in
@@ -3111,7 +3115,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 		if (!populated_zone(zone))
 			continue;
 
-		if (compaction_deferred(zone, cc.order))
+		if (compaction_deferred(zone, cc.order, true))
 			continue;
 
 		ret = compaction_suit_allocation_order(zone,
@@ -3141,7 +3145,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 			 * We use sync migration mode here, so we defer like
 			 * sync direct compaction does.
 			 */
-			defer_compaction(zone, cc.order);
+			defer_compaction(zone, cc.order, true);
 		}
 
 		count_compact_events(KCOMPACTD_MIGRATE_SCANNED,

-- 
2.43.0


