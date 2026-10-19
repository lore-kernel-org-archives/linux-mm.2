Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B99060A3803
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=q9xJzBvC
Received: by kanga.kvack.org (Postfix)
	id 14BBA6B0314; Mon, 19 Oct 2026 13:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123216B0315; Mon, 19 Oct 2026 13:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012B66B0316; Mon, 19 Oct 2026 13:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC9FA6B0314
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:23:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 416BEA078F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:57 +0000 (UTC)
X-FDA: 85340048514.23.1CA5FEF
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75D26C000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=q9xJzBvC;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1NZpg4bEcv0tM4rCujJL7YKJxmpUNmsXISBuFDoLRI=;
	b=uLAtgnqS5kSP2iWGe5oDODXIseD+e2UI5/a/zcZYQvqxrsSUHHzdbwuAIK7B5NCx7PiKl1
	QW5/sf0dmPqn4P/OWyqfda51zQEQSE2w+FzMlU43QxewEr1Sj4zm9xesi5NI92xH2IaoJN
	hR3uvT28ytDJ7N9MAm3oRzuIcS2d92o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=q9xJzBvC;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430635;
	b=ANLgwTwBZ6qcFn+qfLge7iSCwWJ2/Tt+FP9+BTR/TbAx6HMT2ro9NvdYjuxOqCbQHuqrQH
	Ws4yVx1dxXbtg8CuTMX+bPuLp8oMY1kqsFn1OY9j5csrzoAnGWo2mVxRUanFS89e/8EHKK
	lclT+kkrBvUtDFoHG1+IgmFF3N/cKhQ=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f1e5d7450so239229385a.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430634; x=1793035434; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f1NZpg4bEcv0tM4rCujJL7YKJxmpUNmsXISBuFDoLRI=;
        b=q9xJzBvCzQ0kMwDPL6xyAdVrPl6gAEnx+qEdpwEugcKf16qiGSixw6erpbdF0zshVA
         og2BOB6qoCpq3tuCUZgxJeAuvgsWx0Etsd6mHTAK8NLWHkCsknQLt3PY8oSxByLV08yF
         9Cl9YLmQb+KyOTYDKkR1R/FN5ZcStQAKTKBwSHdAsFV4QHHxZPQoFtPm8hxwUc7DimGi
         LYDSLrRvCFp3SUUXPlPzp391eHCTUQ8PWPuYaTyh0B9DMTq311ERTjzbRYmTAR26Hota
         u2jvw2PMBeKVPtc8aa4dZtdVpuYKOHS74aN3U0q9WbGNRmJQe4c0/oanBprQTRRCIt/x
         VFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430634; x=1793035434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f1NZpg4bEcv0tM4rCujJL7YKJxmpUNmsXISBuFDoLRI=;
        b=d7suF3lWg8g52m5154yPlyWAGoa5ekKKOD0UkaV7pdi/igSBbSFQGTxbVuBOAu5tPs
         oJOtRzY74kL/gl5RoEYY9mIjf+lpv9JDZDGz8VarGpk7EHiCi+VBLFMqWnIha1B1V03a
         jr4FBd8XgdsYt4wq+iinb1Sh01boyqjPlfb2uIs9lg3qPLktAu7MXllWEVFteOuMyrDT
         /fbBkRAHL57Vic/tGeOScqZpv5d7cVCqXaoIhQ7ZBgx2lR+9Pe69A+DBBLXxJAdTBihV
         tRJHRk9xf8ofm2sTIp0A+arPxdQ6D0pKk9WFz+qcXFR3U5pWEI1WPym0nz7ae/esg6T+
         rqNQ==
X-Gm-Message-State: AFq9FYKI5JX9DVUftkvGq0lX+djhQBOgLZfS62+XPBfos47Ur9xwmpG3
	MMQLfOuE9zrf/Uo3HnlWwJH0UxHvj//AmF3qDpIE7AcCrMxct5AGmDVNcp8OmBm7gG8nmTZ2obV
	Y+2Ge4sk=
