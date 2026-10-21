Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A130660A260A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=jO212KbL
Received: by kanga.kvack.org (Postfix)
	id ED82B6B05AD; Tue, 20 Oct 2026 22:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0156B05AE; Tue, 20 Oct 2026 22:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9ED26B05AF; Tue, 20 Oct 2026 22:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99C176B05AD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9134316041D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:50 +0000 (UTC)
X-FDA: 85345078140.21.098FCA5
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id CFA07C0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jO212KbL;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZzEJG+KuWuKC34TpbwLEcO6lDSRUEVZ4rjGM6mtgtM=;
	b=jqsJVBdShQj7F1r8GIlewCk1EtK8H5fEkl5C2XhuJOpD/4EGXTQgPPKYmLOGyDUZ5Kep8D
	y1++pS4vHyWDhXETlmFnA9qW/jGbTZkjpnuWTjWsso8XVAxl+W67rX9PwH7yUmPHd2EsAT
	9M2IRvM4j0IRtCUULinWS2u6RvX5HIk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jO212KbL;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550388;
	b=nfSzgVzuBCMlQKoDUZ8MGdV76rd7VhWxNTES8ktm/s7fqAEh8mxr4SaYktgqpeFufYu4hk
	Z+cqtxaCafUtddx5z237SqfMcuyKNl0QdDpr+NF9SfGOOYmKMmb9kMnPxmJ9O1aI0S15mZ
	NzMQdmz34rztJEnZBJ3NkizyxFrpXQo=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5364d86f7f0so3176851cf.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550388; x=1793155188; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wZzEJG+KuWuKC34TpbwLEcO6lDSRUEVZ4rjGM6mtgtM=;
        b=jO212KbLKQ7RNxx0i8rwvgPqfVR8DKjsHz10p8gRWEMuELjW1C0MJid8d9XctUqKDl
         hyFwPIaTqakp2OQrlzqj8PNgWvxSI5rBODhJXhVxvTjDCsCcrVoOnRqhTQGwdKp+emkP
         hyaPLrnp11P+cUXOuc++ChqSdHoDt2XOSEermHQjdGFB/dUAt7BWJMyQ5eEL8tsw93Ds
         4Ys64DlxRs7Mji7Mat66ecK9O6rAf/Uuw6sOg5xj7yd3TAXpjkjMJV5CRgJxbYY5EPdF
         /0BHhn/Mlr/vcar0JA70DxS0RgBSjOPMBkp/YqS6MNUBWqe5eaIBtRCrCEXC9WNiuHC8
         3j2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550388; x=1793155188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wZzEJG+KuWuKC34TpbwLEcO6lDSRUEVZ4rjGM6mtgtM=;
        b=Oy+sou/wiY5oxkOuj8HnTP45172jhJwJYYqXK3AXAN1GBDgURX0k8t9ydRyN/DXnKR
         9ZDuZ5Evkx/LZig9QQYdFYwcFnfWRkDAIXpW/YULC+PgrKixWtJkKq/bWcsKw8L2xIVt
         VYOVOPEGvDUgRXp1xlCmu12QqxQyIHfERoRL6eprfI/nSFFkvuQ81MI8FBbHSqBrz74Y
         4+d1fHfwEOhX5U8euLddG648t3xSohtoGBYp6Yji/pORi/5yp7ZAc6JIlPUXE/jxpJio
         CqDdumYXRCtwTLj+KrqGaS/J3rKELcUZkkMnucz3f5VVBMPBLt0id3BnIurtaBt0LRsX
         ddMQ==
X-Gm-Message-State: AFq9FYIkUp39k/aPlZxj9q2lKsF7YEur3shwFh5u84Zl5+Gugd8zHYAW
	n7Xv7er8emLY2io7WpVq5TRchgYHULBZdoyswK0Y/hGTjVJB/8dM4WAff7geLInfT2H433Ui/9Y
	MR/h6
X-Gm-Gg: AYBFou0RK2nFe/M767mZS1PeLTOT9jQeUj93+1dE2jJDPE1jHaFJyk+n9WbjxWOORrQ
	zLtt86sIClSAZ5V+KhA9x8vV0nv+xNOEQXX+VlVpmMz6WyNmnDJ76Lu6DHLsNULvgn8f+HFtE76
	Hc2IOH3mcB+gTeTHHm/8SnJSRaoJ0hbV5aZEeF6CknyQDJyiIb4eV1u8ES/lpbyKadBujo2bgyU
	9yvmehnTTQhti38mTiAsnP3uk2LnUkz6NdPxF+zenxv6MdQzp69s0NXGDqX/kkd5cAhwWLeDO1t
	jxOUkoYI6BQrcCMWaLDqGEje/svWEu53DeOj6FCYmYcOgnIvPdp1ZIwG25cExuynf/EKsfZU+1x
	xP8ZeYHL8IDtwA87Yq2k4VjCR5d200ZSrY6xCcPqTf4ZFK7ylm63aWlaNQQBbItbUygiaeNU4ZR
	J0H2Y5Jc5Q6k24uvVc0Zaw1ibIVtWtI02GjwHKLEDawGbblszC8yX26SwkB4A3YSGPc1qajaw8a
	5Id/TCNXZw/DL99vgvQ8fhBhQUOLCbAsYzkzL7BOl7vj2++RXxOM9xz2EDD5TOmodrAMVzYWhFs
	2eHvsqvFobra34pbJjyC9n2hXDtTMgbq+C3U8GzZ4K3z5A4FefflhN+jBTdwbEo=
