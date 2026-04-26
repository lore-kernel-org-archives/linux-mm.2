Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68B5FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36D46B00A1; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EE66B00A3; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DC66B00A6; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A64C6B00A1
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 448401C08F2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:43 +0000 (UTC)
X-FDA: 84701905806.08.C757282
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A568E80005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XueNJUqJ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7USjh25t7fZ9hlpYqe18XV7vJ8+Ehu32KbZf7pkYnQ8=;
	b=kDtilMAEf3ceb3oqpygysjeneHV5G0/IsHuNqzWiNdbZyA6DTE80fA+RxO4dN8J61eWRGG
	5nLAgLK8zk/OwHYIbKAWCt1e6W6A5C56uwZLS6QBcywXbtp6o/qNuRaDsV8h4f6n+qnc+N
	e1MPZRgV0NATakSa2zrqI3Cuj1PXmJw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XueNJUqJ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236761; a=rsa-sha256;
	cv=none;
	b=Pco8p1GGG6II/GYXsqeAeHDbjTeh6vnKrinX9i5NBmpb5aDMaHjZ9aVq5hStzYtEFowkpM
	rwoOc5dHTZDLxrPo4P3TGr/W0p2CfwVpJjxIBKBa/NwP8ZnqEhkQPyS6Ru1/quKEZuUbnt
	saNJzM2oYd1xTEZ7ayRBlQsOT6iL3LE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D09A44703;
	Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB18EC2BCB9;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236760;
	bh=+a7yddQciqqedy5ZtwOx7GN0gf1QkvZ1siaztRsfHgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XueNJUqJZxVOF0+nCu81W73Mun0zKB4VqEyoU8g4s5CAtrjiTruK9zvTirpu4L8cJ
	 jBBt/Evy/xW27IQjHPwK49MHrkWVWLb+jkvgXH/bdIK9UON6ceLjLnrjG0X6QUKxdD
	 PmLFt0zBMdWppzB8Pgc8QXExTy4exESNBfaWrxNo2vLjfifc1XznkA7lg3MYou2edR
	 rULL3h6aQbqYiLlveadLZsukd7kQyGQMtVk6YQWnirRHV9PFfqJa6YxJUkahzYfh9f
	 wzhQhh5ypTUQ3UP7s0cdmKfiTg93GOEdrJVKoTYCFtGCJm9tcU3J9M5Zzkj0jCpnPd
	 95hpqoQGgQUuA==
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
Subject: [RFC PATCH 16/19] mm/damon: trace probe_hits
Date: Sun, 26 Apr 2026 13:52:17 -0700
Message-ID: <20260426205222.93895-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ztdnr5gbo8cm3741qjzwodwhj1fy99es
X-Rspamd-Queue-Id: A568E80005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777236761-673
X-HE-Meta: U2FsdGVkX19bCou5uCP+knHiiNYaqN/EXnCOHanUEy++zvjIa7USe48aKePqVQ9vbN8Eb84yNB8TpjzHTJYL6cXxb2AqnF+Pj40vJlMwcqC4nDYZ/sw+krPktPErW3Eh211/6C5AGghJkiWMPJRXD6fMi7370Vcr4P+VUQTfXzPKxhlTRy0Bxk0dgh+BOJjofVS/Gs5xszmH/IW7ee9949rNPtlJ2oVKIRuZ+HG9d6WlciFopYiHf/HRC+YItROvMFP21nKrRzwr3YZ1ZzOgBgjkAiZ1xsasAjILqHrmVBivNJrRK3z4r9PRMoMkrJYED5iItB/IN9/j5gOSh3eNtERnfABgl9GvsB8cyektenkOTHLTC+QM73szAYzYFjzpoLHs4Bs96IQ6ourzziLCLY2aRjMfs9XPeX7GjhrviyAGIfjSic+i1l/UOuaQFgc//hDY96CnOkkUYLdd14blLV0U2kazS3yHd7ksSi1MJByaGVA6gFu2mLmL6+DFB5gFoaHF7rT3clDaxkddBvaeO2WVM7chNUzXCu/+ksOc+2g1nGg8FECs6TxLAQd9LBPt6C99kQRY3UtjiizKUEutr2sqGH+vU58zVqSJy7uuYc9een55dZcnvzntgwX5NIh60QsxwfhjldG2OkqTMxEx/XQXdUpvx9ZYv1vBIfFKSIMBeh3b6ebm/Qw2LN8GD0U0NXMNiVW8sPtQ1FX8AWjyInKe8vFGSY/zRwEJG167vfAzUmgOdUqfOCkr1LkNxMaKPt0Ax+RsmGLeAjsoPd4WcY0WYyPiuUirY5R/hhc7hekZ8kR7svnp1cudxYw70lBkOsPHIZkydBPJ/frP/qaqFFAFbJaqgo6wzulsKORYjzxqR8zArtXoTBLD+pfaAd0oB1y1/O4aUzwruF0BT7fA7kEFPF9nqWGC1CnM9nqY6XvYzkZ8fCdyMEyJ5ujlN/JQYwdHcVfgwjzQEBxw/f0
 9vYxrx01
 BqEtm076HUq/Ib7VEj8wg43Xcjs24mPBbscHou8Rr10tD/MFGnfMDmtkhmZJvsG4ObRN4yChXGTZsgcL6UjsjkUYKSP0dNoGpRFYKFGrxASBKhj//VBuMiBpxVMsf1eccIXo1eccMtvntPyzsbm+wrx5YUX666V/m0JoCByLZBZuzA6/oJijpsqHXzAeq5zsnydt3B+0mJyxZWFHHgAi9hUZsMX9t6pumHK9dHNgyWMz5Calbw5DSP0aMX+q1LwIkRBB4UOeqDuC/c5NcdCiD/eqwbA==
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
 include/trace/events/damon.h | 41 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c              |  1 +
 2 files changed, 42 insertions(+)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 7e25f4469b81b..121d7bc3a2c27 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -130,6 +130,47 @@ TRACE_EVENT(damon_monitor_intervals_tune,
 	TP_printk("sample_us=%lu", __entry->sample_us)
 );
 
