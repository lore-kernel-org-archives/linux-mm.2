Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC9CC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 477816B00E4; Wed,  2 Sep 2026 22:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E4E6B00E5; Wed,  2 Sep 2026 22:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DB16B00E6; Wed,  2 Sep 2026 22:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1D536B00E4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:46:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CED91C2013
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:46:46 +0000 (UTC)
X-FDA: 85170913212.08.DABAEC6
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8DA531C0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:46:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iLfSpKKf;
	spf=pass (imf18.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788403604;
	b=cd/Byx4DdaxrRk1eqoOWY9B38CaRME7ciUWnoFGuFNWVCfjRMQET8qlqNHnduj+c1IY7DF
	H9smPDxuFk6hwXExoWc6F1ToscuazNVevkuQqLC+WU9fVwfPwt6I6VFsUP0SkB3Jr3QDYY
	Ci8Mk5Q7BRrpRKhFNscQk2i3QKbR1ec=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iLfSpKKf;
	spf=pass (imf18.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788403604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrinlxSyjlgA1CHOv7AAT+CQFAvBKLOzmbqNTrYOST8=;
	b=L4DdRJcttD7K2F3xLQWEIKg7GhxmGm/pluGrSbGnlqXdGql2RKAUUz1BCoJ2e8vWmHBLjW
	TGho+mnoVzW5cVOHYzD2Di3F0j/yx9dbtDEtTEXthTsDGN27ap+GvTCfLPJc1xWkDQS5Rk
	6wBMJ+OYzdnz+ugP6/OTFL69Aydlt8o=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-384422b05b5so218265a91.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788403603; x=1789008403; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XrinlxSyjlgA1CHOv7AAT+CQFAvBKLOzmbqNTrYOST8=;
        b=iLfSpKKfThjh9Jhmn2MYbQXXRwRBDzeog5zUcvl6ACLmPCCZtzmklQw/YzuBkGaekj
         qIpc/Ve/4GVbkGfKDRBO/QBXUnERFKlMA5dSK+TKsDKVoDQckBG4cgciHmrhF2V8obe4
         2XxXikhbPR1L0vf8IsloJ29Io50xPn8ogo4JY9JprxFn66rgeHhSpDjG7POKrEdS47uQ
         Rb+DkzhbQjNzM8iQgZ61JZWo4LatHBItQgGeU6e1IlKAp+SMNiLzTfMjoO5Daz0NjEoS
         QiksJcaD+cBWLUBu0WzssaBxaV2PMp61u/Q5CPLYK5TX74azNkMCMZLcH6fByZ48iPk9
         9lcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788403603; x=1789008403;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XrinlxSyjlgA1CHOv7AAT+CQFAvBKLOzmbqNTrYOST8=;
        b=sIzriv9ToKARNIENQVA7w6ohk2R6M7ev8HB3yBONMkVVGWQF1gjl/QHw8w7ihsy3U3
         N6IyStvkQ0M5Ikpto8jdXEph5KqrGOirmPtsdTaLt4QV1Ih4EX+HZtZgsifSooogiFyC
         tV9iXp+6cNySc6idDVcEqLK3bFtFPoALY0a+FIFrSky1P4A3ZZHaB7+9ykmdnc/R1Wz1
         cjy7rVRexft2DtvojBD01L4PYQBcFCYJNFJZ/7QsufZp2NJzxmaLfvPckMxUZvb8At7+
         5zbjh7MTX/BLgCUlKSXJQj5RQEcqLvuZu5AIbH39Q16Uj/bFr9iJP6otU8vIncBThqLp
         JNwQ==
X-Forwarded-Encrypted: i=1; AKwUvByFS4CgjqE2TELB0rWUYBRTtyoqP8sUW6NhpS9aIZCnqbnt5TH1Z2AJi7fAYqElN32SyQCW0YYA4Q==@kvack.org
X-Gm-Message-State: AFuF++nJATVSt7d5o03qiG1gyd679U3S//kXR+bxHmms1EHCqHHNowsO
	CFRdE5wvr9bRnPyZHPcdwwypTjZwCnm9MVMDs26L8u1Q64XRUDOvZ2di
X-Gm-Gg: AYBFou3LqdnxcUalN+pRejwAfqx5LsudtnF5LvUZ8A30SEhzy7OYYif+fDhUwOSwve7
	UPJ9nQUh6SK3JRpu00AWXYGv6k8T/e4veBkswIxmOOaYI5GyU97S7tnVLWW7s8e9iscmIvr/Q/e
	JWzCFM67BMJ+sWkqYvxCednVReGX5i6eSNivAZBeTkDmWlDIrrFOORFEvQTf9gneTHSnzaPkq3U
	g0nx9b3sa07RrA/qsjnPIgdLrEcErajTeTlDGXZh3hPhiRVmKdy8ru3VOG434KMH5usF2XZm66R
	jkE4Y/Dha7A98JKuBZwULGNhLxjqDd9ZOl3iFsAC6KkyFGIKih+SNoWsJWCMtH9JDcby5oKSnds
	3MjZnP06Sd/EJLAL7PEfk1NyhjgnLvyic41P3w5A9HMT7icol7dmIGsJ28/SKaiBMf7n/LvFkcJ
	5XzIVYvUrZyXHwIpLpNUpy46rkjiMgZj8d9B52TrHCIu7Fm+DbSIxiwV8Xb8kdhieIkq5gzQrf3
	Cv26S4HEXBtggT2fXdyNQ01kHlwl2lsYnBvqiDS2LDdSmu3u6VfqkIORoyHMK6RCIlaWJFtMB3/
	1p5BsQ==
X-Received: by 2002:a17:90b:4cc4:b0:398:bada:838b with SMTP id 98e67ed59e1d1-39aee277bc5mr8953822a91.6.1788403603107;
        Wed, 02 Sep 2026 19:46:43 -0700 (PDT)
Received: from hz-11197422 ([132.147.97.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083e4fafsm2177685a91.1.2026.09.02.19.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 19:46:42 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: zhangbo0325@gmail.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH 4/4] mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware
Date: Thu,  3 Sep 2026 10:46:03 +0800
Message-ID: <20260903024629.574484-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825043833.2659350-5-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-5-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8DA531C0004
X-Stat-Signature: 1mh111hxoi9dmsr5bdy59cwsjwzbx3qu
X-Rspam-User: 
X-HE-Tag: 1788403604-847129
X-HE-Meta: U2FsdGVkX1+RBqwptAAA1jpvV5cV3q/+6hU0wgYHWsmqRBU0PjY5mYgROX62+0S2zHz2E4zU5UrnQYcsxBZNKG6cbKzoH8qusRft7+oXs2Mo3xXC966JYlyUF06T7c+4mjxkuMtpvRlK6+cOr1MJYuH8iv9MRAKXSH51N1zu5FmdAIhnAj4/np1SnPsxsIGxvN4BMf9H3hEcm1HOlwSZA+dvo9uHHEI/JKTh07EEcH3EngCN2fjVFHlE93fI0Vg7rZ+W7ldqKuyUNPJtQ1FRuOr9LFKNyjySOoQn+X7FXEw4zr1sgqBwK61n5dvlV5QmpGNnj5r1ec1hwUpeyzlBOMbD+T4S1r3yI11pkt5sg8K9/PKRet9K0jfBJ5Z4DUUiOa0b1q/pQjIDhiOJv6omcr06oNuMuEvNoiMKs3jAlkCdv4Ekoy1KRLj9wNgdqzOlHueHFN801erGcBCbFeoT580VZ9r3hlzO8LJfCIkKTwvJR9AMMJy+jsdjOdY+ZART6D1NlXeFCZMoVXlf0Ki96UD88lvhjH9TJDIGXbiw0/j/nCzMQGBpod43DaOm9u0nsazrbHqlk9ZX/NABwRAjYszsVU1JAFgJ8fgYuW6rIxFkdDhSUFRZ1ANn34ta6/TsbVen5VLjYJZU+Qp8Wo9l1rnTzDSGi1B/wv8rP0lrcH7W0EOSQdrAsC9V+rZlUFPaK32BwS8qvlLFbaHcPwHm3rFpCpToZWcmaCx/XyIAiECTiSz/1hAB5cBxWBaWvjpiwfrEYlUyRKdCR3Rn4QR+r+yEFUe2BI+W6pPLd2MscaIVgW71BS3kInT2M9s3veSGxpv71iQE5CAhWV8kobH6nH8VJZeUc0UkBQKZSo0s4I3d+PlSWh+UGXxHKbdVVxbHkWtLgdGVSa3AqsDABK2dDBdc3fndt6GEhkYNHyVPT+TUhL3S2h7qsDOiNAyIEP/Mk/04iS3tti33sQMzyzJ
 9hglwqHT
 lxqaJMtkDctYxStHZvLrt+qF5QYTzvgBpqVpovLCPvYzbsqBs5Eqv235/H33CpaGwxOLjsFG6d/sMLeNFZjkcUxIngMPeGFTwo65a4CAiIwvN5ZhMPyjCfq5MTBjyjhqbSUFg3E5JD8LkY/HvYprJWyyFyh1QJTNHbuO2fGAHf+M9Vtbo4926o11HHc1uErO/T6y1nRBVjAF9YEA73WV/5uPPIODrSQVrHxc/ifIssH0QAbLuX5iRHBi2Shhltx37mT5Wi/C5K6J9I5VJeKgmf4mOL72qWTUemRxNArddXTT4gGJVKTPHMMyn2ECehKEO7aICVTPUGe9qcXSBR+PgyWtTiqU65SlX8+6YcwkoU3Yrn1MmgOGu0o7lqJ/w6ewDAGyg+kHMLdJ8nemF1QNuF83zQ19aekQA0PZEqdDmIvNeXNsBqv1MKe205Gt/7M0RsbLbytPPUbz8rlEbLw981UlJ8ymCFcgZi2+EVPCtE4nfq7S6TZVeqYyIaYmCREUjvTyt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 25, 2026 at 12:38:33PM +0800, Bo Zhang wrote:
>To improve the mTHP allocation success rate and reduce
>fragmentation over time, introduce
>zone_effective_free_pages() for mTHP-aware free page accounting.
>
>Refactor the free page counting logic used by pgdat_balanced() and
>compaction_suit_allocation_order() into a shared helper function
>zone_effective_free_pages().
>
>The function selects the appropriate free page metric based on context:
>- defrag_mode: use NR_FREE_PAGES_BLOCKS (whole pageblock accounting)
>- mTHP always-enabled: count only free pages in buddy blocks >= the
>  minimum always-enabled mTHP order, since smaller fragments cannot
>  satisfy mTHP allocations
>- otherwise: use NR_FREE_PAGES
>
>Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
>---
> mm/compaction.c | 38 ++++++++++++++++++++++++++++++++++----
> mm/internal.h   |  3 +++
> mm/vmscan.c     | 23 +++++------------------
> 3 files changed, 42 insertions(+), 22 deletions(-)
>
>diff --git a/mm/compaction.c b/mm/compaction.c
>index 15b92475562a..29be72597415 100644
>--- a/mm/compaction.c
>+++ b/mm/compaction.c
>@@ -2528,6 +2528,38 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
> 	return false;
> }
> 
>+/**
>+ * zone_effective_free_pages - get free pages relevant to allocation order
>+ * @zone:       target zone
>+ * @order:      allocation order
>+ * @use_blocks: if true, use NR_FREE_PAGES_BLOCKS
>+ *
>+ * In defrag_mode, watermarks must be met in whole blocks to avoid
>+ * polluting allocator fallbacks. kswapd usually cannot accomplish
>+ * this on its own and needs kcompactd support.
>+ *
>+ * When mTHP always-enabled orders are configured, count only free pages
>+ * in blocks >= min mTHP order, as smaller fragments cannot satisfy mTHP
>+ * allocations.
>+ */
>+unsigned long zone_effective_free_pages(struct zone *zone,
>+					unsigned int order,
>+					bool use_blocks)
>+{
>+	if (use_blocks)
>+		return zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
>+
>+	if (READ_ONCE(huge_anon_orders_always) && order == compact_hpage_order()) {
>+		unsigned long free_pages = 0;
>+
>+		for (int o = order; o < NR_PAGE_ORDERS; o++)
>+			free_pages += zone->free_area[o].nr_free << o;
>+		return free_pages;
>+	}
>+
>+	return zone_page_state(zone, NR_FREE_PAGES);
>+}
>+
> /*
>  * Should we do compaction for target allocation order.
>  * Return COMPACT_SUCCESS if allocation for target order can be already
>@@ -2543,10 +2575,8 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
> 	unsigned long free_pages;
> 	unsigned long watermark;
> 
>-	if (kcompactd && defrag_mode)
>-		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
>-	else
>-		free_pages = zone_page_state(zone, NR_FREE_PAGES);
>+	free_pages = zone_effective_free_pages(zone, order,
>+					       kcompactd && defrag_mode);
> 
> 	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
> 	if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
>diff --git a/mm/internal.h b/mm/internal.h
>index 38b1165212c9..14bb9543879b 100644
>--- a/mm/internal.h
>+++ b/mm/internal.h
>@@ -1654,4 +1654,7 @@ static inline bool can_spin_trylock(void)
> 	return true;
> }
> 
>+unsigned long zone_effective_free_pages(struct zone *zone,
>+					unsigned int order,
>+					bool use_blocks);
> #endif	/* __MM_INTERNAL_H */
>diff --git a/mm/vmscan.c b/mm/vmscan.c
>index c1404a59523d..a419a2c2fca4 100644
>--- a/mm/vmscan.c
>+++ b/mm/vmscan.c
>@@ -6966,7 +6966,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
> 	 * meet watermarks.
> 	 */
> 	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
>-		enum zone_stat_item item;
> 		unsigned long free_pages;
> 
> 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
>@@ -6974,21 +6973,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
> 		else
> 			mark = high_wmark_pages(zone);
> 
>-		/*
>-		 * In defrag_mode, watermarks must be met in whole
>-		 * blocks to avoid polluting allocator fallbacks.
>-		 *
>-		 * However, kswapd usually cannot accomplish this on
>-		 * its own and needs kcompactd support. Once it's
>-		 * reclaimed a compaction gap, and kswapd_shrink_node
>-		 * has dropped order, simply ensure there are enough
>-		 * base pages for compaction, wake kcompactd & sleep.
>-		 */
>-		if (defrag_mode && order)
>-			item = NR_FREE_PAGES_BLOCKS;
>-		else
>-			item = NR_FREE_PAGES;
>-
> 		/*
> 		 * When there is a high number of CPUs in the system,
> 		 * the cumulative error from the vmstat per-cpu cache
>@@ -7001,9 +6985,12 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
> 		 * counter won't actually be per-cpu cached. But keep
> 		 * things simple for now; revisit when somebody cares.
> 		 */
>-		free_pages = zone_page_state(zone, item);
>+		free_pages = zone_effective_free_pages(zone, order,
>+						       defrag_mode & order);

Hi Bo,

  zone_effective_free_pages(zone, order, defrag_mode & order);

"&" should be "&&". defrag_mode is 0 or 1, so this is just order & 1:
works for order-3 by accident, always 0 for order-2.

Same for the zone_page_state_snapshot() call below.

Thanks,
Xueyuan

> 		if (zone->percpu_drift_mark && free_pages < zone->percpu_drift_mark)
>-			free_pages = zone_page_state_snapshot(zone, item);
>+			free_pages = zone_page_state_snapshot(zone,
>+					defrag_mode & order ?
>+					NR_FREE_PAGES_BLOCKS : NR_FREE_PAGES);
> 
> 		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
> 					0, free_pages))
>-- 
>2.34.1
>
>


