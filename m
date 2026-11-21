Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFB1606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHBDSLi2
Received: by kanga.kvack.org (Postfix)
	id 1ACA36B05BE; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E7C6B05C2; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4986B05BE; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C12B56B05C0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55F321C3EAF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
X-FDA: 85460344536.07.512320F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BC39C20004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHBDSLi2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294826;
	b=Vd/ZPr33iKOp6nzxgIloFp+ogue813YtexYl4YokjCzvT5Vfcl5Al/Kbnj1UOUd0cgSVgn
	AR6AEEprhXpT26jve2OY9ca+wEe8gR2+CZOg0Zs63REFUX34JDFHY+OhLcoFPmRU6HSaAT
	CQpGBQql2FPklJO7zgZpym3AvsUzhO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5v3TNUEUyGkIhCVZhl1qQoqUnXYUnCoqLwCawYZ32A=;
	b=65WMWFj2tXp1Aj54wQDPfxUm1rs3g0tisTtAAPQPukHpD0Ldd4PLIfL9axO5X0JvJ6eq3l
	mm1yfvFSxhRgiC9V4rMjrRK0H9QSFK5+Xltf0WMcWe6aFJDU5VVxw/PoipqWwbfjeOCgCB
	U3qCCTNRTDx9ETIoTEvj0XLbK88QnZ0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHBDSLi2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A82343623;
	Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18D71F000C0;
	Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294825;
	bh=L5v3TNUEUyGkIhCVZhl1qQoqUnXYUnCoqLwCawYZ32A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHBDSLi2J4lW/6RdWT3/YH657cSPK07zdlaE9dS5lGt3YFFgtZoMGyhkWY0KXLpPA
	 XRzB3FYHwymaO9O2WgDWFpLINNA/Udg257WfMW6rHGueQO7xUHaoMppErIrt3WeW5R
	 sluWF3EYg2e3Bpnr0JJUwq4sXMUt9eY8Sw9kAQiUNeYJNi9S/ao8boXvEGw5O1BW1t
	 faRvDl5SNuGTy2FbUJbNqHY/bddHMTUUJRs3UYded34TjT5CnPjoTkj6ztdW0QVl/L
	 yEkCcgMGVbug+qROslCYlXOV132k3zDzr6vGWjo5UgFiCLWGtPhtpJabDvfzowVM5Q
	 GvI0WFlh42AKw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Sat, 21 Nov 2026 12:59:58 -0800
Message-ID: <20261121210013.130397-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5i43z1agkaqhy36dza7ubksfgfgccsf4
X-Rspam-User:
X-Rspamd-Queue-Id: BC39C20004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795294826-887283
X-HE-Meta: U2FsdGVkX1+UCWTe/keY6lE4yTuRrIdBoUNn1+MitjpoxYh1Yl4tSNvMC4nWXEOavm1vlX+lgWo2z68l+dQWKImV6P4X6yHRhQOdQ5lyoY3vTzFrDLpRjVGmjKItZONogNndo7tPxPXLMBG17V9ORZ/NkeNzyga+0XyKNcj8NvAAze7poTAMZ2a+IV7cFrCKINFObEipSBI1RvV2d6cx/NOnxbKuP8arzz7jNd8RRg9YsKDcyk3vvFzIVmviUAU8HQSvG/9Ls8xEFEZMGsV+txmwbsNpPA3zixk7Iy7dmLoS49ptedaTWwEPOKUK76VnAcqokr3a2Cyi3n7PGWfy6qPf/oTXTS3me34HAsUeWEOhnBJkWniyPoiMi39KY4UQ3Cu2mNu95XKD/KMePcSHbMAXYINKv7hBI3Q80ORyOPOh0QY43PP2Jy06ZWgE3/s9q+kF3aslQhh3znsHot4NMRkHxbcsWm50hCGVwC6oZeGIVmkmudJiJzEz1T/14flYZnrfEju7EMfQSjFSTo9qY9EJM3NutCnxVTDFR0L8r7+5+M9kOPBBTByx2QIqyFFso2i62rnDmVoj4et30xGZSv2C9mRBvgQyZ5eewtP/fcB0z5DGU9HQ7jgJ5L8zvazifKBHu8TmaqVeLnvJfBidU9ffqzUIXByof7EVWK9xiv9ZjPbwBQpVwZ7A9wVjPQDFixYbg4936jDk0pie+P7hXnP0KDzoiCfek55//SWPtErSvn3HdYNIq+JVnoe8khV7WumI1X3/BocFF1HVoCi8BASFa7aG5wxdXSigRK/7tA8nKIQgAMB1tJVVeyw6mOzOLN0bBr/xQZsJBxWGaDtcngs+7fIjawoBkyo1Wc1Ucl+p+omisVTiy84V//iI4dduJGpFVMOnJ+1MGZVn9sQrr1c4hG8QzpMPcsUr/qRrPiSIvETseKKoznlN8SUJWqpcmGPpr4c3LoKMHyESwJS
 2Gg/vQWB
 +Y9PugdQvT6GigMiNZDx95iu+pxgy4GT9jfWKvUH+myJc5OMJl2V0xIwCDfKONuUMbJoFY2q6xz/2BDUGtBhHTEKIkNxiEAlRHdC4Yn0epQUmL6I0tDxjxwD4MBS2jYSkE2BNQdlXRBLdNz76OrkJ0idkiyBqJKAYe97raa1ZmeUwbe8EKBhTjH9oeKhgNvZxHa7ueOTknzpr+scPPNUeZEn2OR9RcxZSYDHPm84qw1bVcWkgEpckqyCSi3Y28Yt5SrJuJIWkmMrS8bw+wUDzRdCqmYAgfhdw/MTVQZ2MrIg0F+s4PKZgGOtm3uEdAUsUbcpLRx8fNMlJtN76il7SH7MBZNQjh6D9vFpgUIPwAxHAIa3EwFX8p28c7Tm6nW2akQMo8UNPV2BzKio8ZbdlyGmOYOp1sr3zGUyjtfne8zXU4WCdtQ2EQ/wP1sssz4+GliqsZs7vDvXyrhlDy5fPffRAGOTlwooRDIQLcI13OXIeb8V82Ska9OdaZKxTuPKb3Ll4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a support of DAMON_FILTER_TYPE_REPORT_MADE type probe filter to the
physical address space operation set.  Use the DAMON core API function,
damon_report_exist() for the core report search functionality.  Set the
time range as the last sampling interval.  Pass damon_ctx to the filter
matching function for getting the sampling interval.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e89cb14ee17be..4003ae914f1a2 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
 }
 
 static bool damon_pa_filter_match(struct damon_filter *filter,
-		struct folio *folio)
+		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
 {
 	bool matched = false;
+	struct damon_addr_range addr_range;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
@@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio) == false;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		addr_range.start = pa;
+		addr_range.end = pa + 1;
+		matched = damon_report_exist(filter->report_type, &addr_range,
+				jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval));
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p,
+		phys_addr_t pa, struct damon_ctx *ctx)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_pa_filter_match(f, folio)) {
+		if (damon_pa_filter_match(f, folio, pa, ctx)) {
 			pass = f->allow;
 			break;
 		}
@@ -199,7 +208,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				if (damon_pa_filter_pass(folio, p, pa, ctx))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

