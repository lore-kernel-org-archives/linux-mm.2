Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82931CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98458E000E; Tue, 16 Sep 2025 22:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49948E0001; Tue, 16 Sep 2025 22:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10A28E000E; Tue, 16 Sep 2025 22:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5E028E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:50:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FBC613AC3D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:44 +0000 (UTC)
X-FDA: 83897214408.03.80936D0
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6EC0A1C0009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1j3+t2jb;
	spf=pass (imf21.hostedemail.com: domain of 3ASLKaAgKCLoofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ASLKaAgKCLoofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758077442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RU6/kpZEGAR06M2wVDolyGswZ9cjx0r+1Ic9uqduI2Q=;
	b=5jYepZH2HWfCGG4StJJ4pNw4lPyAYYme3XPlaQy0ippwCz9wLeJc+WieQQuUAf4AUICalZ
	PKxdXSZhsrEZYHlKOJyAhZEUHGZT9g1QoacSILlFKctVp4a7DidGMa2QhzGj5RQFTuH6pT
	mHAlWXAc9JF3me42XM7Yz26acDCtbLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758077442; a=rsa-sha256;
	cv=none;
	b=vfBpRkK2g7Rz99P/Cc30sFnnjetFbIqfuyqYVv1EzuQJQ4CW/s9BAVEDE4xs8ov+SB+RBw
	lR50JD7HzMAIVH00xfWEQ8YGGKQyPSCtbJmLG3KDQmhzwJ4vcxSUDM75/KgrcesSQJOTc+
	PGB/kui5w71TJUFa96AlovGgNG90IAw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1j3+t2jb;
	spf=pass (imf21.hostedemail.com: domain of 3ASLKaAgKCLoofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ASLKaAgKCLoofxtsrnzlttlqj.htrqnsz2-rrp0fhp.twl@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-26776d064e7so27534845ad.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758077441; x=1758682241; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RU6/kpZEGAR06M2wVDolyGswZ9cjx0r+1Ic9uqduI2Q=;
        b=1j3+t2jbDT15DxFBHpw13daz3s3t93diQIoHFmO4ttdBcuECoytyHZskZoe5yU/d9V
         2SiXjWGxj98nVtMiuA/szU27ClDLAoXW3tF6/0sRUNxDEFZuSEUOGcviVVl6412ukmTk
         /KBY1FOZ6wGR4JOafSZWkR/UBA15tRnY1gZeA1Hhe8Zur+k4Gyw8lK8myAV2gbBVHEd6
         EQowpkMj5QXiNemUojv8hdicQICojB22MJe9/TKJZaUT/AMe1oC2Fowse4hLwhxDmN0s
         PB/E/BCMEEJGYo6j2YgvL623MgbDx4+++ZRqHSFI2k4SDx+Hthjp7nqT8XWhPOIOW7Sj
         62ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758077441; x=1758682241;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RU6/kpZEGAR06M2wVDolyGswZ9cjx0r+1Ic9uqduI2Q=;
        b=EBeFjFBgbJhHPkscMG/V3PB6Vf9mEEW+d1rtjUBi1IXB81CYsL7M7JB9pEBTNJ/KXc
         UM2ZWDR49ACaQM0VkKo/bpL8UyeJuKeNys/6hkSMbuYdClbsQ7XqaW5rPyofpm24IFSh
         AYoQMFD1dt6pLL1WTT0Gr3TpgQCp8PjQ3u7C71ypkGE5jQhdUyyhrQADTohuZ+pjmqxG
         1gEMYoQIPV5qhhi33THxHUKJeQu2gycVCHuCkcMm/z0X8qnbPpmqj2fhRkg6m69zOWuz
         xLweLVscwRdJFLk2Fc3D4sqgAoKdrHajA81XomvaC2hA3OYOlhqe1XnQxCgJiuL/dD43
         etfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRo1xEGPpASCatrD8q6Nv03uQPyqNyO9+/HFdmm3S5rw0i2vqNhndwjlES7DsTbc3gF/E6fm2TpA==@kvack.org
X-Gm-Message-State: AOJu0YwoDBfFjTmPveSlRYMm1fs9UX0edOZTHoqx/AZORW9qkHQh3RhK
	5aQw4eQWBoWFu1U+lu5cJR6fpU9hbD26OrBFg6PbsAgJhc1QoR6JsfP2fLSzrOwcaYoLq2dBcb7
	yr3ZD4d1ToADXxA==
X-Google-Smtp-Source: AGHT+IErFehkHx558QRyQefB1/NtFlc2KGjefUET9/Av+8/Gyz/SnvIhDvJdH2sa4sKdNORbBQODik0RC7MKrg==
X-Received: from plkb5.prod.google.com ([2002:a17:903:fa5:b0:264:7b3c:4fe4])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:c406:b0:260:df70:f753 with SMTP id d9443c01a7336-268137fd0a4mr6203875ad.38.1758077441117;
 Tue, 16 Sep 2025 19:50:41 -0700 (PDT)
Date: Tue, 16 Sep 2025 19:50:17 -0700
In-Reply-To: <20250917025019.1585041-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917025019.1585041-3-jasonmiu@google.com>
Subject: [RFC v1 2/4] kho: Adopt KHO page tables and remove serialization
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, 
	Joel Granados <joel.granados@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EC0A1C0009
X-Stat-Signature: ispxsqif17tpbk99zpxxctzx1ufzx7sk
X-Rspam-User: 
X-HE-Tag: 1758077442-897631
X-HE-Meta: U2FsdGVkX18UCncPh3PorGW0t4kE59Bj9viId+nG0sTqNE2fBV/dskFQifaIQICXMx0YQ2fi+1El3IXfxm67po7cyr79yddJPWQQgLHYMZZu+uUUWpUw8JcJ6nWWPvluBzCNQ2XkUx9WNsAGUoOIui8PyM/JkIwFO8rN78cgt04EVbVDNNhKzD7gKcy75ufnFzqq4fk4w0hHFmi01H4WmmNH3DFVNGooLPDMqR7sz87gDdvSJ349hRw20uF3qTGq/q0oqRG/1cQTVoOCCQP58T9nerADPenl/rT41B3Iu8KhxRcSGXn9XHSJMpaKEHj4mjfWaOJimMFYYrw9c6QHIDtkFjH/pKpGYIupLnwdIVXtebi8ZX0zw8XaELd9dPC7IrcpTDqGxwuvwXaobyy7Smv8qx4Fx4foLxc+G1gWMIQLKvl3cqInW6gg+B4193i4GRb9c6q+82xvnhT5U70OhUeeHbk3ql8M4oiX3l0/yw3rwZxnGGlvF8Xbohmpw057SvWCvXP5I1r6r3Qlc19fiJe89l19TgWQZTzoaUn4L8yzzjMbzwY5enHHMxS7MwiO7tVeXy8rmEEG8L3jjqD9qJk9uBVJxqCSYcRxQZL9sz4nTuTR/sWC1Vg9QwedMTBeuLc8aFocJADoHu3jkTZUVtXrXd0rCPBpA/raNZhGqGCJPw3gRsLMBhN5b6THqjb0yysS805c0q2vR/x7KN3a8CsdvSdBqPw5nh9kkecfKeMqAdv0pHb0JJzyXsxxyySpBo/JHHB1lMBWVMhQ6TMPT+KOe6DjXbmUVRKZ5sDcifySHRlhd08Dd1ci3KxcgmINJjCHQVKQAy6eNUyXW8j3QdBGkCG6BLpYerTIAVCdq528H4h5t8/frbfXaUczB3YOXvvHQAICFtQlJBDk7O+m/s0LoWcMwtgZMNSXNgphC6IE6rTyuHOETWJ2P9rsOAtnWoK8aM91A6i4Wt6Sk3j
 3kw4wSu+
 Y9izF5msy01A8vGt0YaIYR++y4JaeIBcuqJo4iuZD5AaADa+AVwOHqrbv4l+S8SvedRyzK6cw4lGq5Zwso28DquarXr0MDdEMPZoVq2xCgS99Wxat4OiBUKEnzYsVbb56C7/QDJRZ3iYr8vCoS6W2TwpNpgd2Q/0HON005Pel1EaTnI9izEuQHOKIYX4oEGzzczym3mxI17R8iLePxbsD9Uk9wz5ZogWBrQ8YK36t+7Hoa/y9QwLdbPLgI71RVZcopsK1YEMKJVvdL6TihSmcG6Gvqi0t70RsYK111xhJa+4zn75LwQNRLls8b6vHPAqtRZP1+9WiktNqmEZAI/AMFKgOL6Ciuc+3314p35ETtSxO1i6bEZy3CClqllKZ6Wxm/X1+BkdnTIiCPbS+VIDQOa/U41/RqCV6zZXOuFM9GVzgJswJ+QdQbQ1O1jM04gQ4MlNQvDN3h45CBDymPyr55CkUw0TrYJFXr3A9jLhovSC+lOGdEbvOoeJpMaKzuO6Vzl4MewfOuRNjvag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transition the KHO system to use the new page table data structures
for managing preserved memory, replacing the previous xarray-based
approach. Remove the serialization process and the associated
finalization and abort logic.

Update the methods for marking memory to be preserved to use the KHO
page table hierarchy. Remove the former system of tracking preserved
pages using an xarray-based structure.

Change the method of passing preserved memory information to the next
kernel to be direct. Instead of serializing the memory map, place the
physical address of the `kho_order_table`, which holds the roots of
the KHO page tables for each order, in the FDT. Remove the explicit
`kho_finalize()` and `kho_abort()` functions and the logic supporting
the finalize and abort states, as they are no longer needed. This
simplifies the KHO lifecycle.

Enable the next kernel's initialization process to read the
`kho_order_table` address from the FDT. The kernel will then traverse
the KHO page table structures to discover all preserved memory
regions, reserving them to prevent early boot-time allocators from
overwriting them.

This architectural shift to using a shared page table structure
simplifies the KHO design and eliminates the overhead of serializing
and deserializing the preserved memory map.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 include/linux/kexec_handover.h |  17 --
 kernel/kexec_handover.c        | 532 +++++----------------------------
 2 files changed, 71 insertions(+), 478 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb13..c8229cb11f4b 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -19,23 +19,6 @@ enum kho_event {
 struct folio;
 struct notifier_block;
 
-#define DECLARE_KHOSER_PTR(name, type) \
-	union {                        \
-		phys_addr_t phys;      \
-		type ptr;              \
-	} name
-#define KHOSER_STORE_PTR(dest, val)               \
-	({                                        \
-		typeof(val) v = val;              \
-		typecheck(typeof((dest).ptr), v); \
-		(dest).phys = virt_to_phys(v);    \
-	})
-#define KHOSER_LOAD_PTR(src)                                                 \
-	({                                                                   \
-		typeof(src) s = src;                                         \
-		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
-	})
-
 struct kho_serialization;
 
 #ifdef CONFIG_KEXEC_HANDOVER
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 0daed51c8fb7..578d1c1b9cea 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -29,7 +29,7 @@
 #include "kexec_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
-#define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
+#define PROP_PRESERVED_ORDER_TABLE "preserved-order-table"
 #define PROP_SUB_FDT "fdt"
 
 static bool kho_enable __ro_after_init;
@@ -297,15 +297,7 @@ static int __kho_preserve_page_table(unsigned long pa, int order)
 	return 0;
 }
 
-/*
- * TODO: __maybe_unused is added to the functions:
- * kho_preserve_page_table()
- * kho_walk_tables()
- * kho_memblock_reserve()
- * since they are not actually being called in this change.
- * __maybe_unused will be removed in the next patch.
- */
-static __maybe_unused int kho_preserve_page_table(unsigned long pfn, int order)
+static int kho_preserve_page_table(unsigned long pfn, int order)
 {
 	unsigned long pa = PFN_PHYS(pfn);
 
@@ -365,8 +357,8 @@ static int __kho_walk_page_tables(int order, int level,
 	return 0;
 }
 
-static __maybe_unused int kho_walk_page_tables(struct kho_page_table *top, int order,
-					       kho_walk_callback_t cb)
+static int kho_walk_page_tables(struct kho_page_table *top, int order,
+				kho_walk_callback_t cb)
 {
 	int num_table_level;
 
@@ -378,7 +370,7 @@ static __maybe_unused int kho_walk_page_tables(struct kho_page_table *top, int o
 	return 0;
 }
 
-static __maybe_unused int kho_memblock_reserve(phys_addr_t pa, int order)
+static int kho_memblock_reserve(phys_addr_t pa, int order)
 {
 	int sz = 1 << (order + PAGE_SHIFT);
 	struct page *page = phys_to_page(pa);
@@ -390,143 +382,12 @@ static __maybe_unused int kho_memblock_reserve(phys_addr_t pa, int order)
 	return 0;
 }
 
-/*
- * Keep track of memory that is to be preserved across KHO.
- *
- * The serializing side uses two levels of xarrays to manage chunks of per-order
- * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
- * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
- * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
- * 512K of bitmap memory will be needed for order 0.
- *
- * This approach is fully incremental, as the serialization progresses folios
- * can continue be aggregated to the tracker. The final step, immediately prior
- * to kexec would serialize the xarray information into a linked list for the
- * successor kernel to parse.
- */
-
-#define PRESERVE_BITS (512 * 8)
-
-struct kho_mem_phys_bits {
-	DECLARE_BITMAP(preserve, PRESERVE_BITS);
-};
-
-struct kho_mem_phys {
-	/*
-	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
-	 * to order.
-	 */
-	struct xarray phys_bits;
-};
-
-struct kho_mem_track {
-	/* Points to kho_mem_phys, each order gets its own bitmap tree */
-	struct xarray orders;
-};
-
-struct khoser_mem_chunk;
-
 struct kho_serialization {
 	struct page *fdt;
 	struct list_head fdt_list;
 	struct dentry *sub_fdt_dir;
-	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
 };
 
-static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
-{
-	void *elm, *res;
-
-	elm = xa_load(xa, index);
-	if (elm)
-		return elm;
-
-	elm = kzalloc(sz, GFP_KERNEL);
-	if (!elm)
-		return ERR_PTR(-ENOMEM);
-
-	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
-	if (xa_is_err(res))
-		res = ERR_PTR(xa_err(res));
-
-	if (res) {
-		kfree(elm);
-		return res;
-	}
-
-	return elm;
-}
-
-static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
-			     unsigned long end_pfn)
-{
-	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
-
-	while (pfn < end_pfn) {
-		const unsigned int order =
-			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		const unsigned long pfn_high = pfn >> order;
-
-		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
-
-		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
-
-		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
-
-		pfn += 1 << order;
-	}
-}
-
-static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
-				unsigned int order)
-{
-	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa, *new_physxa;
-	const unsigned long pfn_high = pfn >> order;
-
-	might_sleep();
-
-	physxa = xa_load(&track->orders, order);
-	if (!physxa) {
-		int err;
-
-		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
-		if (!new_physxa)
-			return -ENOMEM;
-
-		xa_init(&new_physxa->phys_bits);
-		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
-				    GFP_KERNEL);
-
-		err = xa_err(physxa);
-		if (err || physxa) {
-			xa_destroy(&new_physxa->phys_bits);
-			kfree(new_physxa);
-
-			if (err)
-				return err;
-		} else {
-			physxa = new_physxa;
-		}
-	}
-
-	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
-				sizeof(*bits));
-	if (IS_ERR(bits))
-		return PTR_ERR(bits);
-
-	set_bit(pfn_high % PRESERVE_BITS, bits->preserve);
-
-	return 0;
-}
-
 /* almost as free_reserved_page(), just don't free the page */
 static void kho_restore_page(struct page *page, unsigned int order)
 {
@@ -568,151 +429,29 @@ struct folio *kho_restore_folio(phys_addr_t phys)
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
-/* Serialize and deserialize struct kho_mem_phys across kexec
- *
- * Record all the bitmaps in a linked list of pages for the next kernel to
- * process. Each chunk holds bitmaps of the same order and each block of bitmaps
- * starts at a given physical address. This allows the bitmaps to be sparse. The
- * xarray is used to store them in a tree while building up the data structure,
- * but the KHO successor kernel only needs to process them once in order.
- *
- * All of this memory is normal kmalloc() memory and is not marked for
- * preservation. The successor kernel will remain isolated to the scratch space
- * until it completes processing this list. Once processed all the memory
- * storing these ranges will be marked as free.
- */
-
-struct khoser_mem_bitmap_ptr {
-	phys_addr_t phys_start;
-	DECLARE_KHOSER_PTR(bitmap, struct kho_mem_phys_bits *);
-};
-
-struct khoser_mem_chunk_hdr {
-	DECLARE_KHOSER_PTR(next, struct khoser_mem_chunk *);
-	unsigned int order;
-	unsigned int num_elms;
-};
-
-#define KHOSER_BITMAP_SIZE                                   \
-	((PAGE_SIZE - sizeof(struct khoser_mem_chunk_hdr)) / \
-	 sizeof(struct khoser_mem_bitmap_ptr))
-
-struct khoser_mem_chunk {
-	struct khoser_mem_chunk_hdr hdr;
-	struct khoser_mem_bitmap_ptr bitmaps[KHOSER_BITMAP_SIZE];
-};
-
-static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
-
-static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
-					  unsigned long order)
-{
-	struct khoser_mem_chunk *chunk;
-
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chunk)
-		return NULL;
-	chunk->hdr.order = order;
-	if (cur_chunk)
-		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return chunk;
-}
-
-static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
-{
-	struct khoser_mem_chunk *chunk = first_chunk;
-
-	while (chunk) {
-		struct khoser_mem_chunk *tmp = chunk;
-
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
-	}
-}
-
-static int kho_mem_serialize(struct kho_serialization *ser)
-{
-	struct khoser_mem_chunk *first_chunk = NULL;
-	struct khoser_mem_chunk *chunk = NULL;
-	struct kho_mem_phys *physxa;
-	unsigned long order;
-
-	xa_for_each(&ser->track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		chunk = new_chunk(chunk, order);
-		if (!chunk)
-			goto err_free;
-
-		if (!first_chunk)
-			first_chunk = chunk;
-
-		xa_for_each(&physxa->phys_bits, phys, bits) {
-			struct khoser_mem_bitmap_ptr *elm;
-
-			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
-				chunk = new_chunk(chunk, order);
-				if (!chunk)
-					goto err_free;
-			}
-
-			elm = &chunk->bitmaps[chunk->hdr.num_elms];
-			chunk->hdr.num_elms++;
-			elm->phys_start = (phys * PRESERVE_BITS)
-					  << (order + PAGE_SHIFT);
-			KHOSER_STORE_PTR(elm->bitmap, bits);
-		}
-	}
-
-	ser->preserved_mem_map = first_chunk;
-
-	return 0;
-
-err_free:
-	kho_mem_ser_free(first_chunk);
-	return -ENOMEM;
-}
-
-static void __init deserialize_bitmap(unsigned int order,
-				      struct khoser_mem_bitmap_ptr *elm)
-{
-	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
-	unsigned long bit;
-
-	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
-		int sz = 1 << (order + PAGE_SHIFT);
-		phys_addr_t phys =
-			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page = phys_to_page(phys);
-
-		memblock_reserve(phys, sz);
-		memblock_reserved_mark_noinit(phys, sz);
-		page->private = order;
-	}
-}
-
 static void __init kho_mem_deserialize(const void *fdt)
 {
-	struct khoser_mem_chunk *chunk;
 	const phys_addr_t *mem;
-	int len;
-
-	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	int len, i;
+	struct kho_order_table *order_table;
 
+	/* Retrieve the KHO order table from passed-in FDT. */
+	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_ORDER_TABLE, &len);
 	if (!mem || len != sizeof(*mem)) {
-		pr_err("failed to get preserved memory bitmaps\n");
+		pr_err("failed to get preserved order table\n");
 		return;
 	}
 
