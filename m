Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49770C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE5C6B017A; Mon,  5 Jan 2026 11:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144F26B017C; Mon,  5 Jan 2026 11:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088CC6B017D; Mon,  5 Jan 2026 11:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E256C6B017A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:05:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE619B6F12
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:05:21 +0000 (UTC)
X-FDA: 84298384842.21.2F54CD8
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id E33301C0004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:05:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=faemh3aa;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf20.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629120; a=rsa-sha256;
	cv=none;
	b=F6DBTW+7s267etsOmV0XGWFmH9bjnA1iUQXlsj/dKKi6/ICGPCjjuf3fVP5XPsWUAIq6P+
	qH7jcZwFvgBalh7BnoxytAKU4dFgZ+IXrOX+kUux3rBsg7qGEuqWGKlHbHro40Q/Qha+bD
	sCe+clxc+dnQr/wjZJJgrA41C807Clc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=faemh3aa;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf20.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/FTPDvAe0kBCPN0cxH7L3pGPOpB1MWPz7S11VhSCwY=;
	b=cH/jAQhq1IblojYEiUGbDgac5gH9YmqHcHl8RTfuNktQLuUl42eDNa6UCHKIUTpE3I6uXr
	TjyR0lrp9IGIx6w002D/iRqTZIjPBClX3Rv47eRE0fQ19lnqi0vklN+89l87Y1g1F4LjGP
	IQ3oWj4RyHDhFYlZNf5wkbZohKFX/Rk=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [108.142.230.59])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5976021260DB;
	Mon,  5 Jan 2026 08:05:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5976021260DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1767629118;
	bh=h/FTPDvAe0kBCPN0cxH7L3pGPOpB1MWPz7S11VhSCwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faemh3aaViYAj6Uua4LMH1ma42MSRKm+E1qg7J2vphI7woGFFz/AlV0t6kcA1ozrx
	 XvTdlgMkeTAY/xgYMMp7NhSctV+chFLmDcczPRPVrJ0T4X7xf0cpsKEJ0bncc0BEao
	 0C49wXBtb/XgLiqqDGR4WqLfjFaZVCrYV6fevUGE=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v3 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon,  5 Jan 2026 08:04:23 -0800
Message-Id: <20260105160423.23708-3-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105160423.23708-1-tballasi@linux.microsoft.com>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E33301C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: n5wzatoz59uxp567nta4re6fmop4rxnw
X-HE-Tag: 1767629119-101047
X-HE-Meta: U2FsdGVkX190p6O2Hd3QSKO3ktfnuNsof1uk8DKJDcpY0Mjgtukie2m9IqPFO0E3xJkKRBdWYAJ8AczQsJygQ1dVNJoguOrxb7tH8C8DjaGKbdtlIq4358N89KImTg9ExVp/w+AwhCuZNurSXQINHolJ8fMNgfxpYDsLPpt2pn3dEqz0H4uqom42VA2J1+9Dc9RQwQszKpDy9Dd7a8AqEpYq0KaRhua0uGZ1/QvZ21KaoKz4ICWkqvkRmk1BYgSnauHgQaLRDLUEazcCZ1HI8oKfYhlXQAPdx9yFGmtKnkiY1js1OLh9tsxsFXFP24KnDq7gwC6+LRonp9EGpZ1jlwuTmFfl74dEMmPi91gJ9Jqd2/C5BWiFbvqQqT6x5D5W/JC+3DgV9bMFBffWQiCMTOfzNgWzqobbSQIltYv7SGXJWYZ+P2sxOAcLEYmvn362Y4yKbvzdHOOGTLxmg3iNim8zAv+GC6xKYw615TNLLa5e+WCqFNr4xYtxAxXUJ4ycmA8xSLgVI3a5Rgqu/4fcBuMP5Nba8y4rQcoqndhw+Uw7OV5dqMIdom/S20ppd4465ghGJ4mkRYKZTHSVyk4TNHLxL8JBxj3Bo47KA8IRThcjzhE67c3mztqQXLovgckxuH9acShCh9W60QkILIs5F/l35mf2viHXOzFjfUbnOLH9sMwtrMGprLpqUud4iNlBGviRsluPIC6jj7ZmSAId+aFZHzM7RvznPcSQ6Sn+mZtF4p6+T46CEz/QpnTwgA4z+qFC0AzIk51fAuaYVwX0UKL8LRmElL0e4VG+zR398d2YNehkgYBMjF2TxTHD/1vENdRMO/FifwwM8SJfymK2ZMHzftxHpQCgHIPcimUKq3Ge7Jj2SAEN2CWs3eteVvaKiAzHTL9MHCkdPoYjJwOnL4eIUtav92z1ZxWwhAs05+5P7NB8zUGNu6ZvBdB+IqsIotiIm23l+gCk65K2w9s
 9Cd66ARN
 BTH//OiI+4zlXzGc=
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
 include/trace/events/vmscan.h | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 93a9a9ba9405d..d438abfa03ebb 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -121,19 +121,23 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
 		__field(	int,	order		)
+		__field(	int,	pid		)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->order		= order;
+		__entry->pid		= current->pid;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%u",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%u %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
++		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
@@ -167,17 +171,21 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	int,	pid		)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->pid		= current->pid;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%u",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%u %s",
 		__entry->nr_reclaimed,
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
@@ -222,6 +230,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(unsigned long, total_scan)
 		__field(int, priority)
 		__field(int, nid)
+		__field(int, pid)
 		__field(unsigned short, memcg_id)
 	),
 
@@ -235,20 +244,23 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->total_scan = total_scan;
 		__entry->priority = priority;
 		__entry->nid = sc->nid;
+		__entry->pid = current->pid;
 		__entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
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
 		__field(unsigned short, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
 		__entry->total_scan = total_scan;
 		__entry->nid = sc->nid;
 		__entry->retval = shrinker_retval;
+		__entry->pid = current->pid;
 		__entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
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


