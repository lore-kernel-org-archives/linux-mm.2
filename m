Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5FBC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E195F6B0176; Wed, 29 Jul 2026 10:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CC96B0178; Wed, 29 Jul 2026 10:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2966B0179; Wed, 29 Jul 2026 10:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7D616B0176
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BE8714063C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:11 +0000 (UTC)
X-FDA: 85042117062.12.670FBF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEC6718000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrG8N+32;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0V6mqL75yYnGxyp17AqfObcO/m8HT1GGawz4ZxfGOM=;
	b=szDoZAPoMRCEiIJeM9rn8pENlKngzR79DiOn3y9D3NbTsMHsLn5rrFlukqszRC5jB9rsB2
	R1RUk+OaYLcZRKvJf7fVkHtZbY6wUQnl83AJL/nJ4QHz2L78kbjphi8OWdOYNTiHTaGK9A
	Zg0rj48VziFQZEIVQBgFwO5dZGBZ4F0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrG8N+32;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337029;
	b=yZhJfAIrnTmyXLhR8SE1OrM6nxntw/RBvGS4fN1pvuwZeO/CHuw9aQ+E7qs9k+PHOiRdfu
	s+CYqZgo+kFo2VLe9MLl3JMfcSmyfTTvJTUCVS4x/wC6Hd2eXlBciBTQss3SjdkJo67gzL
	kT63uHAzDq997ECgn33PGHSHvHHgifI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5439460A5C;
	Wed, 29 Jul 2026 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AF61F00AC4;
	Wed, 29 Jul 2026 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337029;
	bh=x0V6mqL75yYnGxyp17AqfObcO/m8HT1GGawz4ZxfGOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrG8N+32Uy67HY3CGqpw2T7Qi6qyS+jnQ4lW0hYE4fVfNaUHaWGLcqRlar/+U37X1
	 +12A56fU2NvrjBSE+adrj7Nnk+2iiMz7hECX7TPh34ISYAhqbn0Xui/oC8WMWJ92qz
	 Gux/ZioR6bZ7i1nYHO323mdm0OZ9pCI/UBVO+KNoJdVdcqr6bMDlf6PB2I3ka5pxvw
	 NJNFTB1MD9TPp2x+F7O/yWAvhpSkwIy01WwuprNOOJDi8qQbwZ7S6M6z0PgycTw4il
	 XKge72V0lBcCmsAI333HAQmKDsFPlNoHk/ZLo9BT1LY4Fif4aN+HBElHFuJJYr0wRu
	 kCKQIZWa8YVpQ==
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
Subject: [PATCH v5 18/22] kho: extend scratch
Date: Wed, 29 Jul 2026 16:56:03 +0200
Message-ID: <20260729145610.2827231-19-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEC6718000B
X-Rspam-User: 
X-Stat-Signature: gc44pc713xxc4q379gnb1gtpc6frmoqq
X-HE-Tag: 1785337029-749789
X-HE-Meta: U2FsdGVkX19CuZfxPY/eFMqf1z9nMmKqNjbZyCuHF0IcOkqjRG3NdRqKAYzTCNmwSOrLg5d/mHr5Djo+IRfO+aCQC4cq9rfwFO5MxfIsVKJ0bsDuAI+1OjqnWhZMOC7y/y2QuWTkWlyajGxIPFKiRQuIEYoskx0Hiq4o31Mi4gHSxIOvN1BqJooSCXttkKJTL3EwISzWxTm54Rgv8v/Iuf1GSqIhPo2YfGDVesfL4cIOHUOENaMiLROo3BKwu0+flXERS2dTG9/dZG3EkAEOldA1tgIDp9Iz7aAP9UJDYfjqZg2uzmM760kIcSWvjEih5HMWD8lhxpHOb3PEUce6OSqtoULF99FFwHkcy1ls4m3CCzuRZDIVQTLIPqMXfTeb28nmFDBXYEOF/30vg7iHw3rEdPWRwdxv4dTsq3R71hV00UKkPDj+7LgDIFc0V0+t4RJeEAEydrB1NDLq4OHUFoWk9jQcQneYv059rYHvVGp+e3x8NzIQ0XLdKjuaaf3gvaPooT0SsZN7vBUu2etO8OzUd2IuUPb7pI6ShaYqlY1HF8X8ZCn9+jbUCibJyT66r7A+xWTEAuT5HpxMKsUn8/NBJkfYJb5mNpyKJudECqIKFmK/YYIeKoLEqOCSp+71ZLmwZZgWC5UkmaL46Uz89zacsEDQgHfZeNOV3Juq3udG6H0b3vVd3MUPf7Ldg+Q/R0Zy94IK2+eptdXbGOZitnpbK2zllyZ12vf3Mt0/mNg+HJNRnvCeNvue0z5ef0os8iw6fnue8mEmcUmCYwqa6kHKiWminikZB5CdX/7MKQvMff9EGI6XE/kKaOmQuHahzCynL8Qwig7zoxZzMz3Zu5Eb4IgmOCX4E6hbF1yMXYlXEda5bgyncP58/FejsgxEsiG/cIU5FE03tBj4JXnky17UtTWzhxGyezXBDPJ1hWr2VstUgjcpw/3RtTbBwnz3JAfUmatpOaeKzPBtZHX
 CrZIBwpB
 R5lJhjyGds/F8TkOg3WPfMjS/eAMUUYryEvq4YHUqMRl4frP2H6qsnre/R7EN6PxGVYDuCyEep7A8FgHkvLbTHEhKK/VCXKELr6PBAa9pij7g6DjT7y4qxdGum3GOrnvD2NFi6Ocuz3T9Es+d9yvX1JRR4kGsK6PZk/GX90nHR4Y9XHbwDsz3OjymLb/veLlAjVebzuFoxGKkyuoFpY0JJ1Xx9jnBX0AGioLlWsjHnupT7vk=
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

 kernel/liveupdate/kexec_handover.c | 162 ++++++++++++++++++++++++++---
 1 file changed, 145 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6e8682469bd7..4c0756993b1f 100644
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
@@ -868,6 +885,132 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
+/*
+ * Look for free blocks of 1G. This is a heuristic chosen to work efficiently
+ * with large systems with hundreds of gigabytes of memory. It will work poorly
+ * on smaller systems. The algorithm itself doesn't depend on the actual value,
+ * so it can be changed to a different heuristic later if needed.
+ */
+#define KHO_EXT_BLKSIZE		SZ_1G
+#define KHO_EXT_BLKSHIFT	const_ilog2(KHO_EXT_BLKSIZE)
+
+/* Called for the KHO preserved memory radix tree. */
+static int __init kho_ext_walk_leaf(unsigned long key, void *data)
+{
+	/* Radix tree tracking free blocks. */
+	struct kho_radix_tree *tree = data;
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
+		err = kho_radix_add_key(tree, start >> KHO_EXT_BLKSHIFT);
+		if (err)
+			return err;
+
+		start += (1UL << KHO_EXT_BLKSHIFT);
+	}
+
+	return 0;
+}
+
+/* Called for the KHO preserved memory radix tree. */
+static int __init kho_ext_walk_node(phys_addr_t phys, void *data)
+{
+	/* Radix tree tracking free blocks. */
+	struct kho_radix_tree *tree = data;
+
+	return kho_radix_add_key(tree, phys >> KHO_EXT_BLKSHIFT);
+}
+
+/* Called for the free block radix tree. */
+static int __init kho_ext_mark_scratch(unsigned long key, void *data)
+{
+	phys_addr_t *prev_end = data;
+	phys_addr_t start = key << KHO_EXT_BLKSHIFT;
+	int err;
+
+	if (start > *prev_end) {
+		err = memblock_mark_kho_scratch(*prev_end, start - *prev_end);
+		if (err)
+			return err;
+	}
+
+	*prev_end = start + (1UL << KHO_EXT_BLKSHIFT);
+	return 0;
+}
+
+/*
+ * kho_extend_scratch - Extend the scratch regions
+ *
+ * The KHO preserved memory radix tree mixes both physical address and order
+ * into a single key. This makes it hard to look for free ranges directly. This
+ * function first walks the radix tree and digests it down into another radix
+ * tree, whose keys identify blocks of size KHO_EXT_BLKSIZE which contain
+ * preserved memory.
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
+	struct kho_radix_tree radix;
+	phys_addr_t prev_end = 0;
+	int err = 0;
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
@@ -1442,23 +1585,6 @@ void kho_restore_free(void *mem)
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
@@ -1769,6 +1895,8 @@ void __init kho_memory_init_early(void)
 		kho_in.scratch_phys = 0;
 		return;
 	}
+
+	kho_extend_scratch();
 }
 
 void __init kho_memory_init(void)
-- 
2.55.0.508.g3f0d502094-goog


