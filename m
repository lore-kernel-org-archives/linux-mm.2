Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF31CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAE66B0005; Fri, 12 Jun 2026 04:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BB46B0088; Fri, 12 Jun 2026 04:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A7E6B008C; Fri, 12 Jun 2026 04:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10D046B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:50:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F8B71A04A4
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:50:58 +0000 (UTC)
X-FDA: 84870640596.10.3852524
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D4A61C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:50:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dfduYjYc;
	spf=pass (imf21.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781254256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nNJytZYwtWap9OtauGtl0DFhUI7k+x3Laa2gQQWZ0fs=;
	b=1jnfGBexnJgQUrsGohRX5HrUmfoERfu5FfR/urPPY+RkaTg9mHm9rpKslfbH1FDKIpQW2x
	1jWLgJlDi9+1e1in3/lnPK+1hfXIT4SdE95/Tk667pgyrMfccedSPNpX6xPz3QjkEC9FNL
	TTCHFRctvugmdFHE/s1X4pBXpySDy3Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dfduYjYc;
	spf=pass (imf21.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781254256;
	b=G5XusR0Huu4m5xlmP7IRVMr5UaW7yAKgJbwJVrjozTgnXsrqfNlGEnUb02hDpI5lvz+rGm
	H9B2fpv9Da12bsGtYJA8lOZFeWkXBOFbQZY8Y6LRGyFsaHn6a2hRs6FGORjJigZDg/g1i+
	rH929YKoyUKOOIDlTMMrxiq9nWrEfIY=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso1616655e9.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781254255; x=1781859055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nNJytZYwtWap9OtauGtl0DFhUI7k+x3Laa2gQQWZ0fs=;
        b=dfduYjYcMIdIf/He6P2msg350/s6okqnkd/hxZ2eSBjPCdX58K6xW87Np/7rWhZK03
         mRg3Rl9Dosr2c9LFUy+2RXqRXEVxFCmW/E++98lH5+AYJUr6yKwTsU+uiq5B2cUC/SfV
         gRmHI3exCl5G1lgyhd9hWFWc9EMb9XMNRhL/PHsZ/WTxYLW5p1+x0xS0qmUV2EKTR44G
         xqO45i0HqLBJiIbhJ3JfHifI67/KbwyPdVWaf/deiHyFvcZ3g6XfNVBOS3FhfrejnZv/
         gPvpbyuiC3ymkn+Vh9VppWwypywvzcYW5o50RcMlUru1WuCFH5b67Z+gqYIqhXaKw8Yh
         V2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781254255; x=1781859055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNJytZYwtWap9OtauGtl0DFhUI7k+x3Laa2gQQWZ0fs=;
        b=g1yibkJEvdmPlqrIOPt09pYHk0H7yWP+nLNqM0gmIhZszEge1R4/oSg5/PPWKjaXQk
         2ZpPP6tfgbkiN/kT8hfakEOQPm3LFtES1C07y1UvfGal2XP3Kq8pHWwqMl1m0ziaH12J
         cwBJgOHgFENrxUuJKYyiYohshYynFxlzt9vQYVvpvscq7ySSad34s5shb1IOUP+pg/fE
         RaGpBxTMkfmEPLmMhKbWZl/AD4DwmJfdf4lX6r9vC3YIVafbSl0XVKQxtiF4QSOJZ+j4
         DtdGxCOJca2u/JgC5mSjgSxJ0Wy/eL3PVMa0GGU8SFL6lCtfEpVRbTvgPIudZiKNr1vL
         gpNQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kYJ8+weG8uudqXx+hp0eVn0Mlq0YD8jQfX7XNxOKbGqoQXb6IP7Vij1qv4EGKquv7nmr0eW8LWw==@kvack.org
X-Gm-Message-State: AOJu0Yy8Fv6BvtqwJzgaHI/5N1/LIYZlhfdJWt7ATFWREJwaIxG1Ef3y
	S7dE4fVTNBMacYuhyplS5R92WdWsUQ4G4sFM/efnpcHwiUXlX+Snt6N2aBCKV9m7DP0=
X-Gm-Gg: Acq92OHlQ8Q99waGZeSqqvCGONqIJi2fMhkFGOM/E9FBng0TQ//Y871X8UPvQuV5kS3
	9zmdn8mHG1eLGZLoxnARS26wJ4USB9grp4XUUporCjagbcdiWzLLeyMVo22Tqk1+n1xQvbvWwe+
	no1X5tj1I54bryM4ak/+l6TVzJmWsHYlg1FQjxD1CgkgNMU5N1ifZz6UIjr96ps+xeqmdH/e39Y
	mcyREKp/PzlFM3ayoIzMi+J3a3hVDxhFFhWRjZ3nK/m3YhHfFEZP6A0lImtGNATg4l+YCw9/M60
	9ov4UN/E+2l3p0f8DcuJ/LlSrmciePdr02kK+nsAzbmYC+2iqkB27Ers3hATRKAw9bEN+cXiIlC
	mMq39gMtA99px1wpRRQbhQQ1d3UAb3ndyo2k3WntmV4EMGkpFi7/zZ5el+8QgqzZuhMNAYkTtuP
	0eeUYlvYea3zd8SxmQge4ZpDXJJJkoLy29ROhv9Hd+dIYA/xOuq/NSlU3rAlvv/ziwwr8mL+741
	vbo9Eb8C9oHqb+3A57j9rtMYTSj
X-Received: by 2002:a05:600c:3b04:b0:490:af9d:8b6f with SMTP id 5b1f17b1804b1-490ec524eeamr9355105e9.7.1781254255005;
        Fri, 12 Jun 2026 01:50:55 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c90668sm119824505e9.4.2026.06.12.01.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 01:50:54 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Cc: Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
Date: Fri, 12 Jun 2026 10:50:52 +0200
Message-ID: <20260612085052.59291-1-ptesarik@suse.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D4A61C000B
X-Stat-Signature: bwdd9cpiexwfp1q43mc6y9orhssaf1or
X-Rspam-User: 
X-HE-Tag: 1781254256-853873
X-HE-Meta: U2FsdGVkX19tmWBSREDf5qvODNbQqz6zG/UdIJrKVC25UXkSaYMLMcPiDmNBQL2LOPQfDYFESs/c4G71YbgFIBvJQgIGzFKc83jVo+rXma1IbUa/Yfe2Akw7Ob000O32yZjP4P97B+/b2H+PDnbalHbrt6tWXTT6j23TvuzVFHo9SXRljumwZNiiSJMtjQ3gP86s0TG2vJvZilmfv7jcyzbQX+Bb1yM6u975q97tZ2wuFdC9P01SkZ1KaptiNu/mBvN4jK43qGAA/TasneQhk2c9XhMyrTYYuF/0kF6Igk6en1zPo5VyCCyyuMOQeajGxC4iLYm9sewvzzDLJK5neX6GLnQ1w33/hUr5Qoj2JKHaTOzgYKvHJqGoENO1n700Q//D/vk3Tz9Taw549VbDVad6V1XpwMMwqxUooYf8/AybaTD6WyiMXUux5QGGI2Bq1hL6tPKh8+RTMCmTCqGDR9x1gnuCHfnd+gtMNp1UMKUUr8OUr85LWCxjCcZuO53mkHxb2p4BYKg4frEjUsjmHgCh/+M4EONwod32DqraEBBOifMdn2Rv9IuZHXefsTuQm5TY91q/8+8e5fZ1ikNo4ZrAEqIhAKXwTpoSqlWVUdp3DmcsJ5N4XZzwL/Q5BdbRpV+Tjwb9OxOZ9jLd3UCPaXcNJUIfaJVgMNB7WRzfK6Tdf3LFVHQlKxvKdOyzuKMlrZSXobkB+F1AnXyPgxd8EUnHg9jgKOtMWLURO9mv/CWozSGYOgkSXQUi6lsmurGfh5OFBZT+m2QPbordPUcaaZOh0F4iSn6HOQhaNWZZEFEh6xANnXgOhmizutpyghUPOnEcCi1nz6WAkeSyTR/g5Jl8mxk4D3QuIpXUlTIBxI5Ej2VL1SmAAQ3wGbjI++/ilNUxkGb8SSsdK+lS8LC6TzVe7Wdqnve2X5FC8XwmQUSLiqpHi8Sz5JGx8tVGMc/mLoKhMQgGCaRXdthqKQp
 drSx41jW
 v8VjkvQyhqUlzxZe/2Nb+pE8E3vXKlrrVdbSTxG/Jtvut8n7EzmGrqNg3VXg4t/bbe50NBfq51zMc1+KRvfkzZDt2dKA/ouiDBCnuWufANCSc/YMV5z8gczI1fRgpnqT8WxfDnpiSrnrqDO83bx3u0ZRKvr+tbzRZUAuBeaLRBnCn6rrAq7MaKd1VAw8j3Gw0ZBzfd8wk6RmXpbfsOmuODQ2Ekaz+kU4dVdP7i365HDEg/3RQgqtOe98qAuzWdBIB+AV2j7+09DE9QU0UxaHuMojFNW1t04GUv2a/w0HnYxRcITFv0TcWXZtmvfJtX+i04Ky81Ip5JlJqHPemhVgK9KdcldvUg8hSlZPVYAVyfQ+UcPW39lLBKRnLhLYkk2cAHUBZuRP8emyoPEMzC43Ihlp+JBDyrZHOyf/fho0uFFKjCC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change node_reclaim() to return an enum indicating whether any
pages have been reclaimed, because that's all the information
needed by the only caller, get_page_from_freelist().

This leads to the following translation of the old macro
identifiers to the new enum values:

- NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
- NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
- NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
- NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS

Originally, I was looking for occurences of NODE_RECLAIM_SOME
and NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because
they are typecast from the result of a relational operator. This
seemed a bit fragile, so I dug a bit deeper and came up with this
proposed cleanup.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>

--

Changes from v1:
- use an enum instead of a bool
---
 mm/internal.h   | 17 +++++++++--------
 mm/page_alloc.c | 19 ++++---------------
 mm/vmscan.c     | 18 +++++++++---------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a20..89b0ea28051c1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void)
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-#define NODE_RECLAIM_NOSCAN	-2
-#define NODE_RECLAIM_FULL	-1
-#define NODE_RECLAIM_SOME	0
-#define NODE_RECLAIM_SUCCESS	1
+enum node_reclaim {
+	NODE_RECLAIM_NONE,
+	NODE_RECLAIM_SUCCESS,
+};
 
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+extern enum node_reclaim node_reclaim(struct pglist_data *pgdat,
+				      gfp_t gfp_mask, unsigned int order);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
+static inline enum node_reclaim node_reclaim(struct pglist_data *pgdat,
+					     gfp_t mask, unsigned int order)
 {
-	return NODE_RECLAIM_NOSCAN;
+	return NODE_RECLAIM_NONE;
 }
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7db8f049bd23..83a1caac5ac9c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3899,8 +3899,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			int ret;
-
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -3921,22 +3919,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
-			switch (ret) {
-			case NODE_RECLAIM_NOSCAN:
-				/* did not scan */
-				continue;
-			case NODE_RECLAIM_FULL:
-				/* scanned but unreclaimable */
+			if (node_reclaim(zone->zone_pgdat, gfp_mask, order) == NODE_RECLAIM_NONE)
 				continue;
-			default:
-				/* did we reclaim enough */
-				if (zone_watermark_ok(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags))
-					goto try_this_zone;
 
+			/* did we reclaim enough */
+			if (!zone_watermark_ok(zone, order, mark,
+					       ac->highest_zoneidx, alloc_flags))
 				continue;
-			}
 		}
 
 try_this_zone:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3f3ff25e561ac..d5bd55620ee9a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7786,9 +7786,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+enum node_reclaim node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
-	int ret;
+	unsigned long nr_reclaimed;
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -7815,13 +7815,13 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
 	    pgdat->min_slab_pages)
-		return NODE_RECLAIM_FULL;
+		return NODE_RECLAIM_NONE;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return NODE_RECLAIM_NOSCAN;
+		return NODE_RECLAIM_NONE;
 
 	/*
 	 * Only run node reclaim on the local node or on nodes that do not
@@ -7830,20 +7830,20 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	 * as wide as possible.
 	 */
 	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
-		return NODE_RECLAIM_NOSCAN;
+		return NODE_RECLAIM_NONE;
 
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
-		return NODE_RECLAIM_NOSCAN;
+		return NODE_RECLAIM_NONE;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	nr_reclaimed = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-	if (ret)
+	if (nr_reclaimed >= nr_pages)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
 	else
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
 
-	return ret;
+	return NODE_RECLAIM_SUCCESS;
 }
 
 #else
-- 
2.54.0


