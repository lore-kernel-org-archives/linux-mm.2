Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43635C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414686B00A2; Fri, 21 Aug 2026 04:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5E26B00A3; Fri, 21 Aug 2026 04:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3023B6B00A4; Fri, 21 Aug 2026 04:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06A736B00A2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:18:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C483803B7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:22 +0000 (UTC)
X-FDA: 85124574444.09.BA54E78
Received: from mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8C3461A0003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hc19s1hj;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnq9ebT3ekd/XAv678uHucjF2b7+NueYAkBPLKIIftE=;
	b=F4I7O4ejc4xqiA7ldvecrczgLQi8ZwppbhpgSbjWzyBVQ2xBJbdExg2iOWT3JQsd9lihTg
	J/glsE+YJ+Vx065JuAtaEg6iVjHzyEURlU2AeNjftaudddbyPwzFBvEADXWXrPkl1BaXzb
	D1BJW0UVI/y9/sJLP0f26zxhSCUQjFk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hc19s1hj;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300300;
	b=EFrcyaR7hf/SaTrQGmXzoJy12yL2NulSHztZz1HvX8miaDgu0i+DVtR1L21YMQlZfHRRbB
	6B/OB993/mLEkE3LUqmMFaLYaV5dUWWGZjHKwchH1+ZHDy3vFQmqqFfC3WRgbPUuVK0oX8
	1Dw/5/XGGDHYvqTtedg287ce1AaDAuk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oF3Xg/TnqDvbGLvbtogk/iCkdQNbS9f5eo1eLB3uyV4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787300299; v=1; x=1787905099;
 b=Hc19s1hj2o0kH6uSVxt2ukZlpqKaUBHjDmSi47JlJWqnWF1ZeIPeCVCeBI6VfnkDke1cY2Tt
 En4G7PLvA1E+alHNeE6Gi9uxZw/hkcpfpU0EQkc/C0vo6U2SEJLCuNFUCV51iHi1NUfxDc492aX
 S3Vdskb6J8BnYpNOqTj2oEFQ=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 9af9ce5e2af12ca6;
	Fri, 21 Aug 2026 08:18:19 +0000
X-Mizu-Trace-ID: 9af9ce5e2af12ca6
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
Subject: [RFC PATCH 2/4] mm/vmscan: only reclaim file pages in node reclaim when over min_unmapped_pages
Date: Fri, 21 Aug 2026 16:17:39 +0800
Message-Id: <20260821081741.1340277-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821081741.1340277-1-ridong.chen@linux.dev>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C3461A0003
X-Stat-Signature: xcj9ey9kg31gbztb4t95fes6bm6c8ine
X-Rspam-User: 
X-HE-Tag: 1787300300-296481
X-HE-Meta: U2FsdGVkX1+PHV48mfLSA5SLZTreHIzJFDdokTms+5V3J5T1doJtLq+nffbzCNTmNsLJfMM2sWmrVyzMWUNWic8ZJ850s/UpHYS1qnbmQCkQJJ5mXoNqozXeMum3s98HpHvw52KtB6XgVdU5ZK+JsGhdfYcM7dopaTy9rA/pyDpqc2kMFWTE/nM+XYL0cy0PIFiYrU9dHJr3AK3TYoHdhz+HlX2JyemYcstvS2Z5Ijaes4Zdu1r3jM8qdTlbnVpKfcyCbDoPWsWYR0lEcwVNLfQ52+CoWz34eXouTwNJagvZT9uVPKh7ioZzhiqLbx3Aes6g0FDjfuniMDQ5moeIyGoUt6GTC63ooU6WrrXuvCU2PDXR03q7DFLSmb/kz0LSL2d3Xn5P5SxE0mHdawOzgjoojhJRdb45awwP4KsWeCCPcLVTADp3937+2uLBL5foXncGJvLK6MKPLYPcXURPi23s3ffUxMw7DMaNY4qICscehxUWzkWKGHlrK0ChM4so1cxHfugBkGIZXT5buq1OobcRGNFAmsK5R22Ji1Tut9JQUP6ljkKJb2BEy6x25R624Muc0t3LzFn/sC8AdjUzk7Nmcfsplr9A8vNbcf/0IuZ9YMu/6Ef68did5/dfzJsqUxZXUzUc5DJOhOhsxU41/kVyWVI7Dl3PYILDCZK76DQ67Uow3RsurvCuAVTRcxjHMi4HTEL8c7gLJHhwhbzL7bJZtgww1V8kCbP3Y7tCojeVB1vF4wmo7hJssXojzqbV/ONtBaIlRpYzAMhxM4ciZGNRryIdhMomTEhrIVky9I8aLoiDAVQdMqCvXtlLsFHZ5xKdyuzTMM5IlPhSpzMfaia5xTFEGM/BCIDyz5xe3NGHJiChwLC9cflXtCQ7XrVvM5BGufESkHOsXRtkt6zwtYREVfE4lzuze0Kc6CQCsawvmK/jFLHy6UaJxDrqzWBrAqeBWMeNfoFkxV/hLKy
 dKUw5Fwp
 H0Trc78sCKg2Q5I/4OgMQKu7ZjjT5yTNcRsA6CdBjLaXKYRFvLsryEVZTqx2lWILLms7ieZe51Ix350FgAt8H6kZHsRNyos4kd6BAJsTBlSoZzChCWjMikFcUsQAzu0eik04RDBbIRxDIvKjpCcZaKomEuNxbDNWSG0dZVjcsyc0zM+Qm5WUjmNKWehxCLGUE8rOK2KiV4sRWS1l7ZYyGme4bq8GdFP23xTweS1y4C985sg7/J7dTLI22h8MiTwoOI0Cm9vjb3YvbiCxxg6lFEXgFOkRWHadSQsFKldWm4B6MYmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Node reclaim enters shrink_node() when unmapped page cache is over
