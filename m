Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D82F34C79
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479376B0092; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B45E6B0096; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2551F6B0093; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 152F66B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C375E1B6E64
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:50:15 +0000 (UTC)
X-FDA: 84655934790.11.A29308F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2DA6EC0002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:50:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ue0OyZPg;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776142214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZZJDeDMUCJ4duVMOF5j+VcTG1WGQDsVO6ZNF1QPLYg=;
	b=0JB23qDIj07hvDfMqJdL1HNFQ0gBsoe6uxMaQNkLwt1rdvwjwqZ3BNHNv4ovVz5IC2QgeY
	LQ3eyOEWOEDJLV9nMGDY8GKW/BLCZgrnFhZ9hQ5Ak6jQfBC6YOg03YPyPAOP6KWsJO1Yxv
	eKRLopwjMEKEOQWZU48CI6z3agkPDvI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ue0OyZPg;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776142214; a=rsa-sha256;
	cv=none;
	b=tjhk7h87ZWXBBalNgpR+HIQFaUJFogMMfuJR3/omG/isGRWGorcxzY+qCn7TDsXmQrrZHC
	Bl9YtNu5C27tRGrLFT2DWo6V5Sp0SKcGXJIb8/uOXG6RdDa8g4VKwZqK58rjIUM5oyEgxj
	gMC9JDVIntujC/32EepfplBhPUz+0qk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 986126012A;
	Tue, 14 Apr 2026 04:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EB3C2BCB6;
	Tue, 14 Apr 2026 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776142213;
	bh=tEc5S1Hg5SD+ndgy55KmKghFX44j7oOw2xQAGI0H8z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ue0OyZPgAKphMQmfgufZ2O980EarRHbBfjq+clKfoxTrPNS/sRMGwvKWPR+k2nI6V
	 WbaeMSQbSvFgXYglf9GY0PmVsD4bDWriarNDgdciO4K8MMIn81q9svdQtQ3XwQMLBJ
	 ezf7jCkUo1KLEVrxgWjTfPC+taBkQBnQ8ugAd+i05ppnCM3ejkHXCO7TsdB6nzlHwR
	 sZyUAaF/35qC/gIDoOZVo+WvIQA1vsoUwirXaZDIbj1UVfxC9IxyVmxo3cHDT60tkP
	 XRdUqjKLPIsfS16Hy1PlbGnp/ffQbaYoGITIJ9fcDaVMfHP0BM7q/MmLsffDjmvmBE
	 Q7BlFiOVf8e3w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Mon, 13 Apr 2026 21:49:59 -0700
Message-ID: <20260414045002.88110-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414045002.88110-1-sj@kernel.org>
References: <20260414045002.88110-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2DA6EC0002
X-Stat-Signature: mk6q4sgiwmkahm3rdt81f6ekxw8adr9h
X-Rspam-User: 
X-HE-Tag: 1776142214-250945
X-HE-Meta: U2FsdGVkX19U09Yyl/xcg11t97oYw2KaTa164q+yYyL8AwtxDZdAV0H/YQXg3KKS7lwlZAJ7qsY/RhSQ9eUrjEqyfhXS79xheu3c6LReZn6zf/twXW9uYTUFIurZc/s3erx2AsBc+9WpfnT6GX0MI4W5mNLo3Q9R1W4MfEhO8+qr2I0i++1v9n4VfwYWi77Hh7XKMjW3qA/GbWt9Ij4luaEU9d5Un3c1NR7MAP9FmvV0EcDws1nemK6k5f7Y6zqcF58EM+Gc/ALqlrWe556PGlmuxR949+FUXX0CEYXdw3ZG1rOz3OPIcA7emWpGZWKuicVxRXGLYx1elWAMJu94HUf8QGCHUn3/mhZvLllmM9wGgqWfpTFyZPDaEoERhtp765hBfJvdfcrBKJmp6MqaV0qdREnN7iVoPqdcaDfvGHS5dil1wdoTPgVTd6GsBoXRru1r0CJm6fyhwVoAhQD+nyBPvzerST9nikJlGuEPT2U8FCUQAi+MT4cVB5d9mN4M1Ef8zqsy77R0cN8a62xa1wVCquZBJJtvv1cac6EL+8kGCwvuNbGIsD93YlhGB3uG/3IX7zi6NpDwf0xJDDIWVWvhO+OBTpt/aYLI0SA+jEnvJQyOy31dpihKxg7v3dlynwNXl8ZrLZjnKMdKVtrY8i7HkhKuwFlorWLqHL/nX2qvt+DK7bWRYeyeB5GYVsMgS5GYB5j6L6B4E2dtjm6XuWakNdd+u/Yjb85YUBi/U8LZkK+ceazmnKUiuc+Hm9vUexCW30/bZa/ZIqvD8JXwCJzp0bwjlHz6zECGLui3beJNekYOBJ1ZIsVcYazhae5BJm9DoVrxlGRs97/R13ySG5z3Z0gZ82CAB9Dp3e0bxSyEwl0po/EqEvlFzU3GEoW4cAavjiZJM8Wk/YoVobA6Qc2aXrDFacpvV8pFTv0cBMF0aLCbU8R9hVjYYHPS/6pBHPZcjVKVn+kbPhiw4kO
 5iN2mBM0
 CRKeM86Q2nUJIdp7OBHwIbaKlon6RRhQDdewHIDpbZiA51wIate/637KBnawZTMeE6yGxOYKykFn0tvKQp/NjbXO8qe59f2y7PIVP8ZCQn00Nm8KNXkJYZWdd4uHFgx3oqFZg0Upxp1qMISnXdas4sJxJ7z6wqdAw/LAlM+rjcEefLY1rWkZC6sVkBiFMYlxJyaqH1vYRPikdj7X/QIz7tk7t/xECClc9dZoV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Knowing the pid of the kdamonds can help user-space management including
monitoring of DAMON's system resource consumption.  To make it easier,
DAMON_SYSFS, DAMON_RECLAIM and DAMON_LRU_SORT provide the pid
information.  DAMON_STAT is not providing it, though.  Expose the pid of
DAMON_STAT kdamond via a new read-only module parameter, namely
kdamond_pid.  This also makes DAMON modules usage more standardized,
because DAMON_RECLAIM and DAMON_LRU_SORT also provide the information
via their read-only parameters of the same name.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 99ba346f9e325..21fa04d95eeac 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -44,6 +44,15 @@ module_param(aggr_interval_us, ulong, 0400);
 MODULE_PARM_DESC(aggr_interval_us,
 		"Current tuned aggregation interval in microseconds");
 
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_STAT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+static int kdamond_pid __read_mostly = -1;
+module_param(kdamond_pid, int, 0400);
+
 static struct damon_ctx *damon_stat_context;
 
 static unsigned long damon_stat_last_refresh_jiffies;
@@ -260,6 +269,9 @@ static int damon_stat_start(void)
 		damon_stat_context = NULL;
 		return err;
 	}
+	kdamond_pid = damon_kdamond_pid(damon_stat_context);
+	if (kdamond_pid < 0)
+		return kdamond_pid;
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
@@ -269,6 +281,7 @@ static int damon_stat_start(void)
 static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
+	kdamond_pid = -1;
 	damon_destroy_ctx(damon_stat_context);
 	damon_stat_context = NULL;
 }
-- 
2.47.3

