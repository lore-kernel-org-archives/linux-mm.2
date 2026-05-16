Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8A2CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C97C6B00A6; Sat, 16 May 2026 14:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803AC6B00A7; Sat, 16 May 2026 14:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4986B00A8; Sat, 16 May 2026 14:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 522B16B00A6
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14AD41403EB
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:33 +0000 (UTC)
X-FDA: 84774141186.05.17C72BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5C23A40003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PX88rBl4;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIIFuwc9kJvvVUwXalIsrViIHTYb1EICOShxFCF5Ww4=;
	b=AT78I/9xRzuqNfvjp+/D44qUOMq2QnYky25iRtf/8BdldrFlb6DARgCCu6D6LxutLs/LWb
	ev/kavZi8ZCMQqfl146Eo8M4vmItZVhh45oLSOhI4yPz1G507fWUizMIe/i0/Y4wZmm02w
	D3D5NLbLXkZjhhnzvlA23b5U+pBkk8A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PX88rBl4;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956651; a=rsa-sha256;
	cv=none;
	b=WfulDYSPISmZFz82X92vu08mcBcwFi2ilarGwYOD2WOgl5O2IdVjC0D5zXT7Xc5FW5DVFa
	yWxsST3UpLKmQmgb926ZrwitLk8Fmz1TciphI/e5KsbNvjXMcA1mSREnmI2j9DwoP6n6yZ
	aHfQOhc9HvEjGX1HyrApTuoBFXMSE60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E9DE4174B;
	Sat, 16 May 2026 18:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A347CC4AF14;
	Sat, 16 May 2026 18:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956651;
	bh=GaKE0tVTWmsw7G9ti4FDBUbar9GRDUtf1uS+1stN7jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX88rBl4TO3L9oH6KxHVLSga1aGTyNIAhmRiRaTDvkPNCytugn5vj63WBjhnm685Q
	 uXjdfu/tgLeiXUSXqORKIes1dXrUa2v/y79hmgDuHPBIGr0Yp7aJ0nYr3YAv5YYQOE
	 5xh6hba4amXl5O5DNiofca+stGsRCoy2/bQ5HkunlLOeEU4gpiDi8gEPYV49TANzcu
	 H1I+UoDYvMDwLiwEg8rJRcKRwHU3MhULZXe411UKBZc/mmMEtdz/7WTjMGhy7Oz/oL
	 VaXFdw3ZA4QfZ20JJskjwwaLhDVXkHCc+HqNobcuaVM0wq81e0trJHPrVdxnFLO9LF
	 nF+epkeDhLDDw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH v3 18/28] mm/damon: trace probe_hits
