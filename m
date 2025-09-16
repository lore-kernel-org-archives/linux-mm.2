Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA10CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D348E0012; Mon, 15 Sep 2025 23:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC578E0001; Mon, 15 Sep 2025 23:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3838E0012; Mon, 15 Sep 2025 23:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 441378E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA14A5B346
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:51 +0000 (UTC)
X-FDA: 83893669062.10.C3F3B0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 37FC61A0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tufOdFMV;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvcFMk7Bn3PrOo2SJvqdydq4teNxd1Uc2BmDUWD3KAE=;
	b=1SCdLePVTa/Ce+AwQpw+DmLfLI2W9NzklA51yKzDAG5JveLW2Kt649oOTo0YWSPbf2r/T4
	aaXJ35i0nQ7m9crFo/6TaMp8Udqi3Ef8ZZZrs5ywqbBvb9F7al+pAC3I/jLcqOyMVW8YY7
	CNMqv7PaiB5TeBEU2UNnmFC/EIfzWcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993030; a=rsa-sha256;
	cv=none;
	b=zJc4F33gwpROpmZv5DwJEja23Wnd8wqrwGeiCpmMvUq+RXzaXi+OQb7Wlo5w4aTxHFXHoq
	DNHy4zlGjMyKBYhRnUPf21KDd22Sc0lclufyq2bzSidoj/AlLjc1qH5ilwdrWMwpe1ei35
	CZfpScqAg4YM1jVXW3j+xsiI0zyhFSc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tufOdFMV;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CC0C43FCE;
	Tue, 16 Sep 2025 03:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046EAC4CEF7;
	Tue, 16 Sep 2025 03:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993029;
	bh=0axYTgZO105/0nA2HAaiUTIqb7xW8bf0ptfQmVpueWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tufOdFMVXOfv/6C1Hi9vrpLziZo0X9Agk0fVxOuD0FyDivUUqCz6hDp475/nfMPbB
	 LYbP9VIJT/+hJuBYTIZ8mkoWUfMc682pA49ARAjoeCGP4AWykOhCVl2Nqnehb1tenD
	 HYH0gPRLncmzTB9PN5VMnnuajcZchx7Lo5DJQ56fpG+y8SyAah/fPgnR8BZVkwG6K7
	 +ybw5nnKvqM29rmvXjUZGCBdAYNjXGHLxAQo1TiFixrfw/k6AoMMAZLPKXCVv0O7Yf
	 KYMIOGfdUxZsWaiCW9IVLwLksQkrPlxZdpzR6jtqJE43ihfv6JQjEg3vz6SpiZSpTV
	 ubFGooweYY1Pg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/5] mm/damon/core: set effective quota on first charge window
Date: Mon, 15 Sep 2025 20:23:36 -0700
Message-Id: <20250916032339.115817-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916032339.115817-1-sj@kernel.org>
References: <20250916032339.115817-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rajnxtsb6udpqmacyop9ni38csgif6fo
X-Rspamd-Queue-Id: 37FC61A0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757993030-630802
X-HE-Meta: U2FsdGVkX1/8+h2iZ8zmjIyy92+rnnuCWfy21erxoc9nAa2xUYKz2Qw8M8x4ZYLODbHfB59xcwriZtBXOTi2krE4379HUmpy2xAo7sQz93+7ETM0HUSYW9/7SHDEh+aXTzc/FcfryjGVo1OJtYasol14OEQ2wPzVW+c5SeP0SkGSwq+fcDaQ9LM8GiNb+tWIjv9YmML26V+QpOtIRw/zL57d9wup/9Cg10fwosHoRNYt4LElz/C6Zbk67kpPi+4Mk6lQTFHKhfTE9uFXXh7/pNfGC3B4UXS8gKecdhFN8RFJbYnz8JSsHhIM6rr2ktv/pK3yhm+/JS8+wYoFc7KKA81cBLDsk2Qat9+yb17Up1gCvkMsnlQopnwmsCENR8qfbkOT3WJ5xe0FvZqbhwhGnhvXUlkXoO86ZY2QJyYUT0uv7+SDQwcSVOvZ/ooWv1qiqabpAw9dLQ8lZlBsgCiK5/BZSOMdK9lITE6mYJ3dJYCtzTmSL8yae7gfwLC1UhymUdXpnLNoFrK/HC/px6UwJ+jLFIrrUhpiHkDcAUg4WDgqWToZxhkuzQzWJMfF7sJvpnaXM3zAze6o7eUbvcirIxAOIJZLAwiv0ok4srGtqyOJoGX4SXrOVHaNoIum7tj2GNyKJ1SMr3mksTcSfJRpouhT/53Brqj5fzaOB162Uwf/5bBztJLqfk+2cEDNwUI2797UsDbWShWAo65HtJjDBI9YAguHGjxAl4CU6gy/QoiQnMmP9AsQwAghWO+23U6TXWonkuwPQzeIdnHymtmfnK2nay0buSYGWy7qmhCMHZRkbtnm6lNJJpZyf0XNag3BCo4tztawLTak8qbhaOERs/sDmDwzZyFO3FMl2KUgAAPr/tXUvoARdqeK2Rd2X07fcRFhD4x5Q7QxSncXacNnAP1DHeM9rkY9Lz93oS6IGs9fRRbdHJ5Z89ssGPOtio4L2wApKcYsFlprfmpLKOM
 uJzwNOLk
 OdZ+j1XcCSSP7xKGhbfgjEyOTjMwhGIudDQITfs+XSvbxz1MhO3IcdcZl3iotHpJ0XVcN6reh2E0Nuj4fgmvqYsmgMJqwCpsFbrWRs+XtylfFPHCl57OKVNVK4gJrhWfNqei7nB5Nkl+lWYnEhmBH5AoMdJohiRIoGfdxB66h59iOWa4Jhmm8Ji8f+pMjCjqKyFCl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The effective quota of a scheme is initialized zero, which means there
is no quota.  It is set based on user-specified time/quota/quota goals.
But the later value set is done only from the second charge window.  As
a result, a scheme having a user-specified quota can work as not having
the quota (unexpectedly fast) for the first charge window.  In practical
and common use cases the quota interval is not too long, and the
scheme's target access pattern is restrictive.  Hence the issue should
be modest.  That said, it is apparently an unintended misbehavior.  Fix
the problem by setting esz on the first charge window.

Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota") # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ff2c6bb30621..775121ae7a9b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2142,8 +2142,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		return;
 
 	/* First charge window */
-	if (!quota->total_charged_sz && !quota->charged_from)
+	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
+		damos_set_effective_quota(quota);
+	}
 
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
-- 
2.39.5

