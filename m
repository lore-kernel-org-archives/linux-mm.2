Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB78606A336
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l0Du36VY
Received: by kanga.kvack.org (Postfix)
	id 2DE0D6B05B5; Fri,  6 Nov 2026 12:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28ECF6B05B6; Fri,  6 Nov 2026 12:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6A66B05B7; Fri,  6 Nov 2026 12:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E066B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:26:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F6A8140189
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:26:24 +0000 (UTC)
X-FDA: 85405373088.19.FBB2EE1
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id C301E20003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:26:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l0Du36VY;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793985982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xtFTk05uiNaRRdHOMAXi3GiW3HAfYxRIOaZ0COEoKVE=;
	b=nkcqSHReoWhjpgTr363uQod36GTHlOpCA9ihdc+Hitgx0lZtQWNJGtqvJOjQOPbnmgyvGR
	NI+kUVqcFuTj93iyGFarKNFysoiTxDqg0r5n98j6USqbBcA11rAmjblBs4kk5kyKphsaGE
	gbejXj4ov+sUmNhSRlcWlrOJ+u7il+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793985982;
	b=6eogDHex0+ip4VNTVjR9YKQQdzlScr//gsB7dTzFzncj3eCpc7o/JfsNralQI6PlJeQB6r
	l2QzyLWwgbhvJ1jlcQ8rk109cOVGQsEw/RsmkYM0JSmPDnZeAJ0qWqQ3oDDQawyJSpr4fd
	ESONojbJLinyFG1sWu6Z3wROnQLOMfs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l0Du36VY;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b309147589so8318267b3.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793985982; x=1794590782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xtFTk05uiNaRRdHOMAXi3GiW3HAfYxRIOaZ0COEoKVE=;
        b=l0Du36VYTpRy44QqO6c84bioDz96KO5pGIA1AzfKbxDeEf1ngFUStuKNkTRHG1L16X
         Er+bpYKUPPlCQeBzj+ymBpHxUSGc6mpq+R4UsNRiDPW6mw4E+MX0fRyjlhSYrlAWTN5h
         TrXBKNk8juaAT9KZX1f9WGkCRKJskYZx/TfbvmaMXicWAdqaZiddpHMVGZN0alWOLINO
         grLb+yq2q0Jpyb/iwYxXW9v4OWj0Bu32jMqJQXlJrRGklTQ+l5cs2Vsdcixbq0ItET6k
         NL2Ou48jxOazN0D6Q0Tf+3yz5jNCJXFFSo6harWm819uisF32pKIbrnVWAo/Me2LuBwM
         bTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985982; x=1794590782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xtFTk05uiNaRRdHOMAXi3GiW3HAfYxRIOaZ0COEoKVE=;
        b=RafWe7WnZvkceOpqBztWZKtL8F9LCfZBUjGLHwKp0UhR3f2fInQ19WXd0HrMqmGEAt
         F34UenwKP1JKXRxsU0VdT3JoM+RnENWQ8QLMGw05UrS5g2DHMrSmE68p8oWhjXPocv+1
         mFg7qtv9bTSXsxRqH83CwvQUxBvWnD9sBQB1g3/sirI+/TQ6ISwBGQ71w3N7X3C8D06T
         8hQvkg/dQrVrQhrhQJeiLAIn97ff/5QX73GAVdHX0d2N3f5AIeDKzs++Gm+a9R1Ou3uJ
         T5jmRkomM/wxHMQWCB7C4R5ogXaO941N6h9UxRixgBpDpKdgC+RP0ieNzweimXx08gto
         VXzA==
X-Forwarded-Encrypted: i=1; AL+hErGhEgb8xfNAL6vQRpI8hf2JkcYrn3WjUjUWwix7+E7EoicQRGXl1a7eSFkr1poyOzEjYUgfRtdp6Q==@kvack.org
X-Gm-Message-State: APuU4Z8vMr/AjWzvbfqGeAQ0L1MoJSfRQqMelaSPUjdFnI1MMZE7eG8Z
	p3jULC14YcA91LD6BIoEDYoQa5eDRbgU8fOFCl2sZ+DlJQ1RD54aZI09
