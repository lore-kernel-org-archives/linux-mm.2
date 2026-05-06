Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C8DCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 08:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35096B0005; Wed,  6 May 2026 04:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE6A6B0088; Wed,  6 May 2026 04:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD296B008A; Wed,  6 May 2026 04:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC1376B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:37:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1465DA06D9
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:37:05 +0000 (UTC)
X-FDA: 84736340010.30.CDD8CE0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 489C22000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:37:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QSEKTZ00;
	spf=pass (imf03.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778056623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ITQMVtuTNnqVfa8PUokcDI98Exfd6k/BoWWKWfOl9xo=;
	b=3wxtAX0Kbc+qPYMVxAiCUjSXF76Duz/28wlQElosFdmdAkGApt9fdFalgCU/d25gBkO2qM
	X6P89bh/pU2j5NBs5R0zdUQj8ZTnXwIR5WkAO+JDfV8WSs4vgKq+h9sOsAna/UMTU27qGU
	CxtsGkIlJ7Bax7yx8WF7PSWHTNAdt7I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QSEKTZ00;
	spf=pass (imf03.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778056623; a=rsa-sha256;
	cv=none;
	b=au4//FanG62oVNRbCFlgKduGPtChWqcmTPEEWwWD628OpLCktvWNJOg4ndpWLF/8XT0kDu
	10Hu8HZ0apxomrwE/bX0PNJAoRvdJLQYyyQgRUteHf0whCFk0ckAFetj+IHM2/hAcjeQ7J
	kEA52JWT+pkIGw+vD/j7x/wD7q67z7A=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so4415919b3a.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 01:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778056622; x=1778661422; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ITQMVtuTNnqVfa8PUokcDI98Exfd6k/BoWWKWfOl9xo=;
        b=QSEKTZ00zh36nGemkvJ6gln0NA/to/HF+0nEXtKgGn01wU59YSkIUwzF67EgS99DL8
         13MIuKcNxhn2pjOAOCHTXbcxPTeX1waGBej4VP4+BYsseSDd9da7mWdiHdHqr7623kSu
         AJot+F6BxTIQgD+o4RYPyvNtUnPNT60Z07aW/NidWeTyHYxaZUDsUur7785t6jcDTfme
         Ij/YoJBAMB2KrnBtKS1+e20k8oiJEw7zVe/KWDYHN8Af55hbmD0AZzKzuJcnOkuElMZt
         tLcj/AN0SJ73pONGQSkDXHr75oQCDDcur/uNtGVRVYLgRzJRU9EQ1U0Du0Mq8CnL2DcF
         tOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778056622; x=1778661422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITQMVtuTNnqVfa8PUokcDI98Exfd6k/BoWWKWfOl9xo=;
        b=JW9AWFNswNkH0QamKnWo6YdEt7E6nz1niRCYqqIAsWNVmvITk+mLYEnjvH/o6/71dA
         6u2/bLMyGhp7J0WToHfIRExERRDa25X7bF6x3CXgwILvJpw/6Cb8ZkXMBkDXQ48fTvZY
         ooy2f5VfYlrdl2al0yP/a6B/gSpvwNi9E9Dnv2ajvrQ8b9e4V+0oGVft3osFWN6dNOo5
         UblV3UW50M8vEvACRabBZxvTjWgwNsGqQXUMrW1bPF3w3qOXx601/c/gznccirMIgha9
         LMKpqgWPDZr25Cdc+gW/+gQJSnSvPRZp4dMilbMPKZF6hR0hSkC0ObNkznpOygGcTEp4
         SoBA==
X-Forwarded-Encrypted: i=1; AFNElJ/1WOwAii1fcQuEyYwJSgNH7nC0f+IHEiO/3iO1e5jYvejDEwGiscRa6/m1Lx1l6jz9Y9wgVaF6cA==@kvack.org
X-Gm-Message-State: AOJu0YyzADt3yyvRSZLsVXwnTu7PTjONv1wT4/NpMoucLcpYzLBe4+iw
	mnFgPpIUX4g24O9M3yTupr5VvaZscb8j3bqYn4lUUIv8rka/J4Pk5sBW
X-Gm-Gg: AeBDiesxhFTEYsfcTvomAnZGwBPcH0lhI7xtILerm71j1xhT5UpVzHCmiteXcMT5HwV
	UEZFI16FmKOk4wD36Cy70KjzsxGDA0JM7TxJJ88J+5ZdFCRXPBXt0jxQr5OWsKQC+kKQxVyfomI
	+dgyPNUVbJxyaDDlhxsLflM10ff6IczhimvZZleMd09/fgoI1CB4Iv/U/1si7fUmyt25cBV6/FO
	rOn1TQGW9GJwYAtm1whRXVK4823kvh0kxBZZ6f4bAQl11Z4ZgdlpqiKrqzR9exAzPO70I/n8DXJ
	rNkBYo2dwUtKH7L24qsmwRDlSvkoi18UvnXhVBPZa9vdstH3QjZ6LBQne10+R+3RYEekVV7F9yL
	JRsyJVUhomDQcLvwahhMrZhfJaS0hb0uYVa3ig+Y5GsoyKDEWGHBhDYCjv/WBnkMzxLfzref2nH
	m8XXgS+rR3Yr6ysj8wdWgmGpxk51djo2N4Uor7ii+fBtBQtBk=
X-Received: by 2002:a05:6a00:198f:b0:82f:42bc:3386 with SMTP id d2e1a72fcca58-83a5c8b06f9mr2156160b3a.21.1778056621788;
        Wed, 06 May 2026 01:37:01 -0700 (PDT)
Received: from localhost ([154.39.63.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839682a20ebsm4949965b3a.53.2026.05.06.01.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 01:37:01 -0700 (PDT)
From: "qiwu.chen" <qiwuchen55@gmail.com>
X-Google-Original-From: "qiwu.chen" <qiwu.chen@transsion.com>
To: rostedt@goodmis.org,
	mhiramat@kernel.org,
	akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	willy@infradead.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio tracepoints
Date: Wed,  6 May 2026 16:36:52 +0800
Message-Id: <20260506083652.100160-1-qiwu.chen@transsion.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 489C22000F
X-Stat-Signature: ixqw1sxc3qhfqjauobc4uikbjusm4kdj
X-HE-Tag: 1778056623-814252
X-HE-Meta: U2FsdGVkX1/TJPHxn6PqsX8uCH5KjGM6bKK/DoyNPS38eZpxmVs5kr4tfjMumDOA2cEPQeyHaBD8+ZuYld7A1LimI7iPYws/XXdPjKRe5osiaasb4iUnQjbWuA9SuXLJe2DNw1+W12Mk725KPmWdEa21KLV8ZHF8tX03iqtU4ZDaq3l5mDt5F/4MVqJSa/o3rexNnf4b/XR0xvdgsswTnwbFa3kcUeJiJBkXA9aahnCV6vZ8nHjjYGJC7KaOCuIfesnbT2qrFOcyUp7CU8ZEJ/De7ThlyQ4vcukcXCd68Zsbn/V9vbE+LbE7d4cRRTa3KjmxcqPW3IR8GcZiQ5R0/PSdsMSZjz1Hoki753hdJgKN5LEAh+mwvubkknfNWPQYYbbgWa2HBFR+2SDpl0wFFXDCzDVBLANBix7pGDZKkSeBbQ0GOhMcGbKve79eM3pXH6msfREDXWxZNYpbF/OCe+7ZEbbE/P+D/RLVG9inIwRVzF1IxfJN/oJ2OEj6ERMF/fW9shH8FUSq12w/RsRdu1jMGPkCqo4Az8LzB/slRWHjU/xorRz3vFDY8SBeBAlGbuquljGGeKYgMWoDwUtML/2tuEjey6aTbELibRsw8CNcXOnnY5Ba+IKpVBqEuqG1abP/swKDC1+9svax8NIx3tIc3wTCmhZW+BvGZoE1qC9fC5DmjltAyT9d+KuhB9ackGRufySeJ8fFY4PxVbAuJe3BgyxLxYjBqcpK6XYGFAPJdCqj008iU7y7fnUR60TeAagMS9VdnaPOJwUeRbJDu1dScaEFRihRbUAFwtmjUlBbLjw0dQQ8XXZoxr14SOd1rMZFasR3qlbOYUfwjOHWWw+7Bu06K+f/G/2SAR0iCFmEfZJr1BY3ViJtd75qRJgYcYpgCd6FKmd9XI6HFLgYfDUUp31jRrRDHlM/4Pwuhn5oGwGf3PJCV9CfjZLD8FSRsgFOkp+RzAO0W0zssVF
 XFaNMTX+
 3JWUnCsodnbFYsh48wMFq0Cyo/E0grBHX70KJZ1NwjDfY6dySjEz0CtQ5NwfhS5H2o62YCjHWnQLd6iHtp0kb4EjQqpbnJ2sid8CDJYW4gXVjzYaKOpqPHxmiRZ3vCfAy1RIfvmaJg0eCcWGbCUgm2Q0XQjRRc0hY9BaItyPOrV85qh2jaW1QNCxYa0WvieithJdoWEbq5Y2rn0gitH/xwUhvG3mbxTumymZSLseZoPQQayyaLQCEF+YUXxsGAJq9OgCcVDn6V3uT86yHKTcoLxbFbZyndF12DnQ2vqhWgQ65wiz3kP/YpkhHNLBh5PiWcvGvOnmBC8p9nTH8KNSJ/HkIDzUWlqFzrSJzRkvQ+ZVP9fQjOZcuWUzWmBxpPmpziz/0VjVh1LqGrS4HxZzRbeqlermA5wv1e6ojRbhPTKdBtI+LYEA8TH+coU6X47Ut3dt9MydY2lCwerB4KaaiubiJxkZnCy9E9jS4AFEEWJxwWIXP1LoDJ4pklk5MucdzJFGFiGVbnptkNsTVkFqOOS33qz6EJBx3KG9k6i4pmIO0yVziAZq6rHPZ7zeE/XHcGJFATmiQvoW8nhkPCnMLuKoUqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, reclaim_flags always contains RECLAIM_WB_ASYNC in lru_shrink
tracepoints since commit 41ac1999c3e35 ("mm: vmscan: do not stall on
writeback during memory compaction"), which is useless for debugging
memory pressure issues. Other RECLAIM_WB_* flags are not used anywhere
else, so they can be directly removed.
This patch reworks the lru_shrink and write_folio tracepoints for better
correlation and analysis:
 - traces each folio lru type instead of reclaim_flags.
 - traces each lru_shrink with reason.
 - remove the printing of the unnecessary PFN for mm_vmscan_write_folio.

Fixes: 41ac1999c3e35 ("mm: vmscan: do not stall on writeback during memory compaction")
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
---
 include/trace/events/vmscan.h | 71 +++++++++++++++--------------------
 mm/vmscan.c                   |  9 +++--
 2 files changed, 35 insertions(+), 45 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 4445a8d9218d..e3cecd4b4524 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -11,22 +11,6 @@
 #include <linux/memcontrol.h>
 #include <trace/events/mmflags.h>
 
-#define RECLAIM_WB_ANON		0x0001u
-#define RECLAIM_WB_FILE		0x0002u
-#define RECLAIM_WB_MIXED	0x0010u
-#define RECLAIM_WB_SYNC		0x0004u /* Unused, all reclaim async */
-#define RECLAIM_WB_ASYNC	0x0008u
-#define RECLAIM_WB_LRU		(RECLAIM_WB_ANON|RECLAIM_WB_FILE)
-
-#define show_reclaim_flags(flags)				\
-	(flags) ? __print_flags(flags, "|",			\
-		{RECLAIM_WB_ANON,	"RECLAIM_WB_ANON"},	\
-		{RECLAIM_WB_FILE,	"RECLAIM_WB_FILE"},	\
-		{RECLAIM_WB_MIXED,	"RECLAIM_WB_MIXED"},	\
-		{RECLAIM_WB_SYNC,	"RECLAIM_WB_SYNC"},	\
-		{RECLAIM_WB_ASYNC,	"RECLAIM_WB_ASYNC"}	\
-		) : "RECLAIM_WB_NONE"
-
 #define _VMSCAN_THROTTLE_WRITEBACK	(1 << VMSCAN_THROTTLE_WRITEBACK)
 #define _VMSCAN_THROTTLE_ISOLATED	(1 << VMSCAN_THROTTLE_ISOLATED)
 #define _VMSCAN_THROTTLE_NOPROGRESS	(1 << VMSCAN_THROTTLE_NOPROGRESS)
@@ -51,10 +35,11 @@ TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_PCP);
 	{KSWAPD_CLEAR_HOPELESS_PCP,	"PCP"},		\
 	{KSWAPD_CLEAR_HOPELESS_OTHER,	"OTHER"}
 
-#define trace_reclaim_flags(file) ( \
-	(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
-	(RECLAIM_WB_ASYNC) \
-	)
+#define trace_reclaim_reason_ops		\
+	{PGSTEAL_KSWAPD,	"KSWAPD"},	\
+	{PGSTEAL_DIRECT,	"DIRECT"},	\
+	{PGSTEAL_KHUGEPAGED,	"KHUGEPAGED"}, \
+	{PGSTEAL_PROACTIVE,	"PROACTIVE"}
 
 TRACE_EVENT(mm_vmscan_kswapd_sleep,
 
@@ -361,20 +346,18 @@ TRACE_EVENT(mm_vmscan_write_folio,
 	TP_ARGS(folio),
 
 	TP_STRUCT__entry(
-		__field(unsigned long, pfn)
-		__field(int, reclaim_flags)
+		__field(unsigned long, folio)
+		__field(int, lru)
 	),
 
 	TP_fast_assign(
-		__entry->pfn = folio_pfn(folio);
-		__entry->reclaim_flags = trace_reclaim_flags(
-						folio_is_file_lru(folio));
+		__entry->folio = folio;
+		__entry->lru = folio_lru_list(folio);
 	),
 
-	TP_printk("page=%p pfn=0x%lx flags=%s",
-		pfn_to_page(__entry->pfn),
-		__entry->pfn,
-		show_reclaim_flags(__entry->reclaim_flags))
+	TP_printk("folio=%p lru=%s",
+		__entry->folio,
+		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
@@ -426,9 +409,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat, int priority, int file),
+		struct reclaim_stat *stat, int priority, int lru, int reason),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, file),
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, lru, reason),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -443,7 +426,8 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		__field(unsigned long, nr_ref_keep)
 		__field(unsigned long, nr_unmap_fail)
 		__field(int, priority)
-		__field(int, reclaim_flags)
+		__field(int, lru)
+		__field(int, reason)
 	),
 
 	TP_fast_assign(
@@ -459,10 +443,11 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		__entry->nr_ref_keep = stat->nr_ref_keep;
 		__entry->nr_unmap_fail = stat->nr_unmap_fail;
 		__entry->priority = priority;
-		__entry->reclaim_flags = trace_reclaim_flags(file);
+		__entry->lru = lru;
+		__entry->reason = reason;
 	),
 
-	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld nr_dirty=%ld nr_writeback=%ld nr_congested=%ld nr_immediate=%ld nr_activate_anon=%d nr_activate_file=%d nr_ref_keep=%ld nr_unmap_fail=%ld priority=%d flags=%s",
+	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld nr_dirty=%ld nr_writeback=%ld nr_congested=%ld nr_immediate=%ld nr_activate_anon=%d nr_activate_file=%d nr_ref_keep=%ld nr_unmap_fail=%ld priority=%d lru=%s reason=%s",
 		__entry->nid,
 		__entry->nr_scanned, __entry->nr_reclaimed,
 		__entry->nr_dirty, __entry->nr_writeback,
@@ -470,16 +455,17 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		__entry->nr_activate0, __entry->nr_activate1,
 		__entry->nr_ref_keep, __entry->nr_unmap_fail,
 		__entry->priority,
-		show_reclaim_flags(__entry->reclaim_flags))
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__print_symbolic(__entry->reason, trace_reclaim_reason_ops))
 );
 
 TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
