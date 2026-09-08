Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90ACDC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA336B00BB; Mon,  7 Sep 2026 23:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943D86B00BC; Mon,  7 Sep 2026 23:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C446B00BD; Mon,  7 Sep 2026 23:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50C646B00BB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DACE81402D2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:33 +0000 (UTC)
X-FDA: 85189102026.01.E6DFB67
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 14A4E4000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V78otlVx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVT6j1P3zfNYXYnEjgM8kLQiWtuO+wz13pOr0ZtKdew=;
	b=moMLXaKAzi2VM4+Gpj/ee/sdE/cDlWj18KsWFApWjb++utdVpJm+9tMsinDOr04YvT2k9u
	psiBpekCIuS/WPG8UmDAYU6TuK4djPCTF8cn1Zgb9mytFXFeqiowVGVDPIliW2gVFNJbeB
	g/IPRS1LzX8tz+AObarf2yIzBzYggVI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V78otlVx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836672;
	b=SUfRk5dky4TUCEuP5qm4u9ZPfcWPzjl9JHW+SvjUtTtX9nJQkoaCT9I49y/P8MeeQfDKrR
	24K30L0NsxSMPXwrYtcmLQ+r23zpjlvWbNy0i+SUb3f51KuKorXd0V+DhrFGGkTV94/yZR
	/mRUwOd1IMP7ZdfG7vAJtGYY2r5uQ9E=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc1c3c90074so3401390a12.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836671; x=1789441471; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CVT6j1P3zfNYXYnEjgM8kLQiWtuO+wz13pOr0ZtKdew=;
        b=V78otlVxmwIN744Qu0RQY+gzMEjle2LIM+gJSfiI+sGe2vpJSvEFuAeINSk6/TVPRF
         askcuQORkHqiAgNLmhSAgtKVqI1zBck8NpH9Z3hlV4UfM/ZfvVlV98peQCjx12yn3ObB
         xBNQ/i694RLrNkgEyMBZBNl05EUV2QZmU7c8ZrJgUO4Smk4D1B8/x3qZ6/HkOQWbLLy0
         cLwTO1SRE4+IrZblKSZ00KWYyIapi/l30/zXNSLqnQPgnIoY0kgiAvxZ+tmhG14hWoug
         dRkG18tQeUHLBCEJ4p4zZKPB0Y79ePHJVw9zw5n9J0KPqtisbcrH7czXSDANz0qdC4j7
         Kv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836671; x=1789441471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CVT6j1P3zfNYXYnEjgM8kLQiWtuO+wz13pOr0ZtKdew=;
        b=UniB0h63gpDxa3Wf6cfOdKHF7BeEd4HRYY3UgmRv7Cz8xhuU4FRvmvFxtmk3ZyxU4v
         6KlWHgWR6kTWhM+IkzJ8tzMRnJsSkaNUGKWdH2p+ORsTo/febxSyKmAFSU9EPpp/jNjW
         Sr8GNTEC5lhZxa0PX1K3Bx55DfXBTrzb1Ek8jjF9D7yZwaWcsdIeXYZBx1MPwNuaY+2B
         Ct+rJG1d84IhfB1MGzA71mxS2nPS9m5+VrRX4JyNVtMwUVa7grdafvcqZ3EgEeHL7Gdk
         /XXbgJIQdmOzVf4tIBbN3j+b/qPDowMlMwbSHtZ/z36Cab+imM7vYyHSObUQPwuqmVOu
         COnQ==
X-Gm-Message-State: AFuF++l9LxroWFTzjmTWpkqB3dkbkhPczDVG7UVdEsbnhWNb3dAdZN9i
	pUpOFu/ljo4uu2j3nUAjwJUkaXLQZ/9fEyFhlFtIqLaZqAQp4+tU3H13b32BRGNNVuQ=
X-Gm-Gg: AYBFou3o454lCPrTeWADJwyvf082F25olOWveDutAK9ddoc7eKku5TwTzKX9eH0r2y8
	kN5s4Y/KeKxukI/DglXa542wJOiLINWJmZZMtfmADicPAGT7CGLMP6tl0+pX9iXsagHClPYHhK3
	m1b0YU7SWSV4kYdXIXWvJOuDKZyytSxdN2fO6JgrHHCdjmNb7jFFhpXxLysLPGCa4Vi1cEBOpRD
	iuyPZQMC/jjNnHXAvztq2gXDgSE1vlpfO1eUhf3/d1m6KkZpryGrm8fzOXU1GCgZhEm1ot3cC/B
	aOVFGLy+b0QwVFCabxKDzAraBVg87qnBpvC+V+7cIa54W3HEbmLFIFCzBEYgMgj9KlWGVeyhsdw
	ZgVETVOgbOIT1q/e74UYCP25jvxsrIwfwXncRdksnQFPBH7i2VZ8tJy2OXZ3h8/htH9s42yn0b1
	DO1pDuIfLxo0MzygjvHikr5vPeEfDFNJ06A2hAgOm3YEQrKDk3cesD8GJQaK+cVCwipxuPt9Xvn
	3IOejr87zhNIfip8/OcQ4st