X-Gm-Gg: AYBFou3KDq4W27IGoDvZwHnSF3XJfRz5qzPi76BXaj3QQC3TmAO67MmpBNIhDw118Q7
	W5T8K2faj+LBJNMCg/zfC9yxJYyMRs3D5OqzMvCF2d77sb85OVzluT2iW0PHixbMh5TRvZ1S7xE
	KNJpHkVtmB5STfwtZen4e7l+7teviZzl7WrOOGKz89BTPgNTe3qww0gPWvlpbj2XSleML+NIlZj
	qfSRonT29rWAl00YEbsMwopM9FlrDlU6CXJfbhzkpcsmKRUubR+V1uVRcyza08L8O4X9UgQYVc+
	6K5G9bKKL6Ciaphax6A6ofHEqSOzDqAHhBioJeLE841tA0iCNF2DNVa+pDmiNnTrdSIXD8uReh9
	wSg40XSbXdrsAN05TpyoJWLHFed/3vyr/erIlsdh4A5R+6dMawbGFX123LgvZfv7zWB5KqYi4gs
	4aFf5f8BpvRXKmDbjy+Ky7J4o6eV8hDwP1GRzgV0cM0FPdRQPBXCOaLGI9NHCkDiFwtaME04q8W
	KnLhFmmMgTh1XmzmJcG/pjlVuMEQRZV4Yv63GX/nvzVLb1JR2kkFkr9IwZe3yGjJ+T+9kgBYph4
	Vj5OE5ESmhFU8WxCC2wA8JVX95Fd95Sja3sg+nm7GxYdYAG19OhyvafDvylu
X-Received: by 2002:a05:690c:2b86:b0:8b0:ab62:c636 with SMTP id 00721157ae682-8b34199dcb8mr13500317b3.45.1793985981518;
        Fri, 06 Nov 2026 09:26:21 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f77055bsm23291777b3.8.2026.11.06.09.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 09:26:20 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/2] mm/vmscan: consolidate promo vs. high watermark checks
