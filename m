Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B86F8FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5AA6B00CF; Fri, 27 Feb 2026 14:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F906B00D1; Fri, 27 Feb 2026 14:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33896B00D2; Fri, 27 Feb 2026 14:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5706B00CF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E2741CC0D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:29 +0000 (UTC)
X-FDA: 84491260938.12.3D64A41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 398A91A0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cZMXUhud;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTPmwpsDPASdtw1h6vwcNqa/CYS8v88cJ6639RNSh5c=;
	b=FLkF9HQ8iCOt2GbvA6H87Y00qsObID3k4gD8pgnk/FS+efyFrCd4ObNPbLAT8TexCs37I4
	/8PnicJ+VUcCJuBNpOatUt398el/55Rw5bWVZNf30F3ZPSj2bnfNkP4mIZwM+712dgJWm2
	iFoVe2pvNGMmqjxaTLdQFjUBaQhS4LA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cZMXUhud;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221407; a=rsa-sha256;
	cv=none;
	b=qur1DKYCMWaHPzWRp3SiA6hDMk1z5GdBF/NC2ywu/JRGy1rPdacNJ8s9m25r2VT/Qh86dO
	maf14zz46DzwTkiG4SkBLz5HymeO9G04Sb9YGhlXxqJ65EGsf+rWSK0NxfH4q1D6oX9EI/
	Qi6VX6lVXadmsROWKEEJw5vpC/oGM30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BB88446F7;
	Fri, 27 Feb 2026 19:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F61C116C6;
	Fri, 27 Feb 2026 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221406;
	bh=TjFPR2A/aXv+e4Iy4206wqwlc1GWuPYPZlFrvQnaoZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZMXUhuda6GOzaNF9YFCptyk/tFpWLu++oylktkDw6IL42fJeo/aFySRy1r1clCrv
	 uXdmVLbvRHoCMmgYRWJcvHath2q5Os/S70kwfPejbq4IPpQ7eLmxzXz9UUEcLjqWAE
	 ADtzO1ptKHd3L3rAtZd1x8XySafOWGHxVMOkyh2cpVPT+Gnv1C5bSE8kCb45TFH8Nu
	 0eoPqLIKYy+2/GlPCaInqEgCwg5YN+4gedNd2hl34wJs1oOL/ox14ON2jvshbmiL7d
	 sVa4WPf7Rqj0uWL4gULxt9bAUy7Ij8QSTJRpgJKiDdIEhLs0rWsTh++XLbCjvTep5i
	 aVa6IyU/bfu7Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 719A8F40069;
	Fri, 27 Feb 2026 14:43:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 27 Feb 2026 14:43:24 -0500
X-ME-Sender: <xms:3POhaTaV5qr1Dj6LrI73poFsF5MnZp0E0zS2w4i1bNrRwbL_OnMlGg>
    <xme:3POhabkVtZ8NNq0MCTEei1azPgsugLa3SXanDsHcAtLqNYyL9TxQekexrvvTnDPlP
    Q7g4i6rXPRlUQw_UWn1Ssllqx6gh9WPa4AImG-seYA2n4cRXfddMjw>
X-ME-Received: <xmr:3POhaQFX2COO-B-ksJC547izPqWeJpI9pL5-7pSFM3q1WsCSNrBqJm1y0-C2OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:3POhaahEV_GlAj4RgkoNqwDtkUjiH9lXQVDZxo8DvuxFLrR_kDv0QQ>
    <xmx:3POhaakVcgmSOq2eoQYglnJAYs0b972EnoMKH0H03BSi3cv-HzCSCA>
    <xmx:3POhabeSIIdnrf-_0AkbMBQ-aJhLqUBVx4fmaiHgUFEz1sH9Z9S6TA>
    <xmx:3POhacFJyOsaVP_SINusYUcCiz-9kY6XA0FXdgvdHz4XRFTIZOqarg>
    <xmx:3POhaVetfiC8GufnHJ9FOP8LQG1tagWrdQmt2eYAgD6KMrQIp6Qzgyc0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:23 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCHv7 09/18] mm/hugetlb: Defer vmemmap population for bootmem hugepages
