Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB229606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPPOKVWI
Received: by kanga.kvack.org (Postfix)
	id 6DAA86B05D7; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D736B05B7; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE486B05B1; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A75276B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E85CC05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:13 +0000 (UTC)
X-FDA: 85446189066.03.BFEB07F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1275EA000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KPPOKVWI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957791;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARUJ4MAAEpvnziFuLB+fXPX9rGdUVA5ywAZlGvBHYD4=;
	b=hjSsbMbIbYSt28OK76e19cIksqO3vwpAWWyzwYZpii3oeaCrcqyVVwtF/u47QJFV8xqoRa
	2W0WGzJ75WDYMqFF29oB1u2mKBw2OetM6IaAgMwPkrWGzfTQeN5e0DYLhiZ1ambjG/WyRW
	KAv7KRl9EJSN0u+qFdq2UzdiHl6YE4w=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KPPOKVWI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957791;
	b=mOeg5GRu5mJ0kjJ/4Jy4zjn02B493n0JoiS0jfF+YDeFiVjRH99h6B8JDCRMTuonJa2xfW
	jStFDf2Pzg3WSW8V0e+fGe7MIH+qL81vcSNZRzTA2fzOVIcf9PZ1YsRooCEP0PjUqm8V36
	mhvDXvjBKEupxgtAwpMrguvek3PXuyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60448430AF;
	Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957790;
	b=mgfANOd34HR/SejL2SBqQbqomzh0xMBMuFuHvznmQ9jv2O2RmdQsXqIZFP0xDpo0QqoR
	 nZeFKrqdiFIy34LwK5T5OyvVpyt1mnrwoY9c4hg488sHPvmcDpqsbBWe3x8XQXuo7zQ5D
	 E/xusn7Y1x22aP5W9QMcEsrhEcSn/yTPN/LmpXzpI/+1Nj4rAz0IEOoLuhnquXQoXP/rU
	 UWkdoF4PSMwz1lmDntFmpZctAC6g4X19+k2uTVjyOcmAS9E8t9llh35tuyJZURi+Ov1tA
	 HCX1WqsUaHtymdE2rF+jIQDz4eBVzlTTbyJRS+zH+ETt/FhJnaUc/e5peDvhZLeX7kw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957790;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ARUJ4MAAEpvnziFuLB+fXPX9rGdUVA5ywAZlGvBHYD4=;
	b=2OGJyzolixh21Y833I0OUWLVwbKDJSppoLa1viFFfv+rRaxFmYM3OeLIKuSQE/j1drPV
	 4pTzcWCEWVfHIj69oTDBxNrG+vSNbr9aZXbFf18KV3j4G8am8GMITWMZ8bH0JiNpC63na
	 xxewAJcCKU1kB/KFu/YmL1BUVxc/7so5euu31wbgL2VVeY0z+0zHVqhPBWibv/5wAYk06
	 42Is892wIXar659dE/CcLjMcOI3K/64zoRsCMeV4axmry7kPqWAxzCL9xOkxo0OqbYAlM
	 UNvksVB9nSIjqWT5wWtBio3VztoHTIaybhq8angQTGQ12GXYU+hpEwf4E4XVG7HCGig==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5A6FA1F000C7;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957790;
	bh=ARUJ4MAAEpvnziFuLB+fXPX9rGdUVA5ywAZlGvBHYD4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KPPOKVWISH7C+ybLO/dQWDVzh9+5TZakBeAA2ZkaZsHltq98R4gBguNXK3ug65Z9h
	 qf+07hvVPhvC7FITg/MsxHJDpd3Xu0w6QrJF9yaktVwON7j9v1JXBtMIAQJz08dKax
	 cnftnFPzkOlWWFODLWpX03a8fj0BIoJzNdvhmSb9L/RlAH0jxuruPRhNoKuvQKDWfo
	 Ot+6cqF+IdUodYTjrpp0wnXsK0arscfRs22V5s3EMy/P4yRYlBclT+OHYOfYqMbudU
	 BL6FqE6PeP4JoXMEm/Ztg2QWOkunkZLInAOP6lKZbJ9N1YFNVHJW8xreEx7qHwGSp+
	 v5j9bQpbrl1YA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DCA394AB44;
	Tue, 17 Nov 2026 23:23:07 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Tue, 17 Nov 2026 23:22:17 +0000
