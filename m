Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B644EDF04A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10FF86B0092; Thu, 12 Feb 2026 01:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DE56B008C; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD78B6B0093; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A67B96B008C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9B6D160756
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:30 +0000 (UTC)
X-FDA: 84434812980.02.71C156C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2706E20009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uX2H8Edy;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QR00LaMmLjMFNtf+VDRj33mc2hCOw6GT2gjsCj4JrR8=;
	b=qOI9ltm20j7igRcvjW8P6IMw9pBxq3QKTvbMGoZWinVLhbZFeYXtliFwoDfa3qYf1IeQyD
	duP8Az+dTfoIohoCoFcesirC8xY4jDUMuFPVXTxp/rQRefn5MuMThpfqSqP4LKP+Ah21rZ
	XVJqLbNjMtsn5WWIpc4cx5jldmrxzO0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uX2H8Edy;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877409; a=rsa-sha256;
	cv=none;
	b=THnLF17fTCFSubwv3ayj/XSBjeGQ5jFV11J/YGHbzUXAeRKRBDOEIUZRG4HTn3XsHGOgtO
	AXkqxtAeYO+yYkx3i7Szc/6O9yFQr1DGaiKADPRk8rQ4euZsB1TZIY4y1RvY2auz8BsCVH
	xHFRneRCECYmhkBsWo2Mnl8w3Ms8mis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A79960018;
	Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE967C19424;
	Thu, 12 Feb 2026 06:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877408;
	bh=xBnWOLA3jQha94wtKmplmtV31fbSm+0D4iTTXT4bhss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uX2H8Edy988IOxMIf2SQzORS/zRaP3jk2oBvJ5/+z5Q0wCotlw/MJFcbDFIeyBFpm
	 6i8bnUQgHNg50YB2KCdUQi4ELfK18ixbsBsSOVtMhJ+FY936JdFK/w8XtLsYYue3uH
	 4//ekEpbJvOKwmSIK/1tPGqQQ1wV5z1LbMbMP0SAX/leLjTCqlCdYymI3T7aPkTVfJ
	 xJyQQw2pOLpdtyUmlTHFPYR3/EL99gJ+je0wVCDz7xV1sh3qXfCj0VeIjan03GNzQG
	 jGOXay6lmU+8t5bX7FOHhzF8SzEJ+yo31JRO7GPAECesPDfAJhHzyJvvT04MpgY3m/
	 /ydOGkCaYyltQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/5] mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Date: Wed, 11 Feb 2026 22:23:09 -0800
Message-ID: <20260212062314.69961-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212062314.69961-1-sj@kernel.org>
References: <20260212062314.69961-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2706E20009
X-Stat-Signature: frmw3zqerhujpooracs6siopzozo6j4i
X-Rspam-User: 
X-HE-Tag: 1770877408-73229
X-HE-Meta: U2FsdGVkX19l97uCBJOLkUY+hu7OwJpnRzmKH5bCnCWK91eTViSBjKlyUnBP6tXZA8JTtBrBtPNQu1mF8PYB9jagBfjOJ8NLuxFdZQNx+GbotQxHEeGF7FXmWWTKY5b6AbJZgZwx+7vCjc0/gXZQFr61kZZjXUmwK2MKbRFNy4lc9c07Y1GCGSw8F/G3TdkrxIfDLmKHyK6ctZycBtr8ZyT0XH3Ebg2s0UoPUbktXhGfgbDaaGcKo1qdo9HSTtXxf8kW8jriFn2X9J2dDT9cG55f7RPBKzBEJHTo8QOwrIhcsKQm2tNwe+kI9zS4HFdt2Kyx7Q1goARdw45ggtZqnL1fBA9LCdjlO152WY4IG3YF6r/DWEnJQ4ILo3zgbJs6XfgPWDdOaiL4gG/fodiYpvm58rVT7JuG6o1n/MxGjGMW9P62v0b7coghOAycKc8tq/8YIXxhFEkpUBCsBotJA6m5btB94qye6aXlkfT6sG60SVOcyP6Sj1sn8qnfswPAPAvFwORnj3xNORIoR6STGyGf20AGPjMxybbxRbpQ1Os1Lb0bw4IJaDXCYnexCGZyQ1IIo1l9Nqv0ufFNNSw09M0CWf3fqsGWZgMhkor6cxKq5AoEXiakjDDYN1ZXWpSLd5pUBGwxcoR0yikJ3dTWE9/8W/JgnmAni2uliKghXIKKYC07bVPmtbWyPjGuDkKbXiI2lsKFyeNcRIpNxfPtehAQdrYvKvHudwheZdBQn9RPYLkbjie0mCfKjQbLlV705r57YYP+/fG/51KRTCiJWj7YtFupDpETZfHbZmenMsmHkcIArIunZBbMKlaQate7JbrbaPWvW3TOo6UvAxF2RtyXs9AS15uQ5MnCyegwXIahuCAvK+8K2dvVONP+s9dDgp783jn4UIDQusNATdZNju8ly2BNF22qHACpvklBPV3GWA5taFpLvSYREBspCC9hVGpz3l/LJjau92YICVY
 b8jurzos
 uCxs8ixCKEvduB7OZphub7bCIrFhSyVwjN1QM5VSZ4H2qVVcbUzBmG6q4UlqIxzFc+hRHJKVogtqQBpipe97zJErIPnuRdT8MNhXdXouFT4YKYPr5GUHDITYBnn+wiPGiyLqSwZKagPGryb+E4K6GlKpPhxz+SFdxs9f3kPgg2hfr1XHyc9GcFcDUMmVwxTmAJorCp4vYLufFpu2bGyDZTfvUmRPADcU0S7yoyKU4XR2T1LDh3kzt3Wzs+6GTWDuiPoeiatGOcbWOEkIsALY/xqd0UpjUPgw9weSbQC6Plp3fQQlrlcjfy7qEgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new goal-based DAMOS quota auto-tuning algorithm, namely
DAMOS_QUOTA_GOAL_TUNER_TEMPORAL (temporal in short).  The algorithm aims
to trigger the DAMOS action only for a temporal time, until the goal is
achieved.  For the temporal period, it uses as much quota as allowed.
Once the goal is achieved, it sets the quota zero, so effectively make
the scheme be deactivated.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 25345b5f821b9..0ab247fb06ca8 100644
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
index 1c126d910fe62..81e3ef737be77 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2217,6 +2217,26 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
@@ -2231,11 +2251,10 @@ static void damos_set_effective_quota(struct damos_quota *quota)
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

