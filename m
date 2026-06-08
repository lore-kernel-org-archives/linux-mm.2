Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB31CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65326B009E; Mon,  8 Jun 2026 04:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF666B009F; Mon,  8 Jun 2026 04:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68C36B00A0; Mon,  8 Jun 2026 04:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9510C6B009E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:35:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A626164C5B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:23 +0000 (UTC)
X-FDA: 84856086126.03.4F5CFE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0CFDCA0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HGRFKGFA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTsyEmHKpfx3QY2xerCkWdwHjor0zxZF5cs8sc/X2mI=;
	b=ivWUc8oIbt302Gi/LsgK5cxs3nQk7X0FSRYN+cPgvwoOMJlavimDSo1FDn4A6u4xgLgLHl
	lghh6QzU/0FmFA922gDSV7Biw/vD8HS3/cW/mQija1m5T+T6BwzZ/KxRdIJKxjUTyxNUwR
	QCOgFFO1R76K+HJAHAjHxtXid1ycsSc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HGRFKGFA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907721;
	b=BVP49EbgFYAGVoqkrk28Ut8lmVjYtI13FZu92VLhH3F6IXKlY5iFObM8+eTUpf3dsxoIOR
	uDEY9hi3P/8k7gU5kHkZngrsjDwcBXoQdcrJ/lMIpBsN8aaIOnsNv/TRBgoJnts9Vj09Xp
	F8w1uIEQtQ9msD3eGPJ+mhBYH+9fnFo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QTsyEmHKpfx3QY2xerCkWdwHjor0zxZF5cs8sc/X2mI=;
	b=HGRFKGFApOfq18NwQKmtYNxiBhOw8LdW+qFXo6OnpwQTfwaK1gjhjMEw/OlpT0twdhnAf3
	0nlcbzBrQs2xYhsmpng9/Mwg4ca3t/BOrftwsRJHJtFfrkJ3KDMVcbxWUdojRq7YpWrOXs
	fkc4+lO/Po4M+7dyoumIh4LyJc16QFo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-7nj5hELXN5iFvFMU90ikzQ-1; Mon, 08 Jun 2026 04:35:19 -0400
X-MC-Unique: 7nj5hELXN5iFvFMU90ikzQ-1
X-Mimecast-MFC-AGG-ID: 7nj5hELXN5iFvFMU90ikzQ_1780907718
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b5d2e394so29560405e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907718; x=1781512518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTsyEmHKpfx3QY2xerCkWdwHjor0zxZF5cs8sc/X2mI=;
        b=obAmcsgDH9tko2hw+Z2XeNK7EOnv1jnTeNqbW9TlvmRRa/O6feXtsanOIeJ0sqv9ZP
         Kc/+9AhYeAJ7xdNWnMGzf87tENQTBVl3OqLz47Rct0zGSy9DmT1z9mskiz/1PT89Q5j3
         apNiX0SBwTlsrLPquoYsSNkZqDb/OyYkA5gYTKue9RqR2I+Xa0mshCVxqveCBWoO+Zfc
         iThYYQDYRyr9/IBLcr1UPyJavmuatF6BG7LTlT+A6aBigatb/oep4j4j1eGQ50FIFK5G
         P34dvu8KMj0o67RGRinuXjBPc0bSuFR18da5bRoWPJh63HDeI2+RyWY+fbVK/BcZNknk
         qMnw==
X-Forwarded-Encrypted: i=1; AFNElJ8C726+Teb142XKcDO2jhXoinQWfYU3ivHM663/DP2KySAkLoVFO98ZhY5cReZmknYbMB/xf+wQ1Q==@kvack.org
X-Gm-Message-State: AOJu0YwhJj7guzDvw62GhIkqovfeRNg1uTaP7EybSKHp4NM1K5huiuaQ
	a/CeHbzGEzr6PEg1cN3sAGd7YBP7R04ZpxIcg7dtGvgiwrMusgojPSjM32z6FuOpEfp7QNwBeRd
	G/h7ImhGs+SVKwXbvxXrEVvHNWGhdbifVos3omDlNebw4lmvMDNqU
