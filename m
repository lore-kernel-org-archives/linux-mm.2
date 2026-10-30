Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F77D606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PzxwafWq
Received: by kanga.kvack.org (Postfix)
	id F2BC76B00EF; Fri, 30 Oct 2026 17:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5B96B05B1; Fri, 30 Oct 2026 17:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D146B05B2; Fri, 30 Oct 2026 17:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A733F6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:05:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB025807A2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:05:36 +0000 (UTC)
X-FDA: 85380523872.02.262B5F7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B15140006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:05:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PzxwafWq;
	spf=pass (imf07.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793394334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lz3hPdGiB3LtKOV0nNAhQA53cTuUQU9Ot6ASOb7nQ64=;
	b=3JOI8OgUIyibGh9U4mP+5iTNcvL5e1AtBXmRTNd4zN/FY5ynRseQUv0WvVuvGdel2Mdbzm
	+W0aGV3H2fEp9eAa0sLqmIXHZOnhy3O9qBgBMOnTFuf4w441CvZ1E+5xSOpY1j1ba+PVZg
	Jn9lcVxYcH89JWFs8cRqQ1i8/p4gnoE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PzxwafWq;
	spf=pass (imf07.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793394334;
	b=6VQrhwCz6pnmpdAXffo/ZI13/ZMJYLTwFwMEksJavQ4x/6SCPC5YZJXNSF2lQR+Uft827H
	BK6XhSu/XR8tKO/nIY+N89MV+WELYsv32DvFZ2mSfl1l6Sla51uiQONcfDsrBSgD9ks2af
	zCofYikZbScGq+b3EHXQgFtoX/TOlHo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793394335; x=1824930335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iUxaxRahzNaPTiOfDpUTWah4QuJ5Ix+A92v5DpF5sEk=;
  b=PzxwafWqPHD3YUHKBmsYQqrW8GOMXq8iPtSKBr0Y5t9ixA9WLgWL8z5X
   KIfFC7UqaV8Oc4W1WpYHrBsVmIwjjQPcYtD67G0hOzb6KEgml4MRC6kNo
   ZSvwVrqjwMJq6ztjM2lqRVNDVowlsW9zpLs5/8zyMupCI7ZhDQOSIT+pE
   +xWZibOVL734lpc5huCqVfA0Sa6hhYwDOgM96ZQAJ1fa3R1RLTFIaDPDL
   Q4B4ai57jsHTeqqunlOO0okscCEPcyCHdKuPvXW62ftVn8N/WcvEzXfCl
   avKE7+iGR8L/8bOcFIRnKLZKpZ5JqqCy2FeMuD22twqjIFv6CyQUz+Jt+
   A==;
X-CSE-ConnectionGUID: lBZ45eonS/i8s55lBsC5aA==
X-CSE-MsgGUID: pG/vfXytTwyUkA4rMpeTeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2171992"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2171992"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 14:05:34 -0700
X-CSE-ConnectionGUID: 7WwhIb3bSwyFDAscpY/TNw==
X-CSE-MsgGUID: hBwFep02SP+Z7vZWIJRRvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5869865"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa008.fm.intel.com with ESMTP; 30 Oct 2026 14:05:32 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Doug Nelson <doug.nelson@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Mohini Narkhede <mohini.narkhede@intel.com>,
	Pooja Jain <pooja.jain@intel.com>
Subject: [PATCH v2] mm/hugetlb_vmemmap: Fix usemap overrun on nodes with multiple ranges
Date: Fri, 30 Oct 2026 14:10:32 -0700
Message-Id: <17a23a0cb7b98161e0a0d14520c63d2b4d1921b1.1793394603.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B15140006
X-Stat-Signature: fhunm8gz9f1kajuzpjd77f6jdbam7fp9
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793394333-944189
X-HE-Meta: U2FsdGVkX18icYT8HlGkq9+ju8C1KBhAhl0CNunJoWjMaQMLmn4LGxjVc8kkq3RZJF+7BPVhwK1SeZe8IGaxPAoCZLgQrg1yprfvEFTFk3CXQAuT7zL0b++wG+ftN87USYzAgAG454W2a09V0+sFrkEyCY2FySwXOhsyK19k1/dYJnmJ67nnqqGGEPhFM12Xz6U9CfxSqKErTXwnRtpTCydu40vkdtMBMajPjvIYyFrUxLZRCywaMaUcewZubTN9RMuF2rTulNcKEIX9QWsFyPRetz6fu2lroqeYATI8v+nqY3Ns/2DnMk583O8XJIq+3dkKivRZHGW6BXyVA3rykIXb+RqKtO0iyRXvu3g/kLiz3uh+rzPQJLJhMZ+V8mg5oiNFQxUu0C73WOTjuEcgfT04k16qMmTXkO7BuBMn36ziYflwdSxtGlnPeO26pjSWBF4VOar6oSjqLPutPsKi0ftgKfcVXqPZ6rGguwUFecOKW5ftOJLW9yPauSxTSs6dxtL+qPU2Wi5WSxpAUmkOIOz8Os3cRtRLTKMi8wZZ5J01Lqe76v+NCqUnP4mKtM40KIrqFdPKaJ6RMalFOae9L+TtlSxgc3KiwEq4q/RZHC10zfwk0HLC09T4xckvac5EmEEJXS/two6sguWZg8eEPvSu7lmvX8VOhTwtCAdrGF9SuRuBVPCUkVZOUnMFtT54nH3QehTjSqhu3pHNXufK6wVfXMTjX+rDKwSHsgQI6HXMH+pYF0UVSlFsnZlnVbjdBlVMH9Re46tqgczuy/cyGDsHRO+6u0yZvKDdjNkH1OzBjysuWtg5c9KPcPY/my08eHdS5E7YthDigFzG0CyeLrEx5g/ayXJpdOjgLXr0jlq+gSP0R3zWx6CXE1EjAksNG/rb5QuNsXT+GFu9j7h80U/6lLlLJAiJhWZaAfIRhlvh2TkDtF/Es5UtUwFPD7ewvMHRyP4/2YOrIljpHml
 mS1rHave
 uhZt+x7B3YKHy4kXcqT9hivXVqxV1QCdU5JgSkYk71LbQPCLQkhadsOTPOHS9wu0760ct4tYewCMG8jemJxnjMgGDV71ZWGl4ZvdZkgjv/CUeuNisRFyyQeLE1mn2csP66w61xnsS4Y6Ijj3jEKwxBCqP6x+s4nrk+sQBoix0BEZI+drP8YkHOU5sCGtXX6wUVtVsakhOYA8W22ZtRHHpqVvIkcWmBaUjZkAEmQ+KJKvVs9RhoX3SszSzHkgM/2j6edib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[Only for 7.3.y, 7.2.y and 6.18.y.
Master branch 7.4-rc* onwards switched to section-based vmemmap
optimization without this bug]

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
Cc: stable@vger.kernel.org # 6.18.y, 7.2.y, 7.3.y
Reported-by: Mohini Narkhede <mohini.narkhede@intel.com>
Tested-by: Pooja Jain <pooja.jain@intel.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---

Notes:
    v1 -> v2:
    - Use a two-tab indent for continuation lines of all touched prototypes
    and definitions (David)
    - Add Muchun's Reviewed-by
    - State in the changelog that this is a stable-only fix and name the
    mainline commits that removed the buggy code (Muchun)
    - v1: https://lore.kernel.org/all/20261029212137.3141875-1-tim.c.chen@linux.intel.com/

 include/linux/mmzone.h |  8 +++++---
 mm/hugetlb_vmemmap.c   | 37 +++++++++++++++++++++++++++++++++----
 mm/hugetlb_vmemmap.h   |  6 ++++--
 mm/sparse-vmemmap.c    | 16 +++++++++-------
 mm/sparse.c            |  2 +-
 5 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff54160..e25ac1e9d670b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2167,13 +2167,15 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
 }
 
-void sparse_vmemmap_init_nid_early(int nid);
+void sparse_vmemmap_init_nid_early(int nid, unsigned long pnum_begin,
+		unsigned long pnum_end);
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
 	return 0;
 }
