Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 913D2F5A8A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E026B0092; Mon, 20 Apr 2026 22:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01EC76B0093; Mon, 20 Apr 2026 22:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E996B0095; Mon, 20 Apr 2026 22:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD9126B0092
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:21:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CAD9C3638
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:27 +0000 (UTC)
X-FDA: 84680961414.13.878BB50
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF4F81A0004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MV1MgaWQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776738085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQT9sgIl1x5UPRFaiEeld1v2vJgPbOqztRRBh4ZUxsY=;
	b=FgnW3vBn+i3qX0AGYUMGwz+4Y8qdZ2bAlCfntgCuHgk8H1o771Zg8oFXG73kZ/iQjY/Woo
	1OSlVx2MjyxuM3BOCdfkCzggT9Txr/AC6kT2ZFG/MAqwPPvtihbwb45zTyNo/Uozku6D7Y
	HcQ/CxFcltDmf/A2SrSf6oqFsWeIxpA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MV1MgaWQ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776738085; a=rsa-sha256;
	cv=none;
	b=bn4uBlo9ee+Ektl7DLZAzjaeE2zqBPluCSFINA8E74U6A2Jbpd59HvBw2wFvXxPdLd+8V8
	B1JFw9MEW5rxW5XWGbVqUWKl9bgxgng9QEaxL9H1kLblTLxhPcpH8gIp+uf8h2D1xX5afv
	Ze8Ng0sXj/oBG50qYfmM5zFpk1Sf4v8=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82fcd0aa2dbso93796b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776738084; x=1777342884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQT9sgIl1x5UPRFaiEeld1v2vJgPbOqztRRBh4ZUxsY=;
        b=MV1MgaWQbflXOmjq0MbDfrNbcLXg1GxGnRrJKH7da1XUmC+H65UJas6UvTnP5cor3z
         64h5vJeWXOsUWsjx3c7qxiYAgI/m69Y4MV9ZEl4hL4ibPhhvGhhyFfNWeU9XVc3PkDE7
         v7z4Ps7YCmpxFGGlYyVhhJP+jo+GtrJDYpvq7myXc1u9a7HI42CJ9MCkzy9CeooaHO1c
         W0JJc1xDH8CQ//geyxu/PhVb21kEXr6BctU6mi0WgVpGKjE8NqzeVn1coPRepPXBZmbA
         Koq+TQpGyay8SqNXS+JeHxWbjAHkc980Y5cjg4oTjCRstuEAdqZHqkKz7GkFQmbjpetZ
         bt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776738084; x=1777342884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yQT9sgIl1x5UPRFaiEeld1v2vJgPbOqztRRBh4ZUxsY=;
        b=DrMxX0/ORw/+HBFYm3q+e+rEPwanJtTWIjnXOeMEIN8akW5XZx19+vG17ff6Z560Xt
         1FwGKSSfowIRVO9jFSaAb/+AAtvTWniq/mgopGPqJCbGcvDFTXyIr/3cc+HgKFHiWuwR
         PtMocAE4EUZJLqoRhJq+OGKoEwCtEqCy3t3NzxfZhomWuo45v8mPe2phjioqaKmXMi1j
         fMY0L+/tcFJTiZ89BiZ4zrFVYBzbJcJ7dB673Pv84jGgXpXEZRTiRbAiPlsE1ofTym19
         FQtxJSPkHbVtID93woWJR2oxhnEeFf7VALhb0fvSCdUdQl7NB4p9zqhR337TEBtygsyu
         +epw==
X-Forwarded-Encrypted: i=1; AFNElJ+p6BC1lSpq/sRiyedurkILPJCilUGBETWa3XF5xz5JOV4ZS8Z5KooWvPIVjnGsTxmI5flL2pg1uA==@kvack.org
X-Gm-Message-State: AOJu0YxUol3Owh8RBpzqY3+UntLSyZmHcXQtQoilt2BxUlWf1T+kUrNc
	o5lcBm77q144OgNJinfh/Eqs/ji8UsftArKJhQKfsOIGVAAqXNOaq/QmbiByxOUdjnA=
X-Gm-Gg: AeBDietHBknY15GvwLTvKjFdmCKvSDMCKsYugCt3SGMhyv8eB4XTK7bxzCkvuy7SFAK
	NK5pZDFAA34oIS6l1PFMktztJ/0r8J+hoTuSLxRNxsCk9z01RRVKGccw0hWM1YQ7GdXOkaxDyEM
	3k4KAMLAlUt0PHu8vzQ2WfVDK/rt2au67AOEBrBQat1IrosvDTSXEuljLsgx6inDtrYXqRHkXo0
	1sqhmrRwsgMtExgDUEgJq0Vvfb7zYQhZbFWpkKsaRHKiPYs456CswqWSeBwd9mMNXhWJT/4Ylv/
	6BOsipYWCpBkSSXxrzv5jz9NfwxO6xVF2rBiDAlzWwztVkpAVG/ZasecLUdKJOrhXjxLcBiRYtz
	73p7oshhjIdRA2FxbZMZwKctKiBThJVqAn42hUNFe7/946ajGe8kzrSWyAwXArsa87YzgnPuWyu
	EUGme0iEuVTr/0S474UZTbA8ytAwAB
