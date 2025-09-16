Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305A3CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8758E001E; Mon, 15 Sep 2025 23:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99628E001D; Mon, 15 Sep 2025 23:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC57F8E001E; Mon, 15 Sep 2025 23:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 932DB8E001D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 681EF1DF9F7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:26 +0000 (UTC)
X-FDA: 83893698252.16.40A53C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4D43180005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GswUYaDo;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EiTaYr9jivRF46510pqhm5QTOzAr9Qowh3zQ6BHzRY=;
	b=d8NXdHlOs+oePEg5UquWMzgVMk3z1X47G+juDN/UJXjBf940k6GivBPHzPwpTyqj0lmpkJ
	Jspn5Ql9AGjYH4bq3IxW/+8KDPgdH3awsfcPlHwZCsSsoxAKkh7yWwABu03VU5WW3kbg6M
	yG+K4sK0kMMV0U1I+VUzoKr/+gH/AL8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GswUYaDo;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993724; a=rsa-sha256;
	cv=none;
	b=3TLWJdlzxJJS2h202gkXqaHDALQVonqyg/FL8EFLmVyBLKQDGnmN+NcaBmC/jf3myF9RZK
	L7nZs1kQdLeHVMPS6yAUa9MnpJR4z4amP1GT/sSf/esSc/kX553mvxMBTnzaz9wL8QkxRR
	EhJeZG09272M37QzlnLO0tBvkmbgNB8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AAFB4460E;
	Tue, 16 Sep 2025 03:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39857C4CEEB;
	Tue, 16 Sep 2025 03:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993724;
	bh=4uQscG4mYr4g+dERacoLlCCtLcp3o3ScovLzzqmdpAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GswUYaDoamgG2C1fR5wV2glRHaeU2ehx1anVdkERZyRo8fOlc1aeI5cWSmpAXxkzY
	 QQ+fAztPPkjGPGDQDmwTywr6x+/ai7QaVZiQsW/tNsk+3STv0BOSUIFL++v5mNfPUV
	 1fDqc3qT9fr6vrYJr9YeIbQRUYHKUHTe4IE86+lejqcEFRhi4QTJrB5e17ngGfKgWA
	 J7DsbY3hyzBg2ViujYAtCqPhGghty1jWBjXovXvb2W80VXGnRTZ8mjvQ5k75SmKnCR
	 DPABkkkbjn5E8O+T8kW+rt8d5XCWHiv5+HjDu9Pg0mnB3l2d/Ow0O+kZgqOnMsrm5O
	 yYKPe1tJXw/Jg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] samples/damon/mtier: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:11 -0700
Message-Id: <20250916033511.116366-8-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4D43180005
X-Stat-Signature: bwu9pr5qgt8nk9wetqhnj1ydwcnstnk9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757993724-989993
X-HE-Meta: U2FsdGVkX1/wixyaeJjrbK6KIP30XXbILHdtqH4SAKKUv6wj6l/LT9JpjLPI4seqhNUzZ1LOXV4c9MSIVufNtWKG0rHr7Sb+nWZmdXlc0OPasHpUud9y7XdvDeRgEhBQXVcxS13aPU/hnBc/za8BZkRz3c5rHEkBbRzBY5K4ydxvjEbXg19Fbxy44G7h7BKkli9V6Pt9LGAY9jVoHWfs6Mg3XcV5xAVRgc8imczHFl0Bhi5lKbAmmya7+5t1bH9RSewfyuRFtzZ87v5ZcjrHhUGs337XbzdCPBrlvOMbtzUB8/8x77G9m0LQiFaYBsNG7D/fU9aiZ5Mrn0APQcWxfFtwpXoxKL7OFrTvA+8UmVzGZ9U3E1sqsndA1fAg1hjxUs29Yp9MKv7usNdLy/SdUUopvjyZ7jjAy9Wo80BFZOGp/Ci8TGR5LoUFnl9dRFsbwsg+N7voskZCHyewQlUjNDrjBw42cXwGHytad7ACtoTl8b7hdIqXOo2PyGcLbbEuXml88Joj8Be7paTLgkDfrJfvi2oV4EYek9pe45E+ZXVRwA9Bd4xCuTWb/MQjQPzUnfhPuypufOXa0uXEmMv5vyr0G3cqsMyux0uDcwe3e5694ZXosvRUaoBpLiUVw7qBtWNtJtjXYXQWDmPAi5x07LyHOYRTT+mtfnYZWIBQtvKfOOsJbWTT/2sK+q2JSm6KoCpC4xNSr6WzDOh8LkSzc7J8zWTjZLvqXs6Bjnvgt2un6fL75RnNITyniveaw6hLzdrIRBCIw/5s+HA+AGri7zh6qrZDHU2i4lEkacL+WUjNOjz80sCc32eUlRXMQtzdFwxdvCWlUXWcPb/IkGJbtcRPQi2jubjLAL4Yl+Ux05GaS1nrzKEeQMJKu3Jo5/9dO6l91K9GhtDOKBJHWPDPU6z7IEH4c8jRoPrdac1s7ZM5xJoiKAbM/owb+bL7tWXX6C4xaneVv9cxqLSrUim
 CJq7+ZSw
 pw1axeo8ff5R4p3X9IS6n5tnHTlQzu/nxIhEP4k4mk4nJuYjFAv+aaGYAdkClwOISyBAia7T6oHcD+0r4yPoOzHA8C6WtD0e4Ms5TDuP4zHdVrFMEliIxzvUN/LXFDkttfDgtqOw2NQfhRz0+PHthFxtrvG+gsbnfg3hCUQA0Yd3RzJ+qYCU89eoIZO8Y878mRKD7WQvVuY3FNmC4SnAfOpVZgx0DWa5eGDUgG2wHMw0dikfy+UANnL1Fgf8cpFupSCI9AVk1+8rGxfbnxnD9W6sEKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier is assuming DAMON is ready to use in module_init
time, and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index beaf36657dea..775838a23d93 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static void damon_sample_mtier_stop(void)
 	damon_destroy_ctx(ctxs[1]);
 }
 
-static bool init_called;
-
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -208,7 +206,7 @@ static int damon_sample_mtier_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
-	if (!init_called)
+	if (!damon_initialized())
 		return 0;
 
 	if (enabled) {
@@ -225,7 +223,12 @@ static int __init damon_sample_mtier_init(void)
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		if (enabled)
+			enabled = false;
+		return -ENOMEM;
+	}
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
-- 
2.39.5

