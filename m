Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1180DF433D1
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6136B0005; Thu, 16 Apr 2026 01:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0978A6B0089; Thu, 16 Apr 2026 01:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7556B008A; Thu, 16 Apr 2026 01:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DBE036B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:15:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BBCCE429F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:15:42 +0000 (UTC)
X-FDA: 84663256524.06.59B0B16
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 47FD7140009
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:15:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qp3wtGgX;
	spf=pass (imf09.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776316540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzCPqRfYWNQ3O2cYuHAxJrU/i3tD03jXJbGUMk0bn9A=;
	b=dLHeJ25yJc/+aGzcouwVe0HfbJrA+Hs825656owYFaTJaX4lfeO3n0C+xTfRaPfeg4EklN
	0fPGJjA8fT1mh1NxxnwFpOmRHdjySHpEOsYNcKOf+lG8yHU7ECOnSdsfdwLAoLp4PJNM85
	eyUQw+HviNY1S9G8wraAFc2tHTHxkE0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qp3wtGgX;
	spf=pass (imf09.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776316540; a=rsa-sha256;
	cv=none;
	b=b6TJKpba8LD/amvRrveFNG+GA37U7Uu6QJMvE8PaJYTi4tTIFQ2uhS4XOuF+KDpmWR3QVa
	ig101+Xq9uO7YiCVqSTtxtXw76PZ8YelmJqMnfkImejw74aQQEaYKE4UzAEB0OBYNLrrhh
	wRbkWN/JTSQmGdQfoM6/y9khKR9teak=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35fc258aaa4so2347053a91.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776316539; x=1776921339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzCPqRfYWNQ3O2cYuHAxJrU/i3tD03jXJbGUMk0bn9A=;
        b=qp3wtGgXJgzI5per55M0a5sbO1N1n9SZcwBoNm8v3k3Kq1sVcoNhPw26s1GgqAVWjb
         zTpDgiEHJfWn843FBK9/Q9SIsXWVdynFDPgDRQrgsOSSHmrSBP1GQfi72M3tIbWaXehs
         EZRxysKNxU7OnkMhiLTZ1r25Lp0YmORXEWGPYjdUKd48BkqLv64fdicyHrWmCQIHAAj1
         cGcK28G9FIXdNjjkAiTZIuCYfdC2rPij4aUZAgwINDcImS32YqDWCJHEnb3hPgFRja9B
         2naP/ZDiXuLM/J5hb1nm97XL5sN0NYuPvLP/L5lwM8yjuJVMpVenlRh9lcfZrpgd+qqH
         /4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776316539; x=1776921339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yzCPqRfYWNQ3O2cYuHAxJrU/i3tD03jXJbGUMk0bn9A=;
        b=IyEhgQsHMdXp7YXjwi2oDonaSh42K6f1WuDE0QsFl+l2LeaC1V9eYr9hKHNsqTXqW6
         ht3Yd/ExNiTAjOr77494A5PmRQGzSz7cUHolwsB4lu5Szo+LUgpno5Ay5+HE5h8VJ+QV
         aHN8dc4cpxwKnlXYb1JkglUol4puU87NPpVq6FIZyTSxoIbKkfO7VkEBo1ixP2BePXng
         v4u6HTvJmR+gOEzO/tq11AH1jGPxRvW3Ox//apaUcxRCFVzC9yHTe0ec+X/roJ/aY+1O
         bQlGTzFfK2vvxdjvr6/I3io6GfNKrKyhWa6d8oSLIbHZ0tN4V/Ow1lmXHIdtfajK8nYs
         UV8A==
X-Forwarded-Encrypted: i=1; AFNElJ/3FHqTBPoignuwEbNqs+HdXP7iY7nm4Uv1EaV1iyrQva3zi1t0+aUMrj3UMn3BPY+zH5usm1zKqg==@kvack.org
X-Gm-Message-State: AOJu0YwCXyAEYLht8xTJ9/o44uzKVVmPsvJSx61q1zhZgwJd7EkIhQPM
	kbgHw1UJyTIJGeUibe9bF9CycdG/cukmoZ3JBbPG382YIpWcvW8jrxP5
X-Gm-Gg: AeBDieuVInVWZ+GOjNDaLmLrLhGgRkkDIixP9lk604MfTpef+StMx/c+jw68/9WDbnN
	eyTYQE2Bc3xWexJGNKcvRfQLYvH80ySv+jHF0Vhj2nNZcS0g/7oIfFLq4xSPkDQUA6L7jb+sB00
	H4Rv2z/vuQ7BAZBTYWKv4NLOE1Q0D/tui9Pj2LYYzfgKhhCgXsDaSF976RJ7wzd05cqHtm/tFOL
	oONWDguJQ17gYWfQbSLWT9LbYks4h42u+Z7ycXNnh58kCjhVTRkVwOW2bgbFfi/pwC1RpdDzizX
	Pmson1wLolWjWPwJLrLsbiSsnIEMAI0IZ/JEOQRNYyItwQMr8ibjNWuS7h2WfxLKsYKY4iYKV0F
	YZ6SFyHZu7P7LhNSOrFsBy4Z58U8Cpp0en9OstFpRC/5EJBvJiGwle6u5rLRle90D1rkY65T71R
	cpx079Yp0H9asH3njTMuTk3SF0uWAdYq/F
X-Received: by 2002:a17:903:94f:b0:2b4:6367:7b86 with SMTP id d9443c01a7336-2b463678a27mr136040735ad.37.1776316538890;
        Wed, 15 Apr 2026 22:15:38 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4782a89c5sm37570585ad.61.2026.04.15.22.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 22:15:38 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	hannes@cmpxchg.org
Cc: weixugc@google.com,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH v2] mm/vmscan: fix typos in comments
Date: Thu, 16 Apr 2026 13:15:33 +0800
Message-Id: <20260416051533.708909-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260416024248.687943-1-gxxa03070307@gmail.com>
References: <20260416024248.687943-1-gxxa03070307@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1eee4dm6yskszz17o7d1ihhn3gp76qb8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47FD7140009
X-HE-Tag: 1776316540-638355
X-HE-Meta: U2FsdGVkX1+YPgeHYmg6M5hRxOXTZMy6vIw51hkqFFfuLMZtjSFmXtkk29f6pnXx3nGk1kt5YjNqAM7/LbnGWPtuCFrHyqoZPfTpJddiu+ZHDWQVgEwCE3zyOKk9XbUXcckdu4tv7jpQfC+4RUQCh0/w8gtxLKzQnjR1LbsvASqCZ59+dUJMlcKwcr3zBuGGgkegv/VIzs9qmxcViVtutI+PXwC2fgm8VWn7HVSTto/c/lHvOFps1LKgYQbsn7v0I03juGW9G2PgK2YcSuyNVJZIlK8PINbPmDArAVqNd6GfSkj+vZ6W+6PGHpVrhIogKuXxu9/K4JBQ/e7WbtNl9ahFFBFY+AD76XTpYtnYyqLInCIbO07hbzaMbrW2t6NwfOopGwLeLzm3A9JK+pYFF+ECj5IEdSSIxM8iBgu/nZDSjxfXtyDdMptJT6aZOTLiqGUdgSL/4kV/DTYCf847DY1w74kKYEsC4dmY9YibbTAeaK4Pas2sOQZOL9lPKN9rcHCwTGvIfUXBPps3WA01WjLVpEnmY9bs9GSmFLlO2kwgcNVOqN/kBSlEO9vRr3g6oUc2r/6foFqDDli57+HUBsc+U1T4gTbZOmoL8MlRd6W3t5HGOxscTgx5KrYXekZBYfEnjr3qEM9KoNIqL//+Um/K6ByEoC+FebZeOmiwO+pIEKwGcsQQtX+qmvI/BjQ/G7Ts2pCZlurw7OfizMKglz9lMLZWAUuIxrKsnPQvdY5qQljAHUbbri5+ryuTqDR+2VttzVsAdDRSrSiGlgAjdOUJIGvc2UXBA1/vyOVfOkrwhiEUXXCm9vQasDzDqWO0n8qBPmUu7quyhsDsGUOV6wIRlPc0JmBY95JKZV4IQ9HWN8qdTVBY68IOnR6UcEVRY3R6Pv2Y1NkG8n90MZBLsTSQuAxwzrVo+QVAk5cRKmluK3MySw5ZTCSJQ7kK0GPDRshyTfONCi10gHjvbhF
 WbIeY1iL
 KiTofnRIBWR6Wxw4TFfy/K2g6uJEsGt3RqMGBBrLkCOt1Tzi7JoM1dmsWqRMdUyKUDEjQieJ9Ux8rtHVKrJTaag7XNqVKZdY+NpCPCbx3lP9cz+hvGN+SzWLmHAnE3YaqCAxFM8D1rzFsB1JafYT3T0equzBKCqB+bYz3vPhySfZqOTD1wkWM4pnFDYs2JhiLkBCcF+23oWO3gOjW6Z+Tsvk/PhLJj0cD/ugArvlOsfIOx3DZ3z/pKp5XqlRqfNPrFTvgXTgwwQwWwfr6CmUVkSG9+adKPd8Al3ujzOVweMvUH6+WMIDNmCttqVqc0XEzQCyQrfqGvXeQA1S8a1zDd7OIQn9rpByfnnOd5CM22bgktpIkLEGlVBaV7iNSLH1Hm2C+WYP6ZNKejTebaTzIKtMmOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiang Gao <gaoxiang17@xiaomi.com>

Fix three typos in comments:

- Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
- Line 6208: "prioities" -> "priorities"
- Line 7067: "that that high" -> "that the high" (duplicated word)

Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..710fbe1ee151 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -109,7 +109,7 @@ struct scan_control {
 	/* zone_reclaim_mode */
 	unsigned int may_unmap:1;
 
-	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
 
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
@@ -6205,7 +6205,7 @@ static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
-	/* Throttle if making no progress at high prioities. */
+	/* Throttle if making no progress at high priorities. */
 	if (sc->priority == 1 && !sc->nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7064,7 +7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
+		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &sc))
-- 
2.34.1