X-Received: by 2002:a05:620a:28c8:b0:93b:db80:e0cf with SMTP id af79cd13be357-93f57f4bd53mr204750985a.60.1792550387716;
        Tue, 20 Oct 2026 19:39:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:47 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 2/8] mm/page_alloc: snapshot the preferred zone against shrink rebuilds
Date: Tue, 20 Oct 2026 22:39:34 -0400
Message-ID: <20261021023940.1940971-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFA07C0002
X-Stat-Signature: oksaq4kdigj89fbxiu7jfksmsodnzz4a
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550388-570398
X-HE-Meta: U2FsdGVkX1+Xe0m3BFHe6MEwEN+tvaXcaB/nMZZm9W0SyX7kzb9SZFdy+Ec8cv8UrWUtO6lgavLbQUtMxWABNDf7sHkTTztjJ1si27ukip8/xP73/UpKJ4QhFHTCpjpHZrbdqoau/w40ZOausaorShzot8PrzZfM/GaxRHBk+fhzV6LF6o9tcz0zuyFQJ1SANgNQLOKa8xGBtYZcT0FJjfwVP8wHey8ZFpvZrNtYH4KpdCm+dRG+XiPtfsHJBO1SnG4IQ4Pig15kt6/DIk3RQixyV+wfQVmZ3IdOxDPAmyBVdfZAaVNFJc4mKhzeP0ZAj3LfLmwulqy+ssJmWFi638em5W/dJUodggquFpiUt06dyNE6a2eYT4PSlBLaP+l8Kgm4Y4I9nnKfBcZD7d3H2voVxIl7EkqPs6skJLLdunZ56WxlRVX9xxjG4UjSaQljMv5AS4HBEHQYeJnqfjgYscAQkAN3ZkLo6+ujc0P9E1FXYa8xPuacvs8c3suHY3uMUtd/1AxZHicDu5JJX2fRcxkpPRx19snwkctO+7ndvtU7V+NcZpOJujb61C6/Qk6i7E1c5QTXU0iVLSGMU4fFZWTbE2pk57wpYJTHiBULxH9Fy9pYCFjCOUaQZEBfcG8SY96vMgcER0yDCur1KnR/1+OOlfTXBcnw21zp8BIkx5Ib1dX7i8ezOry3oNTHER9xP3KNpGctkQjU9u3sSZo0HHF9HTIEFH0Q34K1KT5JTeZ8pCNhbFMCL4GdnSh8lSFNOFRqV1OGotuOa0rPaLtW/WURhV9OMjMlsKgAE+/1g05R5Xi320/sWgKJrhAy8MVKrdvuIQ6Z6VHJRopZaFtnyDYd+v9KCtdkQkkKWrMt15VLg+7Px6eL+4SctilILK+QaxBNceNd89WzGykcaGjiaYX90meyhSs8uHdv+hF4YXvFVWXd1zGJyYGL8CNGQHZupr3fKxI9wbO+IUajiDj
 xkVYj67z
 TazKOYCjxrI86QFlN4E8MHehowqCTmIfcmET9vjhVF4GxquxPHBXrQrR6/K5pfrS2suRVJomBb7+9quuR31/SymVO/gmIPm4RgQnqRxVrYD7GQg1dPTYIDVBlrsMxGEPrEUNOF+isrfDEJnDj86ugtxeJdZG2PlP/s55cT1jxBH8zYbzRFvDvKGJA0KckI1CNXI+oob6u217WCOdukYrem1XOCplaAy3AzE/xvQhV7SqYpiUziOFvTiNUJKfmLAdM/FTauI2fGzTgVVcsWgbb6IlEjzHwjF5n8HYOhVXP5wqL24Qy23c7QNbKZNNjU5QhLtFu7Crqjf2hetIWOAiPmGvIHQ7FFP3QRvzDptvDKZbphxM6zy1WJqvPUuzSm9/V60oVixcaaqNND7V+UqDJduM1FDkcGwjcCVcdVJvxJg1g+1hljujzPvR6CEvUYb3T0gUF
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
index c7125f6693574..4cf2982c5b107 100644
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
@@ -5183,6 +5192,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 {
 	struct page *page;
 	struct zone *zone;
+	struct zone *preferred_zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
@@ -5231,6 +5241,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
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
@@ -5241,8 +5256,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
-		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
+		if (nr_online_nodes > 1 && zone != preferred_zone &&
+		    zone_to_nid(zone) != zone_to_nid(preferred_zone)) {
 			goto failed;
 		}
 
@@ -5250,7 +5265,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 retry_this_zone:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
-				zonelist_zone_idx(ac.preferred_zoneref),
+				zone_idx(preferred_zone),
 				alloc_flags, gfp)) {
 			break;
 		}
@@ -5309,7 +5324,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	pcp_spin_unlock(pcp);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	zone_statistics(preferred_zone, zone, nr_account);
 
 out:
 	return nr_populated;
-- 
2.53.0-Meta


