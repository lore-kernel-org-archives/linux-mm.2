Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0D7D5E15A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D2B6B008A; Tue, 16 Dec 2025 09:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19CC6B008C; Tue, 16 Dec 2025 09:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6B36B0092; Tue, 16 Dec 2025 09:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB9206B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:03:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43C3359F16
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:03:35 +0000 (UTC)
X-FDA: 84225501990.09.54655A1
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B2BB20018
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:03:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Y9N8buna;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf03.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765893813; a=rsa-sha256;
	cv=none;
	b=TbkFJqMOYXPSVq0IYDiRslFPub8zYU9WmnPtHmHdfIJJCRsz2qkKCphR+JTwBZZ6jhqXtc
	VWG356ltfrFRXXDe13Q1R/VnyFYVsLh0r1QbbdLHsSqT0OPrmQF5FuyPQUEJfhys6Vz+a5
	rTCeIJlrgJsjoI9eu/gBNY/2/58w7fM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Y9N8buna;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf03.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765893813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j5utBX4YaZFXMornXvVJFK8v9wGb1f/34l9iOWO/8o=;
	b=e1aL+xR4ENGQNFrHVkNTU6w6HGYWSOJ8fxEMcZNIFxMJ+0APGL98TG9bnKKYzX8JOLru1O
	3l437CuajxG0tFdpZZcW9wXuy+75O9+qo1RUUyqZNldbRwR2ih7hKSEiHZnAzITlBTq0Lf
	Fwd5dSBHsZwPUpQnMBcEiQeQrUDDfxY=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [40.68.199.203])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6BF6D200D653;
	Tue, 16 Dec 2025 06:03:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6BF6D200D653
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765893810;
	bh=4j5utBX4YaZFXMornXvVJFK8v9wGb1f/34l9iOWO/8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9N8bunaxylY1ELiOjPh/ejm1t6KbVpf3y6rx36E/2boP5hz0Zs9HrwjtBhY3cFb3
	 rhf3UbrtHJCiaWwapSAqfg+VkG67pJ9hVV+FATfsU1LHWkMsp1ZQzADk8MmbZEdCyP
	 h2IYzkYZTddQqvPUkQU41y94bo/VGc/ex8bZ6GWs=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Date: Tue, 16 Dec 2025 06:02:52 -0800
Message-Id: <20251216140252.11864-3-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251216140252.11864-1-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
 <20251216140252.11864-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B2BB20018
X-Rspamd-Server: rspam03
X-Stat-Signature: bago5ti8duwceg9a7wwq858ffrdoo676
X-Rspam-User: 
X-HE-Tag: 1765893812-652572
X-HE-Meta: U2FsdGVkX18OUlyfl33cB4yVSmspu+UoztDqKCPsATxXAQZCCkEmbyB6lv/NP/INEzYei3hw1mbgtWQlH6UgKyM5SzYWzdvBNq43e2ZeUmnj23KI542dVYoXTNZMrBO/huh60zRbDHLx8b80f66l9uj/lpOGkG42KjomWAD3Q9Y0ajxJngVocGIbsSWcU1T9ESAaJjmXaAZJ0Ci78eNe5Ys3AIW3sg2LM6040L78SJt4RM6w4jYw41LI3htyrD2uujvjbzepubzTpAwnM7an7VMjkIUMDf4Gk1n637gC/uZHE2nhvFliq6e0zLY1v++jKe3dJUMPMCmhH8FIxYFRLi/NaYjNynO1mdPQXn26RrKUOsuBXrdNvpKYyiB3AFE5l46yBQrFF1jvBIaYmzud40XxHMMPjPJnjGl8WwbWvzocCkdaSZ5iFzqeoIX3LlnGQvvQxTAoAHXZklYsTJauvQH/tTEPBccNfMJYogu/X+diS8jw/4OPqzy44oBDP7vLRy0H/yXstexkY0L9T/6nWeaoc71g5gJBkBFS+enjJGQeR+ePdb9kWmTyqbJGHeiIpteQ0YAJyKuFv/6VhZi/QTlR5cDIDtMlTs7qc3OVD+8Cvlu9pvWNIjhjQQP2mExB95VGi63kf9FS2+cwHOODD5JS9vzUBAZ3yftiLe0ekmxQreyEi6BFAi8bCtTnIMkAfl4Xnsxd6dZCjbeLe4hFZxL8datDlg6bk8b4U/GGfcg3a0m+k26JAA6+TxG7rWdnviTSAANCNlX76u2dPxGX6nn+6Zz/tinFteo6Ise96fVy9Uru+ZNQzh53nunVzqfU2TDW3pJQvXMn+f7mdDh4CeLXYBXGj7fq1vDOYK0pqG91IiH384Av4XuevkBRr242fzQp67lQGqLKgVk/F3X7jsfetS8AVmpSRBXCj1cJdYZ5EDVBKLuY4tcZziDZr0TN/oAGZAH15smF+jhjxm7
 ZraH47+f
 zB3QC23pk/DNdKZeIDMA3/6fmYb+AKIRzXC+Q++r20OMGXLyxfGBV1UjGx9cCvfjndjU5Iw/yVKWqLKnE4GjKQ5jLNE54It98Cd76xDQn7QRKa2Iz7sMkDTPqr3Ti8icTnVfiBtfs55QNE9hwuMVGWak6GQuANZvf86X3lqAtK5zZU/NhV5N7e+wO70Hz5pG49sx1TfXV4Hn0g1llBUnKz8TTwY81MhPzdfmXbgRd2u4GSHYhTMF3CoZEBj1kIE6zV+nl2e8B681NSQAAz+KuTwhLMwfirtaRCjHQ
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
 include/trace/events/vmscan.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index afc9f80d03f34..315725f30b504 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -120,19 +120,22 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
 	TP_STRUCT__entry(
 		__field(	int,	order		)
+		__field(	int,	pid		)
 		__field(	unsigned long,	gfp_flags	)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->order		= order;
+		__entry->pid		= in_task() ? current->pid : -1;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%u",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%u",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
+		__entry->pid,
 		__entry->memcg_id)
 );
 
@@ -167,16 +170,19 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	int,	pid		)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->pid		= in_task() ? current->pid : -1;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%u",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%u",
 		__entry->nr_reclaimed,
+		__entry->pid,
 		__entry->memcg_id)
 );
 
@@ -216,6 +222,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(struct shrinker *, shr)
 		__field(void *, shrink)
 		__field(int, nid)
+		__field(int, pid)
 		__field(unsigned short, memcg_id)
 		__field(long, nr_objects_to_shrink)
 		__field(unsigned long, gfp_flags)
@@ -229,6 +236,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->shr = shr;
 		__entry->shrink = shr->scan_objects;
 		__entry->nid = sc->nid;
+		__entry->pid = in_task() ? current->pid : -1;
 		__entry->memcg_id = sc->memcg ? mem_cgroup_id(sc->memcg) : 0;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
@@ -238,10 +246,11 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->priority = priority;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->pid,
 		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
@@ -261,6 +270,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
 		__field(int, nid)
+		__field(int, pid)
 		__field(unsigned short, memcg_id)
 		__field(void *, shrink)
 		__field(long, unused_scan)
@@ -272,6 +282,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 	TP_fast_assign(
 		__entry->shr = shr;
 		__entry->nid = sc->nid;
+		__entry->pid = in_task() ? current->pid : -1;
 		__entry->memcg_id = sc->memcg ? mem_cgroup_id(sc->memcg) : 0;
 		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
@@ -280,10 +291,11 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->total_scan = total_scan;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->pid,
 		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
-- 
2.33.8


