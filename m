Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B835A60A2607
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=APPKiBTf
Received: by kanga.kvack.org (Postfix)
	id D8B796B05B6; Thu, 29 Oct 2026 17:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62E56B05B7; Thu, 29 Oct 2026 17:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C794A6B05B8; Thu, 29 Oct 2026 17:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8546B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:16:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E8671204CE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:16:41 +0000 (UTC)
X-FDA: 85376923002.08.065395F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73D98C0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:16:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=APPKiBTf;
	spf=pass (imf28.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793308599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ve26lUBmUJFECYTyCPLjaRxL8AOyHzq0JI4RfNsIoIc=;
	b=LGUBWeMNu3HwzQeyFQWQsBhd0gaVwZ3HIFJ/ih4KP+2FmtTb17nAQImnahEYtvb24thayl
	KKzAanXc4IXjSmdTkcmrdzOORMPUXFMpzo1mpImv3D4y5EppiPkKvckEFnQfVqS0c8IAv1
	9t3TdSPSM+p1iwdxVlxukC3aU6gopPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793308599;
	b=gPPUdDzTQBH5t9n00fxtqY4wP2LI74HOXXV6ttpWVg/R7GaGwd7ENUYdA7FbzF34KLA0ev
	3bUcVAfRlRUTfzsX4Ede0Z44N20O9ViYNABbRYQcrZGIJNxFTNaJtlAPjtZfrQoB2+80z+
	WjsCisM8+f9IkkESG26Y5JKQgrMrbME=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=APPKiBTf;
	spf=pass (imf28.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793308599; x=1824844599;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gUD11uQ0t0v2ZsUT6AEd0e2qy1EJgpyF60DowInl21s=;
  b=APPKiBTfZfy/ShMjlJm5CVwXumEMkrOjbRNUDfSmPXvPimusk7NsIo5h
   ggXezKc6wnCmROfQ9SdCTtlN8WBnMzFPb+k1iu01cS+nBjqi4dacGuPqn
   BmKBKX7pA8L72MuzdjDXz482m/aBX8yLS1smlttLfGxabx9aLc4VswwtY
   bJN6NKnRjKzbHkJApNUS+0Q0H5CpXTX9Tza9bNH+ZeF9A0dMwsZiY15qu
   CtCxdXL+5ZXps0UlkNrygC+TjZhwiwzemg+CLrmYUdqy1VPlDWkcOPfmq
   BAqJzN6kM3z5WvRLPdmUL7NvbQt9csJ+fVcpcF496L9SgWex5nvam7Ufd
   w==;
X-CSE-ConnectionGUID: aG8kxdeeT0OrVP3qG+Sb/A==
X-CSE-MsgGUID: 1RsPv5YTTzGDOINVVKDdKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="1949743"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="1949743"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 14:16:38 -0700
X-CSE-ConnectionGUID: Ak24gQHiQ9GYGQhbyQFg4w==
X-CSE-MsgGUID: sGh9KwjSQGWzllNlhd+0FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5224591"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by orviesa004.jf.intel.com with ESMTP; 29 Oct 2026 14:16:37 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Mohini Narkhede <mohini.narkhede@intel.com>,
	Pooja Jain <pooja.jain@intel.com>,
	Doug Nelson <doug.nelson@intel.com>
Subject: [PATCH] mm/hugetlb_vmemmap: Fix usemap overrun on nodes with multiple ranges
Date: Thu, 29 Oct 2026 14:21:37 -0700
Message-Id: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73D98C0003
X-Stat-Signature: gt7wrnqtsa578gyfs3rjxuykg718zm6c
X-Rspam-User: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	T_SPF_HELO_TEMPERROR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793308598-754184
X-HE-Meta: U2FsdGVkX1/BbAoW9ZMQToYw8QThY2zHrDpNyDRLdmv0QgV5Q968x8LN/HtrmdbBtkBMggSROjNE3b+JiFJc2uLxhQPtVq5CZbcMyBEqAnrJ4XxU92ArEXa510zCqXHWi3Fp9gKuJ+kSfHvBQ0/4JHnCfCeYruAFDHQ9aHcK5JAVpPxDLGP8DJPv9K8gwT5x4S6cJJ7fXxBmBfdiUjZaRpM1qTBBVQEjiP9PZuAdlPkC1Qt5bQCBJATrg7+X5TXF8kXDn6sfckJUAYf2ui98DcmHapyEyVPGx6l5T3HrojA2rQnV2s9hu0/7/9AUffrHax3wl0WIRNB9e7vFdYoyMUmHmuvCpiSpedg7fEohskbP0WLOVZnMr2It2t3+E7R4yTC1lcIquyekpue9tNAYI0iHZ2huXByfqGOuDvW0ZbMR6qIyIuELn4Xi1DXPqfTsoB/miXTg9VFdupCbvfwuZjznIjwCzWyGO6hFw/tDxNUFbrYoyRsDJLgN+tpbw0JfTh2NAtMxYcra/1S1Bdqb7hYWM17toU5dmqxLzHp7ocGxTwBGCl11oUQbg7sHh7iDzTDs5SoUOdLc8V6MNv4c1KDUhoCNTx6GxK2vamNMRaK30y1uD2ihAZHDAL90VnM7Ee/mcjAPkiAJunE1AlfExoBTPsheNTzVHweTYoi8NE1fZad38MeZCQVaeDQIQUzXpCnhpvvl+iz0mUhp2JFX5cJ9uHWK2t/VINnlVj9jJWdgQlE+OnACgrI5YpuMZlawm9pT1gqFwnnXK79UhDzZjtU8cXi1D0pLKU50twFZviIXxdUIbTniwXkZYTrIRE8ym8zNPvzKfpppEjmjEnM6A3Nk4q65bNtWzDomFUQRC4jna4dty40ZJi2Pthqkjv5RO0K2Pr5dfQjZgENZjfZaOFSeeM4j+AHxl+e9z9ZQby0ObjLQcQXdovq42mLlKG7wm3gISUqpcfDe3V50QAG
 qrck3kSW
 ik6kwrGxDWLyKH5ZzhmxVFA1skS4KY6+EFkVQJumudco6sponc8ZAzkrwDexOrEOa6YPz9egHC39A3i9GMEsXmKJD3z+7H457/47usanhcOlTrE0fRYR3UnNbQj+DXg0H36Ml86Nywti5ZUnApyOagEeJZ+NJm3ET0o4rXHFT6uBfSzMUp8ENx/zMUcvatQP/8wELXFO88ioIYU2yOhRrWoTBczbRuO8iz7mbx0UpuDRGB2Z0as4egrYo1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sparse_init_nid() allocates one usemap slot (struct mem_section_usage)
per present section in [pnum_begin, pnum_end), and
sparse_init_early_section() hands them out in order, with a BUG_ON() when
they run out. hugetlb_vmemmap_init_early(nid) however initializes the
sections of every bootmem gigantic page on the node, including pages
outside the range being initialized. If a node's memory is split into
more than one range, sparse_init() calls sparse_init_nid() once per range,
and this takes more slots than were allocated. The same happens if a
gigantic page straddles a node boundary.

For example, with this SRAT layout every node has a small range below 4G
and a large range above 4G:

  Node 0 PXM 0 [mem 0x00000000-0x2fffffff]          768 MB  (low)
  Node 0 PXM 0 [mem 0x100000000-0x80cfffffff]               (high)
  Node 1 PXM 1 [mem 0x30000000-0x5fffffff]          768 MB  (low)
  ...

In 128 MB memory sections (x86_64 SECTION_SIZE_BITS = 27), node 0's low
range is sections 0x00-0x05 (6 present sections) and its high range is
sections 0x20-0x1019. The low ranges of the other nodes are 4 or 6
sections, all smaller than the 8 sections of a 1G page.

Node 0's first range has 6 sections, so 6 slots. With "hugepagesz=1G
hugepages=400", hugetlb_vmemmap_init_early(0) then initializes node 0's
1G page at 0x67c0000000 (sections 0xcf8-0xcff, in its high range), and
the 7th section hits the BUG_ON() (seen on v7.2.6):

  kernel BUG at mm/sparse.c:268!
  RIP: 0010:sparse_init_early_section+0x9f/0xb0
  RAX: 0000000000200000 RBX: 0000000000000cfe RCX: 0000000000000020
  RDX: 0000000000000cfe RSI: ffd7e1d09fc00000 RDI: ff252cb28ffb3f50
  R10: ff252cb28ffb3d40 R13: 0000000000000d00
  Call Trace:
   hugetlb_vmemmap_init_early+0xe1/0x140
   sparse_init_nid+0x56/0x370
   sparse_init+0x192/0x2b0
   free_area_init+0x7f/0x690
   start_kernel+0x64/0x540

Here RDX is the section number, and R10/RDI are 6 slots apart: the start
of the usemap buffer and its current position, which is the end.

Pass the section range to hugetlb_vmemmap_init_early() and only pre-HVO a
page whose sections are all present and within it. Ranges are disjoint,
so each page is handled once, in its own range.

Skipped pages are not marked HUGE_BOOTMEM_HVO. Their sections get a
regular memmap from sparse_init_nid(), and the pages are optimized later
by hugetlb_vmemmap_optimize_bootmem_folios().

Fixes: b1222550fbf7 ("mm/hugetlb: do pre-HVO for bootmem allocated pages")
Cc: stable@vger.kernel.org
Reported-by: Mohini Narkhede <mohini.narkhede@intel.com>
Tested-by: Pooja Jain <pooja.jain@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mmzone.h |  9 ++++++---
 mm/hugetlb_vmemmap.c   | 38 ++++++++++++++++++++++++++++++++++----
 mm/hugetlb_vmemmap.h   |  7 +++++--
 mm/sparse-vmemmap.c    | 16 +++++++++-------
 mm/sparse.c            |  2 +-
 5 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff54160..da17dae8b057b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2167,13 +2167,16 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
 }
 
-void sparse_vmemmap_init_nid_early(int nid);
+void sparse_vmemmap_init_nid_early(int nid, unsigned long pnum_begin,
+				   unsigned long pnum_end);
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
 	return 0;
 }
