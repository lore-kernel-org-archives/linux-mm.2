Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3669EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165746B00B0; Wed,  8 Jul 2026 10:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D356B00B2; Wed,  8 Jul 2026 10:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052666B00B3; Wed,  8 Jul 2026 10:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC2AF6B00B0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:12:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 525391A0140
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:27 +0000 (UTC)
X-FDA: 84965799534.27.6474355
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9737040005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iAQ1P35k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J38DrbD7HGGgkXHTOv7ioJOBlse544u95iqYz9lc1ao=;
	b=vLRwle0j4w3y4zGn6Gjk9Nwk87UgoIPsZvYuwPqEowKNLqmd0d32l6Vdr/2ID2Rty+p9A1
	1CAly5F+SzKinrSgDKWWwlrBSN2UE+QeEYWW3Tb2AvwkfkFQYuKg6/bMoxAKOlKstCtbwJ
	Sk/6hWx1kn9tWE6EbsS89mKSWUxfvSk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iAQ1P35k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519945;
	b=ioJWidg847Bfg48zrBjXNwOJslU5sYqIc8iDd9liTnZEk7Ycb3EQQ2RDQrpwuVOGMmYQbA
	t0MzR5+sejRktZFdjFBgGzmVkvuAp36k9pxJU7B6E8WyF5dFYSmgtK5tt68r9xkEMPVMk0
	cB/aconT58Mom/WB5qrH8mnc1ApzfTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6EB1402D6;
	Wed,  8 Jul 2026 14:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3731F00A3D;
	Wed,  8 Jul 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519944;
	bh=J38DrbD7HGGgkXHTOv7ioJOBlse544u95iqYz9lc1ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iAQ1P35kJG7h2YU5gI9Dkl9yV9n2YwjPBEecOBDxjGfgx1yNtFaIaZdAtue7k7WfA
	 zfYdhFDtZlZZlsdqIL2hkkRax3Pi0RkofDvjBMO+rqZVtEgnUniF7JIeBnQpT6wxqm
	 D4WGFgjwAiDWjzq6ttLmnahNLnab4AGAaGVFZCwgczJ/quwEYEFwaKC6WysIKeMqie
	 XmLqp6jZc80RuPYBWuvlIMut/o176f5A4dgxTCfEuMHXvjGZBcTTKHGrr//pCfMx1g
	 sxNGQQk4iGUo4O/mcVWBfm0MKyaltDHC5++B0BZHJNCtUI3bZYxYuhiKPNkvvKSgZQ
	 Lr1NR9EoHom1g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:11:05 +0200
Subject: [PATCH 10/10] mm/bootmem_info: remove
 CONFIG_HAVE_BOOTMEM_INFO_NODE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-10-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9737040005
X-Stat-Signature: 5yn5e8ry745f4k6p5bgwpwcytnqbmhnq
X-HE-Tag: 1783519945-836416
X-HE-Meta: U2FsdGVkX19DCxTpZ4mTSscJWIGbG1CwENAxq413XNil4cTk07cH02viYRFyooki0LBcYXrr8CXd7N0S/G46REcaEOELw8GCZMUowSWSb7L/WTLKtN5I4lVlBFaeoOYGUBH+Ez8FzjJjWrsEUtt7SK/xZOsMrOnRopxpEzVFq83j2Qu4VDZ/d4Iz2pCRw4kpGMzmYPWh85O2bIqeRFXLWCU4Iw8DrLSoSW4Kc/gaKp7Oa1RTZysz3LEl15aKnccV1uGPgP9dPv4R+icq47rHuu32vJ1ofW/Ac0dwQAVK/mZ9ykcoIVCAkfUyntV1sYrREx1/VlbMLeRXhMPePw33H0YAInGwJD1Oy+/LB4HUnzGYD/4rCnZXBR5cftI2JRWfgIkEWScQpitughH1N9SkKIEr2nlncQfF/hetbBBDPmouPHjLMEL08bX3IjbWIr3b1vYEN4KyDF1a6Fd+RYeOS6bhHUzbTC6hG4Kma7CgWnW7stNtI+DwEQ9Izb/+qKCtrFBrzZv6/We9LsZGEt1h1BEmn3BC4kIjlHBlm7Ldz5IwpyP3l8gWXDCsEDR2mixv0V/LujmgJweIj1E6/PNdXxS3eKlbw3q8J1LwMdG82R9ztB8+1LjJB57F1w49N6DKcP5Uu5mNbS8hj2EYwWDRDGvgX7CW9oYiBTrPeX139zi+9fo/Q6t6lhMZyrDS2OKjHiPqS8UPUq3s95XU1ZIi2jlIfFStiG2Sa9g9E6wBsHfLBwUbjJhZtQg8iEdQtcy24n85Y/DGowBx/WPMWloxNtUfRW9G681B2ARXtscNR9/fiElO8bC3Oj2KyPVbg4bFfAxlyHJUKJQmnAL9I6y4fAH8afMG5//lvrwmj7O29gF6QOaDP0RKZE0Tccwv7ZBEEzPq7Q046Ut9cYmToTEobg/GeQCg+reQCkzhmAllWOvQen7W7NXXXUXa0eSbzXUymJL0KprC5mauZ+5uiX4
 PllVNk/8
 0go7h3A+kM6GUDZw+C2znMeQopQII9RIv+Yh+WQ6sCKyJoIlS9SAeJJGkpoGHo0UPxPpXUl+Lt0b7YJL3ENDi/2KtvfRateo/+reUdT9giNkNHF/Bak2qsmpACz2/fhaaW7Br+LxPE9BeeHrH/HTY+zXygY+irJzMbDlkuqANNFAEp0YrLWoQJ3ihFDXrG/BNT7QqIWu/QrSOyAMPeWAO8gTfXL5GAFwvToO/rKVhQ7RjJ8AmVaRj7oNEnCqAswE8d7BwR1pGOJVDMlPjz+pkXX0UF4iWGvrPEbcwh/Kz8BkQfmgfMbBpYadtypLEuJDSMscK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The whole infrastructure is unused now. Let's remove the config option
