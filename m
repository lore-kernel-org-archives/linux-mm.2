Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC815CD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8236B00B6; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994FE6B00B3; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C11D6B00B5; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63D556B00B3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00EC4A07D4
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:31 +0000 (UTC)
X-FDA: 84862232742.13.6E2EED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63D8EC000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KPVH1/wu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hjcTwQxd/8erExTfvC7SkLcmq65ZXVC4ot5zMsJvgk=;
	b=U7Ugp7lmSjpyxfpbdqqJoh3QXgl7lVcFSYaXAld5K3YnlNMT14/d62PREJwAETjswM0Gwl
	Mrd3tzc3Fs6HCBZE6ZE0EbZcetZFbEMFFeEScN9jNoDF070FBrhE9j19cMIKoTHL7AVYQu
	sm0hnIiQbNyyMc3VZtLa4OBM5A0Vx+0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KPVH1/wu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054070;
	b=sREj+JfzS1a+8fHkadRKHjVglWh9RLI36/JsqwwYKkbpVsV/iSJxj1iDyUneRXv0aUgoze
	AjQ13rOS5QtftrDoygm//d0X9zxLF5wB5ed6KRNtg8US8Yv9igDtKERLP7EJr2OrjfMJx2
	5E2VFqkW2MhFONuURaAz07m3eNPHNLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B460C41913;
	Wed, 10 Jun 2026 01:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2F01F0089A;
	Wed, 10 Jun 2026 01:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781054069;
	bh=4hjcTwQxd/8erExTfvC7SkLcmq65ZXVC4ot5zMsJvgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPVH1/wuZX1pKNk89xoBpd5zJ4L3zLJ6DX7e/G8/BVJ4ne460wFdrrw0wKwKdqosB
	 IFyOFC4pKAvH1KZRY2aS54e+NX3EEy1puz18Hr1rwh0gyeRs3htZIvSGWxBZTlNMvG
	 VnNTzhBj9RU/mOK+AO1zTWkeaCd8FHylf2FnfV2NbgAvJvwdtXkVid4Onz6ieWciH2
	 pFXiEivi+usJKLFHbGL4iPgIWbd8JNo5Vdf/qbvQ0FkTxhoSqyDlQB/gvrwArEd7Ix
	 6It4QjR8iTRe5MY1uC8mcMOxi6glGKHJkTR9ODqnHr1Jz7RDN8eGKn0/wGg6P7iGSa
	 t+uMSLL2iifZw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 2/4] samples/damon/prcl: handle damon_start() failure
Date: Tue,  9 Jun 2026 18:14:15 -0700
Message-ID: <20260610011420.3018-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610011420.3018-1-sj@kernel.org>
References: <20260610011420.3018-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 7qckszhy3yj6uhz4axhu13pbead7x6m8
X-Rspamd-Queue-Id: 63D8EC000C
X-HE-Tag: 1781054070-52556
X-HE-Meta: U2FsdGVkX19dK/a7h2tRPbiqdPSd6nB5oj3RElp4v2qTJpPiVRFI9g7mTSQPyiER1L6jlSLgeOX1kIrGnQ9Dl/xNJVxL+qynZbhycQeuIWV3H2wt/peEDwrkSZO+/sp2bHdtLIUmWPDv4hvkWV7UjLKfe/cTrU+Wd3KLeAP/7Ekbvx6LhEDoGOROhWRQp+VCqonlc/LlLqhbDLVtLQyXZBsUvxnPQeehAfiOS38IfsNzikRw8dBcXquu/eWrdlHaUllta4brOY1bavAiDe2SrNDOHj040O9HqKIQn5CijcG/jeoHi+nWtoMCKV5qdakcJPLCbr2omTQXhy/JkBYGJQp/ANsvKNQ0ByP6tzi3PIh7Huz84uQc8NljSNgoZFMVJXr/Sqa8TzV5rcjxLo+kWtpBEkH62Xvtpj6OkoljVy6lgqGLjBFn4/G/STU5zDg7Dm6b8Re93t0Vrm6YHBE92Q7qzu8YhzH1Xkv0KcB+/whb6jDimdstV8uTxyp7I7OPyhn8WxzCCapyXH6bZRjzVSb/PtPMtTzTADyj3/MMl4GABzJ/sZy3f8mkumi9bOewGNsPG1qmZmB81E0+CH9cKi8Jwbx8S3aTUU5enMSje8xPHQs3f/mWG+eQ3gSWZmLvykIyuk35jCL6p4E/Xh1ix/KxwIFVL1CZ88pHrRu2g6hT8q7u8+wVjY72EoonYF5JsZYbPEnzDcDcUeSPmTMS2bMTh4OiAhd9+ctku6WT3WxpAIvVanQdpTlh1v1+GKXfuI044aTavbI+QPffH8k1/MVgXBYT6aFDpw5QBaZHEax2ZsXAj/HEoT8pRZvUVQjDOX3NoC60aYvJ53MJtyW6kvtA+m2a56DpNOB/F+euE3y1uTIg/bWlwN4M17fr2nJHaQN8Riu6XjcyXyemQLwfhB4xDdz0K2hvbpV1w+v5XnfMhhtRL0pk5AbsvwkwpZC8wA9gBfN/xdwPXod48C/
 75NYURWt
 elrDwD0W1+0uvdWGj9E4OMqtnhYoATd26fe60TvF3XEoXPmlXPNwWyR3hIy9Q2rNGXKnq0qMuB5vYHUGHIXA6+huFqWxMUROEaRKbXSD8XwJPKZT+l76taf4NYjigQvxOM3SRwYOcgzXmun/EM76gNqNg6wD0yqtme86muIYcNDFuB6VtIHgTtfj+9mngJ5CX0RYKAYu7tmtcTZQNwVtDpzGI6IcmBb7cguL142oQZmmnF9j6GUmNeYEXUpB40mqPFdJfrS8ju/tiQlrIcuNfx8j/EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_prcl_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.  As a result, when damon_start() fails, it leaks the memory for
DAMON context.  Free the context in case of the failure to fix the
issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_prcl/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_prcl/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the third
and the fourth commands above, we can show the memory consumption is
only increasing due to the leaks.  It requires the sudo permission
though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org

Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/prcl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index b7c50f2656ce7..0db2598946911 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -106,8 +106,10 @@ static int damon_sample_prcl_start(void)
 	damon_set_schemes(ctx, &scheme, 1);
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);
-- 
2.47.3

