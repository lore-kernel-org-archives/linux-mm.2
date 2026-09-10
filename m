Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B26C88E40
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177726B0093; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100286B0098; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CA96B0099; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D81E56B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1FC81A03FE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:30 +0000 (UTC)
X-FDA: 85196508180.09.76E780A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 352BAC0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iuAe1Q0Y;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b57SpIkbZ6AMBsE6RM4G3dlGWMR1DXMsNf+oP0yvVfg=;
	b=Dl50zDt7vnCR4kUEZ85dffOTJag2O3wug4Nr3CmwDyJ9D3hVg0i0S7PCkitqFqejP4JCMo
	CfybVVa7wMYXmWF8qvTUpQ9LvtqrJW14C8wALwwFdEpOVgIu8jOLVZoyJrkJDaNI6itedo
	XWgRUazs4VvSM6EdoCOdF0poaAsy+eY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013009;
	b=aJj46mnR8jncA85ADG1ICqMm71c9tu/g/g1UwleGdfKXTYWMehdfYrkaPlw/gZccs4tzVb
	ZDI5fdx/CSkcD6Umtc1ClLFr5e1RWPVzUrLW8VigMSfqq3qME1812xKlstQQtORvBxE49E
	E+ZNBcihcU8G/hy6RblMRVtfeYsQRCY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iuAe1Q0Y;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8995043B7B;
	Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A51F0089A;
	Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013008;
	bh=b57SpIkbZ6AMBsE6RM4G3dlGWMR1DXMsNf+oP0yvVfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuAe1Q0YUHJimYcpz18LK6OjYduQt4A9/RkIC4nCX5SUrQ/xXI1A5ah8/fTFhs2nv
	 qSCIGjcGC/gtG7gBvdVZO6/Z2I3ZnvCz5FINszIOgN/QC3r7x4goXa5Gfz7yAZoB3s
	 dFsPQ3qFss+48nKU1mbn5RBBe8m+0KcYTVNV2myFIxKzLNpi2uY55MX887aWyAn0ef
	 loW/QBfP4RckCvfZsyhnIi6F40Pl1X8aCAVAtraGZsizCn0ZPMO65FDaEQ6KJOdD7Q
	 OktxLiAbHM5nL95lPb8v+6/BKUx/WqeuZX1qar8Z2xhwe0RaOHXO4yuGf3Zo8jtH6d
	 2IM4hAdMjfveA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 3/7] mm/damon/core: support probe_hits_wsum damos core filter
Date: Wed,  9 Sep 2026 21:03:14 -0700
Message-ID: <20260910040319.147037-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uze6tg7inbtcq1wn7sxicdmmpno3wg34
X-Rspam-User: 
X-Rspamd-Queue-Id: 352BAC0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789013009-236633
X-HE-Meta: U2FsdGVkX19W2iu+HS0gvSA8gl/57b3m5e7okwWEga0KcXMD4It/5uPi8EGvV1iXInw/73Ip8DL42kWkRLhsgiJygIVQNJG81zY2fXoDxZBfjXfKZtznybEo7S7+C6QOXWd32oE6qg0DU8fF2bXv4xwqlWTksne3zdGxlbNRtBfUV+/htRHy2ACPT4cnquzF0/1FYtfyaQrSCl/k5gFgCRDinThDIct+MWOFKN3LS3cfZ1w0hamxvGF1FFK78tNsGI3mTzhvvpw2YhNHBBXMdl/+fAYu/Uc7jgm+mMGVbMPF8ckSwRane6UYQz6rxQTOitYHHCvlyULeQJ5rO8t2mWIpFF9PT5RvEBx9UZbyCIlSmIRSg2s3y0Y/DpVXUxRUP/aQcmAMDTXInhFjUAaTI/suD107PLHiN/OgoUtxMHiFT7QgIDCQMIdeqAie3gcNGDL2ISLHKO8VtQuqBEp8GhOZxwvCz4YD7aREUtY4at+/LhnWq0Lm/S21TgqGegeLJypGm57gGzxcZN96OLjXlpiutj04Msh7kFvsNZ7YsBm5XmrJk8rdvN52dOBjPX1UQQ2hcWlpNq+4mNpLKr9Bh8Nv836ccqW2Ms4NdwURxnmx/heDZtzLorFcWh6knaIgGx3iuAT7eqoQo1zXUckBFHIh/FR4vpgNYdRH7oG45GjrXALeD0luHCgnt5RDnGxH27N9EiQbZ+bPwenB1c0g6jIo98sils0EFmpSHPJB57sw5ftZ4+lliR+vCjhg64j7X1p9Zyss2FveqyKwP7W2dI6UuGo5MGWFlsbZLZXIOG1SeFgHZzDJLKtsrDPGOWb34ru+JBo+YhoMWZSuLSgAbY+kARK0yKjafoUwiVwNqOaazRT0NbuJg9E/TRtHTxGbirkypbvAaMN+5IEJ/bacAh6odOLwrVCJvZRPevSZVypy4qJS+h2ZD2/zwJPCV5LHwhuFJ4NKNY/rfRplklx
 hKu5Fs56
 kfzneXblSGxo0ZJKahSGXlckDtloAhr0Fc0mzmr/Abo1rlkt1+1RaCL1wymdZIQquQkphKTCDI0yX/XKk4A4VPEwgloC55ZF2xYM4bdqhJ1n8gVFmJkLnCU4t+KliocBEdbBL0YIZITtxfHYaIj57piabOgBCN/1MKBWvXe2UnfAYpE1Y+CaPGlaGqECCSp/bv9QsBcPwPzz7E/lXYuGZU8snwbPYB7OeGeKhSdxsMtgmnQalpXX83pvDwwZkAYZ7YkolStRfij64oExKh6WILvwThg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement probe_hits_wsum DAMOS core filter support in the core layer.
Make three small changes for the support.  First, update
damos_filter_for_ops() to treat probe_hits_wsum filter as core filter.
Second, Update destination damos_filter->range_{min,max} for
probe_hits_wsum type damos filter commits.  Third, extend
damos_filter_match() to handle probe_hits_wsum type filter. Calculate
the weighted sum of the given region and compare it with the given
filter's target weighted sum range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 50e0f9407db2b..0c98f7e267d07 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -658,6 +658,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	switch (type) {
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 		return false;
 	default:
 		break;
@@ -1332,6 +1333,10 @@ static void damos_commit_filter_arg(
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 		dst->sz_range = src->sz_range;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
@@ -2510,7 +2515,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end;
+	unsigned long start, end, wsum;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
@@ -2545,6 +2550,11 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		wsum = damon_probe_hits_wsum(r, false, true, ctx);
+		matched = filter->range_min <= wsum &&
+			wsum <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

