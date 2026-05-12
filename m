Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B41ACD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B956B00A6; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C106B00AA; Tue, 12 May 2026 10:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECD66B00AB; Tue, 12 May 2026 10:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A71726B00A6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 702271204ED
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:06 +0000 (UTC)
X-FDA: 84759020052.22.6D6CC3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B52E4A0009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spSgCZBl;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHDJM6MHr614zHJfhb+huhyfVHZfe3pbb6nuDbqEpUY=;
	b=WZp0Xo5S1mDjrMqpuir/U7G0lC1QdZ8X6uV7vk/UTiFyJ24k/FqzAj6B2VSmGDa05UxpeC
	nxjyffsHvdMwgzft9ROMhfzrezDGtuVHrpXxA79NU0BfDZwbOzyC4B7/9uz1K+65Aq/5Ym
	1HdsG1GH2/C9b7FeRDZP1qlp1YB4dn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596624; a=rsa-sha256;
	cv=none;
	b=6+8/pSkRLCGO8EUq8r5D9y2Ey/nNmJMydaEmf8k7fD0Pqpjb+3iptcrdbumFdkQhO3xWNA
	R09TpSFoAy/OSdWR1ok3tYRud4iR9v529/s+r86eE88KUPe9Clh+VCtCpuYRwhQO6r6+D+
	uPHipoofrAf2ER4mOJGPic0O6/BjeqM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spSgCZBl;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 781B244A96;
	Tue, 12 May 2026 14:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF347C2BCF7;
	Tue, 12 May 2026 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596624;
	bh=kbCsWU0mjnq37gAs52jkDtzKMzPSB8TXwCEtlj7DRH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spSgCZBlv4Hw/H2wyZrkqs9weh8VNtljwJlInhjXMHp673abph/08TnrZHosupZl5
	 HRXgvXApLzfbzFhDrDX+TT6poh+nVz7hMM/IpOkO2h690KQqsPfJ+xoKDUB1Yf3uqI
	 zuU3zFXMDtcn1WU6O17k7dy3Liz3xcCFiiACcUWoPzZvf6arPSEkYuIQVQrq6NY0D/
	 5IbhcHhGzsb3QZv4BzpIPxPc4dORLDFo8kW066JPz9i08qlhJSObnhefma5HAVFVT/
	 iFbVG60r0Dznc2myihg9RO1m/LiOJRBvM+iuN69Kn5nMqxiwlYiJBJ0zZWSmxGU0ip
	 F1rH8Cj/gsphw==
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
Subject: [RFC PATCH v2 18/28] mm/damon: trace probe_hits
Date: Tue, 12 May 2026 07:36:33 -0700
Message-ID: <20260512143645.113201-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B52E4A0009
X-Stat-Signature: nj4w78s84x3yo6qirqdzsi633bef4xer
X-Rspam-User: 
X-HE-Tag: 1778596624-439147
X-HE-Meta: U2FsdGVkX199pXEOP2YsdA40kOp/04jt1WTjVmj0p3yMJL4/cZRWYphVpm4O2WpB4TAXkcyNQjlIgSpSdt6b/r9hOLdmdzpRplHp1r5Nj23XBMCIZYnmrEqQkW9TMr2J7vATiDLWeR0DMi2F9KEkNDF9dtcBr1l3yRn90VTI8aqQrtF6z++EHQwPIZBhopUaSbXucKU/my+N0hmjTvqL0vMMabTSOCjmrQqqBBH1sioAsTmfDQy/7e/QDFnu1nUadHtOolj6MM6+4n38HujZQvH5JKaHtIiOn+C+bbwlYJQLu/t3CCKMttPLd8v3yLJr+VdELhFbl46XSbHaiJAybJgBmz3Z7GGGo1i+COGl5lw6NIGCMsEcBi0y67mwZFRQ05tYic78aLsMjPCJqYXERT6lyH4mYpvzUdkhQnW8lGcYOS4eNoPm+TpZjoyKhJ+56Op/niFBlbIEuedzkpT394jhMqbwEmqd/gI0Ov1/aO/BHZ7IZijxWS0cyYY7hvFe8aIGY0Q2qk4xzQk1z9//gi00WQOlqNLXYtXH9aIpr7w2BZSie5On5PuMLfRxW3gcN4NtDXcxiXaPJEJ4VbRYnkIL+6gFKAFmmuu1nTL97LsNKLurwxwMPc8HRIYjnuq7p0VFPfI+dJfxN/TJ4vveXtT/5FOFcgTlXAi7KIOpQ356ibHNV00QOcPoJGzSJU68xvA57124wkYVz1PdlaxPPJ/G/VnE3TwnAgsC7CLwKL5r62wNPXDmvwKCcL49Wb+P2Jl5HGF87AoE+QMKcsdSlbRQzSKFPO3osEmWj/xDPu4rxCtdUSE17xVndx5BaKUFJXj5gy/OmXK3aYo8cSRxZCVBiHngyrXnDvXXqHl/tblGQKzpZ9kn73hlLUr2vEmqitb5NiZsz0ssoBZeZYBup2TazWdCl2Zv09lu/hMYhe66UTb2HqI+WNmR9fUXqyqam+/wYXQZ3EYlRXcqWrO
 e6Ec4E/8
 k3kQft8jElb/fA/gvsIfRM2uv5qv5j9IdmQAhSUp/rwYhK6VuMwzEOjxuFGzJMMPZcXKZngE0na0j1S0sNS1sS9xYNkXtBOD6lMpCCz6Mpq+sm5LcfNO/h0x8LFVsOBmPuguNp3HwxmNZNNYZdMnAQ1/u34qj0davxZXwwWyftBQj2IprCLyAy/nt7siIRaFxobhlKrmxPC6wlC3cX/fB53Ns9wQg7s4DjftokByC9sZNyFzUv8m2C+AbN18WaLpLDsqfl/AGvJCqDOmLgcP+XRUJ7Q==
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
 include/trace/events/damon.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c              |  7 +++++++
 2 files changed, 43 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 7e25f4469b81b..d7b94c7640217 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -130,6 +130,42 @@ TRACE_EVENT(damon_monitor_intervals_tune,
 	TP_printk("sample_us=%lu", __entry->sample_us)
 );
 
+TRACE_EVENT(damon_aggregated_v2,
+
+	TP_PROTO(unsigned int target_id, struct damon_region *r,
+		unsigned int nr_regions, unsigned int nr_probes),
+
+	TP_ARGS(target_id, r, nr_regions, nr_probes),
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
index fe6c789f2cecb..14b15c9876516 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1905,6 +1905,11 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	unsigned int ti = 0;	/* target's index */
+	unsigned int nr_probes = 0;
+	struct damon_probe *probe;
+
+	damon_for_each_probe(probe, c)
+		nr_probes++;
 
 	damon_for_each_target(t, c) {
 		struct damon_region *r;
@@ -1913,6 +1918,8 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_aggregated_v2(ti, r, damon_nr_regions(t),
+					nr_probes);
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-- 
2.47.3

