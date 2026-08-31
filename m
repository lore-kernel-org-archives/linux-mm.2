Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6771EC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB9E6B009B; Mon, 31 Aug 2026 03:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACF96B009D; Mon, 31 Aug 2026 03:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E666B009E; Mon, 31 Aug 2026 03:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2307B6B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:55:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91B19A3D92
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:03 +0000 (UTC)
X-FDA: 85160803686.29.9991FEE
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id D409780002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jK3z2PsS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fLjmUTfKT3TRPIaKPcH4qoh94gQxw3yJaaLiOmIzFs=;
	b=I+ywIx3eL7wzJDOEAl9TkkLB8OEbN98JAx8OXSgXkmBbmU8vUs0cwZHrTR6OvrqMxo+7V8
	GYy0XCoqDCjVnDfpG7CsgVQxQlHBWReKq7D9d0J29Y4ss+XF//Pdqjj0zwDql4WLXpFXhB
	CF449rTD3POOQfj3a30T6t/ZBIRw1C8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162901;
	b=vQgQz1Ztek2Kn1V5v8c/0zCBseTIVz4z1o6c3ekmKpeAoA7+BTsX2Wg/OPtajWwg1PExiM
	hBB8r1X6mKQTK9CHqzTfp1Kh5ldj9LqIbp0UdxcEcb+xVDDQk3q3JQCjpT56oJx/y7byKa
	qQvUwIyqnddExPulavvjcEfOYx2+WCw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jK3z2PsS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1c7364550so3336554a12.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162901; x=1788767701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4fLjmUTfKT3TRPIaKPcH4qoh94gQxw3yJaaLiOmIzFs=;
        b=jK3z2PsSTI84fdFKxM1jTuB8gKiTVlSUVyU3QDejw662ZIe/CBEqdWTFR8JKg5w403
         ghx0hKUINNw3Br1GkSSdix1lsqOk9PPL9sRHX4pD2w63N00HdC1mwdOI/8s+J8nezffA
         wwnzFh+RKdGziuV9aCxBUJkpSAmp2JIOs0IP+BS2CKvYP/U5rIX5nJXq6nHdGgATPI2R
         vLFLeVa+VIpVhrW3wg1T7DyHcc0qvmIjsgRkW02KBJ0lixg5tCX9G6IpwUmJO7a1jbRG
         T1xRUho+vZobtdRkHSkMU/S52ws/AXjJKVri/r9rQExVT0QzqO3Ksnm8ide/wCW//mIA
         N3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162901; x=1788767701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4fLjmUTfKT3TRPIaKPcH4qoh94gQxw3yJaaLiOmIzFs=;
        b=e7tMLxFqQuSFRXpr479fv8NyTJwIgbQtKo3WSAbrAeVk/acJXWdrLIH4itN6i2xWMC
         x/vUsaMgzQ7zVIQSaftMriQZyp8pZCC3do0zLG7qTHJ02YagwhsKh41gO3wK6vCIHvIA
         hiWaXbnCz1gl1qodLaisdmxyKXKRm5Fp2yr60bljKjNWLYiV4306HbO3Q67nZu+rUveC
         ocyi3x7Tn32+CW+5IJBJKSE2ZNWFbyuovKy81mxzn49z/HP1t5aTe62jcnE0pmCGcL4b
         7ptty4CAp/6yeeE1ODGsU51WiN9NzoeX3N1RibizUYsEzFspwAjsyXyhwbHjNa8Q8GG/
         zQcQ==
X-Gm-Message-State: AFuF++ns7v33UlFNWavxeNkqziMaS3FggGj/z6RqHuVQiOrfnCeLIwDd
	1k+7cQYkNFkp2s4NS5GUNnKPPAGLtNiUK5CSOxxswB5/VLpnZj+UoMWsxvKs0mHd72E=
