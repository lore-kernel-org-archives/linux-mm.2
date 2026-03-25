Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD3E106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C5E6B0095; Wed, 25 Mar 2026 10:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004536B0096; Wed, 25 Mar 2026 10:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83A46B0098; Wed, 25 Mar 2026 10:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7E9F6B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:14:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82B191B8C9A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:18 +0000 (UTC)
X-FDA: 84584780196.14.21963BA
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id A93CB180016
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7cVHfis;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448056; a=rsa-sha256;
	cv=none;
	b=m4x9JrbKbxrFB3th+buxNqOOhxD5gAL9Yd0irksE7FNecGpPTeqQk1o97VlkTuuLkEho0r
	3CjXljqYKcTdB76gq7hLkca0fRO8Th77SmEk5GnWQHTfEqQfswsH26i5gQ9kgqkTF/bEkW
	FvuK//K0wYQ83gbmJt00UmYPqeihlg4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7cVHfis;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUxL3aCWfBrV4Mh30s4f7F0Tm+DKPzxkGVhhwaaaROg=;
	b=RiuzOT9gTtG0QsmYfjKCZlxN/AP0Q8eZ1qUV5A0SwKlXllyHzVnEdRMKVq2MvpPE5kTalc
	i2wx6k3K39uYLmcyk22t8j/jWI1LHhlLzx5gsErJdJrzqqb591dyggrmb3pAPF+/Vt/IuW
	iXh316fpnN0N3X2ZxOyXi9H/T3WqeGo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774448053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUxL3aCWfBrV4Mh30s4f7F0Tm+DKPzxkGVhhwaaaROg=;
	b=H7cVHfisxoDodyEGI1H7uAcKULR+QbHbPyERexScdsEjhh8gOA6XneHqYCAAZKremhK9uy
	fmUBs9uAhFH777GqGsKo2ESInqi/hjOyyMFPzPk9qtVPadoIAVGs/I2j/qcEEEkmtvWk6b
	A77LKX2euCL8bOjJtA5r4W0FkHxQ3/g=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
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
Subject: [PATCH v2 2/4] mm: memcontrol: change val type to long in __mod_memcg_{lruvec_}state()
Date: Wed, 25 Mar 2026 22:13:23 +0800
Message-ID: <5c42058df0e52a4698da005e502deb2fae7bf819.1774447069.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: odmiab7yzhjz1bns9gni6qr9cw9eurfo
X-Rspamd-Queue-Id: A93CB180016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774448056-719216
X-HE-Meta: U2FsdGVkX1/z6G8pqh9kqffH2q9Zw6MJFkJcByO2IZ7TaMlYFJtMWreLIP2YS4UVqDMj5AV1yTpxI07h2EmxoqsHHb8mDVDJHMiNtOnJ6Qd51SxT+dIO9soh7saLRf07i+d80HvbnYyaoJCcxnMmpfRMlJcYAVn5hHoPHke84XsUvNHjyEC97otvGRcIY7Ab6DKLtozflYh+v2Zc21k7VDvD5FwHpsZmuRfqXAbKX6h0R9dnAjTboUXvv1zneblo53whoTVwph8Zs+3PXVHuPDlyQR9AyuEiw5+h/qtVxlaThcTcB2q40jytZRNcLihbPByCbukNaf07Ied7ts89YO83RrK30psCju1AujgDP++j+zLUTlfhSWwqpP84hroZVsnxkBcQN6VfHOgnyXYRKdsefdmYRlt6g0LGWt7rAmjsqC11JyEMRiI65oJMjttFH/xU/e91Wyh8Pz+0eAXckAYzvspl6GBw7VnCtfKJMYjFyCnzULtT3Mon59mdgdKPkRxjbgQ6lpta1kw04SoyW1Naiu2q07U/nnACICanHLNm056VKDoTGjtnuQgNLx/qmHNzYeNFpArPx+tebDlPoTUjZn9D9w2kf8T8uJx5fOpPqObQl8XCGAlQVkTTWsivyzU94g7VlZIwgK8khdSq3br+qwA+rLIpnSLZ6CL3qsAEUz4e3wrgMdXRZUY2KKiRPMwENV+0IgMHH0lfy2Fp5xjHoV1QisBxE6tdp67rBUje9zIW1o5kPXvScjeuEp48tAveR88o843KGV8xlWZhU2hcqLkXpDJP1yOSIa9J5CflzzWom5TYeb9ZdisZcTUPjc5O1Fvv7yuiFXX2CNX1m3Mlz08UJEF9LdzoIkgc4CIQqZg6AHw1uFb5fzvKHPG28KMZ6uNtZW8InNFFyqNx0lmSFG1fJMXwRcLD2ener++DmDRGeQ34aa5c4dneAE4L3q5fULrn6nR/n1nUQt1
 Uq7c8/Af
 9hIPn8NERBdeZZDkt9gDzmwos6sqwO490Fvb2P4/H3xY/KR7hoKMu5zsBESzzaRbtsR1PIRBZmtHVNo4Pipd4ThojvTS4dWzZmou7w9kyCROKTxDqgUbKD4PT61SnpamM094TJ+5lYK7duUQ/5WBJjP4NAd/TzmJy3o4N1oRNj0jMCnl0UbOeOU6C7xrlwhUFLAxFML38avigs04fIRxAQVnoEMwZMWB2dML8W9c3L56OWnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
used to reparent non-hierarchical stats. In this scenario, the values
passed to them are accumulated statistics that might be extremely large
and exceed the upper limit of a 32-bit integer.

Change the val parameter type from int to long in these functions and
their corresponding tracepoints (memcg_rstat_stats) to prevent potential
overflow issues.

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


