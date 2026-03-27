Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9347410ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277576B0098; Fri, 27 Mar 2026 10:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228A86B0099; Fri, 27 Mar 2026 10:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A926B009B; Fri, 27 Mar 2026 10:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5D196B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:26:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8C9CE179B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:11 +0000 (UTC)
X-FDA: 84592067742.29.D3DFD7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 155A840010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fcgKr2Jd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621570; a=rsa-sha256;
	cv=none;
	b=hhaeeZpDF9PCfvVFZ0NuUzk7ZU5PCvKeFo9UjRqm48Cpk9h4msTYLQcfc0lafeuT3hIaJN
	pOG995FwVbALlvIm4bCrc0m8J4ISa8NhOJmCTsHn+pLBNSAniMUotPNyeRbbiDHXdmgC2t
	6mdnn3drqVPalMRzh080sPl/wnges4o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fcgKr2Jd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6eqzgmnXA3CSoC+763dPb/VEVXzgXSP476z2CSvtvak=;
	b=QyldL+qqCAZOSDjm68YLSL6T/7lfEURm19kR24a/amrT65lkYEK+S+LY/bYzAtWbZzD69b
	F3W0xMBmGjRabuhAd/oWTKJBL5oq/vxQCXxJb9iwV6aX9gYB5fTC7b2N1KxVlMUkVkMbyK
	VRHu7l7uT2afQBNogrZhcZsGYoRhDcQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A26060123;
	Fri, 27 Mar 2026 14:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CE0C2BCB1;
	Fri, 27 Mar 2026 14:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621569;
	bh=SCd2raDJ8Tg1kT/fyAOHvNUkzbrdRCMrZxN6B+WI2i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcgKr2Jdfpp+obg1pcYwgv7gcq6LSa2j8dHOp/UGYYyBGWeL/4Oy98++Uy2DochQR
	 fY5lzjhHGEXZL4rVfE/q1PEJDdc+BjJXU5pEcIEzmBxb2a5GxqQRF/J4WA4YE383XN
	 zZVjw2dl3C/3kZSanuK7tgMyjONr55Qeu1HuKOqbXmtMOHXDXuR2RuJ8i7pxTQDPUf
	 n2sQyScqDLgdDDz6E15tH46NWFy+In64svJMOfHX7N/968DjRqEqv3JGDdu2hpA6TF
	 SdXXLia6mvcaFdyHlCQsqMeq7YAI1OJ75d31+h3rWm1ksKljGCLbOFSO0+NgqZCB84
	 SBlLbeI8scQsw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 2/2] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race deadlock
Date: Fri, 27 Mar 2026 07:26:04 -0700
Message-ID: <20260327142605.4834-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327142605.4834-1-sj@kernel.org>
References: <20260327142605.4834-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 155A840010
X-Stat-Signature: 6m5rwu1ekg17em1x5kbyj5enotusqh47
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774621569-270664
X-HE-Meta: U2FsdGVkX1++utx9Sj3l/86CimuYaPTR9GQPf1IedopBVCBGYBvgN/zS42bq9zAcY/ZD8drrdRPm8c6xgfjlIjjLHXVkvrQLdlGvKt7w2/FzS3XMo2zDKb0fBAZoq9DushiCL3/Q4apqbG1flVsedP7adBAbMo/ChCZ8aQkMikX83Mr/rx2Qdkaz/SgcuMfELUfeVe1Ls8DonatiUvx+3BryXaOK2OEzg8/hN3DS5YQx+ivhpp27rAlKI8MEkah/7xZAj/ex4IoTUn/cixG1cBts+X8ch+CTt0w7Tx66OCthUHf3R64xMk7KTAtE0OZ+EgXmXuoVz8Y1ah4KrGBzVGyNj1E/IyNNBxY8LgfWWrXuNy69kh9qeqpIn90/KK6qWaGoGDgDlK15/mD1yRNj9VGOCLWa+sIKPjuoWo9uY1wnvJDR3LlxjJuXftAc7zPKt4EQoMKWRi36vyaIUTt1vscJR49YE1UQb8Ed6lwUUD2H/yZ9ZX2mYcRCMKRp2R76w4vQE+Cj4fuS2XHmbEppBIairZSCh1CxjeRE6ENbTjR07pJAk1TeylkOk2pnwm94M4ceaSA5bkxNhDl+QxSQ1HrYS/BUIFz/mjSOXRSSKpxIG7YJkREK4dqBr6d+ldbZsQpw65a88ckxR51W6rrcbTjTfFGt79j6+PnTW1bBJNdHL8lB9cjaqWN82dwxFoek4Pjc9xUz9bkU1bDq8Hgcp6l1b4LB/B/LxrryfHogXViXRJbHism4/S0DYjwlOvMO0sNuZTcWJkRl8Rz+hxH6Vmkm6pTtQX4hW4mVSeb8R5+2/6dfcZfkURO+8KxHOtqFQ8KGc8ohIrtnTfwH07m6xliLGNDYSITVRMZPeMJrJG91YcB24xs+Y/IxP/qKepK8dLfNfDM6plq68u4wPMPh2S05CerXTSke+p/EwugJnP5Iju7lUZuSDxJ2EiIWMC4q/QrpzeJCyyyZE+5ln8y
 XsyKEwWa
 1si5Z1TI2Yez8Yn04lnRFzgi5HjhHrxNW1J0S8uX0tVDVeXdmMRF5hiyuy5d8HL37Vcokbykg8y4xx/W5EWwgu4D1hbtQTuggz3EcpelOC24hhplrT3MZl4Fk0u5DHvu7Q2gU8xPl9kFCfb1L2Q/MKaP+BxmSOawPp9uQVu+c3W2s0WPcku+1PV+cvIzWLrAFn421x5bZh6WvRsnsFuBU0lC37w473YLB89MSKa2RbwFcCagVUcqxy9lmWrZRi6hjlV6wDRDhdD1wu5+lwgk6kwZ4tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdamond_fn() main loop is finished, the function cancels remaining
damos_walk() request and unset the damon_ctx->kdamond so that API
callers can show the context is terminated.  damos_walk() adds the
caller's request to the queue first.  After that, it shows if the
kdamond of the damon_ctx is still running (damon_ctx->kdamond is set).
Only if the kdamond is running, damos_walk() starts waiting for the
kdamond's handling of the newly added request.

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

