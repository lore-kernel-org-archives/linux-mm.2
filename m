Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AE1EE57CF
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 01:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD936B0088; Tue, 30 Dec 2025 20:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B036B0089; Tue, 30 Dec 2025 20:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C989C6B008A; Tue, 30 Dec 2025 20:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B74936B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:23:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D838C1AFF
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:23:29 +0000 (UTC)
X-FDA: 84278018538.25.2EBCDDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 13E441C0004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:23:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZDr5Mdb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767144208; a=rsa-sha256;
	cv=none;
	b=pUo1p0wumDy5Dusienc69Q9iJI/KIJpPiYvBs+9HbIHCfJMbKhOB7W5I29KuPKb/jjKy6H
	NRgOF9sr66Mjk8T/V9mJ0fcj/4V/dx9v8cfnghe1f3czS4U0/GlpBCsBAXte+BT6kv1OcR
	F190n0eRWzFHit86ZTnfONPZkdkHvXA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZDr5Mdb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767144208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uc8JUbvgbyMsDt4jxHxK/nU9serGQU8CcQ0sflHJONU=;
	b=cGF9IwI/77jfEsINn0tytnZkwh2OODNFEEHagViCYdXmGC8VzIvhLGN8ofMYT7OKslrMbs
	co37DHBmi/cLl1mRxVZsuYvOemAzFJXkGgPjXdoKiHAxX8OGVSJi15NKbVuTnvtyB1G0f2
	FmQLwgoWV9S3d8ZcKk9t6GGKYipGPzY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60B6C60008;
	Wed, 31 Dec 2025 01:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EA8C116C6;
	Wed, 31 Dec 2025 01:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767144207;
	bh=cPr24yWOpwCHZ2PhwbQIiSeRK6rZY21txfdeinfKsqU=;
	h=From:To:Cc:Subject:Date:From;
	b=kZDr5MdblqulROIXEsXlQbW0pIPFGnBEA2MovS3Lfru3y0iOhCe5PGKUMSxEtzBm9
	 z1B14uGovfWVsR3U088Mc+EJMA5ng5RF7LFBW9+DaJ7XW+TkyYV0Q02MaYmuL8ayN/
	 KMAGeD4drI0mTSdFNbY2DcbaObvw91GTjnQ7A2QKwZJ8RJ4V1s6ozJhnKEae8uUOY8
	 uM+Io4ZaG9ttvN8WuUiE6Uo32xJ+tUrJQiA03sR3kbwlN0I4imJme3xSDZLpLYot8S
	 Mc6Y/wtmLwLFLScKBVAUFf//31runMxSQXZoV9y1H1kSh2ql0CEuJW7NfoXf+4rniT
	 bqJlOlufbPDYA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	JaeJoon Jung <rgbi3307@gmail.com>
