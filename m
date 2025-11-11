Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC899CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96628E0014; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA80C8E0018; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F9B8E0019; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9EC8E0014
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AC83138EA8
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
X-FDA: 84099201984.17.6B22922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 816F3120005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQWlzsuR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886670; a=rsa-sha256;
	cv=none;
	b=lE3wLxN3MsZHFZK5aWhcQVoA/VwTY0AisNIZv/zjloi9CMCFnbgHskbU0dAiw06DVAKc0Y
	D6ItFJa3BNrjRNDvtnE6oSfltDLq4Zw6rsz3AGUIa9lvp8WtI0Cly7MLmQvExW9YkGzeBg
	2blSAe7cdE2GfqqM+rwsJNJBwIyxnx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQWlzsuR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MavVrathqgS2MHoHRAtdttmeQQZdGyAeS/vNBq+z7Pw=;
	b=tRNfpd4u/Ptx2KxZVnpNoNZJZtE/bOPvvc2lophPC7qVXns1a9sbZDfUMkVc6PLJ0QE26v
	lnp675jhDGxO6kmSgrYvbKrLyZTQuw0OMboEyxpxV38bT9Kt6km8fvUuzzxppUmnz1BeyM
	uIprPsRX/wV3EY6h+YPAXI1fr2GbSIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1B08446E5;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A02AC4CEFB;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886668;
	bh=MQs6Y/Ot6w9U45Nl0r78HMyQFGLOFhpfSPQUVvOaEtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQWlzsuRWYrl1E2RWLvBQDFRbGxb+uIKfxtaP82qW/+/iTPUYBJSSHXvj3tEWsret
	 0iE27Jz4WI7y6LkrJT5NRSWj3F2LTF/dtjFV+rQ4OwP5nwEhtEzuSOF3jZgVSMYrIZ
	 mr0E2hsfrcWA4yleupkxDejpHH+yQfTmW4MI3QimBIYWqTG85KUgTR6AMBj5nGr0nY
	 yyowd4ZkMMutoeiJ573OIVjopUxKJ+FKpLMAaqJPJ3nIZf8/vjwVYn8L5GuskpliGN
	 Bjik5X7nCG4PIhbsQYUJKx9DWxaZxQpyqQYCAjdpGB/iZr9kCPP9p6w1ljvpN3GBln
	 EORRV8vuf+tVQ==
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
Subject: [PATCH 06/11] mm/damon/tests/core-kunit: add damos_commit_quota_goals() test
Date: Tue, 11 Nov 2025 10:44:05 -0800
Message-ID: <20251111184415.141757-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 816F3120005
X-Stat-Signature: so5drc75puatu9ka64ji3k1x95tgptr7
X-HE-Tag: 1762886670-316745
X-HE-Meta: U2FsdGVkX18Q3Jo1lfdZzleQC/acCmLkKpwvuUsr/Y4VnIitqLtzoj7QZMDq1kt3AA2mHNvoEjDHA+c2nMMPHOUco58Zta/7fVCNC/bVX1DGqj2PK+SNR9fuv37iv+YbxNaReExyO5+48bI5nvv2tQQYO8fsGMT6q5nX3SYSY2y3mD6hyIG6BjMRHVlhfSlCkWKKqvZh4J3K/tYvDglrQ1Ro1eVqgxRdFBwGWxc8scjYLZAfW9JdN2Dc2OEB4kM1ipa/CxtavKd4c04NuncRs7L+rZNS9PaOQmvRGJNarpLtPBtUM0PjqZdnDSEbmzS9mHTvCJvVbbgsVpys8ntamZGyO996urTTLabm+fKc2w+ahSho+TVx6whzEN499w6MAU7RnY/+rX4K6iLD2+ib6xmkr0nI3MbnpKcb8AjuaMFkliQqBTZTHDZ8WKXJPzdfJwqCWE9r6UgWFt1LAJ5zKaf2f0UVtX0DS62yy6I6cKQDrDHHxPO94GtxvcggTFrQoT4YrSfktOiPwN/EivJBfpdcgFJyiXXgfmjuPI5h9z1n9lJ1LZqKW/lJHDocVxGefcBJ2ldw85Jw5MKx3AFpaukdWrs68XMbYoBYbsP1xwoDspjcgcVEjAjhgR1xpiUFuF8ebbezGjBuvCig/s0XnmOgY6kLbjuBXDs2meTYDlZVrUdTW7fqrtCzOPDZVwebxp7vqAm5N1ZngMK3TrClOJ+EXKb7Cg8mVfh/dlHpjh9N4HDZMhaF4WjPXPSObk+PbCvaGALQ3cgfUZ7r8Mgc6Mn9RGsvYpZiz8lvEBKcOzlUwn9s9JjcoJuWp1eNU8d2mXGpPl6dWQwFgAPHLNy3iNoIcVj/Xm2wOeFDe++i4QqYsbNuEsxKLtGjJ2mwYiQyLpAws46OXbHZFR03btb8JIXcLWPs0EPhgN63C6fV5t8NcDkf9ibuVHllXS7Q7IkyL8qLODCuY1YzLJ42TW8
 lPq9ZMlC
 YESPkeSyBjv6P1k3vyxhyAa+v8geHNcnnwOkGsbdLvxrNP/kImLQE8YfskrslFp2KVbP+biqnPoMvtZ8bm6rDlIGqNbiv0e5v7Lb6Pr502u5WkiUxDKlAzsOAjmr6bARrTXRJWpBPz39anYGawuVvb//DoYDvLE61nOO4LOq9xT4RdVETMxqgFveRALfXvPjGdLBZQiSYswK5DkQPVvCS7Guaf8TJP7whwVxasOG6X6WoLgxoxWsTDgqOZ1XnD5c/B5MA/MbNsERN7gZQ2VXCHzCrdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new unit test for damos_commit_quota_goals().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 81 +++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0fdf9c7eedc3..3abf31fb1074 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -580,6 +580,86 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			});
 }
 
