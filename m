Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A87606A337
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzkwPKUh
Received: by kanga.kvack.org (Postfix)
	id 4183A6B05BD; Mon, 23 Nov 2026 10:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305AA6B05C0; Mon, 23 Nov 2026 10:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241AD6B05C1; Mon, 23 Nov 2026 10:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0F176B05BD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6330314085C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:42 +0000 (UTC)
X-FDA: 85466718204.14.73CA001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C0E0220008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YzkwPKUh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446580;
	b=zivbjT9riK4nnYtY9w850gPREhM2Kam9pxkM/z0viLvMZbJC2VNav1tCNDuEKmw9r+g9hZ
	yQSCywPyu/ou8djrfkEJPNKLC7STgNRPH4WCnmGl+DTWBK3GO8gC6Rip4t6JZ2lRgPAn2W
	1ZwLpv10RWAfUcdeO+Z3A5Ms5LHRyaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyOktFiiDK2ucPq8E+Ur0m2cBgjFWaJL3PEUR7BXbI8=;
	b=8iFR6iAYEfePTiB4P17/RvWiVWnQx48fk7deUMZdytQnlqno+M76/Jfk4/f6zouxnbtVhI
	sujkkPswYN5PSQDztGH9DmxeLnK2q7OOlYu+BU4WR8g99iPBT3z9+Fz36GZ6SlvMg/eIbH
	wWjR9JAIRvyx0BpmxUxk3SCHPb3sChw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YzkwPKUh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 624E662274;
	Mon, 23 Nov 2026 15:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF45E1F000C6;
	Mon, 23 Nov 2026 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446580;
	bh=NyOktFiiDK2ucPq8E+Ur0m2cBgjFWaJL3PEUR7BXbI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzkwPKUhz87lk+UO0uia0fJp82Y0FG56zyiDzzVQ4bo4fpAfGMut+r7wsI5F4qdZG
	 fnVZV6VyJ6Mcdydv1gvzbY23GNEwm/JxnLqzRZfZ2fTPtzdDu2fqMcBz+nlUIZ8WDW
	 yhCW38hYEmMyvCD5XXAwRuJMCGObEL/tcbEdukBJLEl+J1H8epYf75pRwKQi12fMUb
	 TPLkrwYN5L7xf7X9uwD8+qi47PnccRxmp7/PwuzcnC1tS8bo591k5zOVBld/Fw53Sp
	 8WquC6AIE7VcJcK/+8Sg4Kx/bNFuvIyMgTi/8zZbMUFjJVt1KzvDjDTjEoxUbLmCpd
	 d8Cm5JH8I5+Pw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Angelov <jasonangelov@ucla.edu>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v3 3/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes
Date: Mon, 23 Nov 2026 07:09:27 -0800
Message-ID: <20261123150929.81797-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123150929.81797-1-sj@kernel.org>
References: <20261123150929.81797-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: C0E0220008
X-Stat-Signature: 93fpoiey4p98odzhdcgu54u56sbs83s3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795446580-176998
X-HE-Meta: U2FsdGVkX196r2KART+Pitd0X0DNcJ5FV1tjaumwvVt5ybBC5IJDEFAWCRupvpR7Z4DuD97Btm5dvJYXzsvp3HU1remr5KDYHz1n/vL9mDHQS3GxPK2yZ9pyW86mimk0YQMFiblXxRFCBTJiqWjA4XI9KHBXe3N186WLNgIAssXH0QxfBsQgqA/DHZBordXXHZmibZnNBwxhmnadyRVMCyGCpXaT+h+K95aTm4Atsp/xJOWPsWUgsPUl5T2A55VN43Xe4O4S86HOui5wVyccflh9qKMsab6I7blJcZ7LLSBJcqZNJluUy+3Xs/FR4PTqb7ahwcmQT9amWVfd8wpPzOMzTCtTHtPcgsDRkd5YYJ6Z+NsrQ2lkYfb+JT3Q1+bfDLERR6H1HsriUyJhMjD5QMk8wKHAtUIxGYMiogfxECAH4NezbbYL6VGqD0kX1Ym7icMR3jF+2Zn/nyIhHfVxhXR1cEuMcKZw82dTjLfjJY9Qv7IfLdIR6/eYXfFqQM8rJiC5PrVwewWMHAC8WIkFvbh8yGL7tZWBU+gXAQ0vwaUlv7OUBVGSSGKIfp0nPvdUQ/ubruH2A+ql/meU5YJb8CjKS/JWCn5pH8YHqevbt/LfSJZDfQzzglarouIS5WLiITHiLvsZLnekjaiPkCOgP5qmJFRWPviccqonUCpfPtCcqTcOV0ly+P8FL1D5XOuGwB/EF+X+49wq21qqWcmy4yczqFGWVNIPobsmG9r2xfy3Ib05yVo6sFJkEwbF8TVu1XSOeL8WTRVblcqoYI5+kFGnMJaLIY9b6VWbNNSUaz+Rw0fzgmXGjRivYcq/ymdpBd2Cn+KBYjK3xMx528NTZHpvyd4M9t1dG3pfVjeD6wqxjy3SGvYy1zSR8Z+WSXftAfgGOKoz4LgVKwOVmyVt39m9F8umLDH2hk6Vq67GtA5If0cfpsShyKDyEIhjYY+qL2GIQA7Q2bUo+AVXc3Y
 +45lmHBX
 r4jERuJEqsHfQjT1fJ8I/+gM2mvQEFgnA+SF06YxG3CiAejwCmrjZRVLIp4ykwciMiKv5lJlaWdg4IYhNhLCgIyji7eu+FVt9YssI2+DJeX8lwiFeQwpOk4mBvSKWNTGIG6Fn189ymL1OFGuV0cM587F6iIClptrzCmQFnxmB8CCqRaSlha+6TG66aecU1TgB/yZ+Lr2IYv3JFSd32bCGngDvJ37VVRQbzS5KKAKVxhwITgThhpUeasHxsBwRN/UP+rL2K0WZZ18tdVK9pluzPxcwd0I0eJf/oW3yf0Mf8zC0l0DnOt5BNnsEmTRvCbFZX/osbsebtX0f/O677v/6zq6cp8xon0sKEN9FZ8TBItxg1uavCNdVCQNSeUP7GSSHavXcBtkxWx1KVmrvk8FRba/Zqy/j/CuueEKGy2SmYOefYMQ1NgzgKg0VL1bw48llN4H6/jd96jhopis3GVbM7txP6lcp0m49NAITFdYT6Qj0rFnS0KW93UBvnLEx/CBdaxoRc3VBYk0llPOGIYhKjW2v1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jason Angelov <jasonangelov@ucla.edu>

DAMOS_FILTER_TYPE_AGE_MS defines an inclusive range for age in
milliseconds to filter for target regions. Aggregation interval can be
changed by users or intervals auto-tuning features.

Add a kunit test for each:

- convert region age to milliseconds, correct behavior at boundaries
  for defined filter range
- DAMOS_FILTER_TYPE_AGE_MS filter keeps correct behavior even when
  aggregation interval changes

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 66 +++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 156f74832c405..3b2b745b85469 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1838,6 +1838,71 @@ static void damos_test_age_ms_filter_is_core(struct kunit *test)
 			damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
 }
 
+static void damos_test_age_ms_filter_interval_changes(struct kunit *test)
+{
+	struct damos_filter filter = {
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.matching = true,
+		.range_min = 200,
+		.range_max = 400,
+	};
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	int err;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+	ctx->attrs.aggr_interval = 100000;
+
+	/* An age of 100 ms is below the 200 ms lower bound. */
+	r->age = 1;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 200 ms matches the inclusive lower bound. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* At a 200 ms interval, age 1 matches the lower bound. */
+	ctx->attrs.aggr_interval = 200000;
+	r->age = 1;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 400 ms matches the inclusive upper bound. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* At a 50 ms interval, age 8 matches the upper bound. */
+	ctx->attrs.aggr_interval = 50000;
+	r->age = 8;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* An age of 450 ms exceeds the 400 ms upper bound. */
+	r->age = 9;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	damon_destroy_ctx(ctx);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2600,6 +2665,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_age_ms_filter_is_core),
+	KUNIT_CASE(damos_test_age_ms_filter_interval_changes),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
-- 
2.47.3

