Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2597960A381A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=tBjzYTCa
Received: by kanga.kvack.org (Postfix)
	id 0C73F6B05B5; Wed, 28 Oct 2026 17:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0299E6B05B8; Wed, 28 Oct 2026 17:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B6E6B05B9; Wed, 28 Oct 2026 17:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57176B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2714D1401D1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:40 +0000 (UTC)
X-FDA: 85373301720.27.A90FF64
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5AEE714000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tBjzYTCa;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qDLFGzOABB53SqGvA4E/3rKuoqOq+XmM1bYUdpKmDY=;
	b=ifAfkNDho0ov1iclY+bU+xlq0uKZ5j6w+UJ+dduaUnoCfByrpGA5HinnIJ8hpH0Agc58Pl
	k3u45teCHeASAj7x5smdMhUCluOfOt2NdGP/c93TRybIzUc3cmZ8v8mPxz888t/RGUI06M
	x5TlvHrJ1mrqeWiuwH+U8iSFAzhin2E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tBjzYTCa;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222378;
	b=YT2oT6HFEySw+f2BWDuxfkLfqmp2jIu2ur9bofh468usIcpnNkgUzsGz5Fq7UmARx2MfI8
	yIbK6DZXLbAS5RwlR1jpZfBmEIAUfth7qIBzaxkforiqCvd4NhIcE1bqEcxsxjMpNLIxNF
	QZdhTbcG1CLw7wvD8rQQCJnzkzoLpqw=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91c76540d0bso16178766d6.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222377; x=1793827177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1qDLFGzOABB53SqGvA4E/3rKuoqOq+XmM1bYUdpKmDY=;
        b=tBjzYTCado9KYTfmG3lGZObzAl3EzhIwLrSWy6OH1hoSmGPxPBzzwnemxW55zW+GPD
         2DEjuNt25CKO8klaFOj+6vEklYZO3yrzX6TC2OMNSBvYNJEVil4Gool/e1m69maMDQr/
         JuvlHM8RAy6Uaf0O0dRLySfEm4ssQ1z229OrawHYfo7cXYEtU6947RHJMk/wAfArZJWa
         bGWm2vjMLOFNalLtoqUN9nbsqRVUm/Eh2T16MR+4bejGtKwEbAzib2HZZ9hOYbvQng9z
         CUo3mEPtL57k7yLBn7KuEwaUcw6p9/r1pBr4bBjHQ246zRFRe+4uprUzs4iGU17crpxu
         gBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222377; x=1793827177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1qDLFGzOABB53SqGvA4E/3rKuoqOq+XmM1bYUdpKmDY=;
        b=OSsll7J67zwS7w0CFjNZlWCziV8KanFgXQ/28m07PPKfsPVryEYNTgzbzOf6PUAb4q
         hZWP5+efgWsc2LcyCZCgzlP3OF6xg4FZQakgruA7uqaDI5FqkJaGP4iGRDeC/sMknO5u
         d3NfmlelBVERpxL+0wWPHHxchwvgy+dOmKnNGoOjCFGNri674pbZBJLB+aO89GEvAd8i
         d9ExWnqe3sIA1bm1QXRInpZXL0FiSa9VMkwmFgTIvt0WG74dlppB41hSbbsYcMfsoKGc
         nYOUqgqxsPvyaCJJpGAiSqrwENm2hef6t2NXZRt0tmT/WgDerD1TWAoXsw0dyTL4jMBW
         c3xQ==
X-Gm-Message-State: AFq9FYKlDmbULc9dPPTNffK3/yXe/9cTfL6iD6xQaymRrsmeStool5YX
	uqyDxrxAkkp5YjMnCAyvvcXZT7mi+qHe0AdRvVAHjXhrqQeJq+TGi9AHXv7cra85F6Mncwo6gES
	aUBUst9Y=
X-Gm-Gg: AYBFou3Jby+dKLdkWQl2cSY6/G5RyL8T7rYtHlxX+rf/5c0qsZhpxSu6DOnMLdVwxct
	zbdqnHx8sANoDJ9IEm7n3GcGdp0u0kXXbJM5vDQ2A9WTf/yW7whWuKwEKMag9VIRfSJP31TsbsL
	D2kIssU6FPlk7WT3uAQOKXq6BDb+Ep0aWdjrx1HX8SikG1gNAX5EvDuvTXrdPcaJ99tFFDPkxvg
	Tbg3a/uJhTSP12pe1X/b5wM0qHDYSMvuDdVCzHfPdS1yh/p1bUoK/5XOJ6H4/PUpiqwVcKFOphw
	/ayHGlR50MeFojmk+gRTYT/MKYVE1TC4reJGC8VmX108oAFUMYA9PGGBaAOEjrHTB4JBKKjmo83
	b62PbVc/y4/SiQpvjNHnRQ2AxKjBvafrUHhmdOVsDhf+ByC/BnO7n8v/VVLNNKp21FFOUKFo0Xq
	5f3N8iuw4DMC+oMMVGy/X3iGfXkIy8Kw0zWb6/wdJulo0DbwfO4jxGJLfuhnM1AZQ6dST8Cvq/j
	/2mLfmIEfoqiDzcxFK3jPoTvwVt4BCmrYPHh+nbTgOADs/CLa2CISmeE9RyGo3OX7H/puwENuRF
	AW0zc5GnNPst25CrQi77AcNM+/HTs2dBL7+ldNSgG2UL0uiI9cAOI8dARhN+wAlmEyCHJc6lNSa
	f1obLzHGFafQXV2s=