-	chunk = *mem ? phys_to_virt(*mem) : NULL;
-	while (chunk) {
-		unsigned int i;
+	order_table = *mem ?
+		(struct kho_order_table *)phys_to_virt(*mem) :
+		NULL;
 
-		for (i = 0; i != chunk->hdr.num_elms; i++)
-			deserialize_bitmap(chunk->hdr.order,
-					   &chunk->bitmaps[i]);
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+	if (!order_table)
+		return;
+
+	for (i = 0; i < HUGETLB_PAGE_ORDER + 1; i++) {
+		kho_walk_page_tables(kho_page_table(order_table->orders[i]),
+				     i, kho_memblock_reserve);
 	}
 }
 
@@ -977,25 +716,15 @@ EXPORT_SYMBOL_GPL(kho_add_subtree);
 
 struct kho_out {
 	struct blocking_notifier_head chain_head;
-
 	struct dentry *dir;
-
-	struct mutex lock; /* protects KHO FDT finalization */
-
 	struct kho_serialization ser;
-	bool finalized;
 };
 
 static struct kho_out kho_out = {
 	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.lock = __MUTEX_INITIALIZER(kho_out.lock),
 	.ser = {
 		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
 	},
-	.finalized = false,
 };
 
 int register_kho_notifier(struct notifier_block *nb)