Subject: [PATCH v2] mm/damon/core: remove call_control in inactive contexts
Date: Tue, 30 Dec 2025 17:23:13 -0800
Message-ID: <20251231012315.75835-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13E441C0004
X-Stat-Signature: h9chq767cygonadzkr8g3utkpkdnf6ab
X-Rspam-User: 
X-HE-Tag: 1767144207-293253
X-HE-Meta: U2FsdGVkX1+wAECJcyHKMrV0Q+s9XC6azHDw1GSnEqjdKFz+ornBG/Yon3ZEJr6EqbW4CYSdDK0wSDM87gu6pAQGBPCys6qnVZHdrz8FeYs3ZHOWfbFUFL/l1nMzzEkqq7VD1J9xrx12YqZ9Z9lax9/SeqodA0icqjXFAufZFbmOeL5l75TSwYR31c/Jktq7MwPxL2O2OAXV75oae+yJx2etExOVSTL67rrqKnRMZEDldvh6/r8lDB2J/HMzTfYsOwLC8aEzBTOvpwkgTa8b+WNJgpi+AK3sUtPyXv5Dbz2NGyI5rpUFrvUawqEp633kV9VLf/VivvQ0kLp+DKeoqOfKsJ6QQSkbBtR9wR31tws2CJg3RuufUUxa2wMpVncIJpQh7yQFGpqzqWB6+5Ep6VZDd0ue4p5Odqu4G+DGz0bpDkex1Yy3YYbnZz4Kh/v/vCNfyZ/ryW1/6IMTC9SAG064eaRKYE0vQym0bxEcGuGgSIKapyHoVfbQqJ9R6fAnaxMLWsfeLU74i2pcvkE1KXbv4uFU8Gp/alz6uBQFwCHN9+iHTzP6WuurBiACEaeFZKa7Df2n+4mLMqPYLe7hAwBolHHhEzrPYvapqTuUSvP1yQWP80WWeZGFSrqYa9F/Z0QWFQtsDZxoclxMavFpIpzGBCzrmzqW0agusJnA42oFfNfaF4M73Oo/WZ5qPqFukHsX6IzYQYa7mOfFeRlaAC9AI/sf9MUCl8t3U6FOlDtQj+Tf2S1bmNMgHR1rvLc9hpzT26buJPpUzFCm2ot7gYTF9+VOoQtkELMQ595qIK1OWCKov0N76HZykVwxXyqGfYIxUt3vHL6vY/R3Pz29wch2NIQSTNObBgFKgR9O5RcKDHBYvffglVhjGg2W6aodN+pbz1JoLYzGyMEiRAPnBl8FB78DsBnOWcgwGrgfGP/ECEtfOLRZ0UTS5nPmvLfKt26kskVEli7Oi/Q+MMP
 zrhIMIo4
 Vl0ws
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If damon_call() is executed against a DAMON context that is not running,
the function returns error while keeping the damon_call_control object
linked to the context's call_controls list.  Let's suppose the object is
deallocated after the damon_call(), and yet another damon_call() is
executed against the same context.  The function tries to add the new
damon_call_control object to the call_controls list, which still has the
pointer to the previous damon_call_control object, which is deallocated.
As a result, use-after-free happens.

This can actually be triggered using the DAMON sysfs interface.  It is not
easily exploitable since it requires the sysfs write permission and making
a definitely weird file writes, though.  Please refer to the report for
more details about the issue reproduction steps.

Fix the issue by making two changes.  Firstly, move the final
kdamond_call() for cancelling all existing damon_call() requests from
terminating DAMON context to be done before the ctx->kdamond reset.
This makes any code that sees NULL ctx->kdamond can safely assume the
context may not access damon_call() requests anymore.  Secondly, let
damon_call() to cleanup the damon_call_control objects that were added
to the already-terminated DAMON context, before returning the error.

Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
(https://lkml.kernel.org/r/20251228183105.289441-1-sj@kernel.org):
- Do final kdamond_call() before ctx->kdamond reset.
- Fix Fixes: tag.

 mm/damon/core.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2d3e8006db50..199529dd7c66 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1442,6 +1442,35 @@ bool damon_is_running(struct damon_ctx *ctx)
 	return running;
 }
 
+/*
+ * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
+ *				      an inactive context.
+ * @ctx:	The inactive DAMON context.
+ * @control:	Control variable of the call request.
+ *
+ * This function is called in a case that @control is added to @ctx but @ctx is
+ * not running (inactive).  See if @ctx handled @control or not, and cleanup
+ * @control if it was not handled.
+ *
+ * Returns 0 if @control was handled by @ctx, negative error code otherwise.
+ */
+static int damon_call_handle_inactive_ctx(
+		struct damon_ctx *ctx, struct damon_call_control *control)
+{
+	struct damon_call_control *c;
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_for_each_entry(c, &ctx->call_controls, list) {
+		if (c == control) {
+			list_del(&control->list);
+			mutex_unlock(&ctx->call_controls_lock);
+			return -EINVAL;
+		}
+	}
+	mutex_unlock(&ctx->call_controls_lock);
+	return 0;
+}
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1472,7 +1501,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
-		return -EINVAL;
+		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);
@@ -2797,13 +2826,13 @@ static int kdamond_fn(void *data)
 	if (ctx->ops.cleanup)
 		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
+	kdamond_call(ctx, true);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
 	mutex_lock(&damon_lock);

base-commit: 40fd05d807b3a7678e3284b8a9a6cb89a32fa8ce
-- 
2.47.3

