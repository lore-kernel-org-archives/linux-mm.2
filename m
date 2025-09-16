Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B90CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9EC8E000B; Tue, 16 Sep 2025 14:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BD28E0001; Tue, 16 Sep 2025 14:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED0E8E000B; Tue, 16 Sep 2025 14:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 552E08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:31:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDDC913A507
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:34 +0000 (UTC)
X-FDA: 83895956508.28.46CA85F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5290F180004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MoQXHer3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758047493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62alQzlC7NfTK2oYF69NPAp0DaceyKSnenQ6ahPuFMI=;
	b=JtsxoC52N6ZF865mjJL3LhPgjF+/7XPXEjp6cCln7Us8HEbh14hM3zGWuPx13LFHRFT83f
	3mm9Cr4zzQP1xd/zeWuQmm9edaugfBqDfcHo48GKPY5Y/ZbtrxmNFiPE0M355NtvQrovBV
	rEAWb2nnMhi34sE1wgumDbIE8p+S67w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MoQXHer3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758047493; a=rsa-sha256;
	cv=none;
	b=UNj34PAD1wzx/k0hl4PtmA6Y9YasRkE8Z1JpDbi6i8hqjnp5MiNWGWOz4jQ7NB/x1yFix6
	wJ7HCc1gOyPuIcaTa8ybf9JhWkiz63S5VpOkZVNtPEXm9SkDLXqfQu8HLuNlQPd5cso4Eg
	17ACDk1U6/LGhdHmCIvMACfbKDG/svk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0778B4486E;
	Tue, 16 Sep 2025 18:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DDBC4CEF9;
	Tue, 16 Sep 2025 18:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758047491;
	bh=BVPIvvATKe2I5aamkuVMwHJN/okxBP1F7amj6w2lqa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoQXHer3AtMIRfigqulPv6i5Mkb+ktfl4XK7TU1Ai5vW1g6Pp6u/gKs/5BKnGDkQs
	 lTSekckm0rCrJzkLz/QOwdRP+1gtL3NCsrShjfBLgIxSTIc5pOhFCqqmd626C/3wA6
	 G8g+OFcc6n0/XWjudponNYf58faEGX9AZ0Nc4s7ulD1GjoRGoYWNAIW/W7TzCv0nLg
	 Jat5H6VcbTLyBj6sRlzvaC1DQCkvfB86S2CbZItmg53Cz4r7oDfkpmuQSHPVdZ+2dm
	 9AgyjmUs+8pJDiGVmfHlWSH3TqrPeq3OtQ5xtQlTQrzdbDJxUwxN4q+djN0/ksi6RI
	 UREY/Vn4s2z9w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/stat: expose the current tuned aggregation interval
Date: Tue, 16 Sep 2025 11:31:26 -0700
Message-Id: <20250916183127.65708-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916183127.65708-1-sj@kernel.org>
References: <20250916183127.65708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5290F180004
X-Stat-Signature: bp15ywo5yz71t7zr948wi5iigz9a1fab
X-HE-Tag: 1758047493-442095
X-HE-Meta: U2FsdGVkX19oT5kSnLej5FTszfGhMgzEHSzY0L2OrTRnzmhk+EL3r9HtzavPAjqQDcc+JAPbD5OcnU7u+QFGYREezPj1zB63u4v0ZDSJ4ZvnQZFLDfdJ5f+41nD/TB+nWfkueKOKOxmReov+YFI9Ro9LEVYj5gj2+5ikDLUxhZIMZgFtZkmMV+aYmBuPyJZaGj6d7Pr5E6oMhTC397HdFu2qjbH287GxBleY+t6Hlf7Ca37Wrm7bf/wTPIlHOEcd/1YQNJQ5EL/ViZiGHB+fzz1PUV1dw9bOwA+JWGVxTxLU0lVrGMkUhXwzlxByie0lBOmfxTqQ0S3EwNtySSs2hvUxw/UsoSnS6einXj1VK6IqYbspQ+7EZSFn0aNqEERP85/bFxZdiVQqeNzsjcPx2pW1yfPGbkueEQg6EUE4FTGceoIith0ZVyXI9gWrHG3fOTEabDhvfbp5ZlReaHeZynvkEYmgcPF3rcSQGSvLiWe3Ll5UvHWqtEiGxo2KNALBYbI0qODTdLHVjJSQkz0H4f3p+zfz9v9KOu1/ZowjnXsudW0plCHoBZXQu/22Ub59wSYY+LLZcgWIYFEcyCE/Gs4UJJLdyea28XGEX+XswiSoZ7gaGmXPAReQ8ema2wfYRHnLcRutOn3kW0jjXFFd6Yrnt5ST9HmLP96omQghBqhcN5dc4RdTN3qECYMsSFUssLF4VO8ydXQ/DLM+JCNHkpjTfJHL90tqlpPQWSHr/Frazul1HiaIR719nWlwCd0HBdZ2WR69dmko4ykbpvrxF2sWHkiMqJaqWujyfcrgsmuL9s+ikwwEg20b8+HcTUmMaejOF0URtLgqYGWSMy1LX4teniwV0Lb8xCStb6Xa5hwRPhmklXHzXoA2NE23UGZO6529ppKxYFHS9s/ezHB8K1toVnyyuDRTWXBUefDs8xAzh60NDEpGgKxNA8kSjl+i0fOjQ3XS6CZpyq3imvr
 IXHA4fPF
 mkRosl/9hirqw9ThF+fjmEIJkJb1yF65H9ArHtutbvxZbgCwyr5jIg9NLsvWFNvxxR3YCZKQL1JjntQqX2GD6fGGkw2cEcCNwUNhsYFhc9XbgudD0T435QbbdkYMJZyUNb2vcCHOCId/yUacVb21hhYLHjIfuUMv6yOMqEqEdiG8KKHHTn/pBpFu6sBg6sPkqAIq+bMcHsL45QbCVmVQLOivls70ucLyNgpZRR8ns01yuoQ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT calculates the idle time for a region as the region's age
multiplied by the aggregation interval.  That is, the aggregation
interval is the granularity of the idle time.  Since the aggregation
interval is auto-tuned and not exposed to users, however, users cannot
easily know in what granularity the stat is made.  Expose the tuned
aggregation interval in microseconds via a new parameter,
aggr_interval_us.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index c4fbd8cfa5eb..1a8465abef4a 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -39,6 +39,11 @@ module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
 
+static unsigned long aggr_interval_us;
+module_param(aggr_interval_us, ulong, 0400);
+MODULE_PARM_DESC(aggr_interval_us,
+		"Current tuned aggregation interval in microseconds");
+
 static struct damon_ctx *damon_stat_context;
 
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
@@ -133,6 +138,7 @@ static int damon_stat_damon_call_fn(void *data)
 		return 0;
 	last_refresh_jiffies = jiffies;
 
+	aggr_interval_us = c->attrs.aggr_interval;
 	damon_stat_set_estimated_memory_bandwidth(c);
 	damon_stat_set_idletime_percentiles(c);
 	return 0;
-- 
2.39.5

