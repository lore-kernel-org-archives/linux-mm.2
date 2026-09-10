Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A60EC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79C8B6B009D; Thu, 10 Sep 2026 02:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D406B009E; Thu, 10 Sep 2026 02:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689B86B009F; Thu, 10 Sep 2026 02:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401036B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F55D14043B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:32 +0000 (UTC)
X-FDA: 85196886264.08.43AE77A
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 623E1A000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="H/1fKTU/";
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wagISQ9d+CnFEjK/rivKR4J4aGNpnRPBrTqRitnWimk=;
	b=AELd9BqtA11WTr2gigTqKvG5ICe50+b8TEuvdkCd5APnJtfed5cBJNpGCpkc1l3ai2M8Nj
	ZiDHl8CEn05hu5xlSZzxAWBNDClpIaJYtLni72yIsqgX3Z3w2rYuVhVOz1hPvwuAO4/YJb
	xHsobrMzQmixpeFYPE0O39/Bap6mUAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022010;
	b=wVPeq3/EPklaHNmk4MAizzLFNLM+QMNyEyxO/EitdOzeKKrS9n/hc08vR8EsxEniWI3IFc
	hLQP46OiNlJpTV5NGcQpYJqMMMbnIjyC9XpdlY/+PnNhmQLXDNWIQBawtb7u+KIGwObNSg
	42Wn9TaIfHFm5bEcBNIxp4na4I5RI0Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="H/1fKTU/";
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d91ded8174so56588425ad.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022009; x=1789626809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wagISQ9d+CnFEjK/rivKR4J4aGNpnRPBrTqRitnWimk=;
        b=H/1fKTU/Myy24Nwf585ydpQh1eJgejD2s71GOMuuWZVbAOHD3/sW0v9ppgmQ9yscuB
         jCDzCojhBOF2zkQAM+4pDyhd4D7QiruimDHJWcU7QtvG2WWZHoIDllmZjU5pR0Di0U/S
         +L3F3jX9N+x2gtvTWNMG0jTqLOW43AV5rYNVoN3xa8mMfuYnkNbJmWLptlyfD0/oJ467
         ChV6C2B9c8VkCrcUH71lN7YlTg2OZrJWdvLF2TF5b2xm8hZ3fgEEagklBfJm10nbAgGw
         rHhv8FIDmpUxFBP4WNxyoGpQ7jMBjjSyQISHITbdAwOm3LQj9iAKkm/E13cz/dexRkQG
         b6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022009; x=1789626809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wagISQ9d+CnFEjK/rivKR4J4aGNpnRPBrTqRitnWimk=;
        b=qP1lP7b/oeiF3IujxoCP8cO4SE+9HKKh/yu/m0xdCG3zDkG1CsBR8ND2UrKk2c3YKv
         4YQrF4pto8PUbdPIXwvqvmszT24WDuzH/XrO78AV5h7f+qyr1lZjph0n7Rys5dOrSR6h
         tWLF+Cuh2yJs6eOAEXMPqDqBxsM55btcfuE1sF6+/pVBSV9ZaV7JmscQB/osttHEsya5
         MbG693m1gVu6vAjKdR3+kDSxCTKmAaXO0rC0TUijQkYVAWp1otvpo3/noSyJiA/C8Dwh
         MDIZD+m74oq2tKs3f1P7LCAOI51hQ+xbb1hcWfl+/HizDt3Pr8ygaOGZFPfngK0HfF/V
         Bh7A==
X-Forwarded-Encrypted: i=1; AKwUvBxPbu5SEziDHpaKcPdHRxmJP+EQhtdKbFMIgB2Tj0z8gc4R4QdVzBukGdKI6/+tDj0L4r9xwbPneg==@kvack.org
X-Gm-Message-State: AFuF++nZFgOhfcATZYOkrZicv+uKEENcLa4cLDXAtcEFsEfUsWF9aYM4
	H5wN5MX59N9Yzw6eqrsEpoLTZbDCGGkfI/O7Hiv2SO8aewUHs0OJhRbjVChTsFw84sY=
X-Gm-Gg: AYBFou1VXxLKvbsqvPOt2mjnRdZNktBSR1YlBzUlGixb62cXJJdwtmY7DcR3aMhQ13h
	nfzfxMgW1ksQ689gW1SB0l6EDkd+XExvXCdJjQu6jMvZzhl0gidKwY9x8hMx7gDENHdbhz4b4dc
	9VSaWgZ++t7hgsN8MiZuXKroBfwssdwl/mxRKKeQm979PHNc9l5yuNMG/u8nBtPeR6Ssow8JzuW
	888G/VxDXdMgoRJGbVuvJfAWleW3tyobwcgwGk1unpqHelWxJngMgangCyMEpY1tifCE0gPavPi
	NqQKFxNByvOxKvGLZe/3L2znjGsdhIJ1FZyBHBmHMDpS1QprEHtkopeYI6YvP4AdXKRmmbA8Hif
	ZkMfjvjv0opkyyhYRVLB4KRctIq4ZUxujG7fZbJ0GDgHBvI9hK4/J8rNC2VTzLdkseI3lrrMfi8
	Ze8wxqumEpE1MxUbKU8z4U2G0rQDBIXdMBW8jSXJz4+/NvVvZvFUEktGV0rvjeQLq2V0jcY15VE
	PWsZm1z3ae7Uq8QBvO6iX8HetXaAG9C6qeP
