Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BA8109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B316B0115; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9166B0113; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754FE6B0116; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 632E86B0113
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DABCC1FFD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:58 +0000 (UTC)
X-FDA: 84570868956.03.9978AE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C18A1A0012
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5Y2AxTr;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJistnFWnDMgPen+vzENlGukE6NrPtXcqWX8OD67mjA=;
	b=Z8ofpeKuP+RdcxmjzbE4GNjHPhGW4gWa1MHWL+nn0b88asJgtlb61kzSwZDYz/YOxNdWSd
	DkdjwMnjZlS3Mr+lsuuy1Izv6z2GEWMD4dGJO+E2ImjNWmossFFtrb4271cUxn/4K++tYG
	sNL1WSC2YIFs11XcG/pV6Fe5DxJ5evM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5Y2AxTr;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116836; a=rsa-sha256;
	cv=none;
	b=TUDol5cyD1kit84lnGntQdj4k861YAynNovt+bHuV2orU7zfYTylXxtwWnRJuWQQTaL4wu
	FPmhmbjbABdo4sJlTHDhYRem7Rdh+EimmdZl3gq627FU5FjifWOryJDNhInQ0HD6A63D0G
	/OBzTP3E+wA9nF6Hvgikr9hetU9HVYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2FAD4459E;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746E5C2BCB0;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116834;
	bh=K+t0IBDIG7HXVVaXmRTS++wFYmoNTkKzAJmGYrkNPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5Y2AxTrErzC/xpyGbWB5GoD42Vw8CeZGe/2gyPns7E1U1BC+iY64/vTLl8YUlQKr
	 cR+xyVGy88+3waxenL8ziLiUq59Lg9Lvsu6j86YESfKJ+X9ubaqUBED+ZqiluXtOpQ
	 4VcKu5VO6xVElzO/rbz1iOlis13eHlq84r/E61kWKgqXQ2wm4tp6aDI8x6rrG3xZdv
	 msAL796o1mr5c6oVQfXkR8MZxvVeFefB0xl0fBce722EW3j7KPldwWvJpAdlrEYHtY
	 TGD9A9S/h/t850vTykm+24eILpHXnebB8Mk3bsWxHosET3IDSWr+WRIg49crE8NEGe
	 uLwFeUf18BsMA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/10] mm/damon/tests/core-kunit: test pause commitment
Date: Sat, 21 Mar 2026 11:13:36 -0700
Message-ID: <20260321181343.93971-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C18A1A0012
X-Rspamd-Server: rspam08
X-Stat-Signature: 43mckiu8hmhb3mc1xn7whqjzcmz4b34g
X-HE-Tag: 1774116836-246869
X-HE-Meta: U2FsdGVkX1/RPJAN5epwtpJk78tK7gjFu/IIAh5wp5vtkE3dd/J90FC844G2dr9qlF1WNAcDYzyX6rIM5oaXLp9/VLQfkYdEzvkj1wxBVj8jvn7Y5J88fW66MUwfOveNZHQc67B1JqvEOhSgxP4APs0eB92t0+c3HMfYMcDNJMhZWwXxzlL9L9unaQiJPtn81yCgIciteqLh+qiqy91HnNnixyB4M+XDd357qwt1GM6SbyxTTLtyx4q99bDZ77+lW1L7vB0nKO2zPFK2kQFo0nRszZZtFQOfVrQL4HWKcmu/fJVTRQ0yupLQ8+Tk0w0L8VEAv1349SLfCt8LvZVntezN/0WV1i1nDD8bBqDt22xUDYqFeDzzT6Zf9Q+IKLx9vvCdO9JWfIMpnohOfookDLMlxL4PnBU73aedoa3EYZPgkh/HV4AHPHuCauY0C8W5tKIVWEJ4wo66kAMYqZ/tnh++C65KOadMfkS8an7SAZUoHZ5ZknCncXUqxeI6laNLmIL5o1AYlkGVvKtf+C4NAiVy74YBfULDUbpZyOtxSAdjh6jm26FDsxRjocBOEk9OZmDoe7z4q8SUvLzK/NEDId1AuH9nLlQxp5WLrl2fCXKZ4C0XXAj5+WZ5lRVrAhH9ZjtvzzTdyNdEFRR1B0lNNjAuDni9d6fOazQ074B+xB5dbfL6a8/me7Dlhrin5srkBhUL4vwahjJz7oCrErAiYNL0CssRg0lxjubKShhO6yZksaX8BrohS3eHwgU0oPBf6UIf/GzpzzCT7q4iilQdvxHmGTwL75jUxCgjn3CqAORJgv6SgKton0/iYa6bFwdA6DJmGd3VTCnxNrRD/tUqDRi1bt1QYkFgARH6hUIhvaeM8zST9zNR9De9a0pT2xGbeTuh5Rz7GlZUgt1GcILa6dlKYQuXTgyW1PSBPtF90aRUnw9vwgJYwmFtSdOyXYL+3/91TOeQf6E5wF8+HSc
 +UTCSdeW
 OKmaPzIYgmz4CYdCdoFP8xlEE1A1E20YHazYu43tb7XYJoH4lDY9pVoMu17BVME3RK4fRo/PN5z7yfh9UFTUMbQidxNK77IdLEUdupg0ENvtVnlf185HIjcvOjJ4TA2Suazbv3FpIB1/KcOscemeQvzMRc6olTPDW0Sx2HScQkkP40L0CneXP7GYWauhQf+A8xMAhMuyon4M5gzdrGzNFSehqgllmf/qdG6T6PaTEi0jpVRo=
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

