Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C2AFC72C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA626B0005; Mon, 23 Mar 2026 03:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AFF6B0088; Mon, 23 Mar 2026 03:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681406B0089; Mon, 23 Mar 2026 03:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4296B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:20:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0627D1B8F2D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:20:52 +0000 (UTC)
X-FDA: 84576480744.24.11422A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 63FF64000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:20:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Nxaecao/";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774250450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UWtLjpr3XWUTy6VpKvNkAgaR7CgXzIkCMoHliiKcXRE=;
	b=18TDGHz7v2txXc3xeelaQVnNT9QFgVmcQTpegkMvf3IfzOzfh74tTEy6BuWVvxLeKYPF+M
	DmTTEwFgMkF6g6SAxeyP6bC5FnfG+9kM9j2AWVm1T0Yh3+2HWInHcoV4kY2Kqcgsd3KpAf
	x9AX5LrUcvM/P4An7RaTdWqdC/RxhRk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Nxaecao/";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774250450; a=rsa-sha256;
	cv=none;
	b=SEQqbsbmjX3ANtCNrHyYnLQGv1m6eLK+b4D/a3NbQr7359hxbHt6yfqe7UfVy+AOcY5kI1
	cpWoPsQktXXBzPFxY1zniIW/U+VbW0FqL6879DmnLnnyZ7zpBrZ8EC6qDYKVLR+kiGotwz
	NnaVEhGzIaw8uXiyq1vfqOJqlYHp290=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D0E84092A;
	Mon, 23 Mar 2026 07:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FBDC4CEF7;
	Mon, 23 Mar 2026 07:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774250448;
	bh=0vD2X20R0Foy1Av9+GcrMxGr/n9x3ZS0o9sWsZdkNr4=;
	h=From:To:Cc:Subject:Date:From;
	b=Nxaecao/+6Lkm6NnDQaCtAZzvPQXM3lyF/W7HPnRyKyZg5phrti13SUAL3wOkQit0
	 xP1VSIEltIXDXYDw8Cheo/YImvWVhBu/V41XJOjpw9qpkcrqCS7kiIvlOBr2Ax+TB1
	 100w4Kb0opYtV7gDVDdGIMFHYtx9xLzccQchh0R674k5PmEm+2NrgPM9SrYAl2JrgZ
	 mk8+31i30LHxDtM5vlwRsNzcw4U2rqYaGsJDf0XrRmRQuc5l+8RnCNlTLRAkWfN+KA
	 c9/c59OisIBarS5gO0CgzQAL9fNueNV0sj43U9vSrROZKziRnmslRvVqUCd3bGSDF/
	 5ZsrG2IxBR0SA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] memblock: move reserve_bootmem_range() to memblock.c and make it static
