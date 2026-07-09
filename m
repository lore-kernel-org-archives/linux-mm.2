Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806B0C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0336B009E; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260766B00A0; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101326B00A1; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D10F06B00A0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20220C0AED
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
X-FDA: 84969412500.04.EC2B3B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E448C0011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VeLgLUh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDi6I/gjqdQG3FZL7bTPNXi1XeJP146JhSzquekJpSI=;
	b=HFASLMO95970qTvVnExgBsU/xr2v5+w35Re2qOL0wZK8MbBR2FvUIWe8TWN9vjm6BpGgjD
	+f9pD6RMacQ5i2ZpOGBaFZJZA5DKwUf+UOgGNMLUSG0c5b6h1iGPbC+/KoRMu/lftlWaoO
	2UUf3sFWJrDPFyrfATpRICyfsf1R4vo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VeLgLUh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605968;
	b=Gh9eoBfdKDG8ciG52sPsS8+XSNv4i038SGE7waoEBHzS4PHA/0HUOrnArqpL0eQ8t+F2I8
	SSY8PA2EeedBHnfEd0NAEuhEzD2A7JM92mgDyLUvLJ0K5CKap9LH4sE9EKu9uHXTDuRkmp
	1DBph4LvR6dKLGKQvwPwgGeZEzEqzp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98B6C42DCA;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA61F00ACA;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605967;
	bh=uDi6I/gjqdQG3FZL7bTPNXi1XeJP146JhSzquekJpSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeLgLUh+rr1bHaq7sAsIy8KkttF3Wk9ow6qqHLK2hG/4sPALyBUbRDsJmRf8ospen
	 REGrUy2G3/+oGnrx5zKJkOpytHDB9lYZWKRWkGqLivz+ULyXeeoG88ox7gDBY2zdho
	 N1SMT5+vlgdKW9OkLzXIfhLCcq3/vJOJi9vlzvqd2J9yb1RrqAv6gy30FT0y4EerdP
	 WW97+iqsoD2gHlZhW8Gibfod756Rx4npI0mWW/vVkM23GN9UAnW3TFNqP9Ovige50x
	 HDfeD9UV51vbH3MhDxAZqfngfhxJkwUMXqMbNlTJMhzSKMhW2iTNY/+Vpx3PR+SZT/
	 f5WCzepUR5hRA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 11/19] mm/damon/core: disable access monitoring when probe weights are set
Date: Thu,  9 Jul 2026 07:05:49 -0700
Message-ID: <20260709140600.90950-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1yeebep66n8ocfo5qhtc876qg6kwgx7h
X-Rspamd-Queue-Id: 8E448C0011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783605968-113876
X-HE-Meta: U2FsdGVkX1/NUxAlvi4dfY+J/QW+gVZ2uU0UnWd9R501x4YmaC1dKeXtOkocGmyQdG5oomwwLjL7t33IQMo7RgsTNGVAQxFSGTb+3yeneaWKvAO35pOmqmX2rTybFKDdio3E8GyPnWtOwJvttMw+soiVC7JZhXlmP5EGhIokLf9OwZYZIvBf0GtGR6veNg11ff2jVHCpO5S62DtTdXFD2BvRpDtHF99EncItreQIFduVMGDvzJLHNYTm15lww2kf2PfmgiUnD/dKrP1XnQYPxN1bBiUM0TRwRp4Gt2QJJ3V5PwVI0i0842EthAhZXPRp7excca3Pcj8t1KhtQsgFOOLBRWQFC0O47fjuhw0l8Lmz0b9DRe8uZB7XUZNOcl6iOwmljS8zbg/uI9oPx2dCbrgXMOd3BIqjMmGpV+8wTV9gBZZLPDuPkuVuBaqrZSGEiM1mrCLP687PQnjG/2XvdeqQ4A8Z8MQvCiyveHgejjKstIN8KfLiej+Bx1Bri+jSEKKRtCqoP9d85qcVzFr3lRFBO4dzuVXU1VMlSrXrF5JuMkMytx5OU+nA1ZSQTh2q1sn3hUISDxySXxZrdCANhX80SDu0pwcgQPNzyKuq1dGxVpR+nugnnwmeDyHhwfgagSUBdm4FvHrgW6DrE17QjTqD+banenFkcw2Z4/3iaXzVO0LiZnvZsVF+whHTiPkMwc8s3tBFm6jvDAfadKuI847UVkQ0kg8aYI8cydQeFo/arZEBzLIjpHrHG0/WP7fE0pHb6pwzdBy0tnEm29bGARdzjLMszLYaA5+LR4VhzMtLp4rAfqtRkfH2AeMUwAX6CHb3f5Bcz1W6D3SHMaMsvYrVDWnzZ8aIScCES8ohzYJFFxB09j7LzdJBVykHXOoP0N245oOUivhdKDrXWOnybDGAvg3p19fIR5hvQkk2Drvtn7tOjFaYtfKDOHvFiRxCqXS4sRf92FCpG9rt8N9
 jReZT38T
 /gIvmAlfQ/khRuc3y/V/coVsJfIXQoH4chznh4ySNgR4LIgXar20eKjdkboWXL8yi2jPlENQZ44kE9xDG5GpvFVXAvsbpZJVIRv0rfViokniILeGFGABx/Cp6VvBVbyZMoDt/xtnZdhZhK6wf6KKljIBHhHwLsQ6weBPIQ9P662cpvB+ouKy3hqVFWprZUtiq8EGIMHlRGhllqGjrxOjAzcyIF26BHQ9kgTlHnnt8yFA5IjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When users set probe weights, they are interested in the data
attributes.  Not necessarily they are interested in data access
patterns.  Disable the data access monitoring in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b585e4bf035f1..e250b7080708d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3763,17 +3763,18 @@ static int kdamond_fn(void *data)
 		unsigned long next_aggregation_sis = ctx->next_aggregation_sis;
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
+		bool access_check_disabled = damon_has_probe_weights(ctx);
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
-		if (ctx->ops.prepare_access_checks)
+		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		if (ctx->ops.check_accesses)
+		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, false, false);
-- 
2.47.3

