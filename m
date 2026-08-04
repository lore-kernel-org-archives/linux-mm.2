Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076FBC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714AF6B0093; Mon,  3 Aug 2026 23:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EBFA6B0095; Mon,  3 Aug 2026 23:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5661A6B0098; Mon,  3 Aug 2026 23:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0F26B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:55:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DC9D16089B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:55 +0000 (UTC)
X-FDA: 85062223470.27.813C713
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6165740007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dTUHtkcK;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqHmNnl5B8M8iecx70lwawtohlkJTRxAzYxhsQadj3M=;
	b=2gYodUiT94CGeI3GxYlB+p2zWaZQ69vcxzvNWqjGVega0VrAs9O3LTn0Zkt8vz1d8AuVgT
	y2FykNZ9XoWF2K0jokjwlrU0ejOOrIDM61rCB9Cyr0he1hJdTlg8HLUggdBaeLvI3q91RU
	X3/GYpiBOlo7VIckzX+1b1yQp0OCiLQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dTUHtkcK;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815753;
	b=p62CUE3lTuO7Dkhce7DtB2pfAtcs4u6A5JQTZjq1IlgWN3gjF82zY4DQq7bvk8L3ItKx7b
	SVhZO4SDL9sVswhzWQG4gskefGtiRuNl8Wsyont1ax5kR208CRLO/maN35vj7Iz2ZYJdtr
	kD6kvbXNbG6z9BSIN6NXdno2LRBVz2E=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2caed617615so56026905ad.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815752; x=1786420552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gqHmNnl5B8M8iecx70lwawtohlkJTRxAzYxhsQadj3M=;
        b=dTUHtkcKKV1Jk5dJCfwmJfYR9Cn5DwVpEm/2wgGDrRzsmuNhy46UM1Am4723tT7HjS
         +hxtqH3BHV+g8f38Abdluzzw1Au0yfBeEgwbJ4PuK7gmH0O8LOkOycxPK21OGt5v95oQ
         28zR01ne9ppTEdq0qRpokGFt8NeEo1O56CvIZdcX6sCGla/9RsTKuzOWWYsjecnRXmk2
         HhT8mQFTnyUnS2cZ3jPCZHx3m/qiP2zHuUoRHN2QxNjDOGcWIabLrb2KT9qLwp1GLa8D
         nGBkbjHzaAB6eSI+FBr43MNyausxBk5iekySfJFhNZe6kXmwx0Hxa0AQbpCHkCHoTclW
         UFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815752; x=1786420552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gqHmNnl5B8M8iecx70lwawtohlkJTRxAzYxhsQadj3M=;
        b=fnFwRUXvD69gh29QcNozVq7WVdEOM1KxEEZ17KD3VwxAwXR7vrVsj/QVB9A+8WnzID
         r8LPTiRoUnvEw0u9WsEz3O4i3SbpsA2e7FoemW6Vks51BAaQADpxspv9aT8l2kg2j4tG
         du4gwbdG7xiVWtiUuDS6cI9pQ1IWZACMXu1bkkp3F2SLUy1FGaGVgCf7QJVI1+z+ZTXt
         l106/Bp7HDtjgeDZY6Nf2fTIxAVKEpkMKcHltP7YPMz0/Unh1PDn5bbZWV+bmHx8A6Ij
         VzyixzBgOFSokAGEPkavXIvcHD0qAgmrxabTWr5Fxzqtx6RfX9NDb4OyNerOF9c0BiZL
         ke9g==
X-Forwarded-Encrypted: i=1; AHgh+RqEk4GyDwtU/Pv//Qh4e4SNGtqAlu47wAUgsWZElRREQknhnDhv6PIzkkurRbPsonyB3+045xroDA==@kvack.org
X-Gm-Message-State: AOJu0YyYPUZ0rqS7WIEobKpnzzq2VR45RlkB56iOjnJOjzZ+ndNt39ik
	LwtTNItRhzyzsd+Z1bMUlrBZsVAaIIhx1hN4jSh8BdSMalaLsOYXSfnrV33XSzpCeGc=
X-Gm-Gg: AR+sD10tW5rFiiCyJcOEeiHFizCpH4vl+C3NRRn0V0ZMn1K4Lbsf5xDAkLaxgXJUUtc
	sStOjh9sBsNaKPwbelw3grDILTU3FN+MaD/EsU8HY4mD2iVB4Dp5DebruJl0fXHYzOopg/aO2eQ
	ZDFnu23niOQUOCxHA6sv0s0GR09G5b5llehJ6fGBFZIF0l5KaVCVrREVIYyq5rN21OUm9glDMVh
	ylbe7hXM9gupjpuvq1m+tOexf7zL7H/0Sk7BWZnDxY5VQdvHyI0UDTJswoJ5yEmvBe7Vh9KB9Y9
	nJqDN2TM36cbB3IoW/+hXjYgwgSjiQ/sX/Cd0Rl7f0gnS1U+Fg3WGEfIC0rKZB9Fg2l9M2iDUkx
	Qskoao5TAEFLtcPnRMoKCG8CnVKNZO0j4U5h4JSqAVL0htURTC0ZMP/nCxdFETIxwDgkpxFFTjP
	IKxnILsC/73g4NgF6HHa2by2FqZzuXXOSXwzuxB1WfZFeANXTT4M47YiN7iIaEc1Za7+l7UQvLR
	2O8tDxd
