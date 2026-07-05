Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A0FEC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09BA46B00AB; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074FD6B00AC; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4456B00AD; Sun,  5 Jul 2026 16:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA3F86B00AB
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 389171C0E81
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
X-FDA: 84955935120.10.6A35666
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A907C160002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVz7gAMy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285078;
	b=SNJpjD7hnRV2DkgybQWgM9WG0STVCqUQGaNDgkNiUQ1a/Ph6j1lJGTv8UfytYU3bsZLUI/
	jimZk9lmbnOiBy8P7gS3L59VgwERoH1uDFBW8D1SrDqSw47Ymm73ySpDc596M1qtMhR2st
	MFv5q6w0Gv0UUGneiegLu0TDUgp7+RU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IVz7gAMy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsWIFasK6BNqNQpHNrMhe6JldAnQbV9yCA0uK0R+9K8=;
	b=qYgJRj8KAk0CuFFBsa0mUlPR5bJReQ75QPP9IdePMdYxrXUXibshYDAfII/fzXCvJoxTTj
	Xr7WX43S1Zs2bEtf7ltTpAwliJQnaCOM6Fl1X9cArxSQv1g6akUaIBh2E7mneJ6aiSYIvk
	WciQ1qqU8zxypnFEgbvqCYtF5tdjy4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0E7243B0C;
	Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9F21F000E9;
	Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285077;
	bh=nsWIFasK6BNqNQpHNrMhe6JldAnQbV9yCA0uK0R+9K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVz7gAMy8tYtuvtWrYqE+U4IJxgtWZVCsu6NBUdkOoiRSnOSeh54+QLPYgWDDa3PM
	 dYlk90ddaT3qO3+wZvCUIJWM2G7S+lwL8PcUimgvGFWrRK+uw7ZhJ3fe970+1bufyL
	 zo7GZIaIetLHcO3tGwUIJ8p6RIJEAVdvTHbc8x2c0e1ny/te7o5Prh2XAXkjXDjzXh
	 807yQmzpQYHPQ4gxlXCrR8p09o5/uBB2VB00bO0wsxWTR//BwTA0+qDuCLXrB4HQgS
	 A24Rv/X5JdHwsM36QunDPr8F9/HVDNlX1cspS4Q1fSIW4zG6jUDR7wTDD4+/cJipRe
	 RH07LkHy4JsXg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/16] mm/damon/core: get merge threshold from probe hits when weights are set
Date: Sun,  5 Jul 2026 13:57:33 -0700
Message-ID: <20260705205743.98656-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A907C160002
X-Rspam-User: 
X-Stat-Signature: xb8gsa8xagjgwzysw41i99cuuaa6w4pb
X-Rspamd-Server: rspam03
X-HE-Tag: 1783285078-971961
X-HE-Meta: U2FsdGVkX18x3v5qn5tEEUz15GOY5NNNNhq0/j9IELUmH3WBic7ZzKVyh3OvEHmJGuLMcMUSLCGDdNMyhW71nIz1cPlXFNLjXRyCI+NNMmIotQ5mjsnUiejHPoswY4g9KXwOiosVoJy40XxZmbWEcCuTvjXa8F2mREJI4/u2p2CsVc1vsmbGGcMSWAyp9UBLpckLTfugfUqdmY3NYKVqjI2NV9/o0Gn6EaDRYbab6CZMwRoO+ieYE0Tv3dNipCwv3jgn3H3aCSRA2/8s7u8oQMLOA49ib1XE+3TbBiylo7/bzYBhaST7N4PbAQPPNChjDwpWdqi5cjZl8VanA8oFWNDDp+ncgWHagND0ri4X+bYfeJNf7p48Ceki2ymKP+D3mEuwp3Vc61XA6zhjF/KZTo2iqrzBcU771UssmhLfNSQt6mEnj8PwghdGJNbvXYi7Xj91lOZBzEwNM8V42Mv+GbiRkSkv2uMlGK2DzGnILpoDAIkDaVDtNGONZ5Fk7nzyJdsABzhIoEd7+2jA9aj77II+G9YLl2yJSmvLZ+wq12II79qIowK+wObrwsW91ERgVRDdo7xFr1dvcjsLdAWIWnlnh3dLSK7ZDhp5FuaqDnML1Hz2Wl7m+NjUUT6tTt70DAoMkzAEKZyR99QUdl7SXZWr4KwsCq7iYtDz94CWsm0IDjFh48MyH3bejlNRstZ6bSMUZ0GmF7NYBXShOmxufWpISPcIyF4mpIH9LLhE2IuAzGUKcDs/MGYRv+947KQ0qmiVcO5fZC/6RyM0I2UlZ9YWuPpxgCjFHr/zVoi1zxbHimNXpwgsd52yhd3bc5xGgjusrE3Xck7NNaqB41CaOIo2oENNLqn6OoHh+yECfG/TAc7l8dqIuw912cTl9Oo8T8RT5FGhW0Cy3+xnS9nWuco4PcXPBswgyUMsdxEnMZl/1Tmj4X6jobRDUSgvp7WEwJcNo86OvERkScwyaVQ
 kh6PRiXy
 WnVU7qXaLuPmuhcnU4NA0XqNlDDTaGupy2Fl/BGmslc1sems1dpDicmoKbiUgbmFR7t8CmO2zE99xZvTl65OFNgEKw7DX4QAr1qOv7D0tIFsk8yl1/qjEyKg7vq69PbTncVX30IZImKGeEX0uKNVLVOTHAIoCmnH9jbYl80GS3WU3AONGnz3fFEypvjGeHYvrbtZbHb74j4yC5jNWncDExn9PxaMU8fvx2zR9B7FAz2vLEi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merges regions based on their probe
hits weighted sum.  But the merge threshold is calculated based on the
access frequency.  Update it to retrieve the maximum probe hits weighted
sum in the snapshot from apply_probes() ops callback, and generate the
threshold based on it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a7ca69ea8e565..83db073c74e2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3714,7 +3714,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
-		unsigned int max_merge_score = 0;
+		unsigned int max_merge_score = 0, max_wsum;
+		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3727,9 +3728,18 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, access_check_disabled,
-					false);
+		if (ctx->ops.apply_probes) {
+			if (time_after_eq(ctx->passed_sample_intervals,
+						next_aggregation_sis) &&
+					access_check_disabled)
+				get_max_wsum = true;
+			else
+				get_max_wsum = false;
+			max_wsum = ctx->ops.apply_probes(ctx,
+					access_check_disabled, get_max_wsum);
+			if (get_max_wsum)
+				max_merge_score = max_wsum;
+		}
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

