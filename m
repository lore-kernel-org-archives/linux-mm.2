Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7742410F287C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 23:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3EB6B0096; Fri, 27 Mar 2026 19:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86346B0098; Fri, 27 Mar 2026 19:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72DC6B0099; Fri, 27 Mar 2026 19:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD2AA6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:33:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E0A816053C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:33:26 +0000 (UTC)
X-FDA: 84593446812.12.6D077A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9513580008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:33:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S+JFfCfT;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774654404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxVsiPS0xP1dceAU8EIPPNayC32A3kunb1RlapBhuj8=;
	b=SXKRnhXuJW7N4V5nIBpFfJxzz/eNETPwtlM26VtF24I4lzF33TF2Jyz+HS2+U3akLsOC7C
	WGrEj8n9O/CmWRvhEIbs+dl90vslycJSXJmVMvCto4riUjUrc4O8v64owZkb/OyRMSJaj2
	FbpSqpWUcGiKQeIlO/R5G4xcqeVlkwg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S+JFfCfT;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774654404; a=rsa-sha256;
	cv=none;
	b=IOlzhpN+uUHetLXHSA2Hl6MYsMYv3OCr4qNSFkIuHs9EkeACbeGnpE5siG7LxUtkfBbo9J
	fyHLS45SoYzWaUa/j1Ype/m5tL0YYqsIg5LNyBj5TTOaGJ4LH8hPDipi8hy1NYrjNlBzhx
	ZrxcVvQzgpzfQiN8FgxeNZyMyPNDoQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E2D04376A;
	Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6012FC2BCB2;
	Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774654403;
	bh=VSUrozLJroKMWrM7KxSMyE5+mSLHT7kOcYr4qKbQQJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+JFfCfT8CQ1EDMB6mu7gzb95mcb7qRbck02Q3vj3/Lh68f4nC1bboFOG+E9lhZIv
	 qq6L/zMDCxZPvKxQazRGe37Fir+fOObkSDqQ0hD7LHG3jRfYkGQ3M+2t6l4tkLWlnw
	 RruNY4xhMhTe8pu6GSBALQbqs468VASuNIbkKxs1AzLPLcBR5EEuf5ly6OmmDbApsu
	 /s7V/LaQt+aCH/GGpB5p+1lzYp3Guq4Sz8kV25XgjcqYRlrRvfVKrJnmNuyzMr8HXk
	 rcVQ6wvCvlfKXilvPLPW+oZNCrAjzY+qUPu7u1m9HwaA30L3dg8fXMXRdxBR7SvoOP
	 7YrcBI2upyjkg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
Date: Fri, 27 Mar 2026 16:33:15 -0700
Message-ID: <20260327233319.3528-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327233319.3528-1-sj@kernel.org>
References: <20260327233319.3528-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: efqh6pn54ccuasxohddje93gu5x9hcr8
X-Rspamd-Queue-Id: 9513580008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774654404-578824
X-HE-Meta: U2FsdGVkX19AaIsS7FlDUSgpmWv+Q3nH0oyu/AQxLbUtQ7hL3JjKEfyyV/zBby+KPocI67Z/dnhU5X22nIgTWqwKdovs6fCMDbuOsu/2ATAg1D1OnZ+KMRF4L0y1O/qiQ3YHXv5YjiqdXNhplq0uzJiGsN/lQWAIb0HFxUFBdVVtE/P5B6xnylG6pvnrSk7n64pgaLZjQH+DpnoDs7fvKCM4JNtFq+g32V7hk5wYcyeTHGEeDSbjfb5DVqFgHXigDZG0uAtl5bUXdAZKBx34Aw+Xar2ymtUCQ8XLX3q5cpuTtQs6bhLfKK9NPpBxVQAlYEFFUTyw8Z9DCGg334DXjjkFmjFsRPTcaO4lxGbJcL+AXPlcxcfsj+kpbug3ieXWmxY6h+0lNEULvk2kWxqUNigd0VvZ8Ztq56PJMCoY5Z9wBdP837XvM85gnKyxOimVJ94ICGaS/5XGJBjTt1hmvgM3FZIaHu5oaSbYikrejNwKVqcYe+LMxUzdxzV84UiQg9k9FTCa4lJHGPb/HZCwV7C9tsPZ/EZkBiKTB5ypiKkXNfHi+WOFNhHm8mvFoP70NaunmxIDuDCoxnPMe1X7C92jPdQuT6IsUOfrlO5479AE7QGd5i20YV5vrUs6DNgQcXhka33FUoYylKTnNXL62rrqUVM8hl8LxwsbeFBiAHFz9XnTDXwSnpsvl/2jB9MKyR6UeUaxgrFYg2gtQgsXwhGTjKHfrrIsTls8r2VwfZAbpCIZoLYKvnez+UL4GRSsNZhY0eoGPt4+NAZ51G+XTTmaUwrKPqup9b9UakhC1YyhnRYDYhY8O5K6BIFRmMKtN7XZMj/LCCtkD+4XBtwJD5/MrzXySlXeE1U9H42c2eHTWQFyiFG2+N/habTdG5QP32jOthXxCG7S/sIp9UJ7+hkUlqyxPs+WR41E5FBd2BBmpXpsTzzaCvN9Ho4bzfoPdbR0ctABpV6yfj2BrZq
 kqp7jL9s
 dnkWpqoJXCF17xVogUmS9fHbnjNPmSJPc+4/vky12VN/NtupzEwvP0SLN+w/Wsgdau/nt20Lx9CuifGXvwS/+uIV43Ge+mK/IcN+VGCQ2SH2lpGwmtTRvDYl5iSvQskOOtNj9yst7I3PK09oNKOoM0imrA2IoMxIRRkLvLMWfIm00GQdqH47fQLuhUFgBTRnA/4y/OEpN1e3njgAi7NpD+YbuxyjtF6IZCl5VT7MGKdfUKuz+M29uUlAyFNXM+2BmSyeUpXZAMQQjbAIu4y+6feuqFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdamond_fn() main loop is finished, the function cancels remaining
