Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4B2CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962D66B009D; Wed, 13 May 2026 09:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AA66B00F7; Wed, 13 May 2026 09:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850C06B00F8; Wed, 13 May 2026 09:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 751176B009D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39B18860CF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:26 +0000 (UTC)
X-FDA: 84762458172.01.4B13EA5
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24ECF10000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T56S6TC9;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awvhCSRpADYIDd9yqdYnymlqYSzgggMn8w5U+iOMJHM=;
	b=TDOOv0KqRAoZqCFOjuiSoTI1opAw4dBPwBPu1h3Go5S4S4Bt7hJqRBzpSeMYSI8xd0k4gX
	gs0Q28BYFr4pZpj+VkCXKM6rMb1/Gd2sfTKxjjLiZdfJznmJJYxcUXheN6z+LTZ56Y1XFo
	BMsYkrGy4F6tam0siiqzje+dUtR2A70=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T56S6TC9;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678484; a=rsa-sha256;
	cv=none;
	b=je8dbeWrU9KfWse5WfEf7SB4Z1kalJVR7GjA3Az4HXOhvk8vejww4ilvusNFKNKyHGUKXD
	TwgZ5GMCx3VizCf1df1xdRkhm7uj2uV5FnlpCrC4CLYOZRgpuvHiEvb1NchtH0O1Zj+D9F
	a9ugeGMpxYzNgkyQtzNMqJ33UJWKh/g=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-367cbac9cb1so4526776a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678483; x=1779283283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awvhCSRpADYIDd9yqdYnymlqYSzgggMn8w5U+iOMJHM=;
        b=T56S6TC9GXh8jbFD+Q3OItkiCpNM5+rYY/goqesdF+iEZHanABX5BfpvMJ2gWV51xy
         dj11fbYto12zjG04Fx1ciX674oKFMVv47tFxqFSDjPc+E/wMK8fmoS0S49QYI6V2I9cw
         9HEbz7g5/hHdZi/V3mEiaSE9v1VO3H2zuWBZUpwduzqzv8SYwEXuylyMCGdVIJ+/zN14
         QfdCOJAOT68kxpxsXAqKoFHys85IMkrNvO1uzwC0mjBtBrYvhwV+1595/Ke/bu0513D8
         hoXV0OfyDVeqAQPvz966iMleTLxOsqJ/yJu3mcSDNPQB1N2oOAWO6pmRVw0e6sr8LY3H
         cj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678483; x=1779283283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=awvhCSRpADYIDd9yqdYnymlqYSzgggMn8w5U+iOMJHM=;
        b=kjAkInsIvpsruyxQ096+t9O7/R15wa1I3cywAl7lefrEcohaZX8Pv7p1tiPa8WVqGs
         Vg8EVNvXqHB3wI88jVt78B17kNTYtQleR5gDQuco8eW+8zyJBZFqlKu/VgEU3anBm/WG
         hB56m1Ent+KaEQp7gUq/drjHznJzKZHzEVcsVDUEpKx2KXqktnIoEuBJGa+8EoJStsZW
         uYvi3ZHog55r5AhiCABRLku7Qmbpj+mJ+wdcbVxST/lEwY6HzeFswCk8yziIPWvsOU1k
         l/NjFW7I3vdBn+unOK/b4/Y2cImHn4mKfSb4cqn2KWUlsZJDHnUuGf1+LZQ5FjtRAoRu
         yU2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/SUMH5pMukqPx/agF1+YNaooeh3Almss2KebSGFO+TgS2ijs3l2940YRjc0wDivHNlRZvaaxmAEA==@kvack.org
X-Gm-Message-State: AOJu0Ywx+05jXUX1tdF4rrx7ecO3AHq8nAKqETDwBRoIFyijAn1GTCB6
	Q/joNtoCgJY1ssprMEBGU7kLuS3ZNGeqByxFwmU0aKWYKnugGGyzdHmSZtYmUo61jIs=
