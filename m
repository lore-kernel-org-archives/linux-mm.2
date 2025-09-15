Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D87CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C1E8E000C; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427D68E000B; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DAD8E000C; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16A818E000B
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9E7D58CF2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:18 +0000 (UTC)
X-FDA: 83889824676.24.8C9B33F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19994140006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LZ/a/13l";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+St7/AleCHhAQAespUrE1tvHNwdZXMFCB4woky125So=;
	b=OtvjSfwoqMr4n1U+TuNuX1modf8OjsFrOzlVO9O49xfj0q01SpOWPowYStJcuAi32VVn2q
	T7B6s0B3N3q0UStXaJWcnGukWwFKcAN35RZMOqgttRzFdBG5v/MQ68j7IxFA0gpR4vcmfi
	Dfp7erUjUiHFZkCSrRobYVnJsEsuqkI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LZ/a/13l";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901497; a=rsa-sha256;
	cv=none;
	b=J0GkgogUL2aV2oxonx79EwGRKeYQFx2byBdk+i6F4n10nELqB5MLTILh68dREBnk0KYYcr
	4D7l7CFyA8svYw4YQHcYYLxaktFqkR+/fe+wYNEKCygnXmKWKu5JqyvNp68Ufnazk/1c0W
	srVnRgCRFG8kID56tX6bDllpxbbC4QA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD03C44401;
	Mon, 15 Sep 2025 01:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD88C4CEF0;
	Mon, 15 Sep 2025 01:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757901495;
	bh=nGvVrC45Vt9+6E5tO/9Zsq1bOPvFtQ8UtnVHJOeO4A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ/a/13l/K1JrCtefJnoQGLam5FR90aUMxEBXcPo0pELUkzQl4QrS7ftW9oXrJLi8
	 pWAoUwc0TlelI102Agga97Ef8ZDzF7aVSKqyMeeQ5KDOFGcHD9+Y7U7U0dtR/BJdGV
	 crJbVH/nQ6DMcg9zGbuj9W7O0t9Fq2yHw6CWkQ89jdo7rIzA1XjE7eksYZoKEDdSqX
	 WmIX0rW+eVn26eQKBvwXJTbgDvjGGXgmRIrkjf8iBNKvI7cVlBJtlTHhiSeH5Y4cG/
	 Wk0LxcLfvHmZQ3ZRmSAWcnXxWjfu868XaqaR8H4K8JmqVUQBPyPJrsWJkesyatSjw+
	 jxS1ZjVbZ5kaw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/6] mm/damon/lru_sort: use param_ctx correctly
Date: Sun, 14 Sep 2025 18:58:04 -0700
Message-Id: <20250915015807.101505-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915015807.101505-1-sj@kernel.org>
References: <20250915015807.101505-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19994140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: z5ctmjdhkkzcrwngj7aozc8u8xc88q3m
X-HE-Tag: 1757901496-521433
X-HE-Meta: U2FsdGVkX185TPErH0oJoeOq7MTaorCRLRAOiY2/7+GrpSLTI3+Se30F4t5Bd0yHMFyWIii8AyI27JNmu3s/1JsawkGjeF+LyE3k074nRjb1hOOyNDGv8Yt78r/KuchCpVb7CTq/6IuO7mu8Xo8e9BbgfttZRgv1oeelWUfLCnKEfDKQyM9whEcXan5WdkwwK4lolfQKohKy5zLjYndHe+OSp3u+mAXyi9xgzKLCDhjPtQ3jTOhq/e75aYXgXgIWpfE/iqO7qvHfCCePgWNGRiW0ucZFNC1ANPTAX5H3Lie7RM5DjHtjjPO6/Gq/oODA1JZJ2oiNTgKHtsPW0uBII+Lnol8v3ak9jxuquqNWhavBYbv/wEWeY9DfjEBWN52+DYlx9Q5vvy4d6OGw8lhPk9GeeCvhfutLKSB1UykBA5qwpjbm091Wht4wAa/dqVHwAJhBlyW9pIntJ0jv3DfhIr6Ofl9PjqNX4BGGl6nvc/n6pZzpKn47+hHJ/DDe04/wpEIZNOihkLLEQZvVV3dJkwten5BGNYsMasPWWp3FGCWNzeBqXEuq1TB0QlyhGDbihqP/+KVo1WGSUbKWuzfWXVULZf4PRFjDdz8ls+2YEOzWDjmaWWNvRTrtrbKUi31F8b79d2qphx5BN1obAvubmp9/Wl8y5bzviu3FVrd20FXMEmBZWqAM1Sgysaj3J0d6qCHhk1CgRoZYAG5OjFtbNsvTEOm1PrBWcOASvZowZQC6SBuFtoy2bQZH0crFrpCb90L9MLRto49dV8qXyYeQwIwSH6lGxxCfaOF98CzB1jnah5M+LKH9W2+lwS6lpcak8ipanebZe2jGDOLgkt8MD/go0zhLvxYPNlSJNs0tmE7uu6DFgc/i9bB06j8ECAnfHqwhRuANcgDj2EghxU07qKcvpXnP+SQVzdnnJgKEDcErTb+1CtWYDiTMyEAmR+UngA7nKXvz7Wj5sfQVzcK
 pGJ5B3ho
 AuDTbND4AQLBEZ1qmPU2KYMfKha+GIxSdcj9dJqikIy/icJPu6MtZVDKEOcnde5cdfb2VByFic/+5DhI7xfmHAwiW1alB0TObN0d73neoKwTIQcZ3QuvQPj4EbFwgtqPGt/zv/0vlleMfXYMhaF5xGimQSlaM24SUM2+1bQUKvvcA41v7jIRSIdA0ZiM3kUu9ngajiKy04u+q0tw6Dh0R42slYRZwY8u4tODZFKxeHchv2g4vTUmvqamGcKGoEIg4kW8Fy2QOxg3OhdiqD2FwG9KACQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is, however,
directly updating the monitoring attributes of the running context. This
doesn't cause a real user problem but apparently this is an
unintentional mistake that can cause code review confusions and future
real problems.  Fix the wrong use of the parameter context.

Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 14d31009c09e..ab6173a646bd 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -219,7 +219,7 @@ static int damon_lru_sort_apply_parameters(void)
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
 
-- 
2.39.5

