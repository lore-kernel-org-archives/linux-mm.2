Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC3BD2ECEF
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 02:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48AF6B034A; Mon, 19 Jan 2026 21:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B200B6B034C; Mon, 19 Jan 2026 21:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D506B034D; Mon, 19 Jan 2026 21:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 906A56B034A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:45:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37271D20AC
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:45:06 +0000 (UTC)
X-FDA: 84350800212.18.3F9C118
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42829140007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:45:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ONEJ2SjE;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768877104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3RXc14Fh+mRlBxJ2vUgvKn/8TcbpXs+n2XpGtsp+0c=;
	b=XoIaqH3lAtnv54AFOfujNRQILoPcrUJucRjjf/FuYkDdurOm77tCppwxYwK/smj9N/WN+n
	59a6CfqnE0FBJsVslVECqtY32JuEAqJSdHq0SKRuhBxaShqkmkVOKsCm9GmaHAVQzN8xx9
	ZNSY50/Ws+4mOD/O61kvDYGnLXbMFrI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ONEJ2SjE;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768877104; a=rsa-sha256;
	cv=none;
	b=V5yguvdgLhV7dr1/7x4bQd+hvMYCEf881X31iJYM1zrXeZHGSCVCAEcp378fkVrrEtn7br
	EcQl+pk9p3StHgsCNsRfA4kKoIK8PJ5n7I4wQt8q6eil+yp8Lo9JrbUTVBcWYVkj6c+T5l
	6argtQKIYNbca3lHy9HiDH0zqStCS4I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768877102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L3RXc14Fh+mRlBxJ2vUgvKn/8TcbpXs+n2XpGtsp+0c=;
	b=ONEJ2SjENJWrxgw4alHNO9f3Ul7X6z8okFWgOPbVFjM74o8iObUsLyi5oLzvvQQH5kH+Y4
	48B1Cfom2YQX+uagGDjjIyE28B/V2ZGxEhNyJuouSRQwcJ6NfYzYcNZsB1Rr9Kgfk/ibk8
	kXE19k7cuKnojRXf6Wb2K10hS2uw4mc=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] mm/vmscan: add tracepoint and reason for kswapd_failures reset
Date: Tue, 20 Jan 2026 10:43:49 +0800
Message-ID: <20260120024402.387576-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260120024402.387576-1-jiayuan.chen@linux.dev>
References: <20260120024402.387576-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xi8who5od1qdr47yn19hr9apkcae1hrc
X-Rspamd-Queue-Id: 42829140007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768877104-49796
X-HE-Meta: U2FsdGVkX19vsk2+TuuhJHJNPzbdDb0LIsdSAx2CwNDASOQgxk6cVGRtioAiyRZ6d4LGktSFWItlUjaarx9eUhI6Pr2zMfSet1tHnh/41m429tLgHZS9LU24nzKZmat8FRem663ij2iBSGRvnaEY68rhIfdrV1vbNZjKdZ/LcQWN7p/0+iV6oEwUIdD6ae7ZhW/L7kcK2Lh6MhFCXgTpRZbHSsLMu0tbPUHsJD6WDiYv1s4o0s7cffYu/yuN4NDwWkOCltOG12HNriveIPZuYpLmVZWDItcPhAUfN7pw2+YNoJmD0yrvmvyqpIbiCCuywLlQ9UuD5XWXg65BnSEAEWvwcqUo8xKsL6DZm0j3xhfcakgqymxVYsQfCf6bBy/a9QPW9qvtUBCln3TAo2Pf9ESwmPhLr+V6Bzn6B6JF35yZ/9jVi/hHevf7SDbeY8CaOR+ySFVTlNq3C+g3mXuqHi8nY2Lchyj8u7dtc1KLl+NbmyOV0SRp/mw4mZvBxEdEWyc7Z5aBDPZZVoUvUY8MTfiEHhrVlam5dF2CnriiYkJr8wjrCBhDufeI8zOHWZzSD+fO/pX8z1AGvpMzioDaQrZmuqQGyRfcTEKmyF36DjhFsXLbMsm/MEUio88nl9ybKPBxfa4UxwUzqBkVzM0odpu9aFqRnNP+spFCFg+1IS6sw2gnUQbT3YtpQ1kmqyqFbv2Qelq0oiI2HODxmmfHrQAajoFVP5iFRcqOkPs7qk9CoPjQ63tIC6qJWShr5HkqVIvfsJCpXWJED1VgegYNFc8kNSlouaRef5KTqweaUtwR18WDEFImtBH57vibTDMtGPbh11k9U6rglUU1kJowp8WxTXM7e4zMkHzjqrRdZ2pm4nNa9MddaGovzCCLXHuvXtPNAWVo2qQrFWBuzrONOdvutOaHycae9C+kDEpRPFVUEgVKIgijmp47e5wDlfxj58YoEC8hab7UXlkvCRn
 TY/5QlyT
 /GQ7e2E/tzAB4VRHXGEoKqufbd2UNZ0HeDciw0/aAQDkj0u/rlhHmDUrmRjtSKt3rNiJamTFwN8ZpijmoB+Cl38Gdl+fNZIljoYwxIzTQ4HSePRKDFv9Q8haMQARkm2fo6wslb+3bI5Vw+xGdqg93wl36t24pXYF5VB5Vyy6sBbknh0vxNB/TmYRM9lvP0/VGbaR4a7lx98wr6G8mGNIkWoXNwIysgvmdPg+BrRApqDDxzVhQLnPVYtBUxoIDXZnxMNx0F8e5YysWK4BICkr+bGSoaHfl8+Wf48RYDo30kjJ0SBtotweCQCUhb3/1LNRSsGhwVJK4Vy9AzufMuAfl4b8VhIR1SIkXYEj5jptB6TFAz3k=
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

