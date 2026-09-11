Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793FDC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9026B009D; Fri, 11 Sep 2026 01:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680256B009E; Fri, 11 Sep 2026 01:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522576B009F; Fri, 11 Sep 2026 01:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10C3B6B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F2071C2A84
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:04 +0000 (UTC)
X-FDA: 85200289608.17.D4F7BE4
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67422140009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LJ1v58W8;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9h5irsdiFbTSRTtgQf8+DpZjFaqFHIv3CtCmLZFKqxE=;
	b=q0bM18BQ9BJmHJhx+eRGoZGvjgESlNIE6w+uKTxEafN7k5WfZrbsViunH1Z2cmoSV+sM7U
	o0j2c9LASTxB0djruLdJumg06pYx2YcDATQzpNBT3gW6q6lrbjMOHmkVTfat1kTBtzrd8f
	+7XNLvJMacjxto39CPnWhd3+UiN9cbU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103042;
	b=suVdPu7Emxp6pOa98CKR3Ob7ssibC0deOA03V1T30jmh4CQO/v9ld2hN+cgZ7mT8KGUxGI
	BuByyhtvBwP0XIHyDYD5EgaRcQZIobBIx9are/jfNb1v7Mlikue9OOKPhZq2fu36Z495kR
	EusONsLnY3fNA2m6KShLOjhGTJNa93M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LJ1v58W8;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso622915a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103041; x=1789707841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9h5irsdiFbTSRTtgQf8+DpZjFaqFHIv3CtCmLZFKqxE=;
        b=LJ1v58W82/wSKAhBLS5UKYo0PFKa0HtdXTdZSKabg560zEBkbNqcTMonEDSPZ5r0Kq
         /3GZcVKeWRFIHqL2WsuW2XadDdmhz9QO2Bt9Qq4U5RrS78Nluqcmj2tCRW1oeUt6UpWj
         lYQgAo9uUvBdDfZvXHL1o0SY88mYSsAxqEr5rmg6F/0ku+M7dUtkCn7zBqhx3FYwC9ae
         rNPrLC9hBZYYyi6uRH2cMfeAyMrM9DJn9HsZFjvptGuu9CX4XXytVGzusRrQcUXA5RHV
         9/Dh9CKJqxV3N2uPC70PdPrlNW3VUnxb2H0BEFgZhDld8dj2lO2oiTpOMZlDZIsRFqkW
         rTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103041; x=1789707841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9h5irsdiFbTSRTtgQf8+DpZjFaqFHIv3CtCmLZFKqxE=;
        b=AXqUBVbAgOMmCTOuY/wV/dzOuR9l3LyPZsxSC+fnMbFWqvJIY/o0l05pLO+MeNXLon
         d/KaJEP8U/JwBM/CDHlKDwsPy9E62po+3VHfgFJo9Q3BmNXFqo7tr7XBXvSuKwmeu08B
         b1KwNiwDAFJJc6VRz/o+jYWlzDlGP4ThSuYFK/QZXdPWoddgKCjQRPI0iWgVClyApkr/
         rrT7n7ivp30/6ADVCNUdexXk3cD/l8AFLSiq0AYBwPyjrpAVKmTJZNbe+BZHm6HfcnEw
         nawTn5Wlci6UiruPyRAFC9SwWOCgk+kjw+xVmvsH4qlbN8ol9pipd7CkiItbkwUszukG
         Y6Bg==
X-Gm-Message-State: AFuF++kuaEndzHK4PSUAKY4TfWHzzimUNrxbhIihL27ojAb5vUACjKYP
	al5QK1cV3pwSUnCNXqs6a4DNXGQFrN5074zQ56evYgAhGwS/iaX5A1kCGy35w36EKDQ=
X-Gm-Gg: AYBFou2kt2U+xmwKWZ8p1jIzbq+4MH32olsV38+jHvukjqOjjTFQoXHJSW5eDNwq10n
	uGqZTc6ND4KT76/yh6it4LlbKVgrC5FVCaOfkB5dkyFVwT0i/mYdhStYeQW80QZn2loovxelT0A
	OpKITEp5v1TSu/X6JO1BWjcERoqPjTGcr4tN0+esreoLWWRT/mV1Tf8jYpl/ciOCxjLsL8JdZqH
	sJs+4N5NJF9C9o+XYd6fltiOBxKoUFdsC98NK5lmeXyOAXDgCB95JJxdFDj/BpFM+1pqyL3ii4e
	bpdDP8u/+/DrGzskK7P6Rz74HFY6Q2BqwiFwpcCiUXzlvJlcj3Kft5hr+XoEB4LDc+4O38X2osY
	WrhWU8ar1q+sg+iGA8BMaA2KCub/aKinYZW2Bwx+wGoP/4fm2FXkhqe6qKvASsdefWggcOSpvz3
	8Lp6RXocXRO6Y/tmCHC7c0Zqa1UOxtc5bJXK7UMqAUV0oKYOysN4Wd9DBsv9LE6x5qCLhRKB+aw
	8Zx3g6VwGCy3nCUmvVvvzGN7bAj6ns3fim9M8fLv7gmMcM=
