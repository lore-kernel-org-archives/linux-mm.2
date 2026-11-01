Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E5960A261D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=BYAwtz10
Received: by kanga.kvack.org (Postfix)
	id D0CC96B05B6; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4706B05B8; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABC76B05B9; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96A1A6B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 228FF1C3D5E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:59 +0000 (UTC)
X-FDA: 85384929798.09.496EED0
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58C13120005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BYAwtz10;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499237;
	b=VU/EsDzVD+eNkl77UO+H8JkFxpWXHY8PHCy2RBP/OTlZv21MSnh9VMlPMYanZ8cDlXG7Fe
	997arw6dn8YNRnW+sBRpl6u72Lj0vHd52lZMVtgY7CbOANo5QttbxFGzTKQb7g4LcMluP0
	uiocOL7Kp2N+7OoYclrUY/2su5QAOV4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BYAwtz10;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfcQbHHTje9Qk+CY4i9Q1tMr84K/2Do4+uTd71vDbHQ=;
	b=hIyAzsQv9pQqK8FFiXPMkjGTHOfYqUYnUO1yprHnmMdbQFkofzwKIAC+ep6I4oo/0PdXSu
	UYVOvugIpCglELLihQhrIjS4vRuVVwt4KQMdhpGwTikqxxxsWrdnt0An+enWn7R1SWmfPP
	gApizQV2cO2JKBcqjXodngQcjj8u89s=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f20b304c0so182779485a.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499236; x=1794104036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bfcQbHHTje9Qk+CY4i9Q1tMr84K/2Do4+uTd71vDbHQ=;
        b=BYAwtz10RtEAOiLkVIb3KY6wKIMUb44oO+CQEgDSUcMYMXqXP+4r37r9/Wogc2lLG/
         26aqaYZW1w+WxbgvIIyHFxMTVmh/vu9V22ATIg5Dnmt2q5iwTRgiLIAJp8Ypri/CJZfg
         YxvcNhF1q03+Y8dxKcmtpebIi31bpp/dhcOT/yikqXZz8rDCJWcuEY0iQ2GWdRcRFL/q
         D2/FreQXHPe62uy95csu435SjVMEN58/jX66dDJGY4YffmTYD07ufu2p7C84GaIlcTUo
         QpZrFDy/MViZtzUDV703UYoow3gkH7Z9zUABcIkGdPYEc9CbPDL39UVEtS1GA4vpEh/F
         fj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499236; x=1794104036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bfcQbHHTje9Qk+CY4i9Q1tMr84K/2Do4+uTd71vDbHQ=;
        b=ZEzabV1RrqYXpeddxYvfY8GcRhqjNycHGczzWUa/wULFC6Tuf+wwCrlOVHBcsY60J7
         G7sopTyWsshIl2SVit8drqEee2FDDG7iW+x77AJGxquVH8LO79lGaGq7g1frQNyIxJvF
         nnWJb5RIVSue9FNvG4DRvbKR+w4CT6Q7OHGjxJYL1jmLN04GTwyEkKn7ifYyXAnlFvbq
         jbs6+cY7jlJox5IOT0FIMMTzs2KOCAQtjqJyfvMZKmnf/3c4bhJhOiE8S3SU2M4iTK2V
         p3sXRaWxqPhJPMesTZOPnu01B64nshjAB4q8Md81nkVjdHy9C8HOU1sHmtpJ0qujcNak
         tcOw==
X-Gm-Message-State: AFq9FYJs/x9uQoAYfcrOY94xIY15gYP+ZERIeqdm1dZA2X/svzIh7AN5
	DOi7R2nqFWmS6Gt34OVRR3zV/5hmSqHYLqkidJepQIR8UXYrEEYQKq7KbIkQdcnKws/Z0rD1JmF
	MRWfb