Date: Mon, 23 Mar 2026 09:20:42 +0200
Message-ID: <20260323072042.3651061-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63FF64000A
X-Stat-Signature: e4uwgwazo3dbqm1qqzuweitm1d9wn565
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774250450-876810
X-HE-Meta: U2FsdGVkX1/h9il3fDz4TZXhGkNWphBFPCRZs7vHfIf8vcf2+I3UL4pYykBEdX6KvOoQldLe/peNZiDXNRCEOJ3xTjI5WWL6Y0OLmkuKVpvVFiJx3EWmtwrT3v/0K2+7wdk00O4RZf8EYyQIer2KLhS2hU2IJmpbD+qUwL3+GAgc8nhY61pxCz77oSe5XsU9HACZCfLi+KHGoxY2gks0yXb0yGHvp7NxOoRSsSrCuT6Dm3pt7QTeQHUh4eIyUkU92VnbfnW3Xd8f81nlW8K2Ct8AVnPhiqeRoio5I7v8vu0/3u/VQMFUVMhDpoKyHT5BWSxjwLvkqZ0HESvT0oT7ngYv8Cb0yAOfINc6LQOEP3UAnkSNFqbVMN6RDuW9OvvlfWv68YcURo6phZ3mN4wGRmZf+Ia/yh5N2oKyVZl7F7+3qRYWMRzy32DM4hGFmWxhU+1ymTf/jlSq6agILcXq8o6p7gTPsOoaKFZ0iedG5ohIFlgnq9aujShjIsDQGpOi8pSw61QiyT0FeX1sRWhZc7eDkSwV4UgjtVvmJmClAKaqn/5/PKA7s/3pP+xDtZQxYY7Zi8V1LKHisgvFIlTP5UySSqSyr2Se8Ys/K+EuIHqSp1mHkuYhTX00tURYbWrFDdtcIATgZIJvlKnoLJXmR7mWFYs+2cL/snGIAaFGYNEIBFFGg/cQJy3At3qcsr9kvLOGTxowy4dP72yuyX5RZHF7qhE3QQuIyzDtesYfoFRD4vYITfn5Glvz1g8cdAbXvdma00KZ1LmnWeEpQqOtTGgGZRsNPJLXek4yPiwbU/Hm79IRRZT7ugO73p1MtxZEM59rv0lTY+bwvV8Q3+vy0H7hcDIhOqvQ7m4YSBYwKE4KWYsqcLT9lTpps7Cjc2PLNuA8tCPA7BJeRYLkGSvuPVwsp9rHCoKNxJavRSBH0TMSwlKhl8fThf4qaY52c+3FsUsAELW25u230rmTfI5
 qBiFcF/Y
 YyeXtmat7nOG71zZSgOzyM/VOsCIBgheU2A9RjWPeeR+hYsQijrC4aacO7RkmJfy4/tJJzyTW9Otg9L/i2hf2ZkjOALbiYa/Sug3hSGA9SIJJLIp5IVGg/RWc1VuFqj3FrHOMef+PUFNP+lPW2f0z8SMzARpEtR9P/8XUzoBGRRF6vAtSEBNVCaAHEImvutlYefhW2RQvjkDJix8DOpQn/VUPVx2y9mvutd4f4P+sKngwKJm8s3EMiPmNJjaGUHMaG5lughsV4zBGx6QdvOGW9CD4c8G8hJSvB/PvXaQkC3qELxuQLeidebptaEmvaVPIZDh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

reserve_bootmem_region() is only called from
memmap_init_reserved_pages() and it was in mm/mm_init.c because of its
dependecies on static init_deferred_page().

Since init_deferred_page() is not static anymore, move
reserve_bootmem_region(), rename it to memmap_init_reserved_range() and
make it static.

Update the comment describing it to better reflect what the function
does and drop bogus comment about reserved pages in free_bootmem_page().

Update memblock test stubs to reflect the core changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/bootmem_info.h      |  4 ----
 include/linux/mm.h                |  3 ---
 mm/memblock.c                     | 31 ++++++++++++++++++++++++++++---
 mm/mm_init.c                      | 25 -------------------------
 tools/include/linux/mm.h          |  2 --
 tools/testing/memblock/internal.h |  9 +++++++++
 tools/testing/memblock/mmzone.c   |  4 ----
 7 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
