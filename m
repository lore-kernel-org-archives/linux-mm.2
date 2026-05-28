Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBADCD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354396B009E; Wed, 27 May 2026 20:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE056B00A2; Wed, 27 May 2026 20:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184826B009E; Wed, 27 May 2026 20:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F228C6B009E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BD7DA06B6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:31 +0000 (UTC)
X-FDA: 84814977702.24.A2018BF
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id D31D620009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=L1MrNbUn;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928950; a=rsa-sha256;
	cv=none;
	b=jUWF6r5XVMNbflOMSnLc4lSl0K5iqQroMpbCDNRP6VO9DUZZTlRkvkV2WLhSeNvZpvgmmH
	3YqMzV73+mv6EU+cpf60EL86gOjHXaAB3FiazfeVG748AQQjdOG+41Dvaddi/+DvVzJ20g
	ChRAgbHYGhQaKllq9svo/1DO+LGVrR0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=L1MrNbUn;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXatuMO/Fdjo1jy8ticG6q7fzNlcTDCEPHvUu9k6XTs=;
	b=sm8v2UuibmoTvdT+bksxqcVYGiR7UJiE9TCkJaUtaXmZWYnz+3gpe7ZnQYx199T+gbhvfT
	Cb4s/Pf+oX6u3/plyR43eE3WAfy2ZJ3+7TWiSieK8pphFM3pTpaZIzpY+VgU+tPLVwYJh/
	ZzD053UG/1CSpJ9QSVX3UNzMOJ5v4To=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 8823120B717B; Wed, 27 May 2026 17:42:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8823120B717B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928938;
	bh=GXatuMO/Fdjo1jy8ticG6q7fzNlcTDCEPHvUu9k6XTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1MrNbUnl/bErE+GLw9HkkjzskqoK7iud5XrEq+OeWG2+T2sOAFJjOi2GFtbc2Yes
	 hm/RFZ8SG+bQV9DEktiBvoSAD2TJs48jxv/gP+eV9+5DDplNG7oFfqyxc+uKmPg8IQ
	 MmOtFPTJQnM1YU/9If1U44KJl0gWnwzDq7STNasM=
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
Subject: [RFC PATCH 10/20] kho: extended scratch
Date: Wed, 27 May 2026 17:41:52 -0700
Message-ID: <20260528004204.1484584-11-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D31D620009
X-Stat-Signature: ofcjg6jxgxi9ri6rgfe8ikuqs7znscuj
X-HE-Tag: 1779928949-43701
X-HE-Meta: U2FsdGVkX1+o0kzDUGAsRd9ZxaLV83FyUDhIecY7+zyBM33ePCc1x9IcXLgehbToSDv7IEZo8bntNrWQoj0sbzBec+kGap8k0RPSakYCv2SF4vu4MR/NFK02HDlnvuipnNt1qxjrgD/9mTHLk5w2J1GN1OThpNG5BhzPbi7ISc1/2ZvOrGDlHzKu7q4BkNfmqBNUwRSZ/vJVadMrQJ5y6Uz8tl/e52xp1uhpiWcfJMUeltiIYjbUP9vIPfXtYBhtvrT0A+s3ipCUXk8GPYQ4OQxBILGClhDr0WmoE8qeISRU5LMOL2zNJE3BcWqJl/DqRB6wq/cGmnOwCJiA5jupa5so32SHu5TswsryddU7OxGu6v3St+ITwcCSYQmpvgXqBoN20JH6QM48QTPaigM7IRr/ZB0k1qHxmX0RPrlZ7W45U/widoB1XLLwND/OWvU9oox+0gZIj+2QOsnFWqG7TU0Ee/rqdrXQuCQ+xYkgwIGSWBhiW7rHj7bB/rC3U3rARvqiDlPMk3cnsqtgHswht41vlye7OadznMc5I1BtgDBToFFHbgAohvYdChVhVyg9s8IHsMi+B3SAYi15oJYE+12cSWLg+2rr933xMQRqDhGGewTaHsxqD632YBC6BAF9M9+usK1cuJgGfuOLzZ4W87v9SuGaGTy2rNEEl9XgvwMZybfGfQIaGWbQJ6h+GkYnp7kFc2XfYVXu++hXnQJ7E+4mshY6NtALVc+Apy1ENPrtAgwKEOT/UTj1U7CiyXZnVaWO2nVrP3OqYliOdIZ/D7lU4+LStgP81SwmwRNTWdFi7Tuu5ra1GvSNc5LRbkIVy1RLQR9+JP/yrBaI825u9qsxoHB5ee3bRrArh75RluzJ9OXdfGoGv1JmPiucvqGhQJQ+zX1zDkvJXn1BYGbGeAdDwg2lwHZ5E0Xi7kMcQRgWN96YiJmFE901e4ozhxKR8Ms367n0/Dkc9DcPJiv
 ctktj9MM
 MkhyHR8Ghl+2uZfzA93dL3xFKtEa7SptJj0UO+QvwIfZAkmiluffV2FjoQrxDR3b4GqsMFw2fDQyw5YxGAyuTnfSQWyZTAh483vbpFLEtmA0ZxIDLt7BWuebfH5zZejK/ja0L+IKcrulfFQDSJGThkjsK3RDAPqSr2p072fmC/Vo9r4N6XEtbK3tC8gicvDnC4kib2GzO6xd+Pi3oANUWb0hvzDFksBjxEXUTcCRcsge9bFiKvttqtrnSEkEz3cEOe3gaRicwsQjGV9WkE1U+9fAR/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Motivation
