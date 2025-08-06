Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C00C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00B98E000D; Wed,  6 Aug 2025 12:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1A48E0003; Wed,  6 Aug 2025 12:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A02C8E000D; Wed,  6 Aug 2025 12:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75D5B8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:43:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CDA95A0D3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:43:32 +0000 (UTC)
X-FDA: 83746903464.16.3940CA8
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93CB410000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:43:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZHTNRZmy;
	spf=pass (imf14.hostedemail.com: domain of bijan311@gmail.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754498610; a=rsa-sha256;
	cv=none;
	b=I3IcEi0sh9QC5CwwrTqk38oZhrqRdSSi+5jcdKrdkeHU/RDrKW7tijsz706IEdGo/END5h
	OTJXNNPKa+HzeemttkG8NmS0OuoMJBINLrMszZYBjy+9AD0YngiobOktIs6QL/HX4qVRAt
	ulaFJQ+7UkKk4KGVTE+yfrdVTt1kgws=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZHTNRZmy;
	spf=pass (imf14.hostedemail.com: domain of bijan311@gmail.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754498610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SfMoFOux/IwUTu8sZ3bFuS6UukRdux0VsKTWxNGPjeY=;
	b=mAPs4akP2OwQT8RZClpkxvVtVn/Qu9U6WXPFKt5UqEpgtZa9ddhfPM/Ia6zPv4ALshuY0i
	gjiDw+7YywGVefQqQr3jmaxHgPktsZAGJtDnhaUpH1AO+cO43aBNVtcVlz27AmLDThhgKK
	Di9cMcA9Hh/EHau6WR624caQDwNM7bs=
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e90293000aeso85149276.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754498609; x=1755103409; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SfMoFOux/IwUTu8sZ3bFuS6UukRdux0VsKTWxNGPjeY=;
        b=ZHTNRZmyykcnbA8Xk6occRPK0PPTNYOmkcMSY91dAVJgrC8axrGrML7Tmllb2fXkVx
         5zwhczh97H3DQYNSQuXAnuDwZmzicBGVLAGCS6ThRM4m0ylr9tn2BIy2wq6YWJPGWnw/
         CgsXTdcOxKKjUt/UcAYzfhuYyeu17wF0MHqDbAS4PSuFDS9qpogfcdGAbI7EjCNeVpcE
         F5RGLxiCLWiAtBbXV40rrhbgCGVKSvtkCoppn/UTe9HPgi9XIVAyF9LXEaYh9jLsNwGh
         6ZGwxpdzyrVJ82KA5O5msXQKb0z6QxhbqM8Ip04xeIppXIgWlycdrLRFfY4JkziZhrUZ
         eUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754498609; x=1755103409;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfMoFOux/IwUTu8sZ3bFuS6UukRdux0VsKTWxNGPjeY=;
        b=wINf0spy4Qh1CpcLbQL2zU5T1+KRPaCPC5wj2SYOSF1OQkAaz2wJKSuqQdpQvvcG6S
         mK2ygCugyg7yNYdtnKWDn5Uu1v7d2OdoVcyNV5WLsR1ARKj+QYa3W/wJH9mtT4msQqXC
         0zPIXp0/EsP0Alx05SVA8pR+TMcwjvf50FnyBv+G23Ah0ehRQJl0LVAI7IWG6FUIb9Bx
         LNwX52Alfr4WCqpRlQ/mQd1pk82ZalNJsAwRbU0ehUdYUh+YpcRkzLs6kgf3cZMPUjO0
         FVimLFHiRh+GKNObcsfpGBcCEfpgAKOB7QU86g12WsheUoTc+nM+pS/+cMxllBYM9EEh
         KJ+w==
X-Forwarded-Encrypted: i=1; AJvYcCWQBUOyNTSRZ1RgixEj+9y2a84Mrtjt68rsd/KmbRPL9zvDR8io9Tk+E1mhx4zDg/yb5gohCLVP5Q==@kvack.org
X-Gm-Message-State: AOJu0YypSzxtgmKsqZJD1ZCszbmgAhtDqn6Tlrr4VhSeG43Dm/JSm0R6
	7w5PkGx+7Zw+AL/76/y5APXkRGyokY/cxlCszH6srcRxNE8C9MQVHbru
X-Gm-Gg: ASbGncso1jJykLn7yhbzJiH8eMUXzuSpQk8x0F4l74RYggzkxgViQNrc118qdtEup5W
	Zyjwrt6tAXSD9W1Cfct8inmYr6Uajr2cB1r8ctfBP9+M+CJZ49JPNfzDJQ6EAs5v6aV+Yxrh4sD
	rf1I71+/3w1D+flVOj4kjnMkD2DA0kY7YSBr9eDdzD9khYVZC0O7M6jESLo80SfaagvBm7wS2Ro
	ovgSXmskmKJhDADLWKIYTbtJ/ZfQWdUb751+l3DjZ+mCD80t1DSZNVgdgwdhHlUqnXyAnFxK+Zh
	7QqePssvQK8thvbioBvo9yHSgpAU++kvX3EDEZvxI6yRiFUXTqy9qHu6aFGYNzTIp7WRccoTjpg
	n+mvFVfWazDRtTgwblIXF7OlNJNE8/7eXV75//htFd7Q=
X-Google-Smtp-Source: AGHT+IHot5TzlAaP22OS8ozlOyxx1qWLdYvYF4U5lEEd5hmBmhG1Y0KHe5Op8KEKdPn4Q6MVr9HmjQ==
X-Received: by 2002:a05:6902:4a09:b0:e8d:7b84:cb46 with SMTP id 3f1490d57ef6-e902888c89fmr4326980276.32.1754498609332;
        Wed, 06 Aug 2025 09:43:29 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:f6a5:255b:e469:fba9])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8fd3713e9fsm5596151276.5.2025.08.06.09.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 09:43:28 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijantabatab@micron.com>,
	Bijan Tabatabai <bijan311@gmail.com>
