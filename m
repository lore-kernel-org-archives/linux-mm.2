Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF81AC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341956B0096; Sun, 28 Jun 2026 17:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319BC6B0098; Sun, 28 Jun 2026 17:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256BC6B0099; Sun, 28 Jun 2026 17:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56506B0096
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68F581C6963
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:58 +0000 (UTC)
X-FDA: 84930677076.20.9A1252F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9F26A0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cLV6cNV3;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683696;
	b=xR3Z4SPOalie65SZpQ8vDNw0CNAq6nNgSx7ktTAYKPx4lxIhX81mRMr7x9rYrpaxCPCWZT
	zZEbRuvhzgrq4XGs3sBELqbKJ5XGb13KALVagPx0sM5r1h24CTSrOE3uoQNSzopspJRRyH
	U0RBDdLeZlSppsj2yleUIdEjjNO7QVk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZMAogVOdZfNtue3KEudF8E70M7L/5Zd6Peu2NziwDs=;
	b=IHvG/L8/G3keIRoD88lJ7CD1XtS0aL/4quvbegHcPwIZVxNWfBuQDJ+ea2q47pOaPLrZ2H
	+uzEdt8wTkpl/oe3lKTPLaSsvpklRvQP/yQ0BD6FBqg/USeS9GTZPyqgk1mLoXgAkfcMK0
	qf2RDqMEeaaPBUG6EZh7jEjgl+SjgVs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cLV6cNV3;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53321600AA;
	Sun, 28 Jun 2026 21:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A940B1F00A3E;
	Sun, 28 Jun 2026 21:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683696;
	bh=QZMAogVOdZfNtue3KEudF8E70M7L/5Zd6Peu2NziwDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLV6cNV3PqVhZlA2ArqlsSIoIOaJEWXbp6XNOQjnn8ybH4Te9MoId4aGWQAGLclWm
	 kNifkfr7OzbK+ydxLCDIy8AzIdP0CyHr8E2Au+fmlhSfa4O4maqqTzqYdu+7nIxs9V
	 OQzYMkCTkrhxbKDeN0AqI7iOsBI2k4hMZZRja0V1z0QKCGAB0m+zxEJ1mXfLtUR1bU
	 LaXgzM5/mSJ1uGt+KHjLdOAHdZdNIvWQROva5Rm4yOJ2q8WargXzZ1clwSFQX8o9qz
	 jfziukBNS8IKawoc4iar0Ry7cPDervjB36dMt1vG0PDVxTqHU1yquneKGtV/pc4DAv
	 gZj2YA39Tp80w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 6/6] samples/damon/prcl: stop and free damon ctx when damon_call() fails
Date: Sun, 28 Jun 2026 14:54:45 -0700
Message-ID: <20260628215447.96166-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fncf6phcrtf61wyruhoq1dzchq7897cn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B9F26A0003
X-HE-Tag: 1782683696-323360
X-HE-Meta: U2FsdGVkX1+MrRz4zx5Q63bttFrO1OZ3WRcB5Dvnf1R5ryE7CaOiWIsQCdvtJNQkNBjf7HzZlrV0kWfn+lJa+LiU8M2VY2neDxRW9EITaWiBhLZLTMQJW5TFv9O/qFuYBPU/Im89wo1k6fLQqwCHMrs88Rt7AQrk/O4ydHvEY/Rixsg2kgE7U9yagKEudV3ll5dWmRGt4OzLLMYvnGJtzz9bHy6LLcYciHBOPAJ1IFDe4bZLPe/3oymVvbN2jnhth6K83A6Sg2lX6ef6f8QAhXwm/Hj0uE/+p/x+06PCRy6B5z1nfvvSKkCrmBkjSCDyc/FGyzskW4B4J0Ph1l0KrvTAPnMUFlhcj5I4MCfiHxN9mN0kX0cWQLv+QEv1isxCZ4Trf+JODseoczN39qq2dBGPXZj8H9B2gUOk8cA/Rp6WQ0vwP7pga13/72CmbN+Kv6XdDDtecCV31XnfO5s3+7mMIHhQ6pjDVXN+2QTlXsSYsp96UD0/iuSJgU1EHoH/49lv4ELfFx91yQa1M4feLy8kg2x2pLWZh3e0cHVCmlyhoVBqpmpt/+8eq+T0y34bu137dB36XMQpQKyHD2c1RCnh8Qk1d8e9dSDnGz5mOUDxJeZ0j75BOCEPM9eBuB/JWyE32IZDgu4A7HOdtniQbEdfc4CvGf+A2QrqThhmmsLs0f5CzKWQkXAZNrHYxiCLIyuM+Sl6gcNuzeLSH+zGG9Mrl62NqQgAqMeQvNczVxovK5UHXXnPXzOSjbhGGrydqVNnxPM+rqJN38zVsKA5ApLosadClOrbIYL/PGvyoFyrCrSfqUYCOcPWIq3RqU5RI3hbfZm4n23gMIXmROTVT1P3yI02Qqw0m+nBJF/H84fkUwMje5wi/1yyxpAI9wpjh4nkgdcQs2muN1AuXajvXpTzr+V7buWadc+RS+PmlBz77Cv5W+sahTrjBbaJGk26YavapxgH46Tcaoj+XdX
 UNDD6X2I
 AgKatrmumxpoRf/+COYZBPGW5VKgadWm3Aiic9q1p6PWSYKCjTWAt/OwH1WoOynx8hXThqx/SKWwzjZzpJuDqu44DoabSlju+StPUqjLmjtntrLjN93NYh4MW+l874mFQMlO/hFX+rb2WjSF8He2Hk5f6pzWIDFNCKlzBSaw/RxIxR+YQGNiZ7iIiL/R+eJteq9tNGOa2QBbVnLYO9mQuEPXYnoQW9YSv9ayt7oF6YppDDQ3O/1bl/kcncUiBsMPcK3SjIkmZvrcAHdDputrd5vciGw==
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
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
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