index 4c506e76a808..492ceeb1cdf8 100644
--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -44,10 +44,6 @@ static inline void free_bootmem_page(struct page *page)
 {
 	enum bootmem_type type = bootmem_type(page);
 
-	/*
-	 * The reserve_bootmem_region sets the reserved flag on bootmem
-	 * pages.
-	 */
 	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
 
 	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..764d10fdfb5d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3686,9 +3686,6 @@ extern unsigned long free_reserved_area(void *start, void *end,
 
 extern void adjust_managed_page_count(struct page *page, long count);
 
-extern void reserve_bootmem_region(phys_addr_t start,
-				   phys_addr_t end, int nid);
-
 /* Free the reserved page into the buddy system, so it gets managed. */
 void free_reserved_page(struct page *page);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..d504205cdbf5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -973,7 +973,7 @@ __init void memmap_init_kho_scratch_pages(void)
 	/*
 	 * Initialize struct pages for free scratch memory.
 	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
+	 * memmap_init_reserved_pages()
 	 */
 	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
 			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
@@ -2240,6 +2240,31 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 	return end_pfn - start_pfn;
 }
 
+/*
+ * Initialised pages do not have PageReserved set. This function is called
+ * for each reserved range and marks the pages PageReserved.
+ * When deferred initialization of struct pages is enabled it also ensures
+ * that struct pages are properly initialised.
+ */
+static void __init memmap_init_reserved_range(phys_addr_t start,
+					      phys_addr_t end, int nid)
+{
+	unsigned long pfn;
+
+	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
+		struct page *page = pfn_to_page(pfn);
+
+		init_deferred_page(pfn, nid);
+
+		/*
+		 * no need for atomic set_bit because the struct
+		 * page is not visible yet so nobody should
+		 * access it yet.
+		 */
+		__SetPageReserved(page);
+	}
+}
+
 static void __init memmap_init_reserved_pages(void)
 {
 	struct memblock_region *region;
@@ -2259,7 +2284,7 @@ static void __init memmap_init_reserved_pages(void)
 		end = start + region->size;
 
 		if (memblock_is_nomap(region))
-			reserve_bootmem_region(start, end, nid);
+			memmap_init_reserved_range(start, end, nid);
 
 		memblock_set_node(start, region->size, &memblock.reserved, nid);
 	}
@@ -2284,7 +2309,7 @@ static void __init memmap_init_reserved_pages(void)
 			if (!numa_valid_node(nid))
 				nid = early_pfn_to_nid(PFN_DOWN(start));
 
-			reserve_bootmem_region(start, end, nid);
+			memmap_init_reserved_range(start, end, nid);
 		}
 	}
 }
diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..ea8d3de43470 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -772,31 +772,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
 	__init_deferred_page(pfn, nid);
 }
 
-/*
- * Initialised pages do not have PageReserved set. This function is
- * called for each range allocated by the bootmem allocator and
- * marks the pages PageReserved. The remaining valid pages are later
- * sent to the buddy page allocator.
- */
-void __meminit reserve_bootmem_region(phys_addr_t start,
-				      phys_addr_t end, int nid)
-{
-	unsigned long pfn;
-
-	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
-		struct page *page = pfn_to_page(pfn);
-
-		__init_deferred_page(pfn, nid);
-
-		/*
-		 * no need for atomic set_bit because the struct
-		 * page is not visible yet so nobody should
-		 * access it yet.
-		 */
-		__SetPageReserved(page);
-	}
-}
-
 /* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
 static bool __meminit
 overlap_memmap_init(unsigned long zone, unsigned long *pfn)
diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 028f3faf46e7..74cbd51dbea2 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -32,8 +32,6 @@ static inline phys_addr_t virt_to_phys(volatile void *address)
 	return (phys_addr_t)address;
 }
 
-void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid);
-
 static inline void totalram_pages_inc(void)
 {
 }
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index 009b97bbdd22..eb02d5771f4c 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -29,4 +29,13 @@ static inline unsigned long free_reserved_area(void *start, void *end,
 	return 0;
 }
 
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)                     \
+       for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
+
+static inline void init_deferred_page(unsigned long pfn, int nid)
+{
+}
+
+#define __SetPageReserved(p)	((void)(p))
+
 #endif
diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/mmzone.c
index d3d58851864e..e719450f81cb 100644
--- a/tools/testing/memblock/mmzone.c
+++ b/tools/testing/memblock/mmzone.c
@@ -11,10 +11,6 @@ struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
 	return NULL;
 }
 
-void reserve_bootmem_region(phys_addr_t start, phys_addr_t end, int nid)
-{
-}
-
 void atomic_long_set(atomic_long_t *v, long i)
 {
 }
-- 
2.53.0


