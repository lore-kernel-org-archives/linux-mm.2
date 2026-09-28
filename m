Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8B8C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E50F6B009E; Mon, 28 Sep 2026 04:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06ED66B00A1; Mon, 28 Sep 2026 04:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51B86B00A2; Mon, 28 Sep 2026 04:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B16936B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:58:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A5C0160148
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:58:49 +0000 (UTC)
X-FDA: 85262570778.15.91DCA81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 927AF40002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:58:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GXDUvA6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585927;
	b=nzW5VOdyVKEKyGZ3aHBZP0AfCEAEARsoDgJ/MfaTrmIsuF6yMs+Nk5uwv0trwry4eqSGsm
	nHmKO4HqjV/A/XmrEsqh78zXxEG7xWXD0P8pnDSTKVdNAZEwz+Qddd1YzIBq8eNHl8Zega
	izyqcUjf/au/ADeiX321cm1/b9nJIIs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GXDUvA6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sd5+lKRVanR5td5IYZf/JY0OSKdgEdCsoPq05buSy0c=;
	b=tGnxNAo1zt0LjS0lBg6EZKeapNSi4TmbP/bhk3RPTNSD0TAwLdYw4JxheAQcZAbn7Uyyeo
	lpq9y47fBKdhBA2oJCs/s6Zx8kEpNVZEHFzbOSloymJ7pBh1CJ6kYdx3BV0QasXz3/9AEW
	9X88ZrTVQHyrJrUkgJFp8Kx4T+s7Gck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12F2E60207;
	Mon, 28 Sep 2026 08:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512821F000FF;
	Mon, 28 Sep 2026 08:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585926;
	bh=Sd5+lKRVanR5td5IYZf/JY0OSKdgEdCsoPq05buSy0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXDUvA6F7RSYiyz/gPZnj8ACNny18VA0aKejKeF6T8gb8GocEXknOrsZICLv2zivg
	 WnAx6HzIKhGCmKVM2RRY09C+e2WSRgCrliIL5IapThzmEYHa7VenBoy7hwpTgcQH8Y
	 X7RwP+wyDR07Vr3E75bxV4eaFi/BAdDbCl3xKrz15gdCLNW3I0KvX8t68TWJpCVy1w
	 UEbeGPUeZbXkkYF+LGIW3F0fk1E4unM1AErBHovOS6kKJOkjHBRl6XGlqKw+uxecAq
	 t/02UZzG2kXy00RERkSLKrKIqL7jEHT4XF/MVHY+Y1GbvCW07znkZE553r8YZcamM6
	 v9/ogbkNSJyAQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/2] mm/damon/tests/core-kunit: test preservation of quota state
Date: Mon, 28 Sep 2026 01:58:34 -0700
Message-ID: <20260928085835.7675-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928085835.7675-1-sj@kernel.org>
References: <20260928085835.7675-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 8bans3t1hymbmsrcc6hjotfqefmoj7q4
X-Rspam-User: 
X-Rspamd-Queue-Id: 927AF40002
X-HE-Tag: 1790585927-37534
X-HE-Meta: U2FsdGVkX188NvBpcPpOJYgtRg6OUDyICT1GA5So3jdvltH8olwlWRbRaVgPfuNqtq7ZMEiYb0aUxcM2cEKDulId8T/6657y0ZmxLCe5ngbvnLSzkkmUzLPCaKyRDBPlg5uyagZk3EKO/4bmP3LcNVLxJ5Tr/PLdVUvSkxX94jAoIKLUv5d/AnDEha9SEwM2fc4peJ44VS6tAUxRCB5jDsrQWMbrBiV+8W0Id35DkbQmn/84SuPtO/xpzg1snvoGo6uFc/F8Xq6jmuiCBIF4R/rO6o74MlthNaMid7F1NHJWP2vHhylK0rGy8KqJ/T0KRsW3qbUOz84wufLhjSN8/wYvEXMwyPgJ9fxgTlvGCXKCtjlq7xwwCeiqHAJu7CvOIutdjyE4cvAGP2tXN24yr0Q5s05LMk+oFyEf7TTZaOHyknpS3K6LpD3w41DeBIxfpmZF63nhndTKeApOPDhV0I/tgFD0oER1xSRLoW5h6VYj84mlSvfGYNIj4LlM0Ke7IvSLIl8KIPCvhM0+/OOCTAJmz/b4xkhnJaiy7Ucl6O6sRHoadPWzbpgMTm4WgEcHBLCIR8y+g4rRpKGxVyVw05hPYPssnrVHdmgDArqaZMjgPu0tqZ/NL3oBV8LilRuNbC0rlcZqEtWzDAdTAyQsNV4OWbb9epJYHpkaPuZXRXmIVrl/vxx2+KDgKO69PQU66dKsvyCcQHnsCDRX0wNdmEx971eW0Q0W6/G5x9qAqVElmxKj18QdB7O/PGq4+fAQGx6ZuIlegNLkhFaJgH9iHRDV4mwEkLt+Z8TKYU3pzE8SlZhitfO+aPOwUIdfYHmQK8GjZGWKabklaAvwj5K2gh968F9XjoqDEyN7zQ5izvSQl2z7ddzhVFDnZokZMw1gVn2BbvNd2M32240GJHQUdukjlx5zW2X9HVUxHpeIAcGoTvUTXrOYOWO71AyteFFBD9rBef/PMu2DAp+Cl9u
 GFjPNOsM
 fkeGloeOQXTYq7maZM3A/OZjDtB+cGlZd7BwHtCFsnW0lJq+wkeu6aUmZK1rMo5ftZ510U8GIFSEACPDQ2ZIxxixEVuJLvQ+BIsIlQ0lJgVhWgK68j+tF/yQvHXB8mwRYhk8fbSD0PrfHkwd+Y+DZ7sC7B6Oh6ggRgkeQoPnF1VS//dAhodvZ8msiwayWICk8NXbJu1nt/zI/0cKHpBpOw8rR7bnfxZiFAIvDULmz67aGVRFeaZUHnVcIBoTpDTXulZrqZyrODLKwvSLWcAb0Z4jf4ZE6rUuFaxI2ILI7kK0edMRgWE0lx9V2ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Karl Mehltretter <kmehltretter@gmail.com>