+static void damos_test_commit_quota_goals_for(struct kunit *test,
+		struct damos_quota_goal *dst_goals, int nr_dst_goals,
+		struct damos_quota_goal *src_goals, int nr_src_goals)
+{
+	struct damos_quota dst, src;
+	struct damos_quota_goal *goal, *next;
+	bool skip = true;
+	int i;
+
+	INIT_LIST_HEAD(&dst.goals);
+	INIT_LIST_HEAD(&src.goals);
+
+	for (i = 0; i < nr_dst_goals; i++) {
+		/*
+		 * When nr_src_goals is smaller than dst_goals,
+		 * damos_commit_quota_goals() will kfree() the dst goals.
+		 * Make it kfree()-able.
+		 */
+		goal = damos_new_quota_goal(dst_goals[i].metric,
+				dst_goals[i].target_value);
+		if (!goal)
+			goto out;
+		damos_add_quota_goal(&dst, goal);
+	}
+	skip = false;
+	for (i = 0; i < nr_src_goals; i++)
+		damos_add_quota_goal(&src, &src_goals[i]);
+
+	damos_commit_quota_goals(&dst, &src);
+
+	i = 0;
+	damos_for_each_quota_goal(goal, (&dst)) {
+		KUNIT_EXPECT_EQ(test, goal->metric, src_goals[i].metric);
+		KUNIT_EXPECT_EQ(test, goal->target_value,
+				src_goals[i++].target_value);
+	}
+	KUNIT_EXPECT_EQ(test, i, nr_src_goals);
+
+out:
+	damos_for_each_quota_goal_safe(goal, next, (&dst))
+		damos_destroy_quota_goal(goal);
+	if (skip)
+		kunit_skip(test, "goal alloc fail");
+}
+
+static void damos_test_commit_quota_goals(struct kunit *test)
+{
+	damos_test_commit_quota_goals_for(test,
+			(struct damos_quota_goal[]){}, 0,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 123,
+				},
+			}, 1);
+	damos_test_commit_quota_goals_for(test,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 234,
+				},
+
+			}, 1,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 345,
+				},
+			}, 1);
+	damos_test_commit_quota_goals_for(test,
+			(struct damos_quota_goal[]){
+				{
+				.metric = DAMOS_QUOTA_USER_INPUT,
+				.target_value = 456,
+				},
+
+			}, 1,
+			(struct damos_quota_goal[]){}, 0);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -866,6 +946,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
+	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3

