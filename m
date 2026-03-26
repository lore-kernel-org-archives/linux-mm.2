Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725B4109E557
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E986B0092; Thu, 26 Mar 2026 02:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05F86B0093; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EB76B0095; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42CC6B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:23:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96AFC5C605
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:23:57 +0000 (UTC)
X-FDA: 84587223714.06.1997414
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0ED0420004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mwy694kr;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774506236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCoa/Jmek/V9IRR4msrRR3XzU03tgUzmz1EWDIWHnQ8=;
	b=KTlHlnELgTn0zZjq2Epp6LEBjodecdlshXk6AH1//M9A4aMcXm3v5NmvTGIjH9AnPnx10y
	BD8v8pcCCfU4wgtNWJ82WdzzLX9S6d1Ek1NSPcyJPwmacWXv7lFHBJ9k2c2z14qezjP7Pp
	up64Vb+fap8woBtkBqL0MD6fmNGhxyg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mwy694kr;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774506236; a=rsa-sha256;
	cv=none;
	b=CoPFDOSWHsX8G64MlS6nXul6B/UasNnXimlv0lsXaBtMSRNS3Ps6n3PqBCptOC3EKBujTZ
	QynZrH4bvTdSiCSWCdgDMEAwkWNyL74YziTDdz8cnh6vLoq9PuC7aS+Pz5pjXalJmlYSKU
	1cN8+0qqTBwvC4t/DeDX2OJbrmlN7RM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EBC360123;
	Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD2CC2BCB2;
	Thu, 26 Mar 2026 06:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774506235;
	bh=yZoBuHZtr5Af4B/Xpz7HSwkfDg5FS5Cb3q2CAhjdDrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mwy694kr/IucXYv3o4lC2wcGmle08x19rR8AKqu+ApQaw1MttHlYRk1xDjfyvAMw9
	 g2ZTIW+1aX1dNWinkhZL2TqZFnXF4AjEM72Emb9B6XENOWmz/RoEIMBR0cYzgZ8NYB
	 P51XxGpZlLA24yflwmaciqrNigaY0I9oZqLfTyaTvAE9pnA3iAYxKCw41j1y90ex0A
	 Mzc+Dun0MZ+33dOmRdR3UGFoAI/+8ZhqhMDP3YDdLcbPkWT909w+OALReQcZFsZl6g
	 CU2V7a3Myj83O5kpFlhcUzCAHR4QKJFszZRj3nJ8DPGYb5nyTm2039NzMHA0B5GLVC
	 tEJRvg6BSBrwQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Wed, 25 Mar 2026 23:23:46 -0700
Message-ID: <20260326062347.88569-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326062347.88569-1-sj@kernel.org>
References: <20260326062347.88569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4qysu5m6zbgfpg7c1s6in9f9yyxr44yo
X-Rspamd-Queue-Id: 0ED0420004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774506235-614990
X-HE-Meta: U2FsdGVkX1/gjKVR4O1/Nndt1CE28ZxZVmxxashEIFEn699RtcLgqA8mLnLL3VnAO5zoh0ESiEmXTWB30vSBWlwalba7nc1X/8vxqZUrFZUco2/dTJ8+Yl/KqI3tN/zdLubVbfyqWmxWvwnJAebqy5ntdPEQjTbo0LcshQA3gf6UcMFluu8uSX6+fYAoKkLXqa0vrdYSb/8yFumDGA6lzOgOEFYaL1qM6GOcJtug5fpxKIImjaoVNJxB4OgRni8fHViFh/gQb/xeRemjYTGKQ3A16NeARDxukq3di5Ic1i4jzA8kQOzW5W5SPAxFU/ep3EMVQa4WoY07fHZckwcx4viHL9EbjGXrRK2TuprmyIwAlBgp2MNHFvGFm37awx39jrcrTpRBjoOvcZ1Dyhu/KEqk69altAZfLQ776YlLzBhn8sk6TIcZYyo4X+IFPdK5Ck7SSIFEvy+ZzBvQj5ivPjKWBNCARTUoH+/hs3HTV6enx61zvmevHcjRuIvDDBjyfLC5DO69ci6hKvKo++tjhaXTLhToAmkdxdAlmzv8uOhiRh+T3WehyGsxj3HO6tb+hvJbP5zctae7ugv7J2cxtUt0urIU+NjpSQS0/Xiig+XOyBnq/veEwKLVGLOFdvyn0qog1qwy39B2fZdjzCqiPXgE5WlQwTMAO6bgAjbmuiCObzJeGvs7rGxO5lWEW0tWWS/meCivaMA2f9PaIM3sYSU3vL23M94bYc3PL7Rr2UxiDqyDuOQOk/XfHi44GQs+0WjVdNQN2suwEXnDdJVXsm/ParEu1B5EZijFywv3LxcwGJcrzS0Px7inm+btjYr8dmSPbqcDJRhy4aEGMFY/dM9RNKgV8/N79cWEh31Mqfa8jaf4nezyXutXXQkci44YKULBnQ9jLxgTtji4AMG868Vy5wmd6hi9Yrmc71o2yjFuUfGl3QbxQIVq0Z12F9VEWfz9op1NKgUh8lj6CDP
 phMdq+9u
 aR6DTZ6zYOYMmxBWJ++zj5cELnmyPtcj8+Hk8E/mZNXbe0DnYqzGOrnNyI40seoIqsPxBkDBUcaMkZi8FERVM4F5bjbcQvltN39gDIXpHm4oWhwrmX+bZLpje3rgQSAAJjEs9oMOY+BkU6gz2V1V+qsMfeUY6oY161dB3KRFQpB9n5cjPvFXj1FdEq97zvJWviQCtlhOifEvMJZTib2GBdQdzDGg0OoJNz/ugn5Uoyb0QwTCM4hkO1EGyQPnMZiTso8y5jqM7bvS8ir0i0+zjwN5+AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdamond_fn() main loop is finished, the function cancels all