X-Received: by 2002:a05:6a00:8c3:b0:856:30dd:91ba with SMTP id d2e1a72fcca58-86168e8bb34mr33801118b3a.2.1788836670753;
        Mon, 07 Sep 2026 20:04:30 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:30 -0700 (PDT)
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
Subject: [PATCH v2 07/11] mm/sparse-vmemmap: move HVO helpers to a public header
Date: Tue,  8 Sep 2026 11:03:31 +0800
Message-ID: <20260908030335.96549-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pm86uqis7gtsexok9eu4yo7y4zkesimw
X-Rspamd-Queue-Id: 14A4E4000C
X-HE-Tag: 1788836671-936532
X-HE-Meta: U2FsdGVkX1/0+ljfryl20QOb9v7LD0yCpmQQzNl7wV4nHepzmb6fX/rcrlgPEvubUgl2VfO9L+TZpwZi7FzjVQli/xMn+I4NiokT0+13eUCTyzlyUQG+uiz3Hi3L0QwR3OF4uz/B+Yra3uvQGihZ1YK/5yA76qW5+1sCTAUjBZg6KSFzhaD/c0ydHCK4c198SVoMtgCNEhE43Ns6UgrM+T1ECacWcqHx6xQyyi8Gr5Uvq0GeGmCYul8nhnNEIsC6VxI1m1bQbn0DAKEAMrc2J2UyizHCSYdtwmMFvxaBfXaqSNCQn/sreBoVPoo+n6rsBXTD0GT9guS+starlipG47paBhN7jM9z87a1Pwr/78sDw32xeHFZ+Czsmh/FtJGslZR3A63mEOtPVDhbvzzYTgtvEHe7spjO8dnitlqc7aNI0ysMMYNdpg5kYxCSFgsApCsEwfdRoieObl5oX6XYPmydAhD+dBQ3D2zSokFKDOj3NYP6tXKV3GE4qpkjC1vNZUwZ+EqPf0gxSqVzt3K9LTSMmIXoh5orLDLVktntY0FoJE3WyRYjgVHBlGIBZ4SBn3AACGxjYXRZeKB4Pqyg+pz++xlWX5tS+L3Xut53nyjk4u6IU0BruMN3O4aM/KUOJZxEecfXez3+3MXvFGePT8q2yiIloDh/Y3cUR/05fhgqyTA+XjSxWVMmDLh7kfCCa+ymTkl4E0mYhiJkNfY8/Xo6gJBM1sGe4+J8VmvfxvpKkUjrAFaspCniW0GeuCd3T1IyPtPYSS2YBGQ4Guvio3TRgXtdu/ze40o/0skrFVKnYa2x7MI2fQlXoZoVa5o/OZtxMmO51yubxXZy82lYFapKJUjBVCHVz9xyu5ygBW4sb8u1iSKg6aTVkckdWmOUGK41smDkZD5LCz1eoIAAcrW5EnNjVCazSUl1nPSahkUyzPF8Jr8dpjYhb/MCnyYjLjT6+QPrcVi8NCQqPAL
 M1bgexBq
 kgO6SZjlDtcrvNye2AdvAuTaX/AACdDZxAyZHNHKIccrBLKMkbEtTY/6WXvJT2Q4f3x9vn12Nb+4TKHVuK7Vaf+v08dTEYLhtboOZEh9Rsj0DY+DTKlzqqcTfEywhQt99n6F6ACmWp7oXas+vO61uvLKhTMpvfu4mZpLsS3wRPfwCE9QwQ6zyP1vB5FKDjVY35N5VY5sgyCH1wSF1RO0j2EurRU2qvRSjJ1R0E1iHrzAhezAKOxSg/9Vv2dRMM/aQDmO/pHfq7gncomkOdXh7ccsqxfNBMbsucoRKLW5wyqsu+1OZynkzw+kITw==
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
v2:
- Fix missing header dependencies.
---
 MAINTAINERS                          |  1 +
 include/linux/vmemmap-optimization.h | 91 ++++++++++++++++++++++++++++
 mm/hugetlb.c                         |  2 +-
 mm/hugetlb_vmemmap.c                 |  2 +-
 mm/memory_hotplug.c                  |  1 +
 mm/sparse.h                          | 73 +---------------------
 6 files changed, 96 insertions(+), 74 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c7aaa2e4790e..2985286cbbbf 100644
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
index 000000000000..492dc662aae7
--- /dev/null
+++ b/include/linux/vmemmap-optimization.h
@@ -0,0 +1,91 @@
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
index fda525bccf50..dff915e6c48b 100644
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
index 0db0379826df..d7a59167bec4 100644
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


