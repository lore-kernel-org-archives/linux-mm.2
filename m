Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF7DCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEEB6B0093; Sun, 23 Nov 2025 13:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277B76B0099; Sun, 23 Nov 2025 13:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDB86B009E; Sun, 23 Nov 2025 13:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE4506B0093
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C00EB140182
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:50 +0000 (UTC)
X-FDA: 84142745820.27.4227ADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28AEF1C000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCsc9Fbe;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJzhP+4vxLQBfOqhMhL2NXA/Rxzb4iy0vWNyxUota4Y=;
	b=4hd8zOchhz7NM/Nck8+HmF2bvQ1eOCAY6f8Tg8TXisJpmYJZrOlUgQZ4hofx02j2ENRd0s
	qbZynqEqQsIe3BRCXn50bxPCBKNEtWXMXMLkSncS4TsPxvgadMG+T+ei7SvM/7QBGmvxJY
	XLWwdNp6Yzh5pwyhSa6/EB6dSdyvOfE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923429; a=rsa-sha256;
	cv=none;
	b=TuMAtDc3eknk/K8+8qCo+nTSqqg7Y/9Aw42DjShmopWxnAviujRtIKT/kKZMrrMLXVJsu/
	2ghV8yWDypUzLGaFLDUZ5/zZMCAu4O/6KkU5vmieh8wbgzVYefYcbSQu09QesfpOgLgjVR
	V+9o+2AgiZ13IL98w/KB99M401xXn98=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RCsc9Fbe;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BB3360198;
	Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121B1C16AAE;
	Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923428;
	bh=mH5BWCQEqqk49CCwYmvCMx+4mPSEeoKbb/+aR5lpkFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCsc9Fbe1dxQvC+VyC2YgBZqZFVqvkyNxSvEcCyUenkZyYkccaPZ7WjU6SagGMC+1
	 XAQajqhn2371cO9Ln+ersUfxExuUbX0dRhyVAOIGdLG/C6SLaA7bslob0Zagkl2Pwu
	 +UcF7rMZ5atHuuvBPT3AUTwNw17iHfbMiPboUJ/R6Jg8o+LrOUJhzzZzc20IxzvVFB
	 0ptr86AsnPZ+Yhkuo4SiKXfev1eBSlyVTXquh6KPu8g6+wZbycgr/UgCdHlJT5RWFN
	 t6kFESo9IRwFeJL/ZhxyNZ8fO3xIdjn/gQuQlz2eU3FTZBpUo0VNs5Hku4Qxx3uJk7
	 U2t8nm2EO9OQw==
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
Subject: [RFC PATCH 12/12] mm/damon/core: add trace point for damos stat per apply interval
Date: Sun, 23 Nov 2025 10:43:26 -0800
Message-ID: <20251123184329.85287-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28AEF1C000C
X-Stat-Signature: b3s931ij3d81m4gb1f8oo1b9khpmdf1z
X-Rspam-User: 
X-HE-Tag: 1763923428-140858
X-HE-Meta: U2FsdGVkX1+6oHUGoOwnDyzyLmH2JJVKSB8AK/ep/eShHyDBTWlIDxEHHXeNktbMDLA8Cr9fsIdpMhpYF4FWT4+uB0ppiY5oGCCEOcjYVX9iUqYH2MfWglKqyu4t5ZDvwh7XYdi2PtY+l41G3lSYCZLQDdz/dFYM2pVSSIbu00Pb92jU+Ep4qpGmIL6MxmCDmOW7+pb+6xy9kcXCEMUIWyX6dysfjrX1iHZrh/23Zm0uvYRPAlIpVDquAMngTz4dXzcSSR8e9Izeiuo556mAjfHUT+olT9kxhq8hfjKyEnleRnRIesuUAJ7sY5no92RWGFEusZBVdmTL3e7x3oGuVeFBLWtx3qBcqboftCdwl9+/vzombrJY90vGey+6dswVV6V3WtBagEujrAQqBUyS+EsiYSH67ucaQ6RabD7J49Y3cZ2Ztz00LgRp3XlXb0lvt5C0G+BvdAgYufN2nvQeqbMy8ngaXzDr0lz0UScaX1uQ0LccjQGhRccLLCw7KHCjNR4MNwOltsS8pn5rTga8HLvb8b8LD3RoqzNO0Qdx6PRod+tQPOlhSdrSCIu1gdFRaJCyi1Iw89ZKq0JFxmrjIAC9byQnGnAx+Fljufrn+IDE3vBuAUUMmJ6XDK2HtHe4e9H3UlmdWeB8HPCSDu3XJb3ZMS1LKB/OC2SWYK6XKWs5aGUT7J3YVG9jJr8xV2RaDA0EEEoW6a1h1zfTOkXhBDfNqEB7BvqLvHXxacAfMROhUT4t/4gTTOf1lVASLBf1/6thzKwEG4JTYdU2xJPfXKAoEgBSCzh3B1tZw0MNzMDWIufpWOGmXItjP/xkHXeHoLb9uu5cI0i/NudJs7fr/wS22fNaoGDYWdD/9jV1Ob0JnVZBtpF+gFSq6MZsjJ6AMD3xMzCugA1mL6t65vnakjz6GYUGaewbmLMUHDCdcCPqGgX34QwBx+TjoOFekpPEHVFIriCb8FIf1/BS7gS
 rev+omss
 rtOwnKmyNjgrxICOhEKw1hK1v6rjuRF/Xg28uOFwMlnrkq/SqIAt02lzwRorMdWo3cq35Kt5hJHxup8ToYxPCAr+LU5f0LA3rkSU7oThtKhZ0q/XCCFwsXGLC6Ni6KoAAzHvlOrNaS95+QO3L428DK2bpGIFhyWpMcLZOpfY0FhGpzuFHIykygTUNlXdeEDYUtZyD
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
 mm/damon/core.c              | 15 +++++++++++++
 2 files changed, 56 insertions(+)

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
index 36313cd1ff1c..2f212a18e4a0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2256,6 +2256,19 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	quota->min_score = score;
 }
 
+static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
+{
+	unsigned int cidx = 0, sidx = 0;
+	struct damos *siter;
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
@@ -2294,6 +2307,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 		s->last_applied = NULL;
+		if (trace_damos_stat_after_apply_interval_enabled())
+			damos_trace_stat(c, s);
 	}
 	mutex_unlock(&c->walk_control_lock);
 }
-- 
2.47.3