+TRACE_EVENT(damon_aggregated_v2,
+
+	TP_PROTO(unsigned int target_id, struct damon_region *r,
+		unsigned int nr_regions),
+
+	TP_ARGS(target_id, r, nr_regions),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, target_id)
+		__field(unsigned int, nr_regions)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned int, nr_accesses)
+		__field(unsigned int, age)
+		__field(unsigned char, probe_hit0)
+		__field(unsigned char, probe_hit1)
+		__field(unsigned char, probe_hit2)
+		__field(unsigned char, probe_hit3)
+	),
+
+	TP_fast_assign(
+		__entry->target_id = target_id;
+		__entry->nr_regions = nr_regions;
+		__entry->start = r->ar.start;
+		__entry->end = r->ar.end;
+		__entry->nr_accesses = r->nr_accesses;
+		__entry->age = r->age;
+		__entry->probe_hit0 = r->probe_hits[0];
+		__entry->probe_hit1 = r->probe_hits[1];
+		__entry->probe_hit2 = r->probe_hits[2];
+		__entry->probe_hit3 = r->probe_hits[3];
+	),
+
+	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u %hhu %hhu %hhu %hhu",
+			__entry->target_id, __entry->nr_regions,
+			__entry->start, __entry->end,
+			__entry->nr_accesses, __entry->age,
+			__entry->probe_hit0, __entry->probe_hit1,
+			__entry->probe_hit2, __entry->probe_hit3)
+);
+
 TRACE_EVENT(damon_aggregated,
 
 	TP_PROTO(unsigned int target_id, struct damon_region *r,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index fe14971d72747..54834b74efef4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1924,6 +1924,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			int i;
 
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
+			trace_damon_aggregated_v2(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-- 
2.47.3

