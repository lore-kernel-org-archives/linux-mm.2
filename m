Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BBCD2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79076B0098; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46A66B009E; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FAB6B0099; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75EAA6B0096
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A68E1401AE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:36 +0000 (UTC)
X-FDA: 84327320112.04.1B1968D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7FD51140002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MbPlCZKp;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PmTDAIhQgbd//Bi2qhXS98/sV8MbAuDvZv8Lhh6liw=;
	b=u/YQdLjXq93dUWTuEVDWRHVGXzg537tyXXPc8wq6gIGEd9fmUicMypVubqkOriYkKRm0St
	RV9iRkMciGFNq2pcYXfpmfeCHnZkxnrn3fgXmwjngMiKk5+dQf8a9fB1Up//AQIMKJgGeR
	GYP6E8oLVEdiWALRFhn6ghYuT7Q46zA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MbPlCZKp;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318054; a=rsa-sha256;
	cv=none;
	b=sENE5Gz79idLr9T/3Exd07cwwN2pH6gKBH3L315wVqh0zdCGT2FImLfsWxCjUhGeBi6dBp
	1f5GDCglB+9rGIpZUSlOzxHx1dY09Rj7sxkkTI3tmiIzm5ej2tA+hAECETTefRaX/osuNt
	BmuOWSB4Ij+Poo9MFlA5LHiT1vNkOCI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 281574324B;
	Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5994C2BC86;
	Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318053;
	bh=pLryvh98ed6XxIPENni66cywNufL7GDRDX92gXVXv0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbPlCZKpIa9lOj8AUJONXGdiS2aKBOANl+x8LvCD7wN/3tBH/k1xZ21qPaPOTgd1/
	 JQ6KtXiAKUbQtF/268czWsrcAIKAMqWUEOd5YMI2HaveSZkVKBOQEKI+R1GrfEDrOz
	 L9n/QK7uEmuy03W2+7Yc3lG1HjtzKD4RXxfhSMaZjkbSkEpyWBPz1fvlvNNGboeBOi
	 KRemgqA15qfU3IjPJtr2AHIP1eAYyb6+R0Nh7yCUD+2ZKh7wqUawGcv3Oyj4LlEVx8
	 joZHlZo2O1H5B+yqoalAjodSq8qbWo/UHo06cHVY0PCsirMjc3k6J3nb/xY/Htz9Cz
	 Tx/bOa4/5q2ZA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
Date: Tue, 13 Jan 2026 07:27:13 -0800
Message-ID: <20260113152717.70459-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rfat5ochyqtctj3h6xh1rubdae8z3j3j
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FD51140002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768318054-735873
X-HE-Meta: U2FsdGVkX19jvkQzCb6J5b9fXNgKvksL7xiXFZgAkgys8wI12h40WBwmO8PHs1iOpSMwQeYqIcCOsXH0Q6+sr2nOwK3CbwVZ3d11RxplAzLIi2AIEvvvG+htC7DDPTq57mi81PICjmGifk4F6L497F/d+ggJpq9zYV1749uodYdRaMTevUGxpWHRp5YNI2z6K3FCIxuoJd0h5QCP0OLYBsRF4iA9dQ3l3sFr3AjiCA7wrUPsNpcqq1ptDcRRENO8HKFXz7h7kJK2i6Pq0suzm1HDRA6x4SmEdN0sOO8D6dwyC05Xm+MzIW60nURnEYTA5B9di8iFVoRhVBzi32z7h2iMaDqQdrlva8Pc4anW1ubjfjyzOMf83/zk7HM5Ln70mc4ZlUe2MXVkizYl96Lw/aURTPO4QVtPnCn80qxd7QI9weaRSCikEoLBRI2FhQ+WBqjFlUxHJ/Ka6Ywn2ulZ7l9wbelp9eUgFuHmf6UlLOqdBfIhxw645DEi2mUM7oT+7JYxapqQPmjMD4wG8vQH9V+UMRcYuhKkDRmwI+ODGMsqu+TJCihapBHPtQ+g0jzmUqF4oYPpjrFbxy2dZlDK13asLfkILOjkPiE8I1p8TKZTAO1I032R5/3Z6RlknhnVbQRiC3A+w1vaiE3gx3Tcq+zCuomGPbggxnWBtpgqEVz41vW/Qg+GZ0PVKnx2LfKnTGPRB9EazdcqymHG1U/qmmU4e0/SkfrfEXn3dn2p+jDmY+xS/KDImV2oVeq5u9CWr7PH0sQrRiZVFMPpmIs/w5v7IlJ82BTj6D6GyIDRAfoiVtgazSAYVsci8Px2o50dzeJS+kRW9YIFLV2zS6huZDDgznhoAxONzszAmaol+s1uvJikPOrcV1V97z8zZ26f9EpUiWbTQjxT3Yygo64xbs08dD+d+T1k9IJMvnulpGkgKhrn1jiL+1Axsw1K/bWClENEDnC7MwBC+4Uth46
 TJvcQgHH
 Uwbge45FWqGF9nseBtli+MnSgSAmQkMbhzD9ZCTRYm62Ofc4FD0iy/LG+/d2exuoqIRWBhY0REn41wjkxcMYK0WEKFvEJI6zkT1dHCzJTbsuEeDTb7SNaqDW8Fh3w9Q9ZS7bqjLYzK74r9kss/TwteKIovlX8jXl3AI97XifTkBKeuJ062YCb9TflQx74J6aXjrnAEVZyCDs5J3b2lSr0Bdbxko/kHzaDqZOM44Ya5yZQ++V1x5uSkBl3ByqKv1h5CSrE5XOhh3H4aC97JIDktQKIew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Doing DAMOS_LRU_[DE]PRIO with DAMOS_QUOTA_[IN]ACTIVE_MEM_BP based quota
