Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA42C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555836B0093; Mon, 28 Sep 2026 04:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5060A6B0095; Mon, 28 Sep 2026 04:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5E36B0096; Mon, 28 Sep 2026 04:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 108DC6B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:40:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F1C616010B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:17 +0000 (UTC)
X-FDA: 85262524074.27.911BB43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BDD41120004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ouiy1Hwy;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790584815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvJUQAwtTUqWjCL+OziAjJmsBq454CkzwYAl5nK+x/E=;
	b=vzEUXXHlCULhoBlM5gNYL8dinfrnMFljWUFkI+2ETsjJx1p1eA7ZOXPwk1lHlyTcdLsgmK
	wAwD+SjHjg2wZAPug0O+uE/suaSCGkRJu62CqWYRk0TWdEp8JUtp3pKlioUIAyxaHSD/9n
	xt4jsIMZAUcuyG9N7Y3PoJhHMDPRbqs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790584815;
	b=cOe9QgjxmlRugJtHjrhJV23b8KakHaIqtsGPJGYK9VRjzFW830//D+d0vT5ryzFE+ZTIoF
	gW7zXmDqw9//Iv1AXAAz/FLW5lli3KwApF5xGuDap1GoLIsiME+JBSX7CdhTabXEVMclKN
	Aw3+cfPXq4jfneenVbpaaoXdaCp+W7U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ouiy1Hwy;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16B5040981;
	Mon, 28 Sep 2026 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87D31F000FF;
	Mon, 28 Sep 2026 08:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790584815;
	bh=QvJUQAwtTUqWjCL+OziAjJmsBq454CkzwYAl5nK+x/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ouiy1HwyCYaUI/6+irBuhHecQHFC48KigeHFwfi3HT7ohp/BjmgP2sISwQmFwbJFJ
	 puXwxpH5Bs0tqz71RPnr1CvC1mP9jwoGQS4+iabRpSQVjjq/Q24nu8+gwdQryrMxPx
	 9ve+/1vbmjl+EMKLgoUkMsOGnBsKm57LfGJ9BN/j8PMglicbrGNF6PPdGzFyJiEe7a
	 aJ480RSA2ChAXIv9eb0eklGnB1ljkv8J/t2l8gmAyXDuoQqxqcqrPa9Bf1i2UZwsXZ
	 6mvC4WziuAsALJLULuawfQofcBmlquxcj6BxgXt5e5BoIk1Gn1WdTm+2FqrHDliXzV
	 grEBSYpFMEAPw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon/tests/core-kunit: test PSI goal values with explicit samples
