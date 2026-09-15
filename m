Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA41C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916906B0093; Tue, 15 Sep 2026 02:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2446B0095; Tue, 15 Sep 2026 02:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7903E6B0096; Tue, 15 Sep 2026 02:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3981C6B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74EAEA0334
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:09:51 +0000 (UTC)
X-FDA: 85214970582.29.E5D5C5F
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5D7710000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:09:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mleiOerK;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452589;
	b=nOmEiDTEmZTHj943IupbB17i9TZrtGW+c+GlshFpqCcRpy8v4d/mO4hBkL/bBipSNu5Ndi
	fzqaHhX5RZgWU/gQ/UjvLmDiWeh8CEDszjlLFzs/ZnQN2lHPNEMm4deXeZQsOuGOHbkOgF
	3ZMY6I4qSJmqhwRVdFYX1O3cVy8sF2Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mleiOerK;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17npcWfNhvbB0tYfjU0bxEFrefgovxZItMHI62tmYzU=;
	b=gVYJ4zgA/u6DThIWv127xLgpIfbT3mP+16eX/fg4rIHNa7fWFxIBR/vRZQjYzndcvdrcKi
	q4yhM0dUeb5aIno/kNTYaDfxrNUjktvCSfFLQ9EiSg9ng8bdBrhLtgxxCdxcZ8m9TF4w/w
	DAFQd7hFhZVRx/0IZDl5SI+y8nGkfOs=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0e5dso32712365e9.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789452588; x=1790057388; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=17npcWfNhvbB0tYfjU0bxEFrefgovxZItMHI62tmYzU=;
        b=mleiOerKKdwwqvPOT8G4q/kt8uOtpubylmmwC8aJt3Tpfc3WzF2Tdm1JsDUPKGulkt
         UtyHxXsHGumgA1tI2n80h0hQE96SFrnVQtXyx0JX5wPhpXa4H8bEmRfVB/zIBdYYEs97
         wr5qlpkmWtGQLxkCHbTdKp28+gYOEGDYUw6d0HQas4Ubk11yIpxHLsH9WOwEJDEe+9c5
         wTwbC9Xr/CZFoEzlzetf9Bpf57fGiLPeUJYFrAfDy8wSgdbbwDJn2CSfRiifb7dKQ/5L
         5Bo+ySLvrBvoM8RmJKhxMAbtc0HY2APDVLYoW/x67kmxjKGixNW+Qaw59yXLWfPqKQ3m
         k7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789452588; x=1790057388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=17npcWfNhvbB0tYfjU0bxEFrefgovxZItMHI62tmYzU=;
        b=Msif+z8tTap1aH1WLNy0DlSQ9Tq13UuAdBLAON66322hP5SyG5skII6vOsgg31h7Hw
         nTcuZ7i3LXyzBA+A0i4eLXLn0eOVREKwcINdVZawtiI8xBjFAKd/o2YsXY0ZrS9ITkNX
         zG/w6IUMRHwjm1hxS08o61b4EqSckCxxH7S9CwMoN1mIhxvEqZez7NFXOK6QlHXwCOnF
         DGl3REGNGxrQ4CTGEhFaGwVeyGl9bI+qdhdZkoHP3TxhfF8DBV2/yqdwq8d/O3j9OHIR
         v91MPPBN7U2GKrY2BCM6uReQp2vlgMDfy25sOcnGAWdBdYNT3sm9sjaw+kJhgnrnOgLs
         Gn1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwdV2KD6FAXPUIIztMRZM0460JPQHwfxyyExG1w3aotHRMPcWaqLoeSH548dbVmcquOM4g3rNAa3Q==@kvack.org
X-Gm-Message-State: AFuF++n/W+815ctpKpVH7dnNt7HJQdDx3W2BZuRi5AFcGsEabmY6WMdT
	4FIWasXEYjxvpWVtsZSuKU/DgauY8qx3R4t9RtTA7ph3pXhewURjfA1m
