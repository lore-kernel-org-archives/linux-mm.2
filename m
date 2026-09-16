Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE25C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626D76B00A1; Wed, 16 Sep 2026 02:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533B96B00A2; Wed, 16 Sep 2026 02:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6356B00A3; Wed, 16 Sep 2026 02:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01F7E6B00A1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B986712062C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:27 +0000 (UTC)
X-FDA: 85218686574.09.06B633D
Received: from mail-pj2-f18.google.com (mail-pj2-f18.google.com [74.125.227.146])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01CA1C0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WDdndGFr;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.146 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO/SIiOPBpUCTQXEHAeYL+mDwPc1g15QDptSjej1KB0=;
	b=nEni+iVyGKlhq3XvecuouAwecUvQ6kHt+ARm0v7qZk7T3GfPeolfvxS+aRbRmMphwXyo+f
	FakQPVS9TervK7iZsn3LTubf2avd5y4wx5w/fO+tBP3FbWcq2Mh4bZsBikAxX/i8AHD+zY
	04sF9CUmLqmF6FL2L9nmPR0ztww/A4Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WDdndGFr;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.146 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541066;
	b=mAvUS+BcZlOoYI4qlYr3A7FPX4RMsS5L0nVjwMbGXdi6aZheGGHfv5jslPK8WSD3SAc5Kt
	SE9b+uUpzDPTi3vrmljYe8T0Z4P6td9OteTRFInd/boAqEMKO0yFCGiFPWKLyNwj04uoU0
	m5kgp7wYLdFgn5Yrl3/F1NybNWqfHUw=
Received: by mail-pj2-f18.google.com with SMTP id d9443c01a7336-2db22383fe8so3848425ad.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541065; x=1790145865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nO/SIiOPBpUCTQXEHAeYL+mDwPc1g15QDptSjej1KB0=;
        b=WDdndGFrCPVcM0to3xsuwz4+NxLQarKPdNFrLLx/VUgtATwAPzAyPklCfpoBzIyliT
         O4ftIO111u43+saTddsHKfoCwllSYMTsI7ZC7EFafGVPhdFkqFxmI2gssl038HZqLz3O
         KnjsajnGAKaaqNWYIxpbJo4OTkjFQ+MBPGc+h8RbxkO47ryKjvQj+np+3yn57yo5z7P1
         Ttxec9XrIvvqj22BgSKBj0yECi8mJp7HOdsK/Y9abs0nYSgNdKtUSm+jCCIPc5sZklLv
         lrqzFjwo+z00d5OlCFPvwOEQls/VQ/1xG4aQFSB9DNAfBNEp2iVJZg25xscAx+jiEk3p
         wqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541065; x=1790145865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nO/SIiOPBpUCTQXEHAeYL+mDwPc1g15QDptSjej1KB0=;
        b=tBumuaOyFSur5/UojwcZeh0R1lamTO29ntkMI6wE96XYoIOkoA/QgpnIwJwr72BA3N
         LsS9kJrBNvAltzca+k8yYg5DIdfRm/bJdXIRL8gIjbg9X8v8rPUJGT0d8oRDUCCjV3lE
         XXBJ7515sPLeiK93gsCWNblMC05ZPYv6N8CVFaW0BUQ26dVIlBwmh2CT6bVS59AToN1s
         PTu21XC7CHusSy8oyvcEw8IYnjxo2ePZtquHnt85ZTBEAeQ9RUMmdxO40JTcsXrpHbVW
         GW5Uy34VC4WGDR6o96r2uv52cSeDeKrYHI5KFnQ2p0BWDs0Fxd3fgQrSzRYNKeAfa5lj
         HPeQ==
X-Gm-Message-State: AFuF++k5Xo3iDTQUdX6exR+xcsyg88pxOtYDfLINLe9XdYz/5RBP34aE
	yD9y03a+obtFoaumds3oJ7ZSxpuUt5Qr4/dMUHFsPJ1FypEOM9R+6U2EPTtXizt7dac=