Subject: [PATCH v2 3/6] mm/damon/tests/core-kunit: test
 sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-damon-sz-ops-b4-v2-3-439888fa04ac@uber.com>
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=4205;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=h2bZi8GyX472sluoP+mJ0igMgXjinQcbkxTFNqsCnXE=;
 b=ZS34BMhhNNrcONv8s6qnYwqh4wj0bpUA4Em2mETWCFRNJ9ey1QcEsZRaNUI6Xf1MD07QoprXJ
 hdZUjXRi/lUDfzAinICPHfg3X+BebVvswtcnycZHNUYnIZwF37EYvLh
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1275EA000C
X-Stat-Signature: pamxbojfofe8h1iaf13sfnx1ykjd43er
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794957790-108324
X-HE-Meta: U2FsdGVkX1/wDaPdjvYspfxUDE1pORS7B7CKDHC4tuD6pNRwyCljiJBjWjNzCddaqesC3G2chDFDfNglXJ1KpddJ3wgbZCL0tGXEnF+yRx7vC77J8wReorkNxjQKGXbRkHptzNcE724aciTlpWDpcyoBK8HTVdifnosssAIPv+aUo8bgp3OMxdmhV2upL4uxUFlIftt8dnRH3tIZmhPG4r2Zf4WNFZDR81tLmDrrAa/PM43klWy0x/r+5lwqp+6KXmyZ1ZFlsCGgKZNlD7yHufmcmRZCpzjlS9WATfTXJc7M3aacbZjBkvu2Nt4uUZePYg0YlkrQh5coIr/nGGWYc8mVAcZgrjAI7ed2Y5S5NpyRcxThiQzP52ETbwm/D5MGsOZLmokfiOagTT00pWyuOJsOJifXf2RyhVsC1qiVR2MWiQcH8wDAQ+lLWflEhroFe5+wnhOADDeocYkpE2dVq0MRRqYL2Xnda236kPccV5sk5yqO5BbDJWEePaeUBujV0us4rznS9+MxcFsrPrOOq/uAj06aQt5H+niDqhMayx/UfzpAzfW+YOcbYvRe+9chOkZsAh/4r0PyKjbpVw3i3jYi6BBE6kQ8rFnweNuCXtYeaHYNy0IHaKhmjm1ZcxoG/ccRdnuCU0jcFBe+PGni6DL0VPHsmJNb3PBAmDlJ6jRK33SQ4FwSj8uQq8hk0i5hpvC9YHGBIrT5I7syThwJb24MWncz4ykcqfwSVPHfIqhfAzAwJRMfFh+F0n2fA0Yaqvi5i/yEfoNUiTcQ7eoitbSFLGpqDW6ky/FQLLeyorFT0/LA4IT4A8caoFC/4oTxrVyKJk9cKMDSF5DWMf2eXT0MwrzRDNviTzzfza6qNva2LJJzjW9TxPD7RXhlYOy9a74/nO5nAdpqC5D1miYoR47pZ2yDoA/U9h1IlvBrlUT2eQR9f3iHB6/5BGP52xT3mysV+ES/59M5muWi93M
 Xg40U+qb
 hQ+3wpnmQL1tvbBnea311CI9YTHp9/qt/YrMfLitP10ue9s/AJPJ9HRd8Z4PP9q65RT6oW/TFbuojkBQIfdS9KpnR7vwER/YO6ItfUbRip4bRgQTYaR4wRKUS2mwpDiYBW0jrLX0B1mpSjBQ25GLkeAKMiRx7ES02Klb03ywQxBoMA3+lc9bpCr+n0E/Qs3CIorl6z9pR4CFES6GSQW0gLjMdO392THuOo7VKbxLAQwj4RhPvNk6bzXKBPaMw9OyKQxbJznx5s6/lvjD3FamvrYf/aybwPR6wv9pi7Lac9I1G3C8GHgabCTzOitwf9DVhAlp26c0lmY7ShFu0vV95Hhq1+VLCqLkKayIwrcbOq2JU8g/bi4elXOgDndB7PRCHQxs4cEM8j7W61tgwgGUvxiHjGg8fCJQSNk02VV4VPu17Z6ZTnahdHRA8kj/aMIAUShcDzvjAzqizgn7w8b/CZ65saDHFhqbpgzbyZm0X7YbnVr/IXDn8uiegZipkZ8tXvieH4zNYzg9Sr+HVAEut5o7h/ykj88Sg6e4mv/tOkK/ogduAHhDdhz504MtGqWG6W7aOI5CkhKp7n/ThnjbZTsYnnA==
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
---
 mm/damon/tests/core-kunit.h | 93 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a5ca4bfe2f0d..d256e6b7de73 100644
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
2.54.0-uber3



