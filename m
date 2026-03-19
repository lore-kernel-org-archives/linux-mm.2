Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1CF1088E7E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F5D6B03E4; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EF36B03E2; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD296B03E2; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD31B6B03E2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CB5713A42E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
X-FDA: 84561666420.18.C08BA0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71AC0100011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NBhtADEU;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YMPV3dkpZQb9EOuMX4w/FVl7j7P52VJCIDDfozAbyY=;
	b=Ry1HV7qfdHRLKE886CRQ1XxRVBHyIzo0sz25L5RFgNw02n/cTdNQTUj/5U01+a5hf8STTc
	j4uzYW24Q9KN29Z2Rbc7Vcpiq/tP5ceulUFBVp6OeoGFGx1hx9aFyj82LKL6JQSawIH9mN
	cBh0Wc1zsGZPMJVH7cVkxICv0+Q4vgY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NBhtADEU;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897728; a=rsa-sha256;
	cv=none;
	b=wAiSFVZREO9I/s0scJ9Qb/j9rUYLI9lSIJgDLc6Zn+7nZshRBX54dSKytSVrgFrzJ4oDhI
	uTasUvQR6WK8kslDJuVzllOUk6y2lOnBw/mE1Yf73W0JS5NGpuap0fj77VVwduhsBrzr4d
	4VzzpgPqYS4F9B1AjjWnyy1PcG/B1/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7301644167;
	Thu, 19 Mar 2026 05:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ED6C2BCB1;
	Thu, 19 Mar 2026 05:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897727;
	bh=/zdFcK8+rlUNIicMSIFp9XoXm7KV0c/o3PoVHHBf0RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBhtADEUlW8MOKFTIYt/NyE7RkdX0oRjJ8zOtIIzeBYu0JQ6bRJEuy1aioKza4eb+
	 k/Agmpa+S3JyPFK6znbuyKEI5o75f4ScDOltix4MAQ+jeXprd3I5zRa27nXEu7hcad
	 jeJqto51aWv0IBSLgJ/1x4/VuF+Qc3IyrhB4kxWF6wdqp6+0hoICu34PlOZBcJL5rY
	 CZzoq/6vE4vM/Cy7jpMKT0PdOnNru/88LsRL9LjpwpVky8CTd5nKNyT4UEOmPzL89i
	 OxbTkAICViJcf19mlTBTrAWG2n59dPBYIJYP3cPsJ6MzRm8swXL3GGzKuQOHanwEiR
	 0xL2PBh3FzVtg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Wed, 18 Mar 2026 22:21:44 -0700
Message-ID: <20260319052157.99433-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71AC0100011
X-Stat-Signature: 5xiwc7dm1sjufxif71xci68x41zhe5t4
X-Rspam-User: 
X-HE-Tag: 1773897728-734072
X-HE-Meta: U2FsdGVkX1/wbsg/FrAWy2+obiYN5h8ZyPUQAAQvDw3Dsz7DORZU6Y7wCutBlb00dIdix2+Cos6BR1NtwmyaUT6nUX5xIMsZUsqfV6Ck/40wyBEoYNmgVgTwRSLOksUKHhBeTXY2uzP6oD/u220U7mXAz3x2fKQ3YbM61sqbe+Mvr0uzIYJMWP33Dfg5zNriIC2dqZhhteqYqrICdeEDdqtrdF3GSkxS3immXdU+ILoKabZhP9oYnyDoJvIuC2d2vPbIM9NALdH6RKdYiY0jjsZW1ongPrxk8hVyTkHNpDi8txQbZta6lxMxMmhOROlb/H20VUoiCvsBbMFgLC48fJMo0/t+yNRAqyJB0So4E/k2n5Sh/1H1a7573ZlLMEfmksNLcfHtF+H/SCcAHrfLccvRa7cDUEzVfQzUJGKLKXGScRE5lKxknG6Wu36ehHgvfSeSpc3mo1ZNDBAkQ0Fgdu6sOO/tKCNshnB/7YjT75KGyaFDYgeyQVNg0/H1zM6zqXlrVjrRKmeqXxY6JF0LC7bxohFn2nEKgOylUNmkN6KPBE0iv5CZlLJ5vX3Fxhsu0PQdSdQ112Tf4nngS4qc07ovRm86Ct105PfcAA8Fyu1oOkr9vdjpDsUXATIjrlTfgurGSPIzN88XwIc0vC7TiGOULr4214MVvdt9WuvDrHC6FttK5DEPo/pPzt8q9dEjyQAh651W0AfnDVmWE2VIVPCKWoaKqprbO8w7QpQILuTggTVhv0YiBqSosk8auuuB900+YRAO2oKCASN1Ga9P4LJoKB8u5QfMPctGg/kIvnWloz+cJ1I8w+iJ3Bp1fq4m9+OYANB6BmtgPXB1x86G0ImrmDQF9DjkSY9ZK1IORCh7i7m7AKF+OXR+yROScnghSW8mrGUWKpo3GtU8vUP9khwtDGSdee562Hs4KW1Pxmz4tfOH1/uu8t7mn0jm6eh1nt3OtaTOg+XsGq8SQ6c
 r9+GlI1l
 CwenBv3GM79O8YRyw1CJMLddCdmW/vk8gqr4IUbo3BWadBUZEkMHEBvc3VNuHCcWihY77C7ul4WTVhG45xBDsomp3ZVUeFXLlGCNXrTwsbE8iwOat59vbjri3a67qBBUFI6EqvjLK8wM2VviMwcbtRhPta1uc5WgCh6QfbMQwwRNLR8FbBDCs8nYd4sDU18qAbYIXDyxFLy2Q4wosiiBymwBXMzgkmrgiqeh9EsLlBDlG03dTJKBH0JnflfObmUBUdJVGhh0zcf8O00O7OG3k8xEo2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON supports only start and stop of the execution.  When it is
stopped, its internal data that it self-trained goes away.  It will be
useful if the execution can be paused and resumed with the previous
self-trained data.

Introduce per-context API parameter, 'paused', for the purpose.  The
parameter can be set and unset while DAMON is running and paused, using
the online parameters commit helper functions (damon_commit_ctx() and
damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
only limited works with sampling interval sleep during the works.  The
limited works include the handling of the online parameters update, so
that users can unset the 'pause' and resume the execution when they
want.  It also keep checking DAMON stop conditions and handling of it,
so that DAMON can be stopped while paused if needed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3a441fbca170d..421e51eff3bd2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -811,6 +811,8 @@ struct damon_ctx {
 	 * intervals tuning
 	 */
 	unsigned long next_intervals_tune_sis;
+	/* pause kdamond main loop */
+	bool pause;
 	/* for waiting until the execution of the kdamond_fn is started */
 	struct completion kdamond_started;
 	/* for scheme quotas prioritization */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 339325e1096bc..0b6cb63d64d0e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1331,6 +1331,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -2978,6 +2979,14 @@ static int kdamond_fn(void *data)
 		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
 		kdamond_call(ctx, false);
+		while (ctx->pause) {
+			if (kdamond_need_stop(ctx))
+				goto done;
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+			damos_walk_cancel(ctx);
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
-- 
2.47.3

