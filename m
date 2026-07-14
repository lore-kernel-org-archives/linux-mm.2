Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767A7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FAC6B0099; Tue, 14 Jul 2026 09:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800326B009F; Tue, 14 Jul 2026 09:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF226B00A2; Tue, 14 Jul 2026 09:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4161D6B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:23:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97F02C0360
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:23:07 +0000 (UTC)
X-FDA: 84987448014.10.A38D580
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6ECF180005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:23:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YgoJDpOH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784035384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7NBFOxG906Drn2yZYxTN5FbdXtG8HM2NksR/ydZmHCU=;
	b=0tGzldi3/mk7nv0OJQaT1dBvr95kOiF9+o1bSll2GuHEp6LFzGDuEh4rrT1ANZDrMwtQEu
	Eq0AApVlYyVZURjwoXJ3zoseTpNRKlvF3Rih2MmKtSCLh596zCh8mwwGm/Fv9Yt5h2o0PO
	b1KNw5gTh3Wbq5gZi6Kc3CUjpGRy5Xc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YgoJDpOH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784035384;
	b=CSi7LM5FHRJxVztcOG4vQnRnrQiN5Gto+nimr5S9tiRD+pQIABZCHHNfZ8vUS2wKMNJGeV
	fFsq5HRh6i6Op+2TFQ1hdXJdVEKJNu5sw4uNYIpr7gTbCLQW8Y0slt4MMu4l8YbYttg9VP
	Qhr2t2V8LpS96/5fN5lPXSUNZStrdEE=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f25e3fe44so212670f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784035383; x=1784640183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7NBFOxG906Drn2yZYxTN5FbdXtG8HM2NksR/ydZmHCU=;
        b=YgoJDpOHcd5rKj/O87Y5rbHd3vbq596vfg0HNY6kZyaDVATrW9HeEdUqhiFkfRQDYb
         vZdnvT+h2C13K1LRf+nTxU3dji5j5nOk42AifjsDY8HoBEvVO3LhV/17rRyNwNUpg4ms
         rjWb3lmah1DHhqXi1jdgp6EtSoz3ecmIpcaqg+P7ckBdH0nJxDnU0gMHphUxEQL/SbaM
         o0Ngj+y+zPxaOfR0EOPQhH6JuRPuBkkIQijPfrGoF5AOb5IJ+D3rN/Nw/OhRQGW3R7Di
         UCDC2aMSA1+Z3ll0hRYpLkoVlR1IIQA6P4sqVtX7iEL3lkle4Bt58ax22yEEdpMUTZdH
         z5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784035383; x=1784640183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7NBFOxG906Drn2yZYxTN5FbdXtG8HM2NksR/ydZmHCU=;
        b=TjmN6bqixXgt3qSBu64d4pqjEOL9rvVr/Zz5Y11kLMSe7uzY9JEu+6P0FzsdubkIXC
         wqGts/fq67nMLeJ6CSXlTrV/h94edtvU1BVjs/US3DAVfUbIo9SzvE6w1GUgNA7dhkfV
         98Yl0pUFKh4dH8In9jXZBuoQJCQ3nABgwYemNkk5hN8jEHLlPCylyrT2+TxSj1MwGrTo
         psAguC1vm6KBLHbmiRC2mRSgVtr2k3KODT6I/eoAn1t61zMfOtWSN2htZ4tg+albrBci
         Sz2bKi524iPOYvw5V5MmuKG9uGtZVvIdpNh3OBihRjzQfgZW9Jqo+MWBNedrWhh0EV8j
         byQw==
X-Forwarded-Encrypted: i=1; AHgh+RqGITCxkbXlcy6/6P6VhcwM6zL7JTZq8Kj3iBktxb3Sacqo4tAuSZjIPXgm/NzmKSx91XfFcEw4Gg==@kvack.org
X-Gm-Message-State: AOJu0YzMKupQo8ejzaKCeNIyfClvkyRMXIRvbEIECqkaaEv3tp0xZ6oN
	zqcRMqu3qkEuHyq0Qf93IjMI6mHArfTeI7EuJq32LWH9bdT01ibs95QRS3xhgZcZJpk=
