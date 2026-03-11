Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC39FCC9B0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B636B0093; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B91F6B0096; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1556B0095; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5F06B0098
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2E21160620
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:34 +0000 (UTC)
X-FDA: 84532654668.06.DD683E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27F561C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUFZR4CD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2dE3Uwu9fE6iIISJltr2A/Nq8qzAWYcl88tLtMysBQ=;
	b=cBG6w7mz2BnaD6cvj3QnPuCU3gBsG223eIKgv3RSYbrEr1wNLjnLUAd/L4rpKR1StBMVP/
	4WDtVD8zpdHXrdkLpMoL5Qw71vCA38byAxGshm4LVl89NA4b1KQMxsoW5adoT/JnPEx3mV
	WgyDg6glSyhzu81XZHGTTHNTzeAeZos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206973; a=rsa-sha256;
	cv=none;
	b=3WpVFZIR3h6Rm1Lp06G3kz0TTnvtAnuqaHWACLCnfVXd3n3vLBSkdeoIHXylqlVahrUmax
	mJUUzuhv5wpOSZGx7PR9ReGOVGEeofMRF82U8PqUqdK4igNP/IVAaTbYtTUD1+Z7g8Orjm
	7xy9xY3GXLT/9qqQYnRZEjiY0rJoBps=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUFZR4CD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AF1C4454C;
	Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3B9C19425;
	Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206972;
	bh=ESvZf4UkUBS6SSFEGCLnD8WnAsHOvLPTsDE9mnF1u0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUFZR4CDVcc+9x4268CeSuiPQAG7y6RnDcoFnSLsGZUpeyOlKbFXFR57tXoUAc2Pz
	 MuyXRVn698cI6fITK9reHO5e0sjhJzUrk5FvfdQ47VdrcLkn5lQLSHt2R954aGQCVP
	 tnkYnn7+hYO3K1C+qNX7KkQDIhMPc9eEHdwQbOXQee2BJkDBoenu/6/vfUsW5bHIP8
	 +dJJMg8up4CPyIqSXPrEwm3voEah2VnWzmB+HYdboVkdY+xwYo0q+umhxbQjpyXl1x
	 nw1r0XKO0aso+lFc7m6N4okCw+Gjer4L/UsDsLL4zfCM8UITryigJQrAEYZ7Jphb+J
	 Fjahs/sBzuY0w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] mm/damon/lru_sort: respect addr_unit on default monitoring region setup
Date: Tue, 10 Mar 2026 22:29:26 -0700
Message-ID: <20260311052927.93921-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-1-sj@kernel.org>
References: <20260311052927.93921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27F561C0005
X-Stat-Signature: ne3db6u1e9atcwwcja8terafmp8raf16
X-Rspam-User: 
X-HE-Tag: 1773206972-217158
X-HE-Meta: U2FsdGVkX19h/i9PAfI9vobNBQyTaXsCWts1ahxfMqUjaG5oaXAwBDlRYADy3R8tpXtqoBVpQGc4KY7vEya4hZiVD81pXfsfdTXG1EVAhEdxPvAXxxTHPrZdzJhps04zfGrx3ykXopU7dKJrHwvYcxDnmPZqCdew9i8pYquiJdPPqTN4oz3yxnDTw4m3KRp3eVTqc3so0mYBA0fBTFoJw5skP5oYh7yk1wOEj494vdTaiz+RmOOwy+BOIexdS6/DVU7S0cfztYLM8PIYk2/Qr6M2+mSW4ADFb9k8tmCD10yaz3308t1RCOPCDmrDJe0o35hczaHiZXXtoP3h2OCeO72M5g3jI8D7dMYo3Q+ePUos+pdIfJEfYn6ObFMf0jPJ2UmpDYI5m27mP/L5jcZRjNeuRWnYprxRwpdyPNRnTx+XfYrXQd36FQ/ZZxCWaJc0Cn8Q9ScHnsQBZ8245zcTCMNVH3qpV1C8n6rUcf+Q+lOA5rVmss2N9lQc7GnQ3no00a53/ENT/PpIZ2c8eGUif23J37gXIyQ7nO4vIjvWPXsPlNH12f0mVhEVPEJqxyTDPTdsgPOcCAFSJFXrAdR2wxAX4COXyznirxKxtDiLj4XkO6jpLb+frJUpWMDsn4/HiefkEaEr1kY/9o9k1zYEisUc/B8I7EO8KM6JF3gEkz5ocUwSnr+WQU4FwHn8ohftDvAfSfwA5GERxzY1DZkyPSFhne69xHskmUZvog4Jv9gLPLUf7IM42ytXNL5gDEGBLkWUW/s67cOzOTUnp903T3ktu5HK5s7/cm1dlAOFtrrHZcE6AuaZr3wuPV1wfvdH8113NRC3gvnsIGZi4+IrIZpE6QUiHy4O3/GiM/OcdVt//8d14upO46311KlHAsZmxozjqN//Qp0F7x2lX8FhXQeJxwMnvM3MFFaahzg+bYO6Zybxfmw6RO21W1ztQvvYJA64w7cu6VyyRE7oedQ
 n6iWDgEX
 S3hldaLquOjICDIm2gzkirSr7fP4eNAbu7tHZUFzhUC6wQswG4jS10VvY2rg8E3fqDnzD4WLHrhbHq05Led3FWAuIaTI7pAiyUrgSnIqH+aWOMl9l5ftatE6VNBFsnqR7P9nYgwoPmbpY2710si0upUxGACTGChzlabXIVi6Bbf+jpXxHK1sNbaQhD2qY3cpjYVpd/SVRz9fQmc8m58VOYueqNjr70r1QXx5FJi4ZLMwb6PcbFTtoUqsv9IKaLmMesc/ULOWr1bYWyBwOyEITTW45pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_LRU_SORT, didn't support addr_unit.  Hence DAMON_LRU_SORT was
silently ignoring the user input for addr_unit when the user doesn't
explicitly set the monitoring target regions, and therefore the default
target region is being used.  No real problem from that ignorance was
reported so far.  But, the implicit rule is only making things
confusing.  Also, the default target region setup function is updated to
support addr_unit.  Hence there is no reason to keep ignoring it.
Respect the user-passed addr_unit for the default target monitoring
region use case.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 133ea17e258df..554559d729760 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -291,12 +291,6 @@ static int damon_lru_sort_apply_parameters(void)
 	if (err)
 		return err;
 
-	/*
-	 * If monitor_region_start/end are unset, always silently
-	 * reset addr_unit to 1.
-	 */
-	if (!monitor_region_start && !monitor_region_end)
-		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-- 
2.47.3