X-Received: by 2002:a05:6a00:be8:b0:82f:9a88:9092 with SMTP id d2e1a72fcca58-82f9a889558mr7527975b3a.33.1776738084191;
        Mon, 20 Apr 2026 19:21:24 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::340])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f932dabd4sm11538780b3a.51.2026.04.20.19.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:21:23 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Tue, 21 Apr 2026 10:20:43 +0800
Message-Id: <20260421022044.1217503-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260421022044.1217503-1-songmuchun@bytedance.com>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF4F81A0004
X-Stat-Signature: z86p5wxc1dtx7wq1rjubnfxeo7tpf9sq
X-HE-Tag: 1776738085-851456
X-HE-Meta: U2FsdGVkX1/MWGNl5KGOQENKAX3oNmg0q8fhOe0GzaEAxCBbd/V+/C1B1RlbaGK91pjCscRuveBVssUg0n9s+3290k5Iucos4Es4bI9u3kPgXki4XydslfDhoeC5FlPhms5nCQZlbO58eiLRKdHhpASCR0hf7puV8eISfaqtUKp6Zilqbt21RDRh7+S2nVo0pihaZP/9rE6MeTrjLoncfKmlaEuW+Rt8fcmVOP1vdZ1/DX/0XWWNHKWsIB4dyPM+UGKSW6FeVQ1NJpgznUSad351zoAAxGkfz5HnYtstJ3hWO/o9diLy66doPyzfll7skPP/eistbLOgD7meEgqE3oM57mbkfgNvQB6cZaMcBwcAYD3NpToBJbiGfgqQXm9UhRy1HAuVvY54P+/R2smSrup2MhfCpB2aPVSiwwiEgly1UId3ALrH7DQWgnU/UfEohBHNzE1jfBUl7xV8V7UJGH2iVqiJJagkGvd1NFhs3LEAKBiKRzjL49yfVQdCbHxKJKx99Yb6sg7FXj5jUuuVyrhAGNKKKd3j3rZUmsCGKi376CuQBCS2Ef70wtm8Qx+XSyflhqurpgkwTXgZ5ywolMD1gHZFIz2cr1d4rTW5vq2nBxLoB/GqU+ImXmszcNLUULvnIHNDE6r0Xjmz/2qpIzb5jCAiexTahsx05JLbi3dzoAOAE+wWzRmRHdR6mWUsS8QDugpysqOrOMkByQvh1kUynAV2J/ZTQhlvhWjBGg9VOVI5mJ8ToZ1Ulcoe14orz6VEFMcQXUXCtayvMXndKSn/cDIj6xQqukiNzCBKksvtMBB6zVa9kmfUY3yzXWgeRumJR+zI35sQxldeB1d0Zcsajnp+7iW8kLywOzM0s3TwM8hfnKiZagYwuf5AT4oPUa3f6RY14H0ytNtFCqF4a9SVlYvBhtZhEkzfDI5WGxEKN7e+/ueAl3razoykSrKIcQUSNTsZbRiAEBu9yN6
 3w1Yc+vG
 oZqO8PzTIFoyKNGmBZsTUu6h2EYsX8avWjTBoWCmL3Cq/WvRgZl5SGKxFPNM7cpgz0rBgqpdyexknwAMMPw6ZIp7S4YJTFDFdHZfTSsaPsmAOeliYHG5Xune+4Y4rid9tHSmyX/QW0QxDjGD4MFHBcX1vp+Fi3YHG2Qi0HjUu8kqAiG2f9hn9LYBx/HyNBaRTjqL5EJFLpGWphIWfwUV83vrewFDRBYnZ9BIdkerrgJDX3So1n7c+25mUX6lMfyyNSqttBc5rWI/GK7SjjUFNYL+hhTAk37K0H4X59gNaEDzMP9Ilhjdlw31QLK48go6uwRGtP5lgJD/qzBbFbLmbiIT6ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap optimization is enabled for DAX, the nr_memmap_pages
counter in /proc/vmstat is incorrect. The current code always accounts
for the full, non-optimized vmemmap size, but vmemmap optimization
reduces the actual number of vmemmap pages by reusing tail pages. This
causes the system to overcount vmemmap usage, leading to inaccurate
page statistics in /proc/vmstat.

Fix this by introducing section_vmemmap_pages(), which returns the exact
vmemmap page count for a given pfn range based on whether optimization
is in effect.

Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/sparse-vmemmap.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 40290fbc1db4..05e3e2b94e32 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -652,6 +652,29 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
+static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+					   struct vmem_altmap *altmap,
+					   struct dev_pagemap *pgmap)
+{
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	unsigned long pages_per_compound = 1L << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound,
+							PAGES_PER_SECTION)));
+	VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT)
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return VMEMMAP_RESERVE_NR;
+
+	return 0;
+}
+
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -659,7 +682,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -670,7 +693,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -679,9 +702,10 @@ static void free_map_bootmem(struct page *memmap, struct vmem_altmap *altmap,
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_vmemmap_pages(pfn, PAGES_PER_SECTION,
+						     altmap, pgmap));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.20.1