X-Gm-Gg: AfdE7cnse8DI6RAgrskbkyP1j0OFVP1yHxG+QeWCygOdiruJtfFyo4DKjXu+YqXMD2a
	9mTk1dsPB9rf9Tc81S0MtGlttrtzu0ni3Xc/KO8wXj4hpORPFqhddDeo/H9Ak1okuHSr0QkuQ7X
	rO2Cx6cjQlzn+oH4YwI8ebTuguJWv7HZnf8VXIVSrCJxF+ey6YfV8L0XSueIHApzyooSoTMMtvC
	kU7XRZLxEavIlHy+7ZX8VO8eGomrrtlZp6/vfsFpitNiwXmy5uit8sw6EkJfdChLQKzVd605L8n
	JRiXjXj27J0YFzi9Ed2wPsYX1U+gsdH3MK+7bnf0kYlbNcrSNY5wpxE6r4QaZaxcAPM0ZWOffcM
	5OnDf0HSU9+MdMTf6PJBAHmlXQ2Yt8HSf715uXlLgYEmJxPvDjWpOQuyMLK7LhQpOsxDcUplYEy
	h6v7IM906b6AQ8srfXfSq/huMRXSHxazgCDA==
X-Received: by 2002:a05:600c:848c:b0:493:b6a2:858d with SMTP id 5b1f17b1804b1-493f885b387mr72994565e9.6.1784035383086;
        Tue, 14 Jul 2026 06:23:03 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49508732395sm74727475e9.5.2026.07.14.06.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 06:23:02 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v4 1/1] mm: let node_reclaim() return the number of pages reclaimed
Date: Tue, 14 Jul 2026 15:23:00 +0200
Message-ID: <20260714132300.2136018-1-ptesarik@suse.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6ECF180005
X-Stat-Signature: p1nepbb4nef6ccmr3j9h9e1dmfmxqx3y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784035384-336733
X-HE-Meta: U2FsdGVkX19bY3ejCD7yzW8RnnQMWBG4Y8ZebON0SbRizCcdxrFAg41Anb9yq2pUfZ9HQMuYbee/M8lFRv5vUj/5eF/6AxcJEO+hSL3etOQ6I+hOhg3in1jIhBMPB42w0WV+IYk1vBRF2gsu/2cgeFT6zfBBYCDGTgVBKcSfAlYABCfGhbel7rlEkqDqNWtQTRlu/BIVrvhuqovKtyR9m9p13/p0Y2vV+VDkFSyCmv7PLo2cr0lL+yeam0DywhiH1LT+Z+vXakWiwZCALcCE9CVJlX5IQi3jYZ0LtPEvIgbK2GRgxlxr12CjGaWVAHr4LUy5Ek4+YY8fxb/HDRTD21+CnmlDh/gF4ITXiDTS7btiGsGJXKL/bbDLmNoj+DwJZqNYnG57YOrHmxruEQBhEYex2gJlyPC17R6Uaisw2xfEWLY6fL9WD0TMS5BIrNQCYuKEmOR9Yr2hDkvaHqZ9epDaU2YbfJLRf8d0cdpub4Bxa1koDSV/Q/sB8Oknd1SpO9/KWm9mWiBHxhxTjL1eVDAjh6aTMzGBwaOFxpEgyHsqoU4endIAWVzH/MrQ0WpQT0onnBLmxTMDhU9IyZkCfPj1VRriPuGrUeNS+EupIf8nNrt7FfpmQvu5wHuAKkGVq0P/37iYt8RxbqRktsepRsdQPuNpuB0XWQgcSZGfNxcK3GlAGdKR1aqHCHzJF+6lsiNg1mnC0RYqd9UV9FZQMtTnA2OvKAww6Ub57hV8bBfL7dBVn4fzdtlEHAgvwAkCwIndSgsBTOhmL5m7H/PvD+bjt9HwNyRG2rDB1HEByQzUIdsOXdaXtMqBZefXw4J2A7HMKFK0KZXFiEuNCHQBvspiiOhcQKV0+uLDNPhgGScgT1dxiWkUK8NdKsx8Xu3yyUSqP3/bwGRufNeRn6rbEBvmoJ5h9EvX2Kj+X/JPb7/MbgP0XnbwgGujB2dQD/oFVYnvDi/TDtDQmKPXfQ5
 dTdgAxnj
 /DHTGKDy8PYXAcMji5ep4R/DKlJoIU18mdfIxopB9/yr+8VGHvXIdBo8JcG5/aXOgRG+8FzNnvtbYDlhzDTgjJmFFFlQtu9wl0xvTqzCveVBCg21EYHAeSJShYngpC2+DCTxEWAcbxZHaL2gwC46mbRHhVOJ4OLf+vOQ0uQ8HG4tdOSaYguWWI5psa4OiSytK6QJyYmmvZ9G6EeN/3Xu+JueDab5hSg9A1FdwPXuBp5ykgD6MiOKWeMJpC3eXQfxeYCQarxY2v78CYRiVNJsJ4EhjmQpmZ6G4xSp5zNCm+YTZ+BGNHO7ZijalgMRXVRDgfJuQ4YnQr2G+UF4pJyMOdsZBKDZ2zDegWyjVIddpelI2E6yRVnEHLqfozLAPhE0eDgrWmtSntMtUWGvdbFn+VxOiaAwuPwS6xNd5xEfKFfW2YuUjpE0QJiG9gmzJjFtIZYnIOmtJJK/fuzad+ozfbgLOB1QwiqghbHMTrLHmXcDf5jkLEHFSB93FqAYhR7EWNSCANKv1ZaluWwDKAkGb70fGiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is only one caller, get_page_from_freelist(), and it does not make