X-Gm-Gg: AYBFou1tonUiJHTmANZ05HB7obomdQ1uZNqLejFK4/4XSmwk28aXtKpr5JyKKFtl+Ay
	/wiWSuND5SjzqE+beRupUmhs3hErjNR7R31+p9E5oCucqbocYwUE+VJR6NGEzprK47pkzxdz/79
	taOt0kggQytlU+TdV1ovqueckt931jeKh6KnBUHIaSPIg/LG92dnpLjc5A4nWMZB4FFoz6wQU4/
	rXIIyVjS9eErExsPf34KwutEB2ftYFoiTBFCUjVawvHgTrkSV5X8BJzxWkx2jAmuUONvqLsxdPX
	lohsqnmPyaslSUi2nBV6UbeWV+LENpw8XMHbzK7K2jJcHCNLLBvzpbpBubd37Veg+KNT+rg3N9J
	XhIBp32ACYB0qQ2ebfx2u6XvvbTc1kky5lriBJt1J/o5IX0HCxeMS8x9kDSknSQlfWbM6ggO0E4
	ABCCDGVr4PCghArycXG4iBkHMOAu6ypJlAfg7/MABwzMPNIckhUTtSlTwMTE46L/H6cY8lukdRR
	yjWgzvptaYBb7Y55owtu7mdPBN8kNJVO5enyf21Ai5MSeertHurm5P9gZ5fkjmtHWNvEk9HD1oR
	6LgnJPdJ4uqQEknwg/FEGQQvJr6ZzbSP1PraEDg216+jtNhkH66ZfgoERAmAks9TXEZ1sM7Le1v
	fhota2BQtmw==
X-Received: by 2002:a05:620a:4555:b0:93e:942f:b8b1 with SMTP id af79cd13be357-9442173ddb2mr1115363085a.64.1793499236470;
        Sat, 31 Oct 2026 19:13:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:56 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v5 06/12] mm/page_alloc: snapshot the preferred zone against shrink rebuilds
Date: Sat, 31 Oct 2026 22:13:34 -0400
Message-ID: <20261101021340.2251928-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 58C13120005
X-Stat-Signature: obpfa6znshxhpm9s8gsnc8c659xxsk63
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499237-976082
X-HE-Meta: U2FsdGVkX194K5xHfpopv86r1ez8jSVLSYe/07HN5afriuCbkseg4Xd6bpYFGTVHQhhc6Sn/G1qv8cuosBkvGDaFvNf/RX5qVmiRkG2Wf7lCyhT4CM8CLt6O83reGv30Daij27dv6o5GAEBa29RE+2Ajd/BnMiq8fjU/Waw1IvcNIDrD8sOkhZzEQ9r6dRDfFMCCVPgIOBbe6Ro9IAqYvz2/acZSeEJX3w9IJ4TnNhLVCdSsScrILbwKgxCeCCNITQcEV2SHHNLKNqCcwkcfVbu712qTTw3DKIq4MB9Fji7iPcFco/Si6OwdGF+D7NQtBMOFldaQZFxjlRQb2/reaUIMH8sk6mkEe1l/FJ6xMuwQ3O34qlaxjVEqkM01kK5fkSX+9HeACHQAPHmtf5iTJcpzQlLqznwFIQ6dufwpO4ZkFuN1HSvZOdezPAKt+uVhXrqQIWmq4KeQ06F8Z6HF4m1Ea8TbpuX5mwIMRuPyrXwzACMKkQrfi1GcDucDJPTnwMZFLz4wVEXSOGIWdsYBMA++jUVUbOF7IUOakjXkhd9JWTBclpaRJeKNzxUwgLMCXZhzSIBktjwxFwMGJKkAzGNNNHKyKylIZnGvUpc/p1/uWhSbckKH5EYDi3kVd8I+GObT+R5Q1wC2nMQTt9SKvXbNzGEpj7+uTaDiJPfhrNve2xX5F3vyTurm6KMbdmvXYomS5wfYSOpZindrTNg4IIXm8pmfu6Vc393moDx9sATJpvQ97egNUL9G/RsBNuU8wfov2z+zUKiSa2sLPJCGnrEUiS2LsNphwEWWdhRcqgWRoxMP5EX+6t2+sBJsVgGGV/RTZJ9rWsVZlxUT6SGd6iYXUCgpbtCyK3nL08JpLcQTGeBnto1lZkoZtyRF3pbgvCeqZc9uvYNvLTFGdfKR+uvQPJwYLEhWbNe9yRJHyVv40gStZr7gvjqFVhmePcJtFUIBCBfzbGRohwXi1qw
 rm0WVRBY
 JuvP1BuAAtDTWhtuTo0vPCseVrLVqfpPfSq6KSoaRxlhzBS7OBHqMThkmnHAJnF+NDKaLdOqganFhCR0syv4VjFNoZTcnY1RpTm/W2e+qimSIBdQJ9ns8O2E2/P73wr4XfwS5dScnJW9dgzQA0RMhMoZkIHieVaI8K6XPoKjmAPJmGGr3qn6QD5imSIncz3ls3gEG5/5eEMzuFGMNRcppwC6XyRsqdoWIOmVO8P9Fs2l0OB986PGczEeRFCK2K291HNEAxGVSvTMDQjSd18dNzbyR7ZHCJqNzhbe8ZghCiKKjSmN8yuRbecKXwnFM/XrdIftG+hOi8QNQaX6S93iOshH296SSBDhnV494oP3a3W01ZYxGlRbN+TGzwJ3/sSOO6BDcXKT9ZzZ3zUtTLfzZZXUvA9T71z3si5Dv4lJdwdk1JNRZMUXnDSxWHVlRSRGBFgzo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_page_from_freelist() and alloc_pages_bulk_noprof() reread
