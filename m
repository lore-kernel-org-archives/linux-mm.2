Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A483CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27116B0096; Thu, 14 May 2026 20:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3AD66B009B; Thu, 14 May 2026 20:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D616B0099; Thu, 14 May 2026 20:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69DBA6B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23F88405D5
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:51 +0000 (UTC)
X-FDA: 84767809182.12.4A5891C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 82BBB80003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvWDiupR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805889; a=rsa-sha256;
	cv=none;
	b=vViaJdzoAoDqC9ojEnl1lSdRFyDEg0vPV9FQDQksCcP52it/n6VVrkJv12ejn6g5fT0rxR
	e79EGRagGToCqyEnVBZKHL+isCrDAj67qqiXccxdfJ53msjGxVa4ZG+KK3f7uy9culFSg6
	/+DSDXyRTBF+5JZ+fx+ZwZd0BI+xvDU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvWDiupR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+QChcDMPj9TI3JS9xCs0WSvkYm3fvYQxRtEB1iVyOg=;
	b=4Q6klNzhplnHT+YkffEVz/USSu1QNwhpE5KeJlEGT/Olt/0uczLEl8+hevjn0P+oXyb+BT
	qKDMT6jBPJS33AvouAE2w9ukI3rVihNiVAjzjb8EU7xAzE0XueauFVfXINn65QhxOM4pSn
	6znV3Hf1PxkGDVXn7NPWWiM5E3PzCno=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2B6A444EE;
	Fri, 15 May 2026 00:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C2C2BCF6;
	Fri, 15 May 2026 00:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805888;
	bh=hJODIpSBe8AcoDpxEMr90X7CC52zMi/o1RheHHmVCuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvWDiupRPolo+bI3uwA60KKbJSlraBTVeak2lv4k19vVRUsmGYp2FM4FYG0HezUWa
	 JNRqhbb1tMro1nEZQqZRlQIk+W++tGR2PL1KERbGAVbDGxyYHcruVGetbp76QqG9EG
	 mDkbw19PUUYbJofBvNMsBl9+CRt7gxPjRvUmO3htl/vwONMng087yE7Mwz3KTtQRWE
	 h9Baf0U2IyesUlOsTQsrEUfHudVljtcfxwkVxLwW/GQCXciuUiY9CNwsCGnT1NIX89
	 l0c8sL9WCMQq3bowKSxfzboyTZnrKOm5ye6sHwPLCb5jVlWJEtAQDsmeNsAXw8NfrI
	 ZwSiRlAueNd4g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 07/28] mm/damon/core: do data attributes monitoring
Date: Thu, 14 May 2026 17:44:08 -0700
Message-ID: <20260515004433.128933-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mfjqh494a58sm7xhjbhf86nbsdm3eqrr
X-Rspam-User: 
X-Rspamd-Queue-Id: 82BBB80003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778805889-832944
X-HE-Meta: U2FsdGVkX194tZ5Xzqmfb6Cud2fl0FLuo74yE4PaHLVgbzs18/r224302yJvGp2ANGy3kZ8U//LLBtlWpVdCoJ67GRX5oSDwzpyj71OuWwgj5h+1li99keBXa6ipHjWT3mbP5DGsjoF3hiI5aHfYBMDZKzH+627DoZgu4HiXS+7vXy50lplEo8e6C30BBesC2c13wdULE1rtN8W9jgvo4jsqny+dEMAZ0OX6mTChs6ytIY4KrBtELakNF8/zKVTB8IOMXBlQvmEUVy+cx4dfJ5FbQUYq5lxiL07hWxiwnXOKNau9yft1tz3kOdRJdaovZIX1+q+2GHjMX6ROaD+rIYml5IIDU8dsofZQcDFufwAKokbEf22FiPk71Rck3tqzmZ/gjGIdYacmKi8WLTXxI3VjGSSMUivd9PeWuHdDjE1W6Hbcwk9K05mP/qF1XYjzY7LgJCXwDdclpmKMzMm2xMOkHbOqR3Rn5/ryCz8i8Q5HpMg2y1smVLbE4tlV7NVEoG6baD3f/1+DlvLdlMD30CJzgecafhYSD3OofZNIUWwvx6C4kTGfoKxDvtr9NdHT7ZDMgEtd4WMUk65Tk4TvDj+LmrVP8V5e5lvmkG+3YO3pIEVTJNxje9fQYqJbb59dyI9UbpAcTTCZrdxnZ5/tAKhlOXC88Epg2+vwmE4ekRCNmKb6N9RkyBTmL2fmCOwktoExbi8HdOAo9v+K3VcibhtY5ubw1eRQh8i1zaDEjoeL740fTsjhd+FlhYJgLbQh5NoyyTSKsYGvGU5psVQ0bw3os1HQwQYUDJHm00blcY7BPjUITjVrAT75QSq01AUf4DZ1G3ocQA1YlnvW90oIS5BTLLoAOOjvyaIgYu453PdmxsiH0qJCe+vr/sQWcVxZM/xT8qUYTEBbMHXByfwPJ2hJ/Bj4CSfWyjC3s0j4Xk7bu2Fu1qr0z0lLwk2L6OaxgEoY6r/gVR8niV1xhoP
 qMvwqhg1
 FEWqQLqtbSPsiWRSTRuuV1+TrHUDeBQswsuOTa1Z/JwejJsM6e4PYUXqgcdLKenaMgIHUzRnQlgbVUjTaWlNX6E7EbtTZf52VBMHuZiB6fuN1HD8fTI0nIErkMclZsXGgGfZMPeIfPZjeVtyI+nBOYPmBwZsW61p9zSFBiTliW4r8b+jCo+qcSnCnj1ZdiCTMEXM9iWV+c5gQJJ0aOPriDN+nCGZTY+W6Dmh2dhiuAppsKA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the data attributes monitoring execution.  Update kdamond to
invoke the probes application callback, and reset the aggregated number
of per-region per-probe positive samples for every aggregation interval.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f6b4beb4b8ecd..1c9d2fb69f98d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1886,10 +1886,14 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
+			int i;
+
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			for (i = 0; i < DAMON_MAX_PROBES; i++)
+				r->probe_hits[i] = 0;
 			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
@@ -3172,6 +3176,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