any use of the reason for skipping the reclaim, nor does it make any
distinction between a full and partially successful reclaim.

Therefore, node_reclaim() can simply return the number of pages that have
been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macros
can be removed.

There is one small change of behavior when __node_reclaim() was attempted
but returned zero. The allocation now skips the zone immediately; before
this patch, the zone watermarks were checked first. I believe it was an
oversight rather than intention, because the chances that zone watermark is
OK after __node_reclaim() did not reclaim any pages are very close to zero.

Originally, I was looking for occurences of NODE_RECLAIM_SOME and
NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because they are
typecast from the result of a relational operator. This seemed a bit
fragile, so I dug a bit deeper and came up with this proposed cleanup.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
Changes from v3:
- remove NODE_RECLAIM_xxx macro #define's

Changes from v2:
- remove the enum and return the number of pages reclaimed

Changes from v1:
- use an enum instead of a bool
---
 mm/internal.h   | 14 +++++---------
 mm/page_alloc.c | 19 ++++---------------
 mm/vmscan.c     | 16 ++++++++--------
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 874be94cf2570..f26423de4ca28 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1098,23 +1098,19 @@ static inline void mlock_drain_local(void) { }
 static inline void mlock_drain_remote(int cpu) { }
 #endif /* !CONFIG_MMU */
 
-#define NODE_RECLAIM_NOSCAN	-2
-#define NODE_RECLAIM_FULL	-1
-#define NODE_RECLAIM_SOME	0
-#define NODE_RECLAIM_SUCCESS	1
-
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+extern unsigned long node_reclaim(struct pglist_data *pgdat,
+				  gfp_t gfp_mask, unsigned int order);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
+static inline unsigned long node_reclaim(struct pglist_data *pgdat,
+					 gfp_t mask, unsigned int order)
 {
-	return NODE_RECLAIM_NOSCAN;
+	return 0;
 }
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c97a86da2b9f..af63558391345 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3908,8 +3908,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			int ret;
-
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -3930,22 +3928,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
-			switch (ret) {
-			case NODE_RECLAIM_NOSCAN:
-				/* did not scan */
-				continue;
-			case NODE_RECLAIM_FULL:
-				/* scanned but unreclaimable */
+			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
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
index 4357a44ee8767..b7ef032e78a0b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7768,9 +7768,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
-	int ret;
+	unsigned long ret;
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -7797,13 +7797,13 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
 	    pgdat->min_slab_pages)
-		return NODE_RECLAIM_FULL;
+		return 0;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
 	/*
 	 * Only run node reclaim on the local node or on nodes that do not
@@ -7812,15 +7812,15 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	 * as wide as possible.
 	 */
 	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-	if (ret)
+	if (ret >= nr_pages)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
 	else
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
-- 
2.54.0


