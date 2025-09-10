Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C720CAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 04:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FA18E000F; Wed, 10 Sep 2025 00:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7473A8E0002; Wed, 10 Sep 2025 00:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B3A8E000F; Wed, 10 Sep 2025 00:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 542B08E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:00:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 046FD86969
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:00:29 +0000 (UTC)
X-FDA: 83871988620.13.017E9E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6CFFCC0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:00:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9cC5W3z;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757476828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3nggkW4b6Q0h0RpIalKWvs5qtuT62vkVlDCtxbAFmg=;
	b=Knt8a3kSkItfLaeFYdopVel4a5/0xii/+2GxzzUii7KzAZocEis4DbIHHW3OXCfjSA/8SX
	qV133WxfAvq/wyzbYkg4l177D4TNS+swyvC0dnPs/WA+ywM6UXYIyqXWyHMHsqssvFqZ0Y
	J4LI3ABuL5tlirRoRFEyUkrk4O9BOEM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757476828; a=rsa-sha256;
	cv=none;
	b=ePKbb93/Pc8eq9GfIE0KtHPhvv2SeLzFnIVdUJp8OfJqEs3H8IzIWLhTsKSvUnkcd6IuL7
	Z4otiW5745m7B3Lp7pEGjL2/o8bBrfkdhF8CmuFXzekj8t8KXbxchpBrvsqWPUXYLBCkZF
	sZAejsU22xXJBqhOwLB1K+3v+bTu2j0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9cC5W3z;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB9DA60242;
	Wed, 10 Sep 2025 04:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C55C4CEF0;
	Wed, 10 Sep 2025 04:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757476827;
	bh=2zAXABT8QAL9TDJ+jCcIqn/wxh096OGrYLR4PeNZCg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9cC5W3zGB0zP4XJWUPtb5EkbnCdT8tUDO+7g+aA/oz+yvmnmeAIWhVrW6E/1Cqcx
	 CyKPrfuhZrHXaqVVFOH2oURcCbTgP/xYM67b9zfscIslWpwFI6KFTWbosTVx2D2aQ1
	 r8cAy55uc6zRw1yMxyvmibc+jsoOUQ35ZDOQKVE0i5QV6biq4oYENYI7DH4tr3Zv30
	 znDVGhsYRTwoK1CdWKQ9dKYXWaF3gw1U0Do1miKBNVpj2bJypzIIREA/n8I1GLY8EU
	 3VMO8YTC6iTa+WdtoebFXnp4LYa02fC0PNR8u8+Jqd+rFzBLaNS8ZxAV8vock/snC6
	 T3SUayFJFQEsw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/stat: expose the current tuned aggregation interval
Date: Tue,  9 Sep 2025 21:00:21 -0700
Message-Id: <20250910040022.168223-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250910040022.168223-1-sj@kernel.org>
References: <20250910040022.168223-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CFFCC0005
X-Stat-Signature: qz6nkiq3cre1gfkhfwrrapst5r8d91du
X-Rspam-User: 
X-HE-Tag: 1757476828-121502
X-HE-Meta: U2FsdGVkX18yJWwZ2LIV1dqRQT91GJ/sWIoascosKRVf/CfEFlJnNigSrPwwQsSyCKXGpkMUidfiI2eu1ohj0kpQVQ71lhEsmtUY1ygl/VrbiH5i7UhejbPTlPpVshH24RqeRJ5Qzj6/AzkIavXoXfkDOTSfb1fzltKsPcZpdcRjBnH2n4atlIBZNHXfpyp6TOo2MmT/TceroU9vIXiBNV5bjXYXU6jM8SJCdF9pakNETjx+ZjaJzRHEZFEdWyYs/U5ZpHRRENnplcd3AlNTi4zcgL3NPQ4HNDbwkkFru/79x0HBjzg4JVgKwsTyXK/KX0rjwIv7yfhz+D+MXFHBC8XOTjy9apzstGcUO+HE9HtKYHLvIvSAfofsGZbM9/efhm3m7ORx3xr09k7zj/5opsDXqtYrv5tA+J4S5MUxxum831yu2pv/fTqKMAN1NVQC5k0NzAywEj2GE/hfzNKBv1at+FuHXNkNomyYU5j2PRgoC/c+vuYrG0v30xKeruzGPQARWuotOAVTUvACF1KdlRZvolsqM2nqnblhYQid9MIo5op2HiEVpIwRyV1fnC/eLLFREyljxgBZ+l8kilFNQ1dbhCmPffJ0zpP/+Ir8HGedM/4usEZ06jyzd2W6+1jyvjw09FLathX9jw7RR650R6RFKxOerwtaMwAaa5xgwgMUye5HOUk/SPgt7r+KcCMGg9VtOq4mtEktHXJkeGL0fIxyGpsjZ07rxNnxqDX4rWcFGrk9Pp+QhMknxJcu5w1dg3RqYnKIPrdQm/yAeZ/ZciGW3WLQSYEPJfIJV8fP/VvFWYdCVVAtVdvfr/XRTuOJEwuPIOpf6z3mKlON004740cqOXvick3kN8SDLk6KligxhZ0KqaWj/dgwasR2dHenutyW+fUcaAlmYFY7ooPZ2abkI7cNbxmShUBqL+bVFeTEItu5Guieb3IRHQyOd9Gi2FDD7vPnZAixhlUj0rm
 WAeOFmPI
 VTVgLynCGpPzjIcyrbjKOXwTg0UErBw6hpylPaDHsdbrqKaDhx/rqH7eb7EADwaQ3SC5W+jO+2GN20rjx3LRbcNIigj+XQn8RZ07fdRi0nVITQha2hUy1lr8dbYV27qXTMzIfZPODQMtVEuy7xPsyrwpf5mBJNHqRAwBazFVPAnB93ZyhvhJ3kELnAMUNiehBSrw2MX73Dmxda0yMmFMIc358v6tUfWqm869t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT calculates the idle time for a region as the region's age
multiplied by the aggregation interval.  That is, the aggregation
interval is the granularity of the idle time.  Since the aggregation
interval is auto-tuned and not exposed to users, however, users cannot
easily know in what granularity the stat is made.  Expose the tuned
aggregation interval in microseconds via a new parameter,
aggr_interval_us.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 87bcd8866d4b..ff1c076185e6 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -39,6 +39,11 @@ module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
 
+static unsigned long aggr_interval_us;
+module_param(aggr_interval_us, ulong, 0400);
+MODULE_PARM_DESC(aggr_interval_us,
+		"Current tuned aggregation interval in microseconds");
+
 static struct damon_ctx *damon_stat_context;
 
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
@@ -133,6 +138,7 @@ static int damon_stat_damon_call_fn(void *data)
 		return 0;
 	last_refresh_jiffies = jiffies;
 
+	aggr_interval_us = c->attrs.aggr_interval;
 	damon_stat_set_estimated_memory_bandwidth(c);
 	damon_stat_set_idletime_percentiles(c);
 	return 0;
-- 
2.39.5

