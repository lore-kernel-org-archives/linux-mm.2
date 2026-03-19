Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6941090236
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3E56B04EA; Thu, 19 Mar 2026 10:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A8A6B04EC; Thu, 19 Mar 2026 10:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8246B04ED; Thu, 19 Mar 2026 10:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37F5D6B04EA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:52:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDE2C599D3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:52:28 +0000 (UTC)
X-FDA: 84563103576.26.38F5A2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3EE36180011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:52:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UIZuhkS5;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773931947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2Nk4BLL2xvOfnZiK1j9eYuU1+jsmMChbm5I1Sr2AlnY=;
	b=ZnSmz9V5RM21M+ryo8QgbgSFC8B2cRBmFdHZyNyyaEgN0IkgGQLINJRxnlJqhEJZQlbNBc
	IlnC24JMV0gvBS1n2F3eA3aiaREz48TXZKO2i7y0+9tfmGuVRu1wkh23U4M2R6bykntFcF
	lMJeeP1Zpp9LoqO1GK6SyXLI+XXaUyM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UIZuhkS5;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773931947; a=rsa-sha256;
	cv=none;
	b=sqVNeJmbWN+2SFOKcEj7zQA9ghU7Zz8DCfmihFD/b7GXXAMCtYFvWfGGyKNjGq24VYNSpE
	JtC7zqEBq7zjRPvAFX0rP8QbeiWQZ4dcyGanGfZ9AeSnX61DG4TwMq0iWGxEwH2U8tWTOV
	PSGRMwFnyKsn6gOkuZmXyJ02jL//cVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41D8F41756;
	Thu, 19 Mar 2026 14:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E24C19424;
	Thu, 19 Mar 2026 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773931946;
	bh=S/gZgyTYvC4CrssFFtYDNp0SzgwSfvUoAiAAW+9FERk=;
	h=From:To:Cc:Subject:Date:From;
	b=UIZuhkS5OM2LEW/JmKTVfUX8UjkKQTrQFW8hsHgEEJV0gCH0Fb2K2a673mH23Z7VI
	 4Jkfk37aCLhl7GyqfJU5vZw80pZx+26w/+SEDwDZ5LeGH5RkneDc5EbX+a4g8kT3k2
	 /E9vfJCdHoJTBpEtdzZojTxtF61UiIrmcLdo0parYaLkkqz2Nkj/qINgIgiW8N/puF
	 o5SVOAgjMDC1lT47MMaBXigGcG2fRAdKKRBN0O7tv62rEuHDpXGxohAgawdy9N16tt
	 GUplp8P9qVS5GpnYaRbfGQn6FsI+g2M/tkTcxYGt5ofQ55iiBI0CAUnzsbwBIyb5Nw
	 YPEJ5mh2MXhDA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: avoid use of half-online-committed context
Date: Thu, 19 Mar 2026 07:52:17 -0700
Message-ID: <20260319145218.86197-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EE36180011
X-Stat-Signature: xzxwka3t3xw7aee1zius8tddhg36n5ui
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773931947-385007
X-HE-Meta: U2FsdGVkX19Dwqzmb32O4Rn2fjpl/0Ubzfk9FgEscvBjLdqHIN/sVpU1XB3Vg/CSyi1Y2j/P93bfecS9OZ3hCcbNfNljGMW/unup07RFqBU1t/LfOMhHN9kFm901GEogyGNHFSmEBNBMHwPIIS73XkbCS54B5I4/8KnWfxPdwldNinMM54p1GLotL352fJswJe5EABZFkuwk0LBJ8de8BtZFbKTxwVBx7H4teLneQV6/tPO7AQCsfBGafuWBhcD/5tOV0ySlBG/mpwfrMUonvw2GpeJqEeIlNCbbzxm3gnCtEwiUTs2lomUpaiHyKCdWLwvy4kBUBy22xqaKF2+KQQwduEDJelaFhNM3HStoqKROy1gug8/0fOALbidH9fG6lZZO1Hpw9X8rZBafo/e+YYybp55firXDe01XPKtsHATZovoyWCOavCgJWYuSFVOkkaB58EWStGSCwn0GeEGblnpaRQpE/j3d7TuoGe9LRXpu5BCL9hcOsY4ydIkh5OI0BsDsR98/l+YDz703zUiXOl/x0FhzP/HC9JAXkIOHMjPg46CSRBxp8H3/02aXP4n8cjsfNKCBZV7tM080sI7u60VnTs2HiYSwkJ43tAU9OT/7oGuJKriPBguYpR4s8nJfwbLO/d7XqTahxoCUa0N/yh0gTSdZYyYS3ZzdruTEvqN6ivO249/i7kqLYGV67Cx2ivptUkrdZUoIKi5vR763lN1MaDGBhw6UwxrSAOp9KveRcQX/bUgwDDrSDDnXyhl/81ADF6ZHZ8YQ6p6DhQ07fm18rJShWB9MGiLvDSkB6jF/bcb4YVY54LM15SZWoH5aQaRhhmLYsMrPlhzAuuCL3fK28QwZIk+VKND4dwviuv6yviyN95BirymsPNaA8v1VWXhGQmj349bUjkuK82GBjysQ/AODXD35XMh1TKFLO4CxeKiP3yaZUIrohfOxAYUchupFPklqkbhDiX+edtP
 mSvX4y0l
 vvUykeSbJkorQHgNliOKapPn4ks7T7ZB09u0LWPSULgaBMndW+USihxJOBWP/Eyb2u7z+MbAn3SUiulpB3I9hMut9ojriohXSihO2qjtI79MAmBZq3NtyW1uGT/B9TLJR9yrVk9YhJKCqS1a7dlX1XyLYPNDSa0zdw8FSgxA5xaOCtrx7vA/wVOzzjQuvAfD1J32jDKjmuDxoeJgcL3Dcm2XCHf9GG/Ni+iGzJ9TyUxUOzW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One major usage of damon_call() is online DAMON parameters update.  It
