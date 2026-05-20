Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF37CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 01:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816056B0088; Tue, 19 May 2026 21:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6D26B008A; Tue, 19 May 2026 21:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703076B008C; Tue, 19 May 2026 21:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 612796B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:21:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21E2C140DE9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:25 +0000 (UTC)
X-FDA: 84786045330.05.E9BD8D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9545B100011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qvg0o9xc;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779240083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgoNqW5Lq/igHId1rBXMsCtJD4xKs309svvL4MmZKcI=;
	b=ztpt3B1ek6245vxFa1v/oYqQdi+jpsz7ORy00mhszvwqvSJ8oTiJCsEOv/ip7K0aNuS6GF
	UDi2ttFhoZBNIdClDZdarnjBbb5h/JJrrXmnYrnLa+xOpQMIiPa5hUuI8T4aRzIjhYeKXf
	qCb+J+BPQvVUIZ5kgvnrGg+xxyQ6ZCw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qvg0o9xc;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779240083; a=rsa-sha256;
	cv=none;
	b=WjxSF6Jj6h/DKPQw6ZI/skLhuIXXrqBrVaxV1oprR1mn+pUuOk+rdiRF+bbjg73FLfe8lb
	bKk1K4zzgYqrPntGwIC7ylAtNInievxIYZucsIKku2OM55O0BqQfF4/uW4AgLVnGHIGaYm
	48JCiicIoP4iEkzbOxmvoJmCh5UST1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E1496022A;
	Wed, 20 May 2026 01:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D931F00899;
	Wed, 20 May 2026 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779240083;
	bh=pgoNqW5Lq/igHId1rBXMsCtJD4xKs309svvL4MmZKcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qvg0o9xcRwy9rQSrFDKwUfsPvVEHvHTNAdTgw10Ga6b8J4VdNU54ucd2H7Ezszy8U
	 +iyIiWdJG158/ueAgWdt6NVUuAuy/4u7g9R8t3VDtUi70RSSSaFveS07Df1v1mINQL
	 BMXOiLzhSWb+tug/5COqbpWoi7n2EsdUo09hljbxV8FDo6tjGrDzVSLVX9x0fF9FiB
	 /Yv27l2dIHRK404dWFF18A2X8WYrmyesdMmcpZcUWc460Sk+Q7vbX9PcqjjUDCzDKC
	 reY9/X89D0IPSKwv5UEudrB7HARS/1K5CIGI4x9COqJSe73mh8ZEfowqIxm7dWMMdP
	 qMpzSfif+moyQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: niecheng <niecheng1@uniontech.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RESEND 1/3] mm/damon/core: clarify next_intervals_tune_sis update path
Date: Tue, 19 May 2026 18:20:59 -0700
Message-ID: <20260520012104.93602-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520012104.93602-1-sj@kernel.org>
References: <20260520012104.93602-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b5t7n1biopjm4mgdnwyoxigsdetykz84
X-Rspamd-Queue-Id: 9545B100011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779240083-747994
X-HE-Meta: U2FsdGVkX18O0ASk1VoKt+G15crpCvc+DerOQfxg0mSapHN9l4yhC1NkKux2vnRcNkrOXjcCMvxBiUS0Y9abp6BBxWuslFjDBiZmWLTsDtvKmioP4NQ+U641cqvh4BwXDXrIfbGSghmEZoChnumtKATLZZ2OnNt0CMEFahwsV+wuzdj0+n4DLtZryVuDH8aT5xwbx5Kl1Fvd0FDw4Mrh/DA4w3gC5/wiqH0ogR5fBU7UXZKgC3CEXap2tCf/XgBfLY/K/kSb93Uyad1HfyhdCDi254CahKyFcMSC+df5dJHQSHnw0RmCmJcHBLH00OEHS621yLFrzko2Px4s8/GI/NZ7rMCTD/MHdzzKXHsMfYe1m7YF3oirneQ8p/TDC7ttdtomBCwfAQheGbWYpcPcUmreNg8USMYBLBjKP35WBt25TECrE2Ntp7kByxmiZYES/UwsN/zczqq3fC+C4pGxfkq7SzGSMKY1hEljmIkSDv/LIDc0y3scMwKNduQbu516iF9iCIZ66qStYkjpgYAbhJJED0eKkeYqHPeB3HnDiDmtzxVyvZBEK+4wPHJcbJwIgu4vy1qDmH6TeiO6Eg7AUv8HbgQ7tyZZPhwph/t8XjylvEjC+cmGpcjmc/3DRumon2aWn/xdeuAID22k6yXl5ufGLUz0aUdA+Y9DyL5y8wCzH/fOuLbj/VCHrjmMa1YEb8KS6UVdbFdsvl2rKV7hFiALagD+p6MwdQG+vgbQg/jVzNd08ktSeeoGio7zd2B11fZGpbQVze8uS/UsBcnPKOp9l3rE0jQn7y5WcTG3JZGg1QW1sliILIEde5HxG27W1u3xzGIEJN4zEG21ELSmPAagYcWYwkaaCBhfH8MiO9jBG3TDzw0p57NEg5CDRdL1KhEPhRz+KOynvl5ZKWdMC2iYlRnTuqH+v1BFVbrMzUE/jFJagaKilQAKGGw/bczYVphQL9BatwEoT2qd3pM
 ILfh6RPy
 ozLaoPYVtR0n1Ns8xH83yVVwwPS7Uln4Y5IZsRW64YtSSPfpOaW327dnt3QSDv6pRqPdLNae/kfkm6MxNgK6xaIFmdnFhGWu7hJ6nqfmIeMRmWwEQzaDkICHJbRqPJXm04rAaMtWMOUyvY8u2C2GsHfR/DZLFSqiviRJrUxYdo/fO2pIAyWwrrr2f9oer3ibauT7Ep7WG+9A5TRwgVw8YdxL+QTyLp4z8XzjZP8EdC4sWdrQCEgmcFd0CDu9dGCNvQxXZyXhaTx+hmYHFukOtefoN2wUQevU1Y+92hucKPIVY+7GpomWjqSBjiE1oUcXJlc6qY2Lj0r1YbFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: niecheng <niecheng1@uniontech.com>

damon_set_attrs() updates next_aggregation_sis and
next_ops_update_sis for online attrs updates, but it does not update
next_intervals_tune_sis there.

This can look like a missing update when reading damon_set_attrs()
alone, while next_intervals_tune_sis is actually updated in
kdamond_fn().

Add a short comment to make this explicit.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: niecheng <niecheng1@uniontech.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/D3B0C1F5BB6ADCE4+20260514163751.3399513-1-niecheng1@uniontech.com
- Collect Reviewed-by: tag.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/7946CE4E0773AEF7+20260514074846.3258908-1-niecheng1@uniontech.com
- Keep the behavior and clarify it instead.

 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4e223857a0f99..68b3b4bbc8fc9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -909,6 +909,9 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
 		attrs->ops_update_interval / sample_interval;
+	/*
+	 * next_intervals_tune_sis will be updated inside kdamond_fn().
+	 */
 
 	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
-- 
2.47.3

