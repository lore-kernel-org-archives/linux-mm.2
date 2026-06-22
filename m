Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BF7CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71316B00A5; Mon, 22 Jun 2026 10:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47DC6B00A7; Mon, 22 Jun 2026 10:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84796B00A8; Mon, 22 Jun 2026 10:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89EBD6B00A5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:21:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE87114018B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:57 +0000 (UTC)
X-FDA: 84907762674.04.077CCC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 66A1640006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9AbdX4J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7ZT39s1NyEHK1m1KzkVPk7KnUmsyN/736p/CsmH/DY=;
	b=FsJvUSe0ke+zrM9JYIl8nmrpxmuGMHBqAlpGk9bhLF+ePBLOM5qLdnxN8Kk8FUp7f8jhWC
	BwbL6VC95mJAE1IKuNrI3CccwNcbczcnop6x+Q0vqsx5SvhJtOyPEqjYTIQa9/V3peYv0W
	I0ET57C5mPs6IVIF3B5IbYp7voFD8HY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9AbdX4J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138116;
	b=m/1GpHsrR6l9b+PJzIaYeVmXnm6rMEUiAA/A7RwW+S2aGbWiUZID0OHXiRxyDbF8Q3lfvq
	GaYRfPt4mCjOL8IBDiOb1ISBUjoUsL8e+z2yFi1c+kLFldQ79QxNnNEFkWVHLmAKO7nE1I
	qHjqTezYfR67ENNC9xZ5Pr8dQBMxa44=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0B48601FC;
	Mon, 22 Jun 2026 14:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F291F00A3D;
	Mon, 22 Jun 2026 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138115;
	bh=f7ZT39s1NyEHK1m1KzkVPk7KnUmsyN/736p/CsmH/DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9AbdX4JMVjrLCGogcAwltbOLbBI9v9a9Pq7hWRTnpHk5cEHydOr4mRRQEJDBa8v/
	 H/2kPTXk6tlcHWeM+30Ksdmf+/zF3Ci4bDi4jsY4CS2rJMRxvFdNp6yjbSk131ryIy
	 S1PpJF0fqOmz08hXQUgZD4UWq2I13pC9/PgFsY8f5psoQlEgBBgKAA3BxclYgNx8Lm
	 80olg5NQbems8h9ufKJm/DywugI6JzuPvYLseR65mSHOrVMm/yhC+W5JWcGUlWngqQ
	 5VOmyaAlHuct7LlGlQc5SBojAH69BVLNYvpqozdhyiSNOOEFQkZ91IV/4gMRA5uNlf
	 tlG1mBoHBefIg==
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
Subject: [RFC PATCH v1.3 06/18] mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
Date: Mon, 22 Jun 2026 07:21:26 -0700
Message-ID: <20260622142139.30269-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 898qp4cuhxtqynaykxbkf5ppoe6y4bg3
X-Rspamd-Queue-Id: 66A1640006
X-Rspamd-Server: rspam11
X-HE-Tag: 1782138116-993951
X-HE-Meta: U2FsdGVkX19u5aCwAKkcsB6LZsc12FV7vh7hiQCmYaQNFPOIRZmGA+v9kzgSya3SKVY1ESKkIGtL3FPVkcDQUoz52I24OIroHe8RpwOzCxg4B0aT80ph4vAShpedr5ugtFqqxHc8vtF625JAWSkJTnzQMF7KSj++Ktwp7RGTmI/OlPD6iYZktzblrkVs6/aFelL+hnquW0vRslZiyOl/3/05mtsU3SPUgocXCHdQVj1vHyGGlnEg6maJQIP+ZRCh3OzSeGkt7A3BERfwByDDDDCy+1iG86ayd7QskbZhPVNl/3e7UaNNFNrWhmgCUYafwyvW4FboSC3aMTON+WbSh+FgABe35hpL3QDJhTpZS03sbaLF1Ki2x9IOtafdEXTWO76GiAcnMhi/0Z5I+Gn9UIFAg6Zc1ZrMF4RQAkxGjpe/a2gR/iDmds83ZDak2JxuoM+SSu5Uds3kpHs5Ws3Og4PWNszlJ0fziQTfVROnFQzpxbwEFuHvsBf6K7SlcqNsi3ei8xiNO+137ZCAEQAb5IrEsjSffjEm/nFLugk3fS2c5jIuQa2xBXqNLQYdxKsHW/2Y38Z7h2L0MO3tUb4g5iELpRBOIA6RmHdA5JEUAbz0YSz29B1QuyGiHRpkcS9RHWPOOvR079WMUBJNumaeSznZtF4Lk3ng8mURxc7BQNwIvSN7155J9fShEIjYVev2WML53vsajCVsBmm5ND2gaYGT4ghbdLHUmUQs8yO3ujcAoDhDd/fhTJDM2wT6PB64F4iBwEKNyq5lyduiNC/Gcrojc6V+An/Fi4PhqP09W6m5Xi3ovvOEe0BN9GgnwQied7fc5k3KrPPwLxnqZYZZIkWHCtm55ak+rx8Zs7PaKO7kZf4TPg5NlbiTz/gQAv+4Ai1Ur9r74Vw7S5rllsRI+9kEPvj110SLYDJf6APraHEoCJhqrsH81KmxuVQLVBgyFn2I6ByZgiVdpQN2s1h
 G+8Viujn
 9GGHeGaDbCTlrxbfbhnNfwImfMivMh+oyMwRn2HxdCcQjXeO0epckjXzhUD7bSLhlKz6DsvQXg0KSnwU/FBWd+PrBBE09wAcHygHeRDFW9gfg2cwOI1vrkpHh6BLN+KcE29EnZKCPI/TSHUlPoUbJxxWgQy/fYuthawxHI9WWI7eGJixb0gS7wWuxlnVepGxWTyPDUH7+w53b4EGle4bqBZccBVDG4fSXeCur40+5yuxwQ3MRHzCAi8Cqt8D5j1c4SQvzwekHTkx5TYq4ryA8+CdgXg==
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
index d6cc538172b40..ca68c4835c391 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2442,7 +2442,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	struct damos *siter;		/* schemes iterator */
 	unsigned int sidx = 0;
 	struct damon_target *titer;	/* targets iterator */
-	unsigned int tidx = 0;
+	unsigned int tidx = 0, nr_accesses = 0;
 	bool do_trace = false;
 
 	/* get indices for trace_damos_before_apply() */
@@ -2457,6 +2457,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 				break;
 			tidx++;
 		}
+		nr_accesses = damon_nr_accesses_mvsum(r, c);
 		do_trace = true;
 	}
 
@@ -2472,7 +2473,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
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

