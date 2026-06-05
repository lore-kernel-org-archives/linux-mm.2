Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F186CD8C83
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0166B00B0; Fri,  5 Jun 2026 14:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4F46B00B2; Fri,  5 Jun 2026 14:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737B96B00B3; Fri,  5 Jun 2026 14:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 564286B00B0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19A5DC1566
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:54 +0000 (UTC)
X-FDA: 84846713028.26.EEBBF83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 87A1D80011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+JEX5bD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPW7ndBXFMlA6BumIKFLGL62i1vzthwDUNuAA0KAxEI=;
	b=YSS3+yfhsW7gKeqcmmSELveolnsWJclfbJnlriZtJrmYV52FFr3fajQBVpzJZRHc8b3001
	BIhg2iQvA43o2X+G6Ra8k343FQaLOveouzazH0ZejaD/i0KGkkpOUajgCjkuoLmqZC/2NY
	SpnM3I818W/oio/aHdN7B1xVDHOL/pM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+JEX5bD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684552;
	b=0bQfct1H1TFRKxeaOAac0muZxbabcgtY2gqntGzdoSZK6/8N0ym6vn0YXiAMpcIK2VR55r
	3aGF4KKwM1ymmryLdwshaTaS/l95TmlnTJVi6SVs9gZ+t7N56VDtRaiIGGVDM96y2yQNN+
	Sj0Vv6/Au2P8rJO04efpZJGO2r4TJNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25D69601EE;
	Fri,  5 Jun 2026 18:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD5E1F00898;
	Fri,  5 Jun 2026 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684551;
	bh=jPW7ndBXFMlA6BumIKFLGL62i1vzthwDUNuAA0KAxEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+JEX5bD/I8m0d8e+OQIBAsmVQ/s+zaYtMEOhMZxjsUC1DvogGlpCdU5fU7dSgDuK
	 8FOWQdo9Jdkn1RAHZ4OeyZNGINZ3xZfaxNiixKoxDT6cDEs4v0ExWj/oQ5Og3nyed1
	 ASfJel4zQfjp3wIDec1AM44piTUCmrOYJfw1mOBrZWcEVcsnMDYB/CCcby8ha8JwCz
	 +GCjI0StGsXqftjYieXLfwS/4R65Yt/er8LvobiSDz+DNU4x8j3rcON2Tq4V9pXNrL
	 67yP935PjiYOf1ITt6cFYJ+tZrJJClDC38cJ62veB3lkZvct/6DCvZ9bW2mGxop0E6
	 UsLSLdO/jBwdw==
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
Subject: [PATCH v2 16/18] memblock: make HugeTLB bootmem allocation work with KHO
Date: Fri,  5 Jun 2026 20:34:49 +0200
Message-ID: <20260605183501.3884950-17-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87A1D80011
X-Stat-Signature: xsueasnebn5kbzobmsgek8by17orjd1n
X-HE-Tag: 1780684552-695282
X-HE-Meta: U2FsdGVkX1+5coz1oFlzO/i9OhenUu3ZS11ZybMrDqkSSpEg5eeHCUgf2j2hZHGfA5obTfcdLqSeemulz4B6ry7iz7s7oUL0v6LbZqqQSgqMXpXkSlbIe2mZkqNKDwGgMMsynvk+PEgdsGHJpLlK87rtCqwsrmN2gqgBy3vipoiUa4u7GcA5vkXmVqJPMCcJU4z0/3Pnkle0NHpcdpxf2EdLaRIlc4YpEtYXo95lA/+drJ7XADzrZIbDNR+ByYyk8DR5Z9pCRjz28sTrYae4UNAady74FoRhonaFpQgF2U/RFeBvmvcosdgVrCwI56s0w5Af3jCkGtzArBMNGuHIVC7oKYuSi30mX8MDYBEgWVVfoELEEFqwriT0T7T3oynqHDzNSoQyX5AqOXxrqtIXCNWTQw5MtkoWr+/dM5pDCNYLSIDs5UqVpWv1cOda5hM7SjZOSF3VcqOq82W0JImMUIhjaZaFRP4MqqCESW1WOOwIt8QercCqfvEQ+yPUgfvqBvpw9wnkIBpz9KU27X4Kfjwh0iH95/snANMuBS9bzB6IuwAbrCLTZKBRG57g3tvA0dk77D5vEmXlkK74GnNzUH9xFCc6k9YQaBZ5m4r1RKRk0jaRl3eFNmTxVl8WaL6JEjdmT2hQfN33dq7lu4ajvv+WgXKCJ9ptiGmABDGciw54lXiF0fk7k3FaDt7D3KbeKDcv9qOEv+D3aQiDfzIlht/1Mslw17g6R35TN8yFh3RIsrr6NVYi0aobjTlD27Wh2pWpxkSaKiyNvUJqKr7RyR+WXs9S1sHL1wmZ7goKsFt3UlfzDIFQ7GQAlGWxFMPRfWNYakK/tlmK2hdLdMZwqR8G1RVNz7U5rFvu+yeo4kuK0X2WskwCyaTlX4Jp9wmWjHs+WV4KXVxeR0KtLo/APJ0up/dp/Lc1z+zXlxLfif8V+Z71Gv6YEwpsqkDt5S5a9xQCFnyu9ZbG4LiEBKi
 saCUCPnE
 aaUZAGp/O9qa7jXjL0kV7seQ07K7q7Ev8e+sBaJUQ5N4PEXlzNGF57d0iADBdvkQupZm7QlLTDPLFR4ynasuVbFi8hAlWSb7PZtaFZmrc/aGCVBe+m1yKlg3C+UssNBl8Ur0ewCiPOW7YghLC68c63UqbU3dEIRDxtFY22DhddSfVHhQdciO8/xlITeeg/QVai0/VMEYTFWUovz5y6+JXtmUvRqTBnDbZ0uOmBCTBb9+Prsw=
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
alloc_bootmem() calls the memblock_alloc*() APIs, the hugepages
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

Second, if the memory found overlaps with KHO scratch areas, it discards
the memory and retries.

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

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h |   3 ++
 mm/hugetlb.c             |  22 +++-----
 mm/memblock.c            | 112 +++++++++++++++++++++++++++++++--------
 3 files changed, 100 insertions(+), 37 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 546d7ef798b8..b3b4a6145fad 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
  * memory reservations yet, so we get scratch memory from the previous
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
+ * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -62,6 +63,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
+	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
 };
 
 /**
@@ -421,6 +423,7 @@ void *memblock_alloc_try_nid_raw(phys_addr_t size, phys_addr_t align,
 void *memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
 			     phys_addr_t min_addr, phys_addr_t max_addr,
 			     int nid);
+void *memblock_alloc_hugetlb(phys_addr_t size, int nid, bool exact_nid);
 
 static __always_inline void *memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b80b167cc9c..fadcfa267ceb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3029,29 +3029,21 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
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
index 6349c48154f4..131e54dd5d8d 100644
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
-- 
2.54.0.1032.g2f8565e1d1-goog


