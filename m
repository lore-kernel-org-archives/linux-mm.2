Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6CADC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A4D6B00C1; Sat, 25 Jul 2026 13:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741316B00C3; Sat, 25 Jul 2026 13:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608026B00C4; Sat, 25 Jul 2026 13:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1B26B00C1
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:22:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF22440347
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:22:36 +0000 (UTC)
X-FDA: 85027968312.13.E2302BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32424100008
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:22:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnMVulZp;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbQq5fTVtu9fBhIyNC1JJ8ur25QqdL4Ptf18o3vyjpU=;
	b=0k6aNZs/CDBR6ZAnDS7oAlaotB/cr2+Uk1fteP/UtH5Gb8A/cForNq0EnW5cZem0dMVt9h
	g5vgZQ4oIHCFnrtjUGuTwcQRVjXN0fkR4990L7bnBN4z0GGxNoBntuZt++2egSB0nTOKso
	gu3wKZOqLaEKCqXwmQjLNp7C8IzDcx4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnMVulZp;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000155;
	b=oY27zic/PcWYBp/r6U1sODpNH3QkSSoew/p1lGrfdFAIJukPv35ZCCiD8X9WJ8fxYanVT4
	/RBR7SjBEnQpS7z5U7+eZTRLaAFX3uUS+3EquXSXy5i/8g/StHoHF2kgqFQxoQPYC8HUmf
	nD2kmE/gzj3savvaUiprAPi84SLH5K8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0CB060A6E;
	Sat, 25 Jul 2026 17:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1141F000E9;
	Sat, 25 Jul 2026 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000154;
	bh=sbQq5fTVtu9fBhIyNC1JJ8ur25QqdL4Ptf18o3vyjpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnMVulZpa7WPuAMiejkOtSQN2gBzUpCBh8WBeDJbJ6RiL+8toEL0t9IgU+PXlcWuU
	 ub/+ZCsCm7feo/j6K7eb1uvW13tzUjdLyTTdG+NITrTY/4TOoLC1z2ZLrKCi5JSCnw
	 Z4cb2kzKmQf0g407K1G9gg8C2YMEQjM+3gVjngMuUguO+gmKAlnsh2w/UaLmUQ4K3j
	 qdBrcG+v41rJY3gUOgi/BomU0XtdjwCZtMoZWxI9tQi6uMDWvmOLpXIwdV8fZAttAe
	 MDmOqd+xLfcZ9dMCpHLLQPUmhUVS6e4JxwekXzCzqbXy+ZFCFSehRfkFjtyu4nG8nz
	 3XACAD9KGl1qg==
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
Subject: [PATCH v4 19/21] memblock: make HugeTLB bootmem allocation work with KHO
Date: Sat, 25 Jul 2026 19:21:19 +0200
Message-ID: <20260725172133.4018491-20-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
In-Reply-To: <20260725172133.4018491-1-pratyush@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32424100008
X-Stat-Signature: wswxo3dtw1r1y635z3hz1xrf3g9k9o1y
X-HE-Tag: 1785000155-815888
X-HE-Meta: U2FsdGVkX1/d0sN2342g2Wpb+AOEIlbG1I245Gl/aKGAXduE/oF7T0WWa8hj+fdUJ/YtBtXUR3iuZWfC3lNK4FbFLNVxCRXf6kPDh9TxV2qci7JtQIHIoeLAk0JrB8Jb+LJ63+SJFOyDYy6GIhXbG/31jrPtKUfPA4ig/TrxCW++HGzHzYYxHHA62f0vxEszYHNNXG/IGvGQgkODG4WwUyYJBxoOOl4vhEHX57dlpd/Nbwp5iKE/Zwd9D1WQd4FhPGSQSXVvgbJzguBpzV5z/3r1FPEy9lwwtywLEvAxJoou13CGhANO4XmH3rY3HBkWK/HFchtEPFFyjbRd1EUTA5v9bUQRU+BauL5R8U8dZfbh11Ro/JDL8flifyTBQbk7kw4Tr8OMjIpxfwpZrXdPifZXxu22boX8lB2dOZse9L3n1yQZbxCbfl3reQMUNKV0+4/9Bd9gBL4RcCNkVPykRp4jqnZLEVWerz+opPwWErkyiWUKLxZzH/U33z4FPD8vlDt81R9NmA1RbPsLr5JVfGgjqyTPps3xczzUFH+69q6UCahOubt6IoOlXo0ReRtLe8P3x0nljIpWr6VJBeaK+srMGkSaW0aQPbBDLBYrrE4hAPPd7Doemyo/qdxRIB7H+jokF9oogcREJoG+bQaZB8Ahr6Y0kfaaZqGANt8R7LX6bFCzz2SVB6YvGrgCyLqj052IpxAWgrxtruej60Qp4DH5CtxaRcQE1W0icue92glAlC5FaIPswd6aTAwn6XPZkXtOqeNKf8VmNBO8b0Ek5Ir+i2e/4+3s1TomnQHxO5HM8WP1/m5XphXBIGYqpPqYkt2BXS0oYBeX9qC2LXZFM2HKsKXOAzBVRcVrrA9VsUfA7oFwqGGGV/PedMCN0/trRYZGJL4+krFQoFDPbxdPHIfQW+IbQxYEWDuZx3gBTmTAx8LkDQKNuYueXsGPLnCnfvgsrJRMWM8dtCjbzKP
 gBh3PbA2
 dh1fqmO7P/I57X73d+cpGqXUPOrS8zZwoGCIeGku7HJ50NO9LuzU8Xxp/tE9JmtBSgrZbeA5FqXhyPtzT3NBKRVCN0CfaSqxCmxK53RouJi40t9blcGOJu0LTWHV2MSPplai8+Kq1lUsC5mEyH01mgMpbPbZGf2LQm8Xl/Z+QSCOWzL04rI4KEwIiGUAkHNkYwxB19XQemWEOXMnOcBYvEmSG/ONLIWPPinWhebtczwoLjrQ=
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
 include/linux/memblock.h |   3 ++
 mm/hugetlb.c             |  22 +++-----
 mm/memblock.c            | 114 ++++++++++++++++++++++++++++++---------
 3 files changed, 100 insertions(+), 39 deletions(-)

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
index 8b2e551435ae..ff470fd0fd10 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -19,11 +19,9 @@
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 
-#ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/memblock.h>
-#endif /* CONFIG_KEXEC_HANDOVER */
 
 #include <asm/sections.h>
 #include <linux/io.h>
@@ -1506,6 +1504,32 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
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
@@ -1580,28 +1604,7 @@ phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
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
 
@@ -1756,6 +1759,69 @@ void * __init memblock_alloc_try_nid_raw(
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
2.55.0.229.g6434b31f56-goog


