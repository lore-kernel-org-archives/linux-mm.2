Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DFA7C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC19A6B009D; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C993F6B009E; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39826B00A0; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5B86B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D99571C10AE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
X-FDA: 84969412458.10.3D3617D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B98F1A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksvBOlhX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605968;
	b=Knu95i+LboA9MJk1be5M4+w7ijr8vz2PTPvM5OwCo24kw8t0DzAzFU2jj+u9EjCGLpBhOd
	7Kqs7YGWCgBklKIuC76h/nUO7IH9Pn/EGgn9VvEs/AE/AN3Gd0Uup88dWcPDutsX0iqXtT
	IZbOYKO70UGXTInmTikpb2EkMkCCzaU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksvBOlhX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwl2cglmpuAFjTMSYGCoVfFN6ks32ggZ1ukBCbftSNA=;
	b=ZvdLBk5b3sT63Y+mC5yvjN7uHIG23HnxTaMo/d4KSuvgvEdBHxOz1jQ3r9GCtgImGYThSr
	lfH9Pwp4zHokaZsB869khvla5/2k8AUwIZuBr1v5XYVao1kU8cETLq84aHGaw7ikOJax5/
	pbmQH/Rv9LZQq7oeBTvumQVW2qXOpMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E83A61384;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43061F00A3D;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605967;
	bh=cwl2cglmpuAFjTMSYGCoVfFN6ks32ggZ1ukBCbftSNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksvBOlhXZuYe6PcvDfA7Nh2i2MrRnI9YRQHYZScgbU9jprbbnerU3CogTOghKADMA
	 AqWVuMMkmttEV3P5neGz/VeCsLEvQJoYI34mCiMB4Q8Kb1o/zmTFExXyc+iGBRK6Eq
	 /7BUvKPgH1VNDMs88H3wSwyzUGYYiUG0itGUopGTpfAAiFVPhSr3BGAI7UbNGsOEXj
	 xpD4ApvNI2vHxW1DRwYIlMd5aUXhXsO1WxaflUDULuPmMVGtFlepDC1tigck6LiehO
	 Ro6T1BH2JL1DXbqNfsnV/5p1DWSJzn9f6RyFeH5GeqTHScw9EgdwN2kFQtBjfhYuNE
	 AUDnv7+9IeTbg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 12/19] mm/damon/core: set samples in apply_probes() if probe weights are set
Date: Thu,  9 Jul 2026 07:05:50 -0700
Message-ID: <20260709140600.90950-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B98F1A0004
X-Rspam-User: 
X-Stat-Signature: 4mhs5ok93hkx3nxtd9xc39uy1id3ib1t
X-Rspamd-Server: rspam03
X-HE-Tag: 1783605968-591694
X-HE-Meta: U2FsdGVkX1/VdrX3es6WqddgKQ46Q/5oyXFPb/xQBjqRuINTZ+m8y7A4zBalz9cJaLf9yFGNFovfHyi2orewjgkuqKx+eirzPR8cXB5OurcGxCvVii5vRkTR7uJN9Vl8alBz6RT3P4ASRmlrtMJ7WSAywE6Rl7DeurQJzpy5yFn11ptPw2YQt4yzJqCqiYmEITuaeZZ2NfRjvFJKu6Ssa2IvHBHY9mN/ddah82pepUjcSuDkM07AYKphOJIUseT8hSeI6tUxqXu3gAG6pOAZh8uFkWLS+qZ4oFgVn4jLY4V8cVoDMdSimJy9+mMM4Sn//1x7JkaiHMxwB2h19isasdknwP9fqY6scuCL/il7efasF/6Hy0M37eE5vqM1nKvQpWmeCl1slYuRbMB44ivLlmBaU7c0rY5OCrHysnvloG5jVnRsJd46rfTeCKbeaNsM851j55c9p/6MvkGBKNau/wm/sGUAjXPUzwhP7xziYGC6GRTHpo/Sy1aPfB6u957T1DQ/yPd+gPPc9S2Og8EZwRc36vg0RL0WYgZgfvE6O124hrOiXNOksxqQC4RRJhm9V/o3j9xuayXUVDNshRHaeIsosOdlModm/ACakAIegPOSlwtIIH6a5UcM6AndpJnOSwxEGDHWoOIABYA1F4FQHPycpjZEltHrBouZl38LTzrj90TmmUP5KORscy71oF9KDMNPypmzStDgAdsOwjyKkL4rmsGXduPMLCp/ADOfNEVNWt+s7N4/UE0PKZMEUmw1T9R0M9WQexLQX8X9DA8vEL+Sld5O4l2fuH2EZuB5E8m5q1FWYA9zWkQyJjcUhFZJxwS6sG7G2KU0Muc+xQbkRDrexEMVU2hs/Hxnl/zkb1g67/CfU7LxvHten6ZKzR+Dfq9GW5Zqt3OY5v3HPdZGkcFR/I7yQ9bdJNVpPrexc4DMTMCSTEPcBPihdJi+ia5oaYVeeGt8ylI/cwdMm2t
 6agcie0m
 vBUyDn0rZP1zXK/bRkqobqUjVjamrFo1nrNtNfJtOUiy4qAHRBOrJ9Ln1RsucoU8BDAYeD3b1aaKdIy/+Ot0aJ0n9TQsUWb6GErpC9uU+TAH774gOBydutqe3Fj34NXbRp8wgxb5OadzCt0t03ORef9Hr9LfTGLOnAauy2HUQxpz30AZdjvmEVAlWVf/fhcjLGysMPcxg+XlwdFT3pZGGLAwtR0+fJhOSOjE77LOZq8VPplP/iua7EuX52yAOxeLmZnFrEreUa9XlrZrLZLMNcxMyPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, the prepare_access_checks() ops callback is
not invoked, so sampling addresses of regions are unset.  Ask
apply_probes() to set those together in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e250b7080708d..f1be748e9a674 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3777,7 +3777,8 @@ static int kdamond_fn(void *data)
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false, false);
+			ctx->ops.apply_probes(ctx, access_check_disabled,
+					false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

