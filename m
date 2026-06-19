Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA7CCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1526A6B0096; Fri, 19 Jun 2026 15:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A4A6B0098; Fri, 19 Jun 2026 15:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018EB6B0099; Fri, 19 Jun 2026 15:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C61CE6B0096
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BA69C1C56
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:36 +0000 (UTC)
X-FDA: 84897664152.12.093CBBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3E9810000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUrKa3Iv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBCI0M4GDy8fMB32IVLMHZ/6Fxv+XePbw85r3F9bljU=;
	b=Gooez6wmW3HRshGpQxWQdd0PSo1Y1uk/TZZgsA83EJXjSsiwuvlysATP3rQ6vjOHss0GKf
	L+sm86NSgnI5aXB1g0vkSiWq+EhigDFObMA/VHrlRJv0wbPurLspj7h2rAtcz9jg9djv7d
	HNuYlMJTADGUw9Mj+vRdpgnATn93EBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897674;
	b=sWBFAcZmaktJ5u7l0+3bBeTgZIgDEjdd7Vguj0Hyw123NeIC4ssb96K3i1XPLItsik2ZS4
	ZxApde4ZkJKohBII4JjlEVYzLyOQodmYK/zFL4ymHO1uCOtSelnhWRRT7h8y3vMm3i5r1J
	/eekpKLn3QquWqlDbQzmT2F90HZ+DRM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUrKa3Iv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B915601E4;
	Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9631F000E9;
	Fri, 19 Jun 2026 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897673;
	bh=wBCI0M4GDy8fMB32IVLMHZ/6Fxv+XePbw85r3F9bljU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUrKa3IvwiWu+Q9HsVwBmNvw1qkTmqkjo18eAC8ErsJS15u1kpGpSA5rsr2ZLmI9x
	 p7w+xO/u1LURKNAI7PT+cY5FrPl7+NeFZTnItmlkkpzaGUd2dxNu9RfL3GkvNBA2u1
	 khBeunR373+BGhtrMkLXYQjCp5X3cR/1+PZEFElOkHP6P/NAU14h+r7fvh9/kOTQgn
	 7L9oQnJS2Ecwjjabc2Oui7L5ppJo6CW4HiZKLD9y/LNDmSaLuch1x9mUx7P7/TGziD
	 9jYVErKePaabNjkrxzFjmZCBwxNHYSf6kF2KSOe4+Cqe/2/+9w7RxJ27OwgITNfIMR
	 5GCQG4D1y+diA==
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
Subject: [RFC PATCH 04/13] mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
Date: Fri, 19 Jun 2026 12:33:49 -0700
Message-ID: <20260619193415.73833-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3E9810000F
X-Stat-Signature: wk8jrpgcu8izrqipstsjeq3asy3k5cqy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781897674-21050
X-HE-Meta: U2FsdGVkX184MogVXGegdBdsWxRzRePwPbJEGNo2p8PjYYE4tt2HKIaZr4+tm/ZMwmQgHHlE6tvUGDXweX1pLC6Uu0VLHRLmWV9cc15vsllpnxWeCYssuLQ+n8rL0wARNDvKV4d/DE2o/rA5oyD1AcbANhGonA+G6iN9fM2X/+iE0NGHrsnSCohyMcfDvedhUtMY2/4oZntTOBo14Ayc7G8AXNe1M5x95/+Y4/cJLzQKXBW/FN3FMgvAqnV4EWIswrjFiR+OoGHYCdJAlThyoNcdaLTAEpkUGWcTmmkV/ipKtTvC4a7WqBpVQbTvm0LmzqYbVB286tmo0FW3pNgAXRYxN1txyysyriRzmxc92KzsabfisJO4JZktJZPX7pUB/WrDkrGQX4hnFERgZMhSALomPFLeEJVq3Y7YmrO48XkA3zTX/iknAME9apG4LZuUawBoPIU5+n18G0+rUb+/Eiev4gZq1mWXm6YAMUE29ry+DONNYE3qc15qAQt4OCe3nkJvgYR8DUj8AFafcWzDvjzp4uCATGANRJl2mdEJEdlWLKC0YLFpODWQZ1WWKTI03EMzryoxjUp/Fyz1WJiFjhKTZtv1tWpxE9gHIHYmK3ISC7OuRnkLnIWFIKwY4r4Q9lQRxeJLemBFYRVse3Jh82GtAqvjyOc0Atjhyezq/P+VEn/7LNrKZIwbYB31oLxtVYeGgrYAzLeC237dDdfM8et5ZSdkHo5uAjUVyr2r13gn0Yn7eHkQYQWxbY58Pb3hnPIq2ZxKoYL4Cz7mVkWlDWueFSLUFSs7lo99cjHiJ81mMwsF74kN+RNC0WabqA15A1XN+G+k2avN2iVhhGMGPrtN740CJWr26sULXNj1B/G42fXn0k7DITUXNnOwGzU6GSqG6TqOmSXfpriVGiTezptJFH1DWx/Lwy0JCuhWFiS0tK/cVlc9gggsZLasCYRlK0MBuOe3fYY0srktDZb
 Vb7XTDZa
 gByprdqwHe7yeR/tp+YvkwWhHA/37E5pFchedhdnogwKpGIHaWJ8yH/P1pvCWaBhmL0CaH2u7s5pT86qDOpQeNsZOrgc+9+24mDsrK1VD+YgATR4Q3ygVQam8fGGxQfZpuvqqhaKraa+GeYUDB5Ln1bHlPQhbS4CTnvLH/HDYUUF635cG3NPiHw2cdTeYeRFsh3cpTMJCBmPDZf6uanCbDP89JyPOfNwagL1ssnF7ycdmiVoclEcaJmxOD1o/NdRc78VSZ6oyJm9nIkh9E7oK0qMhLg==
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
 mm/damon/core.c              | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

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
index 3a6df10ba8548..2eddf2674f4fa 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2463,6 +2463,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 			return;
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r,
+				damon_nr_accesses_mvsum(r, c),
 				damon_nr_regions(t), do_trace);
 		sz_applied = c->ops.apply_scheme(c, t, r, s,
 				&sz_ops_filter_passed);
-- 
2.47.3

