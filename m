Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110A7C98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A0B6B00A5; Sat, 26 Sep 2026 22:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA3E6B00A6; Sat, 26 Sep 2026 22:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117E66B00A7; Sat, 26 Sep 2026 22:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFB666B00A5
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72FFBA09EA
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:48 +0000 (UTC)
X-FDA: 85258027176.20.D3838D0
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf01.hostedemail.com (Postfix) with ESMTP id B8F5040006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gnlL8JDD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CIuL28jJc9rBcE3veHd1eORcVK0n34BpltfpMfOrf4=;
	b=S8FTINWHYohB3uTnvKJbwPYkJ11NJVO7Zh9kAtuavK+gUaisUiwNgdXhJJ0NTmw/NoR2AG
	u4kBS6LM1L6ZtmxXKihsy4bbxsNVe60LxWBwQaZtA2xPKrO0stEmzSlMzC6ekQ6E2rHxDW
	iJiGa6XETX9uELJhndga1l6cu2BE6Tc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gnlL8JDD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477746;
	b=r1mjN7LUHUFwJrNPqh4EVGvtH8Em/qiinR2x/uklWnIvrsuZzkqmZYsY3JjjoSJqZMSRGd
	kbVGa8sLKkazSb7OOt17e6MiQdyLiQgzFMPKtkL9DIydcCGJ7dcRY7PGJ2s6Mx2A6A5k6K
	fRtYlBSg4V/IeOvVNz2PQMFsnHDgE/A=
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0df0bb2d6so515344a91.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477746; x=1791082546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2CIuL28jJc9rBcE3veHd1eORcVK0n34BpltfpMfOrf4=;
        b=gnlL8JDDTdqE60FUNsSb7NJ90W2xDBYJ0hJicIx0K57gkaDTb8mI8YOCh/5ljh3DJF
         M83tR6dzdklf126+FgxfTxa/c4PHMRkpGt+iLNx6tpyJrQ3ECY35u98Wrx2JucAvKMuF
         UZPtyO02l0QL4MazcbQOZxBUwUOY+Mmcl7yEZ4f2yekaKVSSQCeDX100ivfxvJVzL2P1
         MIXfsV7arPxHFQ+WRgd1vGeCob/eoYTjo+J9vRi+ybSmyV/I90rpj4iMz+zLGteNKKYI
         yLpA8ghd72dmAnlUe7svI6LrtmfdpRyxY5+rYqjxm/+IUlid95+3Tns0IU22asKmyHy0
         /hIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477746; x=1791082546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2CIuL28jJc9rBcE3veHd1eORcVK0n34BpltfpMfOrf4=;
        b=KFCnhnS+icGs6lvkoJzO9xlr9s899ivN+hKPfhACdpn333iud4q/mjrm4p29X1BDHN
         /IuCpGYXyY2UMewuIS8+dov2UCo0J46NYHQRBrvfLwoJ+WpZgxzIfPq4KHibU8ImDlHi
         RerVQqvEx0IpcgfdxpwJDwYdNsez9FfOdzj1JsXXLrsIpzEdLElRccgcj/WWoTpQEevb
         qtdP76JGYIEiOUOg0IqeKfFp+Q5SCTSzTU55C8Nu2TqflKWoOj44BqAuDXM43y7PzL8C
         IaIDCLzxRQMBXFx0tPWt/xrMi0S3dB7mJX2XTM9A2M8TMjIzcSdWngZull+8HQST0fZN
         qAhw==
X-Gm-Message-State: AFq9FYLfVLW9k/h9xaXWJElgxzGhYg2D38ujJVH5ontXdGjERZx0H9lw
	rhbiaytfQk9TeYWwkxnO6mRWRvCnVtb8E3IS3YX5Pes22QWGIRWGvwfl5mZ+FW68gdo=
X-Gm-Gg: AYBFou1e5cO4pT/B3+ZNctaJBlnq4L0bDHnX8tJ3JgF6pXN0USPwLFGD57wa4XmC2gT
	QFSonASlcs3wOXB/xFxjlFsJXB3OPAayR9fslCF38CtF5lFemanviANPN43qsf2tnnWFUbMnRPy
	r8f7I9q0E5DCr1HQjQnMjrY7NgAhV55G0ZfEZoi3kUI4pA3Wk4MgByiCKPnUqNci9nuc7h6HWME
	SiQ5SNhJchNFpYQKE5uB/HsPNsPlD/Lu/mfZaF09hNdDT+AbbKrHmjsh5zHuQnxlBquEVjkveDT
	PVbHrjNbmhKBEGuy4bSzg6xvP+i/s4QGYTOZfKCQyVSziYbev5efRdNV/j5vaC+9M3k2SXpQCFW
	9KBsNLD0oB0m9zGkHR7I0cKhsYP57MBHun3SRCCh4ECnR68PKMIZPt3FlF/tcZpiWHTMfusGJpK
	0AbdHYpg1PRp97Cia5iK94FxsBHZzpwr0yJ3aIc7rcmLOLDR4xaHgb8vwqFTG4F9X26hgfUicMH
	jxyMBRZ3MO0vPVNz0FgVoFa9fPUjx0=