X-Gm-Gg: AYBFou3bcxfwI48jnNqfycg7KH+9SenMorpYhq0iQyz0esHH5NQ+TnUWG2NQjoHMwPB
	n6EMY1qKjabUVZo3GEucNwZJSQTIBBI2x7/LFY8/EA0PGigJ+4QmWwBLOmUzisCeb/NS2msvmoO
	6210LVqwkeeGpira7Xij0opxQQjEbfzqmJJblQrlLJfIkvRJTl0EAjUExCjsZfeXboC2MXwUFUG
	Oldc0qJNfD6X1VinV0gRM+LW0cJFAuPuFVdvZuGNq3cRoxjKKQY6pLOoGB6q0XBEeGthktpwbha
	0sYz0BmJHB+992CaR39pZCfSzThfoRphlUvb2GQhGFUBkih4mJxsmUw11/F18GkyLMSIW9HLaEV
	ogjZtMmmSiwqEMNh+TyF66Tfnpj9LW/5V5PMpeGp3L7hFwGFtCiBY6pLGKYIbwzxKY8IryuTEfQ
	esRCgT+FNqMpkmRHthfTOl4O/b9iLcygYMZpY83keCHKm5Socex9YnNVhtr4ySZJFQfhqpzHt0Y
	pSVFmzsb32nzfeDK9s=
X-Received: by 2002:a17:902:ce92:b0:2db:5f8c:b81c with SMTP id d9443c01a7336-2dd8e52ed65mr27165495ad.19.1789541064774;
        Tue, 15 Sep 2026 23:44:24 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:24 -0700 (PDT)
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
Subject: [PATCH v4 07/11] mm/sparse-vmemmap: move vmemmap optimization helpers to a public header
Date: Wed, 16 Sep 2026 14:43:37 +0800
Message-ID: <20260916064341.1825793-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 01CA1C0004
X-Stat-Signature: 7nwic6h8cwnsppue8ga5q5kmyjxndjeg
X-Rspam-User: 
X-HE-Tag: 1789541065-387483
X-HE-Meta: U2FsdGVkX18JM4XeHPYl95UzmXnZdIn9KUKOTyWABFLP16x+ChZVwey1SaU85x8XYSeqNnHkVHiUWIIB0CtDW2hUtrUNFj9yseIBmAWcJdeXlaDLIz3DHxh7SmP5vcNpqx94wUnnPBC8EZSwXC1Vu2VXWVb+GGevFAwxUZikza6QwRT/yxpJp26VaJjIGEJVJQPTdFap+csTfTtN8376acDfKwJNtySNn//VBeb9EWlaKE0zobxevXU/U5PNRuJhP98zByo8WTbymjUlhtMLR/TXWO+iXGWAzSfnPyvdsbrTFG11IFX5cwTxpQ+M9N5Z4yEVIUDjZCiY1KE3lY2t/3TmN4CvgJrgcs+yCwuwuydnmCAhIeEvODRiojj9vANslcBg2mIOq/SlKjKMr6pvKp9oWFeaR5f1Cqbk7e54FeyNGflYeZ/X7OTeTYoBlkC+nUNjR4mjqQSxl3E+JcFrK6QqpY8EKiBC9G28EyeMpKnxRMKB+oXRp3ZUXAdvlGBTzkOKJYRB/O13GmGc5DzkBBlZNJvPaSGjZxULwji7Z7zTmZ5lVxXN+Whu1SqjM4WUsnQUbjv1Rv1xtWHzYCkOfjhsLupqEhOzGe8w9I/mqsvVdshDsXzU8j44lViQARbvkJOjrsti+L8YWmXI+HlMVy9AYfmixOnEn9llwEtUH7TYkK4C6zloC3bmmMEcpWInGotlTEppNmEVkRYKqBzSK+6QgDbXj6cI7QkX/I/hUI5CiRjKGXfD7GzmanM7tERjyE8imkafKvI+xBJ6+Kt64e4ivuJd03maNq8+wuNpXle4fiDIrvuM6QWYJt8PKOWTW1KrTUn+o6e80dGAXdlg6K/LbmKKHtwnoNfIhZJrdAarsIeQTLzg8TCoTwXaFu20Py3ToEQxtwZVhQ6wzjlS8IwJdCVO1pRgjS+Sy0VG+KiDC5krACIKRYVFhIiUO/2m/MXQ5MjFMIyXhmqZdWO
 shJM09+Y
 W04WjsPGabYhVm5uCHqnR/rNudaEb0rhBQENqDwO4ZAzsxuFig0KRyZQAqyDuTUsUrsOrt/wUBimi0E2UZPijQI07GV9LGTG6H8XcwCdzBsvKxqaj3GzuydzeW0ol3P3VIbSfy6Zh79q4E0xOVpi1Gxg3MkprI5pbYIMJU4h+t7B0QUtxxpz/ww7/5FKUMDonmyS/vUXGbgSZRTAdeflaos7t0LkgkVrXaj97ms4oTfbKTSLvaPIz10eFmC+2P8014YODOyfkiw/xr4Ej0U9bJmtiB3rzl0qQM8BBskjumqm8TqkeNRQ3NA1qCM958qdW2DwpuzbnyZGq6XA=
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
powerpc, which has its own vmemmap optimization implementation and needs
to use the common vmemmap optimization interfaces from architecture code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v4:
- Use the renamed VMEMMAP_OPTIMIZATION config in the public header
- Collect Acked-by from Mike Rapoport

