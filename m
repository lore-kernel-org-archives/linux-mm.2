Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1A2CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C456B00AA; Fri,  5 Jun 2026 14:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626796B00B0; Fri,  5 Jun 2026 14:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6EB6B00B1; Fri,  5 Jun 2026 14:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 059C36B00AA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8EFB8CBF6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:51 +0000 (UTC)
X-FDA: 84846712902.08.0C30EE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 26A2B160002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JD4n6zBy;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1/j3Ucet9v9ZybQsRQ8PCoEEC5Pb6SVzbYAbbFutT0=;
	b=enmYNjRIvrPQimv1QHwJU2dQioZ1lz2klT7NgIInBaZV6EzAnei7yHJT5ZqnY07vyerTqp
	EFFTe48fJv8nradvMH0KC98208dZFqtGhozI5uZe6ml/j8AC4C7QQREZZammR+RYx6i2Ob
	qnfKROej7Uf96lY8Q+3zrIIYBE7gZwE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JD4n6zBy;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684550;
	b=CLuTFaLo+vePDbBjC29SMfi4ETNUod4IfiheTLNJPyeStfxV99ZnOxBlBoGHj+Zdg8rwfP
	9I/MUI14rFlJItWc+2yfKYA6jL6XlJu852KErEoRyjjXYUCfsielMXBXSFZ4P1LPb+Xmor
	pV7pWMTXc77E0QLzUs8mhaORIhiRlEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A802A601DC;
	Fri,  5 Jun 2026 18:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496271F00893;
	Fri,  5 Jun 2026 18:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684549;
	bh=O1/j3Ucet9v9ZybQsRQ8PCoEEC5Pb6SVzbYAbbFutT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JD4n6zBytZ/U3VZK1UN3Ojx9L1qsqBExXmh5oUOQCk4b4WhJdk108VJqz03nKg6te
	 i8KyS2qFb76L74r8jC4vVkGpCcu0yWhpLKD/w7hTRe+vsOg1828pB9kHKvRTeNAPq+
	 TwloeSgFBapgmMVq8oAmx4pNemeo6b9TjTcX+5F+dYUyRbXvhNsm/2hpOHoY7wICVK
	 8jFPy5s6eKmJavr/FuB3KJ08lYkdnu6iX5iwgVijGEHZfn2/M0yUvNtW0V2PUUkiOF
	 gOyFxlo0Kok3SdSF31h779qqok4lOpr2amj0kyO9lGhZc8hVAhHUPUZZSYK/xKA0jf
	 mXT73uwFg9Djw==
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
Subject: [PATCH v2 15/18] kho: extend scratch
Date: Fri,  5 Jun 2026 20:34:48 +0200
Message-ID: <20260605183501.3884950-16-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 26A2B160002
X-Stat-Signature: uo7dgr7abpwpquf7d6a6qn1syxx1g5po
X-Rspam-User: 
X-HE-Tag: 1780684549-20799
X-HE-Meta: U2FsdGVkX197ypV6A3H0gloDKrORccqwoQnAOoPyVTi48CrrImGHWGx05UnQImdfDoFq2NtxiSWEzcfNQG9SRaJ2EYut6qI2BMx9B/4WwNHw8jONLKAeAcxCK3fxuSLQQo9XLs+j2124dvWgosd+HffUiBrYLj8suPnXFZ8DsNh3L3+yp7z8sFbXtPjJIWVXZRCbgc6e0JyTI/yf67WbPkkdq6rhWQxnixPpns6fl2aABNgDl3+BFfEBu4J+3y07pf1DS7dSOXA8uEViq8hPPXXAuQB7kQsBgqiit8oQ/PJjvT4B8gnaG2v3ugpVtOBvIryB+dl6hWErAsLrMiWM+iYetJw/Ezrd3GtGWRwAaZeMPoEMGTG6ElCtgluL5obR39o1i8pM+20Dlmk+smWCe2fcNc0Jrb97F0pYTjYV/W+kURRGY79hoW6WwuTCD7zwM2722KdSIVRaFP6/jV7EiT70F/3klky8wDvbbSOYV1htGYMT8nReSStheC4eZV7EmmFtYY5PLC7ZQoWss/K0Me+V8FPbaPfgi/zl+Vgj1z8rj/mDOZzR+uTNd74HUZ33uecbq8tyzm7ahMxGC4HfLyCAFnBAkMNB/E7+HDJXr7KbomlAbmAfgeHrkWLYoEghJ/1/tPGa4byMN7Jf+MCzmHXDbno4JDPnr7AdgEJ1VwpvFF2abntBohqmc4131b1ly3TYQRaTvgJ+y+5IA69agiBSN1x8ebhV+/nhJ+o08cZgmhJsXi0F6vu5XviUtZpyW04yd/GxhTa7t++djE+CMQz+W4F7FtyBRQEYh3B7+R4S7ZlhkVgP+3wcWRCdUbpDAMyKo8rcYpXIxWHG0ChQIWPpDc4n7w34VkPfo0AHa00SEU8OoOhy5KTGIVeUBG/Dr/UhU0x+0ekNGKkG9/aYErIYIU4UkYeYFT9oOK7jWYkZR6Fv/CImwmF8igHhVYwq7/+7BDtGXYlCUVK/lO+
 DsXawWEw
 TMqYtQebQ8dhU+IOVzCK2Ten8BX+aIpzQcMXZc+O/SNIKkw2491rnDZ4oVJT3uVUivgWCL1M9ySLYD/NEb18kd7AOf20cenFEG4mcSHomnrGGAw6RBURBk28CpXawDu5pZU4rFiBCzhAWTzLBhcw1cx9hiyZdcTLyO45JZkKxypnThcP/KBCz2tENUN31kTV0K7OM0JwSn+PVu4IVESORnECrw+nzi5/qSwHxX1hM9xfZ98g=
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

