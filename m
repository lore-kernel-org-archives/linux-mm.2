Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E2CFF8860
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3F86B0095; Sun, 26 Apr 2026 05:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB566B0096; Sun, 26 Apr 2026 05:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1CC6B0098; Sun, 26 Apr 2026 05:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBD86B0095
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DDADC170C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:32 +0000 (UTC)
X-FDA: 84700179144.19.030997F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id BB5351C0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lWN4flzc;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CoquneTBQ8S9NM0KYy8UH3zDqZYMfaQ5136cWznpdGc=;
	b=GvY9iQiRASimXdAGKZDj1LISSSgX/z7ZDRf3sMbbot2F4pJUw6rj5cEFYAyHwclN8wa3P9
	2SyTeSFuUhAbyx9BKnKTTBMVoz98YEVRcjQheiuSXXtIOripbWPvD4Gm6e3DTv+TfkodHo
	gkL7JsBy1Wcb2LTUghJAiBg017SvNcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195650; a=rsa-sha256;
	cv=none;
	b=QQNfu/JC38p69VXm+WRT3GuXOVI0UjQKmI1JVODRLoJ6HRjmLCWLXRcshwEW+iKiN3kScw
	YfauozEdhXbCzBC9aZxzUDgRHj+1NnXBXYCMFNQ2RM25FlomDLi3clNKFIZgtTLkj7ujjZ
	QH+9nNAcuKWE5B2LWmBgGpgFBiTEzSQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lWN4flzc;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b7adb38d65so30869825ad.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195649; x=1777800449; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoquneTBQ8S9NM0KYy8UH3zDqZYMfaQ5136cWznpdGc=;
        b=lWN4flzcCoPqyUoakgN/xEivJoWO2eGt1aTWrYX/jDhAs6alBJlbSFZSAuXE4a9neE
         vufPlgVe63Z9GMQunwVx0kxwJAHscjFvyTBgLf1XB8+7AQ8EywPxbpk+fJYeDiRzPojC
         0dE7BR7Vb0Gh+8fyKyjaTSC3PC00i1ffZ3aMhw1XLqGFtdpwJsLgqOuX6imxgxzXfVv4
         OFWxnLeRvdyLJTexscb0zOr32mrY3hEusFBlfqHs0UoZn7fQLqjRr0/hn3oT+k5KyJUj
         EvAUDXG3/XgHV17OQ1vgFgX8lvRdWimjL5YjGJapuPe/LSOXFeMMeJRKhHu/DCs4KMbZ
         MYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195649; x=1777800449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CoquneTBQ8S9NM0KYy8UH3zDqZYMfaQ5136cWznpdGc=;
        b=MhFdPEQ+ZTujkqA4hO1hRYKH2GdRGMdHvZMN2F6ZrIj2rCsHL8HX3H7VrtPYvnoDBI
         /RVHOUdC1lIn7hoPdzP34GfcS/bBf6idL/JcmWonjkUOWU+nXaQ6ufkFxy6k2efSJsxN
         DRTCLjkOQfrpGzz0S961aXNyKok0hxWeeL2mvjp4KZeyqhYa4OI1YYeeRO78qgwLlGM3
         ypLbqoNaAgWGqTQO2/7Fg0/+pA/NFDdqgPuFGM2xTF1glWxgIDveUlZ30FybuOMP2/p/
         /uttsQ2ZkqAoF3im0gd0DNe7pDrDiDj8Hb4vrLnXXXbRj1dQbgCQgh9CpnX6JMZBodBW
         id2Q==
X-Forwarded-Encrypted: i=1; AFNElJ8llan+2uy6h74OfeyMtOLcfw47s6YgJ3abdSFdJ8pL3Kh2qa+VED0/yanD1QNFKuBqTxk5WrdveA==@kvack.org
X-Gm-Message-State: AOJu0YzkGTbYKHERbEzye7ZAE8cnpdNoLeQ4BfCWpf6jiKp9GGzXnVVJ
	4L0H8SS4QPLLx/IBCw8YlRrFLeCok1tVIjcSpCu2Pw0o2Ic/fygFhs+ojfLuUEbyi7s=
X-Gm-Gg: AeBDievXmhg9wQ7K5tu+vZPK/aH71E/hsZQHz/gotz4vk5joBfJbQ+p7C9nuAFFgk9e
	59FkK2yKD4GYAdDfJHXcZ9VDk5ISfxfdTLes3fVEqjB1ChXPpXbv6b6iR3fmn0JaMZlHjCPLiA8
	NTMfUWKnBxMA+xj/XVflD7cltCim+rIIP90V0c+nEIjU+m+whAQzdL1WF6v6j2He934rqVCU5MB
	qT1RiC564VZzODF4r1z4U0EBUtObmry1uX26xnup7jedRXi8VZ9x7rWj8jFo/CFfvWtFZQudO7D
	CAgGy7Rfr/naEJcgwZUc7K2Lq/UCerETx9xyPKVEsDwNFGv34QkhVNyDzr8+P5zIknR8beBXlyC
	HoAcXxRK7n+zsSYMfs+b/evP4V2WW3ITt92a6hsHlDFPELkOnInzawNLtVqikD2xl42mJFLKYrP
	KWmtl/6+cghq/Z9LMckszB6Pqb5BL0
