Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B698CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166246B008A; Wed, 10 Jun 2026 09:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CA66B008C; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D998E6B0093; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C71226B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B3F312011E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
X-FDA: 84864151596.16.EC05975
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 041E620011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXfrmLYO;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099757;
	b=C2ezimXYBo8BQEK11tEIPGG0UBTz8uXHKQwhqV3OWU7Il8QpgHQ6uWkLPZbEKF32msjmJ1
	T+FeL+AOxZBYN5O4aMpkjPC8t9zLvUG6QAiNPO56DiMgTURFYdvwdd4G0uBIawkrqXutk8
	DgTsDKsVyoXkvSeVg0h0AVwKDLmYSsk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXfrmLYO;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pb0n/eJX1vGIeSAU0z6olfpVOoRIiAMjbL+eNzYDAJ0=;
	b=CNTzdcpZ4JfZDlOF6mV5D6Oa9dVuWDcKZ30a/mOAi0gnrqdCUscJxuP3c9gVCA6LQ1LrD/
	i4VRQQQH6khz8fzxnWuvPYhQFMxS+BgCI76h75wqrbCWhDJa85bbGXJLMMvqJa3SJritR8
	y8HbeX4Q7icKI/7F1YwZvWPYydmZcpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8278E601DC;
	Wed, 10 Jun 2026 13:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2F21F00899;
	Wed, 10 Jun 2026 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099756;
	bh=Pb0n/eJX1vGIeSAU0z6olfpVOoRIiAMjbL+eNzYDAJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXfrmLYOqHE7GlnSbLzF9j76SGDdJG8FioJpp/hd/WsjiulAP+5c98gzWJ+8390nX
	 IWDlDdIu8HAPtUtEh2CpbkJbyavK2f4/oly7AeMsks7CbQgbPPUWXkPBY8xhR8hLEx
	 15VrAQ7Y8xZcqeNgHa+ei3/mfAVjIk4LdFrq2kPZU81mH7NDSGub5BUj/oSdvet0m/
	 6yU2GE99gvinZ42v1Dth57vOUAgTPip2hnKF/u+uNHlZ4wa8kW9rucJ/ovxVDw+QfU
	 3iWjnLnmBSkk4cmxT+kz3KvD5ifbtKXTYRxIY4j+UWU/Y+b+hpEGkELVd7gYuMFmkV
	 P85dP2OpJOBmQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 1/6] samples/damon/wsse: handle damon_start() failure
Date: Wed, 10 Jun 2026 06:55:39 -0700
Message-ID: <20260610135546.64943-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: <20260610135546.64943-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 041E620011
X-Stat-Signature: x4picga61nd4rg46t6uy6nw93d43p56g
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781099756-712
X-HE-Meta: U2FsdGVkX18B3Cvc687kdVUf+r+CiYAT6nEnHex0mkFjZV0LC3lhX2uhavszhyuRBGDWXAhaQc4AAsHnQfsEYoDygcsMnz8wOEgrbHsVahuzMkRq4eIj9x46RjHSRv/fg3Iz9NuAJqqiTtL71wNOP8b4JCDsqqVs/CbB1GJITYOHE6A3QbudkJrxCTKTN2KuQSMamJZpqkVxS+mzZgSpjMXuk/YQIEXU2BWmFeIzj3aOMts5lT5PE0IvmQEnM/P6ZCSfZCbxX414ULK+bfQ68uLP2vj2rLwsJpY1YK5NaUfdVR3WdqdQv0dyFANx7zttYaaHTEr7axBG7T2V714Ugv5cqGw7RRlrLuzqqnZCSRw3mUGRITQrjcZw2gJ4m06UXreLxkC7gbzP2Jn/VQyEYw7QFUPmgmYSjXLVQl+vnb7/ramETHxatGlh4/PvaTSLtFF+Kf6tu9D7DyveFxEiQHlWanrnl7PKqldTQymrQiwzMry9p5m7uUxXDLsEFDf72r7hWpDoMJGuDubith0KtqVc9r1wuT5kLrlIdGSxREbnGz2vWFtBw1b7kjcvF0KC1NK5bvBM3I3Kpe5dFxNIbaoRXISwb1caGzR7+iHkZuh69mjTr+gqeWN8pE9xecB/BXP4/5CEan+jMBQqJL7hN2vfhEDTCowFbvLflE4L5mvURKl+QADU9I/vCxVVR90SVqGhCoN6llBjGyW7hz3l7/BXCLqqcy30W5YZBsW4rc5SCbRKrf7APoVFyiWZBf5O/O7w+lPcEqbno8rxsjcfvhNjq7ftzCLY2qoeWLeOCLYlD6F7sWCVW78syKWmR4+J8TbVRwcn+ekCO43u9uIIZfOpkxQ8TJ2DWNxvqlkVDIIeV2OVmp3f72N1BN2TSm+Wmv0F0KEqU+gQNOl8Mu0ABg7cy80DXQKCKHoT8QOHaXBAZp1NHAD40zF50xrJ8KqncqwMkY009TLguLyUgzz
 OEpu2+/S
 HqHylHepPegDbxbSovSLrCqD+ZGdVRP/3v/izLPCK1om2jekEJu0q9gXdMOF5lATu9tiB3SBykvgCAPnEOb27hH0fJr/+0QneeNOvNoELQtOgXM5EGaUCrCSlAxBlv/LP1Bdnso54sW0UkTv/Bpvzef5SwY1AElYuWKgAAmltMwyJmD95RE7BxIUAd90ALcvTcv5roqktEjh/Jx/lw6Eqc/kRTEXDuOrTuPvo0OlswG488N3DFLp38Wy/tPptqV6miULl4y5j9rNHbrtOI/+JDtjajg==
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
Signed-off-by: SeongJae Park <sj@kernel.org>
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

