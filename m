Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D182AC43602
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09BA6B0088; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA336B008A; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFBF6B0092; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72EC16B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB2B1404C3
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:55 +0000 (UTC)
X-FDA: 84930676950.12.3024B33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 49B4840003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKTtMy9Y;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683694;
	b=OzHDd+Rmq78LccKgxUIEn5Zt2myLmMoUEctxv/3N0+ks92Ao4tDFtvqLTZZi3lS/Q2EBmS
	ych310V0XEQlg7JI4mNXHvhLR7LwZT16pWMarcx4V7G9dr3H2MmVXqPZger1nvkc9ua40o
	N62K0STP7DutsgGrMuOhEi66RWyh+fs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LhATUSGD9m/hcobL+nNhDihLIC7y6gv8GROPInzLpc=;
	b=ShxT3TF7lE6zZwR8iwPo2jZ0xiwisoKAGyvSIN9eE8GL62crYdLzC4ZKym8KzIpOWDjqJ3
	GBSf1k+RkO7R6ImfjbY/MLdY0SpnZa5Cei6/QfV0SmNn1pGO+1N1p7uJCq0tcvnPQ+mrZF
	z8/IthnM+mvFTm5IqGV5KURuLmPRVIk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKTtMy9Y;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C58A160052;
	Sun, 28 Jun 2026 21:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BCD1F00A3D;
	Sun, 28 Jun 2026 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683693;
	bh=6LhATUSGD9m/hcobL+nNhDihLIC7y6gv8GROPInzLpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKTtMy9YQwzoIIXw6bWxoHKkXepftHvlvWAIKn640TsyYsJnqSFrUaNega3+rheZh
	 limtahpHqTOS5bSRny8jkRsw6FRXXEaF0+3ARkqAQp68Yt9xSAfbQkx7Ur1f0vwHJ8
	 kIyp8fJvw1lwqp4LUuLQwT71qZFS0DtIIzZwmQlI9Rpoalvj0zdSsEaWN3gnACFGwV
	 0g4cNSE24Sgw59JlmeMKrfdpOzrcJeVEIVYsmNkBNMy6nEpsXDX4v1Vpd74PPynpDf
	 rFL1e0++Il5f8P8CiCZPV1SiXr3RSwnOFSkxS3xeEZLC5Jy8cnQCILeXQv4m5WqsNP
	 2zOUYL4N4PG1w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 1/6] samples/damon/wsse: handle damon_start() failure
Date: Sun, 28 Jun 2026 14:54:40 -0700
Message-ID: <20260628215447.96166-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8zyrttya1fa88gum5i8qjppyeywzx3k9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49B4840003
X-HE-Tag: 1782683694-863280
X-HE-Meta: U2FsdGVkX18Ix+cmLJ6tTeCHm0QywLJGz+tDvcY2hkZFhMMzDre4G5i7NoJqfYszNKCywYfowdN6BGgsAyyoQDkf7AzmeAyWPtF4fYibyjFKnPRQjP8KJqKSwYKuc8Bv7KyQKo1DmmjRKUGEq7ZyA0dV0b6kl4Wiyi9OzSoqHEautgX3JqLEjJVWtHkINgYpPJg2TbXp8WH0pXMas7I+zZ/oUx8ny5SpWg4nzXwfWJ3QIeU0yfZSLsEYVcP9mCxI1FJ3JC2yUf7YrrCdCOtcO3OhyEG0b0Tne7ax87Tu/I55V6YozRKVVQgWF3asQ0pCuoZnlqwLJdLUfKKQplPT+1hCUuJ0mzOD2MwAC/pPBBU3qwsxYnsRsdms0AMYX4JTXlwtE8dv53T6PB68knEA+bMcZrAh66WtwqL0s2MJ11Igl3bO2s+zgE14HJ8peJzIYko7qnt8dZJrAHCWHZAl5CnObKMTMiWlScioRv+E9z+/XcZkRnJ57eOlTmWa7g6FIDzYApf9NtrnmDRLNeuizOlMQWQ2kPJddV3xaJ2ZcEx9GebK/SGfLEGYjlycoCi9CErUPkpNO5bmjvi503GIsvtSrOmS0Q1vojlYXz2TJVoO6ZncECSy2AzQ+qR+patuLG9XbOxL4BH8xmz+1dG6QA3KW4iHLuV1mXSlw9yy05hlJ8DjA5uerI6hIjpvtYnxN7HYn1Y3Y6sbxPLPi79Lh2TzknjrVz85UQC17OeRwyr6qyeBMu9hEbOom5aO16bfZTLu1XCsEQv7vQSEWh+zYdGyd3xDoR0N/sOSHGMHCQdJZiDU5S167fpIYfZe4cqi0RgfPGsHXjS0kj4/3Ssaa/q0mVP9dMWdKXvBgL5zQKM7KSLMPJhmQ5VjAsq4DHJzAmsGe4qHtioLIbLc7VA9YMoh2DNBkNcHaFhNpqMAJg3Zxm4hVaKcWDzNa6BIiAAOsX8uv8P+sUBe23piXGq
 TEUXNU2a
 0naB5DA4j0huICQ+wd2YmaPgtTkPbFlzkpCJ1EDeskVOkV0xm54hdrWAN48s/vuMrNCNtd5pDupms9U/FE4iYo1jQzPBvQvgkq6K9LLzGu9suRAALNUZF/c3GeftzQP0YuH948Jg7PnJ16VBaMdMwXmhXpjcWOOVDRc1Ctx+3YM2yiVz1Krj079aiqBEC7PbZZmDn3dLjyc/lrdunySBVZ4p2FHRnCyDNATw2i/XW2qD5pHB8uvvRC2gaqCq/3ycOFvtCxQIwld/Bjfdk388Nd5BVOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_wsse_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.  As a result, when damon_start() fails, it leaks the memory for
DAMON context.  Free the context in case of the failure to fix the
issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_wsse/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_wsse/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the third
and the fourth commands above, we can show the memory consumption is
only increasing due to the leaks.  It requires the sudo permission
though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org

Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Cc: <stable@vger.kernel.org> # 6.14.x
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/wsse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 799ad44439434..bbd9392ab5b36 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -87,8 +87,10 @@ static int damon_sample_wsse_start(void)
 	target->pid = target_pidp;
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);
 }
-- 
2.47.3

