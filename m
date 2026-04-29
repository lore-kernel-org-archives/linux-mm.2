Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA264FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54386B0005; Wed, 29 Apr 2026 00:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B049B6B008A; Wed, 29 Apr 2026 00:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A7E6B008C; Wed, 29 Apr 2026 00:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94CC86B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:12:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EB0C1C0E32
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:41 +0000 (UTC)
X-FDA: 84710272122.16.6A87427
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8E9CC000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OWV9Zwqj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aS26p9ME17M+48kDYAv/DQVkMZMl6qXayGdu7srQNY=;
	b=LhOJnrU013y2WHRZRomaDAN+OW2+lLg3ZAYhLkgWnIioKvJ6+cbgLul7eGnawLW53O1SzY
	e4iHTMng3u292o42RbxKZFiDMplQgk2om1j1DJRi2m+cuvl4I17oOz4J8dip37uNopcRId
	2yK9oH1f+/7m6fzZrBe1VynIdlAh+aE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OWV9Zwqj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435959; a=rsa-sha256;
	cv=none;
	b=lhP/JUIDUGAfqAbogCvtvzd5ZXhP0W7yu3D0y/wWI4tOO8rfAOqMxv/cRccHifokhMs683
	UTjAJW8ExfSD3sXm3v4uPkjh3ZDRMNKEXOC0hhhuW1jlfqv2xwbpSBTE4FRlK+O+qsPhjz
	+/ExTOYenPV44AvurRXVr3JXV9ch/tU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4DD6444F0;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91620C2BCC7;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435958;
	bh=tLnMMWyWOb5JWter/hkS9/BroYtAzNu6DanZ/dgc7BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWV9Zwqjp6SCQsoS8qqmQHNRel8GAHCYcF5lV7VFcRdPqRxvyktNufhT1B9y81cht
	 Nh6OekIufSS//qGawwe1wlVuDt0OSUCcptCmhOCHMHY1k/FeIaoJoTWSc6kmXmq8/S
	 hyeY1RQs2v8avPKP1ej2D2hh3DRxNhs8kIs5ktxOtmMLaqnc/RrO9rMtgJCZHronXT
	 T4kR5fK9jjjF2qNZTlzE9iZwmAQCzWyrGUkzpAhsGyJQHx1c4XbqiyvMt+ZKVP2X9X
	 xWWPIH4GBpqKo2BnJjv4ZQUvOx5+7/5x0u1pNrSNJIOxG4vV1/lXEbeHLwtfQi5Lyi
	 VIDXo6MDVIL6w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] mm/damon/stat: use damon_set_region_system_rams_default()
