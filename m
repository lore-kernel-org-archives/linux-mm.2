Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDC8CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DBB66B0098; Sat, 10 Oct 2026 03:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC0D6B0099; Sat, 10 Oct 2026 03:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B566B009B; Sat, 10 Oct 2026 03:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61B186B0098
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:58:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2A61C07E1
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:52 +0000 (UTC)
X-FDA: 85305965304.13.982770E
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F3B080006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aF+b8d4S;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIpC3TTxDyvpOR8NKmtyMQLMyDufyxtaZeBdyCHZ6SI=;
	b=DkrMipnxeFdjcC1p27nMyAJt2nc5d4LW0ODptG/vqStBs6ahVImbEdAPYikX9ixr2i8ZiO
	WFIrLkK7o+4LYSP8ABA7cYQNNPlX0p7DtOMbMhUfkriYjvMtC8pZifJV2KfmubTROgKe2y
	izqhIJVYLcyAiMjrU9QaDDCuy34HgNE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aF+b8d4S;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619131;
	b=yL8wmDO/zdSWtjcQ6Dg/CZ96oT1XFiVYvn56OTLsS8JmxLYBj7MZ+758KSXxe7sit7BwwU
	QnGDo9PkB2ZIgH2z4SIqjrl1Xn091cGe+VuV8fShaq9wLgz9aTeDY5lvwi5otmFJr4t05X
	5SxmvwDPS4CppBoeX78fi8slrH0LCgA=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38759bcd877so220541a91.2
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619130; x=1792223930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIpC3TTxDyvpOR8NKmtyMQLMyDufyxtaZeBdyCHZ6SI=;
        b=aF+b8d4SdaJQE3VduhJH/uW8PPn7PjdhXIHLOIkoMb9IDCjbV3SLf1Z9ONENjJF0EX
         s6RkKwypTUG5Kg4a1BuWXV0hyumA8U7WR8Hs8mjNe52zmyDCToIr4RLFn9UV0G4XP2US
         NqEIcWBUVPl22A2p3GIz0+kUUWZ1TqaA4DAmkj9/pSs4bv+vAYc+gC4+cJT5e4HjCqur
         H2SpX0pJcAxdMsYIr+Qan9yuGeQfwqPBs4hsILbyJG7rNkeyefuK0vqo6YC4BJrqVv9j
         qGwcUdQIJdYQjJWBkI/Wg1c4CtTZpeO5LoOCTmsqTwb5r9la4fAe5qeegTJr5isKe5nT
         lFZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619130; x=1792223930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIpC3TTxDyvpOR8NKmtyMQLMyDufyxtaZeBdyCHZ6SI=;
        b=r8CJsVRuBkWHNdhPSpnnBMKnOLsUZLOg3M0MZnzU4Qk/XMSbyBi8uX2dRz3YJUaGKv
         6LFllvd5VY7E4kCwiU3QYXXX7GzEU9ASKcArHbfu33oDuIWspRVxPkRZblfT1UBPRmA2
         vB8g2Pem0oxt9PW3vW7SveCNCtNU3tg3vl5uAq/hLs5jdb36SqDTLT143+ULBWw/T4zu
         UhZyKNSbIUPG484IMLIk1zqZ4aoezEu56N025FVoW4MSh7TYNevt49yaFKJKb+tGhaEU
         l7OLBQWgbKoPxkXiku0qBmPBU1CSXfdHa61ERH/LbbaeFWz/bLJz+T4zy6toBU6MlrIK
         MR1w==
X-Forwarded-Encrypted: i=1; AKwUvBx9rmyCTbxC21Ngwkhnuoj5IluGhlI13LtGuP+f2JctmHRSPGV743MCFTPy34G5EuEXySVVaAmtCA==@kvack.org
X-Gm-Message-State: AFq9FYKCAGda/hEzZOMuMCcTdJHepN680ZYzweu3KWJDVXWcpOAKqHFg
	HjsbVSmfnuTMS2Jjv5h7zh/wU0N2aGEnJOXvQv8HMu0vgjfiiwTvaTQpSPe16Q+PE9s=