1. Introduce kswapd_clear_hopeless() as a wrapper function to
   centralize kswapd_failures reset logic.

2. Introduce kswapd_test_hopeless() to encapsulate hopeless node
   checks, replacing all open-coded kswapd_failures comparisons.

3. Add kswapd_clear_hopeless_reason enum to distinguish reset sources:
   - KSWAPD_CLEAR_HOPELESS_KSWAPD: reset from kswapd context
   - KSWAPD_CLEAR_HOPELESS_DIRECT: reset from direct reclaim
   - KSWAPD_CLEAR_HOPELESS_PCP: reset from PCP page freeing
   - KSWAPD_CLEAR_HOPELESS_OTHER: reset from other paths

4. Add tracepoints for better observability:
   - mm_vmscan_kswapd_clear_hopeless: traces each reset with reason
   - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure

Test results:

$ trace-cmd record -e vmscan:mm_vmscan_kswapd_clear_hopeless -e vmscan:mm_vmscan_kswapd_reclaim_fail
$ # generate memory pressure
$ trace-cmd report
cpus=4
 kswapd0-71    [000]    27.216563: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
 kswapd0-71    [000]    27.217169: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
 kswapd0-71    [000]    27.217764: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
 kswapd0-71    [000]    27.218353: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
 kswapd0-71    [000]    27.218993: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
 kswapd0-71    [000]    27.219744: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
 kswapd0-71    [000]    27.220488: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
 kswapd0-71    [000]    27.221206: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
 kswapd0-71    [000]    27.221806: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
 kswapd0-71    [000]    27.222634: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
 kswapd0-71    [000]    27.223286: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
 kswapd0-71    [000]    27.223894: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
 kswapd0-71    [000]    27.224712: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
 kswapd0-71    [000]    27.225424: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
 kswapd0-71    [000]    27.226082: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
 kswapd0-71    [000]    27.226810: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
 kswapd1-72    [002]    27.386869: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=1
 kswapd1-72    [002]    27.387435: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=2
 kswapd1-72    [002]    27.388016: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=3
 kswapd1-72    [002]    27.388586: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=4
 kswapd1-72    [002]    27.389155: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=5
 kswapd1-72    [002]    27.389723: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=6
 kswapd1-72    [002]    27.390292: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=7
 kswapd1-72    [002]    27.392364: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=8
 kswapd1-72    [002]    27.392934: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=9
 kswapd1-72    [002]    27.393504: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=10
 kswapd1-72    [002]    27.394073: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=11
 kswapd1-72    [002]    27.394899: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=12
 kswapd1-72    [002]    27.395472: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=13
 kswapd1-72    [002]    27.396055: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=14
 kswapd1-72    [002]    27.396628: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=15
 kswapd1-72    [002]    27.397199: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=16
