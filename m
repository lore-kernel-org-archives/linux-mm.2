Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A625FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358106B00A1; Thu, 10 Sep 2026 02:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309556B00A2; Thu, 10 Sep 2026 02:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1829E6B00A3; Thu, 10 Sep 2026 02:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB2256B00A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CB90C041C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:47 +0000 (UTC)
X-FDA: 85196886894.01.6E1FE61
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF0E4160003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Jyc/V5+h";
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EO4Rt3WEu+fPYQITg4bt0hJ4ppm+DADkMZhoEd2TtEM=;
	b=0jeuwl6+ED4xHprR9ke+XXKXYX5qN2ModqwUaijBo5XXLbdqKRHwnOQYLp7ddlsPbTfweP
	Bx6eRlYQrwgq7SDixJchWhTa9B38r6wryyxLmf6KqX4QsmAChB/eqbRy3UlMMKLn0Ug4jd
	fqsi9KPDfnCzwVrNWPJb15snb7qm6tc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Jyc/V5+h";
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022025;
	b=lV54VLo37sqcPNzPSkadTN/Z8zmqiEhPBlQGvpS0WChVlByWPDzsIRn5Dz3Y8RWQCHfSZs
	iRy4X2ZZ3/SmU9ZT2MUBRklrakM0ElN8SDVA4lW1dkJW/4ABNJiQNWiB4eEt8+Wr1sSR00
	Fvknyz8u6ak0ImEGcDHm6n2BHSyHFTY=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso1622899a12.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022025; x=1789626825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EO4Rt3WEu+fPYQITg4bt0hJ4ppm+DADkMZhoEd2TtEM=;
        b=Jyc/V5+hGSXrpG2a4y3bg2IkdlBNOnnc04KqLEJqBvykHzCPlWlM9cJtBreF1u7Jsw
         +XSB5t7IFzwYudOl8rxobP3HPdYya99yi8GitM6D3AabOmtN4E+P20Dozs6sVW40Zk3j
         XxyES32ya3Krqmzyp0Hc8fd2R5P5lhexlUuYi1lBBceLIugVEiBCf44TWu0wirRIb4kn
         BHLqiB8S81Evs7KiDRJ+dQwmVxzYaD25WiyQtBL5vXY0/YHLxkC+SyGLkhhyAvzrNer3
         g4hd0AAHQJz5F3cPBYim5yoVKZV9OMs363pfuBneO1BGfTeRasE07yWM3iC9ZA8GjPbG
         FoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022025; x=1789626825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EO4Rt3WEu+fPYQITg4bt0hJ4ppm+DADkMZhoEd2TtEM=;
        b=IeGzmsRG9/Oy0tI8qgursji/OdtJB1xn5KXzwSRt/+FC/6nSinSTK67iDziTxv0NZt
         jT+Vzr2UFWG6gqz5cM4mlO8geD6OhTmhlTDM0nKHr88IEAM8rRvbAPyodufumbYC0t0j
         FsJEhsCBJXptfynsPuLEEc0G3/QfiyVrNHuLw6gEPWBrOr/f6U7ZVBmUW4VAvjKhgE3u
         4FHZrj/0SBX5+IFcPWdh+3KI5bOlMV16eUbdPrWOR2ZeNtsNrVYtvtiYVUhZFnUir/br
         U23LlGyMA3POpnSN35nc/dDYP7htfH/n1GK34xEgKBbC+NCeV6n0GSYUfqVL2o2Go1WR
         FUAg==
X-Forwarded-Encrypted: i=1; AKwUvBxYGgI58z0K9Jbmwhfgwr0kk0TDL799V/ec0Z04S3rBy1XcMxfM1f5PxWdb9D4LG1mUCkwLnY/d9g==@kvack.org
X-Gm-Message-State: AFuF++lFFuRDm6mhn33fsclUn8+m9cYyIiMeuVanfSuQbSygTJwQoCLi
	AFNWPrHjsT4C6gzSdrRv225GNIfynGdncWdPGBLGDruSf4QIoaXHy5TTHJ0wHFXGQQ0=
X-Gm-Gg: AYBFou2KiviqjNPDvuAG4WID0Sl9yfcbmIE+ZzuMYsRmvoDDOeEPHAGTT0KS8d2tk8T
	5fW0jCcyapS5USSClcE6LH/Y46oS7WveDNv9WRLV3GxeY9z8/mxwPRx4gEcLrfVjo/5fDW6Arw+
	c7WgM5Qh5cIIkcUhue86XunyLfBcgbuzqMw0SxHeJiwN8Mwi866ZG0z0fku17xzH767IAcqUi2p
	MwT5aqXEqBZbwzgQFXnJ5MZbCgrsptbkaB5FXlZUXnryKIuDIu/4bC34aBmbZSp1lbOhGLi36m2
	yvaQkJq8uc4Zbrd/kyALX8O6172nReoRteBZzez6vV0wE0TDpoUIegHFRQcM94xd87ybbJmVYhk
	QgDKKm/GmiKfZietd/KoWLM+bXD8LHfYIW6QeU0J2+Osd84TQ/X9WG/cGKYuqLAByudZKgqRluk
	o5S3k61kohHrC29ddCDKTfIkBCzzdNcv5590sE15iE8zZWAaXr1/M7CNdsgbUIteXnU6CGqMMsb
	sEtotheKjV0InGbWI2zZMm7wGfjx7jmrFo=
X-Received: by 2002:a17:90b:270b:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39bac13b38dmr17069002a91.2.1789022024575;
        Wed, 09 Sep 2026 23:33:44 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:44 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 06/17] mm/mm_init: factor out pfn_to_zone()
