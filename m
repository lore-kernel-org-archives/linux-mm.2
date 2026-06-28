Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80360C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983AD6B0095; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9348C6B0096; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849286B0098; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56DA66B0096
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA04D1A04E0
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:57 +0000 (UTC)
X-FDA: 84930677034.30.BE65B76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A41B4000A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIKOrHyB;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683696;
	b=AxLEX1VCmVio2iUKehxKMYjfqgec8vSWUGoJJUHYUDo9RKRkZ2idJgKvUKUEK5KqiX2qVT
	XKav0bwyp4L7o3BqCQPSUCbexnW1z4BL6qyM8MdX0zKqlVyWj0hEgUXHJyEwYlMh3v8u07
	aIhqOSorOEIE0FkhiBm3fmuJQ8R/tRc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zk+m+sDW42nDojjPEG5tIM5jKTMmO4VQ//ftyAMI5Y=;
	b=ViuBQI+dT/7HNiZ9I5AAIXTH9QQcwxKmsDu39HoxMINpdwKHOSSP5N+JRNHWIjH8s0MtFG
	RvTbm/5APfuKfIcMuJ7ZlFnMklHIgybua9V9n/2D8jFVcuIs/tp5ql6qUvXPf1AG9Fklpu
	hHYoFu/a6WvquSTGMKJD+lQZjSspBi0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIKOrHyB;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C90D43C81;
	Sun, 28 Jun 2026 21:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195A61F00A3D;
	Sun, 28 Jun 2026 21:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683695;
	bh=0zk+m+sDW42nDojjPEG5tIM5jKTMmO4VQ//ftyAMI5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIKOrHyBpox31ZVRgjjA3zukl1E6KLrTpfKB3z5CmMQQlGES4cPmTkgBTV+W+abaE
	 Yn3oPDhTvoexdatR0KdXmseFdWlErL5/gHW16OWxy3y+a3NYWcBub0xVFUhcL0R0Dz
	 YeLssf3oBdUFjmvmqMmCgLB+dr2Vn3mHyoJ/H8j+7uQoE9raMZNoQSxeK6xjizFAaG
	 mBK8gQHJaV6/LLpbDvZLqtRdC9qPHFWdDSv7FVdC+BE6l1s6fk2nN5qNTUF7461Gmi
	 CiVhScCKTtnDN28u4GPlXmrORxZ+MzyRjsrJZf9nw6Ew9nKOH3Fd9URF+2F4+IqITO
	 065ExZ5yeHuvQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 5/6] samples/damon/wsse: stop and free damon ctx when damon_call() fails
Date: Sun, 28 Jun 2026 14:54:44 -0700
Message-ID: <20260628215447.96166-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d4wjah6mrwu94wd5dihjckar8qcrtcyq
X-Rspamd-Queue-Id: 3A41B4000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782683696-764863
X-HE-Meta: U2FsdGVkX1+YP/sWZPpTni/fpwfRtU26qcXwPHi5GgDAN/M9rBez7n1cRfz41XwpNRATcyGC37XNKJMLQvvex0q7BkBf2E3MUyW9uqT1zncfn59zAAwXwdBES7W+Mbio2UwRNvmcOPR8KNiGY6q29lnkA8YynbwD2dzjt+wFsF7XD4v6JLX1imGO/L1cDNm2hGvb3XFaPtHbVycNwMHrB/UqmDZAsa6y37/xiZu/vf55uymTyVptsw1GibvzycvtI/PROJIYpJoVkr5Cn/JWQ34jw9t3vGDPdy6xEUPM/6Wt0pT4Azkd0GoW0ZB6vwbs5tlOlTGxJZ/Jsr5I9S2QdYd2tr8FwoTWu/FnhyJUyXsP+2pS3roqP/CWq4/Lnnm9I6l1h+3QM/Vyl0L/qOrabgSgFShijAIXmb8nmeaJWD8ZWMqlSFx/El3y6Vx3F7qOWR0KnyDiauMirijlkmgsLw5nEaWceaIoz3O8cStJ/+q5xsn/rXUB5hUc6nUKi8X9N1uh8E+frqqi3AAY+4hSum0QS2CpjblOwgPIixo1eAzCg+Yjdb4iAX6/Gne4qkNSkKNESKzvOIPXDaomaatOTm4C+4mBJ1XkXv8/16x8cFx5ETkdiJYJtYf9c2jSLuZx2BJVylIp5bixsMZzCbK1oDzyFoLoEAUb9O4mYXIyn3MFwl0U5eRAPk9ISgXS2GUJE2AWSjTAO9DQPncR5zbRLjr2Kb4PqMCJVOjrjP3O6NzmWYFxgRFSm92kgmxcG+QAb50YUIqQXnxLTtDjYbcP3b2wf59QhOOcP7LMISazOEH/ESLC8jTzD/YfO9TTJGWQgQUUOc1O3kFhFoB0thzeBVne6WG/BUC6oWbHJTG31JWvd179S6DcbTVJjRuzIF9uXBF7UL987fE5b+GL2zc5z6XSVmysxZAwFXKfd0h8KE6UEQ2O6HwILHyNv0S46kkH8NhE2M0dHpRx4TTwD+Z
 uvtx8KJh
 Zlcincl/tg1RHzvMnlkheZr/7AZ0WUfs7gc6BnlIDQLa4x4foDsKAyo+83Umpc3KKm5VSrS4g2JXrw20iJqtOZBaLEgorCIKEO2NqUtHVMNmCSJg2GJOP9VA9iaHSJ/1jQtZNkUSnYRRHPFy+kVRj3iuxuGYt6JW9g5wQ2pTWjJg2r2Lgjcy0yZjPXdrxaTG/5DK3Lm+tJS6096Il8b6CtWgLEwUI9+CWxwxwJbcxm8iN5L0RFqxEaQZK2fpzNIO7/tMzJTXZ0J1eXZYQr/79zZt3KC103FXLKsNB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_wsse_start() calls damon_call() right after damon_start()
is succeeded.  The kdamond that has started by the damon_start() could
be terminated by itself before or in the middle of the damon_call()
execution. There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_wsse_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_wsse_start() is called again, allocates a new DAMON context
object and overwrites the pointer for the previous object.  As a result,
the previous context object is leaked.

Safely stop the kdamond and deallocate the context object when the
failure is returned.  Note that the kdamond should be stopped first,
because damon_call() failure means not complete termination of the
kdamond but only the fact that the termination process has started.

The user impact shouldn't be that significant because the race is not
easy to happen, and only up to one DAMON context object can be leaked
per race.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260610034828.4632-1-sj@kernel.org

Fixes: cc9c1b8c205b ("samples/damon/wsse: use damon_call() repeat mode instead of damon_callback")
Cc: <stable@vger.kernel.org> # 6.17.x
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/wsse.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index bbd9392ab5b36..ff5e8a890f448 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -92,7 +92,12 @@ static int damon_sample_wsse_start(void)
 		return err;
 	}
 	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+	err = damon_call(ctx, &repeat_call_control);
+	if (err) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	return err;
 }
 
 static void damon_sample_wsse_stop(void)
-- 
2.47.3

