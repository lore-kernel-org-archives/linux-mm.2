Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5793BD41169
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66BF6B0096; Thu, 15 Jan 2026 05:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E766B0099; Thu, 15 Jan 2026 05:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9404A6B009B; Thu, 15 Jan 2026 05:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80DE46B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:45:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13E5AB7C20
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:45:06 +0000 (UTC)
X-FDA: 84333865812.06.3F4278C
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 375084000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:45:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lm2WJvf6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768473904; a=rsa-sha256;
	cv=none;
	b=y+9cS5x9ptPRqm19z6C4SGWaFZho5y/ZOq4eRV0Po/mDgFS8NDJ+IpUatY1gFDRlhiYEhZ
	EIn6/JsJXHYrfjEeAK5Em3FZrz8XzzLasxtGNhVHOnqnskplBZe/xyabwc763TKRl9HlrO
	gqpET4s/cANRq888qyt7HJkpr4fz1sI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lm2WJvf6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768473904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLIFIOyWqYN3PmkXuq0N2mr92XQ1neHYGXezRRaTTrs=;
	b=lsj8ZnoA4t9kaGx/aucka1s5gyJyQLp+Ii60Q3ZgiS7OCOy6ckpXqOoCTm46BWBA5xrn3w
	nG/QvKc3q/NFKKztLd/66WqWLKRVkLOXpWNWR4uVoHjX/RN1oZmNcdE9pvVCBk8LsUMAuy
	aEeZd+XyWAPPv1urTqjX08kyR6wmxBM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768473901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLIFIOyWqYN3PmkXuq0N2mr92XQ1neHYGXezRRaTTrs=;
	b=lm2WJvf6qTegKG7MdxdW+Y5SP8hIXdeQ1TjGe2H1Kwj5kc39uQZrjHtOWQv4e8K3dfT320
	jsRwhPHng6BBn02joaa1i31xS8uucFCisjw1TmbIc3KD00CVJzlRaSon8SsP6nhBRr7aIg
	c9lSCwlvLjxaHCPcVEMvm3aIlnCkc2I=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 26/30 fix] mm: mglru: do not call update_lru_size() during reparenting
Date: Thu, 15 Jan 2026 18:44:44 +0800
Message-ID: <20260115104444.85986-1-qi.zheng@linux.dev>
In-Reply-To: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
References: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 375084000C
X-Rspamd-Server: rspam06
X-Stat-Signature: osq9oau1qdp9htmgpiawjpd3h85n99yt
X-Rspam-User: 
X-HE-Tag: 1768473903-354631
X-HE-Meta: U2FsdGVkX19ShebKGDwJ3nZVgSq7E/TkGc7b97MWkCXk8llPRsxY/uxkSMC/Y0KSZWV4BHjgGYsnTjmIThe4bn9FT+6Axn0ZwlOJmvEmI2+5L8FW+qB7KrNCQmZ6fsQVcU8grU/aYs7n3hAm9K7yHz49w2moE7bcxYuSY1sYJ8A2EZkumfga5nRWutFI/p5QmhTEqzUqGcGtXAk88YSK9oHtL++ujSMDCvtz39QXg2oVFkYSoBC3iPds1ObIIPCLVJFpSKrtevG6Jx3VJ0nn3thQPGKYqrGclBdLmntisADrSesYL7z4pV7X2wn1U4G3FAswQm0y+QT23uYZyFI6qXzu8d3FST8ix/zy5jAuzzan6sbRzBHYomgq024zd/yBlVlGV3PAahUNN2A22dyMfxK3i5/CfaleHL4Rq9LMALtkm2GHVMnqsMZTgeBYVRFDxL4FMPrVuSyPxzSSyf/upb2GA4NMHOU/po1LEcDhQOXqvsYanlg6xjV5aPhuZNv9u9xyno4K7P1Vy4IfLivmh8GVzrM/1CNo1ibSJdAhDrgnF+D0PDvLVLNgAuuZ2bCz1T4WoNlpnKzjVR0HbiLCsS2IxgwkJpjGUN58dA11JYG4xLnvZ0rgpBDGcGKcineDmfoaAmV/Rdqd8ZEmxkWblceo3kE0rPM0bFaVK+KcxDqvRi+nlido7Ix7WZCkg9KdHF398TfdYgmvYSCSgYv5OixopPiupjSX04uKYY0ihrf6FdfGDBjmwAZClqeZKgk6Yki8deiCVYkX8sI60hww3/wD+3uuRyTyv04wf/sKscwqeseXOzAhhSJXx6+pIse4tHsmiN1Hc8eL8XCcWWUz3R0YNIre18iGYMaZio6ZeJsNnSXRRMnk11uh3MWcILX2Lm3PHnivxl12HARyvnN8ekliAwEAyBLRJbHpSdT4YHrKspcO0eE5Cd1QuCk2kazSqNBuIL+nCVqtYaPk36T
 /NVE2K2O
 Ofpa8v58wed364DJURa0F8LG4LbQhm72gf1G1pSHMOmU6S1BGxrH6ZGhLlnZrc0kGfpTCZyBOey7+CeSTo8X8gLcyILMVriSLuYXFdeikcgQWTEW81PT1ERF4QEFg09ioN16+iMhzJXyMTLiag+n1UG07eBI4dDIm6smAf/mBDldjh+E1Qbzj+5lFQvB2GpK4ocpbhfLub6GiLNR/1kCAc8VhfzpA2DCLZRcMkeSuHFgk6Y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Only non-hierarchical lruvec_stats->state_local needs to be reparented,
so handle it in reparent_state_local(), and remove the unreasonable
update_lru_size() call in __lru_gen_reparent_memcg().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmscan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 56714f3bc6f88..5e7a32e3cffbc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4544,7 +4544,6 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 				     int zone, int type)
 {
 	struct lru_gen_folio *child_lrugen, *parent_lrugen;
-	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	int i;
 
 	child_lrugen = &child_lruvec->lrugen;
@@ -4553,7 +4552,6 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
 		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
-		int dst_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
 		/* Assuming that child pages are colder than parent pages */
 		list_splice_init(&child_lrugen->folios[gen][type][zone],
@@ -4562,8 +4560,6 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
 		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
 			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
-
-		update_lru_size(parent_lruvec, lru + dst_lru_active, zone, nr_pages);
 	}
 }
 
@@ -4575,15 +4571,21 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		struct lruvec *child_lruvec, *parent_lruvec;
 		int type, zid;
 		struct zone *zone;
+		enum lru_list lru;
 
 		child_lruvec = get_lruvec(memcg, nid);
 		parent_lruvec = get_lruvec(parent, nid);
 
-		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
 			for (type = 0; type < ANON_AND_FILE; type++)
 				__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
-			mem_cgroup_update_lru_size(parent_lruvec, LRU_UNEVICTABLE, zid,
-				mem_cgroup_get_zone_lru_size(child_lruvec, LRU_UNEVICTABLE, zid));
+
+		for_each_lru(lru) {
+			for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+				unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+				mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+			}
 		}
 	}
 }
-- 
2.20.1


