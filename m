Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE150C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177F36B00A2; Tue, 25 Aug 2026 04:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1288D6B00A3; Tue, 25 Aug 2026 04:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017CD6B00A4; Tue, 25 Aug 2026 04:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C18946B00A2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7B838036F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:27 +0000 (UTC)
X-FDA: 85139167974.20.99437FA
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 060F6C000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=P7EVjq8o;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh+RdUPU8gwH1ekKZyjiyjNcRLEH/6mbqsdeji2hvCw=;
	b=1IWMTPb1LVNlP/lKEHlsZH1KC+PZ/+r+D7dOZK6vucplqShrBSdqe0eMXxzFfYO9BprRYL
	jWrsQj7u0P1Vva0OMLCZzMTnJUFoglKRya1RwgD6WTckeimi9HzLRqoPAlLWsqFETc+Cdo
	vzMFC0T9Ysfj09nUIFpadhjDmT7kLzs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647766;
	b=dI0487ZQohe6G7g/cKJPsNAIv8Yx8gyFfBIs3xbvbpYBSnC6Xoxz1TbWwyeuCePvOawkvc
	4JAfkhtSyj2yBMtWOZSz/AzZLgsladC2jCy03hF67UJ3bcEqPlyoJ9CnWh/hHW+tdNxX8a
	08bRU/FZGhhEMghnAS5YGxfy36rFxxg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=P7EVjq8o;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cbedbaba5fdso2688017a12.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647765; x=1788252565; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dh+RdUPU8gwH1ekKZyjiyjNcRLEH/6mbqsdeji2hvCw=;
        b=P7EVjq8opc53pvGsNiigU5N+d2jcuD8+/RXuPp6Pl8IrlroWsZQRM5yg7eOa+SAB49
         S3hznIrruxRo4PGeTmaPdXWqsEBNi92XqHHr8f5+QfNkNFbitFol3l0X6kvKNvzkcYHe
         THBZHespluPc+MqMpf2+iTw8ehRXqh8l1I4qzeWo+PIYRmy3p+mjMB0YR35zFeho9dOn
         u3W0Gd+szrKqCRbG00Uk85I8c3D6efrwgHROQLYJ/x715dWGRaxqeGm16lqcH2GGT9IG
         TL7vub+BLJYtkbH1Fa9bNwFDYIwnsjCYjSY0EfBmukzcXNdR2V5OnUgmN1OGG0L3Brem
         UCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647765; x=1788252565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dh+RdUPU8gwH1ekKZyjiyjNcRLEH/6mbqsdeji2hvCw=;
        b=opVQav97QL6oEyoWMaEcjigvzuBOPN1B3lmAC7CS/czzKl9pUOJB+XJPWI8g2fCHSL
         YAieTmJvCEMmXeQGcH9sgAMaMwkTAgk0dX8YXH8NYEh2qCyN4I+BQD0PkvMiURdrKDn8
         j5xLcavYI6EGlRLwMFyRk9n4pfIGJVcvKMIfN8cDyTTNXh3Bds3ckKa716rIyDvcKmcO
         P1RbMqioz/uQHvwiuMNbGGMdF22lfxo8+x52Yk6c6tx+tVQvwNqNq6AOCa7mrbWOLn1i
         IL6PamD90fyKgn2LZDujRtdnK0/g+P+pAu/lnakjnbiwZz5f7+lxf+Lta3doCAuohUbT
         aVjA==
X-Forwarded-Encrypted: i=1; AHgh+RrQ0E91dp7dBnVP15U9ZwQqnQgH1g+KWFCZgLW1QV4JuDeYRr/Hi3Z4qoBRFr5sdiru1q7v97uqwQ==@kvack.org
X-Gm-Message-State: AFuF++mmUo6hptlNzQxpgSLKYFIXSPYwGjYG+yVjI3+5bVgQckz2sD2E
	DJmQNw47APLwITeVYq8VfarFaoVhasEE+FFQvCz0HPrNw4sj4nM8V8Pa3aQkeaslhjQ=
X-Gm-Gg: AR+sD12rEpWjid9cScHrCGF23y5ZYfcV1N1HRbkkbY+zCQrThNI8q+EJlkYDjE5MY0W
	H8icWTvImHxKmM3/wVJZKDCrGH7Q4M5TAsVfg8qtyDElkJRZCevebGgw1MGi3DBKq0Oen2FgQzJ
	rLSRwMUFMzhBp0VUZ+yycuU72KltUiUDgYSb91Psxx4I6ltp9e65kfxREutKoHnFMHleHzT86y0
	mNqHxvx6mMndIQU2gHLnhhi9bwIhVlg4mDtofPo8tRjwchJxknrQ7wVLgQWf7pE2FW19aTiUY9z
	yuFYaRrfbjQnjMjye1FmfZwWyoWa0HUU4xsW09ow/rIzM4vd4aE1vWUlODWiWzS946BAiRdKlqu
	GsmrnIRsWbfhFGh4Q/HcRw5oDOOK202b7WDUrtlTGu/wVPb6i5laSqaGWVSvYZMYvt2CFF+ldS+
	+8oyva42Wa8DdsaX1GMhvssucDuTkku+ldSy868GMPTNennGqlY/0G05kWJ3Flu6gGzTbrAGvSJ
	S5/jXAx0o8WV00Bb1zPH8BUuw==