v3:
- Update the subject and commit message to describe common vmemmap
  optimization helpers
- Collect Acked-by from Qi Zheng

v2:
- Fix missing header dependencies.
---
 MAINTAINERS                          |  1 +
 include/linux/vmemmap-optimization.h | 94 ++++++++++++++++++++++++++++
 mm/hugetlb.c                         |  2 +-
 mm/hugetlb_vmemmap.c                 |  2 +-
 mm/sparse.h                          | 76 +---------------------
 5 files changed, 98 insertions(+), 77 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3ef018673b5e..e4412c3d8d45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12096,6 +12096,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
+F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
new file mode 100644
index 000000000000..0f9da22bd8d0
--- /dev/null
+++ b/include/linux/vmemmap-optimization.h
@@ -0,0 +1,94 @@
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
+#include <linux/align.h>
+#include <linux/log2.h>
+#include <linux/mmdebug.h>
+#include <linux/mmzone.h>
+
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return section->compound_page_order;
+}
+
+static inline void section_set_compound_order(struct mem_section *section,
+					      unsigned int order)
+{
+	VM_WARN_ON(section_compound_order(section) && order &&
+		   section_compound_order(section) != order);
+	section->compound_page_order = order;
+}
+
+static inline void section_set_compound_order_range(unsigned long pfn,
+		unsigned long nr_pages, unsigned int order)
+{
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
+		return;
+
+	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+		section_set_compound_order(__nr_to_section(section_nr + i), order);
+}
+
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return section_compound_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline void section_set_compound_order(struct mem_section *section,
+					      unsigned int order)
+{
+}
+
+static inline void section_set_compound_order_range(unsigned long pfn,
+		unsigned long nr_pages, unsigned int order)
+{
+}
+
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif /* CONFIG_VMEMMAP_OPTIMIZATION */
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_compound_order(pfn);
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
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
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
index fd00141b089a..2003439ea13c 100644
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
index 5ddf06b83c96..a27f46fffb54 100644
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
diff --git a/mm/sparse.h b/mm/sparse.h
index 8f6ef0b50b4f..a5111087ee3a 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -9,80 +9,7 @@
 #define __MM_SPARSE_H
 
 #include <linux/mmzone.h>
-
-#ifdef CONFIG_VMEMMAP_OPTIMIZATION
-static inline unsigned int section_compound_order(const struct mem_section *section)
-{
-	return section->compound_page_order;
-}
-
-static inline void section_set_compound_order(struct mem_section *section,
-					      unsigned int order)
-{
-	VM_WARN_ON(section_compound_order(section) && order &&
-		   section_compound_order(section) != order);
-	section->compound_page_order = order;
-}
-
-static inline void section_set_compound_order_range(unsigned long pfn,
-		unsigned long nr_pages, unsigned int order)
-{
-	unsigned long section_nr = pfn_to_section_nr(pfn);
-
-	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
-		return;
-
-	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
-		section_set_compound_order(__nr_to_section(section_nr + i), order);
-}
-
-static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
-{
-	return section_compound_order(__pfn_to_section(pfn));
-}
-#else
-static inline unsigned int section_compound_order(const struct mem_section *section)
-{
-	return 0;
-}
-
-static inline void section_set_compound_order(struct mem_section *section,
-					      unsigned int order)
-{
-}
-
-static inline void section_set_compound_order_range(unsigned long pfn,
-		unsigned long nr_pages, unsigned int order)
-{
-}
-
-static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
-{
-	return 0;
-}
-#endif
-
-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
-{
-	const unsigned int order = pfn_to_section_compound_order(pfn);
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
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
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
@@ -142,7 +69,6 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


