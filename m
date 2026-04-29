Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29674FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7A96B00A2; Wed, 29 Apr 2026 09:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F556B00A3; Wed, 29 Apr 2026 09:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F86F6B00A4; Wed, 29 Apr 2026 09:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE6A6B00A2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E71A2140274
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:14 +0000 (UTC)
X-FDA: 84711702348.28.D1F97CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E70D40002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jOI2WwuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470013; a=rsa-sha256;
	cv=none;
	b=edWKZc2wIHKk1yZd0izEVfKr/QRFSiISaIq1xdqINB1HEihNryJSIlmTFkH4qxHt2NKnr5
	BwEKwJZ90a/28CeISUVaPuPXVjS58IrctgUYrAV52RXAwwwAU8Cn/24AuP333UlTIfIr3x
	pZOLt3XrFGT6vFQGhikyyakNavuHvfM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jOI2WwuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Db16u/o8Bl9R3A+gUowH13nNiAOqM6eGtUya+uogmHc=;
	b=GT+jp9BgOs69q174pZw1l7/sohwSDo05Fj087nqSFDwhOWbGR7kP8BAg1hXjSAY0yjbxzM
	LwDNYAZCSn+PlzuW3sh5yX+LCW+vWHCooa3V1JcfUlpnwjPNckPd1rWVFuWs2OBvaO2dBK
	5o8MSNxH3CrldkgWaxrUHKGB81mdenA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59A61442AC;
	Wed, 29 Apr 2026 13:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2C0C19425;
	Wed, 29 Apr 2026 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777470012;
	bh=LU55tlcL/y5Dvw2CMKDLuxBuqllrlC4je9HKT4siEk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOI2WwuTUXT2dH3dciuVs5qQuyVHqmJNVUXJRlNurMr4RX0gyj4zxKIhZrOzCxaXf
	 PAmGuruB1l9XDdcCwTALDN6OaZiPz6XmYXakHUrh8dU9o19yMdRacl7acevPpu+AwS
	 ypmAG/C84+iiDatEdM86DKP+Drbw8FjjFtbPdGPG3DBahsp5BKvz7U5qDyD1aqk773
	 F53HFBD2W95qGohKSv5mo949+LDrOGFCq3x53gn7KM7UTPdD6cpXqvJxw3mbf3mtyK
	 9GiC/GJfcmoXyX02ITWyEZl891R8WPzYbo/fuaOVroftoIf9Kid1g7TVQpTRs18xko
	 Oexn/U5s7VlEw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO
Date: Wed, 29 Apr 2026 15:39:14 +0200
Message-ID: <20260429133928.850721-13-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 78ad4uf6sg9w9zxqu5wrpqc1sbdxmpc6
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E70D40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777470012-1353
X-HE-Meta: U2FsdGVkX18m2ktkA6PHm6wsWajcd7K1gNc/L3yt61bcOk9Fa1ja/RAdhrxL86FNVlpZxhTyVlrjfjFNAYkSprrohXLDScIcVgsTgSiBwreE9QYRSQghTyjLFIzLX+Cr2HVik0sAC7ClD0HtNaewbi0xgNgWr1Z1g6FhDSyqorGD89HBwxcAKWP17xrHwXqKcCraTMSu3G5KrznL7SjW4iRkEYUNwJb6jQWnZD2Ve4N7PSw2nHJikSTmEwOmpGc+WgmeWIripk9ZuuSeRcALsd7roMoVIfAk9/dwNsclaNXvZ2kkDnK390r63ul+ozMiYKuFxGnSBjWgNql2jDhpQye1AO93yhST35ULiKpggiRANkqSsDkoNFYAWpExJ+BT/gueiW0CEOlDuKA+jYnZCAcLJDNTT7y0QhKUrlGtbr2tRIAjPq2lRZyslMvT3QjuEYrRKyft39+Osu/ktiMPF4bwoPqjBjcm7LAqnpswtN9VuarfNMqW9BFcQDQdfvEzN0s9dxTDmN0dLyfxhNXH9ptmwuFPX63DWGEv3X2DPzzyW3psFTSOJk9sYaK+h/OlCuYpxPTAu07cuwsCmZ1LkMfZwRFwdhgsDBgXF20uenpMG6LU+8qNtc87fgWRLSn6pFQIaFzj6yB7edCoCFibKrl/SVNjMT4xX7N/XGQqkHP22ZiNSI9pN0BT210cPD3/kv9u7ETK9203wcdHvLLitE7oxVDS3gJY1iSAVixKPbOGtiUEF7Dka93aeeV0NPEA6zmnweWBfWaDA4qD43COAPpVxkfEwUerRSkuUGbWdJTmbkmgFU+GT8FsAcmHmm8U4mhaOZ1cYvubuXKiULPpe5TGlKur7LpnBxifi+OWOP3NMI555L192vUBMZq9e0DoaOZQWw7K7Qir+EfObi+nGnvCvigBKIoKp+QXljB0xXQfq69cHHGtQ4eVFXpHoyB3RRe7TqY8Yb8u9WOZoqJ
 QhGs6A/f
 wWhxbruxbBhFoZZx/xhq4/p9qQ2S5bdzDParXPmRIuLXNrncR7VlHVNqEVbI34fYIvoimyXOmTGP/ut32V1A8L6SoDfr6X7IX77ul+r0766PXKxU7W4zu4JfWnq8oczN72Rl2crsZIrhw2w7KM3aautEskGgalt4jx3AR7Tf9nA/OGy3kIyD5UjaM68MITTTZV8l6FsMpKDqD7uJpotfAIZrvhhORBRhBtVYt/BlT8jjcET8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Gigantic page allocation is somewhat broken currently when KHO is used.

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

