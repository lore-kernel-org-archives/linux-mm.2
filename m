Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9D0C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B9B6B00C3; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBCA86B00C4; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98F16B00C5; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA8A6B00C3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18171A1B78
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:09 +0000 (UTC)
X-FDA: 85041980898.09.7DF5FFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7540E1C0019
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkYtsegm;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333787;
	b=TsezdIh8eDCtgUfqtWGzLzyS2LaV26wJ+oDNphd36sQoD1obMM5/k7L2tYWrKLP/MZgBb/
	8I98ENlo2aOnpVbm/xFwsr+BIzMsdnhLGG11jJ6tt4RdY4YHweYotWfhrMg48RRA9ML/vE
	/ltufnOrq2ZHRc3cGYt49EFXOPgeO2I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WkYtsegm;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKzzWsAXP/F08KNPNwIlHEjpZQDPuypTZix55EIf9Lc=;
	b=eySIMVmK0UjZv9u2UxqqJuwvOiAgHmvz7bMfoUraNHrFtE/SfC3mAkDZ3AFaR2U0vfvPrn
	Hqkuh9AzNXJKM0g8VDaSR1rT1V1HFRMagBVCdgIOANCB7ghbDPLs3EpjNbS7qTInLnOqF6
	imi4zXOhtmWvRTgKkl5OQI8+Css8dSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0510E60A5C;
	Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659E61F00A3E;
	Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333786;
	bh=cKzzWsAXP/F08KNPNwIlHEjpZQDPuypTZix55EIf9Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkYtsegmv9ZOWhUIMCf8RtEhUZVp6U+ch9Vjkaayub19BUjFZL4oN9K++Hbb1ovhu
	 +QZtZEgerhSpv1IBGr7VZGTQhka/NPzaVH+IAgJ+eG23jPy477u7cyVJMDx8jlRe6r
	 subUunDcT/sRdjKkZhsI4WF5VJoHENe/DCWmXpm7NLwAd+hUH8ArojaXMUxKP9xiER
	 Tqpx6pLJRrZF7VGbzkKjD9w1i0xdyGoK6HoEyhy+uQNWZ4w5lzUKyFINo4Be76MFTL
	 NqCHk/56opL8f0qzi2eLofl41wigk+rQUF9sOZsxkR1/lywf8f0cxItE+s7FS2DTfq
	 W0fn+hsxZrpWQ==
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
Subject: [RFC PATCH v1.2 09/12] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Wed, 29 Jul 2026 07:02:49 -0700
Message-ID: <20260729140253.87753-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4tgq6twhegtifac6wsq8e8mq1zc65c1o
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7540E1C0019
X-Rspam-User: 
X-HE-Tag: 1785333787-501451
X-HE-Meta: U2FsdGVkX180cfg5kwimnIol9WGzEN9cHZ4cuxw9BfVFuw/WiF8KzwxswaF2Jr3syAjZk56U2Guj34K9oixBtrWAkc+foEBGDGsZtPO8YN8mBrHt7txEpnJIZRIFGKMAataSZWiu1u30NLQ7hSz95jz06VZzhKUz0T+kuwB5+5lQ9J5mzc4flais/rkgSMsDvjdlVeRRLO+zLlj752XIQbia6PW5w5sS3gigqfxeg//8Jtcq58mCaDycLUAE1TNSSojviYzEngQJeY7Dae/xlezICTMfYANlzatvAEI3uyffW4lqWfWZrogpFvT9ilJrkPUM0dV2YiFMq+6t73pvxBPz2w29McKZ6T9lCSrTRZPMn2Yxwhh9PKwXzBw1Ml+ZUgfSuMKvfKXflLf9HKAMalqLLp53birdXvbqIORR9m/M1puqlZIJNN2SXM+DFki5HNyz1nHGS12NmPsxe8cXSEn1WBBCRxfnREbFp+1h1bxfUvnA+7sGws/p9tzOuBk7bFCvZEDI0Pt6QfSS2a4/zZg2N2OrRbucR72TCCZc2RRZfmlegArWTiilylNeR5NqrkGB1S1ClWkJeltsEG50BpSHJlz2CzI77nw8wqr7QwlmXi2tYCj5m+iOUDJpK+WKiESzCYc38NjQT8UksjKB8GC6WDHuY/IZ41Cvn/yensjrjHex2DJl95wwNBhL67GqD63PANetV8mXPWzqnwvmuCeFko6TZUu9dUvcBcd3TJ/Bp1fWikk1i9uAuoc9x5Q2BZGJW3DkyMpPX9U450puiBWGimLp7kMBahmwxJKmrbDCxKVYbveBrFnSgMsGRX3n4tL6Vp+X3nRUGtKljgF35fJKj746ah6JeQ7bwTFBeOqE89Q0GEfpTAlTIrwDMe2Ch5CGj5arcnsAhmyoC+YAf7WX1jC5ia9P7kUOG9ANuR9MYBMMNkiC2YuCzkkZ7JlpsTUsKo9w22s0S3/96yf
 48Q4sz4u
 /tRfr3NZmobgdPN09lCjvz/SHbEZ/ew/5PYP1/T96xRV5lZroCVhxlGvD3JzrysviNA+JWvid+YQDqM2OXOM4DxvqX/KSL408Om/++ZWkXANkjjBkfugsO5WbSy/gX+heB+Di2U+Gna1xr49UIUrtt2BpXU/F6brOx1D5r0WeGt7KPLpTjWqXN9opaO2nlN94OqA2UXmeG+qSzDj/vBztc2S7ikUON2vbWyAF5z9ihy5rvHliIdyMB0EEhj/Wzw5QgcqnAoAXV/P7+svcG8QScglYgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses(), which is a previous version of
damon_nr_samples_per_aggr() before the renaming, was wrongly returning
zero or random overflowed values for extreme intervals setup.  Commit
35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
damon_hot_score()") updated the function to return correct or more valid
values.  Add a kunit test to ensure it is working as expected.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 252d81c30d6f1..c7bda8aadef3f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -619,6 +619,27 @@ static void damon_test_set_regions(struct kunit *test)
 			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
+static void damon_test_nr_samples_per_aggr(struct kunit *test)
+{
+	struct damon_attrs attrs = {
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
+
+	/* Zero aggregation interval doesn't cause division by zero */
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
+
+	/*
+	 * Too large aggregation interval on 64 bit system doesn't cause
+	 * overflow
+	 */
+	if (ULONG_MAX > UINT_MAX) {
+		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
+				UINT_MAX);
+	}
+}
+
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1670,6 +1691,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_samples_per_aggr),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

