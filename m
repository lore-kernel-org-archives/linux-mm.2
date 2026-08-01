Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9CC5C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696DE6B00AC; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9D16B00AB; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A716B00AC; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE4B46B00AA
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54B908024A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:40 +0000 (UTC)
X-FDA: 85052077320.18.E9C5E89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B50FDC0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrBX6Miv;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8b0HjIx8i/4Q0eCfCNUr0RTIks21JMqujJ7T9iW+M0=;
	b=FdChFLglEpmOiFoVoh2fvmhp7VZdeYf+m4QeHVHwPqNgWPYphG3lRUOnUuArkKR49GNEmn
	gDi+INAXYUrf2zkuPXdOIwclO17Msgz/vInfWfPKACiP3A38VZKJyqvm3aDav7VPtVy7o+
	FUgaABVBpIWulSuw9jDRP+6F7jurLQE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574178;
	b=7xQZ+BnCOiYr8cZWWebm2Y90WKjeofZgQINpZ5UP4zzxQa3L2aogSfoqHTdZexBq10cOKo
	VGrmlA4SPigBnB+YBFHIRIqor7tXkBs10lEsbk0tFzARAMOVeOdzuvQh9y1z/RHi53u7Gz
	Z7fjHMnu1q/73HkiQCbx81JTP75hG1A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrBX6Miv;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41C8D60A98;
	Sat,  1 Aug 2026 08:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58441F00ACA;
	Sat,  1 Aug 2026 08:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574178;
	bh=b8b0HjIx8i/4Q0eCfCNUr0RTIks21JMqujJ7T9iW+M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrBX6MivTy3ybY4Ecjin0z2IJWcIaY0ZHg8MxTj4KIGL788PdS3noKBf0Ly5IQleL
	 WN3zaDOgNKOgsKDBjvZogI8MIaChWplcoFbdZvzbB+4VPndTVwbgreMru1ggrjyBGi
	 FuVIMBvGXP6SzgYpYud7i/haPWwSER/aczlKKHvkBbFRt8lCmSK45DehNoVgwJDjSe
	 58sBeEH3PqfFU66mit+FXIcQE2xwhRyZlf4vjIdH1EWBV66LQ7F/iCKb00l3nUUcus
	 y3oGizZdSYlcDg61+ruli6r8Os8f2DxyWnT5GA7bDWR6x60LCpvZe9PxZqyv5RMnAk
	 voscwLHeB2zSQ==
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
Subject: [PATCH v6 18/22] kho: extend scratch
Date: Sat,  1 Aug 2026 10:48:27 +0200
Message-ID: <20260801084833.1897543-19-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B50FDC0003
X-Stat-Signature: rbujx3ddiwf68h67asyn4yacju9xtphb
X-Rspam-User: 
X-HE-Tag: 1785574178-574254
X-HE-Meta: U2FsdGVkX18YltVqzr3dhf/XiXideUOtOG3BaT+I6OUT+K0GF4mgdOULbaAuig40eSDMu5uO2b8snJDHyvMLTreRR2rp/PKEmEMz3k0ZoCdx3LflKW97r3NcCfme4XAQjbMb9XVNHlpFfp6Y44BY7ZcIZrfMTKWMC026YW9EEdBuTZOiSPSxy+k/nqRyVJVSeN09lb/rX1vVfRGDyTRz4+6CrG2bDGX7GFd+bPNwS5KRS+sfevvW/96zS0espIL2EAGSuMEHlEo4+s9stVRgjhrY5EN2hCeOiwPOKhbEOPRUZOLbklNQtXUHgaJl7FTby08N0hycBCeTwaExpX832nZIgJlM4IZWrQKbymZCnjf3zFrxctYI/i46DZ/nykiueouyBHNKaO5L0HJrkwf57hV532lR31U0rD6iVRxTt4KfU4MmE7EMpjylee6SgOrBaR2oMUGpuWNsjfIXJGZvH7J0WFPFNKZfrG0L9RNlMfWw0Per+S7KGoXgaxQctoUl/3rdnNhdjCKrsendor8Ta7ktgoXm803GhSacUmfusw0QKYfp73vQhJnnZmOV5kYF6Tex4WCeitZXeWvEE+u6rd20n+8mLeR+7ILJ8fjMd8aXiQNGfXoxV0ZVaFGJG+U1gybO/oCK0ENu3oevSTOBH04+mPVKRTnQWOuJ0uXMXr5UBSmZSR8mv2blidd6OSuzOHyqFckIejBD2f0440Ln1HdDgX4YuIZW37ILiTxqxwWiNoR7o4rxWVgXHrPpaxt2hqwt6VcQhfvdaif9yVJOOU3DaB7ZztddKHrUFpR4y3S+mFaVETsxwJcvu4uBIaY4YD8qoQ+65F5pHaR3INaTtL8WN6ffrzfMzbOmus0M5YfbojlnD8b9McbVCBOkqz5etL5YTOod3A/wMpbrcWDNudEM9TbUADY0GPcoA6SE+ul/O273WJAlVyWeiBHiV9V4CrspMjeAvla6QbYEoZs
 nTNW9aBc
 jFU3B9Ix88eFOd+gFFodDAY7kaAR0r0hZaWIWs2YjdIxEu09DTp1sLgACjsniRkpcMzOl3vofJBeXtzAKamifr9sErpKeCkboFEk/TenAhOc8kY0ebCWIvq7WGFWg2clUCVr6MlHlqa1dCpnWjRdBloyCpEtAety78GFt+PYm7YfOtE8bA4cokT23ddlJxNa6sxUfCeRvQlNUy/MJm9Ne18jLiXX83AJOuExSY+hFw4jGsmU=
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
KHO_SCRATCH_EXT_BLKSIZE (1 GiB as of now) granularity. Then walk the
digested tree and mark the areas between the present keys as scratch.

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

 kernel/liveupdate/kexec_handover.c | 170 ++++++++++++++++++++++++++---
 1 file changed, 153 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6e8682469bd7..e649e68d861f 100644
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
@@ -868,6 +885,140 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
+/*
+ * Look for free blocks of 1G. This is a heuristic chosen to work efficiently
+ * with large systems with hundreds of gigabytes of memory. It will work poorly
+ * on smaller systems. The algorithm itself doesn't depend on the actual value,
+ * so it can be changed to a different heuristic later if needed.
+ */
+#define KHO_SCRATCH_EXT_BLKSIZE		SZ_1G
+#define KHO_SCRATCH_EXT_BLKSHIFT	const_ilog2(KHO_SCRATCH_EXT_BLKSIZE)
+
+/* Called for the KHO preserved memory radix tree. */
+static int __init kho_ext_walk_leaf(unsigned long key, void *data)
+{
+	struct kho_radix_tree *busy_blocks = data;
+	phys_addr_t start, end;
+	unsigned int order;
+	int err;
+
+	/*
+	 * The key is from the KHO preserved memory radix tree. It is decoded to
+	 * a physical address of a preservation and its order.
+	 */
+	start = kho_decode_radix_key(key, &order);
+	end = start + (1UL << (order + PAGE_SHIFT));
+
+	while (start < end) {
+		err = kho_radix_add_key(busy_blocks, start >> KHO_SCRATCH_EXT_BLKSHIFT);
+		if (err)
+			return err;
+
+		start += (1UL << KHO_SCRATCH_EXT_BLKSHIFT);
+	}
+
+	return 0;
+}
+
+/* Called for the KHO preserved memory radix tree. */
+static int __init kho_ext_walk_node(phys_addr_t phys, void *data)
+{
+	struct kho_radix_tree *busy_blocks = data;
+
+	return kho_radix_add_key(busy_blocks, phys >> KHO_SCRATCH_EXT_BLKSHIFT);
+}
+
+/* Called for the busy block radix tree. */
+static int __init kho_ext_mark_scratch(unsigned long key, void *data)
+{
+	phys_addr_t *prev_end = data;
+	phys_addr_t start = key << KHO_SCRATCH_EXT_BLKSHIFT;
+	int err;
+
+	if (start > *prev_end) {
+		err = memblock_mark_kho_scratch(*prev_end, start - *prev_end);
+		if (err)
+			return err;
+	}
+
+	*prev_end = start + (1UL << KHO_SCRATCH_EXT_BLKSHIFT);
+	return 0;
+}
+
+/*
+ * kho_extend_scratch - Extend the scratch regions
+ *
+ * The KHO preserved memory radix tree mixes both physical address and order
+ * into a single key. This makes it hard to look for free ranges directly. This
+ * function first walks the radix tree and digests it down into another radix
+ * tree, whose keys identify blocks of size KHO_SCRATCH_EXT_BLKSIZE which
+ * contain preserved memory.
+ *
+ * Then it walks the digested radix tree and marks everything that doesn't have
+ * preserved memory as scratch.
+ *
+ * NOTE: This function allocates memory so it should be called when scratch has
+ * available space.
+ *
+ * NOTE: The pages of the KHO preserved memory radix tree tables are not marked
+ * as preserved in the preserved memory tree. But they are expected to remain
+ * untouched until the tree is fully parsed. So this function also considers
+ * them to be "preserved memory" and marks their blocks as busy.
+ *
+ * NOTE: efi_init()::reserve_regions() removes all regions except
+ * MEMBLOCK_KHO_SCRATCH. This function adds such regions but they are not KHO
+ * scratch memory, so they should not be removed. This function should always be
+ * called after reserve_regions().
+ */
+static void __init kho_extend_scratch(void)
+{
+	const struct kho_radix_walk_cb kho_cb = {
+		.leaf = kho_ext_walk_leaf,
+		.node = kho_ext_walk_node,
+	};
+	const struct kho_radix_walk_cb ext_cb = {
+		.leaf = kho_ext_mark_scratch,
+	};
+	static struct lock_class_key busy_radix_class;
+	struct kho_radix_tree busy_blocks;
+	phys_addr_t prev_end = 0;
+	int err = 0;
+
+	err = kho_radix_init_tree(&busy_blocks, NULL);
+	if (err)
+		goto print;
+
+	/*
+	 * The walk of kho_in.radix_tree adds keys to busy_blocks. The walk
+	 * takes the kho_in radix tree lock and adding the key takes busy_blocks
+	 * lock. Since both are struct kho_radix_tree and share the same lock
+	 * class, lockdep gets confused. Set a different class for
+	 * busy_blocks.lock to make lockdep happy.
+	 */
+	lockdep_set_class(&busy_blocks.lock, &busy_radix_class);
+
+	/* Walk the KHO radix tree to find busy blocks. */
+	err = kho_radix_walk_tree(&kho_in.radix_tree, &kho_cb, &busy_blocks);
+	if (err)
+		goto out;
+
+	/* Walk the busy blocks and mark everything between keys as scratch. */
+	err = kho_radix_walk_tree(&busy_blocks, &ext_cb, &prev_end);
+	if (err)
+		goto out;
+
+	/* Mark everything from last busy block to end of DRAM. */
+	if (prev_end < memblock_end_of_DRAM())
+		err = memblock_mark_kho_scratch(prev_end, memblock_end_of_DRAM() - prev_end);
+
+	/* fallthrough */
+out:
+	kho_radix_destroy_tree(&busy_blocks);
+print:
+	if (err)
+		pr_err("Failed to extend scratch: %pe\n", ERR_PTR(err));
+}
+
 /**
  * kho_add_subtree - record the physical address of a sub blob in KHO root tree.
  * @name: name of the sub tree.
@@ -1442,23 +1593,6 @@ void kho_restore_free(void *mem)
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
@@ -1769,6 +1903,8 @@ void __init kho_memory_init_early(void)
 		kho_in.scratch_phys = 0;
 		return;
 	}
+
+	kho_extend_scratch();
 }
 
 void __init kho_memory_init(void)
-- 
2.55.0.571.g244d577d93-goog