@@ -1023,12 +752,8 @@ int kho_preserve_folio(struct folio *folio)
 {
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
-	struct kho_mem_track *track = &kho_out.ser.track;
-
-	if (kho_out.finalized)
-		return -EBUSY;
 
-	return __kho_preserve_order(track, pfn, order);
+	return kho_preserve_page_table(pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
@@ -1045,14 +770,8 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size)
 {
 	unsigned long pfn = PHYS_PFN(phys);
-	unsigned long failed_pfn = 0;
-	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = PHYS_PFN(phys + size);
 	int err = 0;
-	struct kho_mem_track *track = &kho_out.ser.track;
-
-	if (kho_out.finalized)
-		return -EBUSY;
 
 	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
 		return -EINVAL;
@@ -1061,19 +780,14 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		err = __kho_preserve_order(track, pfn, order);
-		if (err) {
-			failed_pfn = pfn;
-			break;
-		}
+		err = kho_preserve_page_table(pfn, order);
+		if (err)
+			return err;
 
 		pfn += 1 << order;
 	}
 
-	if (err)
-		__kho_unpreserve(track, start_pfn, failed_pfn);
-
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
@@ -1081,150 +795,6 @@ EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
 static struct dentry *debugfs_root;
 
-static int kho_out_update_debugfs_fdt(void)
-{
-	int err = 0;
-	struct fdt_debugfs *ff, *tmp;
-
-	if (kho_out.finalized) {
-		err = kho_debugfs_fdt_add(&kho_out.ser.fdt_list, kho_out.dir,
-					  "fdt", page_to_virt(kho_out.ser.fdt));
-	} else {
-		list_for_each_entry_safe(ff, tmp, &kho_out.ser.fdt_list, list) {
-			debugfs_remove(ff->file);
-			list_del(&ff->list);
-			kfree(ff);
-		}
-	}
-
-	return err;
-}
-
-static int kho_abort(void)
-{
-	int err;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.ser.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.ser.track.orders);
-
-	if (kho_out.ser.preserved_mem_map) {
-		kho_mem_ser_free(kho_out.ser.preserved_mem_map);
-		kho_out.ser.preserved_mem_map = NULL;
-	}
-
-	err = blocking_notifier_call_chain(&kho_out.chain_head, KEXEC_KHO_ABORT,
-					   NULL);
-	err = notifier_to_errno(err);
-
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
-}
-
-static int kho_finalize(void)
-{
-	int err = 0;
-	u64 *preserved_mem_map;
-	void *fdt = page_to_virt(kho_out.ser.fdt);
-
-	err |= fdt_create(fdt, PAGE_SIZE);
-	err |= fdt_finish_reservemap(fdt);
-	err |= fdt_begin_node(fdt, "");
-	err |= fdt_property_string(fdt, "compatible", KHO_FDT_COMPATIBLE);
-	/**
-	 * Reserve the preserved-memory-map property in the root FDT, so
-	 * that all property definitions will precede subnodes created by
-	 * KHO callers.
-	 */
-	err |= fdt_property_placeholder(fdt, PROP_PRESERVED_MEMORY_MAP,
-					sizeof(*preserved_mem_map),
-					(void **)&preserved_mem_map);
-	if (err)
-		goto abort;
-
-	err = kho_preserve_folio(page_folio(kho_out.ser.fdt));
-	if (err)
-		goto abort;
-
-	err = blocking_notifier_call_chain(&kho_out.chain_head,
-					   KEXEC_KHO_FINALIZE, &kho_out.ser);
-	err = notifier_to_errno(err);
-	if (err)
-		goto abort;
-
-	err = kho_mem_serialize(&kho_out.ser);
-	if (err)
-		goto abort;
-
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.ser.preserved_mem_map);
-
-	err |= fdt_end_node(fdt);
-	err |= fdt_finish(fdt);
-
-abort:
-	if (err) {
-		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
-	}
-
-	return err;
-}
-
-static int kho_out_finalize_get(void *data, u64 *val)
-{
-	mutex_lock(&kho_out.lock);
-	*val = kho_out.finalized;
-	mutex_unlock(&kho_out.lock);
-
-	return 0;
-}
-
-static int kho_out_finalize_set(void *data, u64 _val)
-{
-	int ret = 0;
-	bool val = !!_val;
-
-	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
-	if (val)
-		ret = kho_finalize();
-	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
-	mutex_unlock(&kho_out.lock);
-	return ret;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-			 kho_out_finalize_set, "%llu\n");
-
 static int scratch_phys_show(struct seq_file *m, void *v)
 {
 	for (int i = 0; i < kho_scratch_cnt; i++)
@@ -1265,11 +835,6 @@ static __init int kho_out_debugfs_init(void)
 	if (IS_ERR(f))
 		goto err_rmdir;
 
-	f = debugfs_create_file("finalize", 0600, dir, NULL,
-				&fops_kho_out_finalize);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
 	kho_out.dir = dir;
 	kho_out.ser.sub_fdt_dir = sub_fdt_dir;
 	return 0;
@@ -1381,6 +946,35 @@ static __init int kho_in_debugfs_init(const void *fdt)
 	return err;
 }
 
