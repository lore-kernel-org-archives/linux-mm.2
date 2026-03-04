Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF98EEDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B186A6B0088; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74F66B0096; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F0A6B0089; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEB56B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 247A41B7EE9
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:31 +0000 (UTC)
X-FDA: 84507131982.17.2001C83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81368C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ONaNs8x3;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt8xK+Sw9r/mpwVItGLgj2YmM/lx6bc/s+2nlO04wq4=;
	b=d8GISDTRVlUHjjOJoHoqVMBf9GP1N7ylnZfp9vsOScS1RWrd5UmRtb8WcAWgrmr11l4rmA
	pknzI5Y9JKfslzzOKtSRmyFyRzEKYFAMqHIbiUpfrM2xbdlAT8X7JrY+iugad4HibPBH2J
	VkK6dEYC02CX0E88rMe1Cq+kFG+1yd4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ONaNs8x3;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599289; a=rsa-sha256;
	cv=none;
	b=wJyD3kP9MBtlP9PTnTIEwd0zEQGjGPDiOsqzSD6kNjuYpL5kZoMagY99E6jYhCcPxXDKjm
	F0RXhBNXuFLPMAK4ynQqnIx2Yov854ZrsOljzHYQtYpg/nw/mNER0CgMC6jHOGMdDViuif
	4DUzsa2bwaxDB1C8Vus6eIJRoq36o2w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1099444DC;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A9DC2BCB2;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599288;
	bh=QHI34cc7GPySMrww748vR+nu09NVGXEeGECMJAgm4jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONaNs8x3vsqddIqGapimPOCja1sezVwIF4WxYgGdeYG+NG8zNawDZImfrPTY1JbJU
	 c5rP/KE86iJpVugDN4qKf2PpnLakeN9DMIQYM5y34jAMIeJU6Jk3wyGjVvT+wdoQH0
	 0kk37hPC8zooX3XBqPFDSu2mhFlVB6R4Mr7ShghG1BYSf/zg2iA1sBRm7uEiEBHchX
	 oWbrEQkHf+6d7s35Q2Ikq411qCiGPUQUZo24RZUaihUxQepoxp6yOjSQUUDUjjVV0F
	 AdfAcI3hUTaFZn1vX+QBKqiCkZ02m+l9oUTqVFf66WJjvNlTA5c+7EQc7ywxTLg/Uo
	 NRngNd4otMCiw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/10] mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Date: Tue,  3 Mar 2026 20:41:12 -0800
Message-ID: <20260304044122.79394-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81368C0002
X-Stat-Signature: 8oiwrqxa8wnci1gnj9rmqhfsiitbwqk4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772599289-509752
X-HE-Meta: U2FsdGVkX1+R5UwkLWF63W8Klo8NbHWHwEzh5GPmgtQ43nkeNw7dtRkgxPb52tSaVvVnNH51VKMt0cjGyqvwECGoGMaJ3DcUQXQiuTg7CYDWMDrzKpbpveoNFzAiebLK+BLsNwT7Xbv6x9ax79dX5pVfh+Xvxmiw+OT2ocZXXzThSmEv5rr5QTFuub+tD2jAK++ewQOU1YmQaZYLNq+3PQlW63vstGWjjLS1ylkVWqLNySZb+4ZXQEc2fu0vZeUhksvnhpDL+nSX2nKKua8a2HyjgGUzJzx1AasXTX79xFOWIB8GA4/JZJXJa6yqFLEkCVWLE+UCatbC082lYEYjgdp1je7SV/Edk5OLVyRAjeJ3Ak1nUIoQat8IbaTjz9lhw1u66LKo4NEdLaQdjSnRzkBzVjvbCqZ5HjZDVhSrRqef/vlqhqEY3S2IeVa6zuXi4qRSRSu23gRa7kOBHSz1M8GkLU0UD435xDpxiJi57khmpJroyj9HerpkJpvWosxhBsz/ZlM/T6hDa0BPK7w56dSi540LwXADVAEhnTYuVLf4U4h51prUnKXMeSP6i8MZKx7dnllU2lAGmMNAYMiWd8BegmjW1K0BxD2livh/7718nY6YsshtxoD2+6WzWy6kY1UmgZlZi8wCZMZfjX7dnOCsuHzEE6B9N1+ykxTxs3cO119Xr9Vcqpq5jorSzEHGBfHl/rLXfyvfYyw3ubTxMDWuHldXmv/dAohaxylYGxT3McEC0TE7vyD5A/xutAcovbJRAcovYVwV9kvw2UhdAsOWTT+qlpOGSofgM1J3GOeMeVYZccfVQgwxaK5m9U7Ia6cfWIdWfwIM+p/3FdEZIreGF6FrAG9i8JirxU/MH2zYYwSPGHmWZriY8mDWftWHKCw+15qBS5Q6n8+IXHpFQHQUX0lHs9eRcmG0qn7+f0JJkWTV9p+ANoLbEWS/o95s2yBEbEWZEY7CZhv9eww
 lXonGdPi
 N5APVxPfFLhjH6QOkrr0JMEeTZaJ9ScKWLyKPc9R2hHF07rwLr/erC9b3S0AnY1AM8f8YsAI63LbjAGgURpruFPeeU0sDKSjM6Yphwd2r0n43BC4OcD+GBvixleSQgitQnusxRfwQqyKa0xZC7JYWOVo/m1bO1Gy1mXyDr9pH2UaOK9sfDsa1/xVmmHmpvd/0Nt1gH/hSGzy7U0bVszHyk/zCsqQqJsXL4UVLpVfMaYsZnHk1wQ3IeFGFNZClLz78C34h6Isc5KM/PuKqimCJYyZJN/DLs5i89mLKe8gDnZQG6kkvSjME+jUgQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new goal-based DAMOS quota auto-tuning algorithm, namely
DAMOS_QUOTA_GOAL_TUNER_TEMPORAL (temporal in short).  The algorithm aims
to trigger the DAMOS action only for a temporal time, to achieve the
goal as soon as possible.  For the temporal period, it uses as much
quota as allowed.  Once the goal is achieved, it sets the quota zero, so
effectively makes the scheme be deactivated.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 63f1e3fdd3866..c4095b34f7929 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -216,9 +216,11 @@ struct damos_quota_goal {
 /**
  * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
  * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ * @DAMOS_QUOTA_GOAL_TUNER_TEMPORAL:	Aim zero quota asap.
  */
 enum damos_quota_goal_tuner {
 	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d657b87dd99e8..51401d35f1b6b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2337,6 +2337,26 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 	return highest_score;
 }
 
+static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	quota->esz_bp = damon_feed_loop_next_input(
+			max(quota->esz_bp, 10000UL), score);
+}
+
+static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	if (score >= 10000)
+		quota->esz_bp = 0;
+	else if (quota->sz)
+		quota->esz_bp = quota->sz * 10000;
+	else
+		quota->esz_bp = ULONG_MAX;
+}
+
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
@@ -2351,11 +2371,10 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	}
 
 	if (!list_empty(&quota->goals)) {
-		unsigned long score = damos_quota_score(quota);
-
-		quota->esz_bp = damon_feed_loop_next_input(
-				max(quota->esz_bp, 10000UL),
-				score);
+		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
+			damos_goal_tune_esz_bp_consist(quota);
+		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
+			damos_goal_tune_esz_bp_temporal(quota);
 		esz = quota->esz_bp / 10000;
 	}
 
-- 
2.47.3

