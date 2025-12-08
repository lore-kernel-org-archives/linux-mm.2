Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2E7D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295CB6B0008; Mon,  8 Dec 2025 13:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4D66B000C; Mon,  8 Dec 2025 13:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014E36B0008; Mon,  8 Dec 2025 13:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0BAC6B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:14:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96FB9B7654
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:14:29 +0000 (UTC)
X-FDA: 84197103858.10.62D90FE
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id D88B6180007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:14:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=gkOXlJLw;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf06.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765217668; a=rsa-sha256;
	cv=none;
	b=hnmOKV9+4Hh+X1en5A+WCBW2O2sUp3RaWmLckFC6Ry9cRmyaGPYEq1IVM3RaITQlghXaS7
	z+x8qozqlRjXhCt1TTmA0u7kAn7h8iTZEapRIfom0Ou6QCJ39MAYBADbbEq5KBgYQxrNNr
	LU5Urf5TIiRbk8ImxhbwdbWJ6anx7YU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=gkOXlJLw;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf06.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765217668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6BkiwIwtDFty4kL/vcoF4uK9prjj6wuzxRHvEPa1Bk=;
	b=xZDkEpiaZjHC4TSCY2f6MkjEDmTgpyIb3B+YsrTjEYq/nbzdKw59nwjZiP3JRvQ8cvGs4a
	v8dQJ1aYPpMUZF3BTZzdx1/XzkIvX8UmJBjegl/Ghui+PhHRhJb2NeSO5EY3yyub3hQRUN
	2oC4NF8zAcrBFF3dRdpUwKKwoUUcBrU=
Received: from LAPTOP-U3CCR7C6.lan (unknown [52.148.138.235])
	by linux.microsoft.com (Postfix) with ESMTPSA id D8C312116041;
	Mon,  8 Dec 2025 10:14:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D8C312116041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765217666;
	bh=q6BkiwIwtDFty4kL/vcoF4uK9prjj6wuzxRHvEPa1Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkOXlJLwdBC6u2WwsteOBjVhNuNJ9KcyPx9CtSfJ0mJRZgTZcxHS+XP9tbeD2RXxh
	 HH8YuymnL1pupRUjxI0hU2RgbrOGVVR+WLJ5Dz9J/4ayzWIMC/RwzOPViyyFaN6vJ/
	 eJElxEVKn2QSwKcSiaM0OaRoMFIRzjnDb9XgXL7Y=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon,  8 Dec 2025 10:14:13 -0800
Message-Id: <20251208181413.4722-3-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251208181413.4722-1-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D88B6180007
X-Stat-Signature: fj17h7k8jzh19ktisqag6xkgta3zjusc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765217667-430550
X-HE-Meta: U2FsdGVkX1/wmnswAo7fkDqrk1ut+/g3WzWBAe3qi+ESA9D26li5EyOq7+cVN1tjapxF6vWFp5NLJGp3sf/U75vJB24UQ0i70DZyvGWs1pG98PqxK43lhrUMitfxgQKq0Ob5PC4saxjLti4a1CCAUPsqNETl6lqiPoC0OylWuCz+O2pRv/nMUVCp6mAF/dx7IBvPc081bFCFqWMXh7LzYKA+T5+EkA+xZ57EYG85S6owzEKN6Y2601OAvUNXUd2SKqTP0q2E2aVA8nU8zKzLrPbLNkoNMhJi+2hAgtd5P1jdhFAUl+l9tIu7LJqkboFye8wu6BORJ1/0LWMPP/zDgehL6gUNoPuaAkOufur1O4qEjX4jxggccviY24/lI1KJkcoqQaWzjzmQOn0aWb31nNEYJC4pjNtCdTWzBDJt8OrsENR8Y1MoJjAaXRm6PMrukv5MmWJuBGiValAsAB6WXO8qBSB+UxjcyPwezMRpd0lGDN/dVfpFiZh/XClKiTrZhqhJPgcvf0NpyhxxijaGD+4sRf79LUWJSdKV6FBZwmZTUaoB21JQ98jGwvO27sKhZ72kuOltjWaRprdTusG5dtEEOkPmRZzI0zfXULRjU9ysxPNPmZIvEHa1EQg8ARIF5ZSgk3nOd/bXZDDefjYvOiyknJ/Jerph0vI4RjhG7kW7lBSvLcMRMbWPqiUyHEiMGo2Gf4A3FM/WewPYBZkcqokuyR84WDriF57lA5u08Yt0+xymFg1mOcnul8feb2ox25JLjlCsTsCjaod2mLdCuvrqnU/GMpxwkWX9tfscLYOWifwIoTXfQVC16kjF26MMWyC5y6upUfbto2VT7BHUouYjXyq7Tzl8zYkqSniYwb59hPdd7eCmrxKlFCcO/V0YGZjETrzErnQhO3rAPmWiu2k1aUPrCAXLvIQyoQVW86YET7a1ogAWNpiuUoTMlZ5pAlc5uuY4oEsWgFwMpH4
 3yNw3JWX
 rpzOqPQXGWsEUgmsDWsMPplLFJMjEmrmg8sNuKnax+nJOksrZZ//uQ2A6hGvb7KRV5fBOTsD9jspJMvG3BsPv1UKRtJHuP1s3d8wIqAWVrC0oJSx9VC2A5+s9KXpfPtfOcInrmyXKIH+du5rrGJPd2TenXaI4a3D/0JhkCrQWUp+2SIitiyw5J6X4td9/a/o0cmrOLiOmkME8gC7Vo5Wni4dgmVAgElubpHOrs7FHafLAcjIQrlxNmXkK/nQ11V7xNLkg0R8oYCyYwWax2q1Zdhi2t1+Hg7iMQizz
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
index afc9f80d03f34..eddb4e75e2e23 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -121,18 +121,21 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 	TP_STRUCT__entry(
 		__field(	int,	order		)
 		__field(	unsigned long,	gfp_flags	)
+		__field(	int,	pid		)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->order		= order;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
+		__entry->pid		= in_task() ? current->pid : -1;
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


