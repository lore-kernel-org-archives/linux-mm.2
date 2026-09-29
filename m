Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08E3CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD096B0099; Tue, 29 Sep 2026 01:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84976B009B; Tue, 29 Sep 2026 01:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D0E6B009D; Tue, 29 Sep 2026 01:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5AB26B0099
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:33:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D29CA1C2A1A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:38 +0000 (UTC)
X-FDA: 85265682516.02.F853F26
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA9301C0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:33:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XUbpFN6U;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790660017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWQii0KU4eCZDNyN5Go6yzEsWjVyPkRiAzmEp1lyEhc=;
	b=znPLf5BLGjXrXTMK/QNl4UV1srSaK3bAqsnzFZpr5If9y4NIyInlZi+ek0u5LL9lhOE/xw
	Re2zFBQeh3vyppcfaoRuCbQHT3AhWg9wRPsWixOEs/GN+BrcWa9xD8remiudGlFZh6Wcuu
	Yc8Ph4hENFA+IcaHgFcvO/YLo0KX85g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790660017;
	b=vQ3DkcYxO7Bre8tskKgd95ivsaiW4feGpjTMPQk6Q7CA0+JIPb9h6A8Vt1fom2flvDz+Rq
	mj/6CoI426k6C1aPnnrdi8TVOGdCPwrfsP4Y/cW6L+3n2+U/Fp2GaHcv3IJR30qyWg8uhD
	qVxbpshGWWs4NnIVcHx3fNQP3d5VXm4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XUbpFN6U;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db18fe433fso16573325ad.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790660013; x=1791264813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xWQii0KU4eCZDNyN5Go6yzEsWjVyPkRiAzmEp1lyEhc=;
        b=XUbpFN6URoqZouVRSqokxf1x0uk2PTxQSL/U5aewad/B0VaXswTIwkdRy2JJK+bER3
         OOuWEYlD8ELT2TrGDXWDeDSzeu2iF9Ly7FyBtv9UcR438yju7V0r8SdasNqilERW/06B
         TUd3udP5Q418F344e/F5EpMLEwbTGIUvaowht0hDp98Its6oLXiflsB/I1B51CKpGGhV
         j3XCr+PcqKyPPdOVshRWvWiamZ3dAfIyPSXh4roM8lx3nbv0BtQGetLeboKupSG0zRDm
         phD7DGmwvjNHL/0qXjMXWynhZ+2WK9TvoNJ1ee9UdZHvsQJKvPavLM+kTJtFQX0qF3o4
         2mxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790660013; x=1791264813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xWQii0KU4eCZDNyN5Go6yzEsWjVyPkRiAzmEp1lyEhc=;
        b=siTV5bu4jtNq7xEuJ8OWlyYwvTj387lOE6MX2T4bzh1F9O76fyW9Wd2X268UFDWife
         pJXX70HEqDUAG/hhv0U/dK18piGgNrx+8AfA5UZDcxZtOd2nqf424IA9phN2D/1EPrTH
         Kz6aGe5jo1G4SBc1wba2ckTFuxp+V2ItRDtzkH9491/OGxaisUsKkw/O5Qv4zRvAh2q5
         BbLxWSpcmDAx4E7Z9prP19ukpOY4Se09/A8OLsi4CcCNzO0g6MeW/XFrD8kFUbokESAl
         P1iuETue/xxwcJXUt2JLYGTXjOt8e3nHwU8FatOYLEqQFk/lKT/rWUFG00oForHicRku
         X+xA==
X-Forwarded-Encrypted: i=1; AKwUvBzfa+eT6KFeGOlUZa6gZ++p6/laS2XP21J71OmT/bla6ImHzXnbjySDwrMPctNebzMzlB76t6pYeQ==@kvack.org
X-Gm-Message-State: AFq9FYIz6X5RFA1l7yq5CRWGnn1bBkEOycZtogsIeBh+wAmdp63DBGPO
	YhJgn3WmrbNKNzvGV9dHD3oQdIEAFHy+KYkuiVd90hQTS+XGpq1s0EfUJbKj7Ze9Vc8=
X-Gm-Gg: AYBFou2+XLT/VTRyDzVVSAWpwWvkWlF5ip+qYjaafAZ+IPPdIFqWNFjHVcu1FicxBkH
	LXE5wW9wgzHrvUw9RA6eLghcGqwGntITD9YkcviRtFumZsXq3J7cvdQ1YpgmDrTKBSv1L6KOb+S
	vqTiopqeU48AvHkQDV93NXePAOBStwmsXpINvkXMJwFxJOe+EGDFKL5Pviifx5PjSIg1LUhCzh+
	GSFjFBMVpA4VSr4kb1ynMqcA2tn6wm88uAbsrYD6bqHF7lhFR4TB3xPnhkgdatdSsQsfxxbWIuR
	b8I+Sjqp+DnqfFh2VmIiVbGHByZ5SPsTR4IKWslt+UZGmF+BG06MVpwFhzYpOtsz+JTEgcB1cRN
	y1N8EayHmak/WlwF5SiQ9L89z+3rdBt685+steU9gkglPB4XQFgTa597dXgbBrGfNNXLJxoEtea
	czDd1BKpZc4XY98ekgXS1Pooec7Oppfvl3vQu4+sqhmOrmsNDGi1anrIdq6Rshg5AB9QW3CklE/
	VFIte01ZFZN9KK8yI8=
