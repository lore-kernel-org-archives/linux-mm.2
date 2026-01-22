Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDB3D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1412A6B02F8; Thu, 22 Jan 2026 13:25:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6666B02FA; Thu, 22 Jan 2026 13:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58736B02FB; Thu, 22 Jan 2026 13:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3D8A6B02F8
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:25:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 884051A04D3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:40 +0000 (UTC)
X-FDA: 84360428040.16.70F3C79
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3F2D1C0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=p+ImZKNT;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf21.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zn10ZMJYtiEcPLf2ZuRuW6L/Fov3vMISENbJTbJv6Ng=;
	b=N4o4oCCT2EDCg3Bwmr4aVofVCABbOrYRgyownaW8IOMeNI2L4nyhNw4ld8NkR9CS3OwzXD
	HiA+Flf90IsSFbCDJXE1+JOezAbY9RoifFe/n3L3cudnIZPclRrR32VTulMGmrhleC1uol
	f9wCNzwkVAEgXmkxWIRxk88xEu/T4mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769106338; a=rsa-sha256;
	cv=none;
	b=FYBfIBRorDab0ThUsnOY+De87gDLwrSUAjnRfjyP5QN2H9x7QrKIlJuZnEOweY7sI6mtJ7
	qPTBp70JoZCHNt8a66PSSLQomPxT8zL5aGnrK+Ox5h774aY5Oi5dAuoIiwtnNUk8jIoQeD
	3rYxfP9LvF+hkxu6aPIx9nWrhvVQOJQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=p+ImZKNT;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf21.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [4.255.188.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id D877C20B716C;
	Thu, 22 Jan 2026 10:25:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D877C20B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769106337;
	bh=Zn10ZMJYtiEcPLf2ZuRuW6L/Fov3vMISENbJTbJv6Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+ImZKNTiJPUfunSUwmJEsSQtqwL15K6ZYgS2IPRZl2iWxj6Ikg/fmyjW/3JoDRtB
	 zw83fYj6Yz+HdHJ+DJlHQMQcbxAVJKEIFM8/esOsHA985pMONs+UuLOHAfxkmgfJwv
	 JkIQ2XvOl8MehFhiuRW72rgupSS1wEf/oEuKKG/I=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v5 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Date: Thu, 22 Jan 2026 10:25:10 -0800
Message-Id: <20260122182510.2126-4-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122182510.2126-1-tballasi@linux.microsoft.com>
References: <20260115123809.2257-1-tballasi@linux.microsoft.com>
 <20260122182510.2126-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3F2D1C0009
X-Stat-Signature: 6ujwyn49y7c5wkqd6dk9ymheih8gxajj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769106338-275021
X-HE-Meta: U2FsdGVkX1/IGzL+U3rHEglN4mftvK2BQY7tOeVN5qFlHwyiYq/48CTNGC7QOTOzpDYldTlLvkeKagDXNuwJZOm+yHXD9HRIj4GvDNDap45dQlBrcCIayNvkZLuHSFEe3zsoydytUdGxgRtgtfRusI4LhM8BuYtKO6eW9fBR7BuqWQnXnGAnMB5QZnm7hSvEzUg6YWVYSxSnFqkR/B6ezUtcfPAVZ2w17WHryrjTBmZixRHXNlSzJAdr5Y0P7XLXmia2fAqcorg99FAWA+SYkbf/ZNo1A1LcmHAQXqT+ost/IQPnC8KFQcV98ChSj/2hFRgJP2QHL5u5Q+yXdpuGj+m7MnA7kelSHf5Jq7UOYCJcdbI64IRqS0mTiakTD4mFiix8yvXUeRYOqJAMVTMpC+uvhV8pMsQiv53MpN8Dmm7hi4AxtMlUT57ivs+J6wAfBgMJsfRXtKjQx0rFjoUa+lG1NslPECq3XEEBCpaYzEmweir75ctgbAKqXX/z4rXYNEaE8Rp7hBM+/J/T6rOsduQf5KW0xTfS0tTDvdDWaDf0Axs0rAHc9scoE5lSzwh7lxgYXGwMW2QkVHxX58sPSZ6l2AlRHy+M5ZMBets4XviqK5YAIk1oZWJYKVMgPDUZLxkjjmf8pD9olnQmvmPJ0ARFI5bWalfZjtuqQajRc+Y3L/B8UtHZlBCDAzowaSPxWLS5XLV23o+oZYpNMyORFNj/0AFem3GWgyTCEersZhbJLprdPfIouJTsRHlXgKZnUtEREOBfoWRa9YzcEu+yk04zvAmkWcYw8yJSsrIvE1x88aeDtGKBFN3bFjPVHRiRW5426JWDCy+xQczRuWuGHUGbCWjboaNREYfSEE4dOClHKTCAUZWmqROqg4a8b/OaQdynz47vLGETU+Qadoo4vdfChLT0PfnwqA8Fqi1EUeFXNDv5TGDoNSY4M1VUTlTowIqEw5HpKb4ff8H8dnx
 gvDHyweW
 O2VoyyMheIJ2Ifp/L844mbI1IjoADE/ndGTK7O7Y3zwVELAzopm9myBwOrG29D7oa8uvgxUdig4d2/84W2TfLMeY9t2pm2jistljjt/KT0GI9kWZFLu1er2aZE6TKafmPCFuW/UEAsw1ZqO5rTxd3yfAwHmljqeBvAQbFK6sqPE4eoNp9YtQff3BfWHulH+4b8VFhRbS+m0J1ttaB1hKccnhvl4338LSZOS/eNxCh2qFn9kuNpRqj1Zy9ZkiGZRAtqu+TCL8ZSTlhtF5FISvT2wV5rH2S/CxnLV9R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The changes aims at adding additionnal tracepoints variables to help
debuggers attribute them to specific processes.

The PID field uses in_task() to reliably detect when we're in process
context and can safely access current->pid.  When not in process
context (such as in interrupt or in an asynchronous RCU context), the
field is set to -1 as a sentinel value.

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
---
 include/trace/events/vmscan.h | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 20160e79eb0d7..c7f7621e48af5 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -122,18 +122,22 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 		__field(	unsigned long,	gfp_flags	)
 		__field(	u64,	memcg_id	)
 		__field(	int,	order		)
+		__field(	int,	pid		)
 	),
 
 	TP_fast_assign(
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->order		= order;
+		__entry->pid		= current->pid;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%llu %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
@@ -168,16 +172,20 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
 		__field(	u64,	memcg_id	)
+		__field(	int,	pid		)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
 		__entry->memcg_id	= memcg_id;
+		__entry->pid		= current->pid;
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%llu %s",
 		__entry->nr_reclaimed,
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
@@ -220,9 +228,10 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
+		__field(u64, memcg_id)
 		__field(int, priority)
 		__field(int, nid)
-		__field(u64, memcg_id)
+		__field(int, pid)
 	),
 
 	TP_fast_assign(
@@ -236,19 +245,22 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->priority = priority;
 		__entry->nid = sc->nid;
 		__entry->memcg_id = memcg_id;
+		__entry->pid = current->pid;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->pid,
 		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,
 		__entry->delta,
 		__entry->total_scan,
-		__entry->priority)
+		__entry->priority,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
@@ -266,29 +278,32 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__field(long, total_scan)
 		__field(int, nid)
 		__field(int, retval)
+		__field(int, pid)
 		__field(u64, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
 		__entry->total_scan = total_scan;
 		__entry->nid = nid;
 		__entry->retval = shrinker_retval;
+		__entry->pid = current->pid;
 		__entry->memcg_id = memcg_id;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->pid,
 		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
 		__entry->total_scan,
-		__entry->retval)
+		__entry->retval,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
-- 
2.33.8


