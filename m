Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF25BCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F2B6B00B2; Tue,  9 Jun 2026 21:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1093D6B00B4; Tue,  9 Jun 2026 21:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12B36B00B5; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD7676B00B4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89ACC12085D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:32 +0000 (UTC)
X-FDA: 84862232784.13.9C91D4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 042B51C0009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWFMJfie;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDkQJtDgOrU4lvsYg1EkfO75V/KL21F3Sc45rqb1ccE=;
	b=l8nWKSsmDW4JAR+O5VW0jUTW+vjd6fw8ydjQtuLMI6swmA44ZXyaRg9JC7/PZt8HiMNMMF
	R6ENXO3H+Cso2tFMc4XX9+sGQGVsY8aFJ8DenR7NmlYFzqcXpBVRA8x4RefkzkHLUwXg/s
	4vCZEKauqFjmDOL+W3XukhQyiTQ31Bg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054071;
	b=P7a4wB5tQAa/jie9fve1SN/xKap/xFz2636EKd3t1eD1rqtqcbGEDJ5+plQMP7+R6g6TW5
	0rB/1R3vjQh8WMaj+aK6oQStEbKNGv5Q5VfMzN2GLPp5yziOtv/627Yc2S4r6/3wV0TY5o
	BjKveHafR0Qr6Z5RG/EWZedxIMQd/Pg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWFMJfie;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52CEB438C2;
	Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25D01F00893;
	Wed, 10 Jun 2026 01:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781054070;
	bh=EDkQJtDgOrU4lvsYg1EkfO75V/KL21F3Sc45rqb1ccE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWFMJfiegjFg0WXrcLnHcHfAA3zFD1ialmjAqXBok7YhTCANjdE7xYwGjiFGEOzk/
	 sGt3p52Spn+RwPkoS0ak/O0aeGudQNIYmBhFe+yZpPvyJGXtYffGTaL0mcL+PrCrl8
	 k183Z/1bcT1kGS1yoWauwpGqb4sQXXFKoRso0jsRomXbqeTMl857U97cInXWYY29Xr
	 V35de5vmNgRTscF4vEt1LBxQr60qMZLPcehklKgWGMECc+ezQFkM98Z+jLno46kEYr
	 Bw4EP83L37IVYTkgyRD3Gaw9YqsrkR5Irfs9qD5mCKpNTyN0y6b5QWbPvl5ee2c0uh
	 iyn9/m1NH3C/w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 3/4] samples/damon/mtier: handle damon_start() failure
Date: Tue,  9 Jun 2026 18:14:16 -0700
Message-ID: <20260610011420.3018-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610011420.3018-1-sj@kernel.org>
References: <20260610011420.3018-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 042B51C0009
X-Stat-Signature: dgt4jw3pyjwijw31efjouhptc6rnikd5
X-HE-Tag: 1781054070-124417
X-HE-Meta: U2FsdGVkX18WRCaKL+YXjEWJNyHTbyn+xfjYoZxcU0590SfABuS+JgmYj/0Xu6eicEgb0SlbUyUixRR0tsrb7vBOHD/GzDR+eBpm7t/wHvfwzv+8gyIiR68JKIUpd8PzBG5GHqRxQFe+grWTsuzvct3Sp+Ji6NSC79BAKBCTjNxmeLpoTD872f91TD1RUt+/V5d0N+hkY6aWXhqoYHjWP5AYDN2kqGzdXrggMPrFizv78D50NJ3LMnpzywWb4jVRfqFzBojxEx+1NR/dL5llX3WHrh5qUQGozXw24cd6Lk+LI+KEsTutL2DMiylXAJdoC1oyYXF4vjGBTK22rsSCal0JEPe6ByE8OyQvR6jyMUGVpcn7l7YpDqcX7KMk6YrivmJ6ne621mEKbYnWSo3T8C3uv8vkXBtXye8jYlDNqJYHTMmAPRrENyI1y271K8LtTsLr7vs8kYvgRvDwC9O2mFNr8lJTpSSRvK0NL8II9HXwDCLxt8EaUoS85qt2/2LwzU75SWRa9TzbMkIOcWb+dE/dP0uVFrdI2DrV+FvX5Os+v9RQRSTNPtwcG737EbOpLecVx/MxVfqSPB3JnnKEI5BZBuhDP356dtln7LwWqwo//i9ukNqrOlU3otak3A2aDBLIcmZET9pLgWa5ivaiTs+a2OwpByF+cHkm5vWswNdyG/39WCFRdMiMGxPTyQqIN996NRiTB1f+4jh25E/A6FZDVm5hDxfYTJaaWrEVaw9QvYqqcETYT08G0PzWroMvk1/g0XPZEAGg5x3OeLw6SjUTFxvD/AXHOrQZpQQK+Nf4P+9fXI6DiR2Ktla6az++ZMQwQD7lMoDsqrnjEi5jFRnbf/jJjx18pBYicjQk3Uuk8zjbidjmRJo+zQD3bi7tnYjapl1lHtCn4xEdK8Yfy8r7GXbANWFnb9zKxdFqfGjaLpfSi1is9nPZNcFGJHQzbufJl8eVhfWPAoGMOI8
 JvUei578
 ojXFS1S29ERWJANcf0iWseP/8BMrmINRADT5/aImvnkinOF5j4EXexSW2iGD39FD723/K/heqfOE1vEU6DKWg84BzWQOmfmg9y01x9XhBDzD5VhQRFeM5bs5ClJXBmP79Xgiko2ifvAH4t/jxiUZ4/HvQd4SYxTSsYXiv7jkqe76A5B3GWZteaG2KURtmj6yTATvxcRj3raMLQrUJshJ8qPiNEv5KJb+h2Ujwz9cP8raLv6ohzJzSU7FfhBjkjHQO61u81qHwJ4N63GIjkzqVrPuM9Q==
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

