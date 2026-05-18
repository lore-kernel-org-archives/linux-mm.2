Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CB4CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D0E6B00C7; Mon, 18 May 2026 19:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154246B00BF; Mon, 18 May 2026 19:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E784D6B00C6; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C77C76B00BF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D78E40B23
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:32 +0000 (UTC)
X-FDA: 84782164824.06.16D723E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CAFA0C0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vPuKh+sf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfmfW4NU0+9Wig2Ix2x4CTTRqKXuRzOpuEyYdgD0+VE=;
	b=SG+28m+SLI700r019gFwqU0UEkcMcG9agh5ZZDvjdTSK/0DkS9KWvcLIiq2QzHKKgJ2Ly0
	nOxMT1JJCOZlPVDYx/sYQ9DJo0ImoF5175tfW08b2mqmFDEwAvgzL7b2a/z9pPa/3tfYCo
	GruEPADpJOo7+FnXTsEgzkIXOj0dJyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147690; a=rsa-sha256;
	cv=none;
	b=0glHcN0orcM23yQMbQbar4cPHMR7dhHg5FPCOWv0F7l30jRsbUOB91XFuFZcr+sfRyFLBF
	YM2igakptOf7f4JSym4n8TzjM++85HexzWOcNfT1XGB2SRFbxp+59FIuf/AE/Tb43lkf49
	8h62hwSZz0QuWQvANlnlheFAxwDblV0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vPuKh+sf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55DB6601E2;
	Mon, 18 May 2026 23:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D0EC2BCF6;
	Mon, 18 May 2026 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147690;
	bh=oi/JcE35e0BkzNgUR9uyr6y/BZqSFxdfd3cKlzhvFvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPuKh+sfRjGLW/nvTDitPAIw3lLZyXsSmvIzv4jkG6j5f2mhGzq50UVbZ8zELzgsI
	 ydxwT4tUwTYrmkVtqAKm9VhqZxZjEq1fYn/pZi0UxjeY2y6XzT6BTft0sLxvHxhFZy
	 Jk+qq8C9LAJ06MZ+WehePbeI/4xcRDffel7hdE4ZgLHi/e60FRqpQkvaKPZI0jSfPE
	 eSpWwEHe0VWNjpJFkXUvgQddPfIBbVSML/9IiCgsRW3AVqSjFi0lvCDGnA5A9X//PP
	 8hewp/LLn1WxCQ4/2yBzmhr+Cj9U2yq1Pxyel1/Vq3MVqB4A+4b6YS5DG3Y6UKrsOt
	 6sn7E7PZgRiPQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH 18/28] mm/damon: trace probe_hits
Date: Mon, 18 May 2026 16:41:06 -0700
Message-ID: <20260518234119.97569-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CAFA0C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: eyiqjrx1pkezqpe6bznbxr8foxz481m6
X-HE-Tag: 1779147690-858843
X-HE-Meta: U2FsdGVkX183cRxjzkFm8KXIDeHvuc7pZqeGNsQ0vMY1Cq/XviIq54OBpy6D5D/RbzqOM8ZvTrtR4C16zkp0kUAGpZY/WoHyLA8ivnQdDvDjb8phmZ/hRy5a8iZbBMjQRh0jpPTRAvCll5VKZx610Za4iJhElPs0CDIuZZKcLWN4kvH1Vb5f+ZsAHQhDCa4O4yfAN5Ywrcv6fYM+uin60NrRUThChdjoT++2Q1Yh68ICnJfh/BiHd8uOToxTHZEqd4s90Y78S2ruZ6BewnsK4Ni+y53TAHpA/FEmlTb53Sw3mwlDuYlO/Ocw97qKzuNSRUFDKs0pjIVMds21zMME+xznNqVdpR6Uy2q4NeG4ypdrb7SACxX1G0rxFGH+9NkM61v6te6pBUTd5JXR/sLTpdDvWhB5eJV2PuJUJP1W3QTqRJWR37Vn2xFWczpQvYMvIf0g4f5pelSNHqhjJ9KjKwDaXEb8UmTr/flB43PYEew/ONZIWWtF1lE3U5GgxHDXyRwiI6iUwXUxSc2qkTt3uOXaEopudhjYd/TFHJzBzXhmQ4mao00yaoLMwbQ+aL9I5zSlJbBxK+g8RX6eUasJZwXd4sRUoTDbvqFvQ6P4pOFxKE+jFLdMN7gj1gd1ennwCVHYk0x23zphSy74z36g1wpAGuf4Xp83Mzbxr1jk8GjkHmkSuduQtqi5D7z3p4mvNGAU7zfiOaqtH99Q2So8p15Pd4iocfVOjVFec0rijAJRWaF5NFxvQmfwM+tf6MSQxBcfqoNrXMwGE5eyDrqL0vMb6sSEzgNakFQYF7hHChqeiAgvT868l7OhsNtock/M851nxgYgCqXVBOZ0ow3iP5VKMgTRaJm0vTBrPwOyEyB6IFV1JnbyQWBcX2WWJrSotdR2r6hYAb/wK1FK6n6RR/+2nTPA0Y/AbpWmOGxQSPsIBX/07Bvlk0SOjw167pxK7e6w+Z2KBVZKyI0y9GX
 SCQ5KtKw
 9w5fNtqcs1s5OeOcaWYv/swfeaDhpYP2Yx9MVlSUmslaNR6xABvl2Voe5FzI6cnAAdIfyCIa7q+MUgs3DBrVE9SfxPmBEspQK+a3NKmZc+1hn4s9GLF7vGPuPOVjRo711EVBSe/XO03eTW96pD7yTMnzBul7/OqqEyvGqi8Zrpm5ahuR6uLQ4wIvgk43Xyh59ui281wyIKxBxSGLI6ibgi7283OwZ0ZwW1TqZVRjxzioGzc/W8d9NaA2lJjloxrq/OkDZjsESEGCom9y9Qhs0/ChvRw==
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
index 7e25f4469b81b..78388538acf44 100644
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
index 433da8781e255..5ba7ad4df4351 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1908,6 +1908,13 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
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
@@ -1916,6 +1923,8 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_region_aggregated(ti, r,
+					damon_nr_regions(t), nr_probes);
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-- 
2.47.3

