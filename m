Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E7AC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9706B00A0; Wed, 19 Aug 2026 05:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59B16B00A1; Wed, 19 Aug 2026 05:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48846B00A2; Wed, 19 Aug 2026 05:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 883496B00A0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 266E6A2F7D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:11 +0000 (UTC)
X-FDA: 85117555782.20.25A8533
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE59340005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Jgq3Jr3p;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pICFP83t3xFRgZ5Z8POKVzeGGbOgsBvO3I/0k/S2WzI=;
	b=ugQVxZZEWMlv0tCEgllSSX2z/nXlxYXosA1ld7eEecby05J5kGQve/sFyIcBOZ3eYhPyu1
	+rDKjGSGqqW3cuj4MLAIpeFxYDgNKEE6YTrkCIEBPOE1aswTkHOzU4fghyRwrzYI0ig8nC
	XbPNwhZ/6P8Y1Hpo4r33ULxhWk7tcow=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Jgq3Jr3p;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133189;
	b=rZJ5bHDu8fwZkU0uSF6qVSdJaPrkL4sM19ArziIzaYVnIVPI7fXBAb9ZqC9FOB53H/ohpL
	QIee6/iwq3x6N0DafUVxf/5DToNzK1oAWoZxxbMYzlPsTrS6fP31jfbR/+DsaOidwJqKrh
	t/WCp44mD+qT1Mnhr4Fgbo6kMzxAoko=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caced6038eso7247205ad.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133186; x=1787737986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pICFP83t3xFRgZ5Z8POKVzeGGbOgsBvO3I/0k/S2WzI=;
        b=Jgq3Jr3pMt7Ci8gBXfRrHBs/FQNlylC63MiJBtylcQdxi9GNkWTrXCNT4WbUG12kqX
         RSCbljqxG8Bbxn4kwCO7c+kNABW/DgvjBZh0gEgdSZ+bQ/MoytT+OAa7PKlO2IGEMC7i
         2HngXajcLtsHFFUh042CioHq8zflg88y427shKcjQQ0oM8lBsrO8esVCruZX5mwcq1dV
         R3t//ope6jUSVS36m1MOOLzwV74TMZxur0eivhOXgMZ/1At2o3pQC51dovtBId6kNyrX
         QylgZGYX6jaGlRUCz46X4dbUlAwEnBoggpQw8adMqfQeGbb/Zn91XWkFk89BYXzcknPd
         fxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133186; x=1787737986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pICFP83t3xFRgZ5Z8POKVzeGGbOgsBvO3I/0k/S2WzI=;
        b=seOBlVo4i5E1mImHS88XJW1nSezYtIKIyQWoIEVT5OLigMdKVBVeVCpfPoKrPu/pIE
         sBjnE4eXK6++1wE3FplueM2Z2Lz9cc3Dx9fe96aCW3WNgga97S5cc6zuA35p/jLD9+wh
         4k9mMhdUFkWWl5kWm1BoUysZo9X8aC0FjsV9B9vEc8OrZY7j4BUIWuiggzDPPEyNDyor
         4PTQK/ShRtCSeXIHaLEcyxuA+J3NQQd25mDZ0wwf2od7tUANC8gr0J31MrKVY2753TOv
         LSbl5BRa+I7dswrvRfeZIJOJrYgXPEfS053uTpyOyjoVga0Qrfz4y+sNr/DAYBFCJoOd
         mDwg==
X-Forwarded-Encrypted: i=1; AHgh+Rowe9z0sZwsmR5lgtVswLfv06eHcJxyZIZ07i1ViibI7RW3VhC04J/dRTIeHs9aFLqJyuq/ZvuEWQ==@kvack.org
X-Gm-Message-State: AFuF++kUU1zh/Ghw3tW+RUU1upUxXrBQhMMfTUU+Y4rC5/r+Z5l2/nz7
	Pr82Dn7hANxMubighfAz7h/inaQpBLyo58Wtkez01FiPF2Sjyb+6mtTFJeHCb4kgbjg=
X-Gm-Gg: AR+sD11aT7YpJuMjlJ6zRib1sAF9SU0lC+2CZT9oCe+5P41Sx5ukgmyhwcGT3iPGs1j
	YdOK+8Wrv+I9eNhup+GPNGgLQ96E63Gj7Sko4RSGAuNoaCf8ETudOPr+4gMw3kW6zzrGr0ggyjI
	i+wgspRUK9ldMy+FwQv+atzNQkujs/ezILvSi1mC3yGUErd2PfDjVGULnq2e6vliPFKs2HFZJYh
	5p0wt7a6NuZAki41wc7TtUFm8qXXNhHlbC0nRVRKQ9giGDt/hbPSEQS2ObR9iUzpTnPyFz5WE+z
	XtZXo5IDDPDOvqTqqbkUtUvyhLQ0W3iDl6TLT2RIEe6pyQ1JZnP7M+GNWCPs4BAD9dab7vs5j4U
	iLlq2nPrhGBoxNhy9scO0Lyge/d2ehSIZpEypdACvLfAqCiHq64t2k5yAwc03yGxsYCk6yNNW2f
	e0PCwOQyjbWwxvtV3FF7UXVi8aM+H0BJeebd2lDTDxpFlnjElrfWSjvbW0E1sNNGH4wOfHKZ7YI
	vU+L1qYGS7YUwnh2gOOgt2l2g==
