Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77F9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DB06B00AF; Tue, 30 Jun 2026 00:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97BC6B00B0; Tue, 30 Jun 2026 00:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11326B00B2; Tue, 30 Jun 2026 00:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB416B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D32B7167C4A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:28 +0000 (UTC)
X-FDA: 84935247096.24.F25BC9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39E0C140003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c+0Jv1tM;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792507;
	b=Rdo7OfD05sfMYPb2N9x+bWFnkOElIXhRqAN8ihJml5zy04Zpla8+DDVtKMNqPr51dgaAyh
	fyDGZbr9ACijpGOPMs22NdStWjIq4NKU1BteybwrFeGiXYFVAAqHJGBz1gal9zcsftpsnv
	g6pFaYNT5vLcekaOTIPLyeEjskYO0EQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml7y0LvVhQqERVNHIB3ApkqZyRkL9+NFf2FisR6UbJs=;
	b=kyXP/2d1edwOJ0x8X91MKRcohF/ZcDQNuWJiKVuxTQBzal8IT4+OJ13ZY3wRSPtiANkD9m
	YGr4tQpT/smSZknV2vhIr4e5xqbxSWcvFEYihLgrirkvfh8S1IB70PRu1P6igZb9GoApNN
	GH3owe2sEpLAYo2241B1QzgcKjdoG7k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c+0Jv1tM;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 797A843CA4;
	Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD521F00A3A;
	Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792506;
	bh=ml7y0LvVhQqERVNHIB3ApkqZyRkL9+NFf2FisR6UbJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+0Jv1tMNOwwWRJ+FwBMPxmFvYvnd7TIKabeliF2famUim5vqBZQ8Q1j47gOLNYNp
	 iUdL9jhyoqsGir+hPD1EgW41cvoWcf7iR2u+p9HTbQNSGOoZU7RZpsbCn3M0IkbXEb
	 TZ6bK+wq2Z17kVPdu4GKlnoghfl7rgrZXJp5OJQWsomGo6bM8ZzSMkwXD+ZWrgop/D
	 IBRBSiMZD2CWtvNTjVoPfdMxY7UFQN7OMg0Of55v+5bpCRl3/a6mBdmG7ArtyZakT6
	 0QR+a6RC9pgc3+yPLmy/XDwoZvdxWPbQbQ8+MQeA5/O7hdz8oQGh58iETPNHfRhzOP
	 g3AGnwHZqvCBg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH 06/18] mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
