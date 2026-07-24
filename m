Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5186AC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0B76B0099; Thu, 23 Jul 2026 23:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977EE6B009B; Thu, 23 Jul 2026 23:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5746B009D; Thu, 23 Jul 2026 23:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 557746B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:35:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B947A12026D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:47 +0000 (UTC)
X-FDA: 85022255934.15.502A610
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0909B40006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:35:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BanKC+Pq;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784864146;
	b=KlRJiFALOCY8URLUFsqADwsjQ0SROySWTDMLYFp+F1npJCZg3R1ckymBMknRuElIYPj8if
	tVBbTuXaQdkiAsOLlVb75mjZJXZmiHM+ao3PDjg226fLkohn35ghoQX6ohMLZ3T+UvDEby
	OLhFGW9tDTXbjqL4/wMmUjokmCuBYfc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BanKC+Pq;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prRkJ8J9CasuULDtKNoROjKzd5fvtcvvTAb4zEJwJM4=;
	b=JrxVeXs5w+7MnXQeP3OQ/cHYxLU17vAHDBgwdvlCk9o337o4FPiUblqZDXDcdOFhqzq0SH
	DtJz7cMY1TPKKL+pSIr5R/am+41Ukkl58MN/3+IXypNqhxP85tQauBgOMbgPEtTLMmjXEt
	xGf+u1X9qZuQzDvtqW9scNWuo4CabKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784864144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=prRkJ8J9CasuULDtKNoROjKzd5fvtcvvTAb4zEJwJM4=;
	b=BanKC+PqDq/UEYb+NLt7HcTTQ6xc3q/hMkAk4LlCZM8vPAfzMNG+xRbgukojZHo3bY+tzL
	E4IrWHxA/IiHH2IqB+L0Pd4Yv+1+MisNpEVAbVifAfKEo7WGhED8RdnuyhouLrZVOkij7T
	vbOOy+0Y7J5nkEhHDNz78N2QlegKQP0=
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
Subject: [PATCH -v4 3/4] mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
Date: Fri, 24 Jul 2026 11:34:34 +0800
Message-Id: <20260724033435.2573323-4-ridong.chen@linux.dev>
In-Reply-To: <20260724033435.2573323-1-ridong.chen@linux.dev>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0909B40006
X-Stat-Signature: sf6bhdwsokcbfw5u5ybbpdcmy9wa6m33
X-Rspam-User: 
X-HE-Tag: 1784864145-23432
X-HE-Meta: U2FsdGVkX1/qjx6CkvO9jYwzM0dx+Td9aUqs44qeV1KiI9Y4nwnuP47XzzuIEfcTnqX/goz6fL4HRgv7GDClv/sj/cITFes8U8525jC83SMoo8zuxue+EosdOcWFvLVj+wtfGOupzEogw15X3NKMHXBJg72sc612+8ZnIjA3Teh2ZQPR4RYUx53yGpEkzdwO5/FJtPsma2Lau3QxvTo0RcpNHUiyCGlI1xC/ezvQKVmkFGhvCZxXfu63+gAdXSsCeHnFB2/kTb1XXA3/uAaKS2oM9oYar8uqb74j/Mqqk4+/5Sddr3/E4dwJpNjO81ersVfWKMP/UK4oTUl0E9bnTeGE+Dh8IuMePy4K3/MExAbNl+y6dOxgJ7xHd+ZgAfYTWj5o5WZ1in18OPcCONr4boHVSajQP+JJt5CvMmqn+LOuse8i1/6Y+wAPP4gggGOZezQDKRfWllD/94yzuueMzZk+rCOji7lrxusJ34ArSngeXfX6+/+1GOx6RrnJgMstn6c1++yBGEn+LuLjxQQ/v56KciQvLtnqVmFjanwY3TEdJC1zM5Q41hTvUseu4Jhh2XyZPz+FnIAPmNOxatFzpcDy8nLTYOEwDRE3OaCJUBC1sKpss0MzIfvTtkk2HIF6joN8j0PG5ZLs21LjnG7lsTbfqVBcqqeBWYrfl5tjOHu9J0zAtTnrSuGBg+zKXSytU0XUzaNnaNAuNJUyBcBI7DOY5K76Z95V0Ed6VPDss2dQ3YrfBkueyUW9jK4O+mPQDLyt9hhrVuzKoh2Ps6EPEv7P0etlRaLWhCUJ6F5bKOEQBbv0GI/LiUOIulwZoF2hrN2ltInskaxk1/IfEVxrhosenwaNeq0zkWfeh7bAYE+QAk6JZYFWBaYs1IJsA2ntKVxNzuYrYyd3Ke9goyfcU54ujKdymA6NW7fD4xYFsqj7CZPR+cGQEDQfAP9AfGPpuiKwQtQyGD6qgpv5ICk
 uoW/puMo
 rXsE8pWwe8AVA+kwy70g1VULYeVdEydVEILMrZLrfmfAVoOJBjrxivcVsvk2AHQ8e6/AZCvF0XEUdy0o5eePi0LZu/wA5QIDAApKLfgAmGOk0XRD/tEQonxoSpI8V6cT00bnTlcpgInxCqySZSfF2WXey9yfl/V3P61NuuZ8k36ff3JoGTx00CNdtYi1psK2JllvpSKhksgqc4/fRfp0mujk20rrAA0w1IRYE93f24XA1eMKjnpyYTbKn5QZ/A8GJQqda4UbhdrcSkMg+U5HUykAo9XrUYNwCihyS7Q95eMryc6yCJ/uFfiJynKWfOqBm6UDGGW6BfWFAssOpwFkCNi0m6eSghxlou7Pa
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


