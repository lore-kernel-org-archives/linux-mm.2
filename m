Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69854CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F138D8E0008; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC45B8E0001; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFE98E0008; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B18948E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:40:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E68E13B728
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:40:01 +0000 (UTC)
X-FDA: 83879043402.29.B531486
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CBD5F40009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrQP2Ut0;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hswk5wq1NIfeFANemacMU0Qvk8VNAPgCDoUzECt/HlI=;
	b=oYvWMbbkeWPw5mH+egMQ0uZgRX9fZHZCRfAJc5J45DuXPFHweCU5X0WSIHWxsrRzOZ3DEd
	sEBpSEWYUx3edwsVgDnd4c0Qn1kVpz7ld91gHXEchCZ/CogKdN/sfVC5stRthmWK3rTgz7
	xN1vnlqUyVE3ZR+wLjriScJYbCeNM2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644799; a=rsa-sha256;
	cv=none;
	b=TRWAcy9vqNyOUIC/d/nRN1G38uG1j3xjEOy5crNSkeWBUhGYsNAIdaA0S4AF39ExSeFSRZ
	PjksAjuGVDxKjZcPqfieY5s6QyClrK+N4dxSk8aEVpC/+/jLseRWOIiKyvgjU0dkt2dCN6
	Pc18YrOvSBeSB/gpbPlYyxv5LeKPjVM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrQP2Ut0;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E42F6025D;
	Fri, 12 Sep 2025 02:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3470C4CEF9;
	Fri, 12 Sep 2025 02:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644799;
	bh=8oAmMgNUvcFWbF3KtriZccsEdzvp1RE+WJ1o1RTAqkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrQP2Ut0hwY/MhhOlAvITAVSfwisKYhr7P7gIhhQlAo5rvPkQWR+COGMkiiKG0wrC
	 mixl2/Kg283jtZRQ4BPLkmIlSZwe+tJOR7Bv7RZVMAmG+eggPJPeCPGR/sjik3HL7O
	 GVtgRbvPCXn8Rid6/18Sr0DMDkMexf42L8UYny9Bvw0GT7bxJd5fpVOpkPzfDUB1/Y
	 +HICj2zVncflQ9k0b6LVXkKdJrXNRG0NGbFAYvD9k25ohKppNBb2UHiGlevfSXbupv
	 z/i9Eb3uKUPZ8rn4dsShJZ4+yOFbtllaswJuTDs847cTDOFdL1YqTyLLKybieSop8z
	 BqpNelbbs3EQQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/7] samples/damon/prcl: use damon_initialized()
Date: Thu, 11 Sep 2025 19:39:45 -0700
Message-Id: <20250912023946.62337-7-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CBD5F40009
X-Stat-Signature: pa38ubcryu6bo5isafkybxquxksryhkx
X-Rspam-User: 
X-HE-Tag: 1757644799-865722
X-HE-Meta: U2FsdGVkX1/jFPGOwh3E9BN8IFIZ8IbHMEnLvg5JYtI0Ew1OSuG29CoPYBO8ydMXsyyiXSAfDMgthz9j7b8U3ypRpRTbftkmU4KpqbZc3Hp/MFEehVg9PT1gMfn59tLnp5zIfAl51mTNNjVZWR19FtggHqnLm0xVNyFOIRqpdVEWViLP5UBksAt1HDYt5LGKXSRleBiQSoH+gFIV95bHBHdFWh5J+8k2S/lMMxG6obVrkZCB7pcpq4V7+XoDcwE9hUW3++T1NsMSpWyYRm71vU2Rdu7GiloJnQYy8fASLPHQmnzURITx2S+1djHHlxzXFT6o7tU2YKrWk4aJwKKEA24QExsUyXXp7DTPyeWlcazOh/PlY1WikPLXaqzgLkXYYQvB85faY9CInDccQaSyvV1w5f/ao1gS5M1CWZLKEhrAD9dyS09qA1XRI2EMSrH18el7YjxzeO2Mr/XNdFr80XGZt9i3+0NggiBz370DiVmay7RcnBSe0A51nulmcXSds5ol/7E3BkEJkC4SkER7/8wJ2gibCZjedahTLLge+EsnwZSUgHHAj/iW53ZrJlVfR4V7NnNZ/BS0HSiTlxeObJA4rmOUzNwPLdfhO2k3ZV2o3F84vQTpq2XgpAYJdvHrJSV1Nx7JrNVsKN7gDAVytPGe1F8SQCgQhyV/4ylqjZ9xqs2DteiD+0ET/G896WpxVd55X8NFXCcdbeSQ6u9CC4XqjvDONgsR+jxHEXIY2HqXWn+1MprAy2cIajFut8wiPQzTb0C7WVUoIgzvEwJ1BbptdrTLnrha3zmHGJV3MKtrfDLyqTC5iWiJ9rMt38pxLh9DrTT5zOUnxU9w2nXodHppUDCkGYmd2j3JQ6y3xK8Drui868vqAVP3OCuTDP6rWnnqIF+HT7IVr5syvMHeqyRw16aNgLbcrj+Y3c1Y1N2O6TVGgpqEpToXdEV7tERkWZ0/bPsrHS4CpRqpmCK
 QhckI4ad
 n8aZElTWqQWndwb0bEom/UrGdtcBTQcw0+zIch9NPAHb0NT6Ak+3OiVHBC7FU8LNWnTloW1wuceUJ1bY2LKMHMe7LFjP8zwt+RSfrxyaBS3EO8hTCXWOrLpn0mkhygudQnO4bXGpFrHpnT7u3zN20bDTa8LXGCTpEkL9ujI+8JU3z6pNV1Nez00tMDCylYI1HDgwa7CqHiVMzd8ebg9o0vdayNQGagojk/mZK0AES0cTE8JZxnKWnuoGnb1BVbHq2SJ5WFnHR1WGBlX5iXLmJOCCIrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_prcl is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/prcl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 0226652f94d5..b7c50f2656ce 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -122,8 +122,6 @@ static void damon_sample_prcl_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -137,7 +135,7 @@ static int damon_sample_prcl_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
-	if (!init_called)
+	if (!damon_initialized())
 		return 0;
 
 	if (enabled) {
@@ -154,7 +152,12 @@ static int __init damon_sample_prcl_init(void)
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
 		err = damon_sample_prcl_start();
 		if (err)
-- 
2.39.5

