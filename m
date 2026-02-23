Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFCAEC1112
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29A06B008C; Mon, 23 Feb 2026 12:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF5A6B0092; Mon, 23 Feb 2026 12:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFF26B0093; Mon, 23 Feb 2026 12:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5A5A6B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:15:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AD3D1C1C0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:15:56 +0000 (UTC)
X-FDA: 84476373912.04.14D3257
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0316910001F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:15:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=BzGSn2Me;
	spf=pass (imf14.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771866953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUplvb9mcjCqtiY4Vc6bwCc2M5ZxKW2qp6OYjQZvxDk=;
	b=wSUDE6NtF444dYST8bQ54IXB5olPCe0iX4FbjTDRAouFMz/UQCKuJFFKV6RmdNHtOrTYY9
	GZnTv2Gqv02WtXiYareVr4RaHWjWf23vF7JWfqFGZMhVL0Dhg7up/VLwTxr41ZMn7N/B1g
	D+ER24TesHmg/XH0sx3IVKrj1lkGQD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=BzGSn2Me;
	spf=pass (imf14.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771866953; a=rsa-sha256;
	cv=none;
	b=5SMSiQHqvhuetLpTXWXDAg6Ge6Q2GyUnqVYtdCwdL/XwYCYBuTtjvk3gTQx6vkv/sInCwt
	W/RM/89RMHzoLygjaYU02EPcbHPxSFiVYauMmIVn6OSD8AhJGky2k7q/pF5u0opElMRB16
	4lWkvaPSyWpcaynJNtTAnCuk0j8ISXg=
Received: from LAPTOP-U3CCR7C6.lan (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2FD2520B6F04;
	Mon, 23 Feb 2026 09:15:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2FD2520B6F04
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771866951;
	bh=pUplvb9mcjCqtiY4Vc6bwCc2M5ZxKW2qp6OYjQZvxDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzGSn2Mea1DCzUaQX4FnGBzWF8V5Zb+5TqtiFyyZOu2Rip3k1NG8/90nE2PRZ6HAk
	 B7N93NH0/n36AO1V0NJSIPDz94+O7wlPUiW+Yyak+iy8U8F17P72m5JIMp1DkxhX+v
	 R6AFMzz37t3hbdktYgoIW+WsmBvofT4r3oNp77Ww=
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
Subject: [PATCH v7 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon, 23 Feb 2026 09:15:44 -0800
Message-Id: <20260223171544.4750-4-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223171544.4750-1-tballasi@linux.microsoft.com>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0316910001F
X-Rspamd-Server: rspam02
X-Stat-Signature: k6mufb59h4zyg7ii3797s3qdut5m11ba
X-HE-Tag: 1771866952-268345
X-HE-Meta: U2FsdGVkX1+c7TUR1nFTiPQuhf2fhpfY6tBBrgvX2O22SvoXb8fLOv7MxpvsczzWNOXWteeGMars6T0ZH9VGWdO7MC0CIINIBV/ZJtID/IyIZ+b+F7xdHewoHNWCpfet3l2TL5UCJ5cyRyOCVHMNI40gCjQwXzjXjc+mOzodYD4CQCkmVxl5IiJEmzS4Xzr0lV+2D8cUv8IkJmW/7gVTl4ikRrAU2qOce2W37r0p/+75hvkuawVR3sYIDl9To0a3Rfk9JXZbb2VpfE0lU/wX2vvNyFXWmbJREsaaH0vhAKJmweItGpAkkhejzbiB/xezJW5Kc1ue/Ky0nuy+8Xvh948DJsKNWUMp+n37TjVpnXlz9vM+x9fKsCuo1yiIVBJG/vcfWMRhg5BMqvRGbwU1Fintxs+yo9CMkZgzw1eyV5PhuDIqBOYIxBDh1EWEYvL9zUViaDJrdZvBKEXSVVBk4KU8nTMvMOgqwmZL5ae/w+nhId943AVi57+EZ/Kedy/lAoQtX+CpGGcvm/rBKkukEypHEXGsl6za+KEFYI1xuA5uIUb1rZwHw+QBFebGcENwCQcP7vfi/90qO4xPDQUgkYMAFApSGapHR3Gk1ciBBSi7dqIvpxaQNWzyZVBONHRXWEKVxLY1T3Q9OtbjgMY4FanfZbp7ZeMENPUWugGrHjhekxpov4WU4cUtMdcUcHnj7L/UTxyIbevgMZrPQs6W3b4bruel8TxMechVrSHs+kJH9Al9/7APDtk8zNTr67VPIxPmsX+/8wuZpL0rQBx6SYJNvkvf/PEbP641VDNUydzVm8xXFx1T/jYwb7LmuJ472R79RLkeyUoxoJR/wy2YEsPTnLDjlURekkqLV8C/ueOFqHUfo3kyqyORldcaDbj7SmUpTlmqezCFFtdjpqa1ZOm2rlaGlt5IY0C9ycoR2Up6dkwwa6X0LJwEzjyaOM0zMkRS+zfl7F9L4iggG3m
 uv1gLAOt
 P6c4Hq72pIlP9lx3TDqVTyUb8wdOqfDkODD/W2OeMhb3eWyPsSWyN6BnwZzDRXz7opJkEePUUug90pl9cgj3M2uPOBGsfOPTIpwG0Xq8FmpfWYDy+QxAFW09WwxJ+SblDMIAAQVCxGL30CccmN1yuwtCpg3FFimseuipSUTcHFY4Yjfdr/nR2qN7RHdaY1D31s0zDvntkF6ovXXxZZzE0GF8bzVRjsb/z2jmREj4FkHk8DP+0y+ObRHgbRT/TOQOBsx0ZO71px64fYTfYI91526j+tHg/B13pZI3ZzKIwtu9Oizw=
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
 include/trace/events/vmscan.h | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 1212f6a7c223e..15b31281f0955 100644
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
@@ -266,6 +278,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__field(long, total_scan)
 		__field(int, nid)
 		__field(int, retval)
+		__field(int, pid)
 		__field(u64, memcg_id)
 	),
 
@@ -277,18 +290,21 @@ TRACE_EVENT(mm_shrink_slab_end,
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