X-Received: by 2002:a17:902:da2d:b0:2d3:7122:833 with SMTP id d9443c01a7336-2d5fca53e5dmr41430365ad.15.1787133186380;
        Wed, 19 Aug 2026 02:53:06 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:06 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 02/17] mm/sparse-vmemmap: rename HVO order macros
Date: Wed, 19 Aug 2026 17:51:24 +0800
Message-ID: <20260819095140.17252-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AE59340005
X-Rspamd-Server: rspam07
X-Stat-Signature: rzf3cdjey4sjk4rspfq4obg91t9t5dcr
X-HE-Tag: 1787133187-169100
X-HE-Meta: U2FsdGVkX18iSqf4LQ6PaN5R0mz4AD6Cw1rVMU5yevs1CH/N6412+xmsaXD8e7ZOI5/Z75OM2IksKm03J40qBzeDbSEsqq1+qgrDt6tIULc4hGnnn9sU+i000iRoCzmPfkHpJdn85YIwhvB8h2ycwHZ11NxNW6eIZP/Vf/3sIivi0I58DRPMPkxDqfJmJVM1m6NfsYN0cezwGV7BE1rYmR+h8XBGdKvC2Sw8h5IpzDwhqPWTgmZGxnuIMq+pjpmGa9A7OVM5DVaM3E2C78X8YPTDN/ACBJ/RaR48CalhLk6UID1iiQHPaagaXsTPNQItpNOJuq2FYvNiQ9XQyWLRCN3tOG/4VrlMIeus2BQXLSzZLtovQgozt5x1z1OXANn6/J9yxb8yxmhvuGBk0Ju0pcAV1e1MMwf5qk5xwMvEfnstlK1aA3q7TXO+rYN6q7isAROHsG4ImVdPe2juV2URFyi/Bk/JtQYY/W8sf7n532Cus805qoilws4eWOjXwN2PKLLQPtARqkrRa/QFNKUkhnAv/KXy7CyNqYitde7UGIPCtQffOCx5i/pII2dn8U1QSsuCEWiLssqeHnmXIP6T2auLnLjJAEN//QAHMW6wY4TLDrkcguU3h/o/kB2cFxQAHEGeWUJUjoFfwlDC1g3tGzIOZy1ioDLeZqFuve7ZKJtXtOF6961HMze0ne/LbX5RD3KapHmNBrTLfttEQPWjmKlDkA60XeIvVdK4bNcAfx4ODHtXbx4pl1OsQYrCuCASGDJyci2CNsckHYA0kfyoK1nYZwH0etZdkbCofr8lo8p8wvRc6mL8mzpLAmlXYKHhE+O47EylNHXiZHNR+TPEmVkUNNoIgtheiRrQG03hiOa7Rxid5OJGDS9geOA0SQVwFts0aVW3g1Sd3qL7BtrBpmaNx5oyHFUoM8MbApxEjjey3xnXY4vWCae4UTm4Ex+Wg1bpER44KAAREzm72eq
 OUncjURR
 Po/zMtpwBCJBpVB77Gch1G4baSaW1+q2Cq8B8JS8esXYtiAA/xdf0nwjSlvXKhRGKTeXla2m3nVDiv5cwZCrnv/xKJrH0pi8GntmRojoaoHha6EirL6GEqMMYi75N4gmlzNWPhUg5mzKVnODFUB5qx1OoDAP0t0m2Cn9TD3a51wtr8I86cdGiJ5KaZuJI0T4xLTqbMM1wXdY6hjrEeYe+RwZnjUn/T00uwp2mzFrHHSlxSleOKgvJhAz60Rr7rFmSXatp3PgdPA+Bu36cRUbumefluntMj3H38MQI8gFLKFU7mtADk++TFOcRepTNsC5XQ0KbPjcT5BvzH4atdS9FwoylRT6j/yR013MdkH6/3oB1eSBCpT9sBQSBOmaTlxyUHOByjaDw/c3OSrZxIkGskJbntoyGTkWcXdwO
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
---
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
index c015b6a65894..a018d0da4ca7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3344,7 +3344,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3352,7 +3352,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
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


