Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD29C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C7D6B0099; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FFF6B009B; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC336B009D; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C183D6B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4514680154
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:07 +0000 (UTC)
X-FDA: 85161731214.16.B847755
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9C27F1A000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IS4NaUCZ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184985;
	b=x6L5ulbT+fWpL2hbOQ7A+yaiAI2nep/T4xGGFZaiFtRAFD2omHwfMDUFNPsa+VHdHJdXjq
	HMwmSbq7x0zjo7hxDi3uR5qpYK2WNVG7zRfkcOoT/rTABpsJ3JrLKn0srmH3Y0L68xkl1a
	YsqMG44UEDa7lZjF9ISK5bY8eutwQCA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKdCBVqYdsKdXO80RoHHV0o5QsCfADzPQf1ZzSc7B9k=;
	b=s5G3HusCGHZoIGDzM3DUE4cZSU6pQ4uH6UxzBrOwipERSPPR9tEcSy47kX0c9NABU+vXQH
	Aeth8bDWWBlS+xYViKL760l4Rhzu8ITmfnWPfj7o3Lehuk/bSR5BwFuVOk0mG2Enk9yaQl
	AmtzAsDiMp2e0PKjGYP2/cm8F81f3jM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IS4NaUCZ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFB4843675;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BF51F00ADB;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184984;
	bh=XKdCBVqYdsKdXO80RoHHV0o5QsCfADzPQf1ZzSc7B9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IS4NaUCZQl4owxLyOXkjofnED5AIG5ZNyQRpkBVZBoyMt8ateeyXPEa7lNhU6i4J6
	 OTne7u4RNdgEO8kTKPD835bdYHYEIzzIQsr5p73sCK04IEq+aDZU4YtXGL9/pCaiYr
	 p0M+iMo+J64J/7zmfywqh5Eg8+fE6hGs9MEkbpP7sV94aXy52aO7mNVdDsIV9B8Fz7
	 j9fPrxqbBOFfNuY2etAIKQua52nNoNhmwemNj6VzAu0yVgptcjyIMLlSBkrD5s8WK9
	 TR4tehQpFQtRK9ajPeTGv+B1PNb1AcKYep11zfhv0Eh+3+1Lz4kHLDd2NQWjmQ05HJ
	 nH3HY0AzQivCw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 6/8] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Mon, 31 Aug 2026 07:02:45 -0700
Message-ID: <20260831140254.72004-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C27F1A000D
X-Stat-Signature: n9ba543kqw9pyam4smke9rbffnbnau86
X-HE-Tag: 1788184985-194237
X-HE-Meta: U2FsdGVkX18rDm396GzDDOQGGuGBZEu4ifnjG/YJrN6Ueu0nWtN9f5jzef911iGwSD2g68dTlVVKDBc/ivSJcdwqBYL/otpDvQNT/DEUko054Q76KmakzgS8eUq5TrnyD6o+kvs7Hh/Ts2Sg6F5wQH51lFCXgpX4GjjjKeql3wUmdknbHx2vdVrG2L1+qHd+uM/WmoweTJMU8NlsuyqAFcNwsUlJhOkb9YotX52ZfR25NEYZTfiCpQ1NBa46hhe/rWIA8DGYGmymxmdrcsuczxxCvFQQZoqXHxXi8iP0NoZGG9QccsE4LHnRqRtBQsWjmWaZZ9PuCTOFeyPUDq1Iyg42CVSkvdnj8xVuNGtVxW7+x4pDN6haK09rCoVPZYvIr4BPhW3vakj1/ItuFLpdzlSkeaV96DgYoUiXCZ3c++lfRHVAm7r6MlZdFXOZV31NSuqj6QSYCXmKiRD1ZENJfjfX12MiyeGK0B6sRzQLNHxpS8iOO/APGgHCipFLK8VOrXGgrFGRUAz4JbsvEMi8FSPe2yx/fEkA1JIWV2pj4kO2AToQA14kHS7nre4yUPQGVDn6n1QKOy+6EXjC5x/jyRABzm5+XApmXxpHRgWCdG0x/x8/htj6nq0BtnhPjsNPewO5xWKJEU6akMYQ/1vDScE1KqqAjMyPY+kuK4EiEXaNBsCy2eERvI/fsNjkBN/G8dGXyW/Gb1jM4o6GvEju5xX0eZASV7RG9MYg5XUNwlAjxyH+OkyW+sJecs03VX+0dQq/e9eoDyK2Vvf3r5WhR1L2w9EQh7RtveRY3bE6TqxKcEbcvCayRJ3/Mev4PDP4XJvMAvyuleTC5VBhYu1wcz0jg89DHMtfW76D0mt0BXJbDYLgi9fCGxhiR5VeDBCkbUCe+1S21fysw5IXABvc6pU/kczcTzcXinaGAtxKR947RM2/KD13XVGkKwTXU/gjJG+zFsfktJ4Mxl1Q/lk
 mDklKAIz
 sz/rZsU8qX1e7LllnGTEbF8XHDLGeqtLg7UK8Cgp8JD0s+gZord/bKz+IEHKqeMFQ1M3HDU8dr0UNqmUq0s4jFA9NVSH2e65ADA+YollV9kMfTkW8iwpKjalzSIVgHYIqvJiD5iFbkkQNDCeqBmob6RN6i61TQBnfZHtIJMXD7IoLhR/lFgoGezaiAQxggEyudQgpqn/YeZnI70LyhhY5Xfg2sUetTJcwkECWXToY4oUUfVbOV7W4wKRi6kPxpwucSgHOQH+fe89FljirqvazBCtWXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  It could also show free memory larger than the
total memory.  This could cause underflow and make DAMOS temporarily
make unexpected behavior.  Thanks to safety guards in the auto-tuning
feedback loop, that should not be a real problem, though.  Fix the
problems by respectively returning 100% and 0% for used and free memory
queries in the corner cases.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e2900d0c984c9..75d71ac09515e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2816,6 +2816,13 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < i.freeram) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 0;
+	}
+
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
-- 
2.47.3

