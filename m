Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD8DEC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E48B6B00A7; Thu,  9 Jul 2026 13:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4950C6B00A9; Thu,  9 Jul 2026 13:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4456B00AA; Thu,  9 Jul 2026 13:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAE86B00A7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEBCD1C1EDD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:22 +0000 (UTC)
X-FDA: 84969949764.18.615642E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6784540007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PStD/HcK";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ix6I6I+r1vTD3BUcaSUPcfAv6vZf01a6pDgBUVaQZsU=;
	b=ERTzgggh9aD/kX681LfHi0UctfCCSXcggmMLAFUaVuyIK+b9F/jP69jyK4G47KKmoMfZq9
	4aLRr6BryEe6+j9RqkhVRG6xkTNzZ9/yXl6zgCjGnc+SRElZNuTCJqshe53ydZLqHfxYtp
	xrk4zAWXEIVXH0dXvjx+DK77cu9T2Cs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PStD/HcK";
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618761;
	b=DFCMBfEomaPpuf/d36TzTX9sSpcj0ctxOIRuM1vrCynmWFXb6ZA2lj8Svo5gfbrt5vofYp
	5mPWLvhB+kmW6LQq9P1cgzwSnrDJGLALq078Z36mGSIam7p6/IOA8qeHHerq8Cdh4jG7Gh
	9G7mJF0mnm7JHmUTrvG1XpuY+5N/DgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B60061381;
	Thu,  9 Jul 2026 17:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CF31F00A3F;
	Thu,  9 Jul 2026 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618760;
	bh=Ix6I6I+r1vTD3BUcaSUPcfAv6vZf01a6pDgBUVaQZsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PStD/HcK3IeCVUJvMBF5NmYMR3SQUv+aJDuTJPtSR1AnHLGcesJXS9oDRyHSSMLJy
	 k/FBFuh/j98WqOUxmfof1y71AXFNYy6AdD9lDWFhB2pGEtMdI41x8tzto9u56t8CwU
	 1JddvGI31gDJEyf5+b5xfZnJiM2vYozU/skjY3Orb08hfsnOTMbDq11QbXovWWFRPo
	 +Qy1Ks6OOGIuaupH+N05w/bfS7juCt72+7ToR8UDJc1Eq403d3XDPRBymNwtV+KrC6
	 4oDCHpdo9CQF+qiq/FTgKPFoQpaCmE0d3uLLz7WMM6Nr1CxSSih7LAhJ99mNZkNyJT
	 89SANEVhcul8w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 19/21] memblock: make HugeTLB bootmem allocation work with KHO
Date: Thu,  9 Jul 2026 19:38:08 +0200
Message-ID: <20260709173821.429921-20-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6784540007
X-Stat-Signature: xoswz8yrofjf7bwt5ctpdm8ifau9zc35
X-HE-Tag: 1783618761-258204
X-HE-Meta: U2FsdGVkX19rPXe60ru5Hn9qkXtJ7P2WF1g/fBRJKljM6PZbIO8vTi0oUoror5Bsljhs1FVX9TKRdwQ3qqym+AkfKJBfdmU4iAdV+q4BI/t3ULMTjYGcNQdGHbT0ZU+vn6xSmOL6lCYFgvmGSAggr10Z/zElF7AfNZbLOJu4XM7xilPg2txDCndVq9/EMNcXAF9/cBwPjxOHsZi7n1VsJEn4G3W/0ny1yajLciTyt0kr0nKpMI/RMymmSF8K60jtnw+JEDdEmc5PiOvl3TG8fodGo60GA1UoljKicXX5BAiaAbvTA5BWiLvsqAYrW1Tf7AYxJhqPdLG7CejriIcYF5VyPX8Zsv7+zqfxTe2vz2AdwtcWMMbeoMlqg26MgVlu45Ex1NNXuZ+FDGYeTZXTkzdgRQ1fo/mIAMgRDL9KFyF3poUYdIZqjl/cMjKDTtoZMWxw54RKzxC4Xosg/UTLJZqPqGAA7nxH2avHZZ1f2R5b8wBDHVCOcJTVeMLdNFNwtuAw1p0EvyLm9MHWkLMQWTo5/lthwmW3P1DewqP8sBKVtp2NvK1i0v5SzZcQBIK0Jttlh7V+mx/W0vWJIGyJuaxs6N+Jg4gCp6sLoJPEUkBLID1u1kCyGVT+QxMxu2g36Qbp+nApu0JPhFCD4XSIRfieOK51tNYCNY7kyCWBfuMjBfl41dy4q4rtk29g2pZwKI0b4v+pVCmJbqmVUYjf3DhhnVDPDgEp1k7yQ7CEOQAxHHKF7LV6k4txnohJC+CBUYJtZfkLXP6pXnWKj5KQGJmeEobAMbhYDrK0uScCcAIpJkPsUs9bna98MKvLWc9ZY+ulDqtnd8b1yQpXxRu4Ljg2A3ZJXF0JIYVAuBLbCYPL3vGZmnEnocfk5jHelwSjKjjPGUp8Oms7riQSVNNQ+XVZ7O9YMUrSi6YTIPsln+p09l/3U0Qfjax9DX9ODmQ7v5tm4k4YPyVEWIx6n59
 lSZjs/t8
 5AgUaoF4n2iftX8qZ5IwZOHGQTwk1ZAzSXNfpIQ4E+ZLpZN16a9YKa19nDTjFAdwBDOS/0w68RkvY7hDGdkgRfmNQwhDFtCqPr7tAcD9JWyZ/nAS6SZsZ/6DpfiuC6oNPH6yc+Qjm+hD3SLQVxCR12UPzXQE4nhlRuewKPAp0OIb11ahEprAV/A8BTR5Aevr49GivAOI1XMnDE/srmscfphkD15mpQOEaf+R4kW/Ww8FXU+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Gigantic huge page allocation is somewhat broken currently when KHO is
