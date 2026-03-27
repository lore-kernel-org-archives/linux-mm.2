Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C64F10F287D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 23:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C986B0095; Fri, 27 Mar 2026 19:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CA46B0096; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DBF6B0098; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59796B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E4115B172
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:33:25 +0000 (UTC)
X-FDA: 84593446770.13.911B3EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18EBEC0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EJ0Ywuaj;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774654404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sztX2ARE8PfTQjOI4FtyjfjsNzcjCO8G+lzDoziIZqg=;
	b=b5zDXFr5/5H0mkPBVJvbv85DbYBoCLsfPxKdZ4/C5ZdKdzQIOQGSlE1eWh2s2zC0jKfEDG
	f7r363nNEZ/mj/ImiKEaSyTSWrUI1VlqIeHAhGJp5/3exWnN3bOoQSgBivMJTQ0JvvXT7v
	IXUMUlnJIUKDfTckgDjVig8/y4X0DQs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EJ0Ywuaj;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774654404; a=rsa-sha256;
	cv=none;
	b=V5VkNas1XReWjzhXxU1NYXzmJZnWpQ4xkZaLN5hkl/q4qANQ2THewtHq0zDRedkBqrsLzo
	LbO5rWwGIn43vk+S/GKAuQIvBWZ+1HRN0fo+4l8702RauHvJubRxLMJ6PpN3MM+dlzY8op
	HVTTiuYcjIRpD5EooPl7JH3UlPrVRbM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F772600AE;
	Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231C7C2BCB0;
	Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774654403;
	bh=X/kqNZLKtesRSIyhav+P75YRaAZ0/1+07JTNlAW4fj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ0YwuajSSsbNtkz3wnEYhZOQoN2/uVywp2Iymk+Ex5FGw8gXpYHj/urZLBGZH/ai
	 2h+ORHvvEexRIWeR9O0TT+blGgwy+Mjab6eUYjqfbteXMacscaUUaijSEBx6RGzf84
	 xBOpoZC2ZJjVSM1rO2FuVdt9dNdP2AQwymKc5NtRGrCCcjIkqmLuUp+3ggxr5MVQqx
	 EDqMUuvlHO4fybm3OgIj3/mxVtro4rakrdmOXMsFshDpBgwqC6o1WSf6XoltfKDuNL
	 05Ub4/2aNA5ybKdMYlUahMwoUiEx44tJgIjl1jVeyzDXeCeiC96CRbTtLUxOF7WyOZ
	 xURk3iQb2+rBg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race
Date: Fri, 27 Mar 2026 16:33:14 -0700
Message-ID: <20260327233319.3528-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327233319.3528-1-sj@kernel.org>
References: <20260327233319.3528-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 18EBEC0008
X-Stat-Signature: 8ygphridx4ww56tpemtepqaye6ir75q8
X-Rspamd-Server: rspam06
X-HE-Tag: 1774654403-454166
X-HE-Meta: U2FsdGVkX18JEQyb+BZnG1TxzjjBLnx03/EBcouChD6UZvykj4FuE3xD6a4QzD3Y1RMqoqMFzyFQClqfvUpWeXnkMlmql1M3FTPWhJuKLBME6iqjNhYxL0Vi4itqSg3eDtsjbmji3f27BZ7caM0FiZxDFmeWh3dU09+388JM221xep/V9/xxVxf0w4KYSsEYBQhYFVryCQSk0BjdRms63ptG2e5soR1/I0VS7QuARN8wSyoei1e/iQB4yX66pSTZyIwr46ztvCq6XVDDcZpPJQViDw1gwWkuS9AyIffXj55cYlCtXaIkcra9f1Ye8zfSHUoe7wAK1vFYNC1PZcR1F9+VbvF5LX63zx/nb+53W6YsGBhGZMe/o81p2gMySd8+hQHy+MrqVs3O7dlzMo2WTODrrZYskR/0ibdnvt+H1h+wuEEsDVVG7xiUYHtEAR2zwnvhpD9ajK8R3Ove8p71pZAEVLplqokP8rfl2w1M2SpSwZmEVK5Wcz3Qzqo95S52e6Ef1kigZqr5SryD9bKVQAmklTxaHw0VZBRyUK3vpXY2ypLHQRI4B++gA0CFXwCddJDbgUacqIq2CEEQ6dwLPUtfHTdCYLSuwXklKanucZ5yST9qYhrzhQf7nG0QYiTVLWwe+jITmKmi70CRnAv3ql0WnaXi6rPajoBkxHshvmkBPZ6E7V6auc9KDDLAXIT+6zcbLLEeVafyR3prGnoHX2kYvt0rFgDbMRSBvDL9uDMNxBy28mb4HVRwMsA0uRfXs6CGhkutcbG+lgd9gL6rHzYZI8lfDD2w59XiQj8xAzFEMoy22PSVjXEV+lXPl5/rfsNSPMt1cBxfVKLcm+/33Rcljmf6PwieJ/O/ZnSJJT9nESEWXgHfzt+nbvwYClrFaaW0UEXZba5lp5GhXvduHK9rJjylU5kGJKNRWptnN2hKmO1GpISiu4mikIfGPozBx5NdUb2txSrX9V8zu2Z
 yJenwWP2
 QJoQk91P90hWvhV9MECPxr7YZ5Cd7fNjjkgaiR/MqTwpUFYMOudoWgljIWHJsavy3KHM1gpjC6v8u4l57CNcSBUXcwrqXK9wjtgOBmyrn3MbcPIfLaoftA1++EGPGM8337zbRTFWvqD258HBFoW3Zw2M8VjVKT2bAzdYHlYJKELpYZ+yVELplGXXqvHzbmGqFqgmvqd8LfB4SwJRn9k7d1qvNtL3m12V4Ok+EkyXhiLL20o/OMfQ/yEEnsGSGdavMVeOqlLalQoAygeAuchSvoswEmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdamond_fn() main loop is finished, the function cancels all
