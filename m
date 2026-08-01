Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A64C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED336B00AE; Sat,  1 Aug 2026 04:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6256B00B0; Sat,  1 Aug 2026 04:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF386B00AE; Sat,  1 Aug 2026 04:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4D856B00AE
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5952F80253
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:45 +0000 (UTC)
X-FDA: 85052077530.12.25F3D8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BFDAB2000A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TGFdElrD;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUYh1XVpyuFv2NFQq7Z2LsqK+jIMTcX5fIOqnoQbuC8=;
	b=wYS3L4+dJ4DAliJkuknCKX7QC/3isAnimBA4T3T3X3FEA/13LnJyikReAJse3XwWXWuU/u
	O2Uldg1x3xl+ZAm5wpxOGONpnnBEPCPtLNBtVVyhpCR/lrRTlBU0jfKsz0Co9cCL0JRbfl
	7lPtXlxhG2XSD36VGQJ5jjGMpHP1uXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574183;
	b=X1wWpySg4Z3ZP/wnPsTzmvJiTyZjPaNwB/AARF4yIBdV/5XDl+LprDh0t36BAtSGxS1o+C
	cki92yUgz9u+6Foz+pSqOy1f4SezNR4MuO425hQUFrfM04eVZLgpCU82p3nTYkRLG94vwZ
	svJpz7En+kB95mU4pkoihG8ZHZEx6LU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TGFdElrD;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C49460AA8;
	Sat,  1 Aug 2026 08:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB061F00ADF;
	Sat,  1 Aug 2026 08:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574183;
	bh=YUYh1XVpyuFv2NFQq7Z2LsqK+jIMTcX5fIOqnoQbuC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGFdElrDZRvZJHHIjb74yh/6eWwEy5x4BQY3qOm2Jwzwu6gSPzFQLgI0GiE6rPFXb
	 msa6bP9YDVR/YrKFXvonNmZYWs7yzYffgAiMjo13NMqCujGAdMZPCvW4EiBvGJaZMa
	 OIt8zIqXaYklrBWWjKHl+YQSVQ70biwLGMDazixBo24ouj9uMy5lXUhiePK1Ecl5fC
	 fXIcTXDfRoUxNvbOaws8+cmkra8hnakdQgPPiPOaoJt5j9AYbWStP7E3WyHUzRHmDX
	 myGWTOAq3p4t0FSuPEpqwG8XtaSXgmLc2v6EpSFaYJ39ls4QHFnjeUUBjHHJF6F58w
	 JUu3qNY7qLcpw==
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
Subject: [PATCH v6 20/22] memblock: make HugeTLB bootmem allocation work with KHO
Date: Sat,  1 Aug 2026 10:48:29 +0200
Message-ID: <20260801084833.1897543-21-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BFDAB2000A
X-Stat-Signature: xghbr5k3ba7ixeet6cxra3ppqimx5ew9
X-HE-Tag: 1785574183-496559
X-HE-Meta: U2FsdGVkX19NeGeEINDQkZ/5VNSkvgESK94WKtYWUU26eb9aRPfwUI9JTtntMMR5JSPgBuBCptoh2lkUFuElEhQjTzdUKW2p7a9A6oOzaUEiIr4bAu7LKe6v8bkTqILrrQsebWrTOwPF/1ds4JYmsS9+520TjgxJm/F1d+ckStpUDJAp2XnI7EDQbFXWLh9x1RXB0bNkCXRYcozXJv8PeS3a0rwzWvWEGywV9d8Pd8nIgGwJYHbnJBeMJ78Wg7IKG3g9tZgKzJQZm22F1yPesCJQVPHGGIOeRw16Lob1hrjMEv+Q2NVRoAXCBfZ9RPQDKjxaeUkKTAcS93jjgKn+lwDUUfdZptt0jRRkp2l8EVOD3mUJMTXpnCviLi8g8p5TqS4PUB4HAbYvItaHlZs9ShqkaCnjqgvVNkbw+6oLB7yUYAQmcwEabZ4Rg8htbyzLKgKQpqDSInGoyI/0wmmKZ6VEvaen9Q31CycG7t0PMU92FdkikFWLzWAjObnzxYIDTdvW457L6FxLPpL8Fc9VR4GzZ4mqNG0YBOIeL6CFvmoM2eGsVONdzYbZjsX9smW7ZZ48nXEZskvEH6Amp4eHlNxE0lzu193J9BJ7bvg41O+ocTR2WdfPYd6OzF/qLmNngi68+GfPg1ux5Dzx0zgkzoX9JI2NDaOxxrH5bXgrtULoc1jei0EGuLmzRBBKJlqAMkobNYvV4f3lfhjCBlxZvmrNE0eFS2uF1KssNpp5AWRYIGCXtk5Ad/U+wwlpXFmmgKmKgVxewEyQmfKilAGLwVZUHywbWy6ziFgG3kvI9PD0AQc3AjVeNxJNV07F8elqw4PBRzO4ufG3+eitMHBnukg+yzmpmbWNhcaRMkrGTdvYxV4HKBTE9uQmPJlzW1XR5OcE/cRR0NU5F3zFBaXSOxSvLglWuME/6SN0Jm44nQxy8ik9p8cYtS+nI2sFCuGJAQ3TY5XmXZUn6r9GryA
 KCDj3WFn
 YO/LcYJ19pfBXbSaqZ4Zb+iecQ7APzBa1fcbnRkJUwkFETxWJ90RfCENeOAr7J2Zdd1Sr8gtUq+xQOnM6a2+tr6n03rQ1t4PvEGhP9O4bL4CNENGbx3Lg+Bhm2Cd9DtxIULlFfp4KeEUijU1ZBI2+wPiFUXmpynxFmynWYN7jIp72ubjz4J/o601MsmTS11GW3jI39MQhfX/OdfxPXFs7hwTrWDy+kLZ4Altc65HGpGEdWAo=
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

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h |   3 +
 mm/hugetlb.c             |  22 +++----
 mm/memblock.c            | 120 ++++++++++++++++++++++++++++++++-------
 3 files changed, 108 insertions(+), 37 deletions(-)

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
index ea735bcd4dd1..77c6540e7528 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1504,6 +1504,32 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 
+static void memblock_prep_allocation(phys_addr_t start, phys_addr_t size,
+				     bool kmemleak_trace)
+{
+	/*
+	 * Skip kmemleak for those places like kasan_init() and
+	 * early_pgtable_alloc() due to high volume.
+	 */
+	if (kmemleak_trace)
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
@@ -1578,28 +1604,7 @@ phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
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
 
@@ -1754,6 +1759,77 @@ void * __init memblock_alloc_try_nid_raw(
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
+		/*
+		 * If a previous candidate overlapped with KHO scratch, it would
+		 * update start or end. Now that the search is opening to all
+		 * nodes, reset them.
+		 */
+		start = 0;
+		end = MEMBLOCK_ALLOC_ACCESSIBLE;
+
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
+			end = addr;
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
2.55.0.571.g244d577d93-goog