==========

The scratch space is allocated by the first kernel in the KHO chain, and
is reused by all subsequent kernels. The size of the space is either set
via the commandline by the system administrator or by calculating the
amount of memory used by the kernel and adding a multiplier. In either
case, the scratch space is a heuristic and is liable to fill up and fail
allocation if a kernel uses more memory than expected.

In addition, gigantic huge pages (usually 1 GiB) are allocated via
memblock, and in a KHO boot that memory comes from the scratch space. In
hypervisors it is common to dedicate a major part of the system's memory
to gigantic hugepages for VM memory.

If this memory needs to come from scratch space, then scratch needs to
be greater than the memory needed for huge pages, which is impractical.
In addition, hugepages can be preserved memory. Allocating them from
scratch violates the assumption that scratch contains no preserved
memory.

Methodology
===========

Introduce extended scratch areas. These areas are discovered at boot by
walking the preserved memory radix tree and looking for free blocks of
memory. They then marked as scratch to allow allocations from them. This
makes KHO more resilient to memory pressure and allows supporting huge
page preservation.

Since the preserved memory radix tree mixes both physical address and
order into a single key, and does not track table pages, it is difficult
to identify free areas from it directly. Walk the tree and digest it
down into another radix tree. The latter tracks blocks of
KHO_EXT_SHIFT (1 GiB as of now) granularity. Then walk the digested tree
and mark the areas between the present keys as scratch.

Performance
===========

The discovery algorithm traverses the preserved memory radix tree
exactly once. While it does use memory for the digested radix tree,
since the blocks are split by 1 GiB, a single bitmap with 4k pages can
track up to 32 TiB of memory. So there are likely to be very few radix
tree pages used in this tracking. For systems with all physical memory
below 32 TiB, this should result in a total of 6 pages being
used (KHO_TREE_MAX_DEPTH == 6).

An alternate way of achieving this would be to call kho_mem_retrieve()
earlier in boot and mark all the KHO preservations as reserved. But that
can blow up memblock.reserved with a bunch of 4K pages scattered
everywhere, which will reduce performance of subsequent allocations.
Since the free blocks are tracked in chunks of 1 GiB, this won't blow up
memblock.memory as much.

Practical evaluation
====================

The testing is done on a x86_64 qemu VM running under KVM with 64G
memory and 12 CPUs. The machine pre-allocates 50 1G pages.

Since the performance scales with how busy the radix tree is, tests are
done with 2 preservation patterns: first with two 1M memfds, second with
two 1G memfds, both using 4k pages.

Test case 1 - 1M memfd
~~~~~~~~~~~~~~~~~~~~~~

This test case has two memfds with 1M memory each in 4k pages, plus
other preservations from LUO core and other KHO users.

This is how the radix tree stats look like:

    radix_nodes:       0x2f
    nr_preservations:  0x22d
    mem_preserved:     0xa2b000

    per order preservations:
    order  0:  0x215
    order  1:  0x9
    order  2:  0x1
    order  3:  0x2
    order  4:  0x5
    order  5:  0x1
    order  6:  0x2
    order  7:  0x2
    order  9:  0x1
    order 10:  0x1

and this is how long it takes to extend the scratch after KHO boot:

    kho_extend_scratch(): time taken: 88 us
    kho_extend_scratch(): total memory recovered: 0xf7ff7b000 (~62G)

Test case 2 - 1G memfd
~~~~~~~~~~~~~~~~~~~~~~

This test case has two memfds with 1G memory each in 4k pages, plus
other preservations from LUO core and other KHO users.

This is how the radix tree stats look like:

    radix_nodes:       0x45
    nr_preservations:  0x80832
    mem_preserved:     0x8102d000

    per order preservations:
    order  0:  0x80817
    order  1:  0x7
    order  2:  0x2
    order  3:  0x4
    order  4:  0x2
    order  5:  0x2
    order  6:  0x4
    order  7:  0x3
    order  8:  0x1
    order  9:  0x2

and this is how long it takes to extend the scratch after KHO boot:

    kho_extend_scratch(): time taken: 21769 us
    kho_extend_scratch(): total memory recovered: 0xe40000000 (57G)

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 include/linux/kexec_handover.h     |   1 +
 kernel/liveupdate/kexec_handover.c | 148 +++++++++++++++++++++++++----
 mm/mm_init.c                       |   1 +
 3 files changed, 133 insertions(+), 17 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..6ce46f36ed99 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -37,6 +37,7 @@ void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
+void kho_extend_scratch(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b2d1572808eb..a006a883ee94 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -84,6 +84,23 @@ static struct kho_out kho_out = {
 	},
 };
 