remaining damon_call() requests and unset the damon_ctx->kdamond so that
API callers and API functions themselves can know the context is
terminated.  damon_call() adds the caller's request to the queue first.
After that, it shows if the kdamond of the damon_ctx is still running
(damon_ctx->kdamond is set).  Only if the kdamond is running,
damon_call() starts waiting for the kdamond's handling of the newly
added request.

The damon_call() requests registration and damon_ctx->kdamond unset are
protected by different mutexes, though.  Hence, damon_call() could race
with damon_ctx->kdamond unset, and result in deadlocks.

For example, let's suppose kdamond successfully finished the
damon_call() requests cancelling.  Right after that, damon_call() is
called for the context.  It registers the new request, and shows the
context is still running, because damon_ctx->kdamond unset is not yet
done.  Hence the damon_call() caller starts waiting for the handling of
the request.  However, the kdamond is already on the termination steps,
so it never handles the new request.  As a result, the damon_call()
caller threads infinitely waits.

Fix this by introducing another damon_ctx field, namely
call_controls_obsolete.  It is protected by the
damon_ctx->call_controls_lock, which protects damon_call() requests
registration.  Initialize (unset) it in kdamond_fn() before letting
damon_start() returns and set it just before the cancelling of remaining
damon_call() requests is executed.  damon_call() reads the obsolete
field under the lock and avoids adding a new request.

After this change, only requests that are guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no longer needed.  Remove it together.

Note that the deadlock will not happen when damon_call() is called for
repeat mode request.  In tis case, damon_call() returns instead of
waiting for the handling when the request registration succeeds and it
shows the kdamond is running.  However, if the request also has
dealloc_on_cancel, the request memory would be leaked.

The issue is found by sashiko [1].

[1] https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 45 ++++++++++++++-----------------------------
 2 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d9a3babbafc1..5129de70e7b7 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -818,6 +818,7 @@ struct damon_ctx {
 
 	/* lists of &struct damon_call_control */
 	struct list_head call_controls;
+	bool call_controls_obsolete;
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b..9bcda2765ac9 100644
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
@@ -1619,6 +1590,10 @@ static int damon_call_handle_inactive_ctx(
  * synchronization.  The return value of the function will be saved in
  * &damon_call_control->return_code.
  *
+ * Note that this function should be called only after damon_start() with the
+ * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
+ * wait.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
@@ -1629,10 +1604,12 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
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
@@ -2952,6 +2929,9 @@ static int kdamond_fn(void *data)
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = false;
+	mutex_unlock(&ctx->call_controls_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -3062,6 +3042,9 @@ static int kdamond_fn(void *data)
 	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = true;
+	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
-- 
2.47.3

