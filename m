Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91810FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E796B0095; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF90C6B009E; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAECF6B009D; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95E756B009B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4541E5B1D5
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:42 +0000 (UTC)
X-FDA: 84574154364.22.5E85FE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 96D232000C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PlVO6kot;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJistnFWnDMgPen+vzENlGukE6NrPtXcqWX8OD67mjA=;
	b=eEYDITe46U9ClDCBHFIQDR6adT4CP5hz+eUTwOvNyV9z1FVA2kaAwT8PB8Vcw4Cmm/mXMf
	JpLUTQjM/FyjKAuHoDagUOXX4nWYYIFzNyF9LaDZfqkrOgDXKE9U72IF6IyAAQDd3yM779
	IP/aeSMdZwnMwU6/xGulGZS8c5nNgVE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PlVO6kot;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195060; a=rsa-sha256;
	cv=none;
	b=f9b8PjdFI3Pbz6mLyl13KBbfIbB7zP1DyR5vfrjXbY+f7PKAZPTn7Z9k9L22mtJOYaj1Hl
	kkwtuXZ0IvMk4RMm97q5WoUl37tSGhiDih5hULjC55GU5sTkPD4UQX7BysQGZ/g0n/vUlI
	+3nPuggS6X0QyEW0QeGbYMzU4ePcR9k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C023D429CD;
	Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7B3C2BCC6;
	Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195059;
	bh=K+t0IBDIG7HXVVaXmRTS++wFYmoNTkKzAJmGYrkNPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlVO6kotRB2q3CldQyLv7KHE+7VPRz/p+DA8T7h7XuvebgwkB/YfZ4rc9uFFn+5oS
	 PKLtSA2r/hREk96rf+oI/aa1mAk+AX1KWX/omEpu9IUgVgcnCETMEy4GmC8fMD6veX
	 9JBirr7VSHWsinjEQOayzsxfzh5VpjhLhKVI2KDFWufdbPjr9RDjBaNqBZXwWdVDzh
	 AMRW7j26eB0SlesuJJ2L645Tx5uTtie1QrDCFOTSiM/xsab05ey902c5XtWT/PrMqf
	 Y5UqV94+HSqU7Pqz+NErvWwNHlNShJeJpdBcGKQGHjf/KILapzuWKlNvBuA3LOi9Cp
	 WquMcsL5okGXQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 06/10] mm/damon/tests/core-kunit: test pause commitment
Date: Sun, 22 Mar 2026 08:57:20 -0700
Message-ID: <20260322155728.81434-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96D232000C
X-Rspamd-Server: rspam07
X-Stat-Signature: bfszge1bpwsj4441ym9txqq1efjx6unt
X-Rspam-User: 
X-HE-Tag: 1774195060-234451
X-HE-Meta: U2FsdGVkX19cIXf9CDPPU/zHuUPQvCQS/48uS/+8Yq03A5HpdXx+HQUYeJSuO+5K9Q6MIvCRS+0YiYZHdDxoABeqV5oyovV9BjZjgFcpjfOROSC1r+dB5uqPZhCMPvaJD+nn2ocG+903GvCmXTT2hI+lvW5pMrGvDlxUpSlM0acILmfwFianF/7TMEjtjfv84X2jxtr5oXdmqojX6WZrqTwMFLm8nL4y5NfuhMqilY1lypaavrcVfLV+HQYTP77cwdQL2Pnl7kN23uZCcXz0r1eby2HAopU+ZluIsadXPn2Xq0j3Y3aBS2qBmXbfpEP4VBl/i68bo06O9Q3l6Wimc7H/9hn22tfwTNlgTvgIFOSN6lD5mY48tdg9SGzM1x7gG1dsmdEo4GW/JWax+6WmZ2jAQsMZRUGMtZqjimtlep5SkMTW5s3R9ct4iPLqSLl7PDt5W/u2szi8H6KTEpZJ2tUgqGofZzXB/5P4S1l1meDOym3Syus5CdjyNQSqgh2LeOLyHvzosTRIvseNKW93UKiJyVN4lssdJFOjf3LPJ03Z16GgENf/VxM9647qvC3CA7saOJim/y9BLbNGG9fffjqjRh0fuHGCfNArSsmwfLbLciVBoB9OixWd36IUmhiF/uXZFSbDJzIJjJpamPTW7lmbIm02uOfjLruJjoaYdLGQa0YLDYJEqmfYR23KNuQw1ci3f7akYaeTEHKT8oc6RwaxUaqC7wKKEUuNoTQVcdHZU8s79IAE6isR8VcuQuMJSm0QmIWzHAk4c+4KGemBhIXW3gCdJVrvz1STu0SGmMUfw69lGiu7EUzx3+YkmMf3cWTFkilti+IK5+xPChOSgtz+5oLwSV0E8EYtBSMNhgADucZwBwkvbkKNXiplbSO7ZlyFCbkUVWrvYVYcdqZtb73P9fdWovwZduvi93CWRucQwv2Ib/LcSXmSrOOE+dLzTyWH4kvDwcne+CZmc3P
 /0B/B7Zw
 i6XDUvPfKY7PnmMn0BIedaLgFHygy5nJro2Q2XzgHJP9JhAjgxpd3AgyWAN8bgnC0xuBCz0oLRp+e0cyYCKi5RP6/j3KI1uTOVZoHX0ZDS/SV4Ib20VVo12c3t1Iyy+s4P5b8+Cny0x7JWG9zlcTRlA7UtXr1n5cVp0D6uehj4puyUWrHHNYVl2BREtPeRIDrSeFefMt0lLy5OfVSLI7NAELGH934tuvF5KsVNY/2TX5R8p4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for commitment of damon_ctx->pause parameter that can
be done using damon_commit_ctx().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9e5904c2beeb2..0030f682b23b7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1077,6 +1077,10 @@ static void damon_test_commit_ctx(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
 	src->min_region_sz = 4095;
 	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	src->min_region_sz = 4096;
+	src->pause = true;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	KUNIT_EXPECT_TRUE(test, dst->pause);
 	damon_destroy_ctx(src);
 	damon_destroy_ctx(dst);
 }
-- 
2.47.3