+struct kho_in {
+	phys_addr_t fdt_phys;
+	phys_addr_t scratch_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
+	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
+};
+
+static struct kho_in kho_in = {
+};
+
+static const void *kho_get_fdt(void)
+{
+	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
+}
+
 /**
  * kho_encode_radix_key - Encodes a physical address and order into a radix key.
  * @phys: The physical address of the page.
@@ -825,6 +842,120 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
+#define KHO_EXT_SHIFT 30 /* 1 GiB */
+
+static int __init kho_ext_walk_key(unsigned long key, void *data)
+{
+	struct kho_radix_tree *tree = data;
+	phys_addr_t start, end;
+	unsigned int order;
+	int err;
+
+	start = kho_decode_radix_key(key, &order);
+	end = start + (1UL << (order + PAGE_SHIFT));
+
+	while (start < end) {
+		err = kho_radix_add_key(tree, start >> KHO_EXT_SHIFT);
+		if (err)
+			return err;
+
+		start += (1UL << KHO_EXT_SHIFT);
+	}
+
+	return 0;
+}
+
+static int __init kho_ext_walk_table(phys_addr_t phys, void *data)
+{
+	struct kho_radix_tree *tree = data;
+
+	return kho_radix_add_key(tree, phys >> KHO_EXT_SHIFT);
+}
+
+static int __init kho_ext_mark_scratch(unsigned long key, void *data)
+{
+	phys_addr_t *prev_end = data;
+	phys_addr_t start = key << KHO_EXT_SHIFT;
+	int err;
+
+	if (start > *prev_end) {
+		err = memblock_mark_kho_scratch_ext(*prev_end, start - *prev_end);
+		if (err)
+			return err;
+	}
+
+	*prev_end = start + (1UL << KHO_EXT_SHIFT);
+	return 0;
+}
+
+/**
+ * kho_extend_scratch - Extend the scratch regions
+ *
+ * The KHO radix tree mixes both physical address and order into a single key.
+ * This makes it hard to look for free ranges directly. This function first
+ * walks the radix tree and digests it down into another radix tree, whose keys
+ * identify blocks of KHO_EXT_SHIFT which contain preserved memory.
+ *
+ * Then it walks the digested radix tree and marks everything that doesn't have
+ * preserved memory as scratch.
+ *
+ * NOTE: This function allocates memory so it should be called when scratch has
+ * available space.
+ *
+ * NOTE: The pages of the KHO radix tree tables are not marked as preserved in
+ * the KHO tree. But they are expected to remain untouched until the tree is
+ * fully parsed. So this function also considers them to be "preserved memory"
+ * and marks their blocks as busy.
+ */
+void __init kho_extend_scratch(void)
+{
+	const struct kho_radix_walk_cb kho_cb = {
+		.key = kho_ext_walk_key,
+		.table = kho_ext_walk_table,
+	};
+	const struct kho_radix_walk_cb ext_cb = {
+		.key = kho_ext_mark_scratch,
+	};
+	struct kho_radix_tree radix;
+	phys_addr_t prev_end = 0, mem_map_phys;
+	int err = 0;
+
+	if (!is_kho_boot())
+		return;
+
+	/* Make sure the KHO radix tree is initialized. */
+	mem_map_phys = kho_get_mem_map_phys(kho_get_fdt());
+	err = kho_radix_init_tree(&kho_in.radix_tree, phys_to_virt(mem_map_phys));
+	if (err)
+		goto print;
+
+	err = kho_radix_init_tree(&radix, NULL);
+	if (err)
+		goto print;
+
+	/* Walk the KHO radix tree to find busy blocks. */
+	err = kho_radix_walk_tree(&kho_in.radix_tree, &kho_cb, &radix);
+	if (err)
+		goto out;
+
+	/* Walk the blocks and mark everything between keys as scratch. */
+	err = kho_radix_walk_tree(&radix, &ext_cb, &prev_end);
+	if (err)
+		goto out;
+
+	/* Mark everything from last busy block to end of DRAM. */
+	if (prev_end < memblock_end_of_DRAM())
+		err = memblock_mark_kho_scratch_ext(prev_end,
+						    memblock_end_of_DRAM() - prev_end);
+
+	/* fallthrough */
+out:
+	kho_radix_destroy_tree(&radix);
+print:
+	if (err)
+		pr_err("Failed to extend scratch: %pe\n", ERR_PTR(err));
+}
+
 /**
  * kho_add_subtree - record the physical address of a sub blob in KHO root tree.
  * @name: name of the sub tree.
@@ -1406,23 +1537,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-struct kho_in {
-	phys_addr_t fdt_phys;
-	phys_addr_t scratch_phys;
-	char previous_release[__NEW_UTS_LEN + 1];
-	u32 kexec_count;
-	struct kho_debugfs dbg;
-	struct kho_radix_tree radix_tree;
-};
-
-static struct kho_in kho_in = {
-};
-
-static const void *kho_get_fdt(void)
-{
-	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
-}
-
 /**
  * is_kho_boot - check if current kernel was booted via KHO-enabled
  * kexec
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6de3a77eb9ae..bbca4cc9b912 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2702,6 +2702,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	kho_extend_scratch();
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-- 
2.43.0


