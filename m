Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DABFF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A546B009B; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C5A6B009F; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B2B6B009D; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5B316B009B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BD34140251
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:36 +0000 (UTC)
X-FDA: 84706244952.26.56BA211
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E6B41C000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwyTEHm8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=WVqmPyS1H9J/McwVDxjyqw7bcouaXlcLpLW5vY8vJuPC7KgUFqEXQtigWqmex9MOATg/jd
	Bshbz9on4GVTx9dewfgvW13PgJwQgZleWBY80ZqI9pxJ2M+gA3xK+1U/mdNSlv+RuBSt5D
	x2ufinmkkdoMJJfMMVwE9RBiPft1GKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340074; a=rsa-sha256;
	cv=none;
	b=jAyE8IGpYawlMKGAGXycc/pl+vNDvJ4wGe2pzTbcjivbWc4Pl7If85F+J0pUJPUwLwuldZ
	Oa90EYNzpEeyHycA5ibZlcUKsKsVlrQbAQC+Cu47TVmrH6JPcEnB+Iwc3OyxOyvWUeG5Fq
	bvwwDLzwoSUtnRJkXB0o12f2CElLNPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FwyTEHm8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0F1542A31;
	Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36923C2BCB7;
	Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340073;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwyTEHm80Or8EoY3Y07sV+u4M/imSwhr2NI0NYYsImWzS9cLsSA/sONsLP/uxH4zd
	 JFLXuIneV4KEm03obAG4R0/ElK0W1CxHEiI4RErdHC5yCC1LKSmS50QqmIJ1Syh+LC
	 AGiBLAjkj/WZfIJhueEAYhHfvJ1VE/HbEF6E8LMOQzWUi/CSB9+b4b5Ocu7BYnzDOA
	 t2bRTPJYgBWhNJdVKuEJqhZkwwddYM+Nn2k3r/mYk+qPUAL27mEAqrBGR8Ll5cicq6
	 bqu8yQQFy2oVO8G5gtuSUOhZMNycXJjWsOBHFF8ct6uIaKun6Dq8ClW3Ve/2yZ91HB
	 R/Nptel5v+z8Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Mon, 27 Apr 2026 18:33:57 -0700
Message-ID: <20260428013402.115171-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E6B41C000C
X-Stat-Signature: rr5ocaxj6mse969qs4nyfw3mrjcqafzf
X-Rspam-User: 
X-HE-Tag: 1777340074-458403
X-HE-Meta: U2FsdGVkX19J4K6baBYcK0pjfjPCbwu4mw0Vkd95EILk5aPgnq6hpMRjMhD0qRH14ruZtjBxpM6yZ4sdC1RSQF9JQArzBch+10m9oRWGMsTX+RO7nYzkPWqE/Oj+6hL3iJd6nXOeBgANBlBVlqy8cH2xOdxe1MW+DPrnZztP2XBtP7csEWMDIM5/swsi/3SsUD8pkJ8kqsfu4JL9slySvodo4mlHYX19xgxV8FHGxjg2WKAqqZBNJSZjo0iac4p81IQb+RDZZrJF+oj+cwCvk98wWwP3pDfZZHxKu1iBHq1o3aG+32GIdRhD1Hb8JZAL5EMgSZcGiMtG6KwnUlZ/xnSbkfGpMdzXQkYOHs7PqDKaozlKuT13WY/4YIS8Jvj7nqfUQEQiFGq4flnUOSkcVPIYiSq7arBiuuk3MvpUtFHyJWYu7ab+1kdOyMAz/BnHWAKqzzS6rfCtMQi4cD0ErA5sdHpHNMljyMPb0jPptJjYRKOtOGWjF+THpo6CuLd0oUcNNfgtuWtVFBKIs+CdAro1WpMZWcEXhdmp0Xw6uxB+8Q7o33uzeS2GIIA2RsMK0AJNwGmfBtkUTjAXMnHDvUkjaolcvBK/9c1FMbIE5fzkZNlZyBlKvn035MGtCxqkm45aZ7Aje9ReuSvP1HoKsiamFfJwGJV8DzG9S9VNh+xzO/hTAeBCG02vvxjzhNCHR+Mxf45uKdJUOzmTI6ej/PTW1VYjM+YPK+R0WMdGvu0NBnW942xzQa52O5VOxcRcphqp3a2gPTeNhYHY1GDVbE3fGZDIiQBMi4vK971YVj+D0iVcXpQqdMDHdQnUWkeF8wWKRkv75wTWOv0LrO3sk228ZbugPkJ4hRSNEJpSQ1XmJSmyJ5a2fq33hTbBUQ0HRVM1Ze5yyQKexu3w2hb8CTPiDMGBrVjiwU8Kj8+yIYzthGbJUkMwSvfuIcCgh8uevMyHx0GzLdxRICFdZLA
 fbT1EyDs
 AEmrHXW8iC9r12vxgE6JJH8VhwsJ6yWjq5thyzQ9/95nv3/cI1zlhmhMRjADLqnanr77lEEf0jlDJip20blB6rsBS36PVTr/bz2Oe9O64lSSvrbvR0Z6aLyneOp61oM7yYGTu9XETvzo9Qk5jO1ksKhMVlJ3tqW5lObGWL3JKYj8UmcukJll7XHTWN6ZOrJs6t19x2LCSQxc1v6Sw2p0r6bST4TBV3YiZEdWzfio+LHjODkTmY6jhYBo3N2ynevO+zzmwyClsnkZ1STB0CYHExK2V/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

