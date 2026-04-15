Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4D0F9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FF56B0095; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D376B6B0099; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BFC6B0098; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7D96B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E762E3053
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
X-FDA: 84659036280.30.903BACC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 915C41C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zuqu7Ybr;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsTMemCfzY0lhpWKvlz0/7Un7osB+uqGWOt7hdC9jrE=;
	b=uz75GWcjtjSY0SjkDJV6UFhXC80Z97nIBKu9MO2DNCaVuN9PVQQBK31vSm75IdcnilJxz4
	PhiUa6h4dLQ18TaA25j+vfr8mLtPF8NOavGir5esHTdam52yHe2HYL2+lUwoD6jKu1/kd6
	PFVSjhIutga5NBFTUk8E0THVQUvBK7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216058; a=rsa-sha256;
	cv=none;
	b=mm8H2QDQ6oMhZ6IITy58gpQi4tE8PiO7uOtLpEIsl9Pf0S6vOVj5vUKu1ibTe1mT/aCXgo
	C0WOhZuHXnPA5uNaR49DwhPBqd264gZZCU+Qs91OjLQHHNGmAT13y10j5vma9JCriqua8Q
	DWFL/1mHOQ5E+CVD04UZQYY8soQeydI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zuqu7Ybr;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFEC64457A;
	Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79892C19425;
	Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216057;
	bh=d7zJukuGsoRpeCy4tkwyJwYBmFc6TkPv6uDC4T8m6EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zuqu7YbrOifqoHzSY082nxiqYcDO/tBge91J9GrdcWoRwoXkGeQ+IdioKg/uFdhVC
	 Xw5IkdfhzRbLL0QuUQSeCTDI1STf4I3rQTG4DVoGdQP6Q2/HDQca7pXzAG075Lt0Fc
	 hTIva8vcI3ZgBAbV7aZ6xuPpLRSYcFx/LpNUsKE7+iR8X4FpHVAYWlOFQJNbmXwGNP
	 8efYV/WT7rBKYs7BNNlmLw2iFodhCBc9nIKpA2pnhjuXxVYsOCikiRmKCAvUr3EEUW
	 y2jbBC31jEJqRWuVOrGWNLPbASVU2+GGqnDJEPGHCIeX9YMJsA1hmoJxcptzLUaMB2
	 1te8pUaaWPvog==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/7] mm/damon/lru_sort: cover all system rams
Date: Tue, 14 Apr 2026 18:20:31 -0700
Message-ID: <20260415012048.76508-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: mxeus8h3m8drmqt6cerrq7i5gsfwksfc
X-Rspamd-Queue-Id: 915C41C0006
X-Rspam-User: 
X-HE-Tag: 1776216058-730076
X-HE-Meta: U2FsdGVkX1+NVh0qaLQ7cKymgp/tQVjhLHaZorEziWMQcRHUNenTNjiDSvbS4IVo4vHCQnyRGLoDT+lneQWsZH4XxxXuH4m9AVw36lQzPLQzQyAY/Jglb+yvUA9WljxYjP/JA42DtKjcHDRdJs9LsSfrEOabS481GpFf1sfL2Z4XSPeTPOad5BU+llQSKCvnPhWZQRPPz28Lp49Z++IoXX9y9pwWPX62IH2kibNNVS0z/mwSvP437fiOE72xUfMmTXgHY6ngaWyA946HIiyYQwUK16apRrpW+oQEFfrqOR5MgFideHLqVHJ2bYcPo11HS5DWC2+tyfelSLchY9IZkXSraH0kuJ9pms5reTbdzfkAK5hBFuv8sSHAPZ4uZqpkmP1Lp3qipt43P5zNjAbgNFpDGvcft1SuK8OB8WH2if9hn6+BqxkshFeXol7Bz2SPY1qGK3zYfErySMwPFgryl/dqK3DhjnudM4Jxmuw/swdPrRklPsSvpryN9COVnK8D0nd6prKqsVyFTwA8u4vkeBGkWEiVOTkp4U6P5UwtaMFb3sfPQgBiRGx8eH1wSqUOpj3qg+r8d5QfqbYToakGzv34FvIcXeWPnChP1Mt6lhJmZ2yEOi2IJ2QuLQaSz8XzHJ/PHgiL9qnHXUn/zph5xRea178zfDw452jjGmJ9OH99pPxgJozZVoTHN4CFWP1nJPDouCRe12wwFrbd3zym6DSNSwHyhIazixaxZQG1UJ0qwTE+NYEQqxbV0kFTDSSmIpVGZGYRsQlNZbM0oaH4vrfXx27oBERrOSLdyZAYD591tu4p5YW7JDoKAvnE/YnwcXu5YsWInQeGukxOOOgoOlPFMkxf7gdBMdmpF6/hk/9fZFIAgeIPFy3IFglt+Umn13anGW5xfgiBSAMCV4DbAq60hItRKj+8klQVwBCF9l9+82/vOTvM46L0qfV/J4XVdxASpU/Oxowb4w46DAf
 FYTFtqRu
 2mNYWu2qRw+uRiM7qljR402ZEJEaT4WuBSss63tP+xzhSxV3ga34mpRpQWf5h0nNgegYs6xKZhvsCkkNAqYq5+Nhp/eKUTFpyXHhA81mHkGhzOs/AufeMalDofsYtxzP3posNu7K+rdBJ51KymSO1DONg3sCI+o1luy/dUqmbw9iDe4/sgzsdQaL9RrIb2yJyv7+CnWgHwj9ESUO1lHzEJZ788dJjmIg+BNhecInprgFYfq9VAHyOVsao8oYSQL8Q9q+wFhXq+y3E9rnvBiCtuF70ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest system ram resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring non-System RAM may be
meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It
makes more sense to just cover all system rams of the system.  Do so.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 641af42cc2d1a..48ddfa6369c93 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -139,7 +139,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_lru_sort_mon_attrs);
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_LRU_SORT will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire phyiscal memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -148,7 +149,8 @@ module_param(monitor_region_start, ulong, 0600);
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_LRU_SORT will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire phyiscal memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -335,7 +337,7 @@ static int damon_lru_sort_apply_parameters(void)
 	if (err)
 		goto out;
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
+	err = damon_set_region_system_rams_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
 					param_ctx->addr_unit,
-- 
2.47.3