X-Received: by 2002:a05:620a:3183:b0:93f:3646:7a57 with SMTP id af79cd13be357-94408cfbb47mr549993085a.57.1793222377269;
        Wed, 28 Oct 2026 14:19:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:36 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 3/8] mm/page_alloc: snapshot the preferred zone against shrink rebuilds
Date: Wed, 28 Oct 2026 17:19:25 -0400
Message-ID: <20261028211930.3504634-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5AEE714000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: yka3fd5nk4sekshwjyfqcuq735fi1wgq
X-HE-Tag: 1793222378-863127
X-HE-Meta: U2FsdGVkX1/l50YQuRw9KBdVNW+6vOcfSxDH0JO8VSN6+DUUKgV24YL0l8EqN1JfMuVTwnGPpGsgPLYzZ3yj8qptNoaFbxKygt8YmPEyW926ZB0ntCMwY5NJ4lH03m6gdb6T46+G0158R/fuHDDFoAZThWT7a08DtyV2Pvd4To7NQHiruzqZSoTnPwt1Ds921U4+wDjyA8/E5Ia7dUH54KrKxu40Y/vl4cgThhHmjsfo0UZvZrM8pf/LdzcTnOdRU3J5wT/KfSYFcKJVpuEzOaEjpWEUSrsbgoZxFYcJbWD3wNIGvGDMm7F9flRKHbL/NvrgWLGojoIlSkPwyy5ffzA/vOcBJMf8DqXI7xvtV+oaUxJYIsA+q2TbKIOZloe3qk1GOwrdnDx5GJBwENm84IblaSSgYl5Zx13aF9W58ptXXuUleHPbTCG5F4eupy0G4SNggoFpz2RNnws9aJuMJGTBJKHyhfaO7tIIa4+w7WnL3rF/sCe8yA26fWbR8ZCYDvLFBdY/gdNNEwW4oWPkQvlEMxe8XBPOlS072iMUX1uOzaqhVt/9C0p7EVosGhZHeIOPUpgxa2N8pmFk9uUFLdJKaeLFId7+rwXmhjDCHFQRfoUxZ05JxoTjp7AfNfJaYqyEIGSema09UijWwBVel4608WYiG+RVQdql3c5XbGPd3UiZZWRmti4z9bGN9348XK8COBL74G5QwHLMUaKmSNLwy+TbMVVQjhnqUkCUoKXbFcZg48KeJKRHPSkhonpk0p772lsAfHJ+ImZnWvAOR74UjxH6urlFigyy38zh3JV3/NmPnFHg4j9/MWaxTbMur9/w2IrfZFkVGA895iR+wagqClv4a++7Bu9rOnd8oTyFskqNkTg5r2k4dPlkUQXmor1mm7ZqsjUKuDPZ79l1rJtazcTuDAzZfpfgIUnzQOUwshbEeFhxs7QC/nSgSaS6u0IxTOFdNymSoHIIMvQ
 7DzXlCSU
 nBz/xfc7WEoRgECIOl3fxUDnDIdIEGPrfBXViVqB8h7sVT2xV9ve1QsoHcfF2o1Z8QX+NkM0Bui0+9EYXS9Mdi6d/YRrR4gEf8w8lXM8LkOzH6OWxxbdnzelHWatv9Ntz1K5ndzIZYL4R6Gv2DFjYnJRO7TdySBa+qGKYhA8u2bBuiRBdDN3AbGBWMQ2QkGlufaW8pk1MY6MiMaYDKQDhLFvmmek/9FFDxHydblZrll5BQyCN2C78GhiklqOhF70e1i5YWo/KFQ5cMrs5SCkIbAwrqVEb66EE997qvX7R6iSg7TYQiuQUXo+VWg0+wId0S0Mv9E/GZIY0FKljVelVX+BNgnMn3+XqSbYeRSSuy4UIZWUlEYm0R9Zf9TwHbeVc6dHb/NB5WQT+5A9WjcNQZ4PBXppnuhUkXrAIRZ9l9DbGdYflfqYyLN3o3FHJpvxbS+2P
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
---
 mm/page_alloc.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 52533992ea16..24106c881ec2 100644
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
+	preferred_zone = READ_ONCE(ac->preferred_zoneref->zone);
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
@@ -5184,6 +5193,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 {
 	struct page *page;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
@@ -5232,6 +5242,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
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
@@ -5242,8 +5257,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
-		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
+		if (nr_online_nodes > 1 && zone != preferred_zone &&
+		    zone_to_nid(zone) != zone_to_nid(preferred_zone)) {
 			goto failed;
 		}
 
@@ -5251,7 +5266,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
-				zonelist_zone_idx(ac.preferred_zoneref),
+				zone_idx(preferred_zone),
 				alloc_flags, gfp)) {
 			break;
 		}
@@ -5310,7 +5325,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	pcp_spin_unlock(pcp);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	zone_statistics(preferred_zone, zone, nr_account);
 
 out:
 	return nr_populated;
-- 
2.56.0