Date: Sat, 16 May 2026 11:36:59 -0700
Message-ID: <20260516183712.81393-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C23A40003
X-Stat-Signature: xuz76h1br3obdy1z3ye4sct7557higd5
X-HE-Tag: 1778956651-151061
X-HE-Meta: U2FsdGVkX1+7h6o9o6gOKbw/9nYO8gZZShsXYIrdgNew8/fMgAfYkI2JuQur2PLB0iBBPly30aU4FEBh9DR7xrJ8qKZmc4k0LPG4XVxQHoTiGRvvBpOn5JPmjeQyMfYNmXvRWz1YEuoZGhxfcancVGNCQYPpxLNhRDZasH4nZWpUN2JIfUClbJu6oxmqaeESbPepPNdhPnRwXe4nSHiSFF6JZL8ONfWDh6xwZEUuiM2dLN8ZXljHBCm3Zi9vu1mh3q340S8CWPEEZ00ni948K7k5nObD8mrJw9THdVTWCePuDUH0bPDxXakRUTfeibpNZCTnzyQCcrm9LFgA1SVhehS3RyVf71rLp+xrq627xPLz2CGi6cc2mmdffKJSwrTA1IFYP2z+O7NGcth/UCCn/8JGQSNuTHIZQaoEOSt8iuB16p2ONEr8Ia0leKU5V0E4SFXix5Lx7AopVhKavAsBTq1i0Oo9R+w+7RJNye0+g4LJuTCrRBUGpMmV9UtFbYWhVeE13LbIIL/841QMwEuhcd2Vs6k1nx216c+PGn8KUb7m6aKS9nam0vMaHd/jiCy9ANgW+0yVJOxfCM7jEybw/I8qBMtORCB/TISSHG1lbyqGlWIQxEaj345g+w/uBxN+n2Kernm7z0wD0R8NeguKpSupIfbnUbuIi9xJVb7nNNQ7wcNWMm/tCdVNJeslx7LPtyey/yS0V+ePYlGyvqm3TpZ2fjuXToCOzMoU/LIHlJo1n5YsD4vbnRkPlzvo2NLCrmpo4cqZ/K6TQGx75ap3YRcM8frxSeMR5gs+HBk2x7vnZV68Scril1veTXI4RnTWzYOtW89Xvci7j0s6UasErKEyeU0TDdsnKBlxg1McmjXPewV5FUNfXMfo6p0JnfSSgJdocTmuo6d0UJc2s0TyWatFApi8fC5oJjGzLj2zkf1bA3w6akW9UR+GM8wKFyOrt6Jc+bD7cYQclux253/
 IPNcIRAY
 +RHcfIPhwqPLTGGlZvfEAm8i+CV/o1ruBhLR30oKkmcIXzCxoqKAHBo1NJUsAEd8wUYuo+SQFkbdw/TaSISakxuxMms8h4kXNv9gAy/D4OJFYBiQ0PFsySVAlLq8KsFvUYEgbeBPxlxnOSxZS7MVMaNjFmHbKKBaiWf2RduN0pPQXsrnKy1i+56ZelSf2H8JFdElUno9JBM5R3fnK+mt+7MAWegwdfH5OSBJQ32hYgAm3drk+0pmUeOn4gfUncfBmGQ4LCCiMm5vQyCfsF74Np/iRx5NRRxWHzpH2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new tracepoint for exposing the per-region per-probe
positive sample count via tracefs.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/trace/events/damon.h | 38 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c              |  9 +++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 24fc402ab3c85..2fd914895c405 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -130,6 +130,44 @@ TRACE_EVENT(damon_monitor_intervals_tune,
 	TP_printk("sample_us=%lu", __entry->sample_us)
 );
 
+TRACE_EVENT_CONDITION(damon_region_aggregated,
+
+	TP_PROTO(unsigned int target_id, struct damon_region *r,
+		unsigned int nr_regions, unsigned int nr_probes),
+
+	TP_ARGS(target_id, r, nr_regions, nr_probes),
+
+	TP_CONDITION(nr_probes > 0),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, target_id)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned int, nr_regions)
+		__field(unsigned int, nr_accesses)
+		__field(unsigned int, age)
+		__dynamic_array(unsigned char, probe_hits, nr_probes)
+	),
+
+	TP_fast_assign(
+		__entry->target_id = target_id;
+		__entry->start = r->ar.start;
+		__entry->end = r->ar.end;
+		__entry->nr_regions = nr_regions;
+		__entry->nr_accesses = r->nr_accesses;
+		__entry->age = r->age;
+		memcpy(__get_dynamic_array(probe_hits), r->probe_hits,
+			sizeof(*r->probe_hits) * nr_probes);
+	),
+
+	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u probe_hits=%s",
+			__entry->target_id, __entry->nr_regions,
+			__entry->start, __entry->end,
+			__entry->nr_accesses, __entry->age,
+			__print_hex(__get_dynamic_array(probe_hits),
+				__get_dynamic_array_len(probe_hits)))
+);
+
 TRACE_EVENT(damon_aggregated,
 
 	TP_PROTO(unsigned int target_id, struct damon_region *r,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index dde3c8d8fef89..11b513eb077fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1881,6 +1881,13 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	unsigned int ti = 0;	/* target's index */
+	unsigned int nr_probes = 0;
+	struct damon_probe *probe;
+
+	if (trace_damon_region_aggregated_enabled()) {
+		damon_for_each_probe(probe, c)
+			nr_probes++;
+	}
 
 	damon_for_each_target(t, c) {
 		struct damon_region *r;
@@ -1889,6 +1896,8 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_region_aggregated(ti, r,
+					damon_nr_regions(t), nr_probes);
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-- 
2.47.3

