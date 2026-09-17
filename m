Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224FEC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5666B0092; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26AB6B0099; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93D16B0092; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFFB6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBC6CC01F6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
X-FDA: 85221915576.15.EBA0184
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35FB840008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eV54DsBz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4wob7RRQ/fb9yIvPkmCYITSEq7R5wOfYsN9M2cgFSE=;
	b=Uj0h4frvQ9pYGDarItIm4WZCoQvDQ1+0hv3SRKGP2+LB8effIK/jtrjRTUdJxir9WRItg7
	drOVfFAm6CoGO67gBnk21Jr8dDVxfEOasLX6NlkYPZiG62QKKHnff1e19ljj0FUOnEuUGw
	rbDGY+KBhFAPMJqci+4QHRf91+MRf4A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eV54DsBz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617947;
	b=yDi5iFPIGMJStxIE7ZF0JC+2AZfLq8i8dICvNAdu57PZzA72xpJaggcX5nyFqi/autsAv/
	1v3y3HwBUFDsj7sWeoxCd8KHrsn3y8bZcZfG3VmEPeas21XRfOSVlLsmZvkPixVJVz8W42
	lgJV5KOxejmMC1zdTW6+uunU0u7vaKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70A6544015;
	Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C91F00899;
	Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617946;
	bh=t4wob7RRQ/fb9yIvPkmCYITSEq7R5wOfYsN9M2cgFSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eV54DsBzc5z8y7fr/46oE/Wnq1D8InCVloq5Z/hxf5F7EqYunqzmqPJJD80u1swlv
	 11TJGJrgnsZvPSDp3rPVU0ExhAWklD17ZypmXAOTHWVzN2W0LuwlJvHkgBVuPggPWH
	 VOrh8gqtv7cuI+WcqlHsUN+7y7uMVOJ8z+u3rYwzr/+gEXeZRhqj1q0n+4RvUuHU8C
	 4WqzwAf3D1jDEs7vWRR823CBv9pCMOTichPSMSGktRPTjsw1pyZX6f7H1TcCwc/DtD
	 qyhU9vZlgqrwdIp6S4wUaUB1h8XTG8Q9qmH7fjm7nJQ6BJcWZu4TtdA00icDlNs/sk
	 LRey78S7YZ1eQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/10] mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
Date: Wed, 16 Sep 2026 21:05:29 -0700
Message-ID: <20260917040537.107341-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35FB840008
X-Stat-Signature: 9s6w4fe4f9qtbe9uytxnzk8pn6pawpfh
X-Rspam-User: 
X-HE-Tag: 1789617947-525968
X-HE-Meta: U2FsdGVkX1/U1qqxIJttnnFCLc0hqnRFUM1YgPUc2EXK/NzwaJUAWpuVOuua2EmfTuoTD35/5Veo+2GG3zfjRqdemBHb7VJ1vKd+SanoZplQCTiRr+8WBEOQ9q4ZSWGeqCLHojXXRJLRMZS5GCHrIkT7IpeK7jjd7g/qmDMK6Oz2mqqfxHQ0cFnKKacYHv+2J3VM/9K6buVqITSJbp86XKekw777Ow3ZR/QAs9DMIsjZVrK8SfBXTslcFnVlVNLl5poZazPkVwtOWC18QrKFVv17AJ/iWPrIjEvNXnXGmNOAoKymJ2LcKJWSYAX1lbixbFreWxwTNxtdzMPubsH8wMwI3KBz41b0YJOX7H++TvOzmGqBTMS6M7l9m5qC6DIePMDQO2AzEsN4MM6w5FtaZ8B3oJhwb0LDJd3vOuEB/wmu9sJFAGx2Uj7lznVHl2l5cU3kxKflBXo+a+8mzIhxe6RqZYbCq3bVeCgr0MRZ73JSMWZmTwlH9xtDYFZwDzMobqGl/DKwSRfr6leBJftisHYg9usAbyk/0xXOJJDfLCopg53DRXZyMung84sZM1NP8B6AAeSgdfYj8PfDV+NhEvmIL8RVjwavQG90mQFaG/9SZWXS482rPEb7BTdO/BE1LjuYFBmnPanosOAlNr9Rexack08MXeHjIUMzt5mpMmjaJNrNDlZoBjYyE30UEl7mE5gcsGBYcaW+GPzDKv2Da7srJDFml9JmkMfgItGwG4hdfiJDJFqXmmB7RQB0OMutU/dWA/4T43Hc6lGgpMZMTv+3lEIiRGaajChmJCnnDeAhnT7DvD3b16Txr0Vl0kw3kAg+rV8xTy2YieMoWyOhaRz1UhtUinRJ7wIaKmAagyXbQYk2Qr3vH5nAiDXs5KiGDdUVw32P/pN04s7IECT8Y+wptRr9RgHq/yqRKdZ+5RZ3piJCoxzkWeY+y3gl5lpe2iT4xq1ULifouHSdMKa
 dQ4FnjzL
 hPrXxnpOM7smRgzU31uYdIkjEmvx912wcl12tCauPRXdPl42zuH5uV1u14Qbyh8K2BQp2LvWKFj1DvAGAQdNXjlJL9eRGl71wUtCrWERC/ns0g5ubaNDO/dl+utAqUJ8m2R6hNzK4wp3xF0mwTfRYDiGed9Lr7HYGMAMqSSHkJ92e0UdWu2VBWWRhNqjQXWt1/qNdUD/JyMr7CQtspwd73YjQAludj6rMt4oxI173p4f73F+E4ECZ1SdRVEbs0QomvEUHy2NH3+HiHLxuuZv7aq4/Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_feed_loop_next_input() does its best effort overflow protection.
score_goal_diff is always smaller than goal (10,000).  Hence the
calculation can be replaced to use mult_frac() without concerning the
overflow.  Use mult_frac().

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0299729e79ed9..7bbbd44379301 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2928,11 +2928,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
 		return min_input;
 
 	score_goal_diff = abs_diff(score, goal);
-
-	if (last_input < ULONG_MAX / score_goal_diff)
-		compensation = last_input * score_goal_diff / goal;
-	else
-		compensation = last_input / goal * score_goal_diff;
+	compensation = mult_frac(last_input, score_goal_diff, goal);
 
 	if (over_achieving)
 		return max(last_input - compensation, min_input);
-- 
2.47.3