used.

Firstly, they break KHO scratch size accounting. RSRV_KERN is used to
track how much memory is reserved for use by the kernel. Since
hugetlb::alloc_bootmem() calls the memblock_alloc*() APIs, the hugepages
allocated also get marked as RSRV_KERN.

Allocations marked RSRV_KERN are used by KHO to calculate how much
scratch space it should reserve to make sure the next kernel has enough
memory to boot when it is in scratch-only phase. Counting hugepages in
that blows up scratch size, and can lead to the scratch allocation
failing, making KHO unusable. This will show up when huge pages make up
more than 50% of the system, which is a fairly common use case.

Secondly, while not supported right now, huge pages are user memory and
can be preserved via KHO. The scratch spaces should not have any
preserved memory. Allocating hugepages from scratch (on a KHO boot) can
lead to them being un-preservable.

Introduce memblock_alloc_hugetlb(). This lets memblock tailor to the
needs of hugetb without exposing those details to the general allocation
routines.

First, it does not use mirrored memory for hugetlb. Mirrored memory is a
limited resource that is best saved for kernel data structures, not user
memory.

Second, if the free memory area found by memblock_find_in_range_node()
is a part of a KHO scratch area, the free area is not used. Allocation
is retried starting after the free area to ensure no hugepages come from
KHO scratch.

Third, it simplifies the argument list by baking in some hugetlb
assumptions like alignment and exact_nid. This also simplifies
allocation logic in alloc_bootmem().

Also introduce MEMBLOCK_RSRV_HUGETLB to mark reservations made for
HugeTLB. This will be used by KHO in future patches to correctly
calculate scratch sizes.

Refactor some of the preparation logic like kmemleak tracking and
accepting memory into a separate helper memblock_prep_allocation(), and
use it from both memblock_alloc_hugetlb() and the usual
memblock_alloc_range_nid().

Add a stub for kho_scratch_overlap to memblock tests to make sure it
compiles.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h          |   3 +
 mm/hugetlb.c                      |  22 ++----
 mm/memblock.c                     | 112 ++++++++++++++++++++++++------
 tools/testing/memblock/internal.h |   5 ++
 4 files changed, 105 insertions(+), 37 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index f142c8a8cd5b..678fe466529a 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -51,6 +51,7 @@ extern unsigned long long max_possible_pfn;
  * memory reservations yet, so we get scratch memory from the previous
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
+ * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -61,6 +62,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
+	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
 };
 
 /**
@@ -420,6 +422,7 @@ void *memblock_alloc_try_nid_raw(phys_addr_t size, phys_addr_t align,
 void *memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
 			     phys_addr_t min_addr, phys_addr_t max_addr,
 			     int nid);
+void *memblock_alloc_hugetlb(phys_addr_t size, int nid, bool exact_nid);
 
 static __always_inline void *memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..ab4afc818e8c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3033,29 +3033,21 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 	if (hugetlb_early_cma(h))
 		m = hugetlb_cma_alloc_bootmem(h, &listnode, node_exact);
 	else {
-		if (node_exact)
-			m = memblock_alloc_exact_nid_raw(huge_page_size(h),
-				huge_page_size(h), 0,
-				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-		else {
-			m = memblock_alloc_try_nid_raw(huge_page_size(h),
-				huge_page_size(h), 0,
-				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		m = memblock_alloc_hugetlb(huge_page_size(h), nid, node_exact);
+		if (m) {
+			m->flags = 0;
+			m->cma = NULL;
+
 			/*
 			 * For pre-HVO to work correctly, pages need to be on
 			 * the list for the node they were actually allocated
 			 * from. That node may be different in the case of
-			 * fallback by memblock_alloc_try_nid_raw. So,
+			 * fallback by memblock_alloc_hugetlb_bootmem. So,
 			 * extract the actual node first.
 			 */
-			if (m)
+			if (!node_exact)
 				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
 		}