-		unsigned long nr_referenced, int priority, int file),
+		unsigned long nr_referenced, int priority, int lru, int reason),
 
-	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, lru, reason),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -488,7 +474,8 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__field(unsigned long, nr_deactivated)
 		__field(unsigned long, nr_referenced)
 		__field(int, priority)
-		__field(int, reclaim_flags)
+		__field(int, lru)
+		__field(int, reason)
 	),
 
 	TP_fast_assign(
@@ -498,15 +485,17 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__entry->nr_deactivated = nr_deactivated;
 		__entry->nr_referenced = nr_referenced;
 		__entry->priority = priority;
-		__entry->reclaim_flags = trace_reclaim_flags(file);
+		__entry->lru = lru;
+		__entry->reason = reason;
 	),
 
-	TP_printk("nid=%d nr_taken=%ld nr_active=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d flags=%s",
+	TP_printk("nid=%d nr_taken=%ld nr_active=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d lru=%s reason=%s",
 		__entry->nid,
 		__entry->nr_taken,
 		__entry->nr_active, __entry->nr_deactivated, __entry->nr_referenced,
 		__entry->priority,
-		show_reclaim_flags(__entry->reclaim_flags))
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__print_symbolic(__entry->reason, trace_reclaim_reason_ops))
 );
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..4ee84db91635 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2044,7 +2044,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+			nr_scanned, nr_reclaimed, &stat, sc->priority, lru, item);
 	return nr_reclaimed;
 }
 
@@ -2151,7 +2151,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-			nr_deactivate, nr_rotated, sc->priority, file);
+			nr_deactivate, nr_rotated, sc->priority, lru,
+			PGSTEAL_KSWAPD + reclaimer_offset(sc));
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
@@ -4854,9 +4855,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
+	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			scanned, reclaimed, &stat, sc->priority,
-			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON, item);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
@@ -4892,7 +4894,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 
-	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
 
-- 
2.25.1