kworker/u18:0-40    [002]    27.410151: mm_vmscan_kswapd_clear_hopeless: nid=0 reason=DIRECT
 kswapd0-71    [000]    27.439454: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
 kswapd0-71    [000]    27.440048: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
 kswapd0-71    [000]    27.440634: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
 kswapd0-71    [000]    27.441211: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
 kswapd0-71    [000]    27.441787: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
 kswapd0-71    [000]    27.442363: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
 kswapd0-71    [000]    27.443030: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
 kswapd0-71    [000]    27.443725: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
 kswapd0-71    [000]    27.444315: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
 kswapd0-71    [000]    27.444898: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
 kswapd0-71    [000]    27.445476: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
 kswapd0-71    [000]    27.446053: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
 kswapd0-71    [000]    27.446646: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
 kswapd0-71    [000]    27.447230: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
 kswapd0-71    [000]    27.447812: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
 kswapd0-71    [000]    27.448391: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
 ann-423   [003]    28.028285: mm_vmscan_kswapd_clear_hopeless: nid=0 reason=PCP

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/linux/mmzone.h        | 19 ++++++++++---
 include/trace/events/vmscan.h | 51 +++++++++++++++++++++++++++++++++++
 mm/memory-tiers.c             |  2 +-
 mm/page_alloc.c               |  4 +--
 mm/show_mem.c                 |  3 +--
 mm/vmscan.c                   | 29 +++++++++++++-------
 mm/vmstat.c                   |  2 +-
 7 files changed, 91 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3a0f52188ff6..d26fdd48f106 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1534,16 +1534,27 @@ static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
-void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
-		   enum zone_type highest_zoneidx);
-void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
-			       unsigned int order, int highest_zoneidx);
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
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 490958fa10de..ea58e4656abf 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -40,6 +40,16 @@
 		{_VMSCAN_THROTTLE_CONGESTED,	"VMSCAN_THROTTLE_CONGESTED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
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
+TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
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
+		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
+);
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..d6ef5ba8e70a 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -956,7 +956,7 @@ static ssize_t demotion_enabled_store(struct kobject *kobj,
 		struct pglist_data *pgdat;
 
 		for_each_online_pgdat(pgdat)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_OTHER);
 	}
 
 	return count;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..1b1dedc7ede1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2916,9 +2916,9 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * 'hopeless node' to stay in that state for a while.  Let
 		 * kswapd work again by resetting kswapd_failures.
 		 */
-		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		if (kswapd_test_hopeless(pgdat) &&
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
 }
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 3a4b5207635d..24078ac3e6bc 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -278,8 +278,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
-				   MAX_RECLAIM_RETRIES),
+			str_yes_no(kswapd_test_hopeless(pgdat)),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ecd019b8b452..0ec2baa4ed4e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -507,7 +507,7 @@ static bool skip_throttle_noprogress(pg_data_t *pgdat)
 	 * If kswapd is disabled, reschedule if necessary but do not
 	 * throttle as the system is likely near OOM.
 	 */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	/*
@@ -6453,7 +6453,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
 	int i;
 	bool wmark_ok;
 
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
@@ -6862,7 +6862,7 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order,
 		wake_up_all(&pgdat->pfmemalloc_wait);
 
 	/* Hopeless node, leave it to direct reclaim */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	if (pgdat_balanced(pgdat, order, highest_zoneidx)) {
@@ -7134,8 +7134,11 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
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
@@ -7394,7 +7397,7 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 		return;
 
 	/* Hopeless node, leave it to direct reclaim if possible */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES ||
+	if (kswapd_test_hopeless(pgdat) ||
 	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
 	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
 		/*
@@ -7414,9 +7417,11 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-static void kswapd_clear_hopeless(pg_data_t *pgdat)
+void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason)
 {
-	atomic_set(&pgdat->kswapd_failures, 0);
+	/* Only trace actual resets, not redundant zero-to-zero */
+	if (atomic_xchg(&pgdat->kswapd_failures, 0))
+		trace_mm_vmscan_kswapd_clear_hopeless(pgdat->node_id, reason);
 }
 
 /*
@@ -7429,7 +7434,13 @@ void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
 			       unsigned int order, int highest_zoneidx)
 {
 	if (pgdat_balanced(pgdat, order, highest_zoneidx))
-		kswapd_clear_hopeless(pgdat);
+		kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
+			KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);
+}
+
+bool kswapd_test_hopeless(pg_data_t *pgdat)
+{
+	return atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES;
 }
 
 #ifdef CONFIG_HIBERNATION
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..3d65f5c9c224 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1855,7 +1855,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n  start_pfn:           %lu"
 		   "\n  reserved_highatomic: %lu"
 		   "\n  free_highatomic:     %lu",
-		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
+		   kswapd_test_hopeless(pgdat),
 		   zone->zone_start_pfn,
 		   zone->nr_reserved_highatomic,
 		   zone->nr_free_highatomic);
-- 
2.43.0


