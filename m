Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD015F30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351B46B0098; Thu,  5 Mar 2026 06:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C316B0099; Thu,  5 Mar 2026 06:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2464B6B009B; Thu,  5 Mar 2026 06:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4E66B0098
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:54:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D21601B8282
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:54:47 +0000 (UTC)
X-FDA: 84511852614.11.25E1DD8
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 422FC1C0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:54:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tLqVajZa;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HAmieQx96uUJHkqmiULZYRo0O0Tag2Ie6J1oo57wFA=;
	b=Bsiu7pywRe/tYpEplG5M9eVQFfg0ofyrV9UsP0kQ95O21o55EJUurnybWq8K6uahRwsBT/
	r8vzThi/nClw5lCjiTwrvIjQUo/12pmdl1VyJ3KfBxVExkq8sAi2oKvD/ShS0auYbdWWQO
	lw7kl65lksV81oJjybCsT76SabFldI4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tLqVajZa;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711686; a=rsa-sha256;
	cv=none;
	b=ksnCM864n1SHmA+UiCRwlU0lG9ZYr/j3HHDxqN3zY/m43sB16qXqOWewKNN1xgw378iE5h
	e1er39xFjMB1fwLwRPREDKPx4wueVjab5gbwrSjSLHzegHvmf44BZ3u4j5bT0/nTFeHZsO
	6NE/P62PDEKxBNCChPKYE1htE4kG8HM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6HAmieQx96uUJHkqmiULZYRo0O0Tag2Ie6J1oo57wFA=;
	b=tLqVajZa0xN3lq32q2+2Y4z9uopzjIj0kne1M5U790g7TRavQL0V3m9ke0lTp/jRilYTmq
	QGM4MpTzczQ6P/FzEGVqDeKjKdRgV2qB0vEPjRi5TqlU5ip4lINogf03VoPWaITp1kM6/A
	xrgYdM62LA0CM3iFJjfGUhdkzQAxLUc=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v6 04/33] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
Date: Thu,  5 Mar 2026 19:52:22 +0800
Message-ID: <b3a202f1787b0857bb6cbe059fffb8edefaf67b7.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 422FC1C0011
X-Stat-Signature: 8uektimg8fasfafamt9iaab5gnhmnzai
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772711686-459854
X-HE-Meta: U2FsdGVkX1/RNDhd/T5zBnPt/UmSda+8zLtRfDEa8jrymGu1vYvRnxvwlDHoGJIzCYmhB8jjzm17bqLYGENH3SnFOFJz+0ZMRTXsDwD7aWzp2fZRF1KWxHiyKceXjr+AVZGSQSZAM+n52HMWFr0OR+ME/yXShisJ11hNgnRar4n+gzlmxJkTZOySlSTdd4wo/YHnj0gYOqtoAc7pnOCZ/QqbwNZj3v8abfLw6C2UpKU4CmkMRV0+8+QFGpNBo1h/CHyIclx4y9h00s6DzDuh7FL+v00EY/vWSFkcnlDNteCqM4+s7GmnEXJXj1jivDlA52DQy+wO1hDhoe5hbVcB6ECpSqgp1MAIUrmuwv4ow8acGd8dHcqgbE//aKHLDRSeInkKAZBxAn3WAyITQQJEwywJUuGkOzx+8PKXgFi3gED5dZ/QHmPDR9suMeGROgtGpyoN4sYJbpmRePEiYZu/vGe3gt8gZS0RMv+Cw4k751NmIninI4KVzcH1vu+XInGkOGNjC/lRn1rwY+wItMW7+KjSq1gKvTTkXb5tbpOlB1g5harZNh75zDLTqVM5d2Xrtqfmg4xnYD8zokMLnVwVVLjT2e2f57VlBGNTXCKQ1KMI1edn6GUGCsEApeXt8+A8rKDs8tbBJnzoL1P3CBDgU2zs+3UAx6fvVj618z/sdqGNtOCsjksNwiHCfPnEBK7MhWOsYVmZvhNuCVDkCoYiOYR5o5J7loVHMq7iy/2D5j8H3lebJgeLgpQEVLIh2C7mCOVi7oK3IXxSH1TWO012KbfZBkCXGL6C7dA+RDrET7yahRxKDB5nYjIOFB8BbB86oOVuQDs9I9/GM+itGwVOQEKY4HTlZwhoQrxjTWiJ52NRaVKOAu5i4zY1iDW9PrYPeB/hlbzbUwUe5snIWvrCkCiYdhrK/g4I
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
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 223d584421a9e..2a32dce8d8394 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2025,7 +2025,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
@@ -2171,10 +2171,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	nr_activate = move_folios_to_lru(lruvec, &l_active);
 	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
 
-	__count_vm_events(PGDEACTIVATE, nr_deactivate);
+	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-- 
2.20.1