Date: Fri,  6 Nov 2026 09:26:18 -0800
Message-ID: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C301E20003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: k4wdt199t349t63scxfdm1di1xgc9id5
X-Rspam-User: 
X-HE-Tag: 1793985982-337672
X-HE-Meta: U2FsdGVkX1/ELjntkqY9jXJwUz1LCD5NXQJmRELLwyTmIRFXzxqh8jTfxuxGio6wQnE+iLhHtlKj1k+4NfYZrwxFZ00QQHuqmDlwrxA/R3isfMcXTzZT1QycW81eVFSvTQi5KLc67h2RE/3ICGFrPxIcyVboEtTdfXrOTxMveGX2YZHNEpObQdJW0NRlQI2iyIwTEgXmDDjQvMhwINYZsUl4bWgc9fx5t6jduerQByXpDp4fIUv9XSlTE12XvsOf8PnpqmWqZ75JYGaekvWpjwVQKmJW76itaLh7PvwrErl0FHglzOWe1bUlYbDM1Nc46gfmytg53DeT8lLU9IegGYBZlkc9yl4S0k5kCfI0aWQnwuDUHk3ELaTSl8wfcHs2priQN4f55g/qU2PL2d0xDsN9ILC1vDwa1XrgUYH+YMlwjefjeOHO8cXXHVDbuQ3eqFoyvhSQXE0rzFs5eny8+ghCmI/VE9SCcRlfM6HSfI4hW8DG/Lpfdo1nOWRR3Kq4BUx6yRwGZ3XR0jmscZUOhaonnOJEsFzLcUYPWu4UmCETcX1WR1A2bcHVZ+fP2OnTKvUmiFWuW+VDKbLNHdYRvepTBoQAjHiePtAXXaBT5jZX7Vofte6yYpSk+IYFzLhs/qBcumqK9i7Sg6h7N/lHkq2AR7Ts3PuoS4JAToKh48FK3kN+0VViwRy55iD6odmL+Ujbydnid6+1h234O1lo7NWKXIm7dS816HKApj0fdIxzw347KDUlCaDkGJUrJfncQ+RQzsET06mMAU7inkSA0HkP97ClaR9lhLBqqDmXx7ecUHRFOtF9rAl0dZEOZMwKtdMnrh6vPxT5SHGDHq9XfXW4bzPeTeEolmJZCVOSCABcJgKXZHr4xViN1+xyULk0vVqEuR5FeSKomZvo+xWWur0+OsOYX9WDNo552hVZUEOoKw/PNhL1yQOGktYa1T0dQiUEJ1uQIiKjmoRjFnP
 g1rPn8Ii
 vm7Ylrvtz7BasP8katIKLWxBu6DXHRd7Y2ZWTj/u2P8k3FueOVSKcHz+NmheTmDwLhBlcBDwQCsmXOcEjPSfbwiAJHtGS5J5PQbqyPLVfQzDngtZtNmsdmFgvE08rvFac8Jq902eVvcFD9Psztnn3W8Zk+nGwbYh8jT2NIKkqIZgh2gIbDkoUbf+7UgpuWJQQDBshrU5EuRAh4Y24I7jsqHPiDRBWjB/7urdqKbGPvqpgthGIvaTjxeLE+lNsZ3b6hs5RtOyn8fid1kYlTDLKnqeVk4xEUw4VHVLR6rzz06oPS8XAQyP3hzKGn7q/7iY7j9GvshnzeSpHniJXSTWcHwinixjTI53RyGQewDXpa42HYFSWxqoJyK3JM3dolDUUMUcroWmYfEqX7A5lXC0E3OmPrhQlbodsWI91rf/pok2XpaSta4I505yp0iTYUKcyRpyOectbmZ6JSMlViSddlu9blVkhOMpsKMxzSfiGg13R3Ar1hphtZNle/Cbe2/QYBDrO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

should_abort_scan() and pgdat_balanced() both check the watermark that
kswapd reclaims zones up to, which is the promo watermark when NUMA
balancing memory tiering is enabled, and the high watermark otherwise.

Consolidate the pattern into a helper function.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/internal.h |  1 +
 mm/vmscan.c   | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 78a7f17b9934f..66495845ec058 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -68,6 +68,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 				gfp_t gfp_mask, const nodemask_t *mask);
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 			      int zone_idx);
+unsigned long kswapd_wmark_pages(const struct zone *zone);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 071a6eaef1a1a..97c5843e14f15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -371,6 +371,17 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
 	return size;
 }
 
+/*
+ * The watermark kswapd reclaims zones up to. With NUMA balancing memory
+ * tiering, kswapd keeps room above the high watermark for promotions.
+ */
+unsigned long kswapd_wmark_pages(const struct zone *zone)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return promo_wmark_pages(zone);
+	return high_wmark_pages(zone);
+}
+
 static unsigned long drop_slab_node(int nid)
 {
 	unsigned long freed = 0;
@@ -5049,7 +5060,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int i;
-	enum zone_watermarks mark;
 
 	if (unlikely(sc->proactive && signal_pending(current)))
 		return true;
@@ -5061,12 +5071,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
-
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
-		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
+		unsigned long size = kswapd_wmark_pages(zone) + MIN_LRU_BATCH;
 
 		if (managed_zone(zone) && !zone_watermark_ok(zone, 0, size, sc->reclaim_idx, 0))
 			return false;
@@ -6966,10 +6973,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-			mark = promo_wmark_pages(zone);
-		else
-			mark = high_wmark_pages(zone);
+		mark = kswapd_wmark_pages(zone);
 
 		/*
 		 * In defrag_mode, watermarks must be met in whole
-- 
2.53.0-Meta