X-Gm-Gg: AYBFou06dDa8SkLB6NDClNKwQxNNEaye0TVwnNxeJAuff9XGoyG2LjMyoUXD3BtxpA/
	qofDxFp7kt/He0adshEFgFsdGCV3BLH03cu5PjzS8hSjBzhfRBizY3xsIcvESA1bSZczmAUMT4o
	OLExWrg1WNWbqhEkT8FGOB0VvJTBYM2klaCl9JfzF2CuAMHq9Nk82/O2lLTniKV6N2O//WRBR8y
	FQjWiwN35cxDD75RbJXw4hL1zWqAiMp0kDIUdQ4nTpNGyYGrfVEb603lY9uijRAapi39FRYSOF1
	GdzZheMev0h6zDfHZHLIXWMO6h4Z3P5gJy8cnmzILyISRp5b0/ENzkET0XMvfzgF+v2clQzm9IN
	z+1qoYersPAJZBk534/n/+gu55qdFZbJKPMFNJaNAJKJxybmByMneojA6NXGAvrC+fKWzg/2Vvf
	jkNkYoLdLUi1se8xfi6tVEzifhX1qGpIAnsh2mc7N4f2QVKQIXD0pCiikcMN6kOp5Gp6zOJz6qN
	dcleJA2GvN997iH+//CX0jMhkL6sEXFxOZIjZQpLtx0l7tdrt5TIIvoJeTZ
X-Received: by 2002:a05:620a:3711:b0:939:733d:cbe0 with SMTP id af79cd13be357-93f29b48f16mr1396488385a.3.1792430634536;
        Mon, 19 Oct 2026 10:23:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4adb28c2sm14615385a.0.2026.10.19.10.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:23:53 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	jiang.liu@huawei.com,
	Bessel.Wang@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v2 3/5] mm/page_alloc: snapshot the preferred zone against shrink rebuilds
Date: Mon, 19 Oct 2026 13:23:43 -0400
Message-ID: <20261019172346.3344005-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019172346.3344005-1-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75D26C000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: espib8hu3o7r384i7yuyud5ygq5gh9sn
X-HE-Tag: 1792430635-877779
X-HE-Meta: U2FsdGVkX18Alw+bO4R1Iq9mArDW57MpiBG/vYe2Fll1QXax+xRaNyijqTuOqR9jz/YQ4qg9sb+115hfkLNa0/w2ZrPdUpJ+13qaVcb//cvo22ZWQLsoHfZFCPSfqdETN7ysaWe+JNlSruyz6M94Itbpz8pMvIi+yivPbf/wAcr1PeZ1SlVTCng+F7qcB29Flzy868Zh3U5pt1yPk5EvwiHViCQ591NAQr89omgV0XiQ6gmjrP9ia2dKaEcMXAM5ZJHrpGtRQ2FO+P5ona8fcbJmZJNqZb8QnLo3Y3ROirQrcqj+fOJz0RoW6A/DJdOwIoFfKooQz7RoCiWq9OiA331l6JQ7EvyLHx+bfeyroyozO/PFbr3U5WmzRf379OG/W2n1t3SPsmEm/+ahOL159JV/YESFYHTYpKr5zbz5nagHAIfh3M0tRubngoZWw6xmiSt6Pav5xatjo1qCiNLT5k4fOF71KQ2jo6mKQ5vbATBPeR3KztvNHxtIiQKS9u3iWQQp53h6fXNv6GAeNRjS9mTcNmlqYS9SANNLg3iUNxbQOXpOcQi7zzkizfE1zvm0b4Ta4UEpWaHW88RlXlDBfAzejBLF+hkarUGajiQbCxadkxJV7xGuzsxgm+pdr83XdIDr0kHOVsKh3j0zuBJMP/E46IC+ADpbYZeJeakMCvBYGJgc56gK/oOgH01Cew7T0BXmE/OWtzpVxelKPgL63GHAP4IA3+Mda3oXtH1PvgmjLpTqDBrWtQtMyDYAba+C/gvxCf5D7Cti8TP3HF4wel5Yl3mNCh9aae09eY6zbkrwNzmUEsVNyfNRY+WOS1yTe4EpctP0DnAR1gBDHnk5KR7ctMwI4s2cmqee3oLhiXPeOLKJCVVX0EVZ2KU0+NqL9LAyEVKSN+ppkCDsc60pXxUUuTOrnn4rwbtjTdR+ov6k6AYOEswX7khqbPWeeICMv5KsgVhppFNiTicCQfv
 qv2JPhO4
 rLSiOu1tt3qzvVSdF3WIo2pCqf6Jh988H7y0i/26qaTqHZpNbX+W+BGrTUYyHIa7s9L3WukDK9HVtcxu1ls6Nk8pK/JpYuQuxB1ZvEPOUfDKajc4dKUxDWG0sCzTMbl7QSrX1kFuUbYwKbS/OXJuKUBRcF+sLEhaiX6Acv7VaTXbMTq4yCZRMJGiIC3np2wsjmFaaTiCz1v6IHpbixCn3H5vJwa6fw05uOuSaoDi86flXl564XUWlR8XqeOH2ikt1AGfZaOP4+xA452lTGVEF7Gx9jZuUjvarN68aJhXOGAlLcEBCA2O5YbrufUFfNNbPn9gtBZOgTlTdM177LemT8YIAKDrjsYCOYl/jcePSu9gOoQnc2JhoMz+D1yqTZ5/il92j1fergBkiHbS2Xp4Y+ULVQ3TY2yb6vEBROH1ru9umOf5g7glNbDdscdqjzLU9HBnv
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