X-Gm-Gg: AR+sD10XvaEMvNwNv58wUWAYZL1NjmybP4KkKG17bD5E/DE8K5n8suMAzFoEjm1oFgF
	DhBObQgz76gbkcv/c/ttY9Sgg/3Mnw9AMvURAQKyQRZwNlaBwKPaEWp39EI2vqIoZxiw6fAB6/u
	jSINgNhcr5ICm565uoPUmHHyjVLe6iXqupYqZY12RyYnWJVb0HNCxGtKJ8nYLdtLiJqu/zLooJK
	3HKGnnTaUN44KLTtL45IeshLPsIgxGUUStbjt7BBFDxBOQIAwEaTSH4r1ltyF6gByPa8Iqzi144
	XtZaWFvFgh+TypFDvbIHCq+9eKJE8QKS2P53lv2duUHAvsu4wCY+MUrO7kbjhuJ/ncPCv8I6jFc
	nxq13lt4BC1uZTRZkM9F3fG9NqGOnLceG/YmOBRdoMK4hccMxZ1XuFHEGmbaCOuo3jZwYZU9+JA
	LqYkovwvoXGR8omI+tB0OdZCt7Ccu+HsOoPfJZoDndtKkTLBH01YLh4jwBmCveA2ix/930726CS
	jCfhAf92mkC2RkC5AhXup9L
X-Received: by 2002:a05:6a21:a09:b0:3b4:61f:1fec with SMTP id adf61e73a8af0-3d26668474amr44495998637.2.1788162900583;
        Mon, 31 Aug 2026 00:55:00 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:55:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 07/11] mm/sparse-vmemmap: move HVO helpers to a public header
Date: Mon, 31 Aug 2026 15:53:38 +0800
Message-ID: <20260831075342.57563-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D409780002
X-Stat-Signature: hmig9f9zg71d191a55tfe4euzpti33eb
X-Rspam-User: 
X-HE-Tag: 1788162901-495105
X-HE-Meta: U2FsdGVkX188J9oTPnHeZm8wlpqK99k0FzduekWMh+S26SK6CqqaL5VMHdVjvuDi5QDO2Ri5B5Ms1fKuklUdHasn8gMFiZf+Ryx7JomWxIviLsAWbpEvxrn90p8rSonMqCun1ObbOKZPi6gIHSh4c/Kb2ubmM58NxhXKP7jEnFwwiiUJW22LjxYh720icEJsfJUpoWQfZN2YMggRKmj4lRsr6SnDtZFD0bf9CZLZMsi2YUFfruf3VXL0j8HjcKDVHSS3UL4oa0DmMhegvrP8YIaGuiauMYAN//yKDsf2JBMPzPPRVIL5iG7Gp8k6tFJE+uxyv5aK6iMS3bTzVZgqAL+Git0+yHGskwMcJqHxpI6Hz0lE76soZ3lNRMH9usE46aoktqaMc8jOIa8ZEk0zHw/aI50a8EliuTZh+zgyVdy1FMHyZ9pfnDVkinL+/dF8au1WkeJxXrtzqdF10rODAsIE0qFcnEz6qzrVjvsnWPLLdIhGWqJgmzJf+TOW7DeWssnE2wptTWIpAsJieq7ji6Km8namkgX2GPzzADapyXRsTeSXpl7QdNAbtcrx5IuFmMQDYFu20McziIKeXDTpegN+Jx8kVLO+EOv+Wh0OMjdzAByDX/tR2DqGdiOB913kl1vp6hGSD1TeDqP46JqPLczvGeeI9TpgLeNLXrQCLbYn+JElSlaj65jcz8k6ty+jZFlk63Tp+HvxAXd0Sk9BhLDPqDHWfQEnokmrjTAy5UbpUpbwgQvowywXpEhzUirvWC7NuUh2b44MfouTkXYuxntE8kigFsSYe5Azc4VwMZLmlmj5pYML6CCI7vUtcFR6GiMgwpEBjfS6y30zQBTKrRoGAxRAVZfeLIHCCJE7zdi6gB72mQdnM7RU0T18/DQCawDOscEfQSrVwEyspMBzPgHQSPrlsQ+qt/1Wnujtdi+QlmtWuZrdRrWynhn2UbAE8dlCMmcthTovH7pOojj
 HKy+hjsT
 M0pYpBh9Dulor1BWWqmXUHUBoVtfR+iN6xQs87IXqny75ABgEOrHg1uU0r8W1aR71yXGvflz8mp+9rlXO1SmDtqfhak+Ww/KhQTR6PFwlVhMIgiU9mX143B6NUG5ueZ/87sLRxQzAcLPhorMoNObSq/TFzo96vyluHGSYIJmtdXosbg4LnuQKHMsPuCVZ5Yorykr0JjOaSPdmRGVWQMR2m0BrM67pcigwJ+yOAK5JnfbRm2VFRzF25sJ/SrbP7ZcVRwGeWOgbGKp9qFU782s+AWVsSUGqwQOonjZqL4i3cf6JlRMbbu41jQCsyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmemmap optimization helpers currently live in mm/sparse.h,
