Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1747EC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B586B0098; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223366B009D; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160036B009E; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9A006B0098
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B382E80546
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:19 +0000 (UTC)
X-FDA: 85206071118.05.3FA18F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 24C6540006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/hHv/R2";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBpdI9GABjSpbOSBeiuA8iViUPE/b+K1BLYoiHpgDDA=;
	b=Aal3KFs622J4Fkk449xZZWWRkSI6d6EuVWKn4Vdvr0dkUlrgp5zSkaiG4yoaN7sLNLMSvR
	8vmBjr8kZeyoVh86U0Bac/rjgOGzIXL9jvcTsdZN7rL3pu+v1bJ/ZMKemTFLySguqi9CpW
	RavlZCF6Ja+0blhmCm/cDrRHm8KsVSk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/hHv/R2";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240698;
	b=xptXi8vOrePn+NDEqeh63skjXXNZ/ygloKJX0bJ/QzuJ8nunRAm9cGTfU5LXBp3DwEI+Cx
	kDuzCHzvsGk6BJFxObrTGDp+ypX4d7SfvSGrTjJP12+YJkkVyI6Zp2rUSpwF8WvQUo1xsR
	pSS7oWS5FAGuSYcj7ltj/9AhDn3hzA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAECF6020A;
	Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2E01F0089E;
	Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240697;
	bh=MBpdI9GABjSpbOSBeiuA8iViUPE/b+K1BLYoiHpgDDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/hHv/R2tnulEDhwwUYhXoSm0PLal63tqu6VxubfKNipw+ZB6kOqdo2/OZcxjf4h1
	 ZqDf8SWbF+r9N9cGHCgDmyoAaOGQZzPBM9jkFEH0R1raZ8pwe2dWDbA3m5lhDpXBj3
	 mwDnpLLyvSS72+3c0DCN79RClX5TCD7DzfeEThjgqJE8n7ivYXs1oXC92CD5n26pu6
	 XV2WUAA/VfaoMEb5RTpslKMaxUB9aU5jKpxhB/jZQjnRfg6SfTn7yUVhzJj9fhv40l
	 t2FJDAeqsPVeKwt2/6wiZSAaNLj8+OwqIGYxpGJ+14RisXyWKxHZScJbXTanAMweM2
	 uvM3B6v0cggxg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/8] mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
Date: Sat, 12 Sep 2026 12:18:04 -0700
Message-ID: <20260912191807.138502-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24C6540006
X-Stat-Signature: tbjssa8a6jjrdyzigxgd6fgiy5z79m5q
X-Rspam-User: 
X-HE-Tag: 1789240697-557068
X-HE-Meta: U2FsdGVkX19BjRpN8W+xHwwT4dtniJat/uI6fDWbq6mzpruOAoVSG+q4qC+EzlRXllT0GhXTNG9BHEi5zwDa95Yu7N+J1FBP4R90qqzOvU+DKv3ipDQs2trT7bPWQdGp+jVV6LQijw32Re7tf30/G537cBYApwVfGWXsZXslubxBHVVbyG75XNupjehJVzbWVJsEObI/3ud1pj1ZbVnhNRJZMnbcDZNjiH7hajZ1Zs/LN77cDt6GN7f9zUCeGK3KD8HWcV5+LKCb+OdDORGhDDmr2wAZ/dFrNE8pxp/vveiv50mKIfX1CPUgcDwNSnelCmmOLA/4xfbWQ+mjx5oFbwg3Pc7lgW6WQCchd37BKHhLtkcW1FXb/ad9X+O7fykfRsYeGwF5s7qFH2BjyyqHkePIiJvJxIFyq1oOZnZ3ETr1zIgV2AnDH0jrISGADadqgiU21rp+4R1Sj3zIxAZ7kllPdbpphF0VtRqg2neaypvk9CpydK6CJ/qJlmi5U8UL2tLGIr+6Up0a6v76BUa3Jk3xHre+DvFOMxA23xXhBTngGPSXWisiM2MYNNj6XNZGdB0srLqjgKI5FgBa5UigTsPsYI3jja6qpfC1LoH4EVX+uUihgo9M2IFCGB2KiSLk92SzOmufT2rKN4Zg7Jtbskoxfsy6ZFvCegj9jwd7M1K+RY6OQXCpCrqxI+5oHbd385f+wc3zzTBuqOb5/n5T8M9Ml0xijz32voIp6AOy9hB9kSQnJk9fYlsrHIadW2AiPZYNjx/6pzRrkLXsmAkyzSXhTlgzpwtbwxZOckgVxgb7Q9ZHi34MWKcEsvTiXK3Aql7G9kHU5sQ5fuaU5E8N2PgxBCS+glFxsNOY3a/qVxzNQs/jbfTo4d3oRKXRg+cjNQcZXFj6bs7UMlQcyz5+N1rDtgyfcvYMlkUmRMxx/rPTlnIQiY0i6hxOn31PWr+9peKFq/cY9eGW+I4yoBT
 GwMAopnL
 sRzmCngz7DCLTadBk8gjNUU4VQTHQ3yimB5pLIz5CJ5NzB6MLWv5PTYdjFAgRJeJyT90sj0y/72Y7aH5mXgSLn0NR2+9wX092V/H3OcAmEQ49anVEs4W9Be49ThizXlZ1AFA3i9nJVon9e5nzp3aW6se//UdED9t5/vq9Bl6xC2PV9BQCV9Dvncz1kzv8P5VjXWAM8NWRJvWHWf8yQ2htAr1pQVzUzpBhGHMw8flVmGOUN+D4/fvIf/tFU9fJKe3b4a/LzvZY4EHTxLM3FVHOH9Ih/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_add_scheeme_filters() has long if-else chains for DAMOS
filter types.  Convert the code to use switch-case, which would be
cleaner and more efficient.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index a4ec5d54cfbd1..bfb6f0bc3f213 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2822,7 +2822,8 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 
 		if (!filter)
 			return -ENOMEM;
-		if (filter->type == DAMOS_FILTER_TYPE_MEMCG) {
+		switch (filter->type) {
+		case DAMOS_FILTER_TYPE_MEMCG:
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_filter->memcg_path,
 					&filter->memcg_id);
@@ -2830,16 +2831,23 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 				damos_destroy_filter(filter);
 				return err;
 			}
-		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
+			break;
+		case DAMOS_FILTER_TYPE_ADDR:
 			filter->addr_range = sysfs_filter->addr_range;
-		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
+			break;
+		case DAMOS_FILTER_TYPE_TARGET:
 			filter->target_idx = sysfs_filter->target_idx;
-		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
+			break;
+		case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			break;
+		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
+			break;
+		default:
+			break;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

