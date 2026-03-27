Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB4110ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A413A6B0099; Fri, 27 Mar 2026 10:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CE66B009B; Fri, 27 Mar 2026 10:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6473A6B009D; Fri, 27 Mar 2026 10:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 517E36B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:26:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A79C1A1112
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:12 +0000 (UTC)
X-FDA: 84592067784.11.C27D619
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78807140013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMthvpE8;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZrmY305Pk5Vh/286D0jZvfzIvFBws6zKkCIIruRWYI=;
	b=Jt4yAl3Im4i6XNmGz6aYiSSysPuX404ylpWeSw+XmFw3Z7RMBLPhNAXoEN+f1OWP5BVZI+
	uSDf64hyQnkRp0Ll3grYMa2ljpTt90UbPCON4fb4H02RTW1Mlu+rKOFRpsPu95wSYojYq5
	gxgpJV/6CtwNKUf3ai20E7WkaONcAYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621570; a=rsa-sha256;
	cv=none;
	b=Jxf4mWdadp/3dlj+i8bMf75CuUOhGeZuY0UevDKI9SyF6+4JIxMRb+lsdu0QggrcJWeW1t
	vkF5QsvfoCGo5XBX8VL6AN1M66SzzeitV0X/qMgszxHpmI1J7pMDF7QS6yT7Sza5g+ytwg
	98zQjGhMht7uVUS2rEyDdZfYdW8Bp9E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMthvpE8;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D19433E3;
	Fri, 27 Mar 2026 14:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8905C2BC87;
	Fri, 27 Mar 2026 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621569;
	bh=fLYAA+7Gdn0tj+igffgyllVKYLdoyYaeXXtFfb6nSaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMthvpE85U9ktoGypO5aXgVOvsiNnQJg6BI9xr8TjMrL4ZuOIQTDaAf4iEJeC8VaK
	 0HHSl+CT3tltOR8TSbcX0OhUQodvndaalZDPLP7PckFy1dHsIU3jUG/wMgBdcWA+bn
	 oBJiRV2jCeRmFCL7xMqo/Rjq0cJGtS7b8H+ydOWSUfEN6/Rr/WwUmjSvwqoVigVjUE
	 OUS8o8eZS50uvpGHQZIng7zUIk7o2ZDVHShxrZr/04q47nPVcVCA+ooLJ89c9PXqvl
	 Nm9xZZ6bcjcfxKdGuAgu9DxcJc8t+sB6VGnt7kR0qtjzpgEOERS9KyA08EG0YERP5/
	 amwTIbJxOsY7A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 1/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Fri, 27 Mar 2026 07:26:03 -0700
Message-ID: <20260327142605.4834-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327142605.4834-1-sj@kernel.org>
References: <20260327142605.4834-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wo8rphzgr5gcnwfyxrmj1z7pc9mc83gk
X-Rspamd-Queue-Id: 78807140013
X-Rspam-User: 
X-HE-Tag: 1774621570-211040
X-HE-Meta: U2FsdGVkX19RACRd7lzRpO82EN7Y5n8LUbEarh4CfBJ6X8YAaR7wZBJU9kM+tpnVxHlW3/8O2onQ9WDyI4KXRKA3FIAyhjIUfeNgVuTGJp+EgC5VbzXsFbX3/vCB7lcvaZ8PSG+j5b6KAso/HlXlUgUhoPXWuIiUffjEqTO98bFxODu1T7ptNqFGObqoqAs9McXQOAiF+rQFtxfjiFok7WTcN1OfBg+y73O9xCum65IDDzzGXpeSZf51PN5jrrqkz58SX99ozQOZou/l+60b4E7oh5HfF6rz+F35j4o/Q9pBZoH5QHc1ZrMsSw9ZfJNhNsupmfk6BcgS1kzNQYnITOibQXj3UoUXx5JcUPGVszbCiTOBpq0v0zGIjgwrr76AqQYIbj/Ce2b/J4tiwGzk5cxrR1HTLpBX+C1xZfydYFibEMKbvq+W4hAC7iToKRXBdCur+umMBxaCUwi2VNyXarLvkl8RjuIuJTkASxJJHRigpj0sPCs4F8M1yo6CAuf+fDevE6SvRXOqW+ZoCXqNBsnOMcVUJP1Nq+LLTRqnJ2YAccZU8e3zDrlLJlk3kV4CbAItv2GZ+3rlYJs54sN8HBghk3w42yJsSzTbJTXTbV6rD4trljnRjC3jOyCe9RdewCeecoZF1XBHgq7Opt1aVaQco3rUAlzeyNgCbxYMReofPsSzX3Tvxwjxip6m49WA9Rva8nJ1UeT+kJcwbmkPLma+KWU+n81JrYS5vn5LBCd5cse+kY/o3X4+EFBTTiy6/pcjC37wYF/4XCCdqZk8+CMpMJT2jPtFfXO68naVRv7Fjl+ZX3yJ9TLz+CeVeGmkubvXEEpcrymH0bMV6JsN4l1lMS2NGWpIHsYjUM8QxSv0eZYsjAM/2YIASh/Po7K5SIlrwoH9KFnRAJUpqmNvhJBFBMIN0CPG2MF4taEuK7GWOQ81FzJeXpJanYjGDIhM+uVOSUhlXbqsnQNSONC
 Yi94i32c
 GKB42
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

