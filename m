Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E23EFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95BB6B0098; Tue, 28 Apr 2026 04:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CD26B0099; Tue, 28 Apr 2026 04:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA436B009B; Tue, 28 Apr 2026 04:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB7B76B0098
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7901F404B6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:39 +0000 (UTC)
X-FDA: 84707265678.08.FE6815C
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 97910100006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YKsa8bG4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364377; a=rsa-sha256;
	cv=none;
	b=B5SEhKVqXGAoeJrUbhiCHeLqRy+v0H1597dj/IAjiiMVtMshYhnLL3hcR3rYL3C53463qE
	t+Vtfbq3yhx5GRSPMfaN2nwn71Hl0llIDF8+o2pjQGag5rWd1pbAVMC1uwvyXSAB4p7xWX
	TTTN7i+H8bRpsLJLX4QTEmM/rhNt+98=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YKsa8bG4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKHGjwyqOWL6rVsBt0Sw/YSvydX7Gt+2C2Tpk5skGPU=;
	b=DCY2nNHGeiE8C2j4yQycVL2DSpACf2WtY5POgJiJMwQghfpN5BxZaGk7dTxjEjs87s1S3x
	0LXp3doaY2nNRqSejNPPvr9RD+YKjk8Ntv4wwUdzqm0+163FIGreYT4CH45iOvYQrPbH5s
	QRFPlYGmTGBdZ9UYj8fv9CWwsv8iyuI=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35fc258aaa4so6937443a91.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364376; x=1777969176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKHGjwyqOWL6rVsBt0Sw/YSvydX7Gt+2C2Tpk5skGPU=;
        b=YKsa8bG4fm+orkhfJN+l/Mf9YKa+Q3Wg+GI/KW30p22H6Jl1vdbnHCa3wMagx9PZ1I
         +c3KGFwKN1ArohFtZ998DVD1ay+l9EN1WIr6za1hc4FPQ+KZAozgoFZ5Nc7k+kxs7RvZ
         obkUoA7s4i46T7p8o+05nxgURfWPDxskHfJIHmwlTKxRUJsml+PoIagNpwkhp2tTMaje
         Xvqh+YcZMiougnl7vI2MqRC4Re51c3KFeyVZrFjEFLLYDhcn70vDxnpNGGQxmLzLjdb3
         p+qFNpSk0uldcCkwEk9R5r/FoVlv4g9kCv3y1va6uEdPQtOA7s5U5VrgmKFbB9R1ctg+
         gfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364376; x=1777969176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sKHGjwyqOWL6rVsBt0Sw/YSvydX7Gt+2C2Tpk5skGPU=;
        b=Z4icUgPoPvng6mXYbaITI4Xjri2VkNaR0Bb3Tmskh+93YOLQLptcSAyTGNryMDswln
         C/PZQW8lqVzDwYFfX1awwZI+ecNb8+5NpKf7ixKWHmNqATTY/ny5zZ7EcCxkk8mHTUD+
         xMq9QOWmDKnq3yEtd5Sfr+9nvwn/GbQVuL37B2MJEXa+cDlQzJtjJukt39zRnxj/1sKX
         K3kiFLo1yHG0276jW3pw83aJAVcrmODeIbFdZP/cGg2KOGNhCXzdFMZ8LSRel22UQ6Xo
         4iWNmz3CtZ0Ex1Zl9Vb3/fhXhxdcvkZf1U7D1lcW/lIL0O16ujbKhXZDg/2yAvi7m+BG
         40Tg==
X-Forwarded-Encrypted: i=1; AFNElJ9wGKhE5q1gS73iRT9ZIDaI/WkIww30X4qwy6ESuRYeqJkoC3RQ3I9Iid1fwmYuImT8csFp5Z0R+g==@kvack.org
X-Gm-Message-State: AOJu0Yw/6/caO9QDsvBuLohVBwsm+f3ZJju64ss84BoVhq6A/g22/F0C
	OLrNForMi6odnhiqOlbaGdCRvUqVC+4HupumEvk9eCcRRFYm4hq9b5i2HgNVkP3aMAU=
X-Gm-Gg: AeBDiesIRG2R6ezCaEGGbanHfhGiRdnBdZR3+OVcqKzSm2O1L/KflzBekswdkMfYsuv
	+TqNasU+zL54aWbYSa+ThOjf8v9NC6ln5OL4vJpVKAyRRDNlWkfW5Tv21/eK7ajvbFfsHv/GfOh
	mrC99hHPeRujSWwRJWK/28xn7w9rVETt4ezsuSmaptC+rZv6IFozmGhAttsyv6+Q9Cqr8i5hfF3
	Dm7yAcU+vORLgWqx2HylY2HVFpWjnnHwLyimEQoNRTQgLKkFvrEDG1llRBRFZDXE29I2++6C7HE
	TiIEV2viWLxe3AWrixYPIAYAVilODurhdN/GzbNlTiimP98t5ssjsS40uN1ardnHB3qBK9kWW1h
	lfH6CISNa1Qkj42IJ+zDeUseXw+6qnHkWFIpB7oGuo4fmJIuiYY40/q1TPQZehDIDoEeEXCS5KZ
	6YHHvtu/rNOkRuTNgw6qvvny35b+NXhX5kcU8JvWQrU3cJjJJN0/TawSs=
