Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9852C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC966B00A0; Fri, 21 Aug 2026 04:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3FE6B00A1; Fri, 21 Aug 2026 04:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1206B00A2; Fri, 21 Aug 2026 04:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6566B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:18:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E9D51603C6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:14 +0000 (UTC)
X-FDA: 85124574108.28.6F35EDF
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf17.hostedemail.com (Postfix) with ESMTP id E049E40005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GG/0Pz/M";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQvED2IN4nQELp3RINoejWOoPEgpgiL/qUG/GEa8vQc=;
	b=y5Em8v5xo2EipsHzdNjt0bl90nLpih9swbDDP3ElbdiQTcAKlvlzR5Lr4zXVqFKJSYZWA0
	ycNXfM2PrYmvIRW86hgn0+ogUC4KQH/BnaDBrxzkDOkDwafuevvbU8jlhiB5wSE0L4POXx
	nM2DByA0r0tLP8sMfnyM/Alz47V0tII=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GG/0Pz/M";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300292;
	b=VYqO/ikCZ/I93eT2Ccr+0So9dIdaljTQ421cYBp4Jc11Xcij2GSinVK/JMwaZDAKOEXjsN
	6JIVzM/Z7LmoievhoTb9sW36NwtHKDP4fJJm7zLWP23KPSor68PJf0eN/6HqV8pEwJievC
	qCERuYJ5VlhjbvQUVHWlV8Q2P8Z5o3U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oOaNAC0BAF0dHeX/TLdwJ+nW9WDxq122HtWUDNIDsqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787300290; v=1; x=1787905090;
 b=GG/0Pz/MVJq+imhtxEWCZU9fZtdKr8trWjaVkMoLg/Pcx0/u7Mi8cvoO06TZVZtQWZnFibj7
 cEgWGIk2yGsBLpulQIgzKJRSn7/hp2xEzvxYS9e5VNrRHiIb6tDg1wBn2xZGYtSRR1epLXXv/cp
 HiO8KQHFooUpWZav7yqgGvZY=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 9bdf8f2d2f2975d5;
	Fri, 21 Aug 2026 08:18:10 +0000
