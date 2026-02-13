Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D320EF99C6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 18:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4396F6B008A; Fri, 13 Feb 2026 13:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0A46B008C; Fri, 13 Feb 2026 13:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5736B0092; Fri, 13 Feb 2026 13:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E47B36B008C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:15:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76790160576
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:54 +0000 (UTC)
X-FDA: 84440237028.29.7D995B0
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F2AD100003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:15:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=L8PcBBUp;
	spf=pass (imf05.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771006552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzDLW6fNX5QGjvcmLpQsGNmnk6vWj41/MTxmEPnka/0=;
	b=QZxDuQVs9W1Srvt2uO9DyIbMRVfTYsX17JG3yxKZvM2QbUO1Q3e2jyPQetleK8DnPckeJ9
	Zn9Yda7fw7XEuoWpnr9dCx2so8m2Bca5xI1mB6ErMW5vrByf7BsgkonL94Ht7l+ywgccir
	1gOMI0rIfpVKve6gI+M0VLh8iE+0JJk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=L8PcBBUp;
	spf=pass (imf05.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771006552; a=rsa-sha256;
	cv=none;
	b=qOcTeWnmuAgLCY05RkR0tpfEwbqiZy6vH9dHv0zEdpBgceKhWfj89uJlE4fPVsl526jrwj
	HwZlW6mOPWKNjq3TNFveh4tUzwIsVVP8ORZRxzjRbSRaucDMRPeWdEYWq2jx6M0zNLbaSB
	Y1urRK0bemUe3ZGE7mtZipzixPXIlJs=
Received: from LAPTOP-U3CCR7C6.lan (unknown [40.65.108.177])
	by linux.microsoft.com (Postfix) with ESMTPSA id D2DAE20B7169;
	Fri, 13 Feb 2026 10:15:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D2DAE20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771006551;
	bh=FzDLW6fNX5QGjvcmLpQsGNmnk6vWj41/MTxmEPnka/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8PcBBUpFdzvHPFizxhcHhG5EqcDUKZshr44jWAI7HgmkCmexyLoIuBGSPfTuIefc
	 nNJ8TmZ1biEYvqeRza5qzGS6e3VnLdoOd9vcJvoct6jqfCXvubWT97MoiShzmkc8DD
	 jZZxX3zhxlthN9Rk3R9xpkO9yFFJSAJMCPs4FL4A=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v6 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Date: Fri, 13 Feb 2026 10:15:37 -0800
Message-Id: <20260213181537.54350-4-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260213181537.54350-1-tballasi@linux.microsoft.com>
References: <20260122182510.2126-1-tballasi@linux.microsoft.com>
 <20260213181537.54350-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F2AD100003
X-Stat-Signature: rjndfbhbphiszhzbeybz4a3u6pc6fpgj
X-Rspam-User: 
X-HE-Tag: 1771006552-823873
X-HE-Meta: U2FsdGVkX1/814b3sxOVWczsgLqnw7MvBB88NrgaoX7OWDD2Eqy3N2oPHyniS0Zyr14U13ZxHGkDlF3JzrPZ054VqPQhzXWbGOcF4S6H7IEDOTl/agUhruSYX0Fe9g2Z7rV6D85eGXhw+dkzFhk8/l8+SpedXwGZvG2SxQ8OF5nej56PJQP1dOZ58wS3CAW7VKF+2BDg59I4EmvPoy0Hyexq1W5vsX7FMGGhZL8j+C5OVH8pI7z/7MQPuKRxa09hY0csIDvO27UAFjpHdo/h+Opa4ho7l/OiZd8X6zx/gca38XcMqVkSlw1feJqNcQaZ3gP03ubGwmppw++jXIgYZvD0KkCDbUk5Pwfz0yCndp18JNzeqycfRFC1WkqSXOBI5OY1or9lj9oDRUfhXoIZ68b8IH5f0boL/C3hZm3TB3XxbJzeeMbmlN9Bl45/jKpDkMYW/fGcSbXwJ71j3mGoIPRITxHww3lREv1Kk4820pkhatdLKURQvzgFZCDYDJP5UxArSCeT/ratBh0mJIS4vZ/HRsitAah7xt2mbt60DBtFKVjupAYy3ZZmohc52ceaEGgkM7ZW50AUT+SClliPBQIvlCojxkR1JuJ9zrmlMBI+8Rqi2iuwby7DU7nvDFouTeU0Z2naE9T+klHKR+V9HBWBbxFoQa6Uzi3N+wKbNgbkpex2XsCNvoBK1+mBPv7EDUPzlVMWH7zDEawilgVLo+SeYKa/s54UTzp/h4BFubIRZDxlZehiF29vElCFjv3oHYspBHMrlkHRIKBuv/UXl7goXnd+vBSZdaY/jAiL+480HyxpUmNFAWqO9mu3FYdsuDfALNdfyo8S7BbouSj0QWVbSUp2KOso0PFlFU3BX9V5RtsIiRblEbC5Tc7Edvnw7dfU1x4cDD9V7VgBA4wHg62JG8KUzT4BNjXVty5TkOpbBUFg4bWHM/WdNwIkaoLAmWB3O97tBXOqvP9eRMt
 dJ+msDe3
 BBJ5TnqlQsRJEtToPn1DCzx/xp7ITR/jkq+Y/J4Xdk1zDZcgXl5iTQHD/v35xMX3f/xn1o/MWWmul+84ufr2NR1wSdjiTWWNOF/Umudsv/r6BVzPDRiOp/PEm/90wVOqy3g8/5unLPZFk61wBZC9lYeoiAFFxUNKA7gKcPOa9z+JHNM+E1BYLI4ChISIh2QcvYgF+RvzURAswoY7Bzx0itMmPZ8M2UBagKKv36sUPdhZ55wqh6YsIRnGkF0lxK92+DIBbjV0/tniaQ6FkGtDoHXOjVXArj7ry5xzDwEqqS10Jqdk=
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
index 1212f6a7c223e..a68b712ef757a 100644
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
 		__entry->memcg_id	= mem_cgroup_id(memcg);
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
 		__entry->memcg_id	= mem_cgroup_id(memcg);
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
 		__entry->memcg_id = mem_cgroup_id(memcg);
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
 		__entry->memcg_id = mem_cgroup_id(memcg);
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


