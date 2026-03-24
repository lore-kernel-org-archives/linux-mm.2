Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14442E9A76B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFE16B0096; Tue, 24 Mar 2026 07:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790566B0098; Tue, 24 Mar 2026 07:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F3F6B0099; Tue, 24 Mar 2026 07:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5548B6B0096
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:32:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1499A1A1A85
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:45 +0000 (UTC)
X-FDA: 84580744290.16.C76A97D
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5009920010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RnCS1WTS;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbp2ikBGYSHp7eYBpCkowJnRwz/ZIiettZ7OaupB1ME=;
	b=Bt6ZekpSnF1uHIWFbSH7X1XTmAY2e3OTMQSBBWtMyYBRxRwvGxddr4oJBWq5FUr9sGQdm7
	0N8wu7T9n/NArIHW9G8sWgubRo6Cg5v4HT+TNT6Lt+G9imRhn/wFkVgCvfKUfHjaQMxuAt
	LKJGeHzOkCSVkZcJD1MuYie1bzSp+6w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RnCS1WTS;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351963; a=rsa-sha256;
	cv=none;
	b=XTwQRQrzW+y+k6hgfF8m4eMXUSmhnUkQ536wPoZouYG0KPQNvo2tjqAAvS8TsuJQLl5SS3
	AAmKbQuHmVbbozCzAxgZO0m6DehF3G+LaHcO8CYRvnMKd+OGxoiSw7UVEzZNEzoudwj2+/
	P9Btqtg/vjB5LhJfK+Jx0NKFnkaZ2ME=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbp2ikBGYSHp7eYBpCkowJnRwz/ZIiettZ7OaupB1ME=;
	b=RnCS1WTSFjuHo26aHrrzV7pr4WyI4hIUkXrh0R2Z6WYadAso5dDj5d/95zU0Wr8rCQ3M6i
	ClRkAIt3dafHAjXQ/puVTZQDDlYFogOFA1CusD8DYjmpzamFKQIE0JqdMCvDov2/JqXe79
	9d8KcFMMmMgpYNuKGEWrRAYMbBvCaXo=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 2/3] mm: memcontrol: correct the parameter type of __mod_memcg{_lruvec}_state()
Date: Tue, 24 Mar 2026 19:31:28 +0800
Message-ID: <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774342371.git.zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5009920010
X-Stat-Signature: d6dxx8swhzen1oiodsnmmkf5e946d5jn
X-Rspamd-Server: rspam06
X-HE-Tag: 1774351963-814470
X-HE-Meta: U2FsdGVkX18H9x8eai9GJB22XlPFpZnHBePpDekvmo8P4g/7jpItTcdFpA7aMghM+IwZA0HTf2Aye95G9Sbv8vcS/AsmZ9zmbPWmOSObC7fZNaNxctLNrphDu6bSzEjEIlD58Ajntc7bC+9r0nBfP3ZpkEukMEI8rOoKWg7QwOc3IqwHLowtGme/8QTpRn7gDqvrXhlkxEt1/M31cqOumchRd0z6u3uDfYAsChu5VwvcCsFHKXCuEAQglTVoNkScBvEgSyG3vsqMutxtxvlFbYo5hVUv790E0MhzFSQ3xfkTEBiMeU0bRjk1oFbJicW+jkhYsqmCsK/sWAb2zxxJeLPKPuw4noL/M7iqE+2CP195FWE+EJx6zYutxIDyeiTETO72Ai/9jBNr1mt06BT7PLTrPe07WhFVaZ0ntZ5ptfHKmrMQRMcwHy3JuVOXn+A0zdfiSVHSKTesfNP2W/ppWVJOnuiMjpjIHnQhdJEX3CHY8maDEOS2NM4oBbh/2VIwvUjaoM8YdAibruoxRW1SW9TBLzYFUBNkrp0cfBhJrAp5apVtVbXXAYX8doY/Xkts1QnNiAxSINNAWNBYry4xCFPq1y0Mj4UjBF4wLVycdMdk4ry7/iN5DIExVZoOq5/gioqYscij4IbmFt0MNeJgUEsHD4eh3qCF13rL7mHZnT72akiAtjRQ2uEOb3CMdTUFSqOokDgaOkVgKvKKxRsA99rAqWBKDd1wkHfAQk3EUxnKE3fvy+EiboYk0dfLu9sFXWZJFQeuZJQUjmxNCY702/CysvG+6ys7mVB87E7bw/wk1YGvH1uh/fUQfITFWORUgA9mgMKDv7MWB0Lgn4YqtRUqsqz1CxDbBanKmezFo9bCa45TVS8a2Yzt+H0z0q1L//VPPDJw9Dg2DFgUNEK2QwHfhsLZee9YjeQ9NnKimqIVR4MatGuYh7AuB9tTsAhAaEmtC/fuASEP2VW4AsE
 uRppQxV/
 gFSdvZ8slvmFU9ZihQyM0u2sLF9q+1pn3LLpmuBm9S/gq+en1Y0Zcb1aWwIAN4V/9PL4GZZAp7D3y1e9ItbU6SX5wRt1sK/jW+vyUI/NLpgTSKf5UTw4uRmo2LsGUU2lSChtL5cvJH5ddoCOm9UX3CYB9YARAp2R26LtOpk+I9dLMVhQhr5RNDIQUGpktY/7T76sOJktzC/viryilFpkDR+9ylQ3P19AxLzd07I4dYER4vuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
reparent non-hierarchical stats, the values passed to them might exceed
the upper limit of the type int, so correct the val parameter type of them
to long.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/trace/events/memcg.h | 10 +++++-----
 mm/memcontrol.c              |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/memcg.h b/include/trace/events/memcg.h
index dfe2f51019b4c..51b62c5931fc2 100644
--- a/include/trace/events/memcg.h
+++ b/include/trace/events/memcg.h
@@ -11,14 +11,14 @@
 
 DECLARE_EVENT_CLASS(memcg_rstat_stats,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
 
 	TP_ARGS(memcg, item, val),
 
 	TP_STRUCT__entry(
 		__field(u64, id)
 		__field(int, item)
-		__field(int, val)
+		__field(long, val)
 	),
 
 	TP_fast_assign(
@@ -27,20 +27,20 @@ DECLARE_EVENT_CLASS(memcg_rstat_stats,
 		__entry->val = val;
 	),
 
-	TP_printk("memcg_id=%llu item=%d val=%d",
+	TP_printk("memcg_id=%llu item=%d val=%ld",
 		  __entry->id, __entry->item, __entry->val)
 );
 
 DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
 
 	TP_ARGS(memcg, item, val)
 );
 
 DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
 
 	TP_ARGS(memcg, item, val)
 );
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7fb9cbc10dfbb..4a78550f6174e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 
 #ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-				     enum node_stat_item idx, int val);
+				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx)
@@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
  * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
  * up non-zero sub-page updates to 1 page as zero page updates are ignored.
  */
-static int memcg_state_val_in_pages(int idx, int val)
+static long memcg_state_val_in_pages(int idx, long val)
 {
 	int unit = memcg_page_state_unit(idx);
 
@@ -831,7 +831,7 @@ static inline void get_non_dying_memcg_end(void)
 #endif
 
 static void __mod_memcg_state(struct mem_cgroup *memcg,
-			      enum memcg_stat_item idx, int val)
+			      enum memcg_stat_item idx, long val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
@@ -896,7 +896,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 #endif
 
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-				     enum node_stat_item idx, int val)
+				     enum node_stat_item idx, long val)
 {
 	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
-- 
2.20.1