remaining damon_call() requests and unset the damon_ctx->kdamond so that
API callers can show the context is terminated.  damon_call() adds the
caller's request to the queue first.  After that, it shows if the
kdamond is of the damon_ctx is still running (damon_ctx->kdamond is
set).  Only if the kdamond is running, damon_call() starts waiting for
the kdamond's handling of the newly added request.

The damon_call() requests registration and damon_ctx->kdamond unset are
protected by different mutexes, though.  Hence, damon_call() could race
with damon_ctx->kdamond unset, and results in deadlocks.

For example, let's suppose kdamond successfully finished the
damon_call() requests cancelling.  Right after that, damon_call() is
called for the context.  It registers the new request, and show the
context is still running, because damon_ctx->kdamond unset is not yet
done.  Hence the damon_call() caller starts waiting for the handling of
the request.  However, the kdamond is already on the termination steps,
so never handles the new request.  As a result, the damon_call() caller
threads infinitely waits.

Fix this by introducing another damon_ctx field, namely
call_controls_obsolete.  It is protected by the
damon_ctx->call_controls_lock, which protects damon_call() registration.
Initialize (unset) it in kdamond_init_ctx() and set just before the
cancelling of remaining damon_call() is executed.  damon_call() reads
the obsolete field under the lock and avoid adding a new request.

After this change, only requests that guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no more needed.  Remove it together.

The issue is found by sashiko [1].

[1] https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 41 ++++++++++-------------------------------
 2 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d9a3babbafc16..5129de70e7b70 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -818,6 +818,7 @@ struct damon_ctx {
 
 	/* lists of &struct damon_call_control */
 	struct list_head call_controls;
+	bool call_controls_obsolete;
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b8..a2b553e2c5a81 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1573,35 +1573,6 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
 	return pid;
 }
 
-/*
- * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
- *				      an inactive context.
- * @ctx:	The inactive DAMON context.
- * @control:	Control variable of the call request.
- *
- * This function is called in a case that @control is added to @ctx but @ctx is
- * not running (inactive).  See if @ctx handled @control or not, and cleanup
- * @control if it was not handled.
- *
- * Returns 0 if @control was handled by @ctx, negative error code otherwise.
- */
-static int damon_call_handle_inactive_ctx(
-		struct damon_ctx *ctx, struct damon_call_control *control)
-{
-	struct damon_call_control *c;
-
-	mutex_lock(&ctx->call_controls_lock);
-	list_for_each_entry(c, &ctx->call_controls, list) {
-		if (c == control) {
-			list_del(&control->list);
-			mutex_unlock(&ctx->call_controls_lock);
-			return -EINVAL;
-		}
-	}
-	mutex_unlock(&ctx->call_controls_lock);
-	return 0;
-}
-
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1629,10 +1600,12 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	INIT_LIST_HEAD(&control->list);
 
 	mutex_lock(&ctx->call_controls_lock);
+	if (ctx->call_controls_obsolete) {
+		mutex_unlock(&ctx->call_controls_lock);
+		return -ECANCELED;
+	}
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
-	if (!damon_is_running(ctx))
-		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);
@@ -2939,6 +2912,9 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
 	}
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = false;
+	mutex_unlock(&ctx->call_controls_lock);
 }
 
 /*
@@ -3062,6 +3038,9 @@ static int kdamond_fn(void *data)
 	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = true;
+	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
-- 
2.47.3