X-Received: by 2002:a17:90a:e7c5:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-395c34f47cbmr55313227a91.8.1787647764791;
        Tue, 25 Aug 2026 01:49:24 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:24 -0700 (PDT)
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
Subject: [PATCH v5 06/17] mm/mm_init: factor out pfn_to_zone()
Date: Tue, 25 Aug 2026 16:45:57 +0800
Message-ID: <20260825084608.47437-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hzdycg5hhruwd9dxjjiiysbr778o3xzw
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 060F6C000B
X-HE-Tag: 1787647765-866616
X-HE-Meta: U2FsdGVkX1+6G6Eu4iLmPADXyILWCKPu8XgUY1xY1PjoXL8+IYxG7914KpB8KyfaXmlg7VEBMr6AqyvsZvHvcKCc0FTwnX9B8a2hYyzjra5jTtsNKhK/fqDjqZKCvNe+9gH45EAXdPbNuDgjfqPgcRrAsIAi1ZdHuVnP/krMyN+OBTQnj/zNJmA3OdJE2vOtCEsws70egcjXEEGEIFvywyFc4YjUGtITkIE3VZnSt9XyG24OKfjM3okYy0+RY0K3Q4SLYtgAWNzmJZH2Lwkb4YywPFdbPBHHRTkZ9Zud1/s2awRkloH/MZkHf2WWTwNPM4qJcGS7QCLrhP/C1Z7P1diFWWCi1SHYE2RxksXwLXkN11V6ps1+8iQlb+8uBc67E73RYmmT1YqeTfUqu0D48c1BzUhPO95LNUzZVnsYxkHfwDs7iADbfpeAQPBpRumsTSEAG/JEtca4OyZn/WyI1gfNvmVXoeQxNuQnRr/rEqTDVErJM/8/AuXCxgqxgM6LZuvwHuDM7Owx1oTDXTsLgN+XZgRoVNt37ABJ33ZZEn9OhMMPlpUk+qV8l09bDvBkIr9v9Hcf2gY1g1h1DrmeXzZHWa8DVxoyONAJKsiJDFhIdxj8W4mNk6HZ5+0znoMBuowlGZ4p58Gp0NspV+r9Ou9XS8eX2tFx9i3hJqPlNADIKhr7oiOpsISidlV2TdROPS/kU39/85Ld582QBDlEBl6VdRVUpIivjb2YTtd4K4RHwx/Yb4Ilv0Db7w2MT6EmudKRR6fpHPCIad0NR+h7EVA+H7wxFquTVEeFGfeWzoTyzfMz831bYvuh9B2w1OMIgqz6GIVf6MHs8be93jeJa91RuTYCwauUbfj8ZyW8OY+GP5SY4u61HMdYuHQfzjn6pNRERWYN8/Rbde/FPMPed35sL+TPe3MfVhTv5hMK6xI5LTO6oyZ2+sV1eMviwejre3fR4huCOzN1PpySAjn
 w/HRg9V/
 +bidtmdGhlT8bU7zrqbUiPXlzFXsBEZZPakBmxrfi78ncpnqd58D7XbbaeuGJFy93pc/zKJXvV9Oi3v+FyxQpzKWTxZfHfC4lDfwixsLTCHe2PY7HQSLgvHY7t06kv9sY1LOvv1A4C6ZRAiOeJF6sLLu59wCFdeLiBsyk6KFhlAtOo9Q2MzuZzwN6MX1eeA8ZZByyhYyLtgGCfo9FA/RdZ6PP7MUs76vSY0eLZflY4pw6bj7wNpCoztq8D9/ojIwqkp7rsxW/F39XHZ8u/6dgPaxqqPifXK+6AznJbvSCRHbrxnb3KIWGVYj5gHY0N+2yNvlSPqHxj9wuwpARf4omf/JbGpKyjMkRsvssObe0GFEkCqNngFvFPnM896xhn9/J14n7BC+NkOw1U1Q1PV1vuhRplIdi++plzk/7rC8g1j/CuOsj5o8tjR0X68EM9zqC2RIS8dACGk7f+Yk=
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
---
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
index f801fd486085..0317fb781e77 100644
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


