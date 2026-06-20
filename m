Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB62CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A016B0096; Sat, 20 Jun 2026 13:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1FE6B0099; Sat, 20 Jun 2026 13:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0253E6B0096; Sat, 20 Jun 2026 13:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB53E6B0096
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BE9C1C1182
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:02 +0000 (UTC)
X-FDA: 84900961404.10.A60B9C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 84CA040014
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaZRgqH3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQ9tcQmAH5LACFHL/fzQkhDxMQKAnhPo6ksNR/v/d70=;
	b=bUp6CUPZUfxSkVCkF3uUiZknNjod1XCXbBcTyio8ubZ386pk2LppqJwj8TIaBhyMBZYu0z
	JnT6mtvM60zB4UeR8Kl+w9MsMVMTqQUcK4zjJIwEyFFG5URVwq9FKFPP5YpHJHCPqRDm0K
	epm+XQaC8xubnfnQbl19kgE8ki1HFwM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976180;
	b=K/PcJH6rOTJOvFlHftcl7YIRbrxe1LRSEDHFFkF2zqMKEKlQIj4z/rAckfWGsgQYdpTHI9
	Y6peCk4Gtm7P+M07hoVpaCOxnB0tRGM7ul6BtxHcH2hVHx4N58F8tcFCVfyDJ7gLjsvpPl
	LGjrijOeoStvokrQzko/JTyZ0ELYsmg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaZRgqH3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D57C240823;
	Sat, 20 Jun 2026 17:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6361F000E9;
	Sat, 20 Jun 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976179;
	bh=VQ9tcQmAH5LACFHL/fzQkhDxMQKAnhPo6ksNR/v/d70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaZRgqH3IvDG20Sb4Hu/dcRr0wUFCte532/LnaNz9hQjKqtvEHJjJ1tMSjSp4Sd7A
	 COP7pwGFEujL3BSbDA9BPIaW1ySIgxx6rgigudCBaM2rIHlmna2IaIEDvb5/fwI04n
	 rBqOZtMS3Lm19VoaIJ3zi9W8atG/L7vimE8ggoX8IZl/YaEpXsEB0A4BqrYvWc3WHf
	 sWOdZlj4TowXfNQXKJe+/IsKTAmJluBo+5btL4AlJleZwTogtiBKIF+d8cdu2Eee4t
	 v4G+VnULq/SUgqzm7h1dVIk+ZKv17w5nc4dLf0RBaEy6vjjCGG0Twp9ZhHE5sgycQZ
	 WOddIOusudCYQ==
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
Subject: [RFC PATCH v1.1 04/13] mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
Date: Sat, 20 Jun 2026 10:22:34 -0700
Message-ID: <20260620172244.90953-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84CA040014
X-Stat-Signature: f97ipuy5txp5kfa9ojxa6nr965fajifi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781976180-189462
X-HE-Meta: U2FsdGVkX1+QQz8MBYx4P896edbh27S5mXgYEEsZvi+0TbuV5sjxHL5mXMY/fDjnU5SgONqLUOT8dWAIKCbm9LtnfLHKR/OxdLmrrIgygr9sqesyE6EjvLzogpavPM1azpcowb01Yo3Cz44z43PxUgbaM4fg7POPQLuq55lS89aA9h7rm81C064GLI/ZKZWmmFi4JlO0DQPMm1vgTPYglszkZ3Gol6M6o+G6myNyyItby7qWNXgL0Uauxo3Gq08gZ4E7VjH8g7qNKhcS/niI5qUKyDBUkpZ4yxJm29keg/jRNPiYC7MNIxPrF0GtJX9T/koPDkSx1sajOi6t7xW6199Rt+2nZnmFZWZh5FsjAiCgYf2rRuzbec9K5zGCVLNKJWl+eac0G1c/X6eFvTMBVA/c/KmY7i38cw5GBrMYC3HwafK0uezk1su+pDrAdIaDxhoNmOPYI48LBWOeMnXkN5uX+OsWxHEyOjM05bqmKR8t1TAUT91Kb9qgwpWf1Dqa4CaA+8RWSR15na5a8Koe2Ml9n4qm7pA+ZjBQy3ahqzwRr++Ff1W8EziVbbgfYi13pxphXifbu8t/9K99hcHVyW6kQ/T+IIuLA5Ev/7ysmVeChJGgjysMDh8E8VSFFH/l4LCIr+E07cUZBL8XTf+XxM+PV0RCO/eRE6r8PVFbt5HVig+LAKuuYO2FlEFEnAfJv6jWFz6gB5iq4KRtOvXkztT7spotH8gjmfd+JhzJI83N0y2PgpYpgImSEB5YQJ4eJcNUj+EsFjCsyibBAxZ6i3tOryI4c7UdrlnZ5AQBAKk1ugtyZmljhm3h9Zxm0m+UciMo9gVM4T0Rj+YlPsVJXV6OR8sDm2u3utKQMvg/w8+ITBpelzJZqoqw8BT8l1aXTzmowgUrtmoVQMzqeY3YaQoNb+dB0RNpaFI0awztBRiEmvv9JzQGIwjiMUZPm53WV5qVUz1S0LiLml1MIaH
 NwYha9xR
 8UaKS5qfTILlV6GScTXSEdXOVh0GwRoNJlAslsUBP+LoJJwrQWtgJlHtG+LJthuW5zdWJR+/UIkrzXqtnRYOmqxeQpgV3S2AZWa44z1NFQlPRxUW9mhM3jjGVlP3GDYa66wAjzy6eXKKv8DhBzg6RBg2iANxY0glDRqnRHJMLuijBAxgW7Qb6Yayyho/vBSHm7yYCwQLV5Cbn1LAjMkzLr9XO3JaQ3NbybGKNmzmxNUX5ELkNGURoPqnjOZcLsqksCxfhnuiwdHyT68eV3D/oYzlK2g==
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

Signed-off-by: SeongJae Park <sj@kernel.org>
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
index ce0e2a4c1d523..710ec13e98281 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2434,7 +2434,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	struct damos *siter;		/* schemes iterator */
 	unsigned int sidx = 0;
 	struct damon_target *titer;	/* targets iterator */
-	unsigned int tidx = 0;
+	unsigned int tidx = 0, nr_accesses = 0;
 	bool do_trace = false;
 
 	/* get indices for trace_damos_before_apply() */
@@ -2449,6 +2449,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 				break;
 			tidx++;
 		}
+		nr_accesses = damon_nr_accesses_mvsum(r, c);
 		do_trace = true;
 	}
 
@@ -2464,7 +2465,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
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