X-Gm-Gg: Acq92OGSAhtA7gnYn5vY5LirZEJRuWSMmqwiW3aTs2rGerTFXUq9jY2tzFwgWIDzMLl
	WuxGvoTObk+GdJ7bMhk4KpSt0AQ9jUnRt3GuR7X+1z2HwXlzQXycXreoeTV9YUpk+qCRizwz/KG
	+mlw8pth9CV7PK4sdqJVBzW3wyNwn1AkYJxSY3RKbGKo1MfsPg5dZc9+e4zsJRZeYsjhb7ecSC+
	JUtq/O6W1WgTvIAercdweUkMX8IAYl2SXZIfmi5BAiT+MdSveSH63wOfezc/OTA/50p/L5Z4fPt
	DwK/rN2NVPo3wxwRmlQlT89EBtZuWHJQGLj1rFLU7ZdSldYHNF+/VBCAdphs1xBhJlOjRB+c0jU
	3n1IIpWnNJyoFVi/fLU1orX0wsljqt2XYakHMKfVgEEDKuO+Bg9Zn2fC1zpbLJdxIQqlIR7MD8S
	sflSXOXiuvi05z5CWmeadIGQKUsaICF5ro6NPCLnu2L8UJCQ3fW76ypwU+evO3
X-Received: by 2002:a17:90b:2ccb:b0:367:db13:aca6 with SMTP id 98e67ed59e1d1-368f7a26e42mr3016818a91.26.1778678482924;
        Wed, 13 May 2026 06:21:22 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:22 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 51/69] mm/sparse-vmemmap: Introduce vmemmap_nr_struct_pages()
Date: Wed, 13 May 2026 21:20:16 +0800
Message-ID: <20260513132044.41690-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24ECF10000F
X-Rspam-User: 
X-Stat-Signature: aziybh9c1anjy5h7wkudum63xc8j6wkr
X-HE-Tag: 1778678483-776537
X-HE-Meta: U2FsdGVkX1/GrhPc2vLNBvn5v1bYO2npWB2cqf88vElOux9VHhe/XoyrKiPtM5+HmWnFpfXoEraeaTPwWL6yc8C9Bc9WsCBAhUMSVes1CMx5dFEDUnGYxrRYeeREMrCq2gTZFJStwtWAN1v2G1e2DyxpuHMSrqilPgQ4I3S6TUaO1IKsqfSuB+wnlEdHTvLpExbNIMpnJ2JPTx2yS2BYAUFzIn4Zjgh7ABkQA4Fzo2bLbqtkqP5qeOp6YyIYY5pgtaDFcJDXWL77VDuVLrajlt01NAXj3RfHIMqDPuN8w+25+1SfcBm4gplfD6ONgAKDi6OqNpGvSRd1Nc0wA5pZFoTZ1vFb68VV3t53l7zzM/n+1y1MwOvjZfHT94SRwPKq04IQKFrsQ/FTa6ZY9rRIY9h8LusmUn/SGhMBvLv8MrJDFoNykKkip7V1FObYbGXdg4pX4EQp7ct6VAvk4rkNZXdnQFsh6m9ECs6FiwBuLygLN6Mmb7RrfRKXDzSqJAYpqHVgcCxbMt+fj8vqiZhX41HRQIHpApW72hHUqQFSPauaOia2hl7jA983nw8SovMqCMGqcRnFn2mldzI6C8VcEsXat1ubXe1EjtvP35zTrRVPdY2TWY1E1HcMTnNtQUbtSOuFh3v3905jZBGodHqz2N1lqDhjFAOqjiJynSmTfJYjk0qlROKzpkfxHw5imhkKA25cdlZqjKgYZ6YR6TKCRAMl369cCgiO60vZSb/pSan9PEIFPG8nqegC0dxVYS2JMVfT/E0Y8uFDdeMBKb6d4k3eU+vgNPf5/fvT+WvHmOqsoOOQo9oQ0oQuAoYEr5+SiTkY6vTpCAP1pfGD1BF/BDLo/MU6cyWnsZg+Eo7yuEvkVa/Bf4QetwG6rBzZFvWkqIrSpMtnZIHZz/mmNSgq8OdqpcfXRFBryNHQUKCFLXrahG7wvBjNsGXt6sTGAr4zvNSz2wLaKkMKGoFRonv
 gvowfT3f
 wgfwt9Z4QvOtkBQbcv3wpLCy0v74VXHLcf7mK5XZXnM/NynisGROhJuVe8hdYLrLTtDhh2GpZa5a3hLqgRiymOx8C8D+8RJC3W935ZGzcMuV0yMS37FGxVOe5HORHGfUY2aj9EcOwE6Ho9ySCubMCPkwK7pAsmgPrBlN2tgRCO2PKf3Ar9bh/zH+UdffU2PLpxXA56mLMPV9Ci/IL5YFTWC2R/ytLDcEBu4coSLTAUaQKrzOonXB5sb14PSt6Ri+uw/TIV8HH1urt6mS7KxYa/hLKzufRq/d/qAP+lJDsypDSJ1DBjuWwPfyRgBIH3kjkihS+aXV/AcIKhBaQpA0HGw/LUsabt5n90l5TqKSS+MeTVPdQCQqoV8p79yRngeM248848tesfj3PKFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

