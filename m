Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0945C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78F56B00BB; Thu, 23 Jul 2026 00:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C294F6B00BD; Thu, 23 Jul 2026 00:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66F06B00BE; Thu, 23 Jul 2026 00:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9218E6B00BB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:58:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 192C7C013E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:58:07 +0000 (UTC)
X-FDA: 85018834614.26.7E351D4
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7CFE040004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:58:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KmCcYRhu;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prRkJ8J9CasuULDtKNoROjKzd5fvtcvvTAb4zEJwJM4=;
	b=CzeHveNLgZUTWVAYRKdutfOprperQgEUcHUMmHHEGGiEN4pSL5q3+U8/XWtkc+A2MlzDhV
	DiIUmgWBfFWA4kLxwPNdMYbJmma3Bicrde/NYi3WDZ6kFaE6F47CJsYd6sctPlkkd308Ft
	c2W289wyrD8wM12z+ZZ9GBD1TV1TiUs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782685;
	b=mtiM8QWdWD6WtkICHK++RiB6KMdX7JBh6dGIcrlz5ZBTlvH4lz7EUxkF/46Uq9QPa+eBNf
	+MMd4PJC4BHcrmvIscNz0iqJUYRlO/BkaG248LZKBKfaBy+VMRdAOHBS2rJV2DI39EXtDE
	aosjCDb2KMTlTH2/pzhxX5nuwOrS6FA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KmCcYRhu;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784782684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=prRkJ8J9CasuULDtKNoROjKzd5fvtcvvTAb4zEJwJM4=;
	b=KmCcYRhu5anAL/i/DX+v0R13XjAs/VaCS4vCeyb8Azi3l4pPu79amO/blrjC9wBfZXozpK
	kqExUkwMVYAJub9MC9wIPSjENjY0EYPJwQ+sG3C1ODonhgLFznY23i/IJ+gFoQSAVNjY0B
	mnL00RCS7jFQoHjgYudO/BhyJNiirvs=
From: Ridong <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 3/4] mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
Date: Thu, 23 Jul 2026 12:57:17 +0800
Message-Id: <20260723045718.2052070-4-ridong.chen@linux.dev>
In-Reply-To: <20260723045718.2052070-1-ridong.chen@linux.dev>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7CFE040004
X-Stat-Signature: dnatxwerokxpqdpbyihetunegx9gzkqs
X-Rspam-User: 
X-HE-Tag: 1784782685-535421
X-HE-Meta: U2FsdGVkX18HlsXUbnGjkkI7Zeko9EpyQ5YKkrvouRvK6Jl4QlG/4A/+48DOaOW2gYAOonHqeimCyuPjvBo4k3bcoLbkk8bqTqudntx9eCy1+PCGZN2C07kF+bIY+njXXifc2O1TFwU8azexCScFGpd/7DbWHr+QsD1WAWHQ4IMS8SpmIks0o66m90RPx7dWBjy0m53Sqr0QLY9orwxG4AF1zIf5b2/5kBeeCVe5WSnTAul9WP7voJmLBKQUdtOWWBnd/y5WsoWFmthHhYqZJrIt74RFLFeWwBLotnEzdPbP/6m9pogoOP3YAuMZZnqRekIJqvYBLzzw3BdWVq/TgUMDq22ZOtsnkxHOk39Blyd+ffIsldKEeHuoh6Mq0nLezs63NIuXjiGqz7LVXLrHp+zMidMmPZyWnC8Sl9+Ifj9nS2o5a4+zCtTfbUefTqszS0DfKXCLZlIWbNU1CgqIKhtF46EPjtwlwfs5MTXPbEuVRoNrmBxalkNuup42V+mDhZJP4I0QHdSu9R3zCeNuqpYRQZEUPBM4hrxRK2iCT+wJBIZc1WVmNQEiCzNKEOV5Qidp3hLZEoABhQwPsQ1Z8lOoX/7z5nfhDC1mxZmVzm9khb1D79unWUp1FLHmko2fQOIuAQCN1WWB2kMQo/ubjPWLcPV222c1kq/erAqQN15ypa5Y73nMxGarYLIK94+eO04INyolEYJV49hFYPIIj4XGKK1HChBmOPxObfiZkq4fe9a8kQP2X+J5c7jumurBo+Czvmt/TpzwlfDwBz/J7n+3ijdM0ziybX48i9ga8vw/x66aM4YDfa7XyBf374L07W15UY0A/4SgAqrd+3isl2vVOaXt6oyTFgC+bSRSvyfFtXSHtxLsbQJWhixmyCd177LG+tio4wUPxT/LCt72X5iZxF4ufTPfxc+HML/mR+SSMWMY9AHYswpQL56TshyvUjPkYEWqe6hcdU1qagu
 MbrukMea
 pRWZZ2YNauVDBI0DIed/WCwpFA9mYxyPNbR8se3hh7EC1rFxo5UlqQdPuUqCw+8NOwHh9ZBAUlksI2hNskyg4yqckBAyXu8+vPmHWoIOIfZozWW9+nj7qiqaN41JrJa2C8Gg44i4LZrnW+rUfumzIc9TDHF8ti+ZrYgTod9Lwm6ZehFIbP692C0GJzu6ivVgbQoEn+BMG0g1eaAPuHR3BW6a127zIjlqDZPMP2FbKZyOS7mMLLSNu1wY0p7UcdqHM76zh9IQUwZdjNCnOeusa5zAz2FayRnOxQbYQTQRPLa9esdxgbeZhLelPQGKc9kmsipX7b0uOzlx0I9u77fEJvFqUhIvMLlQGs7CN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
moved the scan_control construction out to the callers and passed the
struct in by pointer.  After that change every use of the gfp mask inside
__node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
unused. Just remove the dead parameter and update the callers accordingly.
No functional change.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4b62d6304c49..859655fcf60d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7748,7 +7748,7 @@ static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7840,7 +7840,7 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return NODE_RECLAIM_NOSCAN;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	ret = __node_reclaim(pgdat, nr_pages, &sc) >= nr_pages;
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret)
@@ -7853,7 +7853,7 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 
 #else
 
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7955,8 +7955,7 @@ int user_proactive_reclaim(char *buf,
 						  &pgdat->flags))
 				return -EBUSY;
 
-			reclaimed = __node_reclaim(pgdat, gfp_mask,
-						   batch_size, &sc);
+			reclaimed = __node_reclaim(pgdat, batch_size, &sc);
 			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
-- 
2.34.1