X-Gm-Gg: Acq92OEQ0E5P/AqVKFyiffxcwPNPxfubaYQDBnIzAnrbUbS2os94d7EhtvCb9h9K787
	l8DuKA7cpnjTt8jGU62V0TLGlHfoigDFuHz2W1IgFgCODE6j6s3f7HNJBcbkqdHvBUvd0j59SW0
	2hY5wvR4r1J1MSRcdlqQ1noJIkodenashCI8Mlh3ypD3ByQpNwz36EUYCex0I0dY5gHra3J30Lt
	+awIfr/Rpvm+wFPXHZW9dcM4HgzgWUhhufFc2tzbRXQwJvNBXUjY+WXb3GAvI6yEYyi8ofL1qM4
	eE5TX9X9dGOuiU7jTMflJB5t4ymXCKjuQrMBXMUqhZNhhvVBBG9Zvdl7ElTp2cLZb0i0RkrOYPT
	cF1zMeeusN3sLONAQRCJh4TE=
X-Received: by 2002:a05:600c:19d3:b0:490:48df:2793 with SMTP id 5b1f17b1804b1-490c25fa410mr242690835e9.26.1780907717919;
        Mon, 08 Jun 2026 01:35:17 -0700 (PDT)
X-Received: by 2002:a05:600c:19d3:b0:490:48df:2793 with SMTP id 5b1f17b1804b1-490c25fa410mr242690165e9.26.1780907717394;
        Mon, 08 Jun 2026 01:35:17 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d37edbsm282225125e9.2.2026.06.08.01.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:35:16 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:35:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 06/37] mm: move vma_alloc_folio_noprof to page_alloc.c
Message-ID: <5a3034dc7b3d5ea1edcc8b9baff63c980b7ae434.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GmgiQO4n5pWAfjIPcYBJOQPTxHW6xpgG3R-DhpQdUi8_1780907718
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wp814co11966udqnqswxg43kgp9st6x5
X-Rspamd-Queue-Id: 0CFDCA0006
X-HE-Tag: 1780907720-84826
X-HE-Meta: U2FsdGVkX19lufRuHxiJOQyOfshlcXhYuFkbRUzE419X+sumHYfECP+LKoEAWhS+KKhguzdHQMaxTGFt1wcc+/uj64EN2phyulvswJOGtViNSoCeMTJl93aNX33d7xWOCPl8X3Lt5cE1yx0CLC+Vie+ppGyZBwvyTLgJaoLh3j7RpCivbz+AQMYXmR74BdV0wgOE9ctBlcgwef9CmebvrPMrQ3SW/ujnC0T4Iwvxu1lthtTmNV8uuLKn2CYAGVGkmcwj9vA4fouZ7kXqI7u7LtAt3bC2O7maPuFQJylbhR6Cqa3HLYwT8M79PzqR5gPIte4JjDdekg+v+q3ngV+WNVwo+YnzSziS5XohkV33/Lb2BjZ6b3/44ku2dX59coeoGaQqMh+0dLLLwbZg3fiY2qGyy8cVTPAzKWydJCKSRjVeeeYoRoHbPao/TfloaWWmwU6fSfD1Obh29G0AlQrx7WVO8JVbaWtIs1idTPwqM8JhSm8VxflEsABbNBGRlg6vlbhNoURQ/CfnU56ohSH7ipOiBwYub+/Hi9AAMTwQ4i+Rj0i6iJNdHTtZUssZZVS1XEb5DMG1Cc4Yr4RgyWGu2YVgn2AdMHhSYVprm8QLZNRvwdVX2NV06TzleilvVwRb0q17gP9uUZ5TSPhGttIk+g0/jPzwwdv1rYEgs5yLsWdh8kGMORvXq2THmtguDj5CIaYF5SHSqPIF5VsDSLgfvn43krptQk3mCTMIINTXvuIViYTIAbnr9Wm0nG/8KvPxvSsoHV9wHDZa5VM90+tL3w50R7CozgDIRmKldmW3oVdLCRNd6JRrulhoVpnetBF/649U3vwMGAfRAlS7MqBqkB0f0dltRt1BKq+zdi1VgSsmz/cLwCMpgsOg26q40+mg01gNTaGAePy59Ct1mSjrIQcUg5gnz3vmE+3JGnngVoyBBo9D2mCHe/ikSIhp/QTaGDViznUKVbQI8T08ebF
 jyz9bwH/
 yx+LI0nSLF1K9x4UGU3a39xH578eI0IMXJ5etwx48XplwTooPUm7mS7T5YBnEPRL6GG/fjqhbsDrfD0SqcosSXei7rCVQQy1rKMMJNH+Hq0alWQdzxWWjggdh6lobiB9KpmxIcwGpWsOpgOrwUGLym4aLfy4XjyqjllsEn/u9+TkGYn2JHnVbKMNzQyl3g0E3KJqIuM0sIS/asZaqxBu46yKb4BFtdH1Nj/Qw6PCsokQ8AZ6IjLtMtBanYMkc/T4NrEoFCSZDuhBFm/2armeSTdrRQGHohELfxKXoH1/9J+fQ1zlxnGNaaYqYjEMQ1uElO9a03HDwCplk8Qw+DQurX8g8fa5yawqPgwPhp6oM97diCrS45F4NJ3lSjU0RfWQLUoJOO3OiQElw9s93z6tdrvZJnrf5K6Lclal4AsiLW3F7MAAu442ahSTU2wPqLKlnIggZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move vma_alloc_folio_noprof() from an inline in gfp.h (for !NUMA)