Discover areas that don't contain any preserved memory at boot by
walking the preserved memory radix tree. Mark them as scratch to allow
allocations from them. This makes KHO more resilient to memory pressure
and allows supporting huge page preservation.

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

There is no inherent reason for using 1 GiB as the discovered block
size. This can be changed later if needed. Currently, KHO is mainly
targeted for server grade systems with hundreds of gigabytes to
terabytes of memory. So 1 GiB is a reasonable granularity for those
systems. For smaller systems this doesn't work as well, but we can
arrive at a better heuristic when we have concrete use cases.

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

    radix_nodes:       0x13
    nr_preservations:  0x214
    mem_preserved:     0x227000

    per order preservations:
      order  0:  0x20f
      order  1:  0x4
      order  4:  0x1

and this is how long it takes to extend the scratch after KHO boot:

    KHO: KHO extend time: 47 us
    KHO: KHO extend total mem: 0xe6c17b000 (~57G)

Test case 2 - 1G memfd
~~~~~~~~~~~~~~~~~~~~~~

This test case has two memfds with 1G memory each in 4k pages, plus
other preservations from LUO core and other KHO users.

This is how the radix tree stats look like:

    radix_nodes:       0x28
    nr_preservations:  0x80816
    mem_preserved:     0x80829000

    per order preservations:
      order  0:  0x80811
      order  1:  0x4
      order  4:  0x1

and this is how long it takes to extend the scratch after KHO boot:

    KHO: KHO extend time: 22514 us
    KHO: KHO extend total mem: 0xd3f200000 (~52G)

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    As one might notice, the "scratch" terminology starts to break down
    here. There is the original "scratch", which is passed down by the
    previous kernel. It is marked MEMBLOCK_KHO_SCRATCH. There is also the
    discovered "scratch", which also gets marked MEMBLOCK_KHO_SCRATCH, but
    has nothing to do with the former.
    
    For limiting the scope of this series, I haven't done the rename here. I
    can do it as a follow up series once this stabilizes and lands into
    -next.
    
    I suggest the following scheme:
    
    - Rename "KHO scratch" to "KHO bootmem". Update the documentation and
      all code to use this name. We have the kho_scratch kernel cmdline
      parameter, which is harder to change, but perhaps we can rename it to
      "kho_bootmem" and if someone complains we can add it back.
    
    - Rename MEMBLOCK_KHO_SCRATCH to MEMBLOCK_KHO_NOPRSRV. This describes
      the property of the memory not its origin. Then KHO can mark its
      "bootmem" as KHO_NOPRSRV because bootmem never has any preserved
      memory. Later, kho_extend_scratch() (which is also due for a better
      name) can also mark its discovered areas as KHO_NOPRSRV.

 kernel/liveupdate/kexec_handover.c | 149 +++++++++++++++++++++++++----
 1 file changed, 132 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index af22086ca2d6..8540608b8602 100644
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
@@ -869,6 +886,119 @@ static void __init kho_reserve_scratch(void)
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
+static int __init kho_ext_walk_node(phys_addr_t phys, void *data)
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
+		err = memblock_mark_kho_scratch(*prev_end, start - *prev_end);
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
+static void __init kho_extend_scratch(void)
+{
+	const struct kho_radix_walk_cb kho_cb = {
+		.leaf = kho_ext_walk_key,
+		.node = kho_ext_walk_node,
+	};
+	const struct kho_radix_walk_cb ext_cb = {
+		.leaf = kho_ext_mark_scratch,
+	};
+	struct kho_radix_tree radix;
+	phys_addr_t prev_end = 0;
+	int err = 0;
+
+	if (!is_kho_boot())
+		return;
+
+	/* Make sure the KHO radix tree is initialized. */
+	err = kho_radix_init_tree(&kho_in.radix_tree,
+				  kho_get_mem_map(kho_get_fdt()));
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
+		err = memblock_mark_kho_scratch(prev_end, memblock_end_of_DRAM() - prev_end);
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
@@ -1443,23 +1573,6 @@ void kho_restore_free(void *mem)
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
@@ -1763,6 +1876,8 @@ void __init kho_memory_init_early(void)
 	 */
 	if (kho_in.scratch_phys)
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
+	kho_extend_scratch();
 }
 
 void __init kho_memory_init(void)
-- 
2.54.0.1032.g2f8565e1d1-goog