-static inline void sparse_vmemmap_init_nid_early(int nid)
+static inline void sparse_vmemmap_init_nid_early(int nid,
+		unsigned long pnum_begin, unsigned long pnum_end)
 {
 }
 #endif
@@ -2379,7 +2381,7 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
+#define sparse_vmemmap_init_nid_early(_nid, _begin, _end) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 917db0984143c..8189f08203192 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -758,10 +758,36 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
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
+		unsigned long ns, unsigned long pnum_begin,
+		unsigned long pnum_end)
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
+		unsigned long pnum_end)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
@@ -784,6 +810,12 @@ void __init hugetlb_vmemmap_init_early(int nid)
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
@@ -794,9 +826,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 			panic("Failed to allocate memmap for HugeTLB page\n");
 		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
 
-		pnum = pfn_to_section_nr(pfn);
-		ns = psize / section_size;
-
 		for (i = 0; i < ns; i++) {
 			sparse_init_early_section(nid, map, pnum,
 					SECTION_IS_VMEMMAP_PREINIT);
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 7ac49c52457dd..26a018a0dfeb4 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -28,7 +28,8 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-void hugetlb_vmemmap_init_early(int nid);
+void hugetlb_vmemmap_init_early(int nid, unsigned long pnum_begin,
+		unsigned long pnum_end);
 #endif
 
 
@@ -76,7 +77,8 @@ static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 {
 }
 
-static inline void hugetlb_vmemmap_init_early(int nid)
+static inline void hugetlb_vmemmap_init_early(int nid,
+		unsigned long pnum_begin, unsigned long pnum_end)
 {
 }
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5a2469fb1838c..bade43290922c 100644
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
+		unsigned long pnum_end)
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
-- 
2.32.0