X-Received: by 2002:a17:90b:5808:b0:35b:e5ce:73bb with SMTP id 98e67ed59e1d1-36491fbf11dmr2272598a91.1.1777364376405;
        Tue, 28 Apr 2026 01:19:36 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:36 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v8 6/6] mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
Date: Tue, 28 Apr 2026 16:18:55 +0800
Message-Id: <20260428081855.1249045-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 38dwtpuw5pi3udtauy9xw4dsqyyp7edb
X-Rspam-User: 
X-Rspamd-Queue-Id: 97910100006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777364377-739505
X-HE-Meta: U2FsdGVkX1+ZlPNr71swwERVKoLH17xlob0j+yu6hgvp1V+kx+p/Db7RNwodp/QLsy+u8T4AOleMlSlat1q+LunRaALJDSNL+U8pIhNFXu/RwSA88PylBRVj+K/v1gYQaOaHBZzT52cM77qcw9W0WyJ9PoFXeybIr5c4XAumv1AhAZ/F1DWR6zjWCpNAcJF6FpjJoRRoBdwZVCWGj+gbTTvrzwvz+EpHCj4vE6BJs1RZd08ooMvUJsdGSStTEtp45daLKP1sYn2tUn8ltsypD+8zbszMYnODi/quQa1mNpa5MNYNiTqCPI9I+ZIhNB/Du5RxlpZ2ocrzb8Wpvp6KARBQRfSVgVN4a8J4TJe57HwWPqMtUdKLWr1lc0hAIdaezm02kLMWrJRzSuyQ0/zbOwwLXMrLnG/GMdO36shB8hXHGdFjf2xbOzzWFz4soe2AIL7v+LjepWZqhYVWKresEIGOS8KaeoPSuvAU5YxJnDCKCyruhCHNrIwCrdKC7C3eWrtHylkCM6qhJ+fuc4j5WeV2pq+OW6F4aMtfz30TLBaJuS9vVbhtkwfFzeNBKpfOKgMU6/DBiMpxOhAmUQGqW2FSiWprxa+pHd6nTn9QtVw2Okbfl1JMIVFCr9e4JguH/ZB8TSxyGmdMZ8E5ppuu+xtKV5nDIB7CbvnIotrwRYr9pqgAfjc9YZUAxDl5Mz8USommfTvqYYqbmEVJbp9L7jcjTGiqD0CcHoL0r37Dqy6mLELSdcQaxEXpiR4lruCIxKPukmsommeVkRwLH4jxRBSVHdslylhU9U/I+7fnLSC/mkXTXMCEuakYrnIv9SkWTULHXS/nW+ZHP0EQ/7lHAny4Bx71NSqeiyAqXbdBWngzjmbEE5yxqSlH0XkA4hx1SkHeYyABnJVcAmwQk9vthLNegZKxH09ogDiTBVQ32bsPIYMAlIqgZUeMQXuyCaeNAty2iUL6h3kfgrtZn9c
 UG57ES3s
 YabaEb22iP2gLUm8vovPPZ6bTndxPNo8oOvwA8m3hOzfti6Qv+0ZCjm6DxU4IrLOEOvDlGq4ABOzGcgFcMtbl8PJvlSa111jxxZFXBU3kjgT3KEk0Ev/vvVXoaKnnHF7fI4fA8Y526C0Uub7sP6bQkLuKxjhbfYzZ2GCoW8NyyT8jJLcobnPyyIQ9E0fnDnBixBgluX1S98twV/mnwf2pXF9N/YyzezLqHcGOs0KtlKxKj4mA0I+o44WIe5rGe2ZLs4suogfkBR+eBu2ISYsvuNQwLJDFpHjH24jcMGKu3rxxYg7W42XXvReFXL8aPISg0/6YoI1H94bUj604GtHkp2qlAzSM/AMnueA4bSR/VP+ZSkKFxpHzCRSvGDNhcOaD8IB6fHq8UY325amShuHL42cEGRhNoX4eD73qnfeWyi/x8HW8DTTEV3A6Qa8YzR4t6kdhLdZD+zvQFPjglwcPcg61sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index cfc76953e249..bd466a3c10c8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1


