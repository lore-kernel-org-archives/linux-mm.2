Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3586FEFB7C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0266B00AC; Fri, 27 Feb 2026 14:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E5A6B00AD; Fri, 27 Feb 2026 14:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F9F6B00AE; Fri, 27 Feb 2026 14:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C87A6B00AC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E009AC2D3A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:50 +0000 (UTC)
X-FDA: 84491229060.30.3E53E69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E13FFC0003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BdmRdbXP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTPmwpsDPASdtw1h6vwcNqa/CYS8v88cJ6639RNSh5c=;
	b=ch3d+giVS6QLXY3GLYx1No9ce2mSgZUHmhGK8dZVnkwmsOwz1kOn0naby5v7i2r6ZBO010
	qeTF8Lf/ySiXKZTChpDN2ClY8g++adLcQetvwOLxIhN+EblDkKYK6q6fgIA1+lGNoA8ZFn
	EfDdXe/De5sMDWmAEXWJq2CdLxCXfuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220648; a=rsa-sha256;
	cv=none;
	b=pUogjZtONeuo3zXNRBRiAToRXS3AX5wgQUpefIoNpeWvigRsHZp/Nhf+z+yhE+tDV3KP9Q
	lZM32pNt3O+7FhzvrhPJmDQJqpPMfrAZcMZDmNW5wB+nLmFYxVaiA6dQP/P+RRHHboUoml
	HWuNe4fuTj6PPu3Q9K0f/2EbEfPGPK8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BdmRdbXP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E5246013C;
	Fri, 27 Feb 2026 19:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2552BC4AF09;
	Fri, 27 Feb 2026 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220648;
	bh=TjFPR2A/aXv+e4Iy4206wqwlc1GWuPYPZlFrvQnaoZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdmRdbXP+RPMUt0zk9rEa9hQFxuhSdPcQxFkvBfdmQfY7BeYBNXJw8ug/aSzVr4wE
	 VZAqu2ZznoJGFK2pe3L1ZjCqqCSDE3Yzp2WJK6+z0kICbLNVXbIDWyyoO8UdBjQwJU
	 iKJ8fe4J/oui6CnIJga8g9mCiM6yAPxdXrmQa3WS2Vv80EJaF+BFiYzyEw/bRlAeFe
	 6RPr9znTPh3bmukmzmOVC3SPSAj2/R8YYU6RZXWZ1/0S3VHhOS7sYxc3deQ+6srY0i
	 OlNavriCJfv3D8kn65od8a3gbG10nhCBJbfTX5Yy5vlk28Z4cCDdRHqW7k7W7ItR4z
	 4T9ur/IxMEyIw==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.phl.internal (Postfix) with ESMTP id 450D4F40068;
	Fri, 27 Feb 2026 14:30:46 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 27 Feb 2026 14:30:46 -0500
X-ME-Sender: <xms:5vChaas37lCeo03y0kuZeDbEXCt7uyi4__EgqCKxU28opIbJzWJDfQ>
    <xme:5vChaYpfxmbE375Sj5lL2I1JoS1XLx2O_pvVSpzk1roJ3MaRW3tq__isSZlpmZ1Ku
    btAvQQQNH2aU093h04UAGU6cJunaR9Frb-VRWGLFaBnKrvwxnr7cww>
X-ME-Received: <xmr:5vChaf6KMrnTNXpxwmlxkCSPUfiVr_qMBJBT1qx6bYg8H3ywAUdbGaAQFLGnvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
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
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:5vChaWG1sOaaUqkDujw0NKs4nOi4WEcTnwM-40iPQ-OVa1dQ10nPgA>
    <xmx:5vChaW5KWTTZltoDT9WZjxUkDSuVPLZFcrVtQ4hoxLz_vFQFYPko8Q>
    <xmx:5vChaZgIlwBQK449TIjzftWIYpJP4HSSxD7qFI2AkbBryLVBwLf5VA>
    <xmx:5vChaY6gjNoiJTkMSy6Qt0wkudl9kmCg2AQrTDQu4_XHgyzS-rqsiw>
    <xmx:5vChaaDQD_tOJHyCXX3lL9pyaucAIGXqgQr-zZW51fwD-kymJk5mdMLr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:45 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
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
Date: Fri, 27 Feb 2026 19:30:10 +0000
Message-ID: <20260227193030.272078-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E13FFC0003
X-Stat-Signature: 7fiag5t49t6p5ejotrhwejw7jg381iea
X-Rspam-User: 
X-HE-Tag: 1772220648-3981
X-HE-Meta: U2FsdGVkX185AusJ+3LcaZ9jJ+mSoc1bDmeYuA2OSq5PFjUviLsuHlYK17NVbALYf6InYmzS4Z/QsNSYU+2e/6B3xQ9Ox1ZppQO/L32Om3NH/jdH3LMZaUs15p6mM6SZB5aKJr9k4Q4Sm6Jxsc6Iw1DiJXp8L8A83+jYULN7drWnUOTBKSu412GPGO1Cp6x5NlJcyt+ep2A9eeV/v3K/g1kbDPYN+z3Tkh6HDmNNodZP8n3NjsF8UpUVLX4HdnKTZUahI92NEftqckiW5wOVKgVEGC2Za602ce+O03M/rU4yeSF7v2x2W8pkqIXWw5Oel1+ia10fA+jtxi+c2LJY/I+1OEKCNY6nf9Qy1qwW9bHScX4I7VDfDa+imeKm1s+BkJqpXK550C5JLQlYvufm+EGgswtB5mY6RgNRcWkCaZAQx7klpSmZUVQ13JgrK43TEOEvn9/LP4FuMIEkyFq2LpPiMgp58uLMmsaWH1qIPEPd9Gqaf+k7923PH3B9AA0hd1xh8N7WMsGkxCz/lSWcWWk7BUhtY4351+aiLaG+2oUi+DBXAfyLXzVa1Rvx71LyVrLelJBx/1DVjp8OQKZkskozhJDbMPJ4FCt9TAbyKJ/fr7DWgZSr37ydB0Iczaji/ruOFvhEGCxv7aDabsN12BUKkEbr4aBCzJf5uUNAHLtYS9pfGWe8Echd3HqPg98ymb9EU9giuR0Feum6BIY+cvXYVSoJ9b++L0V9mZBnuK9k8Dr1T+HYCL70aFEs20Bbc68XBszu6dxg+0THIZBIPv016okSQKgu9Rifi4Ui2C9dQUYU5xgdupBYH+F6bjcockv5yCl0uRPCEPcfYchxb4mbEXIjzuiBV1ll0SipqEdkkQeFjFLc4dNzgb+fXlYpsxTBn3OP72qz4v/c7KnCJR/Y6Fs5jlhZa7b5f0GUWQUyxzCDjo0fE4ew7BixH+rwhcbNLTTeIAJAjuEj6BA
 XCs+ndZ0
 OpOggA9ywa352qVlgs01cMADAIV5TT7DcG8bpm7uYTC/gx77h0BLRDvkLv6JUEL1ij/BWsDmvsGGxwRmnuZn0YenwTaWSWew5w865l676R6NZSGPd1TcPClg8b91ynK+aT+/p4B4o71byE7aWUjcKvR7vi22XoWzUmpWYHE2IgXGj+YOJ+ZB15iVPWhJOuD2kYejRRre2R/DQN03earFZksa0+yYiWBYYp7/5
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