-
-		if (m) {
-			m->flags = 0;
-			m->cma = NULL;
-		}
 	}
 
 	if (m) {
diff --git a/mm/memblock.c b/mm/memblock.c
index 8b2e551435ae..ba6d887ea18e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1506,6 +1506,32 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 
+static void memblock_prep_allocation(phys_addr_t start, phys_addr_t size,
+				     bool leaktrace)
+{
+	/*
+	 * Skip kmemleak for those places like kasan_init() and
+	 * early_pgtable_alloc() due to high volume.
+	 */
+	if (leaktrace)
+		/*
+		 * Memblock allocated blocks are never reported as
+		 * leaks. This is because many of these blocks are
+		 * only referred via the physical address which is
+		 * not looked up by kmemleak.
+		 */
+		kmemleak_alloc_phys(start, size, 0);
+
+	/*
+	 * Some Virtual Machine platforms, such as Intel TDX or AMD SEV-SNP,
+	 * require memory to be accepted before it can be used by the
+	 * guest.
+	 *
+	 * Accept the memory of the allocated buffer.
+	 */
+	accept_memory(start, size);
+}
+
 /**
  * memblock_alloc_range_nid - allocate boot memory block
  * @size: size of memory block to be allocated in bytes
@@ -1580,28 +1606,7 @@ phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
 	return 0;
 
 done:
-	/*
-	 * Skip kmemleak for those places like kasan_init() and
-	 * early_pgtable_alloc() due to high volume.
-	 */
-	if (end != MEMBLOCK_ALLOC_NOLEAKTRACE)
-		/*
-		 * Memblock allocated blocks are never reported as
-		 * leaks. This is because many of these blocks are
-		 * only referred via the physical address which is
-		 * not looked up by kmemleak.
-		 */
-		kmemleak_alloc_phys(found, size, 0);
-
-	/*
-	 * Some Virtual Machine platforms, such as Intel TDX or AMD SEV-SNP,
-	 * require memory to be accepted before it can be used by the
-	 * guest.
-	 *
-	 * Accept the memory of the allocated buffer.
-	 */
-	accept_memory(found, size);
-
+	memblock_prep_allocation(found, size, end != MEMBLOCK_ALLOC_NOLEAKTRACE);
 	return found;
 }
 
@@ -1756,6 +1761,69 @@ void * __init memblock_alloc_try_nid_raw(
 				       false);
 }
 
+/**
+ * memblock_alloc_hugetlb - allocate boot memory for HugeTLB pages
+ * @size:      size of the memory to be allocated in bytes
+ * @nid:       nid of the free memory to find, %NUMA_NO_NODE for any node
+ * @exact_nid: only allocate from the specified nid. If %false, the specified
+ *             nid is tried first, and then all nodes are tried as fallback.
+ *
+ * HugeTLB pages are always aligned by their size, so the alignment matches
+ * @size. Since the memory is for userspace, mirrored memory is not used. The
+ * memory is not zeroed. Does not panic if request cannot be satisfied.
+ *
+ * Return:
+ * Virtual address of allocated memory block on success, %NULL on failure.
+ */
+void * __init memblock_alloc_hugetlb(phys_addr_t size, int nid, bool exact_nid)
+{
+	enum memblock_flags flags = choose_memblock_flags();
+	phys_addr_t addr, start = 0, end = MEMBLOCK_ALLOC_ACCESSIBLE;
+
+	memblock_dbg("%s: %llu bytes, nid=%d, exact_nid=%d %pS\n", __func__,
+		     (u64)size, nid, exact_nid, (void *)_RET_IP_);
+
+	/* Don't waste mirrored memory on HugeTLB pages. */
+	flags &= ~MEMBLOCK_MIRROR;
+retry:
+	/* HugeTLB pages are always aligned by their size. */
+	addr = memblock_find_in_range_node(size, size, start, end, nid, flags);
+	if (addr)
+		goto found;
+
+	/* Try all nodes if allowed. */
+	if (numa_valid_node(nid) && !exact_nid) {
+		nid = NUMA_NO_NODE;
+		goto retry;
+	}
+
+	/* Found nothing... :-( */
+	return NULL;
+
+found:
+	/*
+	 * HugeTLB pages can be preserved with KHO and no preserved memory can
+	 * be in scratch. So retry if found address overlaps with scratch.
+	 *
+	 * Scratch areas are normally not very large, so this shouldn't take too
+	 * many retries.
+	 */
+	if (kho_scratch_overlap(addr, size)) {
+		if (memblock_bottom_up())
+			start = addr + size;
+		else
+			start = addr - size;
+
+		goto retry;
+	}
+
+	if (__memblock_reserve(addr, size, nid, MEMBLOCK_RSRV_KERN | MEMBLOCK_RSRV_HUGETLB))
+		return NULL;
+
+	memblock_prep_allocation(addr, size, true);
+	return phys_to_virt(addr);
+}
+
 /**
  * memblock_alloc_try_nid - allocate boot memory block
  * @size: size of memory block to be allocated in bytes
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index b6b1d147fd75..e86bb9000b22 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -66,4 +66,9 @@ static inline void init_deferred_page(unsigned long pfn, int nid)
 
 #define __SetPageReserved(p)	((void)(p))
 
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+
 #endif
-- 
2.55.0.141.g00534a21ce-goog


