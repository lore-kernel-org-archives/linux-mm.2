Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 441F7FF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 08:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826066B0005; Sun,  3 May 2026 04:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D71E6B008A; Sun,  3 May 2026 04:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5916B008C; Sun,  3 May 2026 04:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 599046B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 04:57:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC645409BB
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:57:23 +0000 (UTC)
X-FDA: 84725504766.01.F74521D
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 259EAC0006
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:57:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OK/P2B/N";
	spf=pass (imf28.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777798642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f0TXFebOBkrQFdsHKAFpCWalVWtLPCeNooD3w1aSjjY=;
	b=GqtvYvTDVqt8up9W0/JJard5RlLLsoQUT7E3Rw3cIfjcy2eGMTX1f/A3sRQpBmOlGmK3GE
	gZ9R35VzZ4x46lcZIveeDjxA00GkKh3ujBY9Mj28Tb/db7uLwttKHPQdj4OuNiXs/4T3QE
	mzNUcgz865a7tCeLY5yX0/0bN5CqX0M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OK/P2B/N";
	spf=pass (imf28.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777798642; a=rsa-sha256;
	cv=none;
	b=v7d+NRAIqyBDmwjaqzdD68Yz92jzpKe0RktL2HH4qWcAUpJTcxmisAf1RLSH9jfLiFCR+p
	IbqcTWPpRGlMteykaYyhPeici2+9UV/4mFKk+VgigAuJmRcD7gh9wA/HrGpnNr1WD5zktu
	D7M99ahqVyxeAzugzcrntghdkrl4Fyg=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-365312a27abso281968a91.3
        for <linux-mm@kvack.org>; Sun, 03 May 2026 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777798641; x=1778403441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f0TXFebOBkrQFdsHKAFpCWalVWtLPCeNooD3w1aSjjY=;
        b=OK/P2B/NTmd+YjRdWx1Thze7GdthA+YJMVQ3wtFXUrxOwFJ6ZwSLcLjAgv66FHzR1t
         7Qv78DL25QKVkzo9mFUqPFonu8lkS0ZXF0Hi19+PsDwJa2N+F3oohR0O7YdHmmOxcMly
         rdQdJmWdsbyjmyUMLMQKTS4pPhtLIz8EX6Gwcg7UgMAHtaw1VQnpRTECxfwh/eKG7uu3
         4ye+1rjb1Z6skPcvKnUtds6877P3sZ+8PGvncoPncq84KZDW+Rds8eXP3N3CXKA+aJgg
         ubeT/qRzrTKROEhteMrrNMaKN3X+M47JtyNRnkPh1fRfatXtfKSolL3+fcFYrrGoII+y
         ZxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798641; x=1778403441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0TXFebOBkrQFdsHKAFpCWalVWtLPCeNooD3w1aSjjY=;
        b=Q76W6iFhnjCxCWJ+c/EQnrlaYyz18rug5vX+ISiwtTQJErJ32C1xrnKAmtfSpOOuED
         yxJ7Vu0moellnJd28Pj35XUdAUyDKIwFeC6YCKqf0aTRr6zyQxnbgmXuBizfUK1Oep/M
         P8vNXK1TIDMMId60obCJe5ujS0y/ynelx398X35OU5st87dYeawZh0iVZ3+gLCHgtvpz
         bYIiGSZ2HYUYpr2Ldwv4EKOS6ElfXIbWSpFF/MuMzKhziF85Au6eWU2G7jXtbmqhuAJN
         CaqzXe6hi/K7Pogn007VJmhx6wfhj80+l8aIwVhDwXwScz1AVv4xN4hKSlUykQBUz5oW
         KWGA==
X-Gm-Message-State: AOJu0Yx8WnTuCw4TKwn10CTPyLq3No2UpqTrhjVzf1CVUxUn0tpJW4j1
	CUttfNdCgVrOjAsZmZm/wYtH9orbLPpzlxhlf354plAB5c4/QQ+eanvX
X-Gm-Gg: AeBDiesaHcmwtGFGtXg6m+Eo9KB0NCCWj4hUvuvlj+8/rQpT+uSNXZ+B+ZK6T1eib7T
	S6r+IaAoOpVo3HVq67ERwz1CagHcqABh7QAdNUvxUzU8M+ZdMqK2M+qtnVqG5wPxnEWo2U13aEA
	k3Q3WzdGsO6nPF4rR2shKUv2fuOUQuOA7nXMw/4NbV5HNDeTJaaJB+FLkZEVhEmAjUKfxm/eyUY
	xnX40T2F+0dDRbrT7Mc31in6Tih1xkeFabn9YAn6cpwWwUqJhST4a0uJOoTiGogzRi6rRTEqjaL
	lX7bP+Eu+WbQGi83IZuumy0D+ZVxkKsjI7UTC8U0t0h+k8VUgZg09mJJ1j6ctvKnFfu2rGscX50
	IAw6gK3kwuJ+mJK3deYTRBwmDdwPxnCa9z/5SBU2MblSeQPC4ueSHj9R7maWsOvDh3MWfRFoKXf
	4lQ2jNJHM2gYlndikxM3VZMYYSBZ+XoJJ56kceA/l8EgdYJV6NLg==
X-Received: by 2002:a17:902:ce11:b0:2ba:1202:4fc8 with SMTP id d9443c01a7336-2ba1202525fmr16484315ad.17.1777798640858;
        Sun, 03 May 2026 01:57:20 -0700 (PDT)
Received: from localhost ([183.227.123.133])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa7e791sm70589365ad.7.2026.05.03.01.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:57:20 -0700 (PDT)
From: "qiwu.chen" <qiwuchen55@gmail.com>
X-Google-Original-From: "qiwu.chen" <qiwu.chen@transsion.com>
To: akpm@linux-foundation.org,
	rostedt@goodmis.org,
	kasong@tencent.com,
	mhocko@kernel.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	ljs@kernel.org,
	baohua@kernel.org,
	mhiramat@kernel.org
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: [PATCH] mm: vmscan: rework lru_shrink and write_folio tracepoints
Date: Sun,  3 May 2026 16:57:05 +0800
Message-Id: <20260503085705.3276-1-qiwu.chen@transsion.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 259EAC0006
X-Rspam-User: 
X-Stat-Signature: 453hpoegm3ugw53us19ncrn1yumd6kmu
X-HE-Tag: 1777798641-889310
X-HE-Meta: U2FsdGVkX1/sQ2HX9BTggavqyLrI5Jfvgu2zxk2tF2LNPJzPuraZKu0k1C32G/nPeiNlVj+1utLZD9xBdW6q5MHgTGyf0fizZyeGfNINtlMgfdDv0yDBjqpnbzWSLpIUTRKwMQvg2kFq5uLnGLASWkk/PInf3YCkS2uXXkkt5kIt+5sl7Pj+dFo+701c7SGpcGzNCkdgBrlQIE8sDyny0txAwmvt4mCZMJgaMh+XBR0f0FXuH2HphXR9y4b9yuVx/KKgLGMvtejoqc/PZcY26nEFWvpKCO6UDOdvwmvc+3Eju3XC+FXdE7Z/vBy5uyZkLIwJ+ebyQVuGgvT6lkXTFKZjf0IcSIINqsers7l6jUr3jbEOA33cP+AcSrMMJJRcN8Q7dp5SdJJuDoKgvSQW+mvujfpAwdEXJjwl28PNH1r/WMTkPrDRgLReGeWIWjhzbYz/v69UdE9Qu6TIDBEbMEHjuvJhnLKHaBS10WEGuPgrN6rI2+5O2iIlTNuglarbT8n7qjfEz2EyPI+FfLNqEwzE7/MzwBY2VotoyCBRLdejGfupCiJaN0jKiS0BqRhOr0DfVSBTFBk5YrcnUKYXmBJtWEqrg+JgKPnVD6YTKaJlGNEG4nbYnuVBfrlq/jlV+p3Lnv7s0zMQiFWUXwlFD1nTLMvRgM9bFvUwq8Hgic6LEwgaKmq0wqudWJy6EEoa5KzintaNewCcQhyni/u96S+IPbiVUNuN7PS0Eus+UHCDqAgXHu9oA2651lB4bmXYS6KwjyJGWYgmxG443KVeqqYwVd5DqZh8YrWDgv9zhN7sKNgLlHhUexClEuFx8KvIl4c5+6It4mFY7bodCQEeZYqhArqTtgdXn1261Ilvggs81/otWCiLpZ/4z1Ye7jOsV7o9wrocpaEYQ5Ix1T0KmFhMmTrJA2b+r6s5SC1UrBntV+B/SgUui5OZjSU1dD9CwlmMszXLd9QIutJb/fs
 xrfE1QjT
 hJSODPO2AbgjEKF5eCwk7TYjHxFersPTNxlIcDvWzSamcbTq3LcRP+XzHGa2My71KyaoVaD3mHHY4nsDfg+eMk9e7+rVZFWZrnx8Kp5/3bPeVt68otQlEVgdKchsNuAAANZWayO/9ST1JnnCP96ToHmwaKaRSEPCjdYho5mM2yjKxnhlbqPwftIkG0KNYtVlcr4V8VhVenDu7yPwJFsvwVf97NU7J1QYQ8c/fO1WqFUQz3/mZpzjPKxbSUearm84iBlRmHxJ0qPxEROnGZMq7bxRZBa61rvI8IyFnVF8hfnpjlxTlVRLpFLM5OGfFMPUtfPS4trE+4Qmzq5SN2ZDw9QxaV/7utwo6xF+fRYveLe9uRhmr6GNgpNjo7pf5K7tf9h22DrgAviyreeMHf6qIeZpOL1BmkWP0Gkf/zK977KQQp7ENm253o/yzx6DPsgmVU7GWS3pKIwTbJMrOKgA3/ZrrT66UIsMf9pmAaKM+FVs3uHt5fLGZAHtJBIcZBhd7I9zS
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

Fixes: 41ac1999c3e35 ("mm: vmscan: do not stall on writeback during memory compaction")
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
---
 include/trace/events/vmscan.h | 65 +++++++++++++++--------------------
 mm/vmscan.c                   |  9 ++---
 2 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 4445a8d9218d..d0a7fcd265e2 100644
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
 
@@ -362,19 +347,17 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
-		__field(int, reclaim_flags)
+		__field(int, lru)
 	),
 
 	TP_fast_assign(
 		__entry->pfn = folio_pfn(folio);
-		__entry->reclaim_flags = trace_reclaim_flags(
-						folio_is_file_lru(folio));
+		__entry->lru = folio_lru_list(folio);
 	),
 
-	TP_printk("page=%p pfn=0x%lx flags=%s",
+	TP_printk("page=%p lru=%s",
 		pfn_to_page(__entry->pfn),
-		__entry->pfn,
-		show_reclaim_flags(__entry->reclaim_flags))
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