X-Received: by 2002:a17:902:e746:b0:2b0:5a4c:7263 with SMTP id d9443c01a7336-2b5f9ef646amr454625165ad.18.1777195649505;
        Sun, 26 Apr 2026 02:27:29 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:29 -0700 (PDT)
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
Subject: [PATCH v7 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Sun, 26 Apr 2026 17:26:38 +0800
Message-Id: <20260426092640.375967-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB5351C0005
X-Rspam-User: 
X-Stat-Signature: dk78xhoqad3g55udj3z88rgzi9571hem
X-HE-Tag: 1777195650-209897
X-HE-Meta: U2FsdGVkX1+XMIOJ3zWmHUVIkDpzu7IsCMP6N8iTW1WpzMr5rLwc+I1OAofC2mzHsgzyBT3XnRUW8oGh/zWHkzMimqd2QIIPocBXJEGEndXVpOfePO/lD4DuWOf7Oja7+nHfNsS8d1VhHwqy79MDWE+tEJIxWdyfW8PkEcBtgB5dpLs03HuBobhswbbwjRKahSkICAreZ7iqqb18GCLzgWcNaAWb4jvb35harXf1C2Gu08kpF69XTsJs5oyMs02SuYGzqvJu7i49Zaa/BVw8fsfVhhxGZVX8bRX5mY61QR7JG+L/10L57DyZwkQTlYz+J2F1fHpld3jGhYlMTXK54S9O8Q/RciaNUEn6wBCFGZOYxkxGzmH4sCXMUAtVO/zPyAQkKs+e2x6zDLDLDhzUD1G7+o1fEPIOh7r1FSrjTcxizS7nWFkqsun6nhpxGbI5QtOSlM39yoRWzVZb0kAdfTvFVlQZDzF9I5/hL1lbWNo9akSSe07Ltcgkd4/XixJiF9QqTBFF5hCAIi6OWAvYjzcPpyxYPpPRClPLOEAryOhC8LoPy5hYTbMCjmshOxcf2xxgIECGt4dIxE4Ah1wpCqkDy97hi4ykncvNV9Dg/7JXbrTcoKjbaKxS2LKLF6sE2iC9VvVnO1rm9JPl/hRKVoAxhUU2cfZ8IDty1IkBnDIh2gUXtWH/V0YxkhHtsaFWVc8A64WXx4WnmQuELVZNBM/oble0wmvE9JcCKYgLHxFwEvoIsnnVo51DcCs5iyPi54iQmE0aAgiub2rTkdKJ4eo5P+prUw7GOnOIVtKaQb1CdG0lHceEYYX0F+6ol1RhJxUJbrUHpZQAKnI28BoM7Azxtu3wpNt9PIS/rInQ4HqKYyROA8+F8yocpMx7R+6d8BuneIZ8o8WgHzxasheTw+eh8mLXA4kpWMmc7pjJmPEdAXS2h+5dkEgGsaHAaufMf1mAzhRRYWtHgKiholH
 Ma9gFgMQ
 gHIeqLafWfa3F5IkSGtWvdI8odyuJsP4YJ+ArHlB3TrGme9etVJyhpYa1rQg6N4wRNQuuNh++vimPNRwlkRbm0PhqUu7k+4ViDidpMYUecyPOPeD7dJTWt26L/Scidx4Q63lFrFBZKueLEXIzYT3Mh1fL7Sk+2lzCF1KRhMdFWduMHnmVF0N7nmb4BxtHjlcd1SCqdXRMyrKalw9io4GwjmZnfF36gullhPZBoOOVX7VoDCVV8akILN4f2kKsVH68/Pv8guR1XsRqQbywmXkezAs3aBAcglqX5moFbzo0PdTwj3sDwd3UHAqH9BhBCXwYpqS5cD1SB0i/S3FgVKpCXeRysg==
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

Fix this by introducing section_nr_vmemmap_pages(), which returns the exact
vmemmap page count for a given pfn range based on whether optimization
is in effect.

Fixes: 15995a352474 ("mm: report per-page metadata information")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v6 -> v7:
- Refine the alignment assertions in section_nr_vmemmap_pages().
---
 mm/sparse-vmemmap.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3340f6d30b01..01f448607bad 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -652,6 +652,31 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
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
@@ -659,7 +684,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -670,7 +695,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -678,9 +703,10 @@ static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							NULL, NULL));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.20.1