ac->preferred_zoneref->zone at every use. Offlining a zone's last block
rebuilds the zonelists in place, and the shrunk list's NULL terminator
can land on the preferred slot mid-walk:

  CPU 0                             CPU 1
  get_page_from_freelist(GFP_KERNEL | __GFP_THISNODE)
    zone = NORMAL (slot 1)
                                    offline_pages()
                                      build_all_zonelists()
                                        [MOVABLE, NORMAL, NULL]
                                        -> [NORMAL, NULL]
    rmqueue(zonelist_zone(slot 1), zone)
      zone_statistics(NULL, zone)

  BUG: kernel NULL pointer dereference, address: 0000000000000060
  RIP: 0010:get_page_from_freelist+0x6a5/0x15f0
  Call Trace:
   __alloc_frozen_pages_noprof+0x125/0x330

Read the slot once. Zones are never freed, so a stale zone is safe, and
a NULL slot fails the same way as walking off the end.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 11be12b443ad..28d46f987685 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3794,12 +3794,21 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 {
 	struct zoneref *z;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
+	/*
+	 * A concurrent zonelist rebuild can NULL or replace this slot. Zones
+	 * are never freed, so reading it once keeps a usable zone.
+	 */
+	preferred_zone = zonelist_zone(ac->preferred_zoneref);
+	if (!preferred_zone)
+		return NULL;
+
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -3846,7 +3855,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 		if (no_fallback && !defrag_mode && nr_online_nodes > 1 &&
-		    zone != zonelist_zone(ac->preferred_zoneref)) {
+		    zone != preferred_zone) {
 			int local_nid;
 
 			/*
@@ -3854,7 +3863,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			 * fragmenting fallbacks. Locality is more important
 			 * than fragmentation avoidance.
 			 */
-			local_nid = zonelist_node_idx(ac->preferred_zoneref);
+			local_nid = zone_to_nid(preferred_zone);
 			if (zone_to_nid(zone) != local_nid) {
 				alloc_flags &= ~ALLOC_NOFRAGMENT;
 				goto retry;
@@ -3916,7 +3925,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 				goto try_this_zone;
 
 			if (!node_reclaim_enabled() ||
-			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
+			    !zone_allows_reclaim(preferred_zone, zone))
 				continue;
 
 			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
@@ -3929,7 +3938,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 try_this_zone:
-		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
+		page = rmqueue(preferred_zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
@@ -5169,6 +5178,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 {
 	struct page *page;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
@@ -5217,6 +5227,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
+	/* Read once; see get_page_from_freelist(). */
+	preferred_zone = zonelist_zone(ac.preferred_zoneref);
+	if (!preferred_zone)
+		goto failed;
+
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
@@ -5227,8 +5242,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
-		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
+		if (nr_online_nodes > 1 && zone != preferred_zone &&
+		    zone_to_nid(zone) != zone_to_nid(preferred_zone)) {
 			goto failed;
 		}
 
@@ -5236,7 +5251,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
-				zonelist_zone_idx(ac.preferred_zoneref),
+				zone_idx(preferred_zone),
 				alloc_flags, gfp)) {
 			break;
 		}
@@ -5295,7 +5310,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	pcp_spin_unlock(pcp);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	zone_statistics(preferred_zone, zone, nr_account);
 
 out:
 	return nr_populated;
-- 
2.56.0


