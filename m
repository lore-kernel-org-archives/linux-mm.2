Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDF2C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E076B0096; Tue, 25 Aug 2026 04:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CEC6B009F; Tue, 25 Aug 2026 04:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97546B00A0; Tue, 25 Aug 2026 04:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC1AD6B009E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D5991A0370
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:13 +0000 (UTC)
X-FDA: 85139167386.25.FFA5FBB
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9BFF12000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZDAi0Rs0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SREjF1UBBXv2gv7dXR/21RVjzi8BP52PTZ7zJ8g1H34=;
	b=kQ5IkBRAv4y0aHu2dPWPezOOsoTTJEVhUD9QpRVANjatA23GVVzwcrBiihIN8q3Eo3vmwj
	vsMaq+VboTvlqx41qjjqMU/IS83GiCUe4spsiUYBm3qqWCXquKUvRGCV25FoIhyysmYXf/
	yORkUhLV2eiekWvi+O0nfQ/2ncJx8EA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZDAi0Rs0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647750;
	b=enJ0oAxGgDt5e8dxORjuDj3tcpG1A3DTO43OHwCNkLRje+X2sdz/tFSVRAhWLoEmCKVROL
	jbVpEiwNJ/oLyzQpKfqj5Dtg4L6xy2Ghzp4OHoyBgGN3tJvDuXkXHTInUb/W4SybhJgFhM
	R820YxeugmX2l2v9HPM5cc2avb+1Q9Q=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so4616192a12.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647749; x=1788252549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SREjF1UBBXv2gv7dXR/21RVjzi8BP52PTZ7zJ8g1H34=;
        b=ZDAi0Rs00k+NG3rGE6mZWIXDGFkNznsEzpFdlH8gL42QsyCY1NdkCxpHYKbvYhXVpO
         rZZ1Q925WeJrRxNtqfSJwX7qiyb1PMHJa+B6ZHZ2teU0wudQO7I8VEPZD7ZefXT6gpPe
         lIlvkJ4Cnq43jkLCeh5RQjpwRVt9BTSNfPmELvi0s+PunVYyJmr7rwen+3mFZQP7WAtQ
         xrtWaSzeKd2OOgX550P7sDuYCnjwbUUf5T1va/if5XKc7mceT42ruINhEhR65e95Ro9D
         iG8PCtEJWQshwOsWC9RhqZuWzoTHqDquOOReIQsyE6B8OfmYW11bzTslr+kTB3XOYiUJ
         +Dcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647749; x=1788252549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SREjF1UBBXv2gv7dXR/21RVjzi8BP52PTZ7zJ8g1H34=;
        b=E1o9olsk4ojNCBBvsFSXoh1+fbLXV3jhDIWsX71Ubz3GQKu3FMw2G8gp36ao3tzfho
         AIqnQHcNpElIy/8SvG1q24KPXy+eFN56TcA6BFbX/REytCXzMetX4vDY++4OhvkX0m/6
         Hw5Fx55AVo534ljkZUUXHQL6DHMi8KT9nB/5nWfSad+oeo2UCEeCZtRVCaLFpoRfnS6g
         G9MDYAQ09QOB/v605Or9dWp893p7qjCySehB00S7NIdxAoI/NtDzCcdUSadj7euqc+Kh
         9TmzkbQHBt8yybnLCvrpSQW41bYRiP335AgZBj/sBHqN8WhQY4JpOyOMq2jgB5QUHeUG
         4l+w==
X-Forwarded-Encrypted: i=1; AHgh+RoRWLkqFZclmQHXREHmj5N8EmjHjB8F7vifMxGxAJuLDUbQde+EHVQzDp2hXvRyQ+2QdlTOtyC3YQ==@kvack.org
X-Gm-Message-State: AFuF++nsUp7H6gKIhRyLwhpRGm+wmBgAZfp2Ik3gASvwo9TfPcNlqkxd
	nkJa4Ce9nerxtxU+/+Sq713TzuMpzqMyjEzd7bYr/LfdEx2jXS4JXY0Nl/MMQ6L1IJk=
X-Gm-Gg: AR+sD11LGaxgyNca2aJYdaHCWv0IaVS55+btrYxa5uhxdV3Znpj/115vrdmiz9DyIB0
	q4iv7O5wArDsiNrP34jGTObHafTRuWziZpdr4A6oU3uIK/y+AQ62y/NJnyXgDoSXba3IuwIZCj4
	j7LeFsMrhheXNDOueo8NXINOOfFMzaZAlFdrsDtLNe0iKtc80a/emXyCYv4iWZpc/Bdjx8i4USo
	wRaGWVlU5g9/Ncc23m8nJVFyrNY7T9nxgvJnojLs9oj/PHIUORwSdsH20d2VUn5I9229DhPy1IE
	2KwefyGT4NjJCyWBLpPJd5GsnDHh9xMHRFZK375nYeC2ocF0HnQ0CICipGjZicMyaRnBr9ws2Ep
	55+xTV9Te/P9giiIghFWSwc8MNl1e8ntCGczUurc5d3IGJZLThDh1GPS3cZQgYWZvqARD+pfCam
	LacTzGUH9tQBds5bwEz17H8Zdv2n5KHEPBVQfFj0XsDkhA5gl03fZgVWB9w59jSwDnki9r2wSDL
	QPWYEiicNP8+CvXLWv0wW1ggg==