X-Gm-Gg: AYBFou1qzmSszlSTMBr7/Q1TxB5YGuJPu8dubepGZdRYvcy99M5R60AWz/L9ZuPUO2x
	grLhFAzYWxisPMcknAiQ1kvfEj4OqX5ED8BVOrLrRrR2GOM3Y4htMbY/azyYIgy11cxnqN8I80U
	Hm5iL/DigMjCjTcoiUjTP+BIxKZLZNx4RPsqAT6pWyz+hca5DA/u2ChM6JM5bv6vV9toB4E0SCe
	iKG55DrXAsRMrb2N1tc/9f7EElyndEHrUjeR47ocv8kH88XLqe4LYiyyu4bYTv0Ts6B12Bo48wz
	VKHeSodVOGmWXHzpkSeRGvWKpeuXiiqmKEtYtZf+jVM8f5hlBR363R5sxJxlE4/0dVKQ0j14zOS
	PFH/yf2zS1mPM4B544oXvCA0fWQO4FYEqLhwpUwO+nfgLBwmnyZK0NGpRFsR6pwig1EGULN0SLP
	nG7vkDiIZyT228QIVnAPx8RDWp/EwbNEk0azmq7B2MQg1CkcFI3xVy0vwvydy/iNfLoH1oSqXee
	p4fSG/xQpmnFq6nyKEtLruUFx5nbxvrAmxepYe4D5TbpNpn
X-Received: by 2002:a17:90b:2ccb:b0:3ab:17b6:9a93 with SMTP id 98e67ed59e1d1-3ab3afcdc6emr4054531a91.52.1791619129838;
        Sat, 10 Oct 2026 00:58:49 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.58.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:58:49 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v4 3/6] mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Sat, 10 Oct 2026 15:57:52 +0800
Message-ID: <20261010075755.83339-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010075755.83339-1-songmuchun@bytedance.com>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F3B080006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: suoasa6rd8kiscgt3dxygntjdcexppq1
X-HE-Tag: 1791619130-977286
X-HE-Meta: U2FsdGVkX1+ltN/27SgRiganE2IgXZ0xYgZizJpuDu6Xv/GoCEdK3FqHUikCbL+9wlA84JJcBuiBb97LgVJAohawijhO4TepsFfwZQs0NoL58CrHg0jRtjqiin8fG3jdyb1+Y6UcUgi3GvvpWzOV7jJCiE+O+gZ0Gb7d68kFAA2UZaABo+URgnle8YpuPa36s//n4pdIq+69D7HxeTY8rMFBh2OS7c+9EJRcQGkOOSeah1vQ/NoWDyYIa8BE7+Q+P8ds9T1DbrvONGJnMrcoj99NPyG/0zC9eO0wVrL58wD+6xUC5VK2nxsCqfT3UNJfiFfeIUdRWaOCHf2qbxksyRkPLrdlcUZ6qmCp5bG24Emsb4M1yGjz/WG10tNXxeGxzg3DbB4Wlb9+T5pFE5/VMUqLKknocKld4vM6k39ohea2edGhXISrjwXchkMBOs1vivM2RNDYD7Ct8v7nIljYrCMVr1qtAoVxEGzq+/VRuoOs44RkS4FQ7Yy2r9xaOGzROsrEcqRo+figI68MwsyIa/+Xm8HpgUvbQwYB10bcGa0KCtyNWFeYJggJAOPg6M0ngzNqtB3yWu2ByeRpVfYnKx+FlieX2VZAHK6s7jtOmHXQNIA9zYCd6QyXdgEuDjoRODt7xZ5vjedon3qMXsCw39h2pH8wQou3SyaRsW0NrsiN1nyZqGrW08QOp9zOsX1ZITtMKdVrkBRs5+Gh8+MxJIfBrQmEzCwspWy1/k3HvTujXsM/O/8iZHrLHAC1I04gCM9SsqTDHArkYkgRs81twwLXDZTqR0flxZur/DWv2ateYcLp2Mj+DvrNrBoG0og9RejraS77MQOYx4E9VLAhWDn6tHY4rcNB0j2Bsv2VgO9Yvn73PVmGL0I6+9qjg3zgUR3rBT5BnTk5uMhOpe2Q0rLElJ48k4cgX9NwES0B1RwnjW0ZlmPhtLmQSUBUSzLoRBj2/kVB34kq+EbYkTi
 zc7sO55y
 vaTxbQOXlysajBtIw4wDt64EWY7hBwZDY42MqNUlW20uRx1wh83Eu8wr4b7kXHbpbtPovI5VTyp9s3k1OnwhJTtrRSTZ6H9uuU1GBAQsNPg/mr6KWkHRs/EsJHhvOHX8P2+MODz1odRpAJgS1bgRBKOhznXxPY6bphQgTy9fa87AOR92Lsp+/5Mw/AjFQc4NZykuvfSEjz37L0PwDo7KsEH/aT8SuKXxtcTd05Tfo/7euJReotJtBkxSiA2t1vgl5W7RzdgT8+DIifGsZ26vwUzzSXPHQRnvXs28kMCS4t7/DJVjlqel1vlin2jgCTBaTEuWWWwZHgOPN6UdC2CF7sBgvvE3XwDQMfHs6l+NIceXToBBdWAESu7QS5qZdoqWzEKMmPD/mjLC3CjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common vmemmap path selects the shared page for optimized mappings