Check that damon_new_scheme() initializes the new scheme's quota without
changing the quota passed as a parameter. Cover all eight fields
initialized by damos_quota_init().

Also check that damon_commit_ctx() preserves those fields in the
destination scheme for both accepted and rejected parameter updates.
Use an invalid min_region_sz for the rejected update and confirm that
returning -EINVAL leaves the running quota state unchanged.

Without the preceding fix, all eight fields are cleared in the
constructor test and in both context update cases.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index caf582882f5f..2111faa58153 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -812,6 +812,48 @@ static void damos_test_new_filter(struct kunit *test)
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_new_scheme_keeps_src_quota(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damon_target target = {};
+	struct damos_quota quota = {
+		.sz = SZ_64K,
+		.esz = 123,
+		.esz_bp = 456,
+		.total_charged_sz = 789,
+		.total_charged_ns = 1011,
+		.charged_sz = 12,
+		.charged_from = 13,
+		.charge_target_from = &target,
+		.charge_addr_from = 14,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos *s;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s)
+		kunit_skip(test, "scheme alloc fail");
+	KUNIT_EXPECT_EQ(test, s->quota.sz, (unsigned long)SZ_64K);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 0ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 0ul);
+	KUNIT_EXPECT_EQ(test, quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, quota.charge_target_from, &target);
+	KUNIT_EXPECT_EQ(test, quota.charge_addr_from, 14ul);
+	damon_destroy_scheme(s);
+}
+
 static void damos_test_commit_quota_goal_for(struct kunit *test,
 		struct damos_quota_goal *dst,
 		struct damos_quota_goal *src)
@@ -1614,6 +1656,69 @@ static void damon_test_commit_ctx(struct kunit *test)
 	damon_destroy_ctx(dst);
 }
 
+static void damon_test_commit_ctx_keeps_quota_for(struct kunit *test,
+		unsigned long min_region_sz, int expected_err)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_quota quota = {.sz = SZ_64K};
+	struct damos_watermarks wmarks = {};
+	struct damon_ctx *src, *dst;
+	struct damon_target *target;
+	struct damos *s;
+
+	dst = damon_new_ctx();
+	if (!dst)
+		kunit_skip(test, "dst alloc fail");
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(dst, target);
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(dst, s);
+
+	/* Copy the parameters before populating dst's runtime quota state. */
+	src = damon_new_test_ctx(dst);
+	if (!src) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "src alloc fail");
+	}
+	src->min_region_sz = min_region_sz;
+	s->quota.esz = 123;
+	s->quota.esz_bp = 456;
+	s->quota.total_charged_sz = 789;
+	s->quota.total_charged_ns = 1011;
+	s->quota.charged_sz = 12;
+	s->quota.charged_from = 13;
+	s->quota.charge_target_from = target;
+	s->quota.charge_addr_from = 14;
+
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), expected_err);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, target);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 14ul);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
+static void damon_test_commit_ctx_keeps_quota(struct kunit *test)
+{
+	/* Only power of two min_region_sz is allowed. */
+	damon_test_commit_ctx_keeps_quota_for(test, 4096, 0);
+	damon_test_commit_ctx_keeps_quota_for(test, 4095, -EINVAL);
+}
+
 static void damon_test_valid_probe_params(struct kunit *test)
 {
 	struct damon_ctx *ctx;
@@ -2348,6 +2453,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_new_scheme_keeps_src_quota),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_set_psi_current_val),
 	KUNIT_CASE(damos_test_commit_quota_goals),
@@ -2360,6 +2466,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
-- 
2.47.3