X-Received: by 2002:a17:90b:56c8:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3964652108bmr10799150a91.12.1787647748524;
        Tue, 25 Aug 2026 01:49:08 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:08 -0700 (PDT)
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
Subject: [PATCH v5 02/17] mm/sparse-vmemmap: rename HVO order macros
Date: Tue, 25 Aug 2026 16:45:53 +0800
Message-ID: <20260825084608.47437-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9BFF12000B
X-Stat-Signature: 5xoq33uhryaeians53sfkjfmfqqh7yqa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787647749-509129
X-HE-Meta: U2FsdGVkX1+bCdt0uVCeMTHzF/Dgm5GhbtqEEB+wC3M489vzHTFjJrjn5og9qYZqGi8tMbsvMdeqSFbURLhRCoJc6hT3G1iz+SNuz7YoXENIJme7fPwA1mx04KGKh6dVnBHjN3Qe235YbxItAi42xNM7IMqANgtEgmcLZ5qvp9ACxHms5ApZitrKcYHD/sEmkbpuqr6Z6iPC7sK4uIy9JXVjRGR/fq5mqVMYCi1WFRg1jZ0vYiLfFzyflWwoF3jOZjmf8OgnXHJ83UU2zlRFFfBDtIaTppeSqOi82i8E2LRJXlm83kVwNb6mwDaUWI//cFpRo9YlQIrUKWR6PrUEW1JHk19Wb798MxrNZSR1S4EdOOPAecLS3bcjIhTve/wr8fbg+qNk42Lifoii4o49fb1grSw6rbylmb+yeRZVqkQk4r48SDm0AOwz3AULh553H8+TTVnRADuLMt5o0DtjzzoVZdE36on4xrlOQLYzOOwVixg1XLe2GGsIzmrouTz25rm1UjtjJs5rW0SepM39qBbx+qTYG34+J9CI+eL3wCNfyXhDZxzuQQN2KCUK80shNRJsbUzJqsGcKB6IeNIHPe1KnJMQBJdJ79KK9Axn5aS2oz3o7tjj0dqA5nSYBU4zXCZIhvtqqw5e1QUUb2PwpbppJLDp/zSZM/lmq+kyXBm/upWuZhjz/RdPbopK7eiXDTiu5g0DHHPn0g9lOsJl0x5c8v436yBh2j0kkex4c9xhcnKQRQ+DMkRSWtO6WvU5Jo4Q8uG2Zm8Fiib1dDZ2gMiGk7zyHxeqXZuKl1CIZyXUHjnosYy9GF8/xFtcwFY4KgV0zPyXtcJh4b8ibNqHgcBxguEv1JOJ2UVWevK/wNeCfxRoi6spfFMt7P4mAewG973jdhmK3BIeZOpYBGyPFcbUL+eZitDKgp565ME9WxySbMPdJ8SPHO2H9TTgGwbWPEeFWgDVQxhLFqjHpCH
 Yx8vhF0h
 mVThA0eY5zWSOs2DBwlrD/xQFIGVH47zMjiDLJhboI2Bnb1wbPpCBxG0qWjRiBd4YwgFiPTkoacZCQRyXleHosABTbNsNT4FeCPJSvZrVhgs26GDj2jQ0Z4h1KMResmTu61JJN9JiST6Fa1HAKAK9qf71/rS2Gm3ugS585FmZy2kVSorehbbsqjAOyeCBFJA5NGecAHiFYRyKXXipvbP3xBiCXSwqcdTlUnHeiTqEn9uJSZcSuBgWvbD/reU8hg0mPF40USs3I9oBGB5+SAn7d6TXEMWybSHEYh/ePwpsXIaXI4n5vUVjEc0vzPwZHVj+G1uT0j513mTUgrSRasMRon19hD4S8duL2XPxGn5kcbv35ALkUvBjStyTi6DezBIP/DfAbU84/hJK76nqj7lP7vL+OrUNF7WXAU4j
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
index 4f6f58bf3db6..04e6c4244cd6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3346,7 +3346,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3354,7 +3354,7 @@ void __init hugetlb_bootmem_struct_page_init(void)
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