Subject: [PATCH] mm/damon/core: skip needless update of next_{aggregation,ops_update}_sis
Date: Wed,  6 Aug 2025 11:43:16 -0500
Message-ID: <20250806164316.5728-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93CB410000C
X-Stat-Signature: eenc939c49ip34jytmo8xuasjb784k38
X-HE-Tag: 1754498610-546871
X-HE-Meta: U2FsdGVkX1+NMXOf7BYhURYEq4FhT7dVt/i0DwxkLoizGT6/UjHArxqoIJDzUNhAN0BEI4E4N6WG7YouNofAMZjxd2kk6ysfcaVkAoRV1Tc/iDGXubY9vvilCYalp/Mm12JnZP/mrXrLZgilPx8n8SK83/H/i8mTPV4rvt+0ncBJnWR1NuLx9ZZGHjDdIvN4ppE8YMR8PqaiYj9uKUkULqry1iwP8g3KX8qMuXbR07WhXc1vfjv6kZRDa1SJbLuKruby6MPwfTyTn8QCV3JjxSu5r4XtAiQBd/kXPuwYaVwkW3Dgbo5PfS7QgFmrdSGi2b45MmN4wyMjSj2BYpQT2Z1m5L0Njm2F2P6oxh/N0cFmn7ZNR40tkZAESbzQkVtcIyRQS7oo8BHbvTFeex8idPkMO3ZqgrEYVwnsLKj9hRYGSFynjIza5nskN97fjfxtsHSsWdDqEDiALlszjYYqlAYweHSLyo7Aqo9+Yp1ttz9GoQwkgdPC7SAeitE7awlvV7HqujEIxMyGjudYCuGypgp1wH/4r1JAHNRjFsQeC4+k6CJEySSBg1MUaacc7PePZpC1eGT62DhPMcNgjgMRSSV2QpTyywH6FEvp6PjjbSG9U97YEnuawz7sVSaiIatMZfKKpScPIba31ceMcCsqmKhZZL89K2eoRIkArvPbLLO908u5/xEgQw8hteuvwggOXDc4aDwTgy/EA11ZNGH4tk0Qz7e8hGNfdlVYR9FLGTyG34Va/7B7oRMv8/bgN5ijSnu2rB03vndBRyMUFt6rmOmZuNMaiJNdBTH7oPkgjOwI9TcUhFXU1w/PftzCMD8l1bY2IZvSSi/f6EVsqlqk5JWPY549p6l8fN8Q1Dp6kHAtPGFiluT0x3zNukKg9RiUqOjGjALftLFkeJX+kACln8w6OTdgYpv3ECNtf1/+kB6PqNNRsYSQjRlDgB4X20sMe8fhDFbTxBllEB7HEzh
 x3uyNpkf
 K0V2uld7z1hGqMvGzHWW29fuwCqIb+/iWjh+RCgs4kSqLHGiCM5UwHpizoQf+zFMCNW7F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

In damon_set_attrs(), ctx->next_{aggregation,ops_update}_sis would be
reset, even if the sample interval, aggregation interval, or ops update
interval were not changed. If damon_set_attrs() is called relatively
frequently, such as by frequent "commit" operations, aggregation and ops
update operations could be needlessly delayed.

This patch avoids this by only updating next_{aggregation,ops_update}_sis
if the relevant intervals were changed.

Cc: Bijan Tabatabai <bijan311@gmail.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
This patch came from discussions in [1].

[1] https://lore.kernel.org/all/20250805162022.4920-1-bijan311@gmail.com/
---
 mm/damon/core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6a2fe1f2c952..1c3d8b92257c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -693,6 +693,12 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 	unsigned long sample_interval = attrs->sample_interval ?
 		attrs->sample_interval : 1;
 	struct damos *s;
+	bool sample_interval_changed = ctx->attrs.sample_interval !=
+		attrs->sample_interval;
+	bool aggr_interval_changed = ctx->attrs.aggr_interval !=
+		attrs->aggr_interval;
+	bool ops_update_interval_changed = ctx->attrs.ops_update_interval !=
+		attrs->ops_update_interval;
 	bool aggregating = ctx->passed_sample_intervals <
 		ctx->next_aggregation_sis;
 
@@ -710,10 +716,12 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 	if (!attrs->aggr_samples)
 		attrs->aggr_samples = attrs->aggr_interval / sample_interval;
 
-	ctx->next_aggregation_sis = ctx->passed_sample_intervals +
-		attrs->aggr_interval / sample_interval;
-	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
-		attrs->ops_update_interval / sample_interval;
+	if (sample_interval_changed || aggr_interval_changed)
+		ctx->next_aggregation_sis = ctx->passed_sample_intervals +
+			attrs->aggr_interval / sample_interval;
+	if (sample_interval_changed || ops_update_interval_changed)
+		ctx->next_ops_update_sis = ctx->passed_sample_intervals +
+			attrs->ops_update_interval / sample_interval;
 
 	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
-- 
2.43.0