Fixes: c33d6c06f60f7 ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa3cd44fdaa5b..75a440ebcead6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3807,12 +3807,21 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
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
+	preferred_zone = READ_ONCE(ac->preferred_zoneref->zone);
+	if (!preferred_zone)
+		return NULL;
+
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -3862,7 +3871,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 		if (no_fallback && !defrag_mode && nr_online_nodes > 1 &&
-		    zone != zonelist_zone(ac->preferred_zoneref)) {
+		    zone != preferred_zone) {
 			int local_nid;
 
 			/*
@@ -3870,7 +3879,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			 * fragmenting fallbacks. Locality is more important
 			 * than fragmentation avoidance.
 			 */
-			local_nid = zonelist_node_idx(ac->preferred_zoneref);
+			local_nid = zone_to_nid(preferred_zone);
 			if (zone_to_nid(zone) != local_nid) {
 				alloc_flags &= ~ALLOC_NOFRAGMENT;
 				goto retry;
@@ -3932,7 +3941,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 				goto try_this_zone;
 
 			if (!node_reclaim_enabled() ||
-			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
+			    !zone_allows_reclaim(preferred_zone, zone))
 				continue;
 
 			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
@@ -3945,7 +3954,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 try_this_zone:
-		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
+		page = rmqueue(preferred_zone, zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
@@ -5199,6 +5208,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 {
 	struct page *page;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
@@ -5247,6 +5257,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
+	/* Read once; see get_page_from_freelist(). */
+	preferred_zone = READ_ONCE(ac.preferred_zoneref->zone);
+	if (!preferred_zone)
+		goto failed;
+
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
@@ -5260,8 +5275,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
-		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
+		if (nr_online_nodes > 1 && zone != preferred_zone &&
+		    zone_to_nid(zone) != zone_to_nid(preferred_zone)) {
 			goto failed;
 		}
 
@@ -5269,7 +5284,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
-				zonelist_zone_idx(ac.preferred_zoneref),
+				zone_idx(preferred_zone),
 				alloc_flags, gfp)) {
 			break;
 		}
@@ -5328,7 +5343,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	pcp_spin_unlock(pcp);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	zone_statistics(preferred_zone, zone, nr_account);
 
 out:
 	return nr_populated;
-- 
2.53.0-Meta