along with mm/bootmem_info. + include/linux/bootmem_info.h.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS                  |  1 -
 include/linux/bootmem_info.h | 89 --------------------------------------------
 mm/Kconfig                   |  7 ----
 mm/Makefile                  |  1 -
 mm/bootmem_info.c            | 72 -----------------------------------
 5 files changed, 170 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d19822d574fd4..9a67ae0f7865e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16877,7 +16877,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
 F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
-F:	mm/bootmem_info.c
 F:	mm/memblock.c
 F:	mm/memtest.c
 F:	mm/mm_init.c
diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
deleted file mode 100644
index 486acc6127039..0000000000000
--- a/include/linux/bootmem_info.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_BOOTMEM_INFO_H
-#define __LINUX_BOOTMEM_INFO_H
-
-#include <linux/mm.h>
-#include <linux/kmemleak.h>
-
-/*
- * Types for free bootmem stored in the low bits of page->private.
- */
-enum bootmem_type {
-	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 1,
-	SECTION_INFO = MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE,
-	MIX_SECTION_INFO,
-	NODE_INFO,
-	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
-};
-
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
-void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
-				  unsigned long nr_pages);
-
-void get_page_bootmem(unsigned long info, struct page *page,
-		enum bootmem_type type);
-void put_page_bootmem(struct page *page);
-
-static inline enum bootmem_type bootmem_type(const struct page *page)
-{
-	return (unsigned long)page->private & 0xf;
-}
-
-static inline unsigned long bootmem_info(const struct page *page)
-{
-	return (unsigned long)page->private >> 4;
-}
-
-/*
- * Any memory allocated via the memblock allocator and not via the
- * buddy will be marked reserved already in the memmap. For those
- * pages, we can call this function to free it to buddy allocator.
- */
-static inline void free_bootmem_page(struct page *page)
-{
-	enum bootmem_type type = bootmem_type(page);
-
-	if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
-		VM_WARN_ON_PAGE(page_ref_count(page) != 2, page);
-		put_page_bootmem(page);
-	} else {
-		free_reserved_page(page);
-	}
-}
-#else
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-
-static inline void register_page_bootmem_memmap(unsigned long section_nr,
-		struct page *map, unsigned long nr_pages)
-{
-}
-
-static inline void put_page_bootmem(struct page *page)
-{
-}
-
-static inline enum bootmem_type bootmem_type(const struct page *page)
-{
-	return SECTION_INFO;
-}
-
-static inline unsigned long bootmem_info(const struct page *page)
-{
-	return 0;
-}
-
-static inline void get_page_bootmem(unsigned long info, struct page *page,
-				    enum bootmem_type type)
-{
-}
-
-static inline void free_bootmem_page(struct page *page)
-{
-	free_reserved_page(page);
-}
-#endif
-
-#endif /* __LINUX_BOOTMEM_INFO_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 592003a258bad..169a3ba12a255 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -509,13 +509,6 @@ config EXCLUSIVE_SYSTEM_RAM
 	def_bool y
 	depends on !DEVMEM || STRICT_DEVMEM
 
-#
-# Only be set on architectures that have completely implemented memory hotplug
-# feature. If you are not sure, don't touch it.
-#
-config HAVE_BOOTMEM_INFO_NODE
-	def_bool n
-
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 4fc713867b9bd..52428a3d3ae14 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -141,7 +141,6 @@ obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
-obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
deleted file mode 100644
index 0fa78db7fbc0b..0000000000000
--- a/mm/bootmem_info.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Bootmem core functions.
- *
- * Copyright (c) 2020, Bytedance.
- *
- *     Author: Muchun Song <songmuchun@bytedance.com>
- *
- */
-#include <linux/mm.h>
-#include <linux/compiler.h>
-#include <linux/memblock.h>
-#include <linux/bootmem_info.h>
-#include <linux/memory_hotplug.h>
-#include <linux/kmemleak.h>
-
-void get_page_bootmem(unsigned long info, struct page *page,
-		enum bootmem_type type)
-{
-	BUG_ON(type > 0xf);
-	BUG_ON(info > (ULONG_MAX >> 4));
-	set_page_private(page, info << 4 | type);
-	page_ref_inc(page);
-}
-
-void put_page_bootmem(struct page *page)
-{
-	enum bootmem_type type = bootmem_type(page);
-
-	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
-	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
-
-	if (page_ref_dec_return(page) == 1) {
-		set_page_private(page, 0);
-		free_reserved_page(page);
-	}
-}
-
-static void __init register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long section_nr;
-	struct mem_section *ms;
-
-	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	if (!preinited_vmemmap_section(ms))
-		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
-					     PAGES_PER_SECTION);
-}
-
-void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-	unsigned long pfn, end_pfn;
-	int node = pgdat->node_id;
-
-	pfn = pgdat->node_start_pfn;
-	end_pfn = pgdat_end_pfn(pgdat);
-
-	/* register section info */
-	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		/*
-		 * Some platforms can assign the same pfn to multiple nodes - on
-		 * node0 as well as nodeN.  To avoid registering a pfn against
-		 * multiple nodes we check that this pfn does not already
-		 * reside in some other nodes.
-		 */
-		if (pfn_valid(pfn) && (early_pfn_to_nid(pfn) == node))
-			register_page_bootmem_info_section(pfn);
-	}
-}

-- 
2.43.0