Introduce memblock_alloc_nid_user(). This does two things: first, it
instructs __memblock_alloc_range_nid() to not use scratch areas to
fulfill allocation. If KHO is in scratch-only mode, allocations will
only be made from extended scratch areas. Second, it removes RSRV_KERN
from the allocation to make sure it doesn't mess up scratch size
accounting.

To reduce duplication, introduce __memblock_alloc_range_nid() which does
exactly what memblock_alloc_range_nid() used to do, but takes the flags
from its caller. Then make memblock_alloc_range_nid() a wrapper to it.
This lets memblock_alloc_nid_user() re-use most of the logic without
causing churn to update all callers of memblock_alloc_range_nid() and
adding yet another argument to it.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    Checkpatch complains here about the alignment of arguments of
    memblock_alloc_range_nid() with open parentheses. That can be ignored
    since the code already was mis-aligned, and for good reason.

 include/linux/memblock.h |   4 ++
 mm/hugetlb.c             |  19 ++----
 mm/memblock.c            | 138 ++++++++++++++++++++++++++++++---------
 3 files changed, 116 insertions(+), 45 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 4f535ca4947a..c7056cf3f0f2 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -160,6 +160,7 @@ int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
+int memblock_reserved_clear_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch_ext(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
@@ -431,6 +432,9 @@ void *memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align,
 			     phys_addr_t min_addr, phys_addr_t max_addr,
 			     int nid);
 