and mempolicy.c (for NUMA) to page_alloc.c.

This prepares for a subsequent patch that will thread user_addr
through the allocator: having vma_alloc_folio_noprof in page_alloc.c
means user_addr can be passed to the internal allocation path
without changing public API signatures or duplicating plumbing
in both gfp.h and mempolicy.c.

The !NUMA path gains the VM_DROPPABLE -> __GFP_NOWARN check
that the NUMA path already had.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h |  9 ++-------
 mm/mempolicy.c      | 32 --------------------------------
 mm/page_alloc.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..7ccbda35b9ad 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -318,13 +318,13 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
 
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr);
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr);
 #else
 static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
@@ -339,11 +339,6 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 {
 	return folio_alloc_noprof(gfp, order);
 }
-static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
-		struct vm_area_struct *vma, unsigned long addr)
-{
-	return folio_alloc_noprof(gfp, order);
-}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d139b074a599..a1707ad498a8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2516,38 +2516,6 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
-/**
- * vma_alloc_folio - Allocate a folio for a VMA.
- * @gfp: GFP flags.
- * @order: Order of the folio.
- * @vma: Pointer to VMA.
- * @addr: Virtual address of the allocation.  Must be inside @vma.
- *
- * Allocate a folio for a specific address in @vma, using the appropriate
- * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
- * VMA to prevent it from going away.  Should be used for all allocations
- * for folios that will be mapped into user space, excepting hugetlbfs, and
- * excepting where direct use of folio_alloc_mpol() is more appropriate.
- *
- * Return: The folio on success or NULL if allocation fails.
- */
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr)
-{
-	struct mempolicy *pol;
-	pgoff_t ilx;
-	struct folio *folio;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		gfp |= __GFP_NOWARN;
-
-	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
-	mpol_cond_put(pol);
-	return folio;
-}
-EXPORT_SYMBOL(vma_alloc_folio_noprof);
-
 struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8dae5b3f5876..6a605d05e8cd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5286,6 +5286,49 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
+#ifdef CONFIG_NUMA
+/**
+ * vma_alloc_folio - Allocate a folio for a VMA.
+ * @gfp: GFP flags.
+ * @order: Order of the folio.
+ * @vma: Pointer to VMA.
+ * @addr: Virtual address of the allocation.  Must be inside @vma.
+ *
+ * Allocate a folio for a specific address in @vma, using the appropriate
+ * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
+ * VMA to prevent it from going away.  Should be used for all allocations
+ * for folios that will be mapped into user space, excepting hugetlbfs, and
+ * excepting where direct use of folio_alloc_mpol() is more appropriate.
+ *
+ * Return: The folio on success or NULL if allocation fails.
+ */
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol;
+	pgoff_t ilx;
+	struct folio *folio;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	pol = get_vma_policy(vma, addr, order, &ilx);
+	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	mpol_cond_put(pol);
+	return folio;
+}
+#else
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	return folio_alloc_noprof(gfp, order);
+}
+#endif
+EXPORT_SYMBOL(vma_alloc_folio_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
-- 
MST