+static int kho_out_fdt_init(void)
+{
+	int err = 0;
+	void *fdt = page_to_virt(kho_out.ser.fdt);
+	u64 *preserved_order_table;
+
+	err |= fdt_create(fdt, PAGE_SIZE);
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	err |= fdt_property_string(fdt, "compatible", KHO_FDT_COMPATIBLE);
+
+	err |= fdt_property_placeholder(fdt, PROP_PRESERVED_ORDER_TABLE,
+					sizeof(*preserved_order_table),
+					(void **)&preserved_order_table);
+	if (err)
+		goto abort;
+
+	*preserved_order_table = (u64)virt_to_phys(kho_order_table);
+
+	err |= fdt_end_node(fdt);
+	err |= fdt_finish(fdt);
+
+abort:
+	if (err)
+		pr_err("Failed to convert KHO state tree: %d\n", err);
+
+	return err;
+}
+
 static __init int kho_init(void)
 {
 	int err = 0;
@@ -1395,15 +989,26 @@ static __init int kho_init(void)
 		goto err_free_scratch;
 	}
 
+	kho_order_table = (struct kho_order_table *)
+		kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!kho_order_table) {
+		err = -ENOMEM;
+		goto err_free_fdt;
+	}
+
+	err = kho_out_fdt_init();
+	if (err)
+		goto err_free_kho_order_table;
+
 	debugfs_root = debugfs_create_dir("kho", NULL);
 	if (IS_ERR(debugfs_root)) {
 		err = -ENOENT;
-		goto err_free_fdt;
+		goto err_free_kho_order_table;
 	}
 
 	err = kho_out_debugfs_init();
 	if (err)
-		goto err_free_fdt;
+		goto err_free_kho_order_table;
 
 	if (fdt) {
 		err = kho_in_debugfs_init(fdt);
@@ -1431,6 +1036,9 @@ static __init int kho_init(void)
 
 	return 0;
 
+err_free_kho_order_table:
+	kfree(kho_order_table);
+	kho_order_table = NULL;
 err_free_fdt:
 	put_page(kho_out.ser.fdt);
 	kho_out.ser.fdt = NULL;
@@ -1581,6 +1189,8 @@ int kho_fill_kimage(struct kimage *image)
 		return 0;
 
 	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
+	/* Preserve the memory page of FDT for the next kernel */
+	kho_preserve_phys(image->kho.fdt, PAGE_SIZE);
 
 	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
 	scratch = (struct kexec_buf){
-- 
2.51.0.384.g4c02a37b29-goog


