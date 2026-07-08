Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1BBC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48206B008C; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9006B0092; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35FD6B0093; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9B06B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 224E8C04DF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
X-FDA: 84965753334.22.5A4C122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8D58520009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIpsp811;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCC9FMAOFAsuAQp9u1XHHxd8HHnGHTKjPJp30Yo3v74=;
	b=u9ZW/oCWFZZHhErwSCrab5EV2KYJDc756k3owUFby2knlA/osUffOKFM/R5K+RHcsRPdzL
	6qRnZwpjgXN6QmPAqEo+Jije/0l4Z30rdrwBf38Aasg6a9odR7Yh7WpGQy30pzrzYg3oV2
	qLjjfDIC4Q2IJn3dYDo7O689JzdRXU0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIpsp811;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518845;
	b=aFKslEicJwXCXw3bkFGRFRT9URa8o5RlqBs5hYPmtBk/x4o05bK0MBcfRmhf6T9/7ZANhd
	RH5Bi6ucONlMEOdC+9r0qH9ZL0YhzR2Y+MMi0TFad2E+BlufYx7452TFOMiCYxtZnRcLXw
	uvKj4UrLPj1H4rrYLKrq5vUHqbHDi54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FD646001D;
	Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A831F00A3D;
	Wed,  8 Jul 2026 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518844;
	bh=JCC9FMAOFAsuAQp9u1XHHxd8HHnGHTKjPJp30Yo3v74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIpsp811cUjkjWYr4smf0LDaEVsHjkLVNw6d3l9DZt+KvbYTyUTWZGGlf+awyll2v
	 wFpiKYWCEMtusCJRIa9ZbbZBq/1EDYsohHL8Iv0gtRTAaPjn81L8yt+GT/amzFq2pd
	 uxXNdZK15RCQbm/3k1yQBb9fz4yk1YoeeS7OB6FtQn7kV0ID4DNfOwipsB/4SYS+is
	 siKdLjhaGtkBOO55wbg1Fb7CLaswMJ1bs08MRoHaarXqnErSLoQNYwgGlmJo/ovlBr
	 Jz3inmBDWiwaT5zgPmvEXJnBpw7SGz3ccT8mbNc2hUDsmiO5qL1hxVsSkM3RaHyNWi
	 cw4SfHnhMBOLg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
Date: Wed,  8 Jul 2026 06:53:51 -0700
Message-ID: <20260708135359.122587-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D58520009
X-Stat-Signature: zemk8fqaxxz9wpg6n9mozawt5rntj5tc
X-Rspam-User: 
X-HE-Tag: 1783518845-388784
X-HE-Meta: U2FsdGVkX1+NtrYIrk2QB0op11nWKC/dBYfc6zyTKxUevU77ROQN7+ielm65OZfOMdXj2yVFC3fFCDVWTwlVkCONkRhjkDq5xM1J+y8w8ASaFDhtRWSr2iU8tR1hkMWohR61bWDFVpkyE5Hqip62k9yeAfjarvb1YNOLLboGwSsR128Rvp+7t5365xX1qP2+GopwkgBCBm/b42jeGYJ04e4C4WzeQ7gogWeOlqKIIBu/FxsrhmeFKjLgONmU0xI+id2RX8r4zZW/rZZOp3kcq305uJADbp6ckVyFRK7t2I++ePFA+IyjwPOaSk88g3/PolA5vfTj+D15hj/bHhOagb/WipkEHJBjYSofT9jRrDM8+VHC5mwPl+o7jmWQ3kPROkZjIQyYll804oqEIQsHBHZWEMGfAWpZF9k1emNh1/zwZOfUE+WKYppnob1PFzUApUoXrjjgbDRyGWpOzfwF8R9ZpaK4vKP0NHXR2SW2OGRyzB8P0BpuGVk/e/tClB7XiQWo0IErG43cBSHX7mYldFUwiSwFSm7O1ESQZw9zbFocc8QcPqTlrFla7Zcc7B0yrmTWE4ZGa+WO6h5f7nuEdg8tFzbCJ8nI+phrkpRJ51QKJzP5NLUKkZ6VOlB2R+Tm1Mrp8ZIWZcCrGwVlYp/+b8dbqZPFaQ9hR9bmdgfVWM+geYb4pXPq+3eauRwTa2Sd2uY5i0/EnXupVdE2ZM1EdYC8uy/ZpHB8CcTqqOB+jKvpy0UZHBlfO4nmGbMtDZdYAofynsQjW3nCFvbwOtt+TBRi8HUeeR5pPnDvz5f1lFpToS31lXwp/qimpnDt4qj+fHCr1Rq8u8As/xitUIfr+KzVmFxZcAiSkunBiXjL8/zlBEwDdYGV0jMzs2VwxUPe6Tv8f4ihpCO0Ti9/LU+rxIde0qLyYRMIuL80e0740/7G77c8HTcLKJwbgG8TMT5tJMIAW3RKLDp2MJ6JbqM
 3TnDhBT4
 KPVZmtT7EG62qbBCLiPU3TQZY+0OQKjSB/HtA2SFzirIcao6cid1mg/FP8wunQGs7F0LSk38hkRitZtYnN9pxdr6juLv69HBaO6GcI1F3ihhT3uiItYOhJMIgCbM7+b+JPO0/KTYzRmhH1djF1Ja99VVEr5kwLbahtngV3cjlOZMU3bf2qKXNxMwY9iWME86aiJl0kqubufsuFAECrZGGvLWhYg3iXXntWr01HAqiUxepwIY3OzfJNcZBXkPPHeMVMFqSqJ6k2mb3DOt6jG7RXiP9Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comments on damon_nr_accesses_to_accesses_bp() and its unit test
warn it can trigger division-by-zero when the aggregation interval is
zero.  Commit 35d4a3cf70a8 ("mm/damon/ops-common: handle extreme
intervals in damon_hot_score()") modified damon_nr_samples_per_aggr() to
always return non-zero.  Hence no division-by-zero of the note can
happen.  Remove the obsolete comment on the function.  The test code was
written to test the division-by-zero case, which cannot happen anymore.
Having it makes no sense.  Entirely remove the test code and its
comment.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             |  8 +-------
 mm/damon/tests/core-kunit.h | 23 -----------------------
 2 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 390e00b3685ef..a15005db82899 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,13 +883,7 @@ static unsigned int damon_accesses_bp_to_nr_accesses(
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/*
- * Convert nr_accesses to access ratio in bp (per 10,000).
- *
- * Callers should ensure attrs.aggr_interval is not zero, like
- * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
- * happen.
- */
+/* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..278d46632eff4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -575,28 +575,6 @@ static void damon_test_set_regions(struct kunit *test)
 			}, 3);
 }
 
-static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
-{
-	struct damon_attrs attrs = {
-		.sample_interval = 10,
-		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
-	};
-
-	/*
-	 * In some cases such as 32bit architectures where UINT_MAX is
-	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
-	 * damon_nr_accesses_to_accesses_bp() in the case will cause
-	 * divide-by-zero.  Such case is prohibited in normal execution since
-	 * the caution is documented on the comment for the function, and
-	 * damon_update_monitoring_results() does the check.  Skip the test in
-	 * the case.
-	 */
-	if (!attrs.aggr_interval)
-		kunit_skip(test, "aggr_interval is zero.");
-
-	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
-}
-
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1572,7 +1550,6 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
-	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

