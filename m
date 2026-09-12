Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F4AC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25E06B00B4; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2646B00B9; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0146B00B6; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97AA96B00B5
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5821120593
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
X-FDA: 85206197370.01.6D4867F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 59E27C0003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojJaqsSm;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243704;
	b=sYw4B0Vjs0yIX+ZLl1xzxG3nYFrq2nYnRecw0awa/hbY00N8KwFlrrPIOvzofQxMOdg83Y
	DVHhCzHBCJPtYsaYsm6tqgZZ0VaR8Hk1v1560AL24rk/ppptxzFOA54xfu+3ebNGzW8c0X
	KZ/BtEZ/y7zYKjbHuMG/IVVOtlFabvQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojJaqsSm;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlghyvZVNP8/XL0yY4KLFntdcCcvr5Jln0kHwD1ylXY=;
	b=7eTzDbtGTCPmN48CnPgNcwCQ22INBIJXlwdv7ejzp+Rw09E5hVJMgZIv8MEJ7jMZ/BQoZv
	DCKh1A1zFIZB2ecTerO+KAxzuA2iTdhs4b3a1hx+sP8hWlzxWWtccl91dmfu+kN+SuEavP
	lXSM4kK5cGKt7jqmKYEFHJKnJNPFVF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A90FE40E4F;
	Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6456E1F00898;
	Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243703;
	bh=jlghyvZVNP8/XL0yY4KLFntdcCcvr5Jln0kHwD1ylXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojJaqsSm35JPnh3SwZ7uQ9wBPo68CoQtaBz99FqPU3hETd9okd3Wa/EAhAh9CE8X8
	 vUvqGTGcOKoqMVisbqQ+8Y2lBEdiGgkO2gIQ1eqXEg4qj579gOaCixglPUJkZfBPL2
	 5UXe5PapAxYJWbQHwx7XxFAYOT+li0mw9Y4eBsw/1rVXBnWO4M7UeVa2jnr46TRqHz
	 k0a5oBALMN93AWKBId4DIr0qpQWdof7CmQu73mWCL1M/7AZFTeyi+H958MVaDDhgDu
	 fJqcThaaLnhOGY2NZxi13bbsBIAWibTZ2cflakSq7EPPjltFY6a/bWOS+31c56Gl8D
	 H0LbzKxr3+OnA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/9] mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
Date: Sat, 12 Sep 2026 13:08:04 -0700
Message-ID: <20260912200814.145612-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59E27C0003
X-Stat-Signature: wffjt8miribi3miaht1n4k7juz6h343e
X-HE-Tag: 1789243704-87683
X-HE-Meta: U2FsdGVkX1+G+aSy5yxM7VTkIcLv/bFn1sfsIjvjx86V/JsoN4WVHWvuqxkujydiVecMm4lBWmwowooXtxGIRljmzG4ZTyV91nAnGz0BfN516eZCM8u/6BXvBRBfSnNP9/kHPCm5LheRI+/JWxN0DSLyqvJlM8HrBRNMoh8z7VSiLyUjY4LdaHl8MYyQe9KYcrEpbsMfaqETDg73utZxuDxP6n33PhDqv4fNk0fvRzS99t6QYNrp3FGwR+bZfIt1VM+EnY6Qd5Y4SMBhBwAuGe3ZpL3H2ysXknhr5Zgivv2GVzVa9E4vpBE7Ptwc0TkvSrXOqAFTEoBZD6kBB/6RKJT3t3zUnqCjweCUHc59eGa9QjW66qS+YQljMv1mPQS1nWj8gJRpbIOnoWQsooEAXNjzCjpRbTTBLPSmmwhsRidxjDcKFsh9M9Ab6XM1fw3Tz7V/0FujZPYRU977FtHD5PONIX0ndkhxJCkWGCwfJipHWVUW8hgBU2aSnuzp0kcTd5ji0M6jzWZyAz2iESRbFX0hgVaGA4XpYU7OIUz/SYfkatI7I7P19pjzEcz3q9Y/ShVi/WR9qIVH3DU6TtW3QJRXS7f0F0hvKKpkB7Rpqp7sgk7iMlVSyJ6YBMJo/EphDIPqBaqoqSnZ6HWa3xGQN2XM8DOx4uft7sOLFJZ8YvsK8c6WMsDZj4s+QgJMivJ8k0gToNvtZQJfKwAkRKyHYZFpgd+1dwTWxlJfplR/Hl6nfjpJY8SEie+Lwepxti/Dzsc2fM76tNN2Ih0i41jVucFLQFAJvJBabApB7xNsq1q5AvbdI5V7ZkwsUm/JqiIuFrWbyZNuxRqWnTRYDZ1mJmDieSalZZTdZGZG80zulDMlWcZVYGmNMKVaqkxgR2v37dRYwdDc92q6YgIlG6rcJBbimDY6ILu6p2zp/uNZEPzOP5j8aBZFwiRLpSplt76fPIqRKpfV/QHjFLru1SU
 MMj8jPNd
 DMoVCep+QLwDInari1//bIEvT2f1KCx6A3E8NVSMXtoI334v/vBGjPQ1+6CTTPF9rfv4o0azbYRCHA3vFYT1eFHipjRrSt8gWwxXWhbR24JwjtDgeryoJPizVwsH33m74W+lBxywOE4tSrSfB2TTMKPj1dX076izloGiNhhQ7p4FnZGCguUjfHpP7KpBRPsSRPKrzKcARXxyrJgulXGaM7Htfkes2qaRJjzOIxRIf0RbSorFxPiYTyHPnlZkOzeTWmYWVp4EZTEL9HgljCsUlY5qsGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_feed_loop_next_input() does its best effort overflow protection.
score_goal_diff is always smaller than goal (10,000).  Hence the
calculation can be replaced to use mult_frac() without concerning the
overflow.  Use mult_frac().

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 61bb25674cd23..cf10f6d725c19 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2921,11 +2921,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
 		return min_input;
 
 	score_goal_diff = abs_diff(score, goal);
-
-	if (last_input < ULONG_MAX / score_goal_diff)
-		compensation = last_input * score_goal_diff / goal;
-	else
-		compensation = last_input / goal * score_goal_diff;
+	compensation = mult_frac(last_input, score_goal_diff, goal);
 
 	if (over_achieving)
 		return max(last_input - compensation, min_input);
-- 
2.47.3