X-Gm-Gg: AYBFou3lvgJI05qve+Y5b3jXEB5cLn/2OV7gtEDFzeZi9tTYMSJvhawwX1cJbA5V+7e
	h73ulp9ZpuSK+FjgtaFXrNOch3/WWccbAER5ugIGWB7fZGNf72FgeL29U+vkUmna5KKi1LSpRgn
	6QgEyhdD8aRamKFbLTdaPjvt3GtVVxbLSDZX22sbouagzu+1m+hWB7hwQVvFVA7izhep3OTD+G/
	8WS9VdGIzke7kb0ACSkOQa8wATxgA9Qhshc6Q/KYdOn71ZVJ7tJ8PlG+B+hvcweib4rRvcAPVwG
	WJiqLvxw3CQdTgVsffmAqa2ai1JjjPYNOSfzlss+hOiFoSV2/ArZghwxP73QnsFeg+1tst4tJWf
	7Cd9QXFJhv+J22GyHl3ERAKGOyXDVdXF75k+XNT7n3XC2Zv/3RJCm2NGF2QzJ+U3kdc7j0z4UX6
	popkbji7AxRLbCAqzyvO+Bm7X1zVPDhlWfF/Qsx6uSfHEiggzR644MC7dHhne2hczSbN6bym5P4
	XO/gMLs0BMrvTlSHkTTfJa6g50Cxw5KJwctyDKeeQDTBhAY8a0TvnOtuAtwKxwPAtTqY3CUAxo8
	pMhQWFUupTsRQreTDHIgCRvtoouIs5dLETezUYpNC+8RMKSqTeMY+ZOXFFMzXE43uma4EF9LF1h
	Cps3a99+AuN+Hxhoh
X-Received: by 2002:a05:600c:6297:b0:498:943:ccc0 with SMTP id 5b1f17b1804b1-49e7a654dfemr129105045e9.6.1789452588005;
        Mon, 14 Sep 2026 23:09:48 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-afd5-c801-cc65-9ba1-765b-bff6.310.pool.telefonica.de. [2a02:3100:afd5:c801:cc65:9ba1:765b:bff6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7d27c88fsm44282905e9.2.2026.09.14.23.09.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 23:09:47 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/tests/core-kunit: test PSI goal rounds under the temporal tuner
Date: Tue, 15 Sep 2026 08:09:37 +0200
Message-Id: <20260915060937.3423-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260915060937.3423-1-kmehltretter@gmail.com>
References: <20260915060937.3423-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5D7710000B
X-Rspam-User: 
X-Stat-Signature: gphmfq355godrxbkhjce1cukr5955jiu
X-HE-Tag: 1789452589-703282
X-HE-Meta: U2FsdGVkX1/45YVuBg0wwdprsohILb0XERYDopMAzK4fdubtO7aoscM2UFw/x4Uxfk+2/yktaAAvMlzV1Qz3okDirzJzrS13jxOd29pztvO0aG4zkOPhdMtkGIe6auDFEB2GhAGtuse/AF8IdLgozJVn1ojcUa0yeXIThFehUpRVOGZ8aapMcMw06uzpwa2LjxUVVSaSxnJ0gTv8+ZZ9/tN766GbE+DcejnnqL4Vr9r6pVDpmMwzDsZoXpViRoGqW3q4fh/POJ/ponC47IinheHM71zUgPJVYlhjrVlCMl7Bult9JFf/Hyge30uvgFG2wCyomMKVDwHww0LH/P9mawMgZCGfvU0Oc/j3BGRGvCSq+myrGxocLtrb/xpuigVi1b5PdV1UGJExm4TUgQXV+oJIsT4GfcpSDL7gBtmv1V7ceJhglAJ0aVT+XGqL6jBVdM9tuHXQXC4ynVApgkNJK4BOAJc3TFuX94TGkGpdbSeuDOiHxDU1NRwTf6WhAyGfo39+jWlJEROoDbn+9UNnMadgnhbsTA7HWZXydXC2b6L8OYX3z/5W7fBUtIpU7r7F956dMI+ZnZPIHfzWc8/REoov4PtSsmk29bCB7Dmx2M21p3V4GwIJdMQxKCNcwzGWcLCBPGfkdkMPeyuUPk1BlciDmakJsZwqYTRKpwXdeMPx6aztIF4ZrvBfdcqZgJviRzdw8LBl/zgESE+UoHZGgLmdpEm855AJzHLT7+gN+Cab1o1RfX+gv6HZAnVoJ/xkCpS3ANu8idiS0vsBjl0p5zPk7s0/CbzLzyt3xNrXxNNh2jdMMs53u/xSGxRM1VOuifigjTNxhdLhKE7mJRlgphGqq0cTg8XPHpO7xRuVq4goaw43U8yYliLNtf0pYso2pH09iYsAjLhHSho6OHcG/jfTX0DjwxoXDl6b1jSN9nTCV2p71vLGxMqb2yOlH/tgNGUfOY8EuLK9GGyCeu4
 PGcQwD4l
 b0ugw5jWIQ1gB8z7Usiy10P7v/w5DRk8le+5oYvv2PaOdAdW2zB4HDYKncDlzGbq4Bu7wtToAdPdAca7fDQHWQyXWeNJi7lECDErqgoHDoFAibBpu3A1POLNkntiZjhceR4jLaeZtHw+Z976a3/Dk1Cz8bjxUWfCaDpZCzbALUXs4WFJ/RGjcaaSzCL/s3yjRuVg18Yjydc+4kWIgqJmfV014eWQWVAjw/5JNQp4TztN1Y7sJY57mXmY/qax0UiEtf+PtJztL/xajZjLtq/ajyDZnhQYJPPOcSJWnPztrtJAkqUdIxTNXCd2UX7uJI1esP0MF1muzNHSNzSYjLkR/a2RbJljDp1htQ5OEm4vA8rAXhSZwaP0fog+xKj6b1FVyoTGymvXwFckPGEM/MOAavlIe/9cZ1ufKVosvdu/OGh53qddj00xbTsXTQe3zdfymDDrCYoUOOFqau8Fw18bkuBNDgh2wSeZvxTUvXhx4taitaOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exercise a PSI quota goal under the temporal tuner on its first
round, its next measured round, and after a goal commit. Use
ULONG_MAX as the target so the goal is not reached during the test.
Then check that a measured round which does reach the target sets
the quota to zero, and that the consist tuner keeps its quota over
an unmeasured round.

Without the previous patch, the first and the post-commit checks see
a zero quota.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/damon/tests/core-kunit.h | 69 +++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c01e6a75cadc..2b9b24ce7dad 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -889,6 +889,74 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			});
 }
 