auto-tuning can be easy and intuitive, compared to the manual
[de]prioritization target access pattern thresholds tuning.  For
example, users can ask DAMON to "find hot/cold pages and
activate/deactivate those aiming 50:50 active:inactive memory size." But
DAMON_LRU_SORT has no interface to do that.  Add a module parameter for
setting the target ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index f1fdb37b9b47..f3a9dfc246b6 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -41,6 +41,20 @@ static bool enabled __read_mostly;
 static bool commit_inputs __read_mostly;
 module_param(commit_inputs, bool, 0600);
 
+/*
+ * Desired active to [in]active memory ratio in bp (1/10,000).
+ *
+ * While keeping the caps that set by other quotas, DAMON_LRU_SORT
+ * automatically increases and decreases the effective level of the quota
+ * aiming the LRU [de]prioritizations of the hot and cold memory resulting in
+ * this active to [in]active memory ratio.  Value zero means disabling this
+ * auto-tuning feature.
+ *
+ * Disabled by default.
+ */
+static unsigned long active_mem_bp __read_mostly;
+module_param(active_mem_bp, ulong, 0600);
+
 /*
  * Filter [non-]young pages accordingly for LRU [de]prioritizations.
  *
@@ -208,6 +222,26 @@ static struct damos *damon_lru_sort_new_cold_scheme(unsigned int cold_thres)
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
+static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
+		struct damos *cold_scheme)
+{
+	struct damos_quota_goal *goal;
+
+	if (!active_mem_bp)
+		return 0;
+	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
+	if (!goal)
+		return -ENOMEM;
+	damos_add_quota_goal(&hot_scheme->quota, goal);
+	/* aim 0.2 % goal conflict, to keep little ping pong */
+	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
+			10000 - active_mem_bp + 2);
+	if (!goal)
+		return -ENOMEM;
+	damos_add_quota_goal(&hot_scheme->quota, goal);
+	return 0;
+}
+
 static int damon_lru_sort_add_filters(struct damos *hot_scheme,
 		struct damos *cold_scheme)
 {
@@ -277,6 +311,9 @@ static int damon_lru_sort_apply_parameters(void)
 	damon_set_schemes(param_ctx, &hot_scheme, 1);
 	damon_add_scheme(param_ctx, cold_scheme);
 
+	err = damon_lru_sort_add_quota_goals(hot_scheme, cold_scheme);
+	if (err)
+		goto out;
 	err = damon_lru_sort_add_filters(hot_scheme, cold_scheme);
 	if (err)
 		goto out;
-- 
2.47.3