which is an internal MM header. That works for MM code, but
prevents powerpc from using the same interfaces without including a
private header.

Move the declarations and inline helpers to
include/linux/vmemmap-optimization.h. This is a preparatory change for
powerpc, which has its own vmemmap optimization implementation and
needs to use the HVO interfaces from architecture code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 MAINTAINERS                          |  1 +
 include/linux/vmemmap-optimization.h | 88 ++++++++++++++++++++++++++++
 mm/hugetlb.c                         |  2 +-
 mm/hugetlb_vmemmap.c                 |  2 +-
 mm/memory_hotplug.c                  |  1 +
 mm/sparse.h                          | 73 +----------------------
 6 files changed, 93 insertions(+), 74 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a3167bcbe589..ccc7f75bbeb0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12099,6 +12099,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
+F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
new file mode 100644
index 000000000000..171553fabd47
--- /dev/null
+++ b/include/linux/vmemmap-optimization.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * vmemmap-optimization.h
+ *
+ * Generic vmemmap optimization declarations.
+ *
+ * Author: Muchun Song <songmuchun@bytedance.com>
+ */
+#ifndef _LINUX_VMEMMAP_OPTIMIZATION_H
+#define _LINUX_VMEMMAP_OPTIMIZATION_H
+
+#include <linux/mmzone.h>
+
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
+	section->order = order;
+}
+
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
+		return;
+
+	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+		section_set_order(__nr_to_section(section_nr + i), order);
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return section_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+}
+
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif /* CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION */
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_order(pfn);
+	const unsigned long nr_pages = 1UL << order;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+}
+
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+#endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8fa1bafa03d9..5aa9c0eaf2d0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -38,6 +38,7 @@
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
 #include <linux/pgalloc.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/page.h>
 #include <asm/tlb.h>
@@ -52,7 +53,6 @@
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
 #include "mm_init.h"
-#include "sparse.h"
 #include <linux/page-isolation.h>
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4a57e6c3352c..25c4e7d2664c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -15,10 +15,10 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
-#include "sparse.h"
 #include "internal.h"
 
 /**
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d28bafb6fd53..4f3387632883 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -43,6 +43,7 @@
 #include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
+#include "sparse.h"
 
 enum {
 	MEMMAP_ON_MEMORY_DISABLE = 0,
diff --git a/mm/sparse.h b/mm/sparse.h
index 59b825df83b9..e511d99fc26b 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -9,77 +9,7 @@
 #define __MM_SPARSE_H
 
 #include <linux/mmzone.h>
-
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
-static inline unsigned int section_order(const struct mem_section *section)
-{
-	return section->order;
-}
-
-static inline void section_set_order(struct mem_section *section, unsigned int order)
-{
-	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
-	section->order = order;
-}
-
-static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
-					   unsigned int order)
-{
-	unsigned long section_nr = pfn_to_section_nr(pfn);
-
-	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
-		return;
-
-	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
-		section_set_order(__nr_to_section(section_nr + i), order);
-}
-
-static inline unsigned int pfn_to_section_order(unsigned long pfn)
-{
-	return section_order(__pfn_to_section(pfn));
-}
-#else
-static inline unsigned int section_order(const struct mem_section *section)
-{
-	return 0;
-}
-
-static inline void section_set_order(struct mem_section *section, unsigned int order)
-{
-}
-
-static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
-					   unsigned int order)
-{
-}
-
-static inline unsigned int pfn_to_section_order(unsigned long pfn)
-{
-	return 0;
-}
-#endif
-
-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
-{
-	const unsigned int order = pfn_to_section_order(pfn);
-	const unsigned long nr_pages = 1UL << order;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-}
-
-static inline bool vmemmap_optimizable_order(unsigned int order)
-{
-	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
-}
+#include <linux/vmemmap-optimization.h>
 
 /*
  * mm/sparse.c
@@ -139,7 +69,6 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