+/*
+ * Unmeasured PSI goals must not disable the temporal quota.
+ * Keep sz * 10000 within a 32-bit unsigned long.
+ */
+static void damos_test_set_effective_quota_temporal_psi(struct kunit *test)
+{
+	struct damon_ctx *c = damon_new_ctx();
+	struct damos_access_pattern pattern = {};
+	struct damos_quota quota = {
+		.sz = SZ_64K,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota_goal src = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = ULONG_MAX,
+	};
+	struct damos_quota_goal *goal;
+	struct damos *s;
+
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US, ULONG_MAX);
+	if (!goal) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "goal alloc fail");
+	}
+	damos_add_quota_goal(&s->quota, goal);
+
+	/* fresh goal, first tuning round */
+	damos_set_effective_quota(c, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
+
+	/* second round: last_psi_total is initialised now */
+	damos_set_effective_quota(c, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
+
+	/* commit a PSI goal onto the initialised PSI goal */
+	damos_commit_quota_goal(goal, &src);
+	damos_set_effective_quota(c, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
+
+	/* a measured round that reaches the target disables the quota */
+	goal->target_value = 10;
+	goal->last_psi_total = damos_get_some_mem_psi_total() - 10;
+	/* U64_MAX marks an unmeasured goal, keep the sample away from it */
+	if (goal->last_psi_total == U64_MAX)
+		goal->last_psi_total--;
+	damos_set_effective_quota(c, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 0ul);
+
+	/* the consist tuner keeps its quota over an unmeasured round */
+	s->quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST;
+	s->quota.esz_bp = SZ_32K * 10000;
+	damos_commit_quota_goal(goal, &src);
+	damos_set_effective_quota(c, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_32K);
+
+	damon_destroy_ctx(c);
+}
+
 static void damos_test_commit_quota_goals_for(struct kunit *test,
 		struct damos_quota_goal *dst_goals, int nr_dst_goals,
 		struct damos_quota_goal *src_goals, int nr_src_goals)
@@ -1887,6 +1955,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
+	KUNIT_CASE(damos_test_set_effective_quota_temporal_psi),
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
-- 
2.53.0


