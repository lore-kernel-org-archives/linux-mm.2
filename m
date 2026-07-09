Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B6BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4823A6B0096; Thu,  9 Jul 2026 13:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4597F6B00C4; Thu,  9 Jul 2026 13:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370656B00C5; Thu,  9 Jul 2026 13:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA3FB6B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:48:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9175A4026B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:20 +0000 (UTC)
X-FDA: 84969949680.14.A006DC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EE0D9160006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E2a/hdMB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhShZLkxvoxdNMkU+N0mJHuW7JAtU37ty1oXYy39eoY=;
	b=trlNcero/3bvAIqcZjIiJv/PnwGqAKiIeXuIJzKHOK+8S81xRK7hAjMzMrJCgonUaIJvbP
	SyGDAqsV+NmpXjT1XGP2+xLz7jJh+B8HzUitrepnMstT5Rvwe1VlgHQHpLpg1zaMUeg37n
	fUYumOPbw1s4Cjfzl/q+w7gLev+R4cE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E2a/hdMB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618758;
	b=jGwcdo9YnNgt04nDDXVUni4V3PtV0MP5MYaxNI9ciuIJAKTIzC853ZB5Ij7Bs9DrSK/eJI
	QS8UUKW3Hp8ISAqgp/knJPc8ZiUKPGJd7b3RRQw7IWySJqvb6pgAwfgGnOUphDW1QEXm2v
	aX0LfXeFe+BgI2KYL+W23CpHH1N6mcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B0CE61386;
	Thu,  9 Jul 2026 17:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9981F00A3D;
	Thu,  9 Jul 2026 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618758;
	bh=PhShZLkxvoxdNMkU+N0mJHuW7JAtU37ty1oXYy39eoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2a/hdMB8kTkWBiP5cqXzpmc+QoU2RgsGJiw25bIn2Susc+xZm41O4CIgz+Uvi/MS
	 GuXyd86gN0LA29SB5zjUAqCn4fO76t8seYScy4cwtJ4/Yh1aj/a+1QtPEO7zdo/Fss
	 WxqEn0Fmi8QddaJaTXaHtOwTwLXcK0S0q0q9r2EjH3Jv9M1rrnYVkZSbNYISmGTZGt
	 fX4G0Ic2fCb64H7NZpBmy0HWc6yYldwTStnZqrKVXAouNkuSUdnS+tuKYPbs5HMk2H
	 n4sLKf+na3aUtbXx63+H20qHyTFAFqq1TnCp2jk98ps3ZS9EG5yEakMeHAbvbZSUx/
	 g7/S99P7BOJJA==
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
Subject: [PATCH v3 18/21] kho: extend scratch
Date: Thu,  9 Jul 2026 19:38:07 +0200
Message-ID: <20260709173821.429921-19-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3qhbdqpric7twhkr45s1gripbosy7hop
X-Rspamd-Queue-Id: EE0D9160006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783618758-654955
X-HE-Meta: U2FsdGVkX1+dc7PNmJ4echVxvnErNv/Y/rZ1axeDGkyUb6qZFrgOxkKUdiDkoheSuTcdK/st/xNlqjJca7Y2g8L327HQ75eUbEqyqXyIIEgOJGyjplrHDznms/EcoTj7i3fDxPDNFb8BRjnWoMNz7kovhFdldTtrwt+8nhtc37A8Hw8gUszQ3blfo5FILqxn72DoHHMhVSHNhfxBN+1/hsfue2xHjFEunsL+XIVvAJD11NVcbN/hWUpdlWlGLG7Y1xuxP79ULXg4bGTYj45oVazNY1KIMjraTJKRj+KI8jTkyFCBwUWQggcxY/xLkhbci1t7hqczxFEbhW4LLuJmlR5rSnuT2ge1KsCtj+JjxMC+oLRtvfdXghI44eIV7LThlUAjSuEjME0+N8ySY0fhJ3SN4V/29km+ODyjJs7K63+XMQ5ltCV/d5qO4lMNBJSbpBjTD28HEsTfY34u4VhZNASLoTlqCeYODzLulozdh/tTfo4yGJ7yhHEBdbA9rwSp8SCBEojYUvAlzcaElpnc0MuhXPROaev4Qa61XKIe0FEZFHduLY58SEJw7M+Ij1ullD1g9fnbiGtJ7qH9mOE1goL2djHyTS1l+CaOHUlXiM3mzsWGYFJsSZNcETxkdwFnRmdqzij1iiGKVOVB9+ATkjg5erZT9m2ZLLc5ogUdxgQCKOVIWue6DhXbCnw4gfCYlN16hENcRESJdNpNOJaiFDOb8RH0ZnkTcSN2eBJYnhWDFiR/0gmGeraYr8Zt6wkDPofeUJC/asndyvx7HzRc78trmlvPsaTj2eKp18gHHV/GDh2ZCRRnaHZOE4oydfcbBRw1ApkcFYDHL5MZ0oKYXruiIv9ZsiPoT48iiz+O4rFbi4FqDQHspQE8QbirE+np5v/CrFcCT1SEA8upo9Lh/xwvAZ9gCHB7qrDnWLl+3AlVI+4RoRUgHkAtEsHV6Cw5SADAYqjG0TcjFwu2Tyf
 DRntGahI
 4k6oPn3Kqws+IxfdjRPWXK62OVK30RCfDP7VugjG+tOIQ1NqLrRPjK/7rvW5eCGs7Oy+vmUUVId+Q16qp6BmmTgOK2fl5V9i3E3RT+3SRewBRS++NMz8TK2ASaFXuLvn6+Rb/OFznxjCBu1Eu+/ofhzUB7PaHUmZuwMzMZSuQ/fST8EI+WlQbYSPRkQuc/2LBzAi6PLEwRy/Zw/Gbad7dGAD3luQhhxkj86rQIO7Qac3BP9U=
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

 kernel/liveupdate/kexec_handover.c | 158 +++++++++++++++++++++++++----
 1 file changed, 141 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b400976851e7..2c4848874629 100644
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
@@ -895,6 +912,128 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
+/*
+ * Look for free blocks of 1G. This is a heuristic chosen to work efficiently
+ * with large systems with hundreds of gigabytes of memory. It will work poorly
+ * on smaller systems. The algorithm itself doesn't depend on the actual value,
+ * so it can be changed to a different heuristic later if needed.
+ */
+#define KHO_EXT_BLKSIZE		SZ_1G
+#define KHO_EXT_SHIFT		const_ilog2(KHO_EXT_BLKSIZE)
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
+/* Called for the KHO preserved memory radix tree. */
+static int __init kho_ext_walk_node(phys_addr_t phys, void *data)
+{
+	/* Radix tree tracking free blocks. */
+	struct kho_radix_tree *tree = data;
+
+	return kho_radix_add_key(tree, phys >> KHO_EXT_SHIFT);
+}
+
+/* Called for the free block radix tree. */
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
+/*
+ * kho_extend_scratch - Extend the scratch regions
+ *
+ * The KHO preserved memory radix tree mixes both physical address and order
+ * into a single key. This makes it hard to look for free ranges directly. This
+ * function first walks the radix tree and digests it down into another radix
+ * tree, whose keys identify blocks of KHO_EXT_SHIFT which contain preserved
+ * memory.
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
@@ -1469,23 +1608,6 @@ void kho_restore_free(void *mem)
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
@@ -1796,6 +1918,8 @@ void __init kho_memory_init_early(void)
 		kho_in.scratch_phys = 0;
 		return;
 	}
+
+	kho_extend_scratch();
 }
 
 void __init kho_memory_init(void)
-- 
2.55.0.141.g00534a21ce-goog