X-Received: by 2002:a17:90b:1648:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-39d9bec50b9mr3746365a91.10.1789103041109;
        Thu, 10 Sep 2026 22:04:01 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:04:00 -0700 (PDT)
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
Subject: [PATCH v3 07/11] mm/sparse-vmemmap: move vmemmap optimization helpers to a public header
Date: Fri, 11 Sep 2026 13:02:24 +0800
Message-ID: <20260911050228.58884-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67422140009
X-Stat-Signature: tki1gh7jdsc9ps9d3tznpfho6jfopdqw
X-Rspam-User: 
X-HE-Tag: 1789103042-54864
X-HE-Meta: U2FsdGVkX19Gue3u/Q2CW8IrAZCRr6hSqX0vfpRfUal63utsjLprGtJGoUHrn91Dl13wcc+fjDjLWyx1PFy4FiZqKsdbRDLMqVbGPuMH5lslzhkLtlvGqE7odAhUDIIck37Arw6zvmh3RWGpVFH/Us+VpTCmHmuyB4DizQrhRgfjA6/SsQvtiNvBLCLBp2nZLQbdlSDnJ2Jl/Hk2xXoK90H7uLgVkGr2U7uvGNaDY8acou3pn0uBcVEBRIWU6Fodl/B8W7vWkVJ8/y+S76r67ccR6Jv0DK0mq/5xZZz3lYSsTInKrwwzyNU3ZofOK+N0YVu8qJflJzmDbUBTY08PLQZowqD9jo0C6LqX9O+3Kl5RlmhW7WiGFRC/ccSTwdPAc4gzk7XJ5qisK+xUeToJ6sjRJWB82DOoDgSUZoHhluj+DbtQmFC7BCYDMVNS0m9YF9VwuA4EqQefYl6uvV0lrNgBONy7G+Yh/Ig15/XZDTkVLm6YRonqeWYcMzd8Re5lYg7SAveKqlWL8VlwfDG7tIU5Ia9QY6+O4tatqA1Awyz54U37RpQpNN0XkFQbBdIFXnvUWWjYkEjJ4cUTdjSVj/AyXHmwTpmpXxE/ZQihDRqMmHHQ5uV3m2UKe5PbWS2lx1FXIOd6rO4lrx3VYfptbu3A6Y3gDSLj8tRDbM2BG4sO0fP/KBlzvysM4UQoybpbg/QL4f9c0lljijaNUux1q4et93aVmJyDedxLEOgB51JToqXIPyi7djEF8ijrh124dNK9I5suLN3jWbg3Yi7AohjFafo+2Di16Gt7sREnextUNowl/jAnI7UvRNgz59rBucSUzur/d4lDpXJX9GHBBi+b7eYAAHkgS1NU0SnGiSiUZ8sMrcKSa1NxU/lF9TCyLVK/OhZRQYNxRWmQdHVPupJmcdatLKY5X+qd3Zyt9ceDw6HltKzpWlgzbVUVYo03TGyYACSJJZd9IKyiqp7
 3HSpVgvp
 6zwVA7GWI9E9hVYugUaM/clj99HQ3JvmRyaRcEfZP0M1/N3dg6GhoWuQybCPQdM7WLATn9SK1Yu19xAs91jJ+5aqdf3aUP/7LIeJWJyJAzlpetvheTOYkwOAwQPB2nOR7vk65qYUXHP2I/W92Y43mkMCpTz/s76DDkRLrSLwypekN57IUwQulKoyMSfnp9Oqj3dAKFeoLZpvtk/eRorUAq2eZqdMNx2wuCNltHKIRHPWdCBbFnHAmwv8CDVeHgOGq8gygK6kGkuACC0jOF9bZs6mLP6z/qT8muaKf6uix/XmL2JqOqHy9qARe0A==
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
---
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
index 000000000000..2327929467f3
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
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
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
+#endif /* CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION */
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
index 0d101ef934fc..7af55e1544e9 100644
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
index a250bea4088e..a5111087ee3a 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -9,80 +9,7 @@
 #define __MM_SPARSE_H
 
 #include <linux/mmzone.h>
-
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
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