+void *memblock_alloc_nid_user(phys_addr_t size, phys_addr_t align, int nid,
+			      bool exact_nid);
+
 static __always_inline void *memblock_alloc(phys_addr_t size, phys_addr_t align)
 {
 	return memblock_alloc_try_nid(size, align, MEMBLOCK_LOW_LIMIT,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be047..5ba393b0a581 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3049,26 +3049,19 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
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
+		m = memblock_alloc_nid_user(huge_page_size(h), huge_page_size(h),
+					    nid, node_exact);
+		if (m) {
 			/*
 			 * For pre-HVO to work correctly, pages need to be on
 			 * the list for the node they were actually allocated
 			 * from. That node may be different in the case of
-			 * fallback by memblock_alloc_try_nid_raw. So,
-			 * extract the actual node first.
+			 * fallback by memblock_alloc_try_nid_raw. So, extract
+			 * the actual node first.
 			 */
-			if (m)
+			if (node_exact)
 				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
-		}
 
-		if (m) {
 			m->flags = 0;
 			m->cma = NULL;
 		}
diff --git a/mm/memblock.c b/mm/memblock.c
index 79443e004361..504b5b0c8af7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -178,11 +178,21 @@ bool __init_memblock memblock_has_mirror(void)
 	return system_has_some_mirror;
 }
 
-static enum memblock_flags __init_memblock choose_memblock_flags(void)
+static enum memblock_flags __init_memblock choose_memblock_flags(bool user)
 {
 	/* skip non-scratch memory for kho early boot allocations */
-	if (kho_scratch_only)
-		return MEMBLOCK_KHO_SCRATCH | MEMBLOCK_KHO_SCRATCH_EXT;
+	if (kho_scratch_only) {
+		enum memblock_flags flags = MEMBLOCK_KHO_SCRATCH_EXT;
+
+		/*
+		 * Scratch can only be used for kernel memory, since user memory
+		 * might be preserved and thus can not be in scratch.
+		 */
+		if (!user)
+			flags |= MEMBLOCK_KHO_SCRATCH;
+
+		return flags;
+	}
 
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
@@ -346,7 +356,7 @@ static phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start,
 					phys_addr_t align)
 {
 	phys_addr_t ret;
-	enum memblock_flags flags = choose_memblock_flags();
+	enum memblock_flags flags = choose_memblock_flags(false);
 
 again:
 	ret = memblock_find_in_range_node(size, align, start, end,
@@ -1173,6 +1183,20 @@ int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t si
 				    MEMBLOCK_RSRV_KERN);
 }
 
+/**
+ * memblock_reserved_clear_kern - Clear MEMBLOCK_RSRV_KERN flag for region
+ *
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_reserved_clear_kern(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.reserved, base, size, 0,
+				    MEMBLOCK_RSRV_KERN);
+}
+
 /**
  * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
  * @base: the base phys addr of the region
@@ -1532,37 +1556,11 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 
-/**
- * memblock_alloc_range_nid - allocate boot memory block
- * @size: size of memory block to be allocated in bytes
- * @align: alignment of the region and block's size
- * @start: the lower bound of the memory region to allocate (phys address)
- * @end: the upper bound of the memory region to allocate (phys address)
- * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
- * @exact_nid: control the allocation fall back to other nodes
- *
- * The allocation is performed from memory region limited by
- * memblock.current_limit if @end == %MEMBLOCK_ALLOC_ACCESSIBLE.
- *
- * If the specified node can not hold the requested memory and @exact_nid
- * is false, the allocation falls back to any node in the system.
- *
- * For systems with memory mirroring, the allocation is attempted first
- * from the regions with mirroring enabled and then retried from any
- * memory region.
- *
- * In addition, function using kmemleak_alloc_phys for allocated boot
- * memory block, it is never reported as leaks.
- *
- * Return:
- * Physical address of allocated memory block on success, %0 on failure.
- */
-phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
+static phys_addr_t __init __memblock_alloc_range_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid,
-					bool exact_nid)
+					bool exact_nid, enum memblock_flags flags)
 {
-	enum memblock_flags flags = choose_memblock_flags();
 	phys_addr_t found;
 
 	/*
@@ -1631,6 +1629,41 @@ phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
 	return found;
 }
 
+/**
+ * memblock_alloc_range_nid - allocate boot memory block
+ * @size: size of memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @start: the lower bound of the memory region to allocate (phys address)
+ * @end: the upper bound of the memory region to allocate (phys address)
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ * @exact_nid: control the allocation fall back to other nodes
+ *
+ * The allocation is performed from memory region limited by
+ * memblock.current_limit if @end == %MEMBLOCK_ALLOC_ACCESSIBLE.
+ *
+ * If the specified node can not hold the requested memory and @exact_nid
+ * is false, the allocation falls back to any node in the system.
+ *
+ * For systems with memory mirroring, the allocation is attempted first
+ * from the regions with mirroring enabled and then retried from any
+ * memory region.
+ *
+ * In addition, function using kmemleak_alloc_phys for allocated boot
+ * memory block, it is never reported as leaks.
+ *
+ * Return:
+ * Physical address of allocated memory block on success, %0 on failure.
+ */
+phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t start,
+					phys_addr_t end, int nid,
+					bool exact_nid)
+{
+	enum memblock_flags flags = choose_memblock_flags(false);
+
+	return __memblock_alloc_range_nid(size, align, start, end, nid, exact_nid, flags);
+}
+
 /**
  * memblock_phys_alloc_range - allocate a memory block inside specified range
  * @size: size of memory block to be allocated in bytes
@@ -1782,6 +1815,47 @@ void * __init memblock_alloc_try_nid_raw(
 				       false);
 }
 
+/**
+ * memblock_alloc_nid_user - allocate boot memory for use by userspace
+ * @size: size of the memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @exact_nid: control the allocation fall back to other nodes
+ *
+ * Public function, provides additional debug information (including caller
+ * info), if enabled. Does not zero allocated memory, does not panic if request
+ * cannot be satisfied.
+ *
+ * If the specified node can not hold the requested memory and @exact_nid is
+ * false, the allocation falls back to any node in the system. The allocated
+ * memory has no restrictions on minimum or maximum address, and does not count
+ * towards %MEMBLOCK_RSRV_KERN.
+ *
+ * Return:
+ * Virtual address of allocated memory block on success, %NULL on failure.
+ */
+void * __init memblock_alloc_nid_user(phys_addr_t size, phys_addr_t align,
+				      int nid, bool exact_nid)
+{
+	enum memblock_flags flags = choose_memblock_flags(true);
+	phys_addr_t alloc;
+
+	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d %pS\n",
+		     __func__, (u64)size, (u64)align, nid, (void *)_RET_IP_);
+
+	alloc = __memblock_alloc_range_nid(size, align, 0, MEMBLOCK_ALLOC_ACCESSIBLE,
+					   nid, exact_nid, flags);
+	if (!alloc)
+		return NULL;
+
+	/* User memory should not be marked with RSRV_KERN. */
+	if (memblock_reserved_clear_kern(alloc, size)) {
+		memblock_phys_free(alloc, size);
+		return NULL;
+	}
+
+	return phys_to_virt(alloc);
+}
+
 /**
  * memblock_alloc_try_nid - allocate boot memory block
  * @size: size of memory block to be allocated in bytes
-- 
2.54.0.545.g6539524ca2-goog