-static inline void sparse_vmemmap_init_nid_early(int nid)
+static inline void sparse_vmemmap_init_nid_early(int nid,
+						 unsigned long pnum_begin,
+						 unsigned long pnum_end)
 {
 }
 #endif
@@ -2379,7 +2382,7 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
+#define sparse_vmemmap_init_nid_early(_nid, _begin, _end) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 917db0984143c..e9b35dabb6a4f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -758,10 +758,37 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
 	return NULL;
 }
 
+/*
+ * sparse_init() initializes a node one run of contiguous, same-node present
+ * sections at a time, and only reserves usemap space for the sections in
+ * [pnum_begin, pnum_end). A node may be made up of several such runs (e.g.
+ * with interleaved NUMA layouts), and a gigantic page may straddle a node
+ * boundary. Only pre-HVO a page if all of its sections are present and
+ * within the run being initialized; the rest is left to the generic path.
+ */
+static bool __init bootmem_page_in_section_range(unsigned long pnum,
+						 unsigned long ns,
+						 unsigned long pnum_begin,
+						 unsigned long pnum_end)
+{
+	unsigned long i;
+
+	if (pnum < pnum_begin || pnum + ns > pnum_end)
+		return false;
+
+	for (i = 0; i < ns; i++) {
+		if (!present_section_nr(pnum + i))
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
-void __init hugetlb_vmemmap_init_early(int nid)
+void __init hugetlb_vmemmap_init_early(int nid, unsigned long pnum_begin,
+				       unsigned long pnum_end)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
@@ -784,6 +811,12 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		psize = nr_pages << PAGE_SHIFT;
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
+		pnum = pfn_to_section_nr(pfn);
+		ns = psize / section_size;
+
+		if (!bootmem_page_in_section_range(pnum, ns, pnum_begin, pnum_end))
+			continue;
+
 		map = pfn_to_page(pfn);
 		start = (unsigned long)map;
 		end = start + hugetlb_vmemmap_size(m->hstate);
@@ -794,9 +827,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 			panic("Failed to allocate memmap for HugeTLB page\n");
 		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
 
-		pnum = pfn_to_section_nr(pfn);
-		ns = psize / section_size;
-
 		for (i = 0; i < ns; i++) {
 			sparse_init_early_section(nid, map, pnum,
 					SECTION_IS_VMEMMAP_PREINIT);
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 7ac49c52457dd..255e650bc4174 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -28,7 +28,8 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-void hugetlb_vmemmap_init_early(int nid);
+void hugetlb_vmemmap_init_early(int nid, unsigned long pnum_begin,
+				unsigned long pnum_end);
 #endif
 
 
@@ -76,7 +77,9 @@ static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 {
 }
 
-static inline void hugetlb_vmemmap_init_early(int nid)
+static inline void hugetlb_vmemmap_init_early(int nid,
+					      unsigned long pnum_begin,
+					      unsigned long pnum_end)
 {
 }
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5a2469fb1838c..baed805b87d03 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -573,15 +573,17 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 /*
- * This is called just before initializing sections for a NUMA node.
- * Any special initialization that needs to be done before the
- * generic initialization can be done from here. Sections that
- * are initialized in hooks called from here will be skipped by
- * the generic initialization.
+ * This is called just before initializing the sections of a NUMA node in
+ * the range [pnum_begin, pnum_end). A node may span several such ranges,
+ * in which case this is called once per range. Any special initialization
+ * that needs to be done before the generic initialization can be done from
+ * here. Sections that are initialized in hooks called from here will be
+ * skipped by the generic initialization.
  */
-void __init sparse_vmemmap_init_nid_early(int nid)
+void __init sparse_vmemmap_init_nid_early(int nid, unsigned long pnum_begin,
+					  unsigned long pnum_end)
 {
-	hugetlb_vmemmap_init_early(nid);
+	hugetlb_vmemmap_init_early(nid, pnum_begin, pnum_end);
 }
 #endif
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 7c15406e77f5d..25fe41c69414c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -288,7 +288,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	if (sparse_usage_init(nid, map_count))
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	sparse_vmemmap_init_nid_early(nid);
+	sparse_vmemmap_init_nid_early(nid, pnum_begin, pnum_end);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
 		struct mem_section *ms;