itself, so Device DAX no longer needs vmemmap_populate_compound_pages()
to find a shared tail page and pass its backing PFN through the generic
population helpers.

Remove the Device DAX-specific population path and let section memmap
population always use vmemmap_populate(). The powerpc retains an
architecture-specific compound-page implementation, so select it directly
from radix__vmemmap_populate() for optimizable sections.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v4:
- Collect Reviewed-by from Lance Yang

v3:
- Use the public order-based optimization predicate in the powerpc path

v2:
- Collect Acked-by from Qi Zheng
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |  3 +
 mm/mm_init.c                             |  2 +-
 mm/sparse-vmemmap.c                      | 71 +-----------------------
 3 files changed, 5 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index a3332f32ffb2..44868b62b14e 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1126,7 +1126,10 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	unsigned long pfn = page_to_pfn((struct page *)start);
 
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 56bb4567a494..1650d6bc1211 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1046,7 +1046,7 @@ static void zone_device_page_init_from_template(struct page *page,
  * initialize is a lot smaller that the total amount of struct pages being
  * mapped. This is a paired / mild layering violation with explicit knowledge
  * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap. See vmemmap_populate_compound_pages().
+ * of an altmap.
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
 					      struct dev_pagemap *pgmap)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 62327ac15206..270b5def58e1 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -503,71 +503,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-#ifndef vmemmap_populate_compound_pages
-/*
- * For compound pages bigger than section size (e.g. x86 1G compound
- * pages with 2M subsection size) fill the rest of sections as tail
- * pages.
- *
- * Note that memremap_pages() resets @nr_range value and will increment
- * it after each range successful onlining. Thus the value or @nr_range
- * at section memmap populate corresponds to the in-progress range
- * being onlined here.
- */
-static bool __meminit reuse_compound_section(unsigned long start_pfn,
-					     struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
-	unsigned long offset = start_pfn -
-		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
-
-	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
-}
-
-static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-						     unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap)
-{
-	const unsigned int order = pfn_to_section_compound_order(start_pfn);
-	unsigned long size, addr;
-	pte_t *pte;
-	struct page *page;
-	int rc;
-
-	page = vmemmap_shared_tail_page(order, device_zone(node));
-	if (!page)
-		return -ENOMEM;
-
-	if (reuse_compound_section(start_pfn, pgmap))
-		return vmemmap_populate_range(start, end, node, NULL,
-					      page_to_pfn(page));
-
-	size = min(end - start, (1UL << order) * sizeof(struct page));
-	for (addr = start; addr < end; addr += size) {
-		unsigned long next, last = addr + size;
-
-		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-
-		/*
-		 * Reuse the shared page for the rest of tail pages
-		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
-		 */
-		next = addr + PAGE_SIZE;
-		rc = vmemmap_populate_range(next, last, node, NULL,
-					    page_to_pfn(page));
-		if (rc)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-#endif
-
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -580,11 +515,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
-	else
-		r = vmemmap_populate(start, end, nid, altmap);
-
+	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
 
-- 
2.54.0


