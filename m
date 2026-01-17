Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B720C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C296B0092; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0A46B0096; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED2E6B0092; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48CB16B0096
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2C98D1DBF
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:07 +0000 (UTC)
X-FDA: 84342202014.16.F65D05E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C2761C0010
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifXrQOLf;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EV0OdeiBmKQxOq6wbEZVmF2AnSpYVIUHcT3kUltyemc=;
	b=BujGcrWBJQ1FXPHBNTJoFHMqaREMWuVNy1bO8AhaPdKtG78BSzuuRdVwAySU81AL3GYX2q
	A50c2IvQAUQZWFbJl7jNzSwp4K8WQJ7sosgtnm2/HOz5RkVL1wo3xiTcYGcSDDTq9+1VpJ
	c4wb9L5TRARfCBljkosIJYkHncARygI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifXrQOLf;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672386; a=rsa-sha256;
	cv=none;
	b=KlPNchvHJ8T4A+tBFOJsqVE/Q90GYWmuUPGPPtyHYRy2b07J6yybRvnIC5Mdd+EFIQsDgc
	++R69AI9ErSN1rA+Vgz5G49m5XDkpUYGrd3HDdvdFyqAaddmyR1GsXCQYka717KYaPnY6y
	0dB6tjo4LSZNpqra2dNn7k0NtafDqXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7053D444F2;
	Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30628C4CEF7;
	Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672385;
	bh=VahmTvFk2dGc/ONa7UpYlxUiKSb/QYQK+lIo3yfJ+G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifXrQOLf5teMOEqaYYzrF0RAErBT5uPf5a3CvMwFrMrPZwREODTvdkpagpJoa4cc/
	 qh9vBxRvkgpvUVdl5eEf3RYIWXcNFgsSL3gtHw7AFl+aECUOQ9NEtQOlOcjhiMInoq
	 btOY2x+wHjYy9p1wNRSDsdpRgHDW2mFhIlOltZixLt9ArWBuxqiCRiyVXof4fiOFyg
	 KQA+maCXs2EDprxLbSkr+pI7tQl0X8sAsFeLpM0jv51WbPEE8CeIoeRkK2ta6xw5LV
	 aYTx0paCEOobXX3ahMcUBTMFtdX5Omhs6fZA/mESVDGYXSyQd/MlnjSabFvv2SA9cq
	 TcLcM4DzeWlGA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
Date: Sat, 17 Jan 2026 09:52:50 -0800
Message-ID: <20260117175256.82826-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C2761C0010
X-Stat-Signature: 63c6buquwdipu9xxcq9b5e3wwp8gd1r1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768672386-974968
X-HE-Meta: U2FsdGVkX191H/Kts7jf8CFejY0nD3pqftj8HdpJ6mS64l3HzLgLZr9MSU1ln5gblApZY7j6bk9aQhQJ58kTBYyUlGzpkFCsKPe1LvK++5duzWo3zp0CBzbiYd8OgsbQTktNez7oaQhhYNtxuHLTp3r/za9MU1y7RmLyHxlG4dCzQ20bqYImO5OJ2G3rKvtXLsY+2zMQId9INWivtGcQemRda8F8hBi+1KYYUqYrAaKjERx1YwKXuLehsTlGRZMgAUHIF58dikm5t1OqligKgYMPmPFLs7UzbsbAWKC6DItknL/kdS87ZpnFnaw7qQR9/n9L56rmpvtkn5XilfAsMHq3NLY0cQNqTO7AekFfxGTDC71Oou0+msvq2ShEV2cjYBaJ5/8G/0ylMZG/kG89M6Jx6sXPsZySqG0GYVWuRdQztzHxFxUTYxF0tDbg8dRP/k63gdU1IeR02VeH3ivSxzYbT9LEBLdG2ezDe+eQ8AHHMswHICJVuoBbBLqBxQHLTUxstu1ZiLkBMpIrCs7oyGwBtDlGcMiNGzY4+cBPr+7682a+8njRa2vo0TfvL2QHhRSqpcmvrWlL2j/pFk1lbNi8O8r7tDkqZ/YITckvR1Sdq2LwzAhsW1F/g2nZkTSKQhsyWEIqpGY8qvK7AsCiBKcqq7N3Fd0WdZKYAe4D8wkLL2wT5NcRbC4Fp+xJfItC+sa0UFaK6veUD91F/XCPQO7t41BOVZDgXUlq0EyDljvfCJgFP8vc8SKNoLE3Z1SiExZ1Sa99QJNwYQJZU/ZieN6Np1ZLctjwDOW8AjzvMyR+LpYuWgkMBGPM5tDBgJrVpYerFMkmUMLDBgvvYGwrrp8zDGvg7yNjkU/9gx0sRrnGnZv2pNUrvbMjHjAa0upSBRUM33Elw+QFZtwYQDBnkhBY7KsHYIwQInbel+H/aaGGLso+uK6BsSM/pF7H4qv3AGCZpgl9ZvWQBYwUtyd
 nWUBQf8R
 4pd6Mrg1QW9Ig9fih6JtA2GT0yvDuzd9t4tekGC9fRcbyhny7EagF5Eiy2kMLdUX9p2P1V9sZZmYXmqH5Z9h1iGjNXcN9FHFQSQ8mGowMJKzGgwN/CdMNodPBt0+Qs5CTBYq+E7EwnPLzzXE4rWbxY6lBF+l+D8gWS+BPdu3NMhIJmfTNSFSQFX9H4ERvgnrFOWA/u2XwPRNCVaheqp3SqkFk/7Kujgvphi1jcSoGv74MbcgLVch3v99RR/e8YVbLqs9GVVE/5eR8qCuAGhZGr1pbUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_walk() request is canceled after damon_ctx->kdamond is reset.
This can make weird situations where damon_is_running() returns false
but the DAMON context has the damos_walk() request linked.  There was a
similar situation for damon_call() requests handling [1], which _was_
able to cause a racy use-after-free bug.  Unlike the case of
damon_call(), because damos_walk() is always synchronously handled and
allows only single request at time, there is no such problematic race
cases.  But, keeping it as is could stem another subtle race condition
bug in future.

Avoid that by cancelling the requests before the ->kdamond reset.  Note
that this change also makes all damon_ctx dependent resource cleanups
consistently done before the damon_ctx->kdamond reset.

[1] https://lore.kernel.org/20251230014532.47563-1-sj@kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0c8ac11a49f9..0bed937b1dce 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2856,14 +2856,13 @@ static int kdamond_fn(void *data)
 
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
+	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	damos_walk_cancel(ctx);
-
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
-- 
2.47.3