compound_nr_pages() exposes sparse vmemmap optimization details to the
core memory initialization code.

Introduce vmemmap_nr_struct_pages() to report how many struct pages are
actually allocated and need initialization for an optimized vmemmap
mapping. This gives memmap_init_zone_device() the information it needs
without depending on sparse-vmemmap internals.

With this helper in place, drop compound_nr_pages() and keep the
vmemmap-specific logic inside sparse-vmemmap code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 11 ++++++++++-
 mm/mm_init.c  | 21 +--------------------
 mm/sparse.c   | 13 ++++++-------
 3 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 06022074ebcb..9597a703bc73 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -997,7 +997,16 @@ static inline void __section_mark_present(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
+int vmemmap_nr_struct_pages(unsigned long pfn, unsigned long nr_pages);
+
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	return DIV_ROUND_UP(vmemmap_nr_struct_pages(pfn, nr_pages) * sizeof(struct page),
+			    PAGE_SIZE);
+}
 #else
 static inline void sparse_memblocks_present(void) {}
 static inline void sparse_init(void) {}
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9ff118e35641..4ea39392993b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1062,25 +1062,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
-/*
- * With compound page geometry and when struct pages are stored in ram most
- * tail pages are reused. Consequently, the amount of unique struct pages to
- * initialize is a lot smaller that the total amount of struct pages being
- * mapped. This is a paired / mild layering violation with explicit knowledge
- * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap.
- */
-static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (!section_vmemmap_optimizable(ms))
-		return pgmap_vmemmap_nr(pgmap);
-
-	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
-}
-
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -1145,7 +1126,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
+				     vmemmap_nr_struct_pages(pfn, pfns_per_compound));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
diff --git a/mm/sparse.c b/mm/sparse.c
index 3390cb82f114..f314b9babc4a 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -237,26 +237,25 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
+int __meminit vmemmap_nr_struct_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const unsigned int order = pfn_to_section_order(pfn);
 	const unsigned long pages_per_compound = 1UL << order;
 
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
-
 	if (!order_vmemmap_optimizable(order))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+		return nr_pages;
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return OPTIMIZED_FOLIO_VMEMMAP_PAGES * nr_pages / pages_per_compound;
+		return OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+	/* Ensure the requested range does not cross a compound page boundary. */
+	VM_WARN_ON_ONCE((pfn % pages_per_compound) + nr_pages > pages_per_compound);
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return OPTIMIZED_FOLIO_VMEMMAP_PAGES;
+		return OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES;
 
 	return 0;
 }
-- 
2.54.0


