Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56ECDCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436DE6B00A7; Thu, 14 May 2026 10:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399EE6B00A8; Thu, 14 May 2026 10:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDB26B00AA; Thu, 14 May 2026 10:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0608B6B00A7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3CCE1A0283
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:26 +0000 (UTC)
X-FDA: 84766207932.01.6D5079E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4185B16000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3J+Hs+b;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOblmcrpNNxtK0eTG4SXbWVakrG9GNaqWHp/w6TZiPM=;
	b=vWcQ4ZHl16sYkmIUh2ZeXnOtuF6DLKDFcYbBw2fyaGcE3udSbzMP4Dl7YljNUZPg7IHzyg
	pAXuLaQ+FNdYICsPFGvD/47sKTd+iiQo99NdrxPYHiPTxnxMP+fmzxkgg10tKR0dt9NP6n
	ogT1Pc1L7iFG3AI78TVxwakMdC2QsDg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3J+Hs+b;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767765; a=rsa-sha256;
	cv=none;
	b=Lk6wg0lrW9HXtmtPkf7di1ZYjjnxVLjwj1SEKpqfGAtJt3dDaKuFf18zWSokFfuodu8z0b
	cMYTKr/wYJcdEr9vG9FP6IKd7aJKNF5VRz1mOp2mhWq3M0TyisqwqQTfyFylY2+9g6yEoo
	hcXTeIMP8S1IPQQoeIXbOR8+naHq7+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF11B60132;
	Thu, 14 May 2026 14:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE3C2BCF6;
	Thu, 14 May 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767764;
	bh=98x5lFOR2XwPdx9xbb2XrTj95QF7fTzrnwdxu0XvwKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3J+Hs+bJYJBU0vB5bjHF5kTSDn6wUE/wGRUGO4rlA1fMJnyVu3yoIeJqutZBg/L2
	 uoRGA++fdIkiAYeGWLvfm1UDC49pJjegfkNpZsziypyKWN22sOEj0oet7h26/EDA/C
	 v9covqeZp5MHiSJNxkQ48nFxv48Jv1gZUOcWPytCvBxzSSazkTMFJLYC0N1PrUbhpz
	 TiIaYOPwfHZPsLJs2A/qqpqYm90DZYavaguOVQI1jXt3FLO2r3H6pAnnQYev0AwjHo
	 ZW9OBJMAQUkgPN7vFjmkCr8SHDvRgk+Tqof263gHDPdkXIIIeK05U09CETSZNSWdK4
	 7UwVwvH7rAWhw==
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
Subject: [RFC PATCH v2.1 18/28] mm/damon: trace probe_hits
Date: Thu, 14 May 2026 07:08:51 -0700
Message-ID: <20260514140904.119781-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4185B16000A
X-Rspamd-Server: rspam06
X-Stat-Signature: atjhz4afhexrnpkm1kjmg917en9mhht9
X-HE-Tag: 1778767765-141036
X-HE-Meta: U2FsdGVkX19rXmmXl0omM/XY48CsdVeBJhmDHkiF9ASAvgDLw12wIJGnYOgjJMxwirfQGv26DpM2Mpw/DLeInmK4+IbedLmMuIjeILMnNOqZM6FY8B/nfwweGzGLwI7M7+pNQuDSfvnAQIV3TQ/cux6tw4ERtZ2ykcWjyySv6noo4e+ChoZLDPPTkmg30yRLiK/Rx77wxQYaNJmXRnjAFE9+7b0FG9c+kYgiopX176vXmrCRszngDeoDb3UqBK6wAsRBs1DyVmRL/rskIgbTX7Km1cwMKTb2A08l0w06DRen0soJ2yGb1yk/9mTjjntAGy1dSBBLx31AdoIFd+p7e/u5SsFPQfK1M6m2xBBtWj+6MNCfimMR8DdxzMQQwz7do2O0dsfYuqzX89CgUnSw11lz2Vf2EQF6pBQOHhqMaP3sn4tGsNosZ7AT1Cj3/V8TNz239PMdxXB7H/1hq4ZRcyWVJbIylZ1n1bo8TEqNKPbFikLWl8lRfAoI3n+4fBoUbHcXJZK2kZvvKw9kxBOn6N2XYWpPMurAqH+NOUNpy82eM35up6wgdIivO6JM13pIjqGBhFWiwSXrqYRsSMiT/vhD8MDxw5/d1307J1lAGZhA+u73+kVK/AzXHIkohifD7ocORbgaYDzeYexQxf7ea+RMSzIDDMNls7DsgfSmlmOwurntEaHsUDI5nMz+2eAEXWmFiR56mwZ1+beMjX9S+GLn2/uFQB33tO52fNG2fsRP/8MwnzcHiyqeHebCSiU10N4P0aC1i5u1kEX6ZtB+iWODXAHpWRbZKqEKJ4Fem9r0AdhQY5QsL2au/ymoyQVbDtQ3qjg8xRxHNURmjEJIMpqzPTdAtcSMCcp3KEywTrGF6+u3bvgmWuGiP6DtaKX/jnvZ8fc0B8leKLq//hr6YH6titcOKSFGP5VMkrdzU0lfn+WH6J4Spe2cqIyjqN8LxaDCWLqgklwGszY08I/
 3BYXrUoH
 jZWtNW13PrSH4cUs00zGWVY8g/e1+TRTVjTgY8lPUR6HPDzamEquexzrb+NHiRviFoWce/zGVb+rgSqOzexbIqKwGhKYJ6X4MEC4pc7DEfyhhONpFzMqAHjuikgF0RQL86yLw5T4G6R1UmrQgyjPN8ON5QpNm3UMx7/CyRYaupaLKWowQUcZRuLPHMGPs1t1EATl053Hk1Y/yCIcpauUwyNv1QfEoiLVP07EDPoOEQlkcWS3x1rFm7Zupasr475mX9lhBXnj/nZpQufGGRQZwGXZo7w==
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
index 7e25f4469b81b..2b96a03876034 100644
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
index fe6c789f2cecb..0ad1a0af06893 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1905,6 +1905,13 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
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
@@ -1913,6 +1920,8 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_aggregated_v2(ti, r, damon_nr_regions(t),
+					nr_probes);
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-- 
2.47.3