damos_walk() request and unset the damon_ctx->kdamond so that API
callers and API functions themselves can show the context is terminated.
damos_walk() adds the caller's request to the queue first.  After that,
it shows if the kdamond of the damon_ctx is still running
(damon_ctx->kdamond is set).  Only if the kdamond is running,
damos_walk() starts waiting for the kdamond's handling of the newly
added request.

The damos_walk() requests registration and damon_ctx->kdamond unset are
protected by different mutexes, though.  Hence, damos_walk() could race
with damon_ctx->kdamond unset, and result in deadlocks.

For example, let's suppose kdamond successfully finished the
damow_walk() request cancelling.  Right after that, damos_walk() is
called for the context.  It registers the new request, and shows the
context is still running, because damon_ctx->kdamond unset is not yet
done.  Hence the damos_walk() caller starts waiting for the handling of
the request.  However, the kdamond is already on the termination steps,
so it never handles the new request.  As a result, the damos_walk()
caller thread infinitely waits.

Fix this by introducing another damon_ctx field, namely
walk_control_obsolete.  It is protected by the
damon_ctx->walk_control_lock, which protects damos_walk() request
registration.  Initialize (unset) it in kdamond_fn() before letting
damon_start() returns and set it just before the cancelling of the
remaining damos_walk() request is executed.  damos_walk() reads the
obsolete field under the lock and avoids adding a new request.

After this change, only requests that are guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no longer needed.  Remove it together.

The issue is found by sashiko [1].

[1] https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5129de70e7b7..f2cdb7c3f5e6 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -822,6 +822,7 @@ struct damon_ctx {
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
+	bool walk_control_obsolete;
 	struct mutex walk_control_lock;
 
 	/*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9bcda2765ac9..ddabb93f2377 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1637,6 +1637,10 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
  * passed at least one &damos->apply_interval_us, kdamond marks the request as
  * completed so that damos_walk() can wakeup and return.
  *
+ * Note that this function should be called only after damon_start() with the
+ * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
+ * wait.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
@@ -1644,19 +1648,16 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	init_completion(&control->completion);
 	control->canceled = false;
 	mutex_lock(&ctx->walk_control_lock);
+	if (ctx->walk_control_obsolete) {
+		mutex_unlock(&ctx->walk_control_lock);
+		return -ECANCELED;
+	}
 	if (ctx->walk_control) {
 		mutex_unlock(&ctx->walk_control_lock);
 		return -EBUSY;
 	}
 	ctx->walk_control = control;
 	mutex_unlock(&ctx->walk_control_lock);
-	if (!damon_is_running(ctx)) {
-		mutex_lock(&ctx->walk_control_lock);
-		if (ctx->walk_control == control)
-			ctx->walk_control = NULL;
-		mutex_unlock(&ctx->walk_control_lock);
-		return -EINVAL;
-	}
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;
@@ -2932,6 +2933,9 @@ static int kdamond_fn(void *data)
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = false;
+	mutex_unlock(&ctx->walk_control_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -3046,6 +3050,9 @@ static int kdamond_fn(void *data)
 	ctx->call_controls_obsolete = true;
 	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = true;
+	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
-- 
2.47.3

