Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DA9CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5266B00A3; Thu, 14 May 2026 20:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD866B00A4; Thu, 14 May 2026 20:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2376B00A5; Thu, 14 May 2026 20:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3706B00A4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9CED8D100
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:55 +0000 (UTC)
X-FDA: 84767809350.17.D784BA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B4CB40006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jwg9Kxxy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJnelCSa+BtwQYwzCXrmaNpWbkQOm6uDto3EhFhoCoM=;
	b=b0Vta1cVdOOEIUd6IJv5vZrotCusxT+rTzjprXV8rQV0PvLDH7D8qFzGTTbHS+mZ7laNvt
	It9n5MtvIK8uijwNwIK6JetgYGbnUXqyYRC5bTNMtltPVqcnQHV0iQQ9AfCaV9NjYbyC99
	1xdZN9Sv7nWGizHLU2w8ZGIU6JQmnRI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jwg9Kxxy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805894; a=rsa-sha256;
	cv=none;
	b=rlq8QWC0/Agg7leBtVe1D3YRaAe9B/xTPmFeLSZZV2fI0YY4Kt3dqZHkpZytPZLr5TAfOq
	Q2pRdiAqyLU2NhNcg7GTulRrXKVHSSiXFVLbyEeknB70hvvSf6+31W7qPHG+81K1BKZ+EW
	7fJFypL8alreA0G0ylDrQQ7byJjObbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE44A4036D;
	Fri, 15 May 2026 00:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7233AC2BCB3;
	Fri, 15 May 2026 00:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805893;
	bh=O6Hl0Mh7Nxw8m7P+hZlG7JicrW7ipkVD+m8lBYL3rME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jwg9Kxxyp5SiFWyPel8l0mDAk7ys3Acb2RUOzTSm9Zbjp0NCywgHIm0e71oWxPoOa
	 /MR06AYDIZMsnHne9/DRPkuwuIKS+i1bAOFv9boEKqLPy+p65t0GVhg3QCMY6bZxcr
	 mvtkEB4O3u42wydFD1ryEEzGi9t/fEMeJ9yEittT+Klo7hbpWqmqo1zJiiyijvFHT9
	 IzsP4ozltwnkSolKLVlg15pg88U+q7O/a9VSFFL+A3aAKbcpPF8QzbrR/leL44Rhm7
	 MmIIX+8XH/RXkeUSV1+Iwp5VNeAiiOGhU2MmEItoI98Mt56V5TULNeFXQujxRlbA5a
	 qoTB6HGcFM/lg==
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
Subject: [RFC PATCH v2.2 18/28] mm/damon: trace probe_hits
Date: Thu, 14 May 2026 17:44:19 -0700
Message-ID: <20260515004433.128933-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B4CB40006
X-Rspam-User: 
X-Stat-Signature: f6qi93ffeegyesx77ct7iumt1o815hqr
X-HE-Tag: 1778805894-269362
X-HE-Meta: U2FsdGVkX18kUVhsDzxoJj5TuvXLhDObPFtqC7N6ijzCvnkV5aPZ2xexU8fj1CbucWlVqVqbbJSPg+SNQuEFc0lQZMKDghgj1smTIZe0vFN6QN6rkc3Ucr0asJeHZwTtoHbiINdlTHJBjXiiUixLhpEp5Mo8xG1DEFQ1+tkXZFngHB4ulwq3+tB1DK45ziAwloyZhQbELG0BxHBtJHg5CAYRZN/XdR+eJqOCypnX8I8gGF4AHj/00u7i4Xjz4HoHLdX8jYJPoteqL9ltOH2MPMCc4j4p56xIts4ITxdTxrjM6wHZ223dqe1FdI7uun1o0M5GxAzyRTgfcGugkjrzah3U1EOlp2TG4t1rPTncwhfhTFjp2W2MZdF52cz4P4VLFlwGwlWIM5cLcYlCyrFYlrAA8kUeJoTpScl5dz7NX+jyYs2Edo3FaTS/5KTM6u1TgUFwoQUgolfYi3Q1Esv9BbAiVpu/MPL0Yz3zInIXaViCUVSLfFN6ck0RK0EWGSkGlVFBjULdOy4JdULXFzZK4ZJUD6hik2OD2tD4hcVjHMH/5VaD24gPjf7Jxbi0iW3qN1zfBeqyQ/jZ+zGGIRFFmghFwkQ5KbNkt+0I1tSPlikKDXY2/JvCdErnEIS9oMP+454CDHSNDcEM/RDDS67uTvkMWmWuXlLuL/zf4Ou5pQ25gS5vs9f6scp1xh8WcDrNUXmWiiddKpbOmbnlLfV88bojxMlMaWgOqV1yLJN1y3LhQ9OS+6kme8jmNsgtuwFYLigBaQsESk2IInrXufsjkxuMMOXehKeKXo1xt6x/RxQ221mMDjEDpRp0lUr6yx7p4FM+sy6PFmQwdshze2S6WOno0OCYr8JGjY4dYT5I+hSBE1Xew/q7KWy1T3Jyy2v+vc9WJ8cenyaQQ90qCEReHLuCRH8/QGWHEazLmUNbTs6rU0Sg1aYVrnvAt1bGi00+1SpFVvtDnR74yvAblDt
 3Tih28Hj
 2UVtE778KFTrFP7akCDE+0WXRd8srtU2dKyZvKc16+nusC6JYpTtlp+fypP9tiGEN1kZfMmKjBET1vWIUaOoFnV5CptnZP6fAmCGImXUwvd5JNR9XrVdhafNqXafjxTWJ9U4OXceZkCS7TZrsf3QzbLVEQdFw5rest7GQTA/LX1gwUCl+QZ4dN33oZOF3cabSt6RyaRrUA6IFX+HrNGatd96HLXl8taXABenc0x7tXr7n8wUHH2K4Vr7h/u3KnDw2RummxRZIatDHYxCNnAeo/bRdQdMLR4S3+b0q
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
index 24fc402ab3c85..ec1e317923fd3 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -130,6 +130,44 @@ TRACE_EVENT(damon_monitor_intervals_tune,
 	TP_printk("sample_us=%lu", __entry->sample_us)
 );
 
+TRACE_EVENT_CONDITION(damon_aggregated_v2,
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
index 1c9d2fb69f98d..ab8ac9ec8450d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1881,6 +1881,13 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	unsigned int ti = 0;	/* target's index */
+	unsigned int nr_probes = 0;
+	struct damon_probe *probe;
+
+	if (trace_damon_aggregated_v2_enabled()) {
+		damon_for_each_probe(probe, c)
+			nr_probes++;
+	}
 
 	damon_for_each_target(t, c) {
 		struct damon_region *r;
@@ -1889,6 +1896,8 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_aggregated_v2(ti, r, damon_nr_regions(t),
+					nr_probes);
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-- 
2.47.3

