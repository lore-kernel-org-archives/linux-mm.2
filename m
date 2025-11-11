Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7E6CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A258E001A; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69778E0014; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B02A8E0015; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74B9A8E0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35EE4C0178
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
X-FDA: 84099201984.16.D971439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8EE64180017
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFCM8je4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886670; a=rsa-sha256;
	cv=none;
	b=3nIRp0LIf4HKkVECAmVoDP+6wTrfnQrYogR/BmXGv7MZ5RVPKE6XiNqdI2krIXYyFkAn5z
	r75tlGpeCeJG+4fRJoe36JPmg3bib6UfnBB1G1nyVmHBW0AfT64XDYYwTPcBJ7z71lOBla
	BKGnt5/YKNIy4CDZ4UVXvrF3GUZeOXg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFCM8je4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JHZsdhx2aLWQyymzRasgsH1N8ZrlKmPTHEKNBtDJFA=;
	b=FuKKbzB4L/mPg/2KVdyMQ3/YVAJSbUHriMc11ozpvwc2Wvri6/N/xiBP26vPIQ+KUz36ea
	zSmc6CahNilUxLLbuB1fWdJmfNpMsnTfA9j2XZI6UFYsZLs84V6u57AUg611LNn/8w7f0f
	FPjETacXUneoha4L9hccYRhxtrfnNXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6918B446D8;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D14C2BC87;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886668;
	bh=6GIRF1VPc6ujIgCM/hIhi5fTx9G4B73HDb3fviuhNMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFCM8je4C6B8TLyL7WzV8/bGwLWLzPgT822w2nvlMY50AJZYGbB6t8uoSVpVnbIxC
	 d10Q8aC0D4hxUdiFtHVE7xWbgZhyDSnYAQjnHbjwPx37VYOmTSla5T0oWc5s48MOSz
	 o5LNlQi9tG2Lk6ytnC0BlIoyj81nnvdK55vxxjLqFyUIZOKYDJqGk8z3/ON2y26JYK
	 5DiDCgwzcI7aMsjI8mWklr/ilhQlz5aXFXF3F2HoaOidO5mn9ICyNvOijSLcMHX7Oc
	 oR0xVxjnTsou1ulG5fkQpUSzgbcE8ijCK6ne7moUh2GvRa7/3Dytm/q6E1IGZVwTjE
	 1E6BX/ZtLAA2Q==
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
Subject: [PATCH 05/11] mm/damon/tests/core-kunit: add damos_commit_quota_goal() test
Date: Tue, 11 Nov 2025 10:44:04 -0800
Message-ID: <20251111184415.141757-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EE64180017
X-Rspamd-Server: rspam07
X-Stat-Signature: dgw41k6akrhxgs6tnc1pogwzg517p5wd
X-Rspam-User: 
X-HE-Tag: 1762886670-331682
X-HE-Meta: U2FsdGVkX1+dPjH693nFsSnu1DclnM88tUSVQuhSuAfVB2onFMbAonBXNCoFMsu45fHN6vcDnCGNuX3uNbjaIUXx3FZXI3xY0VT1tUHR0XdoNKD0Uu6aX14GcaNQUoijbNLRCT8lWGXVWwJsAQ0ha1fNtX9D2NEe+pEv38zzksMTvm17szT7nMhyH8jgkYkoJIyHQ2tBG8GJ5l3WamvKNZFNuwkDZWtlTtxdZJ0O7Y4IfUK+7fECYdkS9m42gQuCuOUkHVPrZr21YKWdsbtO6OuZ/biILPtZZ2gdAmgFmPK5yNcRkUfR/k0f94mxp2MOwH+Be1Gj2Ktanko9aK0LNrq3Pi5jvc0nn/8fzf1qaXPZXWq+W95X2TccmdxOeBpzWnBtq3VPLcQdGR5vk93uK9sX3ATIG/wuWJonbGJp2LCpICNfD8BX7pH83Pr5MKQ8ISix6h9QizqwljJym5XJU16i/u8p2MBKPUmuLoGwi5myAXQTckiavBt3HdJPnK4XhgIO1VproKD0M6hKKcNMKGX4tiS0FdZlbUkLmhbQ5Iuehw20VKJhMUTAMgyONlEUUGaJKyVfFE5gxdiiKRVd/FXR7MC8r+xcV3t0YVQCsp4DLs1GuJh2J/ChrCh3yjnIfQGwlQGvVpE3+dQIsLTDhoxEpsCviiJ+pTj/lPVqawae9Z6ylZaUkMp4ELkmThLvpayjU5R7ATnLUpBeyKAb7opvd4EBZIfhu7J00lchS1yisKEs9wdVgcYbHF0M8oyM1f4LUNOoXnuqf9Sx2ApU0gYKjGhjXFP5/cJQbZunShituyaPjXHr81S68S/+gXtudckcvvDWhH+nyR1T4x/2dqzY8EWh3IngKD9aNNlCygYgA7vBBx1YW/EwkIbdV7C/b5qh3WJWdm15uohF1YwHy4FO8HUm+mAjkUp4V1ujkQH7Ifod0kBmY1voeE/WHchZ2crWzksyBiS+JjkHGLz
 qmGxj0Fn
 TzslcqagS/HgDNgSaOSDyruFWL8eqBL8GMu7aMh/1hV3rJb51/evugVf2dZtRwjOPtu/UdmaBrvG6jDhCwP0iKpSiW+iCcAslSfBekDpeIHUYR35DNTAXKWrjG4n7V1fXRrbxCBBT9a/Caa86xLez2NbnHSJVjLE9BBJ3fIMcj6On+TRrpN8Jv96HCe+cCg9iLr5kn3B6Tu7Nii/cVjsmZUHQ1OGT6v4IxSAEqQK0lExQBdR0Lag/fq41HhFJVt26X905Cjcw4mEpAcT6WZ/11Lk4EA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new unit test for damos_commit_quota_goal().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 84 +++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 2770972b0a39..0fdf9c7eedc3 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -497,6 +497,89 @@ static void damos_test_new_filter(struct kunit *test)
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_commit_quota_goal_for(struct kunit *test,
+		struct damos_quota_goal *dst,
+		struct damos_quota_goal *src)
+{
+	u64 dst_last_psi_total = 0;
+
+	if (dst->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		dst_last_psi_total = dst->last_psi_total;
+	damos_commit_quota_goal(dst, src);
+
+	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
+	if (src->metric == DAMOS_QUOTA_USER_INPUT)
+		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
+	if (dst_last_psi_total && src->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		KUNIT_EXPECT_EQ(test, dst->last_psi_total, dst_last_psi_total);
+	switch (dst->metric) {
+	case DAMOS_QUOTA_NODE_MEM_USED_BP:
+	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		break;
+	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
+		KUNIT_EXPECT_EQ(test, dst->nid, src->nid);
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damos_test_commit_quota_goal(struct kunit *test)
+{
+	struct damos_quota_goal dst = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = 1000,
+		.current_value = 123,
+		.last_psi_total = 456,
+	};
+
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_USER_INPUT,
+			.target_value = 789,
+			.current_value = 12});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEM_FREE_BP,
+			.target_value = 345,
+			.current_value = 678,
+			.nid = 9,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEM_USED_BP,
+			.target_value = 12,
+			.current_value = 345,
+			.nid = 6,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+			.target_value = 456,
+			.current_value = 567,
+			.nid = 6,
+			.memcg_id = 7,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal){
+			.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+			.target_value = 890,
+			.current_value = 901,
+			.nid = 10,
+			.memcg_id = 1,
+			});
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal) {
+			.metric = DAMOS_QUOTA_USER_INPUT,
+			.target_value = 789,
+			.current_value = 12,
+			});
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -782,6 +865,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3

