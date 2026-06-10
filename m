Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C47CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4BD6B0098; Wed, 10 Jun 2026 09:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2760F6B0099; Wed, 10 Jun 2026 09:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D456B009B; Wed, 10 Jun 2026 09:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E812C6B0098
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:56:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AADDD14010B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:56:01 +0000 (UTC)
X-FDA: 84864151722.30.B50F4DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0787740006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcr15hwW;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4eyIQGc8+YbZ/+RebaJPmK558jLRcrZFCvASXPTF6k=;
	b=ockMUiBp15u8Ix6hOFLpmhXxz83lC/QQeQyJAAcr9urvwsDVU+5yH76kQf4Nin+Kzz1ome
	jqgC9Ei1amMAn8aPd4aTJoT5HO5Vs3ZzBPZV/4i6g2Vz55kwYkgfUv6D7IOCjTuwMA3/EF
	434NHHRsmx5eHYaiYlEsPjDTd8TWndE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099760;
	b=ocOC1B93VpLMLKPAKMZ2SWdWOEwTNRcYH6axNh+l6cc3irZHgpccYRrR11XGA3rhC0cUmN
	8smV6kYcy4a3uIkHmcgwrozrUC4ygJ2iNNytwnrKVN34ftgeR6T08ZjjOILB81m7FgKG6E
	TwyOV2Z+oP68Z7HhK8pa6KfufFCmdqY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcr15hwW;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48FE643481;
	Wed, 10 Jun 2026 13:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02171F0089A;
	Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099759;
	bh=Q4eyIQGc8+YbZ/+RebaJPmK558jLRcrZFCvASXPTF6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcr15hwWNAfWGBze970neza/Riie2JsT2EdEpr8fVGGSz/6GM2MidgoBinploF7aB
	 /mSVBSfQKFx0TXZi42o7h9jrs2eo4St4BNqW9RUHXl+SUJ6U8KWCskCFY7TQmuXUoi
	 HhQvD925TuFMndmRQsZy8rexLZgA5rUmcw+cp1Rm0SjTH267TO7xydap/4uw/zrgOb
	 ys7XestTmnfII6oJs+RE+lc7U4EocNkoxEMJKZ3KFayltTHMpk+Em8DkhmS9LmUeJ/
	 r5DkrntC04oRcE9ievA7cc5Wi1rranE237bxLJ04yUFDhAP2X6i74MW5Mea5FFg+vk
	 nuxRaNeekQP8A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 6/6] samples/damon/prcl: stop and free damon ctx when damon_call() fails
Date: Wed, 10 Jun 2026 06:55:44 -0700
Message-ID: <20260610135546.64943-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: <20260610135546.64943-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0787740006
X-Stat-Signature: 4kytuoqstxu6iga5sfy546x9kyxky6u7
X-HE-Tag: 1781099759-52931
X-HE-Meta: U2FsdGVkX1/X5f9rY4CFQFFd7OblZFEwJLaj8irZ9mqGUsN87rBvbG+PA1pYMXBcRusKHIZyVvdBgjM+CLs7eyBbBwdgsQmQG1QISzS3Wv/4BAKBGE8Gtx1qN6BtwVlOPb+IJ2ZSQDWoHD/n1gwlvBvOR1KT1jLQBNY06ZlieENvonrSnR2EtEDvPa+csT5avGtmGAhZHJTh7z/ZiMVtTRwlfi16StA3na+XP8s1cwcwCc/XCdO9+28u7XTQqc8K5RO37Q1cfoO2lOaLnVwhm0UVZrErB2g3WLUGikgCb/co9suYrg3NizgX9IK31S7jCeVfaZ1tnAP8PGccCwoXxh4+DZ7EQu5gqh1v4kbSVp4olQMsSNB8dyeX5lN8O7+aTPTb0xoFoO30D24VNVnqxiIBHuQ6GwYCv/975O//UY9u9E3B0vLiH7xFKPqHHzL2AvEUkdQ2RBRN5xOJywAoyOgw23DZCHeccn6TGTGAxbfpPpNNhyGOte+KfczgSxb+7apQEtVWRAp86nHWb8QqM22eeyAYJuo3oIsHNcbp68SaHUaCVE7itAbjyWb93gPRM3Iis7iwac6EtN4WUNJbxfRgS/CfnDgmT9RBxtD5u9Lx9px+cypYNN7o+pEbNKIuzKaNUQzcT3+by3VOgVEB6KX4a/xCXClvcF5feoH7Pf1O6zeECiFvgECj+n/cwdy9dkg2kTI1CJSEfvoYsjtlga5NzsaTN44l6jNkXcvCbHZFfoV83UfYvImrUZt7r/Zv2d4xp44OJ7RKWYb7DlFcvSonE8UNbp46kxIM4DEHI59EFLc5533FUh6aRjLteLkzkCLFJ3e/5x8vZ0djxyuDHpmRqrwOd7bxr2cHsdq2gMiyWV20B7TRN9g04dUWaY1tsM0+pZH7sTVyLGSF76BdhvNeMs2TVVytcA2EdrdENUefXyzjD5O5a0VVmNBaRrEZQXP9uKaKauEkFD2TRfl
 GauDdxxo
 ST+rRDqHsjosUqLVieHzsmNT+I++pZVpuToeF909DOc2p0tYSF2zI8MxOL/wb0L2i8SWHFEdUfLO6hWSj6pEuM9bwH98+i5mNLuXGltUGcm6PE4NlziVbiD7WDmbieameeTJbgoBTOQbufJY94H8Bex5IN60OvvT0knebcBZBNgFpBz9OJdyVGOdC9R8Y/kFTi4djcddpk2ilWYqJwcOJ4bOc5nCeN0Fo6K8cz1EVBcULmzXU7BRuQLa4vU0vwYzEXHADiX8mIkZdEeEYPrrHlu48bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_prcl_start() calls damon_call() right after damon_start()
is succeeded.  The kdamond that has started by the damon_start() could
be terminated by itself before or in the middle of the damon_call()
execution. There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_prcl_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_prcl_start() is called again, allocates a new DAMON context
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

[1] https://lore.kernel.org/20260610035214.4850-1-sj@kernel.org

Fixes: a6c33f1054e3 ("samples/damon/prcl: use damon_call() repeat mode instead of damon_callback")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/prcl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 0db2598946911..edeae145c4a8a 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -112,7 +112,12 @@ static int damon_sample_prcl_start(void)
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
 
 static void damon_sample_prcl_stop(void)
-- 
2.47.3

