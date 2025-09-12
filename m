Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30294CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0CA8E0007; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7703B8E0001; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575638E0007; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40E628E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3A00160626
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:40:00 +0000 (UTC)
X-FDA: 83879043360.19.55749FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3641B140002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOIbux2e;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gUxWuvt7VkbTVwQb57v8Jcz3w98hUW0TAOpVZItUfk=;
	b=S7ETdjwPuibIE0hExL88novNklyrT7vKIEY0ji3GnYKJHs8GVr4PFHW2ytjjnKtLOsudmh
	fPfxySM/F45TL3nor24bOzYcP9p+9LL7Fz8DGoWZ7K+onQoRVyInEooo07f2MgaZNQzMqe
	IbLFCspARFfmaCLUpRH4S7NSQGYFGFI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gOIbux2e;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644799; a=rsa-sha256;
	cv=none;
	b=dHbxXX4yHNPjrDNO7BPd+EoeSWYQgb9AKVWBXcS++AU+IuRqd06JtcZYsZl3a6t8Ca0+AK
	5uHGoCAQxinrZPS7ji7Vw9JF1mecA2nSWd1SKIdVmXafAK+hB9mAiXo/C/mimFHR/5KwEu
	EJS9lQ/3s/II+iTjfnY0SPKL5WbHjjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BF70450E8;
	Fri, 12 Sep 2025 02:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87F9C4CEF5;
	Fri, 12 Sep 2025 02:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644798;
	bh=2demp7SZfocNtJOdY3h9yRpOtgZXlewJOxyAe06bXV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOIbux2e0xlvP/53qMivwnlzSiSL0JxQL4XPTJ4+nyltrcm+59hn/qclLbE38UyAW
	 M8LgW3jzBIZzUHayt/fyxX28Imlt5+C1IwEzf5Nm1RLLCPYUdxlebddkLPkM5vrWz3
	 88pdwTGRsQJpFW2P8Y6WCZ78ygE3mfEtfi6sQmRvboSCcTFNraK8887PPkiDk/lZzh
	 W0UZ/fvLYHfpbDadSfsJUAUCxUCwe5kYdr7qIICUkkpQnfF1Tt79jC0OA6OWvt4Bgm
	 7t2YWtwEkf0Gmpq4hb+TaQUPltp7fSaUz5XFHu5q/DPWtx+qBSPfagidJWW/vTfLPJ
	 MnWtxgppmk1SA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/7] samples/damon/wsse: use damon_initialized()
Date: Thu, 11 Sep 2025 19:39:44 -0700
Message-Id: <20250912023946.62337-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3641B140002
X-Rspamd-Server: rspam05
X-Stat-Signature: 74rmhf9mspcs74p19k19zntadgu7ndzo
X-Rspam-User: 
X-HE-Tag: 1757644798-106777
X-HE-Meta: U2FsdGVkX19zIzVuc5bSPKJjNKz8F4eIgfYGgpsl6p6h33BCXpB0qxhuHMT4+7IhmffXCrcsvjTex8r1lkxacjIxEc1XtzzX5N2fS5iY8fumh+sc7f7vzV0BcCcoJwfCLX09YrPq1MCk1TIRM4Q5CNr7RQtVQ+UIuOm00nF1DqzGu5c8iDIaL0mX55xKAvmosmkkLRtPTn+RqkI1NC3MsiZJVEa9sO8teg2WTCab+WGaf+ebuWksC2Yr4kpxKSvOaaXLRrsMaoE1yKSgWe21ZteAW2e0yXVrU3/wjNEq/Brf1Q6sR7FZ4j4taagmhDjbTl9xqIlHy3czuQ/18/J8NR1Hoz4VTiug6jGG1cXiO+O/QqREJkfGr1mDIgnaZNTApmNEZiwWoj7QvwLaGyJpmqIN6PYyGi0gJlSmlQ864zqoxBKxly+ENtHVzsZyRxULTDh6s3Wjo2hIR4pYPeG90VgJ7gGN7hhcC0jzLhfI8h5AoC3WqocqIg2F4AmwEhO1/WuT6P5Ja/nVfyXaaCkDuxWuOQZcjhu2OApweYctts7KIK6PNh0NOw76/lMphCZ8zm/QftM//vChn8jdzETFFdFHje7gZG5M1kYULUCprH+y7X9a8Qhw81cF5SRmA0nBRDX7xlUviLnSOW8MCg7TFWPGaRBIL7KtSrDsDEJaAkh0It9JsyCtNpC8P3TEfmWGzAGnWe6hl4khdO8sa6jIZhfOcDB6ymNYe02vkyhzzzww3Eam9UoeNUuoaWTk/eJP0BWo4ZYnFK97jmScc7d4+3oAGMQ2Z5VcV5re7JZ5sQHpSGl3hvtC6TNqRAwDtReh5y5ReUTN5FWoJG9VyeG4FxOZlaw8uQ1NN+LhioaJPOMRtxPyw8pqY/NiJlTe0uWWTg/RJI9sa75NKKVJOWxu7LWtMl6xoadtjraCDdWEZvTA+pBs2CktbF7iXA2m2SBiFhJWVznyT1W4Pn1olAh
 CuG9rfn+
 qwnA5L0+Z37NlVa7zpEsQWzQ4RnOKm9PeF/LvRPA0cBGgKNIa9Ux/qOqI76XiWwbd7IZ8EKrAlMIRAwxCsZc++uYu4tbdxSMIBHuXXUiQHdE2ePf1SJvsK7XUhrLZFp6MQ3MHKeMJRcom0yeuH6E0mCSy7+PsjbiUCxPOB7dXQIi5I3hkbOn7cz+ZsAuuPza30nUtz44IkfmYzYfffbOtXkIl2rW4vI+lmnhOReQi0ms2w+3ezlImi+jCZwB4Yw6/G0Fs03+/LuOMRY9ifE6AUWERKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_wsse is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/wsse.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 21eaf15f987d..799ad4443943 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -102,8 +102,6 @@ static void damon_sample_wsse_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -117,10 +115,10 @@ static int damon_sample_wsse_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
-	if (enabled) {
-		if (!init_called)
-			return 0;
+	if (!damon_initialized())
+		return 0;
 
+	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
@@ -134,7 +132,12 @@ static int __init damon_sample_wsse_init(void)
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		if (enabled)
+			enabled = false;
+	}
+
 	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
-- 
2.39.5