X-Received: by 2002:a17:90b:380a:b0:3a0:be2d:3853 with SMTP id 98e67ed59e1d1-3a0be2d3c4emr5473938a91.8.1790477745543;
        Sat, 26 Sep 2026 19:55:45 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:45 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 11/12] mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Sun, 27 Sep 2026 10:54:40 +0800
Message-ID: <20260927025441.741633-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ccwtcw9ibuf977dkmyj6nxgbdnwp7g4s
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8F5040006
X-HE-Tag: 1790477746-938083
X-HE-Meta: U2FsdGVkX18vlrG0APk38Ty5AYoI+36nesQ+bO3UXnsVR+4KxRO4Ro5t/KJL+OVLw3SU7CgdzfKdGWk8Va8nZECchlTdJVG2TFNe8OPrw8LaVNc7MqrfDfPF5QHTJ+zszonVuraqhy+aOYfqbQy/61dNADajY885HirRctAD7/oqcqTheHojPCY239MJXSlLHp/x/LEx3PKz6riKFQPUH7LIIfJhuJQMyyf0fHfE5yXXVziR2RV64v0B8RUdyyU0ERlTVr0qE9ii6vfz/jxUJTYCh7ySlMTIjfZ8rLsKD6NL/muhpV9Z9fe+Qz6PUDb/gtVl/OOG/tCjK+q3FWZ6soX8DwjWumqdMsmxMwtzhx6iC/zsuaPKVJhOzfQA2J04dvpAllR77z4uEyvBDYJWzVwq3/ixTPBOjakEIL2wmN8lsAU6oqfC/E690+MQb8I0HEwitcLBL+b8t96//R+SQNgd6Nwvy0TPSFiOX/9UZgC2Kho1YSppdBBkMI5rwoaDD1rC5UwBKNiYBK8l2vIIdiuTB7ztbFmk1nUJUIGEH2BhkqEU3/j28PnmKtm+WXgS/qEpfFLPngL2/JHE0A2eAAfwfRE9eiE63ouap4jYQaQK6ddZmx7e0e5dJ7VEIcbQd91W/zfWTpPnmFgqXw2sPiwGMg9FVy59usqpqmEB1SHZRnWKlC5Xt4Um4XzvabPJFykDoMUqsfueQmfOy6eJNCco0x8Z6s9d/jWHT+Izq8aioH6vB2geLAkcKLwZrvl+mtoCdqN9e8LwX7paSmZYErAZj66yyJS/+RRI285MpmaXvLzojtJq3csrsQRlyiyU6KEa9+5L1cHycSwliBNNG4X7zvKzyGwmnXb1UGhAP9LyHI6LAfI8Vm+wHV+6hpGOYg/ujDMTwwVr1QZkP1n+1geav2VFvZNAebmZr4k5LdCUbVMFUvn6LzXw9kkFjYk2evVoi+k+WyMpMyRou1v
 pLx/ANjK
 G43Vj5vjxdip3ujQuqi1muNKCaOqeFMKxZwAnjZjHkHDZfQcpAtBj4Hp/zVveL/V6yVM+SxZv+N0HCtqbXODS9i6wmBBGXrs09TUi40NE5ZAff3ARnJP3HQq61Vz+oeANwpBwr+dACb9N5tMHH2TILqWyUtHwGxpvBPqczxOw048djn3LT5h+/Kdo7ijKNkD+88VxNnRMX8uIAlRMPtknX1MTSjXyCS5cJ9P7/42yQYpUXlmNU4YwoqLRP73vpALoR/YGhfXKeElFkNty/zt00qSgjioUlAvyKXe956jZvq2GHkxc+oeFmTJvWbieGDKjyW6/Xenpz64CDnI49bceJQfYZ6NwligDNIDPB7J9H8M1q/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() no longer uses the altmap or pgmap
arguments, so drop them from the helper and its callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 10 ++++------
 mm/sparse.c         |  3 +--
 mm/sparse.h         |  6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b6378826b9a2..b617ff1b985d 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
@@ -666,7 +665,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -677,7 +676,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -687,8 +686,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index cc28bb41fdb1..b75921c622ed 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -250,8 +250,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
diff --git a/mm/sparse.h b/mm/sparse.h
index a5111087ee3a..530692cdd516 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
-- 
2.54.0


