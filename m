Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39C0D4117E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A9D6B0092; Thu, 15 Jan 2026 07:38:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162596B0096; Thu, 15 Jan 2026 07:38:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078406B0098; Thu, 15 Jan 2026 07:38:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD6A26B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:38:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC4B813A930
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:25 +0000 (UTC)
X-FDA: 84334151370.21.4596C0C
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB92380002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:38:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="rapo8Ul/";
	spf=pass (imf02.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbI0FyXSbb6YAmZDeYFsFgsBILt9uByw9OReMAxXcLw=;
	b=fm4QCzKn/bEXjMZs1Es79wqNBmMEV17NDXa51giBpF05wFTgkDVt8FLB+p7lknL05D+Lse
	+8ESwbwP5IC1CMBu1pak8m+w+fBH27HwmPC5z2hyH1YnalQkK7N+fgVXJxp6yNAsBWG7mm
	Y6VPxAovmSgydvAqtsPeCkP1h+9S8Uw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="rapo8Ul/";
	spf=pass (imf02.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768480704; a=rsa-sha256;
	cv=none;
	b=k3DBjEJ1USSjhLWgWtiS6mjlAHXePiFb0HnBPxyNhMgtGvHJUHBLvcwj/ErfC0X86IVjmq
	gvI/MAROrTROB7UnGaxcIKtmJGnFnkG+IzEHWpTOLa1mubx0p+53XaJxoA/RG0WkphU3Xs
	pJPBsXunl79Yz7PI+G+iEkP5x0+7+6k=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [20.107.46.209])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5CDEC20B7165;
	Thu, 15 Jan 2026 04:38:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5CDEC20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768480702;
	bh=CbI0FyXSbb6YAmZDeYFsFgsBILt9uByw9OReMAxXcLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rapo8Ul/uEa5jDPQ8S6WmuQBVUYyNDQ/plF0jMu+OJqfd+nUo8/AXNNyV6oGHzmVj
	 hYWKUmKi57O39oaB/eXc4xTpqRMdVk8kyUIb+JOc+atFw9ezbK0+o0oNFoWwGXXo+s
	 JVsqI9xYHs9JKlatmx+1rYTPPeV4gdBa++0xuQUM=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v4 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Date: Thu, 15 Jan 2026 04:38:09 -0800
Message-Id: <20260115123809.2257-4-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115123809.2257-1-tballasi@linux.microsoft.com>
References: <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260115123809.2257-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pp4t9uyw8zmzis8xmobp8wfqs4yrienr
X-Rspam-User: 
X-Rspamd-Queue-Id: EB92380002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768480703-152907
X-HE-Meta: U2FsdGVkX1/wQdP97wvpWxtDQMRJQRBrI8/ifWGQDM/4SsViCO7TPit6YZG32EQBZS4E9RsnmOLwHdJ0GP/Iapl8H7mHQVbtdLWwVFeYWHUtolbIxyp3Y0y8mVW9WT6ztcxDMMkMBrztwngtALgwguWICO5nx5u0rO4BWD3QEGc5f1KQ/j8QF3NCJWvukgLBHgr3CKMJT/FMN/n+jqbqZu54t3PlW2zbr3Apckru+hlYBEkaD7BdFMPrI8fZ/BT61oJ6GzvH+qqmDG2G3VnX89/yn9NTw8zKJvP0m1pCTpAPblvVwC4K5aS+pcyy2TuBYCNo99IVkM8NX5jmOQ3GKDgUBL0Z7akeE7ZvQM0D4VdxtUOCseZo5qN7sQrQVJ5MpHcdBfDXSC7/v4v8s8rrIsES96Zvjl9jZhkTDUUSdl6uK8buC0ZUYFtQ/PU1MsVI6t5J1XI91BM9f+ITKDH65MJ0qG1njTBqvijA0yREBFVOCodnZA7kLauCPw3OuuwGttmc7Mu7KL1SLFbRbstAmJanlwF20wzDXr0e3m18jTqNo7TvHJD/JA9oNhdpmbBcy0MjdkiM+Tiyr4Ppr6UFV9U6U1lDf1wdG1f95aH79dlzXCQ6TJOyW9JX8VTD+MZJrn0LaRxdWyvThJuMfjxCm72UJg9WY5QcSnahwgCqukwTkQeQMnViXXyoo7zeMmMd2BJhnX24BeRrg6bg1P1jPfj47F/1/SQmGj/te2cIRuuRcSY/8fxwXof+1kNdPUl6imKmHMEyyTrjViy+ktXAH2tejAf7pkB82U0E1OtqCMEWCqX36efuxv8CSj/YL9prv++yYi8h59E1Qdmz6FIW9zjgp0osD/bEww03Auu58HvedBCoo/i/Ma8fBGcwCTAvnWHIXmZ4LTTWLmRHhIINcZNEDsQlhSaqBRRMhSvoZ3UvgpnpSlV24Ef7sFIS/SqfDci4ODIm0Xq/VnC6ALn
 vcjb8xGO
 La7J8VkJeZ1OtFA/FQfwHD/rXnU3ujZzLWYOb2WXrNJislfXxQZOtfVWvSSbAM5XXG5d/dMylxwJF8qvwm9kU8auJcCxZEBDWHewOy5yF5i+aGlna9gMM1VVBRysPYWFBRKQCNCC/JM4qEx0TVmIAwP8buGd3lN2gaFkZjJmDyR+7fIbris3F+nCyoyoLGACs7lx6Xm5cPJl4RJEovjQ5PBsrfpO/g32WBkDSu8zJ/0TZkBpbNzd+QLOdosF9GmJ4zyBdMeVuzJlSyJZ1aAwD5c1+lxKuOzLVZuhG
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
index 20160e79eb0d7..288589e3364b0 100644
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
++		__event_in_irq() ? "(in-irq)" : "")
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
++		__event_in_irq() ? "(in-irq)" : "")
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
++		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
-- 
2.33.8


