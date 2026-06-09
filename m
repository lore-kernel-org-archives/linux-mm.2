Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C77CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97ABE6B0092; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BF56B0093; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C89B6B0096; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 703396B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 250C1A0584
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:21:25 +0000 (UTC)
X-FDA: 84860586930.08.0383ABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F9F44000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:21:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giNvD8gV;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDkQJtDgOrU4lvsYg1EkfO75V/KL21F3Sc45rqb1ccE=;
	b=mV0GUDDQKIkYsAlRFkuLM9zuIpIDmcrTkyIDcA2WzET7DIwGB9DE/dbj/8ss21Rl/vOf32
	7nwKsrvR6JUbakhaf9oS+9/5wVRswQrnI1/tcfOCfGOU2GzRVMn9uE6dzK15I28xrQT5TF
	XDvPQeo4TyEIIMRCINWj9LDq2htB6kI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giNvD8gV;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014883;
	b=pPdx3ia1flHZdbxu40/Y3+4sU5kdVoU96yp/95OAQrToRXJyVTaWhCUKL6H3mHGM6dY4Xp
	V+9/NaE8kZWBq8vS/RRFi64/z+XbNNqjDC4HeQNfUmxP34BvYEX0yeJlqxsITpsBNBeiNT
	ULBubxtwxS+OEYGn2llRFlTjMf0E2ec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D92DB601D6;
	Tue,  9 Jun 2026 14:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EA61F0089A;
	Tue,  9 Jun 2026 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014882;
	bh=EDkQJtDgOrU4lvsYg1EkfO75V/KL21F3Sc45rqb1ccE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giNvD8gVjuvzGCjAIf2P/Qv3EPIvKclX/DYD1jhbQQ4qRtkbifMFmt0QLzYvkfH8w
	 PUPLjQID5cRmhsDOlx9994Ds2YA9yHj7AXWZNC5LZkxmw4wA9LOKy600yAsD35X3eH
	 deIMo4lxIwb1+s6NCsmj8H2kWu0QUiuj0oQcm3Snrxv8g+y5WW5d2I9Dug3gICX6r6
	 WXlLyNB9ASN2vBJ0m/pfhUj7hbZIO/CexQ4DDCJEhNLJqM6P+5Y1CALRA9qPdEGZ2l
	 hxRQfibAbvAEqc3hyqmCkyBAlrU76cV0sb4dYvqwR0xAbHzK9giYepg+3uZPpxVNl6
	 zUkt0/hQYcWNw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/2] samples/damon/mtier: handle damon_start() failure
Date: Tue,  9 Jun 2026 07:21:16 -0700
Message-ID: <20260609142119.68120-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609142119.68120-1-sj@kernel.org>
References: <20260609142119.68120-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F9F44000B
X-Stat-Signature: j3dprhywe99me69cgmgo75szwqgnq1un
X-Rspam-User: 
X-HE-Tag: 1781014883-954848
X-HE-Meta: U2FsdGVkX1+ZsomBzf9ZR8nJZftgX32l0IYRLhoj2puGu9+0Vuqme00DLPl5sdNHwoV+xk5qdohVIvN9SYXGbYkcwoLbxEV6sXK+/BnStNWNBGQ2YUrawzP2C+K8ex767bF3Tj/UXFTu7mH/J0Ucv/QrmAtOpL7M+om4ZPOK6OwIN1wDxmgOOUcni2OBHiiK33/CGeRt7pz4DfHev/t5ssOW8Dzpn2Wto6wlVPzckIZAwvfkQ/zrLEAV8z5yOyUXUPC32oCkU7djtEV1WOlgQE/2pBB9KDyQlB3hGxGxtBTRxKYDYzpARh5Cczxb0jnbuDRxBPKIQXMVPMVPC0i1mnbLzbu2wUNlQCEgE4M5EAwFIgth+I1SLT+H3angSJtuWJbCAIqzz6UakxZxAQW2ZujAnSaVIoMVG/ttUueM2QJ89Ze8wxSD7PF9FlvUmbUhKFUZ29UTLFPfvEmlSvAfwtKH303nSHHm6SuxVJqG6iJx7ztvgXV64SwXDrBgM6dE/2AbJmrFYIBnt6FsL2IKlFVSIqPzV4tYGnWkQYVHjwkAMZWQ95XMhTGLHA/r3IE3YnScyZLGhJ2kUDD/bqLl3tregUCD+HTahbOOU0haXLizgr8PsOWKxUVbgY5UAkz1eQMwjKQkdx5b4zDa4nBiLiJVeYtA+lHXd+Ccj0gPylmwJ9SX2WqwozYo1aVUjuNKIuui07NGmGXQy0P5udgX1T/vizvvF/rQXk/sKPD/hcdI+Rv1qQW89I7BSZ8F2L7Jnh+DS2JRNlPVN8LAc7MI9JLkLtp0m6Wh3ROmdFGRq2H2ku9pj6YHq6AOcz8ZE1Ro8yfdvmfdIeb250wMefr6xWWrB2tj0dF/YUUQ4vcRdu5itzE4KvbIwsRhbMKKn29pNCX59LDX5ugnaIzDYR8fMLEvNwOdGPkWXl4Ur5Mrn+TxIrqB+Q4nzrSJLhnX//Osb15wC7xkCILr3nR7CQc
 I9ULUeGu
 bFaBSlAgJVcLbTlJ20zLmZEv7PQ36G2ayb1jux6vhFX2p3f/KR3pZCIo1myMIXWaL/oDx+jWTApX1xCYbxCaYu2OspdUY08Mq8Ldoc6L8RRWfuz8Qjlp7kZniBX8ND4VqZOzSDAfxzLJx/ncwi1rjGwCvb83tBfFJIixY2egoXKQJpx1UpQJ47Lqa+LbkOwFDhxlUfYSDhR209OSW6zvmTyqtRYGqTT7Xhwk/iEAgMCteFCyZDyYWL4Pq8d5P3lHFJOcZIcO1gRBJ0bfcrpIueLmsoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_start() callers assume it will clean up resources
when it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.

As a result, when damon_start() fails, it could leak the memory for
DAMON context.  Also, if damon_start() fails for only the second
context, the first context will indefinitely run, and avoid starting
other DAMON contexts since it is running in the exclusive mode.  Stop
possibly started DAMON context and free the contexts in case of the
failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo Y | sudo tee /sys/module/damon_sample_mtier/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the second
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the second
and the third commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index eb1143de8df17..66b591f2180fa 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -174,6 +174,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 static int damon_sample_mtier_start(void)
 {
 	struct damon_ctx *ctx;
+	int err;
 
 	ctx = damon_sample_mtier_build_ctx(true);
 	if (!ctx)
@@ -185,7 +186,15 @@ static int damon_sample_mtier_start(void)
 		return -ENOMEM;
 	}
 	ctxs[1] = ctx;
-	return damon_start(ctxs, 2, true);
+	err = damon_start(ctxs, 2, true);
+	if (!err)
+		return 0;
+
+	if (damon_is_running(ctxs[0]))
+		damon_stop(ctxs, 1);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+	return err;
 }
 
 static void damon_sample_mtier_stop(void)
-- 
2.47.3