X-Received: by 2002:a17:90b:264e:b0:398:9bd1:3215 with SMTP id 98e67ed59e1d1-39b262e28cdmr63381387a91.22.1789022008789;
        Wed, 09 Sep 2026 23:33:28 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:28 -0700 (PDT)
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
Subject: [PATCH v6 02/17] mm/sparse-vmemmap: rename HVO order macros
Date: Thu, 10 Sep 2026 14:32:41 +0800
Message-ID: <20260910063256.64386-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 623E1A000A
X-Stat-Signature: cferuetmuc7gtnygns5foxg6otrpbptu
X-Rspam-User: 
X-HE-Tag: 1789022010-536792
X-HE-Meta: U2FsdGVkX1+OybYpv+l3Blcy2zGgFBcVHCb3RibnUTBdS7WZ69CXih76CbyyXVzXwMTz68sIpQjxvtNzn6cLzwflEfJCatCMyEwY/v8gVRPnQJfAyNMmaUBIVKg8AZAbZM1Px2sXhkKNzC8wqUufC2qyBmg3/Of7HvPnnBc7ZGf7jNrZOnNG2/YThn7dj3bjtBrarL81iY7IHDo1rBgdQ5wV+m62XYmhYIuZjHwO5TtoDjJLd5pUMPqhrCNiSFfmI+YgpLu9lCA8wTf18L1gnHK5WtjYkArkFW8tpkIGldPMmtaDljnxWV3gdWzN59SOSlHtoIZe3h9Yl47fxsMXP8QiqrQxUnJ/Gq1YupFAbmrsLk/r/dBCT5x8L7/ZoBCi1BCqKdqt4PETl4ydz0Aepnm3r0iUbhsgMtvFIn8qQo+evszNIL79p/8/9dj/gJMpJMZOtZ5Oe7gk4GSclKvie9ENQO8jXcpb242gTGgqVxJNvpxh1BK2zeSEO61djCHSj0bgQx89Pv2l8aFSX4WA4fMyZkrcaLutjR6VDED2M6M3QJCZ43pr5k4uS7X2iMcQjFn05WU0LROyoHiaR3bJPn3YJVkOOhZqyELLmYjjjlBypLkYNGAB1bhfF5vA0tRK+5IHoGxEqeK8V5dulqrMiaYXmHYxL1+P1R2BXq8254NgetX0uJ8YYZdzEeteTkGSgIqbVHrs/qa/WokqhU3zOmtC0TnpDo+8rcph7ulGeM7o3mvRNT/an0kW3IVnDwzl8U2WVp65yjt6qblXu94a4vBLRsoEc0CEvxOvVCQ6IWx45DPPlTHlAQVzsA4Y2hW2BlbvlUVDXo65H3S5ILsrRVcZNFbK4Iz5LL+XSqgPVnUdrS4jwf2Im1atGC34X21R6UsYYLcWtm/Adc1aDYHIgSnCuvwrnT9H6eoWkw63WsYRR22dqzzx8U8Iv/MH5kBpQmxNbLfLket7GjL09tI
 +sIKAkfR
 KPKlcRouLK0dVShz+PhsliY5bw3KmsxUUnwBrasa/0ZOKdav2VvLPnmN1T36rpfWfljXB9Wx8A0lnOtLsKEZEyBd5I4+NPfsAy2vkK79cKh8u/TpJc05uBZ4Ta65a1QpYIa8GZPPP14zHrrIsd8rAX/ufliKI9TBWxUb5QO6YmmRq3qVUjbIGuBXud3rzBFMdI/slScwxnyS/u0JwS+QF5xSkIK7iB+dXOMO4B9WR6ry2wpV/tSJqmRvbDrWp1zG4qvBQF0zci8fMVTeREq9ZA166QlNE7NTFu8yPpvtmlHTreJllTyV8YuhsVsR02Ou4f73MGzbVROy/0g0jRZUsOw8dfc9Uks/tOsHl3LF5F+D848sLLEakiacWWHKkKZV6jfWLPIB3sz4zinhvbp2DN6M7Y+MaIqIoiwJk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the
order range where HVO can be applied, but their names tie that range to
the tail-page cache implementation.

Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
the HVO paths. This makes the code describe the optimization requirements
rather than the tail-page cache implementation detail.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Collect Acked-by from Qi Zheng

v3:
- Collect Acked-by from Mike Rapoport

v2:
- Rename the macros with a VMEMMAP_OPTIMIZATION prefix (suggested by
  Mike Rapoport)
- Drop intermediate optimized-folio size macros (suggested by Mike
  Rapoport)
---
 include/linux/mmzone.h | 17 +++++++++--------
 mm/hugetlb.c           |  4 ++--
 mm/hugetlb_vmemmap.c   |  2 +-
 mm/sparse-vmemmap.c    |  4 ++--
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0a2428714108..5fb9b37819d5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,13 +107,14 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/*
- * vmemmap optimization (like HVO) is only possible for page orders that fill
- * two or more pages with struct pages.
- */
-#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
-#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
-#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
+
+#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
+	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
+	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1158,7 +1159,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 46b6703bac4e..003cfac98f14 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3368,7 +3368,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3376,7 +3376,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
 			if (!tail)
 				continue;
 
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
 			p = page_to_virt(tail);
 			/*
 			 * prep_and_add_bootmem_folios() can access pageblock
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 917db0984143..ae8fdaa42118 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -494,7 +494,7 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	struct page *tail, *p;
 	int node = zone_to_nid(zone);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5a2469fb1838..aa6a4a2fae98 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -329,12 +329,12 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	unsigned int idx;
 	int node = zone_to_nid(zone);
 
-	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
 		return NULL;
 	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
 		return NULL;
 
-	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-- 
2.54.0