Date: Mon, 28 Sep 2026 01:39:57 -0700
Message-ID: <20260928083959.4030-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928083959.4030-1-sj@kernel.org>
References: <20260928083959.4030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1z896foug6g6u6emjt4cpybm56e6oecm
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDD41120004
X-HE-Tag: 1790584815-944410
X-HE-Meta: U2FsdGVkX1+R4Kaj6hbl9l6q7Sp0OsR3/x+WmqxABJWEMSXjue3x5THP2Sh8Cjr4TGy82ueApA83/GNeHAhM4EUy7ZxE1bbnprerqM9r9eN0OMN3AvWClUzxvyduDbGKDi53S5BLmi1uPJPny4jL6vKMT58gwtfBKPTg4f4nDCo3fMu9sgyL7gHvHdF6bNC0HyfdFVgNvBwrgtrgg+odvfWStNT+4lSbrTdL0lBo/FpsKCPWfsiRvXpDlJo/yf0Lkblxc/gqgqO/yw1qrbVYCy1cbkv2pxNRUrqxFvC+L02oIHO5nAJbHdndZLet9S//XK+DE+bmtBdWTTzLHFTqEnlW39c0NwhVJupxGLpA3Qnwdh3GTXtb/LE+y/7vke87MFOoOgZuFgSHEbS8VDwkdCVgqKKSgXTOvDlk5zcpIqA0phReTILzTRvnPAeHNYVVtEB16r/LIl8TfjDUpDI8kt30G03zTHTSFkwImYDCaRUV656qc+iGzcsyUzesJ3y6j0/h+JT65s8vNdkYb91PPgMgwcMuzGREkvg4NiB0jXo3tfFYxRLfLQrc05RxZu9dJVxKSaBy8A3qyFOUc2xABUvHWVtfBY+tccf8+TFcw3bWWyHbbzBR51hZqkn3cf0eFGoaXunuXDQnaGk7wu7YbHrzNvG3n4rmrSRpInVyZZKbN2pY1DiRk1wBLXz0AwEtQtu36w5FE4Hqo3tarqWAZXpJaDyvPoMAAN7XrJX5N6wHeZw6UnK8U8oge4r6jdGNX4rms8Lo6ei+QWYrFgLe/QyKAvq/rRwS+YUHIdYVeB3uo8J+cWa177nMUbBM3GrqjoqUHiFDUEHelNLA/snykB9M7U60gkM0XZcBeFh4qfhnYRkq+XOzWxM8hjNkTamCuzwXIYqQzlQ0pTQMhwZKAKj0JlkddBvFr5s0H3+CPqtwklLAfe4h3pkrf7lKoaNkPZHrA5gbo2AQoI1pUyZ
 3VmS/5ks
 EUYSZ9Ss0rLKNEDY5f16U1r3OT2n27L4zBymX8NS8A8CB8ejAVeHcVJ8JFS9v/mhl09k/1jgc8Z1d1gfBd+n5t5zgioL9PTLEaiGZCsa4gfMaZXTAoPU//ZQfdiKvHEcwIyePvy/X7NsNdbiB4/u39I3cgGP+yc3aZl/plLdo6l+avDi/CrJXwQg/Ux8xPM8A2TPWEvsbfVK8t0ScboVksbNT22yIRLIRiGSscqV5gAsoBo0cixjr0l5huNckwZZsN4Uc3zzCQYM6CZWz40Nm8YVNBa+SOXwn2VYaQxjRolBzzrw7oZSlYS63puM3+HGea7BGnL34yMEoE+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Karl Mehltretter <kmehltretter@gmail.com>

Test the PSI current-value helper with explicit totals so the result does
not depend on the test system's memory pressure. Cover an unmeasured
consist goal, unmeasured temporal goals with zero and nonzero effective
quotas, and measured rounds for both tuners. Check last_psi_total after
each call.

Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20260921020013.33105-1-kmehltretter@gmail.com
- Collect R-b: from SJ.
- Split out from the series.
- Rebase to the latest mm-new.
- Delete mention of old behavior, as it is irrelevant for commit message.
Changes from v1
- v1: https://lore.kernel.org/20260915060937.3423-1-kmehltretter@gmail.com/
- Use the previous effective quota for the temporal decision, including
  when it is zero. Keep resetting last_psi_total for new and updated
  goals.
- Move the current-value calculation and last_psi_total update into a
  helper. Test both tuners with explicit samples and check
  last_psi_total after each call.

 mm/damon/tests/core-kunit.h | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index df84d9cc7d20..ef4b8b85d67b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -910,6 +910,48 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			});
 }
 
+static void damos_test_set_psi_current_val(struct kunit *test)
+{
+	struct damos s = {
+		.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	};
+	struct damos_quota_goal goal = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = 100,
+		.last_psi_total = U64_MAX,
+	};
+
+	/* uninitialized last_psi_total keeps the consist tuner quota */
+	damos_set_psi_current_val(1000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1000ull);
+
+	/* initialized last_psi_total gives the delta */
+	damos_set_psi_current_val(1030, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 30ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1030ull);
+
+	/* temporal tuner keeps a zero quota */
+	s.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL;
+	s.quota.esz = 0;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(2000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 2000ull);
+
+	/* temporal tuner keeps a non-zero quota */
+	s.quota.esz = SZ_64K;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(3000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 0ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3000ull);
+
+	/* temporal tuner uses the measured PSI delta */
+	damos_set_psi_current_val(3250, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 250ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3250ull);
+}
+
 static void damos_test_commit_quota_goals_for(struct kunit *test,
 		struct damos_quota_goal *dst_goals, int nr_dst_goals,
 		struct damos_quota_goal *src_goals, int nr_src_goals)
@@ -2260,6 +2302,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
+	KUNIT_CASE(damos_test_set_psi_current_val),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
-- 
2.47.3