X-Received: by 2002:a17:903:2f4b:b0:2ca:ec6f:aeca with SMTP id d9443c01a7336-2d0521bcb22mr129595065ad.8.1785815752030;
        Mon, 03 Aug 2026 20:55:52 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:55:51 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 02/17] mm/sparse-vmemmap: rename HVO order macros
Date: Tue,  4 Aug 2026 11:55:20 +0800
Message-ID: <20260804035535.2846016-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6165740007
X-Stat-Signature: 8n4yjs8cndrbmwu5oobfcxouit4dgu7a
X-HE-Tag: 1785815753-568994
X-HE-Meta: U2FsdGVkX1/g34Ydx2nxpfGgkbiB/BoaPp0iJZuX/7vgtARqTdxMTotxGzFs0gLY/b++T8ge4BNDDNwGM5jSVjd1LuUwU5aXIljQYMU/Luc0B5g1GU93zPF3/czi3SxF5AmGXHarFCVgDHzJ5ldiYUifkhYiZDyFibYFEBDJS9KQCFiBzfQ1pyTfgFtsYMxsAUHTcdgXQxbxtalKGFXvs3kUXm5wS2GKui0C7IpKK1RdhSbad7DpoyRN6Xd2Hnzv2V4tWlLJKWv2eGLNhtHRStZiFOhS+AtkZgiPcXD9iwSrsfq8boJyFlISEA9croUtU71D/I3JMbwZLOAFs/B2Y/q9VF1hXHIosy4xYjNjQwCRqL72mvh39s6PycLFDk/+YMTCuEHlQ5VEKXv6aNSARjDYKddlKhIpjLoSalhi9zq/HhG49+bORbYicte/m0ewAJVXMMVQCObHpElUKeBvO7Q2FqO4IRZEoZtITtbzfhxy6Xdcy4HQ8rJ3hGjD6JMnSpHI3vmGR+dT6mErH2F1CVRGXUSd1bDQ+2q6g0sSRrbd7li/+PyBQubFSYvX3RGNmNvaZQLYD4YI7SxjsjFjxVoDg9osQ6Gp6FNAh5gu31sHARE4InUNbH0yrUjypkMfnqRtmjDCiAW8ZmT1S29FSbLat/ZDlUjLJNBUI1Hy2n2Y3OjWVngffqi+gAkC3JprFOerPCn6LZKH45sUyawKsd9fYPxbrgOCl7mPiZAhZ6tzLRZjjz+8JnRM/jkcD8yRn11RA+fw8c3o6gGhiMd0LS4Z9Q9du53N2nwJ5205/FHqh+SwFp94IoyWx+8IjGVPfo63VhLg5oCCqKXfF8R3WTDyDH6lBX7zqGAUyR74Rdxft7EOIyVtqAGC8Ayji8Eg36rLccNA6/s8SSbdNwZ0qrDxx6+gnTS+RsTo0ns9sr3WkOrkoPr1BgsiwdbEW5WUSdpi7rtIbHH00YQhgaP
 0c5sNfHY
 LnAyEkbQRDQHywzPrQTouySGGF4iRYv3H+ZImBa5gtUSIvFeixqK80PF777nd9/ihmk2ROOEXKnRu8jJKFQbnBMhPzhOw6HZGgqYEHd7bgyv5amwUNgkRYJEVxOiVv7xfoYATXp/pfjMZ+FTKw6S1IjAaUDuNBRzXSDcCDfN2stklikwuY7hOSCAZ9iCRVto43lCncsvDkitT7QEOK2qcP1y4DjQgNsQsWIT+mF1ZYmLje7c1tE4VQddXw1jaAazkJOvxD4QFfPva/iiI+dyxBjD5nFAGjWtqDgPDnvnOQfjZigkv2gydkufTpIfVjPk0QykoUTeOL9iewGnSjc0wDY8mbde8a6p/OO6yzLN7uyIyIYDgmt6pHxcjqLgaUYDFYdAuEgDjqOfUSgif3+zvbMc9NRqZtkvXyg5e
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
index acf02c87900b..f96a45ac558f 100644
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
@@ -1159,7 +1160,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 234218e14c3b..d212bbff4c83 100644
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