Date: Thu, 10 Sep 2026 14:32:45 +0800
Message-ID: <20260910063256.64386-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF0E4160003
X-Stat-Signature: gm3w888arzb5w5fm3iqsrz5bmzffoaos
X-Rspam-User: 
X-HE-Tag: 1789022025-682779
X-HE-Meta: U2FsdGVkX19/wcZ/oZbW0PXW07YflXKRhEwirmWxX26b4IRTirFCbBIreQDGU3lE+tZBq5CWgdXaINuld9F+1py1lcSHgh/6XyqMFN2f+G+l0Javx+1ctGKxNc4jKvHCW6Yvu+cU+RPz5iH5vprlGQFdCwj1j4SEJl2en8rYP55SvDWNaucW7mjX6OPA5aWmIFxl2PhQ0b+x+7jVQ1CH9k4r0fDCtm1mfg05PV+Gt0/nV2MyQh7Max2lE7XpM0a90TlLe9s9nPGWYgzii2hbgNqEgKbg007vtqsO+go8tinZM6TrEZsrMzIBGmYxBxuxifBM2u9qn/Lb6qQzBATAW3uk5HoqUREnpH7vAzbunzMoYhaFh0PjhfZ6JIUO8hIRg9QCc9PNjBga/GuArZUvMuKb8OcIBu1Oc91D6FAJvk7PZlZjMg9ZoJDeKJwdI3rvY3vrVrYvmaAY00pcw3V6Bisrkh8lu6dQDxAn+j6/QzeFkYGIejx7OVH2QKJ7kZmowjjZymrbQRiwDPtCBtAFF7FhN96Fp146VbnlL9p36Pmq6lOSYZlG9OrS3oztdYQhUT3vGRmTBVHTzw3C7JDhfuqQEnB6nLjQ9fvNi+sOfKPYH2SWWAPB3UVXNFXq/PNUQgteSeqn4aNffR56AOnP/ZKaIzkIPrUi3IKZuLFR4aWgb8Xb3QguKKGXe2kDAtauQ5u8BcgXC/erSh19V0phU0cXOCPHjOQAjQWmEdh3BARmJboO7azeXCdlz6knqTUv9i5/OpWFePj81MjcHiThJg+g4+n4InbOmVFDQJjpiWgFCvZCZ7eHMC6TvGJ5hcB/j0WZqmi65PCP+P85AK6EGpVKxuplbq3iEUXf+LmKrMC5nh+H8+7H5T1hGHvYRNB7m+ZrpScetNxhNU3g7GWnzgeA+GTL+6Qtddrp7oerH3scBaWAw/6Ms70v412lC6uTEr+dljVIwLuH8e5kHIK
 GDc+2ox3
 0joSzjucRdWAvwgCjAIWnBtFt9Lld+QjbZV+pQjJpMyU0X6fOzfdIvleFYvtn/QDk38OpA1Ncz/q+PeYKo5XqUUodeO+Vn5B9PEitokwUaBfoGGoj26rsg9iIB8aYzjxw6axZ6XZCFzBVMSGjECExKuP9URLfEg9dEcTL/tZJE44u9PIyVF+UDvkrjp4QuHb0MoMFoAq1EV5u2Oe1g2LsaN8rkmklbLFD38IjPK633O4KWDR6dh3bzhSGvQYyNsUdiUrr9Etkq4ES5kx3XR/jeKchhmIi0fIoe2knsNmmPaU+LkVBJOqi5MpHSB86B5LRRw6sp6ri0O8bYKBUlUQx4dSG6rkKUgUMZJWRa1AZYBulWDjV3FDCkJzj0U3Iz3wQlxx5AM6SJh8e11xce312A5SlzmXUrYQdQx52i3xwJnZOCRA0NTW5Pm71r/AEGDD9OffMh7HbrsCr+zQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
__init_deferred_page().

Move it to mm_init.c, declare it in mm/mm_init.h, and reuse it from
__init_deferred_page() and HugeTLB early vmemmap initialization instead
of open-coding the zone walk there.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Collect Acked-by from Qi Zheng

v3:
- Fix the commit message to name mm/mm_init.h instead of mm/internal.h
- Collect Acked-by from Mike Rapoport

v2:
- Move this preparatory patch before the sparse-vmemmap optimization
  changes (suggested by Mike Rapoport)
---
 mm/hugetlb_vmemmap.c | 17 ++---------------
 mm/mm_init.c         | 28 ++++++++++++++++++----------
 mm/mm_init.h         |  1 +
 3 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ae8fdaa42118..c48fcea076a5 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "internal.h"
+#include "mm_init.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -744,20 +745,6 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	return true;
 }
 
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -787,7 +774,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		map = pfn_to_page(pfn);
 		start = (unsigned long)map;
 		end = start + hugetlb_vmemmap_size(m->hstate);
-		zone = pfn_to_zone(nid, pfn);
+		zone = pfn_to_zone(pfn, nid);
 
 		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
 					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6655fe696e0f..ee3bd7921768 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -692,6 +692,20 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -750,20 +764,14 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
 
 static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
-	pg_data_t *pgdat = NODE_DATA(nid);
-	int zid;
+	struct zone *zone;
 
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
-
+	zone = pfn_to_zone(pfn, nid);
+	__init_single_page(pfn_to_page(pfn), pfn,
+			   zone ? zone_idx(zone) : MAX_NR_ZONES, nid);
 	if (pageblock_aligned(pfn)) {
 		enum migratetype mt =
 			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 39f75df9be1c..c9fc35e7e9f1 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -39,6 +39,7 @@ void memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		enum meminit_context context,
 		struct vmem_altmap *altmap, int migratetype,
 		bool isolate_pageblock);
+struct zone *pfn_to_zone(unsigned long pfn, int nid);
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
-- 
2.54.0


