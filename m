Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4944C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BBFB6B009E; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893E16B00A0; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7816D6B00A1; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB266B009E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAF5340346
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
X-FDA: 84970969608.19.8AA1C3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1DB25A0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDxEzSXb;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGD2YWf7x+bc2xuKYd61BqqesZUpM+m83fMjtL5Ub3o=;
	b=qgmLwKcRPZTeclbS+YA8mRTzeNHjh6XwCVceuzdKqAQC/nOZQ2OOp9obWa0NpSKZ3ya9gq
	eubJUVlAe5VOdoHqqOJHDsPUMajenJ1j/R1SSjtCQ1cv3nrDhmmkyQ9RjHl49399e84ujS
	16xXaOs1Bq8533iiwMnkjf0LgPsh4N0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDxEzSXb;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643043;
	b=IrjFBccnY48HugAa0QWSgbmY5P4QADMh4qXltO5ituCBxZ3XOz9sG86NOUKeZHUGH50t37
	l6nqxb639hX3MCSeR7jA2iKF55d6VrX5y6NgvOVMK/vI4UHwRK1eaHDD2/GSdtabcGjgOY
	Jf5WAadYbox3sepn40tc4D8KF+9xg6s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EAA043FE9;
	Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287AA1F00A3D;
	Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643042;
	bh=XGD2YWf7x+bc2xuKYd61BqqesZUpM+m83fMjtL5Ub3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDxEzSXbY1Gp15IUSZTSzgJB4wKiWpCO8s2NG5+ut+qNiXQwqwaUa6JJI3hIHAaty
	 HHNDBGvOpJJzEv5TTOy8vu5Dz2HyU1nx86ht/78bi7HFWSfVQeDgCqDLx9Ubgk8mNx
	 BgWJhkzz4/wP+arQMf4CvMqaHQYzHLzW+frMWWOuf9ZNsJ4AOwyicq3Ph7fmx6/B48
	 YHGkrhxWAejDsyM1PA7s6cqXE/SB9hFEXa1MVtdFVLvorEPgupqpuUrvh9Hqks47FV
	 YV71znycF/Wz1/whWVLSw/Gc9RIIplZjcvnMArB8AKEf3I5+ErdM6xopHVMklJQ3Yz
	 U/MRiMQG4fmeg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 11/19] mm/damon/core: disable access monitoring when probe weights are set
Date: Thu,  9 Jul 2026 17:23:37 -0700
Message-ID: <20260710002349.111414-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DB25A0002
X-Stat-Signature: zuj447gnc4j11x4x5i3uaxg4wsajon4b
X-HE-Tag: 1783643042-234107
X-HE-Meta: U2FsdGVkX1/b0EC3/umRcymusXjxqqD5R96tOe0AK83a31sLTCoNG3dOO2PLca4XhFQ06mnHZxB0ZL8adLCD6PCoaHLaDDm0zMwAJKTeijNBFZhrd9J4SLk+ViFOmRZj6F5qWA593D1gqPSx5rEobJcDs/yejdBYbAb8rqPkHf5uQSX6WGGNMfJ7Kuc/zXO8cGOfN1N6gUyMXW/kLESrRcREligH3nvivXWkgTQsVihZfrv6FY29mK8cUINTZPXmbPaM26qobBPind9LlpJn+uNTOS1FocqK8Hx/gvuxKT/rxmOMqvNbCyY6br8wOXLeC+P3zGW02YE0c8+I2i4t8LL2/Ds9YSMVbLpmwB079AWpRiKI4hXQvokrS/EX4v772DF8AvoIRN6Vqe3UxpseJwABLtg7lK7gnKpakPlg1v8KPpGLbB34sSiYNMvpILDXV+324nLVquJVcMPtzHBWROZjcb2Hb+Hx2Qgt+ZjQTtmbgbMYVw+klgmM4mM6Bz96klNpWDJLe3zc73A9HxYvYsJlgsKXiv6WFrHtWQCQr3SefDW/zUppnUeZH2JMbrTOiPOUKtTENV0sYEifcE+8/7Jf+e/C4jm5VGB9gNoC1OP7Fkx106iO89nvQBJNbtGAxwVGvehYpeTy7KpO9surbb9CwoyjtdxHY1zFksG3EnyN7RuIue1g03PxP0vZPACAn7FEsB6Vb7pDR5y+mXdTx3TAuNXW7w+u+TOGCScKrg06ZGTykGui86opuxsVlN/jwIMvKxrC8WVm+JEurbHln8/E0XE+6550u82HxdN2gKPqJ8JyWrDHCYoBOjAFKz8rJIAvKKJvh0nwoIjgurR9/y4j5+CxFwNPWJ+tBd1nd9IszzbRlqns8qwGen+SlDoc6/ZX/bJvn5p+CRgPErrcwMERZ9cKjKFws4IEK+tejBNzzO3X6uG1SyVsYhCNbVv3/QaU1vkxWzng6FmchId
 pok284+t
 8+6LgvdIvxpQzJB3q+zMjn2EBk3/vmpW31Ds6KugdKAgmXsfWTHkKd8j76HKTLQ3Ja4b0CGKEUBVEo8jGa05f8FgM4MQnMHDMhNzChdER0khEQDY9RDq1zZxRgE8EMHT8tlQTZs6bw7395qS60MrGPvMhQEPtbVyidcLXCH8iWFDAklAzcZElkxebvqNx2zpNWEy3emRpprBAWB7G3ECbgXiMlcFKoJlx7NzT+Rnxr79wAXA=
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
index a0e6a5129fbf3..65f91e3b58d2e 100644
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