X-Mizu-Trace-ID: 9bdf8f2d2f2975d5
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 1/4] mm/vmscan: only reclaim slab in node reclaim when over min_slab_pages
Date: Fri, 21 Aug 2026 16:17:38 +0800
Message-Id: <20260821081741.1340277-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821081741.1340277-1-ridong.chen@linux.dev>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8yyuha33jdw1cefi5txu613oydjrw4cm
X-Rspamd-Queue-Id: E049E40005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787300291-421940
X-HE-Meta: U2FsdGVkX19lzWpKP8If1o5jbFi+9srtLxtIRdOrjt4I1DxLpdPL2I5EWTddzgOEtFEcZx/56tZYT8RY550GvsztEVW2srX9NlO9EfVGf4gF9hcJoeMFHGraOE7+er2/8J9D3AVNs0fr6qU/OK4agRnrfWYKzH1uXx/JLug3s3D2gLlOjHl9zsETdF0AiV6AqwV4c4VpbNirzme/ZVExR/Vb5p1KILKMSB4EK+iGKRWbsfYnsx/DTHXCtWV3gJFishqxFMaBZrqEKctBeyS3lr8Slc+sxcyeNMDYghyLg2S34gFPZnOovA/E4ejic0+0VSehtr7w3nPIXIxgQ6tAi1V8XyIlT6AETJpRY36uQo/2QpmZeFRnMO3Rcp7ZG4BPJpD0oUh8NFqXVBIKjNiUfFdSp51H4k7c8vueIkkzfQw3VyxgVaY3+CKZXFtXtpLm8UyVyG83JN+FmfGOkVQFSDwglXSawtI0A736POpCF+aKmLZi3Vpz/7zcCLGatoIARp+6K4KPedNPxiiaDOclwqO+NM9gGnkOYVX8imS3ReIHfXx1+2WBGpHIObXHNXgSOe30G5OUOzldzNasOqyslX/uGaUEAxHcAoDHWDVLmsIqyzh95quWAvcFRFB0X/P/lGd4ujpSDD5rhT1vHgkxZvc51n5LD51HIMygz1L51eOstDLALoGfryEXtLQjOcV6ZDmJUiaE8SLPNX2jBi8lrSLNQUqzRH0EHcZifGnh3b5X8Ouammb58eMCOz5zoh2/Xy7NatO6NqzBoY0puBTEIyLjAOE6xJWOwZyE+P/z3OjsSlTJM/3eHAmVaaV53nLiU6vUJU0cZR5GSIS2TyBuFHmssmPxK9fYmHC/FSX3xIfQz/LB6oDvZ7ivQwcKalcpRi6FK4mu8l87W9MYQsg+CPjgdgKM+DVq0bWZ7foBPijFH3Gd50yZ2ooVhZug5vseR+z/DpYt1yvrlNVI556
 9ThMFK4+
 Jy3QeteAkE4GURHcdRvr72Jt0zxlVQgPZ+VNuknTFjCAoT6a6DV/E5m3s4/T4SSg2HiZUoJCclR80+YfGSZ/mlvgCyfEz0lCO1AIzy2CqY1a6sZ+A7P5AqEXTDlQSncIQLjQcZQ0pMi0prYbjKNYRy1aNV7rUUmewh8oyLM+TvjB4FwZfuKuverizt79uKDeCzo7Ql46uT8t/wEnGB/EbNlyqHmKwQVYYek11efJtYGQYRuMfRBHn/7On1wyazymTUgjxMKCpmrwhmx1K+doB4cGQWbICysN7MiWbrDqrcVbjsrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Since commit d8ff6fde8e88 ("mm/vmscan: take min_slab_pages into account
when try to call shrink_node"), node reclaim enters shrink_node() when
reclaimable slab is over min_slab_pages OR unmapped page cache is over
min_unmapped_pages.

But the threshold only decides whether to enter shrink_node(), not what
it reclaims.  min_slab_pages is documented to gate slab reclaim alone:
"On Zone reclaim slabs will be reclaimed if more than this percentage of
pages in a zone are reclaimable slab pages".  Yet once unmapped page
cache alone trips the gate, shrink_node() still invokes the slab
shrinkers and can drive reclaimable slab below min_slab_pages.

Carry the decision into the reclaim path via a scan_control flag and
skip the slab shrinkers when reclaimable slab is already at or below
min_slab_pages, so the limit gates slab reclaim as documented.  The flag
defaults to zero, so kswapd, direct reclaim, memcg reclaim, proactive
reclaim and drop_caches are unaffected; only the node reclaim path sets
it.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c17ac77b08a4..7e65d0ba4a96 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -114,6 +114,12 @@ struct scan_control {
 	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
 
+	/*
+	 * When set, the slab shrinkers are not invoked because reclaimable
+	 * slab is already at or below min_slab_pages.
+	 */
+	unsigned int skip_slab_reclaim:1;
+
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
 	unsigned int no_cache_trim_mode:1;
 
@@ -5120,7 +5126,8 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
+	if (!sc->skip_slab_reclaim)
+		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, sc->order, memcg, false,
@@ -6237,8 +6244,9 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		shrink_lruvec(lruvec, sc);
 
-		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
-			    sc->priority);
+		if (!sc->skip_slab_reclaim)
+			shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
+				    sc->priority);
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
@@ -7940,6 +7948,15 @@ unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned i
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return 0;
 
+	/*
+	 * min_slab_pages only gates slab reclaim: when reclaimable slab is
+	 * already at or below the limit, leave the shrinkers alone even if we
+	 * entered node reclaim to trim unmapped page cache.
+	 */
+	sc.skip_slab_reclaim =
+		node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
+		pgdat->min_slab_pages;
+
 	ret = __node_reclaim(pgdat, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-- 
2.34.1


