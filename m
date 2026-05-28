Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8929CD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5376B00A0; Wed, 27 May 2026 20:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528E46B00A1; Wed, 27 May 2026 20:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A3B6B00A2; Wed, 27 May 2026 20:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 214BB6B00A0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE0131A06A5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:32 +0000 (UTC)
X-FDA: 84814977744.15.1A3A45D
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B6D9C000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bVQv5xaK;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+G063ctdwqAq59myRrIwk7Q0GStjlB0cHg+gbXD+SNA=;
	b=Hm96BvH2ThqgP8iUj4Lah1MDFvnsYEqW8SD+eHJ810VfmVtKZo5ZGiYnp60ljo4dk0Vv27
	GF/Pd3UQ3E3PT2Orng7C8BVnD64UWoDSV36bxe3/kqmsLI+wv4Yfr9ltu1SbjlDxs3vZcU
	kkkO64tK7qZdTM+wFmYQ4WEM3T5vimU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bVQv5xaK;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928951; a=rsa-sha256;
	cv=none;
	b=vifHc50pHhhOqhFrlaogJe4Y2YnnLXR4SKaVQ3YRPLL2WagU7YgsYXskjXzD6ASWR2VbiB
	8KQ4/yDF0Ch87DsDgPxpePDoYP/ioD+WqU2trfxTeyR2V4zPBuQAHWximDFZW/afDgH13k
	9BOkn6hKbnYYgbQsyDyyDeHiSMwmCI4=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 44D8420B7170; Wed, 27 May 2026 17:42:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 44D8420B7170
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928940;
	bh=+G063ctdwqAq59myRrIwk7Q0GStjlB0cHg+gbXD+SNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVQv5xaKggle/Bw2P9ow3DP6wVgMoerP3uhclUMczMpmBc6gJzRAXV8KwcrctrbxH
	 JsjTAsUXMIHGhqkoW+8gDqhmDvAI06KFwEi2M1IPzw2+Q5lDO3d0oKRlcnmMZxR9nn
	 +z1rC4KbcHJIE9nNpT6yaPtJtlYI+ggAx7fAOGyI=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 12/20] mm/hugetlb: make bootmem allocation work with KHO
Date: Wed, 27 May 2026 17:41:54 -0700
Message-ID: <20260528004204.1484584-13-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: een9n4f47mi7xuqthga4863j59p69154
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2B6D9C000F
X-HE-Tag: 1779928951-585023
X-HE-Meta: U2FsdGVkX1+c66Q+hxlaubo6g8NJvU+5FMFnM5H84XMsvD148Zh/QtjHnGk7uM1SA85VrOtWUx1EjzbZQhm8Li6o1MP6kb3fwasvaESYvcGjAHAbQb/yJZCRyq3uCIZjy5dc1iEHGwvbyYfhSM2dbcN48Fxo8v1cNs+VGn9GVgpqCD0jciRuNgJQY0FMdoDmulhXhp/9mY6HL5dPeT/21+yYt5iHPlx8GBEZLG6BB1QGzHcpPvyGVRVF3ssh9zWSWQTvoGFcfhh1x27w8yRuJ8UDRWUnWQ8jf2wo9m2cacKauEkKMMG6cfjQh0B4/m6Z0E/WmJS0r7jbU981hkqjCSPPMiDbGgYJEtXeSHQQO5jd08pLshxEdbI5qrzkrtZ63Er1SLB5S1HU7a2fID9/8WyfPoRXVuJrjLoU0Hdea1EAYt25zbP4A3i4BHHkPL+MPu6u+hbIOpJFSyThg1q6BVUcTnZ0ZBfTJBAcix47csiViIdwZKfzlFVGUoK/n7dv3PjxcvyAo7uvVHFOoI7lJBf0/fsOAsZ5N/ciasZF7avEkGTsPtoLYq4rVGOdDswRFa74mE2b5peMNdPTkoU1R3T1/U9zI+kkU98aQEHYQ/L95eJNZvmA5E9A0JwaXjQgMwE61ajrbV95wHtAFEh735swYTwggg974YJgF6aUopadivASJ1zFXzQHkTzxk9Nm4JeOSVwnWjQEXlwN+C1DfRqmFY5ys1pZoLzKJ4W0rfbQi9TMqF0Pllb/ZCrUK2eoHO4UGCSFxJWEgRgaKYCwfyc25jDp1R+zpsaDQU9sgDoOWFD5tuFMBSuo2ren/Hdjlhh/pWCFZ4IccvCyMq6LSLA3Zn2ndVkTSNFGOa5HwGvwHy9V1C1nvQYF70NmUg6R8PxQBJnAaLH7dToNjFl1jJGD3gaMajXigeVikinIR1a8y23HS2qp4PGwQFN1QLKlNEEctFuasW+ggxAbFk5
 x4u5VZZa
 CGdsYEtSxExjaKlHmk80eVLuefe5EyrSqNTwCI9QXaJyT03SHYGWkI2vduZUBFF/Fpwhq172sHql9Hv55JM/Ccawq3QLNw3OgXpXGK8MDlXEmjiWgENOQsPOre9gGgrPpsuDn1ZlU08mjs1gi1AHZBerpQApy/EOSKa/U+JbH6bru+ii8FYGwHFNhW7jm9k0FdFcOnlfk8uSlGLP1RNaczMO6qtjoEuf7z7EAC66nM4rSKBkdKvMBErhc439OBYcYru/8ybb6ZYMPvAU78WO7tcahIg==
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
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
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
index 571212b80835..46f2b1bd5abe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3033,26 +3033,19 @@ static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
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
index 6f76a6bb96d6..8cd52d34ad6e 100644
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
@@ -1175,6 +1185,20 @@ int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t si
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
@@ -1534,37 +1558,11 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
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
@@ -1633,6 +1631,41 @@ phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
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
@@ -1784,6 +1817,47 @@ void * __init memblock_alloc_try_nid_raw(
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
2.43.0