Date: Tue, 28 Apr 2026 21:12:27 -0700
Message-ID: <20260429041232.90257-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8E9CC000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 37iz7q3dbhok6kebq5i3ay1sb3r86bm4
X-HE-Tag: 1777435959-311937
X-HE-Meta: U2FsdGVkX18t4kqDyjRtugCEfpQ5iKzrxuSwPTEDbQ6OaXzSBK76xYwQB/d681avmmLQ8KSlYnyLLqx5ahPHksr36ay8FP8vd/0IfAqwDAGWg1p1nP5Bxy+ob71GmZ7ARmBlApooO54/tLy7rhPz97NAYUwVI0YqVcCLgfEvm6S4iEq2MCTwlZdrwdwCj5ZxxTgKVCFi9/P90OXZHu0dx40iuRTwcAgtFg4LF6lgN0TUlOPCHOyz5OP7bmFYQXodnd1Hqmd1NhQ++2Be+o/Exzh2Q27H1xe1jsR6Ako6cG4BDoyWv4qS5mnTdhRUWmG/mvBFZl7mWiV/XELw5CpTqPvZevdDogTHkXkEkccZfSx3o3R8s48Y/gbDpEAdIs2b3qzLXUxJ8F3dUcPFGbxr9KgzLT13I5r1OhMtf9y6XCTQa2/6RpdVqwCTFZ0MJnBBLpdB4vkmyBBK8cYWTNuTgoKNM6PUe4YcYQuZVe+D+NBUOrie82E2u7XV2omx9IhpiLFtVixDI862S5DntEhNmfAwKQCknDkogL5dhjVoLv1ujqQGZrAYfLVnqpAKafonxuJ4s2oPTKJGfwN5j203oM4D5mUkgZBMTX7blsjINYJToJRDSvWPLH/CdVB7ENIhaoxvx/Y1rCEK7LJ61GTFBDkvPX8wih1it0F/Z45z57l7X1lfAu0TBQi5uQMVm8QwQcv//Q1vsxJkNSi4TMmzBU31eLnRiGLj9MEWM33isOXKT4LVq6imqiWjAd8NE5sWp+RDpkc5XkPjYKcBKeVNIaGSSuuXhVzhNF3AijAffrpFXPA7aFuDTz9msw1eGDNEju+Dt7s84DFZCuhfDRihVuphTpSeR986ima6OLYuoH3kDiUcp558cE2CpCQx3RXxsaOJ2oIPXjdgFVPN3eWOMV8d3Er4GAKfuUKohyp8mXrWd6bKjQreN876dinHY3PcBXxVB8Ib3aGQAUw0Qxx
 fZKngv4I
 sKh90SIkUlz9XCieJeWqXiA7ja4NY7YmgJeTNtITlCWVO5GUgnAI7C2YCs99ZkDjsNcC0rcwGwlAVUJW/yyKjWzP+x/oLsogwYXdOBRWrNkt8OKNNAom4CTXYegahAd9urPF+Zu7hUlqaTctPae8zMxx22LIbsBQnD5qmZpuqXx0B/dwC/WPwwMX7e4e4+yyKHrd7jCWeYik8LEmWupFKZhCiDPBYWjoRrY5dgMAY5INDFHugs6S9lSPIZCTgfWBdF0FxtlwNEuXGvA50PsQC3NwM3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stat_set_moniotirng_region() is nearly a duplicate of the core
function, damon_set_region_system_rams_default().  Use the core
implementation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 53 +++----------------------------------------------
 1 file changed, 3 insertions(+), 50 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 3951b762cbddf..f4d3203e92639 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -148,59 +148,12 @@ static int damon_stat_damon_call_fn(void *data)
 	return 0;
 }
 
-struct damon_stat_system_ram_range_walk_arg {
-	bool walked;
-	struct resource res;
-};
-
-static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
-{
-	struct damon_stat_system_ram_range_walk_arg *a = arg;
-
-	if (!a->walked) {
-		a->walked = true;
-		a->res.start = res->start;
-	}
-	a->res.end = res->end;
-	return 0;
-}
-
-static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
-		unsigned long addr_unit)
-{
-	/*
-	 * Use div_u64() for avoiding linking errors related with __udivdi3,
-	 * __aeabi_uldivmod, or similar problems.  This should also improve the
-	 * performance optimization (read div_u64() comment for the detail).
-	 */
-	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
-		return div_u64(ra, addr_unit);
-	return ra / addr_unit;
-}
-
-static int damon_stat_set_monitoring_region(struct damon_target *t,
-		unsigned long addr_unit, unsigned long min_region_sz)
-{
-	struct damon_addr_range addr_range;
-	struct damon_stat_system_ram_range_walk_arg arg = {};
-
-	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
-	if (!arg.walked)
-		return -EINVAL;
-	addr_range.start = damon_stat_res_to_core_addr(
-			arg.res.start, addr_unit);
-	addr_range.end = damon_stat_res_to_core_addr(
-			arg.res.end + 1, addr_unit);
-	if (addr_range.end <= addr_range.start)
-		return -EINVAL;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
-}
-
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
+	unsigned long start = 0, end = 0;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -230,8 +183,8 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
-				ctx->min_region_sz))
+	if (damon_set_region_system_rams_default(target, &start, &end,
+				ctx->addr_unit, ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.47.3

