Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52834606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fXY31ala
Received: by kanga.kvack.org (Postfix)
	id B72F86B05B6; Mon, 23 Nov 2026 10:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48D26B05B9; Mon, 23 Nov 2026 10:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974E46B05BC; Mon, 23 Nov 2026 10:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 679986B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB830160907
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
X-FDA: 85466727402.12.793A24D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67A5940003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXY31ala;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446800;
	b=auK3c2WDaRcwsLfm+nSrRAHdFwM59XuBdLCEWt2XDF9XyxhOlqxr95hik1MGCLlfnBWF+t
	4gMrbf09J7DahPFUNEDiAJ4Y9nyhijfwfaL0IyjyUDcHwad3Iq7Ff/V4t1onHyza++CC8K
	q0u7X7m/gzU3QQS/3jpjPvyw4cOix1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8iGZMS1VQT5g45aPmXwRX2Ggq134Vf+4sc1iINAHRg=;
	b=tlorTpimKw0iLT4gBRNITuMvo2A2SUs33zr9QxUnOZ2FzqPdTilBSpJw6XCXOqB9V8cy4m
	nTbHfFJLDVxkpsN2sWOAnEYrZn1dxKlM22lJ4cv/If9lQTIoeWFpY8dzHzt4XQgO3/IOzZ
	SgMRpubW7BuNLjQeJrDhJQBKB1PG8+A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXY31ala;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BEED613AD;
	Mon, 23 Nov 2026 15:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D20F1F000CA;
	Mon, 23 Nov 2026 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446799;
	bh=p8iGZMS1VQT5g45aPmXwRX2Ggq134Vf+4sc1iINAHRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXY31alaB0u9au+E4xSMKcuTQIfRhQ4BPGDLp+oUMYHbYT8u7IlCmzaE6xrQOxD3z
	 sqoo+K7mO7QdpSPUj4Mtn6lerSYJwuO6Hwm7vC3y52cpQidFPN7id5CpajhpYjEfb4
	 XwoRFhPRAmsZ7V23OidYWxA+H1Em/2GNVFatbGKP/ppp5wbuRJoTdKAsFM7X8cxCJ/
	 cZhDKDI2K1nIrSVeN7++5eoNuDy7N+KlfIpGUp0yxabT2kKl8WGwa7c901ARhhrJet
	 OI1cZ+lZ6Shj9xWDvrWKhgWGaFBZmhgPS+iSSMzRSjMXV+TNoD4dAMFAl8S4Jyyp4t
	 XJgsg+2uV6dfw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattathias Pinchover <mattathias.pinchover@uber.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/6] mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:04 -0800