X-Received: by 2002:a17:902:d98b:b0:2df:8ff9:514d with SMTP id d9443c01a7336-2df8ff97286mr102857185ad.62.1790660013300;
        Mon, 28 Sep 2026 22:33:33 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142bafesm49251765ad.51.2026.09.28.22.33.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 22:33:32 -0700 (PDT)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v3 3/6] mm/sparse-vmemmap: drop Device DAX-specific population path
Date: Tue, 29 Sep 2026 13:32:28 +0800
Message-ID: <20260929053231.66085-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA9301C0004
X-Stat-Signature: zs4zyjny7cm33eyfb3mpazp573dheu1y
X-Rspam-User: 
X-HE-Tag: 1790660014-909958
X-HE-Meta: U2FsdGVkX1+WOXyqh9XaY+jKx5pdqBJXb5Mt9FlvfEkSjvm1tIK6pdnVZAnOHdLaezgNbxjUAF5F3MDXfaooSI1i4YqHTtMizlfPeGd+cymbrfVAUQuVmb+7L4mrsATSUoQX7upM9YgDohHxGVRgmPv4V8UUBUWIuavh9+NhS7y8him5n6WylndjCoFJj9P+TgoVylQbPxDmjCMo+gB2i52kB4U317JlSx2tiaQxjsZUl2ilFL5q1q3GXP4nyA1LlcDJ1MYGAmhkRhW+8h9nn7qztntveJxp//ILgky3yFyiqJhcLF+/lMQPtbTF4tkD+Qoo1afGRGv0QIC/lHtlMo3FGOKSEcAlrhVKH9wZ/byiPJdPUFGxZtedXnH+yvTKZljEmkc/p/azJm3Gaj9GzXS80THTPD8HD2K0ZfL4QtPXiPNmWPMIpve9b1cMesqYQcyY/J0bJ0+YxVUN/tXi/yuOnj0nsKdk7NRRBJJMw1VMb8uSLjGcTMJ0vYvEBpboibipX3CT71h6cNwKUkyBQuhwL6o036vuGo9vQeCPCzKvDTW8NxWKfYHq/WxeKaIryoLVrW9dJ4d3bQtjwg3E8TNxxl41S19yCqDrNDfs37rNN1TKMpjZqac/0rdK2K8NF/MC4wAaI8VduaH01CXLe0o7SlfrL2BJSaVvtbfrAXaDRn0jfc7AZ8/QtXfFTTv5hgrc+/ZgwA8QII7VvqGlb40IFgGnQzmnzEiEhOLU0A1/zDNWn6avbGz/1MQgq5FKNOcNFNQbSZwBkfJgixpxnSv7+ESzV5hnpQrA6rxzS5GoBZKoO0FLKl+ggHFwlZ25OPYyi3jEvN4oQsMIOtoJo347YCkFA2XjD8+mnJorE9vn+vMPDLCk1Myv4b6agx7jIKZCZ+QfMXphJH94ed9a8+6WZg8GhhpEdlshG//oX1uMJdNRbjfQzhrCGyPI+pkqVZqT3+kFjS+tV8y7+rU
 uRn/bdAc
 CqfOJlX6wq3gUeQ/7Rx0BXWSnJ/BLfDpOM17PYSFgtZuE1B4LCQFSe+0dcuYVtnhd7IGqCvwyQJLVAI9ndhs+DCYw20NH+AhFDttiD3yS0Axsyl4iXM2bfvi8tanXIiHPqoJS3YfOpv9NvBg7cO8oG4yPzw1WGlj1kNmyCwCaoTlu9bdATJBIEHAhXwc13eAW4RWmIBzaqnkGabGI81ZlRRY0aIzSKNRrz2Hd62/sm0/MqCA6OjByy1tq9deTjxeuusHB+w8GyIJEZzk6NeDlcgquisJL20JjL4AqqrZqU4ZWRBgtEGuvV+TyXWYUqo5v5jhBJJBEmZ1qm5O84716Lpzf2CrKiPzb7A42eynNUTbLN84VJJGhgi8+BXPDhT59kKaH
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
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
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
index 9ca28e4a610a..fd13fa91e5c0 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1122,7 +1122,10 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
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
index ee4c113ca938..dee95e520376 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -499,71 +499,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
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
-	unsigned long size, addr;
-	pte_t *pte;
-	int rc;
-	struct page *page;
-	unsigned int order = pfn_to_section_compound_order(start_pfn);
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
@@ -576,11 +511,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
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


