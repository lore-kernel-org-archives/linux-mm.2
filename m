Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5C2D29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CF06B0089; Wed, 14 Jan 2026 06:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D596B00A1; Wed, 14 Jan 2026 06:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18DE6B00A3; Wed, 14 Jan 2026 06:34:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 937AF6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4126859001
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:00 +0000 (UTC)
X-FDA: 84330360240.23.780ADF9
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0D1A180007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmrG1zrR;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=uOpWcfGGgNyMlKDTLG5wyQoyxzKsCoK2UsI9vQyfb/r+uW+sQq7646MytPFvu3g8xs7co0
	1lLqQ6HcVYKQ7blWpDpos8w7Yv1kYgkn0UHDbFmX0w6akdWWGA1gdOOMk3slMw/rMFxSt7
	ElSMVAysVd9p3jqbitaNdaUlfoniNcU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmrG1zrR;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390438; a=rsa-sha256;
	cv=none;
	b=Oe6avez1ro4uLqxKyfdiMBt25GZDhSzdwn0Pxfgr103a9ZO37RkUYDvx7A7RZ/wMv+wzO5
	7jB7vsST5cPSQbJEGbR30V3hujn1M/Srwgf4Sx8eZysw2zNu+3ixd5IgHFyeKJg0UazjYQ
	u5PMb530GJASYdV9yq2X+dMRemh09/c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s82tZFT3iNsr3WMx/4d8Ml9gjp1Ep9qgTy0gWjRVe+I=;
	b=HmrG1zrRF9bILjq52W5M0fEv/Kh1W49u+KPtADu7tHudamR6wf/d+m8tGOauHvXjCtLxt0
	SAGGpGRko4EltwHQF42dxC+zQLNuRLzEivYmePLOfQl/bjCpK8oakNCbMzF1SdgNcXjczG
	ggkH48Uzs8Fts/TIPgaIlQNj1AaZhJo=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 12/30] mm: page_io: prevent memory cgroup release in page_io module
Date: Wed, 14 Jan 2026 19:32:39 +0800
Message-ID: <0242e03552f49b54cecef97d90ad1b61e7904703.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A0D1A180007
X-Stat-Signature: 18k4werz73mnxwos4kqwy5zty1d8mgae
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768390438-886721
X-HE-Meta: U2FsdGVkX1/VJumxSz4Y7KlREU8YRahRShw31z1ZLtZGYqVF8fFIiaMFwSd3wAqc429+CVRrG4TKUA2lQRyft3S69DTjGvvo6JQzrgrBm4LSsXWCBqqTVEFaA7W7xEUMlyYj/tChFohx1shItwU/8q8fhhzBu7uZSpkgOOTRTwPaOF/nuEpeWnw/1fHNA4bdLeJTHaPVVoVg/xzTVEYAz1GJhenqgXyvYpLy75ZTtOwD3S2W6Fud+rk+nVo4t/A/LhSGA+6+rPcIguBvfFXxKY93D06SmTDXh/mgBLndVS6LLOcdp3IkFi7y9MYuQxAwu9t7G79nm/qAMLSYBCleX/NuVWzlEP6lyMidcdIUOaYRDeNWzAq3izZYILsFpCfr39VQ5FFj/GKpwRWSb8l0ll6FSLp2FiUsVhtUC4boEQ8uGp49Y4uuch/OfgaoG85VWQvrri++4MR0qnWKx5N45FftKb0oewHNVaG2zWaqITaosutCI/IGcympW40+aaPjUQuM6UotRoTCaanaGUdAGKTfhbxEexpyChK08do4Ik30Z72/Go10K0gGXEfk2l0h0E78oQh8s+avuiR+UuTJ/WG1+DJ8CPTd/NK5KRJAyqMmOhSFXxtXsYXdDa11kjsH2dzf2Rhw6EkLOaU9pEjW1kKmwsGezs+101Bc8ff/yOjl8doAw0rAMHoywrKjVbDZckRn9W6gpQ1ngNoiQ3Y5LpRYszRsRlulAU9vK525WJVZ7KMB/aBi2wrKPo1VkfvoFiwRRyDav811FEo6VNSUbml0To0pi2/nOUekJLlsHKbfIkr4zanfxYbv1Sv4nahmFUivnRxEXXjEqrag8G3VhjYXbVWKEdqpTbQmGmtOmo1O4DO6OJbIugJExjkWbPhWKLWvIYBKTHxiuWz1rKtt/keto21MB5oQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in swap_writeout() and
bio_associate_blkg_from_page().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/page_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index a2c034660c805..63b262f4c5a9b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -276,10 +276,14 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
+
+	rcu_read_lock();
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
+		rcu_read_unlock();
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
+	rcu_read_unlock();
 
 	__swap_writepage(folio, swap_plug);
 	return 0;
@@ -307,11 +311,11 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
-	memcg = folio_memcg(folio);
-	if (!memcg)
+	if (!folio_memcg_charged(folio))
 		return;
 
 	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
-- 
2.20.1


