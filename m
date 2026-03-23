Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE02D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698496B0089; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3617D6B008A; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250C76B008C; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE136B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD7EE8D1EB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
X-FDA: 84578887050.29.372B4A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2A1E714000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cCv48XIw;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93eYcEZ0RPiKQmcbKpNe487BEt7ILXQLopraIrnVLNY=;
	b=sXzFjUVJQspAmQRa1a1dRZmQlqFZqQwoSYC2ZACf8a7S71EecCQ3avITvN3E3n3oa2UHY7
	q4tb+Bip5vZf7rqcp+8G0gR6jtVzqnyHd5XEGuiH4E+O63gfoPdnBTZYm+xLV9nImCKjJn
	0wNj60zG2N0qGRWuh3ajFKCDSm2/Ly8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cCv48XIw;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307744; a=rsa-sha256;
	cv=none;
	b=oMqcOBjKU12Q959oaCAt058vIkBzno49FZ4BuFv91eSdp4EW8CwB12XLz8A0aVv90Y8Sva
	lV5i8BXwA/wwFMY6abjcDHxcxDd/G5FEsMYgmCgMuQOyvtutCbpwqzCJrlFxTaKOeHL1y0
	sUV0rVLtQb+G364znzLdvSamylC3tyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2290C442EA;
	Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3770C2BCB4;
	Mon, 23 Mar 2026 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307742;
	bh=R+OyX+2+xXzYOPMk7hH5cT/Fo0kVRBRvE8hVSDn6Zoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCv48XIwG2VlpoTnqISMydw2TQW4JBJcbUbw+yjZ4YTzn8104rOdhJHZhNTAcj1+q
	 j/LiMTkFRVcSeEv9EdxiNdCUTQmpJgxxWHyz26hkzY+ZeoEd0IqBp7ddKtGuW5N4tS
	 BhHlj69mZp0t/YaRMHikJFeUTcMBSTjBhNl6eJlYtafVwas4ARPOr7E0ghwUjlW7Mc
	 QREBRETQAe2S92uvisW9m7M2RFUoEIqBYOj0AnVb92NRZ7yx6I6fTPlIf+4f1oARIX
	 8v7sU19F9gup3RsNgg3LFT4Zylaq+ztdvOxKFqyyBCdeaJrKMZwfcNgnLUWs9alNoB
	 +4QCmXgXaNEcA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Mon, 23 Mar 2026 16:15:26 -0700
Message-ID: <20260323231538.84452-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A1E714000A
X-Stat-Signature: kf67cbp4qm5bqhbd6wbjykesecpk15za
X-Rspamd-Server: rspam06
X-HE-Tag: 1774307743-5204
X-HE-Meta: U2FsdGVkX19NWSutkPM+iatvJhnt/I3fWkXF5fwRlV03myQm8/sd/gsHIrNQiCxwMzSPt6ddXYdJEJkT6WtrQyEbs4zgkcY4o8tLF+RbJ9rdw+XNIOWb2Mjqk1MSodd1pIsJxRbfM+aJ4zDMQ8l8OYHgxJdhWwJIV7NA435GJdAXqt/GfoCJKM5uJq22OpTpcIlTtjPOmFXG9iMYufZN7xgUzvXhByGN9rqLvye0Zc8qYOGDYemkM9weZHI7fgVqyFwSULKpmrF38eE1LWVvpJw4vSjfu8znt8b7Rba22BPAO5NSItGcRze7WxnirK9Gy+M2kgVH3jf6syK+6C+eVrt6apc6WlahtUb6EiHppIlIJGUwkLcfs0jGrNI6YJmrbNf1ztROpcfOF8+VM2tTnDKtVECszBMtTRmzl9DlX7k92eoCFv8H6adnmEEjk6IuBYb3JzQnRq20+Nx2y/NOsunaRTUvRKH0trbvvJS4HaKnRaox6T7wjw7haUiGdbyOucnLS7gn98AGeC3hzjbzTt+hphcKUDcWUYG4gKzd9i16sgFWHQShGGGe7w5keI15cyCdZm7bYmsODovP3bwFv8diL7DxEIUIUIigulTf0omnPrjc5wiYaCwVPlGqZy5b8x1xTeNxsVZcZXqGHZC8xA9tpTnIlsKXEqOxdMe2byT+wTb5o8q85xOCrgTSQsQEqxxpBJcz9MSiEPiWZA/dRwUa5EJSuUyz633vV95ptJu/40Am7sCZvI8E3P0ucJwpGfVxW7SulSRGTXLVJR3MpNJxjLirfyXPnJT7yUKzGbDBEixaCAMjmHSKOdv74QrmFuAwLze4d2q8WkfpZWLjnJgGKC2jk9MU497W16GQuZLL+K+6qNtswWBiIuN8wu3r0nCf80PIIV3cWVGeYNLpCY9uF0YsilfC8wl6nj+v0MGfbF20wDNf8SjgSKkMw+6Q9TcyEQt88cSB42bzaD3
 vwjaD3z6
 jjQncian92dnxLao+UERZzEhnvFLEOOQRAQ3b02mqhkYD8lR/Wq6QZHx5LfmdEm75lEKUoA27AjOqbuFtiI0ZxhhbmsU+eCLcq6uc7MpjMS1PpK/cdUzl8TX9IeU82nSTLO+JEEg6tXGkN56MEKSz+ByurO6sLd6mN8z8/9/f+3hw1+SslRxoIUyoU4Y5GPqmpvrh2hq9+VScUukRI9gWjjg3tCAH3jx115i8rysjpsZNBkwuuhh/9u7vBc30aLmu5cM+39+wbeID1IcfAg3cBJbOeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON supports only start and stop of the execution.  When it is
stopped, its internal data that it self-trained goes away.  It will be
useful if the execution can be paused and resumed with the previous
self-trained data.

Introduce per-context API parameter, 'paused', for the purpose.  The
parameter can be set and unset while DAMON is running and paused, using
the online parameters commit helper functions (damon_commit_ctx() and
damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
only limited works with sampling interval sleep during the works.  The
limited works include the handling of the online parameters update, so
that users can unset the 'pause' and resume the execution when they
want.  It also keep checking DAMON stop conditions and handling of it,
so that DAMON can be stopped while paused if needed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 04c8a052fcfbe..65c8d5ef510fe 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -787,6 +787,7 @@ struct damon_attrs {
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
+ * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -838,6 +839,7 @@ struct damon_ctx {
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
+	bool pause;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b8..0ab2cfa848e69 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1349,6 +1349,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
 		kdamond_call(ctx, false);
 		if (ctx->maybe_corrupted)
 			break;
+		while (ctx->pause) {
+			damos_walk_cancel(ctx);
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
+				goto done;
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
-- 
2.47.3

