Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDA0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60A06B00E5; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74F56B00E9; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7689D6B00E6; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4081D6B00E7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B510A403F2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:25 +0000 (UTC)
X-FDA: 84958559490.07.C9267CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2974816000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfwDclfG;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzzZd8DigQnVYbi2j1POHwqutTVJPfVsJOTUlbgk6WA=;
	b=EjYP0ipVELyTRfrH8ABPXiyDgl7Yaul4hJnFDewukrvmrFyNORCAl78llTTs8Q2h+97Sga
	HNky6GpFe0wgseKoRtJ5mkCpjth5kLoaRF82Bc7zCK7KYTLU4SGRulC+pPp1M0R02Oouow
	Zu/+cqlcQ4HnEGyRPTtMX4LG1NTmsBs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfwDclfG;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347564;
	b=zl+VGw7SWrmQDL0yWmogdKqNzx89YaoLEG2kRNTKimbDm+FM0PTsV4unIKh5lrQxPL03Dd
	nnacX7q6Yi0MM4QryoFcKw6xoqY0AA2wyJwhuaNIKoUEd4Q8jcKmb33zCfWH0RqVRp3MA7
	oX4jKsurigZ1uAIeEyWH25TyH9UX4Zs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C28F361838;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7169A1F00AC4;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347563;
	bh=OzzZd8DigQnVYbi2j1POHwqutTVJPfVsJOTUlbgk6WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfwDclfGvrh2DaiGg5vexq+MFhTZzvTR81fc3DKhg5C9oFBmKjitsY00wlpHrnTJr
	 xgAzvTmF0ysFf1HPqZlR5faZTQQUghibGPSsNFNL8E+gMbZNMLqjaA6cAes38i73k5
	 EI8y8toe8kBZn7npOjILOGFYexPaYd3SLPrQILRtRIeSfzqU4o5nF0w3k4+Xoi3epN
	 HDPHTw24Lg7bnyE5m++zD51LvErNVHTIpDCau2B5lbAx39iXQhnB3ZZNyl03N88S0p
	 2A5hr5lLOekmoN3kDr/fW5PZnFb+Kp7bJNctobzyqOyNzbY1Ka5JdpIf4SbzIuFXFH
	 66uY/vreLLlGQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 10/16] mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
Date: Mon,  6 Jul 2026 07:19:04 -0700
Message-ID: <20260706141912.88445-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2974816000B
X-Stat-Signature: gk4ozo3j71p9jj4nztob7sicz3y6io1h
X-HE-Tag: 1783347564-243408
X-HE-Meta: U2FsdGVkX1/UNBDT+m/4EGxPuFs8qgTBC6IzFIXXnVD9no9KwUB1LDXN1mb1rjKxcZnnmwNacijAa9kvFXcWBr51Qdp8Ay/eZaOB2zdJgf4z6hxGiOu1X7N1lYjw2j298LiYpVbcQigwotiOtUv1+VD73T9whjnI1zHX+2g7GXX/DYx4cC77YnPw5uqN3lc5mQQ+zz/lEUVYK0WIRhqZy9wT7+USBGsIx/hY9RU8+MLXygWWqCzgshIfWgCZASwlhyChIZDACBnwQm+d0Sol+WwiLQFUIxJaGFqt/Oej1gcIFJ0qmej/6AXo7OTSTiU4P5KMXNK03pKvPj9DvTuLpz+Sqf64NqVfA0vHW/9Dx59EgCQiuFLuQwozbfUI5Hw/GE0lV/Q39JyjcfjugIpu0a/KovyBvpKwTkmUbzHfOqY3HA9k2DfWzwQnsAdcfKloqi/ZEqhxefu6VGDuj0K3Nv6nhgokTkh3jgIu9Xja2XqNe5d1rrP68i5MBso11BSe9gbj6v4PmRFRDJSxdBE1zH7pLe9Rmlo4MwpR/sdhbxWYChtbhmsQsQuDxEI06JpP4r0uzKr5lrEEYB/u1TR/O/i38wZwqvPzlP5j065lgF5FhhsqWctdh81t67lVnR5IEkZwF8Fp8AtQQYcJPA4eG60G1UJHaf2pQ20BfNqXurhDVRAKTmOAdnj+/pyzqgbtXBhKIpTS+ssuB4CwfTI5/n4L4ZrI4j64Q1Xfg6PRfbTRY+qez8ueDPLgBo/TzQjMp1L4AwZjynUZizA1IodoygDQysDv3MSDRq8c0JAq5FjS9wonNRO3gfa8Gs9UnaW34YicK6+g/0QCGDRoFsG7FCDGWkCEGVXU9hxGNh4kzl5ckogCA+uT+VJGzOmpGRtGyPPFPcVvIb6CR6Z2alRJHOPVdJ51dX7CsHF94tWtGGdzV7XJQIrX8I157PFK0bBxbn4rOOQ78JvCMt/HoFF
 jDS4uMrw
 hETfMtv2lFr2gMRhp5r59DZfwwBcNO+9IZdWBC7hTkB+la5tjh5b9b0SxVxeQKEmAzX/L+wHJ2n5OJL8K+io6iYNhd81GvoT6z2oykB/kDaKcDSgcoxX5uT74Vn4W6QfQs1f41XNFQc/td9zfnQkhknoE9Uora73sOdCkWwnHOUYuwbjKm+adYg+QF+Inte+2OJmlnRVOF2FAMQGW/xy9sxLeX+sP7kJK2r1AfEHbAexpYTF5+7aAvzSH9oHhxjRJs/Dsoj5RcYqP2ahvbhGh322BBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merge logic works with the probe hits
weighted sum.  The core logic is setting the merge threshold based on
the access frequency, though.  Before using probe hits based threshold,
rename the variables to look more general.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 71008ee6ca243..a7ca69ea8e565 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3681,7 +3681,6 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
@@ -3715,6 +3714,7 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		unsigned int max_merge_score = 0;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3726,7 +3726,7 @@ static int kdamond_fn(void *data)
 		ctx->passed_sample_intervals++;
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
-			max_nr_accesses = ctx->ops.check_accesses(ctx);
+			max_merge_score = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, access_check_disabled,
 					false);
@@ -3734,7 +3734,7 @@ static int kdamond_fn(void *data)
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
-					max_nr_accesses / 10,
+					max_merge_score / 10,
 					sz_limit);
 			/* online updates might be made */
 			sz_limit = damon_apply_min_nr_regions(ctx);
-- 
2.47.3