is done by calling damon_commit_ctx() inside the damon_call() callback
function.  damon_commit_ctx() can fail for two reasons: 1) invalid
parameters and 2) internal memory allocation failures.  In case of
failures, the damon_ctx that attempted to be updated (commit
destination) can be partially updated (or, corrupted from a
perspective), and therefore shouldn't be used anymore.  The function
only ensures the damon_ctx object can safely deallocated using
damon_destroy_ctx().

The API callers are, however, calling damon_commit_ctx() only after
asserting the parameters are valid, to avoid damon_commit_ctx() fails
due to invalid input parameters.  But it can still theoretically fail if
the internal memory allocation fails.  In the case, DAMON may run with
the partially updated damon_ctx.  This can result in unexpected
behaviors including even NULL pointer dereference in case of
damos_commit_dests() failure [1].  Such allocation failure is arguably
too small to fail, so the real world impact would be rare.  But, given
the bad consequence, this needs to be fixed.

Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
the damon_commit_ctx() failure on the damon_ctx object.  For this,
introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
when it is failed.  kdamond_call() checks if the field is set after each
damon_call_control->fn() is executed.  If it is set, ignore remaining
callback requests and return.  All kdamond_call() callers including
kdamond_fn() also check the maybe_corrupted field right after
kdamond_call() invocations.  If the field is set, break the
kdamond_fn() main loop so that DAMON sill doesn't use the context that
might be corrupted.

[1] https://lore.kernel.org/20260319043309.97966-1-sj@kernel.org

Fixes: 3301f1861d34 ("mm/damon/sysfs: handle commit command using damon_call()")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a4fea23da8576..be3d198043ff9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -810,6 +810,12 @@ struct damon_ctx {
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
 
+	/*
+	 * indicate if this may be corrupted.  Currentonly this is set only for
+	 * damon_commit_ctx() failure.
+	 */
+	bool maybe_corrupted;
+
 	/* Working thread of the given DAMON context */
 	struct task_struct *kdamond;
 	/* Protects @kdamond field access */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index c1d1091d307e4..37454e8c9c510 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1252,6 +1252,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
 
+	dst->maybe_corrupted = true;
 	if (!is_power_of_2(src->min_region_sz))
 		return -EINVAL;
 
@@ -1277,6 +1278,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
+	dst->maybe_corrupted = false;
 	return 0;
 }
 
@@ -2678,6 +2680,8 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 			complete(&control->completion);
 		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
+		if (ctx->maybe_corrupted)
+			break;
 	}
 
 	mutex_lock(&ctx->call_controls_lock);
@@ -2707,6 +2711,8 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 		kdamond_usleep(min_wait_time);
 
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			return -EINVAL;
 		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;
@@ -2790,6 +2796,8 @@ static int kdamond_fn(void *data)
 		 * kdamond_merge_regions() if possible, to reduce overhead
 		 */
 		kdamond_call(ctx, false);
+		if (ctx->maybe_corrupted)
+			break;
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else

base-commit: 969615b6b5d178009a87abf4e4292f90c098978e
-- 
2.47.3