Date: Mon, 29 Jun 2026 21:07:59 -0700
Message-ID: <20260630040812.149729-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 39E0C140003
X-Stat-Signature: pqb5gturr1uom1rpcqr6n8cademdg9ii
X-HE-Tag: 1782792507-26360
X-HE-Meta: U2FsdGVkX19ylb4Kk06Pbj4x765rqnKgL/+pu7aEO68CRvwAE4CC3T/6bzNg/rdyP0uJFaBKfO5KiZcq2Onhga1taniVIdut40oeUOUOcfjcZHymYrDDAFVc0ETwy9buPSyYDGHG6diGRpBj/MIabJuhSegrgSKvSvwAFBQjVvdIsYsRKQVYH1UvlvvFhvMAWPsPKRqS3ku1mj43lNiBiTWqh75GcVePwqpEmlAJe8SHgp5zQJD5uc58mjRbuMREe7lC1rx/aUudEWYA42r4jpTg0KtcXQMXUx8pLKJZ76BCUXo0KM0XzUv4tEVHCl8CJyIBNWigwc+OYUEW4SHtJRTciOH4PgT0TTPQu6cUGoi5ZYG4mSsM92/TVY1NoDETnN8pZ9/2TTgRk2/8S3/hTP4YCAsU5jD6pSvu8pPbuDCQcOihtkblT+OAG1jGDGv+8IaXeiVwiSIQROk/Yf37ZHn++ttW5GnZoO+VStMB4/1S6crC5IXaLp62Qnl4fBiW1rVU07oglA6P3WtpdgpBLeEACyXDV9P/EUrU3qVjs94K/hOCWvp96GHMtrmepXfCLHKquAozOxQmWhL3Q8K5lY4nwQDMC9WvwGu4WoijdfCu5lgvHakdNVTMQtc7VYvtGvQt0RIu7S8WbgJ5RgfQDNmuvsVQjdQr75/QR/aotXHLwuoxisI/PQCmqzyvP+IGJDb95FEe4FLy3c/M+WHhk7/dw2tiR7YhHcrQ+ErRkOk9XWOLa9Q5qE+f7+JKXHpHA3W0otLeNkvrLnHOLZmOh+t1snmq0RxrR3jQKADavsk+snjLb394pHxdrmhWWjgbubFp6uvNm2oVt5SedbTnxzWNLetBHDPL9mCGzMP4bCoZhqTAQI7DNuj2+lnvNy0BzhKdOf3IDIx2NvUciPEFLdVRuBKisvw4IQXvBtreEwIdJA7oGY0UslhJaQrzhV/P6FjHq44U4HO2ViQwaKv
 KI5qqYWA
 //LBvmcjYwD3ERk7NaoThsnyvpdCGTVq8iICg7uZ5Ix5vbSgB95To4M+Oj/KJbe7nhD95aj7YjaDyGFC2u45cUeEb/Zkjd2gkYcUz9eaWunzty4B5IS/K7rWr5Dg3liHtMR/vT/oXVTWNWIOJB8brWF0YaTYX/gvruBNkTZl0Q3edDTU/CMPHgKht6WFX6TIQwqExFsNmgeSgKCJIe+j28yX0SQCa6BAacx3zA85sFsjEEAJBSWGUHKtRN0yAfNerbATKqcdHIKgpHXSCWy0nUi8CZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in the DAMON region exporting trace points
instead of the nr_accesses_bp.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/trace/events/damon.h | 8 +++++---
 mm/damon/core.c              | 5 +++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 78388538acf44..8851727ae1627 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -78,9 +78,11 @@ TRACE_EVENT_CONDITION(damos_before_apply,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
 		unsigned int target_idx, struct damon_region *r,
-		unsigned int nr_regions, bool do_trace),
+		unsigned int nr_accesses, unsigned int nr_regions,
+		bool do_trace),
 
-	TP_ARGS(context_idx, scheme_idx, target_idx, r, nr_regions, do_trace),
+	TP_ARGS(context_idx, scheme_idx, target_idx, r, nr_accesses,
+		nr_regions, do_trace),
 
 	TP_CONDITION(do_trace),
 
@@ -101,7 +103,7 @@ TRACE_EVENT_CONDITION(damos_before_apply,
 		__entry->target_idx = target_idx;
 		__entry->start = r->ar.start;
 		__entry->end = r->ar.end;
-		__entry->nr_accesses = r->nr_accesses_bp / 10000;
+		__entry->nr_accesses = nr_accesses;
 		__entry->age = r->age;
 		__entry->nr_regions = nr_regions;
 	),
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 612762490e866..6423e7417c24b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2446,7 +2446,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	struct damos *siter;		/* schemes iterator */
 	unsigned int sidx = 0;
 	struct damon_target *titer;	/* targets iterator */
-	unsigned int tidx = 0;
+	unsigned int tidx = 0, nr_accesses = 0;
 	bool do_trace = false;
 
 	/* get indices for trace_damos_before_apply() */
@@ -2461,6 +2461,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 				break;
 			tidx++;
 		}
+		nr_accesses = damon_nr_accesses_mvsum(r, c);
 		do_trace = true;
 	}
 
@@ -2476,7 +2477,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		if (damos_core_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
-		trace_damos_before_apply(cidx, sidx, tidx, r,
+		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
 		sz_applied = c->ops.apply_scheme(c, t, r, s,
 				&sz_ops_filter_passed);
-- 
2.47.3