min_unmapped_pages OR reclaimable slab is over min_slab_pages, but the
threshold only decides whether to enter shrink_node(), not what it
reclaims.

min_unmapped_pages is documented to keep a small amount of unmapped page
cache around so that file I/O is not immediately thrown out: "Zone
reclaim will only occur if more than this percentage of pages are in a
state that zone_reclaim_mode allows to be reclaimed."  Yet once slab
alone trips the gate, shrink_node() still reclaims file pages and can
drive unmapped page cache below min_unmapped_pages, defeating the
protection.

Carry the decision into the reclaim path via a scan_control flag set
only on the node reclaim path, and honour it on both reclaim
implementations:

 - traditional LRU: get_scan_count() forces SCAN_ANON, or scans nothing
   when anon cannot be reclaimed (e.g. no swap), rather than falling
   back to SCAN_FILE and breaching the floor;

 - MGLRU: scan_folios() leaves the file type alone, and isolate_folios()
   falls back to anon.

The flag defaults to zero, so kswapd, direct reclaim, memcg reclaim,
proactive reclaim and drop_caches are unaffected; only the node reclaim
path sets it.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7e65d0ba4a96..1e56973ceb73 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -120,6 +120,12 @@ struct scan_control {
 	 */
 	unsigned int skip_slab_reclaim:1;
 
+	/*
+	 * When set, file pages are not reclaimed because unmapped page cache
+	 * is already at or below min_unmapped_pages.
+	 */
+	unsigned int skip_file_reclaim:1;
+
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
 	unsigned int no_cache_trim_mode:1;
 
@@ -2581,6 +2587,21 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		goto out;
 	}
 
+	/*
+	 * node_reclaim protects unmapped page cache down to
+	 * min_unmapped_pages: skip file pages and reclaim anon only.  As with
+	 * the anon-only case above, if anon cannot be reclaimed there is
+	 * nothing to do without breaching the floor, so scan nothing.
+	 */
+	if (sc->skip_file_reclaim) {
+		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
+			return;
+		}
+		scan_balance = SCAN_ANON;
+		goto out;
+	}
+
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
@@ -4749,6 +4770,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
+	/*
+	 * node_reclaim protects unmapped page cache down to min_unmapped_pages,
+	 * so leave the file type alone; isolate_folios() then falls back to
+	 * anon.
+	 */
+	if (sc->skip_file_reclaim && type == LRU_GEN_FILE)
+		return 0;
+
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
 		return 0;
 
@@ -7949,13 +7978,16 @@ unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned i
 		return 0;
 
 	/*
-	 * min_slab_pages only gates slab reclaim: when reclaimable slab is
-	 * already at or below the limit, leave the shrinkers alone even if we
-	 * entered node reclaim to trim unmapped page cache.
+	 * Each limit only gates its own type of reclaim.  When reclaimable
+	 * slab or unmapped page cache is already at or below its limit, leave
+	 * that type alone even if the other type tripped the gate and brought
+	 * us into node reclaim.
 	 */
 	sc.skip_slab_reclaim =
 		node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
 		pgdat->min_slab_pages;
+	sc.skip_file_reclaim =
+		node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages;
 
 	ret = __node_reclaim(pgdat, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
-- 
2.34.1


