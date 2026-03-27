Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E3410AB837
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305346B0005; Thu, 26 Mar 2026 20:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6BB6B0089; Thu, 26 Mar 2026 20:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC5B6B008C; Thu, 26 Mar 2026 20:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2A26B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:49:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F443C4889
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:49:57 +0000 (UTC)
X-FDA: 84590010834.04.7B52AC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B51380007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:49:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fXvYVPXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774572596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jgKhZtxyviEEP0c/k1t3P25JYRE1FTE+2ng1LnAjnfw=;
	b=ULfJAiAlMFtr1++wL30mTKdbVN3JKjW+YQZQtu7vhmzsQTyr/55R3XO2EVjkfrynsf0Hbs
	XWnXmXCIFXPyiKkhZYnwQDoJljyywlunL9lild/khTkp1fTcSAQ5rTq0gsQhZ1ZtIdH/go
	U3/KX+qvKm/u+3Uzv/6f7AB+SWE2Hes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774572596; a=rsa-sha256;
	cv=none;
	b=X9K1PdcCc+uKqFx5mJOSwVLd6A1WSao3O/8LXSgwFIqJsU1j9vcOG86NTSADNwY7hpjQla
	kJlbDicYemN0LnUSN9a53Ll4oaboNpjoRNIebAwMgPbRDNeOs0MSyKe0KrxFQS1gP9noCI
	mEU53WeVO1hSBk0E0DSV1yugxl+RUrw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fXvYVPXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02A9F417DD;
	Fri, 27 Mar 2026 00:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87F4C116C6;
	Fri, 27 Mar 2026 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774572594;
	bh=v2ytZre0hctDpszcbcqLcBzEhOlj7hZ5jEoUksm0I7Q=;
	h=From:To:Cc:Subject:Date:From;
	b=fXvYVPXHy2TM1GE27qw8sqseNe+LQ1FDwsxdtQDQq1ipjO6hPU9EWJUAkjrb2N1Y/
	 YslVJ8Dw6K8dLTEI0f1DCxOZttuChn4SqU0Zl9ZrdBAx10BTeB845ImvYUI0/pt39Z
	 ZW82HZ+c7LuXM+e/iZPn4lzVg7/je/umDJXLwKLw7LvWQoE/BghJtkqu1Vwz3jrM/C
	 C70txyu4PdUq4dJpGrfSkwWKmw+sXaFCzBs16gylVIKCjOEM0cyTBHt2lpr3tyW95x
	 fYP6l2iiHc+gPwyZkiQqsjMQ4AYc4U99mZCLhH1qq0MlZPJ/lxe0evrSCwWjHCNpaK
	 JarTwIVFAi3Ng==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 17:49:51 -0700
Message-ID: <20260327004952.58266-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B51380007
X-Stat-Signature: zfw6nmhiwjz1podthubaa7sicc4kf9t6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774572595-64822
X-HE-Meta: U2FsdGVkX1/9qdc2D1fSJDTWlN/CVu4c8XMpcQMktzyINXBE82GK9bpnWNoY8iFLGrNIpWB56awv5uHc3XEtiXooQlTlyX/o9gwF0DoKGhK5d4cCYIma01ztJEFFj3Apqq4zE6BJ+Q2j1rmHJE24tNPYurtsbABKr84sgwLyv8y5PG+/j6+5Kw7EHWdtw2eVw1PQBz0bGbjn5giFpZITO88sLWxGNSLMqYdd17k1uanU+2eBk6cGbBIriWhmmA52wy/9JC68yCay0f+wuZZcO1U7btK99FALrWDJqy0P6/k+df/JDt+ItYA+vdHucDBOA2hVnddixq+A+0n1E8vOu/eRz3NqqwhqrHvW9ALpkIoXSRpIKlK8D+5k/P+yGbZYEa8QKbm8mYNIooMIFFRGaybQ+ucMvnApqnyPmOC/LoUl6wIaMjX3Sqo4D/I40El6NwOgYUM5fCHpJQWAn52QtQ/NJUvAIoZ+WF5Ok6Mz8LZVrUFkozR5jN0veOZi9BXkpWdurnbTotokoUgSMQ7AxLo2vVQhY8Be45w+/GNwCn3OH01ktXrkDE3Is47kLJmmgW2ziw67jKf/NrwWYVjV+wHXQ97dgfqDxJcMxZTO6rLurUvDuBd3XlmAUD0LJND2eZPhCVaEtWKWkvxfb8tOtCFsjPX3KgnG16RGoctG8mlKoM7SNjCwsG2/gjiMZ4R1SX6cCls/nMIle8FjGQf38rqK0nZU5OlvK7Iww5CztE0CYv0f1XMF5oruzVq0IB38JyYt29zaRj/M+fX0au3ulAZnN88LLXxZYZMcqpjfFQBh34c2QNYABhSN4Q4MT6pOm0V9VkLK4BxhCfNMRreYmyk+319+svFpE/S6JHrKTL+3qLlzRAWUaCkjRe644TH+umUMBtUUUaUtYHcNdmtX4GTgtnm06/JzXc+89xSUv74ofdVH3Mrnrui1DT4FTrQqng6sZ7rY78M0nD595cw
 oTiL8ywY
 75E1TO+317tAyOpHZvoAbwLH+/PPjO84UPV0FJ2x5I0izVcoRYjHnsVhwcngH31H1EtwGyGhJOot0Mjeucs7jDu9H1jyZUp9Mg0slU98AaPLgiModxDzCdYn/xkZ074eGSEQ7x4/r5VGsYIWOcDe5ENweiTSH/qtrbcvRjGZ2Hg9UbWGlpGfPDxfjmVPICqRd7r09F2T8ucidqQNWEQMmFLsdeXQP6e5H/mMgAU4yggOhAgsqBI0xAe3RbLqSVLA3ZruXJHf8BNtQ58ziaO3VhCpQ9w==
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
kdamond of the damon_ctx is still running (damon_ctx->kdamond is set).
Only if the kdamond is running, damon_call() starts waiting for the
kdamond's handling of the newly added request.

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
damon_ctx->call_controls_lock, which protects damon_call() registration.
Initialize (unset) it in kdamond_init_ctx() and set it just before the
cancelling of remaining damon_call() is executed.  damon_call() reads
the obsolete field under the lock and avoids adding a new request.

After this change, only requests that are guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no longer needed.  Remove it together.

The issue is found by sashiko [1].

[1] https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v1
(https://lore.kernel.org/20260326062347.88569-3-sj@kernel.org)
- Clarify damon_call() call condition.
- Init call_controls_obsolete before kdamond_started completion.
- Wordsmith commit message.

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
index db6c67e52d2b..1e8fce6a2a96 100644
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
+ * @ctx has succeed.  Otherwise, this function could fall into an indefinite
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
 

base-commit: 871ee9fc2ebebaa1fa26d4a266ebdf36252b53cf
-- 
2.47.3