Message-ID: <20261123151309.82675-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123151309.82675-1-sj@kernel.org>
References: <20261123151309.82675-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ursi5d9i7oupi9xe6ktzmikmjikxme14
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67A5940003
X-HE-Tag: 1795446800-335795
X-HE-Meta: U2FsdGVkX1+zh0N/PRTP0Rdaoh0TXc003jZfZApLb/FHAfpgMLhuWn3w7VhpzoNnLje/nxe0SLqjYQVZsoYZCX7zWFfEiZNchk+jaU+H0Ig5vqCqTcbbQI9KWKvvcc+eUfM5+Lo1dowb2u6s9LQwBlKZh7gCRpMyoAO+YZi59zNoBcFyx9n5LfR2vBe5UtumjgZeHRcPjHBWcKugK8kTCx0nLqXpe4lHJN8DFPlmUVuDQYXOURikoIOqVOMpJ3T/Ib5MBZvR6v/B7Ud5B62JtAJfJwIhISiuQzlwYjgLd4gIcLiXudZAChbSns2zJB7DFfvx+cPhzXnYHCOA4dPejBLIWbPo2scQAD4BLX54BEaPt7VIroog5j/ZDXnIjrYkXgwwCzICmhPooP+6hnAVqOITXDMA6S5BsXTCrDfI/MiU4hZetQFU0SMowUKeCa7NRZVzkhjWk1qqqCXgqXPRzxD2XTrOW5wJL1g0uvUPDTafl0Jv7Kn/TrRFJuV21sqypVfISAjCDG2wbZ/izgaR1c+dH07d7/Q2Q6lqwsBLmbxA4LSV0RT1xoNBTYFTuVd+4xwhRV/I6OXCa+G7k58UKC8lmtD85NNBJ+NBq2C4l4mVlLsJXqb+eqD/37BV3xxG9EvLj06Tcg73Dx9y0WbpxHQ+jEep0TJd34VV5k0MDUFW9SGy48CuTfuGFRIzN4+7+OAeLm4GyNZ+UQbrQZ/I9rVq9sc957W2pdk2d+BI5frBfW15tpshcKXqH9fHKaYo0677Czwk9pw2aHFW26x0nvNZErl0O5AHbOioeumsU60zNsqFZb8Ctfp3/ouLDh/RUqVlS/7/TgTFj9rxTh+iXBaM4p2EtXY+9jPZGNbR3mDYkQpe2U4ALPWdbnC4ME3WsaNLgvxmiPcgOBlPOfDyMvbxlwOs+8KESwyp4wMuobGBvMu6Uo32YVdN8GMJiOU5t+I9nkEB+/GjK3JmR10
 fn5rI/qp
 VJG+pBrRmg0NNHFLguucINVvAuT0znls5vZ6Bsxad0dAYh28l3okOngXoCWhXujiHhm5Vrok2lmQLQihEXdMz958Kd0OJ146MUysG6Ke5jctjvNJl9sptsc7hotScW/S8QQkglyRbZLePtYL+fuw3362/9DB1N0IXHRMQl0A8tvkefw6PgZe6jV+L2UBbbfz7Po+SCQu+NbuLg9Y8w1eYKOoYBvXwvrWp41uojJCqp8aRML2oNFDqc7vX7yLqLidhnKdHJxNPwv1n4df5BffvuehDvh2ryLDCOhssI3dqM5wqQ59SvSmfZ2DVsj7zo2g8WICmAklng3oJVNy+uIcRpmejTbCsSsPa5Wtks9IOb0LESalTWOrJudZ3pHpi6cPjDF+NLfqL6v90CNSAEzsLXCIvIFAatTUh5PTvFmOGUTupbMvCdXoiNt0sqRdwJMi2Y4Ow8hQIi6yKbPfYmbaBm6UYyrS6EtNZoRVwAXcl2w8NAIsMtxmTocStS+g496qwvfYkDlStzKqEnqIW0OeR1ZxyIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Add a kunit test for the sz_ops_filter_passed_last DAMOS
stat.  The test runs kdamond_apply_schemes() for multiple apply intervals
with a stub apply_scheme() operation that reports a given ops
filter-passed size, and checks that the stat is set to the value of the
last apply interval rather than the accumulated value, and that it is
kept unchanged until the next apply interval is completed.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 93 +++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a5ca4bfe2f0db..d256e6b7de73a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2541,6 +2541,98 @@ static void damon_test_last_region_quota_reset(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+/* bytes that damos_test_apply_scheme_passed_stub() reports per region */
+static unsigned long damos_test_sz_passed;
+
+static unsigned long damos_test_apply_scheme_passed_stub(struct damon_ctx *c,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *s, unsigned long *sz_filter_passed)
+{
+	*sz_filter_passed = damos_test_sz_passed;
+	return 0;
+}
+
+/* run one apply interval and return the last apply interval's passed bytes */
+static unsigned long damos_test_apply_interval(struct damon_ctx *c,
+		struct damos *s)
+{
+	c->passed_sample_intervals = s->next_apply_sis;
+	kdamond_apply_schemes(c);
+	return s->stat.sz_ops_filter_passed_last;
+}
+
+static void damos_test_sz_ops_filter_passed_last(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	c->ops.apply_scheme = damos_test_apply_scheme_passed_stub;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damos_set_filters_default_reject(s);
+	damon_add_scheme(c, s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed_last, 0);
+
+	/* each value is for the last apply interval only, not cumulative */
+	damos_test_sz_passed = 1000;
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 1000);
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 1000);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed, 2000);
+
+	damos_test_sz_passed = 300;
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 300);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed, 2300);
+
+	damos_test_sz_passed = 0;
+	KUNIT_EXPECT_EQ(test, damos_test_apply_interval(c, s), 0);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed, 2300);
+
+	/* not yet the time to apply, so the last value should be kept */
+	damos_test_sz_passed = 500;
+	damos_test_apply_interval(c, s);
+	c->passed_sample_intervals = s->next_apply_sis - 1;
+	kdamond_apply_schemes(c);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_ops_filter_passed_last,
+			500);
+
+	damon_destroy_ctx(c);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2585,6 +2677,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_rand),
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
+	KUNIT_CASE(damos_test_sz_ops_filter_passed_last),
 	{},
 };
 
-- 
2.47.3