Date: Fri, 27 Feb 2026 19:42:47 +0000
Message-ID: <20260227194302.274384-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 398A91A0002
X-Stat-Signature: 7fiag5t49t6p5ejotrhwejw7jg381iea
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772221407-633348
X-HE-Meta: U2FsdGVkX18gtiyxOVWowUObkDYAwDxWKBVuqvuEgYT1JBJB08PUAtwRg/mQWzc95LRnYtShLkqq12jl+I5s/mMZEQTDnKgM/RwceTqszkW4j4As5NS5342jFzBXQyKlumzsYt9eopWr2+5eHoc2bdjTKz4qq6TJa3Vpnbzc6DY89CCJCdFYB0gXotkcz+BP64Ie9nT4b5ZzDcGn7535/pHmu/tfWGZ2nAV5z6aSzCliv2sQA4WFezP9PB2XAaw8dWB2K8UkP11oMYGb/wBIe8hxLZvfq4EogFGH1OD8n9R3rfTkaLetLW4vwbPOJ9G2V5MMzuADzclIqd806mbV3JR+OGusJMTPyZ4OyxlplOBnRZqQ4SShZMv9hP2/YMBWtIJlFpSYyALCEbpar6jWH3bRDT9jOVeDkk0GqfYu/IMIQCoqKLNebmEIZpOnJjDSCExrzb9X+uMa4owMaCo3QeS0sDP59n89PJjQa5IOKQBwIoTghBW9oPAZ8JRt/Uh/DMrR7P3ZS8absYr2P3IEKIJuNcff5EKVt+88Kegw2dxnRmS2m9E/pTUI8u88FLUCiSOU4xPV37qxk3HVzZyyOPhIFsbj5fYJjMbTlQKUgGHSg1oGBWPZKySHRbm2H4hcR3SCR6CxbBjK8jvKka8GtmhqzrQ/BzIhIzAU1E5jaLNVSS1jrikPaLlqU4isd6zAo/hGyie2h+d+wCJUq2VVchrqQlhdrRoyvPIsD5NatsCXGYDKtiLOr/rmiySQ8I5pTpO7UAMmYIKyrZCFEdUUqwNWpsqUqDrSkQXqCJhpDFhpxJkh/FWDwU4Uy1dynlPVzgbt/4bYvzLUatyu0T0CWis3L32D+wSlk8NhNVvosMoZrDxPoa7Us/R8zpquPsWX38N5j1sgtOylAJ2GReDtJlpsgW24Fj3sDiVI12FGRzGgjTnwD1UMBYIAT+t3zsgwBTpAO+4UtC6qJsrbULE
 lQ0xP8BW
 xXAWRpSH0Y7vY8tWJDIMFepdXKb97YM8VN5bjKpYzLpOV3l176LuGnOQUrNvkx737caaVJWc8gLweDfLoVQHRgPumIP08HpG8fuShdiFtMcKCFGbDykllHPUX5JgZBwagxa488EfLxB4rGush+IRunY8UHiEEnIi7x8aq3tnCntUh2mw6yi+U5ot66z4v5iBgNculXzBjbJ+2esIw/PTvBZMDbBv/UhV1WJCq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the vmemmap for bootmem-allocated gigantic pages is populated
early in hugetlb_vmemmap_init_early(). However, the zone information is
only available after zones are initialized. If it is later discovered
that a page spans multiple zones, the HVO mapping must be undone and
replaced with a normal mapping using vmemmap_undo_hvo().

Defer the actual vmemmap population to hugetlb_vmemmap_init_late(). At
this stage, zones are already initialized, so it can be checked if the
page is valid for HVO before deciding how to populate the vmemmap.

This allows us to remove vmemmap_undo_hvo() and the complex logic
required to rollback HVO mappings.

In hugetlb_vmemmap_init_late(), if HVO population fails or if the zones
are invalid, fall back to a normal vmemmap population.

