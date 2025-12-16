Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B737D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2806B00AD; Tue, 16 Dec 2025 03:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C376B00AF; Tue, 16 Dec 2025 03:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EE66B00B0; Tue, 16 Dec 2025 03:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 700026B00AD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:02:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31A628AC52
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:07 +0000 (UTC)
X-FDA: 84224591094.19.D4B8D8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C046140002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qiWaYlDd;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prE9ql26JA4j2cs+rv5qQ6e3/bZoSINWJJWa4or49Wk=;
	b=7gIkl5K/iG4CMeIqgsTVW/m5heUsLROPDmdrEirqTehRKpDB2AZJDXtpbUQ9BwEoA9TlC6
	rPYkITebr46uMLz9lVaWVjOueq87/2PQjGMCX46lHkBk9TgGJTrivJbo9I86IaIhruBqnM
	VJolWaT6joNQapnbqi3seEkJ9SLyfCo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qiWaYlDd;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872125; a=rsa-sha256;
	cv=none;
	b=w1pbU/AIjCg+zPF04mNoDFcX04iILwAsT7dK0ta3XFdtBOQE+QAwWfeSu2/2OkuQ7nlAj6
	mVjTqu0qQSagBt5Ijr/U0zuyAO9VrM1rWDW3kcelKDWEitmuU8/+undYExcncscq4/hXfk
	ZkrSuTknyUUcl8j2wh897sJoSqSKfjc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53367601A8;
	Tue, 16 Dec 2025 08:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E6AC113D0;
	Tue, 16 Dec 2025 08:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872125;
	bh=UYABSgwRGNA1IWS8REj5rib/2rvNak+2C8vgI6LoV8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiWaYlDd5Ydpl3Fdoh6hNRSX4IIqyP1tMJTKMFAIBbhSq7b/kZO0WM1EwS/8d5h2k
	 0FaQ3b495L08nxbjgFYMklrV6IEiQUT7MHMx2eSWmEKkhKduhVPjMJS/2IEbPLUs8e
	 c7hNfBFezqp0gEjMEaJCi+7hxBiyEvF5GgYZC8jLMMwBCxrXhFj9mOAUIAat55lo4T
	 FbJe81yWXQbMQcpKD3CCUKkmYKJOCJ//rVEYhs60amSrL5c95DBaKSp/3R1UaXsWib
	 mZWA19JgWS6ISxh1jLy/9lz9OtXMnHEz3v5so8OUJ2UXJGk+5qd2bjHhreUHGm8U1W
	 u6eG0yfCi7j4w==
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
Subject: [PATCH 12/12] mm/damon/core: add trace point for damos stat per apply interval
Date: Tue, 16 Dec 2025 00:01:25 -0800
Message-ID: <20251216080128.42991-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C046140002
X-Stat-Signature: a78m31qh4ek6bzf3nrpnehyg9zmc5caa
X-Rspam-User: 
X-HE-Tag: 1765872125-948607
X-HE-Meta: U2FsdGVkX1+9JCZsMEfNI27aaJUWMWNYVUtCJ5LD2b5hSis1cIi1vU1t+c0ajgjpJI11Xr0ZLgbNmN5hQdIDzlThgVAWEqmnfH+MDT8xU91O+r0S130DWq6881ICKFcXRsub5y2xfPalwGVVp4grcH12utDQsfSpd8DtxiFe8Tcgtut807u5ofF+SPW3lMg9oUSt2n6n6HmHxRfY7+jonk8v3yhFyxVKc+tgz5X4HAPtAIFXW/7JMdaa1eyyTgzt/HMWkfh4q9lOY3tnvduCILJ0o1PEmskS9wVo0elLY17nMc9HbE2C55GP5aETdg00y59nWFpr0zeSimnQkuMeWlcGkFmcxNVtCL3juzzyybTJMRAtDgbQ3KsTtlYwYvbY1gEl0HENw7+B6ZYnfgVxMug1WTveYfnMxF5DDegyilH1eatElCXFLTx1po/dpX3V0AiYTa4gB30xbHANJs7zBES/YyXFyRUwdfq16VKFhLiTC/75uzh37XMGCh08b85IIXoewS+wZ5Bh6ZbdVyxbC046CknhY7qFTYiJYd805BzEDgB3xjydqRpgCemcK1ouPSQzsA35r/cQYGowDOcvEJ8tvxJRfv0nqk8WZ+OG/X+6nLsM10Zlx+8t1Fg4qP3qkEIXC9lM1hLSVwvVw/UsT3st8MlNpDlquP703Kxx8FPK7h2oTKZGFJPTiMiNEtq7GVvAeD7VUgRSV7Nvfe2JB/SoXwwwP6kCssY8qDOQbiJkOgGusynrrY1Fg+jgbchvffycKq0GShn60sfWl/yW9IU4dgMlPqXQF+MN4QUM3VjTeQFvywbdQ8wZEWwGy+AR1++w9UDZmpvVBln11/5jdaf2hkX1U4cAF38xP26/ZjaQHBmSZ3nmG83QbGLE+csMugx6wbUBpHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON users can read DAMOS stats via DAMON sysfs interface.  It enables
efficient, simple and flexible usages of the stats.  Especially for
systems not having advanced tools like perf or bpftrace, that can be
useful.  But if the advanced tools are available, exposing the stats via
tracepoint can reduce unnecessary reimplementation of the wheels.  Add a
new tracepoint for DAMOS stats, namely damos_stat_after_apply_interval.
The tracepoint is triggered for each scheme's apply interval and exposes
the whole stat values.  If the user needs sub-apply interval information
for any chance, damos_before_apply tracepoint could be used.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/trace/events/damon.h | 41 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c              | 17 +++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 852d725afea2..24fc402ab3c8 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -9,6 +9,47 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(damos_stat_after_apply_interval,
+
+	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
+		struct damos_stat *stat),
+
+	TP_ARGS(context_idx, scheme_idx, stat),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, context_idx)
+		__field(unsigned int, scheme_idx)
+		__field(unsigned long, nr_tried)
+		__field(unsigned long, sz_tried)
+		__field(unsigned long, nr_applied)
+		__field(unsigned long, sz_applied)
+		__field(unsigned long, sz_ops_filter_passed)
+		__field(unsigned long, qt_exceeds)
+		__field(unsigned long, nr_snapshots)
+	),
+
+	TP_fast_assign(
+		__entry->context_idx = context_idx;
+		__entry->scheme_idx = scheme_idx;
+		__entry->nr_tried = stat->nr_tried;
+		__entry->sz_tried = stat->sz_tried;
+		__entry->nr_applied = stat->nr_applied;
+		__entry->sz_applied = stat->sz_applied;
+		__entry->sz_ops_filter_passed = stat->sz_ops_filter_passed;
+		__entry->qt_exceeds = stat->qt_exceeds;
+		__entry->nr_snapshots = stat->nr_snapshots;
+	),
+
+	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
+			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
+			"qt_exceeds=%lu nr_snapshots=%lu",
+			__entry->context_idx, __entry->scheme_idx,
+			__entry->nr_tried, __entry->sz_tried,
+			__entry->nr_applied, __entry->sz_applied,
+			__entry->sz_ops_filter_passed, __entry->qt_exceeds,
+			__entry->nr_snapshots)
+);
+
 TRACE_EVENT(damos_esz,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8908aec6670f..68dd2f7acba2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2256,6 +2256,22 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	quota->min_score = score;
 }
 
+static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
+{
+	unsigned int cidx = 0, sidx = 0;
+	struct damos *siter;
+
+	if (!trace_damos_stat_after_apply_interval_enabled())
+		return;
+
+	damon_for_each_scheme(siter, c) {
+		if (siter == s)
+			break;
+		sidx++;
+	}
+	trace_damos_stat_after_apply_interval(cidx, sidx, &s->stat);
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -2297,6 +2313,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
+		damos_trace_stat(c, s);
 	}
 	mutex_unlock(&c->walk_control_lock);
 }
-- 
2.47.3

