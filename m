Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F9ECD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DE96B0096; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C22A6B0098; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E536B0099; Sun, 21 Jun 2026 11:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCBD16B0096
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AE758D021
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:34 +0000 (UTC)
X-FDA: 84904374828.09.67BE3B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9317A140005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMBje4RB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXiLtH+Zn2MRUp1wccyuIqHTYFDO5c0rsaJ6q0wXLp8=;
	b=BSQJbEJ0ZyJvyO0/tNJPNRudUS5V9GP2a8bBAMzeD+hkSNq7apJXHvzamPKSM/Qc3kzKHy
	cAehHcy/ZXKzFLo4CfPZGKEjl/lVpKGxogo/EP4E9Cyio6OB81MG/7c+r29wBfQMKiTa1I
	koLHOF7BtNita73KyZ/Sc4/BqMLP82I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMBje4RB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057452;
	b=AE06gvBNM7h17XnhwClNq19wpdGzhPAj6P7xlz4+uOFB891hIBUBu3XZPqgSr4hPy1nKKo
	BqlmswxnCEv1/2UDyvXKeQII1GINybvcSl9engAh4Zs0YwsmU7QThEhEEbW5/tVmJtmDEJ
	shTjZaiakO5TD+PBvVnSUr7ZaA1dXl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D33A34453C;
	Sun, 21 Jun 2026 15:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17111F00A3E;
	Sun, 21 Jun 2026 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057451;
	bh=nXiLtH+Zn2MRUp1wccyuIqHTYFDO5c0rsaJ6q0wXLp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMBje4RB33lYb1mviROX82s8w7c/xoZi8s5NLWLxs5VcE1Iz8boP7n1ygFuS01NVB
	 XpxBSaPqDpWCiP1bQx2165TNpJzIQtHA7mpjt5X35LytEUJFGhp76aCmFS8miDg+73
	 ACY5jnpcE/IwmFzhja9q8ilO4EudnELunau5Nk2PCDE9Er4PR203UqoOEh0vV19UNP
	 Tam9EJDpWM0J0Qeo/9+LF+F+DTO+A62nk5dyPCjJJ0EKPz9w9XnfAnLBVymoS/5hG7
	 4aUEIIoILsbP+i8yAE8YbPLNasg1oVTEsp6zOoeKbA2f0+Z3tmUJpGURHY6lc3B2JS
	 IViLjaKo6s6yg==
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
Subject: [RFC PATCH v1.2 05/17] mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
Date: Sun, 21 Jun 2026 08:57:01 -0700
Message-ID: <20260621155715.87932-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9317A140005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: gfm67w4trrijzf5fdzmni71fr89us8qu
X-HE-Tag: 1782057452-171833
X-HE-Meta: U2FsdGVkX198Jj4W3dkeR3UD/vypq01x0wx4qEwJKQgRJYJ8gMTjRV2CLiFo9OMoB+P5gKL2bh/lElaPmi50bwbAO4l4KmfRpLD6WKFWuhNP9wUtuPC0npr0XVzMiylIMODtwGeud1aBTS9z6Ct0SquYj6ZZ+EAUlGeah30cY+/50i7DD/skthxD3ryZ/EsfZSYHyPQo1c+uRq5Ygjw3yuj/QTb/0DukE8diHUMX8oOGZVCrVNx7r5rPtDUnGRV9y/FwtbkwowCEKm/ewd0Zw5yWSG9t8TOb3NhJ8ZBq/d8J06kBdsYNC2GduIxoC5xRpnJ5UQ7LegZJQhjm5V0JpGt2AUDFaLwB1xbfGmQPdVPnI2AVj65OqZMTiiAMdoTrzZjyi6nxuriiBkpmtd+GXFlB5T2Mc/mFGC0VVbCVjwp/Eb3FUtYDiCETEQzk+Q+Inxni0rdnrBXYWbM8Fer62XH/ASqU9D3hICdIIYCPaQnqt/LgUvsUqKa/5LjMQYQQLlzgsIlx/34DufyLahUfTVXX5mobWp3Kptz1eEa6MpISw67pkTANEf8uy1skg68jOtuNvyj+w2BpeyImeVdr3VZNCrLXsTL0mhLX72At5h9rN4XgaTGwry9DtP3kK65BV6LMZXF5O9V33l6a02RawquZfc5ZsvuFWg5BVI5elxYldD9LGS1mUz5qTirVG2I4FVX5cRwmv7pcQl0KNPbQJqXO5LA+Up5eAakx0FWFaoTlDjh2YpNHlsAeQ0l1XzZ3QZERBjV9ItwIIjlC3uOXd3gKhoWywtQlXEhBhYcB++gg36AO60XavQ/nzEepjOgZfr/FPwpVw6DrABdjprQ6e9YUjw0UBhjEbItDKAwIMahl6ncGmXsMT6y8zTvTQhwyQDiJ6hakq3xt99JAWrzcXqqZzfn577VwTqSUC68uHICMvxOISGnOkACD2MdzS1BJ1fPoWv26XNw2IofYFqc
 zRb2agt1
 k4uGdyNVdqHuQd5Dj+NcEQqEF5UroE441brMfDxzFOtBjAsViMUdYy2drdDOP04gsuPh34kLfSXGvqtFhDyc9ala97tWL9JW2shBY0Vq7xuDSA1EaVqepm1RmsK+XJtAQxo+chGvbTqXnscFTlYxKT5EP7nbs4ccPPrboG8Iwbt85YHVRwxZIM4KwyXYWIpGo1ugHGgI7Bo4WSwI9vy+kiNjccrJGU7VQEJKM+SXIKbWPhIVcO1coehkCAcY+NUyJMKuV0TNWj9D5XdKT1xZciTLVog==
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
index 8f845bf698b2d..91f137901e726 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2439,7 +2439,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	struct damos *siter;		/* schemes iterator */
 	unsigned int sidx = 0;
 	struct damon_target *titer;	/* targets iterator */
-	unsigned int tidx = 0;
+	unsigned int tidx = 0, nr_accesses = 0;
 	bool do_trace = false;
 
 	/* get indices for trace_damos_before_apply() */
@@ -2454,6 +2454,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 				break;
 			tidx++;
 		}
+		nr_accesses = damon_nr_accesses_mvsum(r, c);
 		do_trace = true;
 	}
 
@@ -2469,7 +2470,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
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