Postponing population until hugetlb_vmemmap_init_late() also makes zone
information available from within vmemmap_populate_hvo().

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/mm.h   |  2 --
 mm/hugetlb_vmemmap.c | 37 +++++++++++++++----------------
 mm/sparse-vmemmap.c  | 53 --------------------------------------------
 3 files changed, 18 insertions(+), 74 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7f4dbbb9d783..0e2d45008ff4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4484,8 +4484,6 @@ int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
 int vmemmap_populate_hvo(unsigned long start, unsigned long end, int node,
 			 unsigned long headsize);
-int vmemmap_undo_hvo(unsigned long start, unsigned long end, int node,
-		     unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a9280259e12a..935ec5829be9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -790,7 +790,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
-	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -808,14 +807,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (vmemmap_populate_hvo(start, end, nid,
-					HUGETLB_VMEMMAP_RESERVE_SIZE) < 0)
-			continue;
-
-		memmap_boot_pages_add(HUGETLB_VMEMMAP_RESERVE_SIZE / PAGE_SIZE);
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -850,28 +841,36 @@ void __init hugetlb_vmemmap_init_late(int nid)
 		h = m->hstate;
 		pfn = PHYS_PFN(phys);
 		nr_pages = pages_per_huge_page(h);
+		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + nr_pages * sizeof(struct page);
 
 		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
 			/*
 			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and undo HVO.
+			 * Remove it from the list, and populate it normally.
 			 */
 			list_del(&m->list);
 
-			map = pfn_to_page(pfn);
-
-			start = (unsigned long)map;
-			end = start + nr_pages * sizeof(struct page);
-
-			vmemmap_undo_hvo(start, end, nid,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE);
-			nr_mmap = end - start - HUGETLB_VMEMMAP_RESERVE_SIZE;
+			vmemmap_populate(start, end, nid, NULL);
+			nr_mmap = end - start;
 			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
 
 			memblock_phys_free(phys, huge_page_size(h));
 			continue;
-		} else
+		}
+
+		if (vmemmap_populate_hvo(start, end, nid,
+					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
+			/* Fallback if HVO population fails */
+			vmemmap_populate(start, end, nid, NULL);
+			nr_mmap = end - start;
+		} else {
 			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
+		}
+
+		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
 	}
 }
 #endif
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..032a81450838 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -302,59 +302,6 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
 
-/*
- * Undo populate_hvo, and replace it with a normal base page mapping.
- * Used in memory init in case a HVO mapping needs to be undone.
- *
- * This can happen when it is discovered that a memblock allocated
- * hugetlb page spans multiple zones, which can only be verified
- * after zones have been initialized.
- *
- * We know that:
- * 1) The first @headsize / PAGE_SIZE vmemmap pages were individually
- *    allocated through memblock, and mapped.
- *
- * 2) The rest of the vmemmap pages are mirrors of the last head page.
- */
-int __meminit vmemmap_undo_hvo(unsigned long addr, unsigned long end,
-				      int node, unsigned long headsize)
-{
-	unsigned long maddr, pfn;
-	pte_t *pte;
-	int headpages;
-
-	/*
-	 * Should only be called early in boot, so nothing will
-	 * be accessing these page structures.
-	 */
-	WARN_ON(!early_boot_irqs_disabled);
-
-	headpages = headsize >> PAGE_SHIFT;
-
-	/*
-	 * Clear mirrored mappings for tail page structs.
-	 */
-	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		pte_clear(&init_mm, maddr, pte);
-	}
-
-	/*
-	 * Clear and free mappings for head page and first tail page
-	 * structs.
-	 */
-	for (maddr = addr; headpages-- > 0; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		pfn = pte_pfn(ptep_get(pte));
-		pte_clear(&init_mm, maddr, pte);
-		memblock_phys_free(PFN_PHYS(pfn), PAGE_SIZE);
-	}
-
-	flush_tlb_kernel_range(addr, end);
-
-	return vmemmap_populate(addr, end, node, NULL);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
-- 
2.51.2


