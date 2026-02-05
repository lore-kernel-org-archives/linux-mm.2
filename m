Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7239E91298
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370CC6B0098; Thu,  5 Feb 2026 03:57:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A2B6B0099; Thu,  5 Feb 2026 03:57:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2547E6B009B; Thu,  5 Feb 2026 03:57:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 145716B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:57:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B637AB94FC
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:57:00 +0000 (UTC)
X-FDA: 84409798200.14.EEE9394
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 00F3780005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rLlYUxEO;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl55ZD/XpxuV+TwMC87ANkfW8PG21jVvZfSxHlx1S54=;
	b=zq99lEGgsh0U+czQ/GgZ+whVxiPkWFkQ6axP11sap7BT+G1l+673uJNatlK8xQbDRfCafW
	LwIdG76xhgv1YoSsK41GSFQEF2vvK7OA4MLsKg+pUvxD9CXkHsTGlTOmPnpQkCLnnCG9aI
	sBxddy1SdqWxYX33jZlsDPQZu5q72zw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rLlYUxEO;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281819; a=rsa-sha256;
	cv=none;
	b=y3Kk8Ok1zZzak/GNHHEUaT10603UF91sKw69qL5fIxN/kba4BrcphvcLIVQXkWYO3IAlo2
	8sRqHRc9juzNZSe7bi0EKm70rpv0NWFAt/UEiVqsn7zGZrr5rFEYmdxnkVwNWfvjCBUcH7
	3NrSYlF8pS8X3uqCj5Hvu/+SylxRhT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl55ZD/XpxuV+TwMC87ANkfW8PG21jVvZfSxHlx1S54=;
	b=rLlYUxEOw0iWYZ4PNnhDDiZpDRQmGWtNZYhMjkOs7ukos96vL4wekfsabjh5SBEnAHtCWs
	k2VFJrJk9OHsKvnamwLWa5fq/jxdbJPNANyWbDRKoABAV1YaM1cS7NwVW1F0Rxi48pw8c+
	n0BGRtlAaOs3GY95R4tzkHiB5eCxNFo=
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
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v4 04/31] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
Date: Thu,  5 Feb 2026 16:54:33 +0800
Message-ID: <2a61a9f46870a987ec4426cbf88177d9e2ddd628.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5oyxebfoe8ccojgib6cftewtpgo6n5ui
X-Rspamd-Queue-Id: 00F3780005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770281818-629678
X-HE-Meta: U2FsdGVkX191dH9mpsR5N1AdJ/8UsCEFCdMI+kiiFhQ+loJSHF1RtCwvujA64FRm9s61MEAugIYImS09FxhUxlNrMszDQT8HUnl8Sm9HDz4JMYD88r4ZRb3eD0Ll/qe41dcGUwIxWxjz9aBNJ6pc50/bcTI3XzsiJHDA11XLWyWAfT3QLHJuu218tnhwwMl4Ga/FxUPfsdMqsMd00V3yZ+iw1SVuQMAhWhctZ1Xnwcvbh6spTHDum64T23vT/yNjtX7SUxpri5Oz2+EO1f1opxuW8GiTt99Ggm+l5jKYT+A4wYnA+t+/9Gg2nrhqFP9UIzPAezTNjGReeLK+XJqEJn6W4G6OhVubHOXBn0VFVK07v9H/fWoiI/10kl/AtM9TJdYdHZh3r1yOgJ68nVJ5O8i5ui9AZvVJ2ssCiOOa1tyrDK4LEGoQL155KF94qrbVCGVzeg7oQAYgas9sPe9qEpV3hHegJ85R3l6hH94JM00AVQnZOVy1OPCRE7+Wn1JVADaJYs4OAJO9KktVt9USUvxr+VQQbdtnp3196VLMGvK1M4xCc9nkDtnsNbq0WpJbc2a/9VTiXsp992/Vyame/L/+3pco7Y/CeXg/ZhQE8XJskBjjzvJdM8eSmHA+J7nJKvZTzS0w31cHcpBJsbnBckkHx+XwTEDcC6UT0oqYeDUHpwvSfLPKDORFyOx7cWfScD/fX6/99p4FR3wDSMlmZ4IExbCFZZ9CVXmT3/H0l+aNuQhuq3GUysDMsw8csULAdLJCnieb2mKJNmC09TtTCGuuWqHJAT8FhLjhFHALcI+nQKZJT83DJ1SaBtwXkV8ODHDYeXmdVFdvqY2DALpAFcRCDgfNkvAqjtTVkph610MeTMyKJOBfxnH0WykDNOV8EQBVVKDFH1I1oRzxp8YrIMA03/IDJekaQWUCTDL9N3i85vopn+vFj5FF7pEGRYm50DLUdLY9he+7qSBAah1
 tPdJJg5t
 2+hHV6oN0RB8Dx82BtfpPea3S0ouddE385W/EuD3HeiEXbL/md64NaWi2Wdp1zadcdlZpb0sqIdow3uxLZcLkbQ1WlKVBa7gPuURh7t0fFEm3BF9dNOrJ/Wxt8nZ2W3QJSESW4Qfy1w2ZGF1ccmz0s/sF74fOKVC9RHNCo2ZLYrI7HyQ95fJQ7+J+z1adDMm3h765hAWirdq88s8QdVUxBzv5rNMdZcqJg/EG+Dgm01sQ5X8U6p9/+wn4xyCWTk84aaIlSL7/r5AC6ncsaSTPF1TyqGQ9tHBe6fCF6iz1q+cfT1sAGkiG1Wcq6Iir1zK+awRBlW+Q8576yAuiCeDVcACk2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Once we refactor move_folios_to_lru(), its callers will no longer have to
hold the lruvec lock; For shrink_inactive_list(), shrink_active_list() and
evict_folios(), IRQ disabling is only needed for __count_vm_events() and
__mod_node_page_state().

To avoid using local_irq_disable() on the PREEMPT_RT kernel, let's make
all callers of move_folios_to_lru() use IRQ-safed count_vm_events() and
mod_node_page_state().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a4892f5e3d347..f595e063faeec 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2028,12 +2028,12 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
+		count_vm_events(item, nr_reclaimed);
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
@@ -2178,10 +2178,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
-	__count_vm_events(PGDEACTIVATE, nr_deactivate);
+	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
@@ -4757,9 +4757,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, reclaimed);
+		count_vm_events(item, reclaimed);
 	count_memcg_events(memcg, item, reclaimed);
-	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
+	count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
-- 
2.20.1


