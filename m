Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35634CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C4C6B00AE; Mon, 18 May 2026 19:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4A26B00B0; Mon, 18 May 2026 19:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DE26B00AF; Mon, 18 May 2026 19:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5CE76B00AD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84EA2A0B3B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
X-FDA: 84782164698.24.0F96163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C45368000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNtF7sqb;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHrmE9flUeJI4nU+SM6rc2thHdTPVPSprgG50RMUPzo=;
	b=MmHUs3Vm73YDIMSmIiY0HDaO2GdhTg3Z40SnUctmhcre7sWYpDCjMPKh8tcbEizD6tk6DF
	KDf6b3TJyUJSYT2GFZF0ozCrVyHMWwssfaherXcmOVRtBkFQ8GNKaPnoDsFut2fc+xuvvJ
	DsZSHc9JxyLvsxgc5lWUX36Hx+ofGO4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNtF7sqb;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147687; a=rsa-sha256;
	cv=none;
	b=GV3iR7vl+qBdbKFshGcru4xWxQl7rPl6w6TbX172qtbEvK71W4GK62tQpZMIZ1gE3eXx0V
	iv3dvEjz17FXXItwPTpvzlkXfRVwGvciTQNT5RdrkMLCfynxvENPPW0HR9B4CSOMtQ6t6H
	9iU7K46NMjgzIyQXLB5qLyy9RuHJ94Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63BCE445C5;
	Mon, 18 May 2026 23:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22534C4AF0B;
	Mon, 18 May 2026 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147686;
	bh=EOdiDLw/Fh1yhoztKW51lYed+pEAR0BsIW9TAh1kfRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNtF7sqbaWtRINKs/9wm8INSXN1Jw85y9a3gFeOXhJASFk2FC7+1/9zS4gFnJMnep
	 Ijk9mRO0bujO7/WL+8XgRvnYe51tmd1qXYPDbsLqDaPCNJmPYmDtal4i1eOJUMYsmx
	 hwktFvtinqKzdvsIAEojku/MdJhEKyOW5KLISSL8atvr35FyfBV4sp2F9QN0jxX4Th
	 +VdbY8tsBKNCztZQnlFyDHma2nh9BVFShz29Ie48U83xGR3Sb78vRx7aGUG6Fbq5aN
	 Y6KY5Dz1eVXmcfPPNxLikOmw56a3F5ZPVNHXI2JPS5co1BH/qO/Oro2J5K5nyVnJSx
	 eF9sOSCkwLkPQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/28] mm/damon/core: do data attributes monitoring
Date: Mon, 18 May 2026 16:40:55 -0700
Message-ID: <20260518234119.97569-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C45368000A
X-Stat-Signature: dhpmu7sonfxjyppw3tboiooaarawsoye
X-HE-Tag: 1779147687-620154
X-HE-Meta: U2FsdGVkX180Phvj3qZub9ENK26BKMi8CmMe1MCoJXun255joPd6DJHCtFhtEPrDgo/u2H5a4yeoI6G7lyxpWqVQDljMOZqtJyp9iJdxbp6A18aKrVkCJJzGHQ51m9QdDbefjiJaiwVdaUJ1N0E5fr5ZzX3C7NGAvnQw39cru2usp/mUOXZIuMgmUwHnkDAbE7dHv13oPA4AX0iEIN9xNGEzfYU2DS7BXW4Ln5p+UvPb5e55mZEzcHeya4KtUOF0cqOeSRyiIcIAvZ9w033cQgdHw2bYxsbtwBVZp6Q8dXhhhrBqGT6i6Zhml2wb67uy+UM95kHr+rNbzqoGS0Zk3a4aRPZQ9VNfE4xECUbdScOzgGXCL9gfqZuEIXQO1xiwWIyhuwRgnnMQFrvli/rQ5rSBeBu/MTk5aupKeJ46KVVgi2AylTlfyyb5d/0GgaoWvysK5sQMQMsDhOXW7DoBqVlsrlUyk7FUjTWZcGrjTHTIbwKpmK/c/R50M/xayMQlEp53AvJTPBYQhJur+zqIwocFyfgr6JZABnbX8cb8bsUh/ThYlx1rpIEcHhXUZrKF9L5VTx1qB6ohiHSCjVZWyhOkKLQ7mFr1IlYtgvp3qODZCscoxG6/olqF0T7WY5rCrlaTl9EZVR6ZvtZ7y+o97XHKS9lVusZEvRqVcUI1ejEHOCfCWE/bV6k9KJxYgQJp4OMeU3wv5Zb4YNYwsdw5fA/zgMnH9Jcpc1DfMOjRWzx1j45AR1tO5nNXKjVkRAyGtuYSqhmlwWTSVo8XWIYfZF8wzVths2j47GYmK/kdRSkBSAfBtkydc15koLW/DsW0R/k0wDgVqabMshbE5jWLJWs3X0t1GJldK1R7mvDCqSn4H4Q2xiKu8pS7bWdqI2uP2D2qYp6e78Q+lLeWPdhZh7cDg78BYpWXdu3HEJilw5gT2BpZYzPE2HH5zBTdDit+MI7GPndbkKcAldDf19o
 tN/gjRC7
 wu6mKzFpq0XIEXsbB2BHIbqXc321gzRV+eU9mtxlpO4Lg0RBMSrtXdY/MwG1558OQGmPw2J6GiYxKRa2UhI2W+qRemSARlt38x/7U9cYMBSr+NP/1WSdiz1uFlmr01yIdlRhnDJXxOtYjPwX7MyfYh7gdDV4uccC2UPkIG4URsQSzLg+tBMYrgsEwYsiC2/5F3sW4T2gVGrqfSPN+VNifjnaqG9UcSPztfPyXx6QJSEo1yag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the data attributes monitoring execution.  Update kdamond to
invoke the probes application callback, and reset the aggregated number
of per-region per-probe positive samples for every aggregation interval.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6dd1bce81ec2a..433da8781e255 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1913,10 +1913,14 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
+			int i;
+
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			for (i = 0; i < DAMON_MAX_PROBES; i++)
+				r->probe_hits[i] = 0;
 			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
@@ -3410,6 +3414,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

