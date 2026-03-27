Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DA610ED656
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F326B0095; Fri, 27 Mar 2026 06:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31F36B0098; Fri, 27 Mar 2026 06:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E203E6B0099; Fri, 27 Mar 2026 06:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDE906B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:17:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D68B140E94
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:17:10 +0000 (UTC)
X-FDA: 84591440220.24.B36BBD9
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC71E1A0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:17:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NU8UZA3h;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NU8UZA3h;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606629; a=rsa-sha256;
	cv=none;
	b=vKEtAV7uL36/CryVge8G9X5+cWN9j8dCIvjiAMyiHNYqDqkQYevl8J9s6szGPwMzDFXfji
	pE1Cm7xFNuf76mPTWtnfXHjhZYIt76gT4TvlSPZMGE17VR3Z9ffmIjkYpZedgoqL7SgBCZ
	pKaLxtgVx12BwkxeQ0G1IAZIre80W64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7idg4apMzWcM1H7JQ2J+ylc2yYHYMkuNvApHewHifiU=;
	b=ke04C2tYbVCI0Lzps7yB0z97yKOz6LQboopn6KLWmRQveCXLvTs82wNA8vcQt60xrPfZeo
	OOUEZ7PTCxcfHF/6lue+WMwVZeH+t6aBukWMK9eHhQYi/oXW9u3MNzvLhgxbY1TTwpfIPB
	GCHPrGtgwlvJ8UWFbV7auvVGLSsrgwA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774606626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7idg4apMzWcM1H7JQ2J+ylc2yYHYMkuNvApHewHifiU=;
	b=NU8UZA3hP79BXLamKOXvSfYVXxrE1CpdXnaT1dCbM+Gea8WrLB8v8+ti7++9OljRYQIt7y
	MFUij4jIzktEgcqq8sYriETnMW6W3/ZbAv3CZ9C6550PvPlI8uxWHdvkFAe5UtUgEwcpRP
	LUqoILmS8Gya1+/G3RjiZWRFH+pok+E=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH v3 2/3] mm: memcontrol: change val type to long in __mod_memcg_{lruvec_}state()
Date: Fri, 27 Mar 2026 18:16:29 +0800
Message-ID: <70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774604356.git.zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC71E1A0002
X-Stat-Signature: fm5b4dq1i97ixy44gdz9jpg3rzbe7uzo
X-Rspam-User: 
X-HE-Tag: 1774606628-193792
X-HE-Meta: U2FsdGVkX19tf26vkxbL5S1BBJIocqQ6LNgwIUKhkij2bqAk+KOdNvgWKeYQezvhPfIG0eeDu7U4WzuH3+oAzkRDrxNIVgEH6NXE/2a3bsnAEcIkBsI70iFcQaZOK5yVG7x78YMjrp21208F7V5oVeaaSdsXo7OpK3PeV7k3ThuIIpWIqIG35YkoE7OqShT5x5P8qpJEowplxRWkII9Etq0j4IPGCkxWOVvNTiP7Zt+I665sB83gQmtbJqhBd5UVzpBOZ3d5uWnBDtsvF3F3u5vLvH68sTWqplqOLFOOs/6E9mbiRFRpxQlfJQZJZclWn0+XONk/XayXyUQT687ApKnKDCzGb2HuUD2h8d3uIolZEUwxKPC5ClSvIjqaiwNkK8yc0sK62if2946FfcaZGl6VLMOHyYrLMbI54oPlgQkaIKHnaIy1JvqIr1VRfnoqsGeC3xX/zEp8pn3mFtJ6ZZlmhyFwNqPOnaiGX8sq55w0vqrL0SWm2i7fDAXkly8xA2QY53JOuak7srUUgWK/B+MounWqtb4NabKOk0yvKTVB/plpSzFXejXNJqHuz3TnrzKPTiQ9cPD2WX1l6JpK44y5MzFyFbFufnUx9lob58gUwLQ1+THq8MHm4vJVCKvdLF8YrgRYcFd45U+zvYxbhfOwo2thHwqeu/HK9CRonYFugoiWDIiNQt0yggKXjByYGJlu+aV6HnVVAWgGTWPu71QfnaCcT8BdozV6KcTW5b93EdejSERYpkZAdC/tczOpWy+Xxq5W4YvM0n57UCxV04/5vyul0B6+pVkhOV2bpvOzdLz+762OxP6FbC/UcOKkwwcRhtO5PqoFSu0S7I7Sh4I4F8aFLKNlOZhABVu6u9dKRU0UsW3X0sURLrzsAZjBXkdxOnqIBMMGYUBxUqVK1TQ+ksSbJcEcGoWqSNlOq55Kd3NGQ4d1uXFNKT3aCrv5n+DTjWVnZXTLXj7l6L/
 tOBI0RQu
 COBZRN2rBojAbmHEsNf7/XgvBPOqx8dA7fXvLORlMN7nWsE6BOTibbvtMoHtkeMFHLsg6vYBvsSNgs9jpqa/aA7AFqZtLmSk4bJAr8gIGiLFMDrXaivSB7s6seIKTL7jXNCacWiaTTDzV1grVOHg6bu/mydzmfbY5wOxMipNY3W2oxl4WDLrTS+kFTzFEYkY90IN1w/1Cmk+KbxROBV2t/SkGvEdJDpJBv3fpmSPQ0sGZYB7D3W/X8Cf3AyzEQAGnEgdz
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

After that, in memcg_state_val_in_pages(), if the passed val is negative,
the expression val * unit / PAGE_SIZE could be implicitly converted to a
massive positive number when compared with 1UL in the max() macro.
This leads to returning an incorrect massive positive value.

Fix this by using abs(val) to calculate the magnitude first, and then
restoring the sign of the value before returning the result. Additionally,
use mult_frac() to prevent potential overflow during the multiplication of
val and unit.

Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/trace/events/memcg.h | 10 +++++-----
 mm/memcontrol.c              | 18 ++++++++++++------
 2 files changed, 17 insertions(+), 11 deletions(-)

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
index 3daab9b46429a..51d72ddf08119 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 
 #ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-				     enum node_stat_item idx, int val);
+				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx)
@@ -784,14 +784,20 @@ static int memcg_page_state_unit(int item);
  * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
  * up non-zero sub-page updates to 1 page as zero page updates are ignored.
  */
-static int memcg_state_val_in_pages(int idx, int val)
+static long memcg_state_val_in_pages(int idx, long val)
 {
 	int unit = memcg_page_state_unit(idx);
+	long res;
 
 	if (!val || unit == PAGE_SIZE)
 		return val;
-	else
-		return max(val * unit / PAGE_SIZE, 1UL);
+
+	/* Get the absolute value of (val * unit / PAGE_SIZE). */
+	res = mult_frac(abs(val), unit, PAGE_SIZE);
+	/* Round up zero values. */
+	res = res ? : 1;
+
+	return val < 0 ? -res : res;
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -831,7 +837,7 @@ static inline void get_non_dying_memcg_end(void)
 #endif
 
 static void __mod_memcg_state(struct mem_cgroup *memcg,
-			      enum memcg_stat_item idx, int val)
+			      enum memcg_stat_item idx, long val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
@@ -896,7 +902,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 #endif
 
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-				     enum node_stat_item idx, int val)
+				     enum node_stat_item idx, long val)
 {
 	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
-- 
2.20.1


