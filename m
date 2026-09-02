Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BEEC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFBE6B009E; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D7E6B009F; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5866B00A0; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB71E6B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A372140462
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:48:00 +0000 (UTC)
X-FDA: 85167741120.14.BE675C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB1CE40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy6DkBnk;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328078;
	b=0ZwkHonxs2DHfhl5VekavO1Qk1DjonZ3UjVzvDzS8ZZSNvRnFFb4EzoS5HJgCX70+gS0P5
	ztJcrd2CS07s+X3Am1DrQMsiIaI8IWqVuMTWdlPVUANylVe3bu/dA4rbzIw1z8XX79zvNe
	lEMjHKoXs+FhnJwPHc2RvE+d77X2z7g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy6DkBnk;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCVrTJpLa2unGCETWoawjk8AD+WeKZfpebJRiu9J1ew=;
	b=AghgpT9Sj4k/SgxBmeARtBqa/hzoKnVWEEoM+1nKLq9PdQ6QsB3t6x6zJDG2HZ6toJjycp
	O2ZYtSqvT4Gk+Q+1qdmoGiraV4runP5cDELESzJygRMiOTsI/WX7K/+4w7KvFBNrNVXSrx
	RNrAmlQ/jW+RWw1pbNf6YL7Tb4Xh6kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1006244517;
	Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AAD1F00A3D;
	Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328077;
	bh=LCVrTJpLa2unGCETWoawjk8AD+WeKZfpebJRiu9J1ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vy6DkBnkymZetvewrk8FS6KINWHWOlX1jyYBRcTg0m96UVSraiO/U0opQaAvso2ol
	 P0cfp76K+VND/mokB6TfEyVBgGVp/nDpbqhde/ht1M9WqVoS+X/s6ZwYn6OqzldoPq
	 Vm9vERApPAp5rqb+XY2Uh6TaUOchkGBsqufU4WYy+YUR8OGWiG+84iw6BttJrvTRJj
	 YJSMYxjmEmy4oY3EwX7nFDkN9q7hkpaJBvhmyfilAhiMXVZWQJ9xZnnExnkNJKE9+r
	 euSF1WZ15iwLkqCxjDpjwL12jtoknq6ISX74LXuzuJGhT0fURRvsPDL2zfNtuy+chG
	 h+GGPRoBjgMlQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/12] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Tue,  1 Sep 2026 22:47:42 -0700
Message-ID: <20260902054747.99370-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f41bsm31gxf4kthsjxqquyia6gq9ijed
X-Rspamd-Queue-Id: AB1CE40003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788328078-906384
X-HE-Meta: U2FsdGVkX1+u/YRQrsgnamOOVjREbE2CZC/yf97mAXkcai/7hXrQgcYarHc7sSjDsQmqezylOmeAFQKUnub5mRlO9Lr6s+4qoYxEb1gVrTQPr+qh2niYIlMWMHjcRNvRLhcT8QE3XGmVKosFUI/4W9e8DSU2WA1+4s2seVKwmf5U/wSIhV2TAdXqoIK+1zLP9HXFHAwEyPRjR8pm8Dhzsq5uJENs4C+3vXdKrRyNn8G39FhyOc4BwbYGJHyCoaICZHS0clDW+Q29S3hWGOSlzREz+EftgxjJdOV1DM1Wx2wEHnJq8xXx5UyBQ6o+Wq/nK1ExXCTJJEQUpYhjBTeGrVbi/dk2wx1gpjCuNwqY4XRZ0krC5lhMYMHiwxxxOrYtp1wjjHiuigz/AfT2dFSzXdCVaRmDRBcZkeilhitDeV0jz9LYO8ScmZhtDYeu+8n2vN5LGlumQjahumnGVfrKnjZdDvthLu7X1Qi3DpouKF2QYgtlmlu8XNp9rfz7X1uKzN4LX8qiRVPhWUvUOLW8T4Cm+wkPASgXt+pWEFOl0Ts72p9j7LQ4sIeirb29XFG8LWpdqBS8w7GPREmnrRDKgtIlpby2BhJSlLBFsqnaNwy4U0QvrWxh+ueYzMYsJnzgF2ra6GgOhInBhQw8NvMHCTzFwd5UHuHu2PRtGSv+ZsCRZ/+fAcAsLeg6Q7Jo+2ZJlGizuXJRF0+4FeZRxFp0Y6xi5VGQPPS1lgH4AMJnOFX7mHHYT0fhT7pAyhVVfzaavKgL8s3oHNb2OfL+YdALz0ZwylsJES1piVFXwBL3j+LPmbhiVRgVFuEZaCGMcqX5GuDIPjE8b1u+/mtbVMy3/yoZ8DcXEfPa2x4+EyT2XVTxWA+1+eEi9DdDcjU9UEGT5kCY5obWSaormOMAD0Z1Ud6y9qLsFqWTVCvfOmCvljRDrnFw7twApNrRcvECduV1dhNZTN//gc2UNKUHqU8
 PdqngNhE
 FYaL4CfxkhOy2rpIiiCF/4UGXA2/xd+t3fQ2s0XsqxWIp7zDRp/hRzOLtLwL4XCTe92GPyJSBW6tw+wOvVpCyLhU242ipN0FW39Vr/fdxyJcI4dijEB7QHBHS9x9l8IZTzN2wghHV7/FdqF7bmTt+PJ3BKx1R+ie6m3mPR9KiloDvx+Yb8kuKNv2P/U5hhzQ6y2aL1WdcNgadxVpRZxhDvsM2cEeTK/N8Qhh5RSvOcT/oyedkny4ezZYLCkE51/FZpIxOURZoDG+WP2iTwXKk5zL1Kw==
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
index a4164ac489a61..d0bed01a5b7fe 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -625,6 +625,27 @@ static void damon_test_set_regions(struct kunit *test)
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
@@ -1736,6 +1757,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_samples_per_aggr),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

