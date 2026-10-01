Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D9C5CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339AB6B008A; Thu,  1 Oct 2026 11:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311256B008C; Thu,  1 Oct 2026 11:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2271F6B0092; Thu,  1 Oct 2026 11:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED2876B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:34:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A69EA03E7
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:34:12 +0000 (UTC)
X-FDA: 85274453544.04.736906D
Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7D5D18000F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:34:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BdVitacX;
	spf=pass (imf24.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790868850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQILXCbNTg3uilRJywVvrlkBNpYRNdVSU/c2Q3udK90=;
	b=oqxc0h7bQARWDKG3YSQpuXYFoXDJEGfWd07eRY7+Au5QeR8pQ7rktvboVwjjVOqBIBF+RG
	IwW8JBrmVLBv6HZmWeevW851M/cxuy9AUcvxcffrIwTDzt1UlhZrBj7Izt2EMuUiKQdUgu
	su33G6oGRIUIQdxT1E6fPsw3fZ1Wb9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790868850;
	b=0FS2cQee+sceGbvAd4x13v9R3Cx6QquL4W2l0Sf7Dpm+NJEJ87rsjYHgwBLTO84us5W+XV
	Q9YHiTHNae+nC7pA9wPBwxbHDv4QjjTM43QVvxGLWgMRLRfRs8jAp2OoF8nZvL9prrwSRC
	a+rDyOQuY8H2wPDL3OZ0EfeAbTLEtlc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BdVitacX;
	spf=pass (imf24.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd04be87so1445105c88.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790868849; x=1791473649; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KQILXCbNTg3uilRJywVvrlkBNpYRNdVSU/c2Q3udK90=;
        b=BdVitacXPpS48u/uoY2OYNOrlh66enYqO4u4nM7zvkMaW6fIb0OQYDzluXdZJlq3pN
         3HWu6D5naxjDOwSC4rZo6Y/oHyrwNBoPcZzl6vam21UQsND9zmra5mHDLtQLv3+U/6fX
         MSV9znD3tN1H22Vt+5uP14je0oBAjQC+RQaZAdqZ20cnzWS1QJE+x2Qrl7LoXUcwqDL8
         ahkZNAjk+EAofT/YYouosgPXLnaHo1sAZObOzVrql3mJj+kxatyaDrg2KaSzJtLfMBxV
         7zNq04c/zT0vM5A769eVSSI0FjzUgQL88vhtcT0HXufMEBjMZPcUDXvmYPNU8HFr7133
         5hoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790868849; x=1791473649;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KQILXCbNTg3uilRJywVvrlkBNpYRNdVSU/c2Q3udK90=;
        b=McFtAaDSGj3RjfkUmNPU7YKVCZu3dU1LRaIemgSkWdjZU2Rqu5CdFRc5J4JGZREQwa
         XNlHpgkjFtrgXCfyDtkWf3Vaqf+j3yUDupf5qZInToEiL4s2ALS1YkTPdcBOe8V+bxnI
         NInj07agvPgGWLsMw4nYLl7tEZ+/6dTnul9DIy8Va+BUNBHhCEHY0+qcWLVI6rHZqSfZ
         +q6afxh/QMCIYDHbomFLbi1ftHzcozkzM2ag11343gc0nqTR0b5baVxz4eBIYUoemAOm
         jRCgIHE6hp5JIIvLh10pMCGDCDDqD/VYBi8hp/9DrHHqe2AlXuPNnKv5iQYeoGpS7HvM
         ue3w==
X-Gm-Message-State: AFuF++mgCOcP/0R/O8jIWeA1lqqu5FrZr+5qUiiN+4mDbXKXOHV45uSM
	apdEmvkJurHjo8QTUoPNHACH+vvoRm+1zjusFnmCChEAiZv9BI3McNy9
X-Gm-Gg: AYBFou2T3YZQ0CfEUx7oPd/Vq3M6MVjT4jwiZ17KFVMt712aHVEa+K9Up41cTc2TMAX
	L8d7nESt7bFEo4lKTGULIp/3DAAbumhy/Guf2r56dtouGMJU0T9F7sgKvFc2U4jGitvgEFm7x8V
	9b8EyMvcyviNZYLYWd+y5e1OTFrCo1gmKwQhgSoPr+0r7s85pd2CYn8qLEaLpM62HlgWdiiZNnR
	taRgFpRVDjLLRaaqZD24FXVLLppwuIpW2wbHHgcXOeRUZzOky4jbzHvhUoR1alDNh34tXqqlPOz
	wDjP32LM7The0D1Spi2PnILRcqOb8ByK98tVIZN2nmwmk/HZJO0preQI+CCsMur0skVcebvuFWJ
	ku6fax9xWzqwUt75Zq2otNz5Z1at63bDTbNK64Jwhl2e+QlTBi1ie4iPtNYokeQhrz4QCEvlKZS
	Eki0eJMR5iRcEtUrct95r4JuA8G70W28rYx/2faQ06GD74KMwB1Uhz9Ez5uLdesjHnvA==
X-Received: by 2002:a05:7022:7e0b:b0:14a:5d07:9b with SMTP id a92af1059eb24-14d3641df3fmr5352454c88.28.1790868849303;
        Thu, 01 Oct 2026 08:34:09 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f266d1156sm146683c88.6.2026.10.01.08.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:34:08 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 01 Oct 2026 23:33:48 +0800
Subject: [PATCH 1/2] mm/compaction: keep compaction deferral state per
 migration mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-bug-mm-thp-async-compact-defer-v1-1-0174c7923430@gmail.com>
References: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
In-Reply-To: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
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
X-Stat-Signature: drcikb1ehq79hrxrya1xw19s98mq9epf
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7D5D18000F
X-HE-Tag: 1790868850-55887
X-HE-Meta: U2FsdGVkX18LmHeoMVOzlfmx+r4nQlcr/6tLqVCJduS1sg9j5XtC38wIM7pT2sMIAipo0K2H7Na7Fot+jjhf82pN3OvsKmEnjVLnTrc8Yf48IXVv3NBD40+h15rPBDVa8/WG+43Cy2T6kBHqKiLj4G1gS/fQJ9yju7VfEI8Ll81szyK7zFhhAzFU6mbqWgMUl4PaGhrLAACb0yNN9E0vXSYBFoX6VCJ+VCA2InPZyPzWs2A8tqBX5+MEj6Vp5g5czOiFxo46iiwxxmjZKsVuaYUmxWIFmb5yQphw7kEkOCFNvgyea2Qz4QXDIvX/NlQhq4ZyPxO+1kK03PmIYUkeujtVRU8vATedDBf5N2OBogoJEmR0+ak7ElI2OqjFlvk0p/nAuX1hkjvsJMdGgNQ1CyPGCGgrr6SyVtv26Jr8ZhAW5kE9v/gmZCtwDy4bavgFd4OsgsX/ypNsGyuYCRR9eVVA2qCCt5e2b1A4GBOSy2C6w/In9q2wdMnjX+BDz/cG99QKtNDxVY4X3l7lR3c0y7Ar1lSfmcH3VHB48m33Y+55fkUbvwxEBLSobi0Xys35wNSkEumCcXChzF83zTVdSLaot93l6J0o3BuTlplkx0X0J1COcB2sqBFDVYaCzSAT8xheItp9/0EOm006y5LMJta1AxgQWsM3fs4Cij+qH7VRxuikzALsyoTFhbmrN+MXfE05nmLZcf4uWAcjdrXkKp5btch8ZCu8+bnolwWcqanlZRUMM+d166KWAwn37tynlky4RpIuOkjsOyg+dijsLcU6+quuuk9/pN8xYBgsVqmaok1IV6UrepK7DizuD9VAj/phyTtkZncSMqLcTrpdENUjis/pti7hkWB/nd0gx+WVsa0MpqU7mVhyiOiBdalqcUYI0T6LQk4hp+QcdznYlHoVWabXmGD5mhZbw3WeK1slXsZotHQNdS/MLDnUSuDW3DSr0bDoApubs9Uzy2l
 UNk9Kd6c
 PFCNfAvjETdNidUXy6/MCfvuq5X+zRK1FmjJdXhnAKkNb4uOkhVWWEv0vIXZTJKG+TMjzycY8Gy7IFLSlAZ26yk+5r8R9UE9ezbcWlqiRdmV1q0tOtPdcEk/wXGfadWStKaBSf7835974gE45uxBftkriBO+f2YqITVSkdf2WS3LZ49FY1201Ayak3qNDcTY7S5D0CYRb07J4pS9QAns8Tzqk+MRoEFLfoFAw9lD8uDXj/uad7fOBpTFIVORs0zgJ7p5IvxSj5tMzIjQs+4UtOTYieTi9Ml+puJ2DN8EpZOze83y/B4Kgio3+7oXuxlhhv55ytZNBoZhSWrPlS+BClHI3kYqVTFlBmq1GONeNNT94FoSJQXlhFab0rTC1sbXhMdYq5SwrKmX+pYCHk9rfGYfhOE/xMWAoo5ifywNn13h+oPdMaFfE+oaVgFuOiTnDcQEJ7goNNey8mZhHfIiOPiOEU/2c3crlyeCKHhHWS3b6d/an5kYwF2m0Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_compact_pages() defers a zone only after sync compaction fails,
so a failed async direct compaction is never deferred and repeats the
same futile zone scan on the next attempt. Deferring async compaction
needs state of its own: sync compaction may still succeed on the
pageblocks async skips, so it mustn't be deferred along with it.

Turn compact_considered, compact_defer_shift and compact_order_failed
into arrays indexed by sync, like compact_cached_migrate_pfn, and pass
the mode to the deferral helpers and tracepoints. All callers use the
sync state for now and a reset clears both. The deferral tracepoints
gain a sync field telling which state they report.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 include/linux/mmzone.h            |  7 +++--
 include/trace/events/compaction.h | 27 ++++++++++--------
 mm/compaction.c                   | 60 +++++++++++++++++++++------------------
 3 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff54160..91fbaa7aec6f9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1140,10 +1140,11 @@ struct zone {
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
index a049415512c67..7f8845d1990aa 100644
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
+	int sync;
+
+	for (sync = 0; sync < ASYNC_AND_SYNC; sync++) {
+		if (alloc_success) {
+			zone->compact_considered[sync] = 0;
+			zone->compact_defer_shift[sync] = 0;
+		}
+		if (order >= zone->compact_order_failed[sync])
+			zone->compact_order_failed[sync] = order + 1;
 	}
-	if (order >= zone->compact_order_failed)
-		zone->compact_order_failed = order + 1;
 
-	trace_mm_compaction_defer_reset(zone, order);
+	trace_mm_compaction_defer_reset(zone, order, true);
 }
 
-/* Returns true if restarting compaction after many failures */
+/* Returns true if restarting sync compaction after many failures */
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


