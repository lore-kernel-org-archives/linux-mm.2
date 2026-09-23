Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D17C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA2E6B00A0; Wed, 23 Sep 2026 06:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46AB56B00A1; Wed, 23 Sep 2026 06:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A73F6B00A2; Wed, 23 Sep 2026 06:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171B16B00A0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CDCBA6B32
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:13 +0000 (UTC)
X-FDA: 85244619306.07.6F105B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 03ECF40008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnImGiUN;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7YELTFQNH7j9BvemS3D+5shFIScXDKY2I62M6OGUww=;
	b=BcZOuafHr/G/i64mwpOZCLkjwUJTSRzG1bZIvVbf2LUV6Apc454UMcArizh2ddR5ehYChf
	kQqeyAASLD5Sh3BN5ow91vTI3FmgIjOZEs8bNX8Qw25VWcTITEWJ1oQHG6dKtYSGngMk8O
	0XBOsUWnrbOYWz8SQlgTDyasBHN3CYA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UnImGiUN;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158512;
	b=rgjCyqCX4HGcbu/7804fiJfqh0zlHlR88KP7EsvJLzlvz7nk8ASoNEX2soRI8+4AEz80rw
	XJEvj3JJQdf1v26w99Qj7hg3Uwsq3rqksauj38+1JUOpilTIv9kUCBbY9xYwquZLqKRzja
	iCqRhA0P4defNwotjFmTeUv3FFBEgK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A41140E59;
	Wed, 23 Sep 2026 10:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA431F0089A;
	Wed, 23 Sep 2026 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158511;
	bh=k7YELTFQNH7j9BvemS3D+5shFIScXDKY2I62M6OGUww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnImGiUN2/myjs8Neflq48mmgdjZYYc4VUBwwh2d5bAoxr1jP23mCfwMS147zHAm8
	 9RfCTWuUfbGB0E20WzRr1BQs3W2SnLuaQ6+Hm8athKeteLLdgCwOZjNxh7aHwlWR+C
	 OV+DejIdfvd2tlhLIKviB67wyTwKopviC3Flv1Keae97Q6obY0leVmd5hdIjQG6jRV
	 7ZB/VYTs+yCx9uIS6AUZ9VY9xuNEQm1xje2pWk9Hk+ODKIgMuhn7cRrCJBewR0Urxa
	 tN1jILP0idlevObPsRWYCsQ9EM9kDCxBu/1WUfvRG97iCyUssBhigUWNZ0QeWqpNjZ
	 ntTWsFGili3HQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 4/7] mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Wed, 23 Sep 2026 03:14:49 -0700
Message-ID: <20260923101454.5748-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03ECF40008
X-Stat-Signature: ssc3rm9ecwhr1quaq8ufyibiua64w888
X-Rspam-User: 
X-HE-Tag: 1790158511-5565
X-HE-Meta: U2FsdGVkX1/NKziCYgN2E1o13PB4w+KvqdSdfdobBXVSlRPCH/+Md+khvYbbATU83LmMMu/Kv4Hhb7vKmo3E2Hb7cUpV7st8WY1hPYl7/BLVG3F6CKK+3aCbNxG5HbmRU47bQuxDLmqitgttd6zktfEzXLRE7Ze0jdN0CMV3q7s7h7q+QzuulwCkZ6oLIkKmYw3TeZqFL62k4ZsulW0Yk6tkUJSQVhX+Ee5e/NpLlHX9AJGyZ2a7SkKmnfCEruqFJn+nyzojyQ9QkJtjp6RqWnsL8mdW3K7B7V2PkP0hzcRmpO0Rr5UGOizIuLf9jIr0kMtzR686yXphhHteMnHfsXppXaWLNaMRTqPZ1fj7+k2oYFgmjkQxhoB+RXvRFJdq+jkMaQg21KODODhoBxHqmPW9DggUAYSpaegKwOa1uDKMEXkQZvt5OPJN5NvFtUw6maLSniSdTxzjbj/VVRvfUdBTIsRac5IsE91JerYAJA9E20pKtzXVGlQV5xh4APYOwg3OYuy6bCX/cEt+g0ZDyfZShql4CNA/12npgBofDo0OyLf0SZXEXgUIrDn7BD/CvL7CBHuohg5DXRQVjwOwgnuk4gEt/q85bjLSgSiOmTwSfJbYnWdsVo4BPp67NZNBjr8eEHKchakByLxIpH3y3xlJ5L20bO3Y6QkqBjpFsYVnoovSFFxnaAwjVwQx5SAnkSho7MiEutwJSmVJC18XE2x866bI9JkEJ2yU4ErV7sYyxI2fLHDpOyKo0Wc2ok/b96UewNhe4bkstEhZAbypQcDOiwaf8ZKo46lXvKsy+fhB9aA1ym77FbS5hOI3OmdSFVEhyIrfaO1Zk1C+jjyzytabtAETpuFDPNlAgq+AzblXFNHkVZ6dR23lnB9PPt0+yJoS7UR6+8mGGmxDevQAwfQqsw4IBCW1OnFapZfWNJqXv7XJq6cSwBKnVG3Cm25VDmVtdhzdcSk85YUK1/w
 4nMV0//7
 IWXrVfhOQzVlU3yEEjWfItqE0qFA1f10MurCTjVfRIdk0QBrPqIvwYXli7fxf/C3YikWWEjkaBB88wmbIr98/R5lK5fbSH6t5GIrFzVXk52e41+n46tfO8NOl1vGOuHc9Gk0DveQkYWXzplLbNJ8+tta3bG8wAr6M6vU7OAu0Eq4CV5Ud22eERO6mB1XQE08nz49OGnTUnQAbS/gaWiHBUiQJz+Ky+9SJfm9lcQwyNaNbjPIpQuNf+YU+a8LlF6JTG5CkVmTClHy+fHEmGO+R2bHL0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend existing DAMOS quota goal commit unit test to test the complement
flag.  Set the source complement flag and confirm the destination is
updated to the given input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 72dfb9c595a4..ce15e693bc0e 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -819,6 +819,7 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->complement, src->complement);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
@@ -862,6 +863,7 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
+			.complement = true,
 			.target_value = 789,
 			.current_value = 12});
 	damos_test_commit_quota_goal_for(test, &dst,
-- 
2.47.3

