Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77787CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E9A6B00A2; Wed, 30 Sep 2026 10:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776266B00A4; Wed, 30 Sep 2026 10:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CAA6B00A5; Wed, 30 Sep 2026 10:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC306B00A2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A067412081A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:27 +0000 (UTC)
X-FDA: 85270608654.03.6022362
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id D701F1C000C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="BF2/rPa6";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hsh/ZoG8vVNv7jaAJJiYEU6YoSTVYkNqliPjJdqTXgY=;
	b=hFv0gG4qBAUseOEhjg2DQx2hc/Mpc7LcTmCYj6jvqLUXGSOFWAWgcj+owNbfT6Wnz/4juV
	oFo+kWyIwEfonNl6hnlu9hAnRZtOWXjJy88KbPY8+rwz0L5S8T5oy89GNBBOeMH5QWgksO
	5KxjGqLJd4TDRWzUjWQWbu0zZATg10k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="BF2/rPa6";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777305;
	b=aDcQel4rDgYxU2LYYbb4UhJKRxrVDJmFV/tMqJ8g1eOuwpOK/bDlXTB8BN9mVEBUu6McqZ
	K5bYXspFA1aRiEkU6ljdVRvG3y+YdIP3fky6itWmJ67EY17oOMnO8JN3Kgh/pUlkvovi7i
	Q/Bewo9nEvKNzmXHvqJRjBs3pR17Vyo=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccdaea75so1943215a91.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777305; x=1791382105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hsh/ZoG8vVNv7jaAJJiYEU6YoSTVYkNqliPjJdqTXgY=;
        b=BF2/rPa6L4YFMhmMQsmPSlLzINXhthNgWhDaK+0+5wLxzUB1dTKe6H7JdTPejUJ/3q
         R+u24QKR2a16fQ1N2CVoF4Mw3KqsKznmCr6CQ4Hf+HbmQJXnerAsvjP+tJ75S70jFdLC
         H8uMx1+eT6LR6zt0pyOntv+nHG3J198+lT2b12rDNwHkoZqea1w4CEiIHYd/Xpc5HyZ+
         FVpqlbwEiEnlRQbCcq+n1bEigyF3g7yIryjHQw3aB3h9yarGkxi2qRrqPLcSNT4O/B2P
         iE89UJVKF/GakANBXK1EpyhRHaVmz7y4ZIqz7+Td9GjjuaE5SSQYcaZmFivEosZvY8p/
         sKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777305; x=1791382105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hsh/ZoG8vVNv7jaAJJiYEU6YoSTVYkNqliPjJdqTXgY=;
        b=lXnXRxjWPl8lK4BaDf3W4Sysv9KIsPlgc1NcMjMXWg2cPbkgkaxZgeImMPH3WdqrjY
         yuCCzsfQCupq4jpTHeXY8yFM1m0MFO1BwwqAZd4xsJpc3D4vk0X0vZ+/ULnYmKR2PT86
         DJ7QphI+4EahX7BNjfhdhQ5d49E5mlOYKa19slqT8KvLwGOyFEg1DXPs2g1c3M2dFYeY
         sT7ZtEneUjYDqDHUaF6xtDVeTpr4ogkpbAAuOqiGBiYOkOlqTz6swLWhoo1VGDcXKXL+
         1Rwcikm1sYkKwhrNrauKBBIEW7AqWG0CRhEtlqWDByNYSn6WTvqoZHrxNyI8mJP6ox+M
         iViQ==
X-Gm-Message-State: AFq9FYKjPS23F/8SjdZBP5NBdme08Bxnv+/jShMgTkzVtmh3RzpvzsBc
	a26sBnchabLiYC5MYdxugh0cQvX1gPFn3CPdwrWUCq/8nDQrZvqtEs24L/QiYLnc214=
X-Gm-Gg: AYBFou0WjEatXtwR2Uicqj2NR2j3yK0vaRg4UPCI/3fr4jYqD3evSESCyVx3Lhioawy
	30LlAiiEKa0P/TnDUQFezQhGBSE78tmVkvkDNzPqk6hsBZeaGuxOh6qn6OHRS9FpZtvPf6+PDq2
	ABrMFe9c2W2JTWpYMke09ojShOPQ5NMjwVxao14l1VvwMSy2EVazpbTbLlLKD4bGQfrNsc7IQa0
	fPEwMwAuQK60sd2lJC6+3pKiMe9XI9uw9To7Y9VtSvHKIieKSBMGJOs2nrugkxEavc/ezAFiBwN
	KHtEElq2PDSGo8NxITAxjtFGOvr+nYl1w9PT7U9+tnmoQVoIczyMSPC1hZPwMj2cYQFosA8YEHT
	x5xl6xEWT+ckmM6HpuWEnsnGWDAlULFvSeUWf4RdEr6D0hkEAHJxciWEXdmKO5FDRQQyx+QK4V/
	ZJ4ExWaP32dtbbT2KiWefLa5LDgB9EfkzF26ePsQq6FHsfaors6BjHKSK3HG3FOb/gdEImyIk3T
	k2tTdiD+cmS2g==
X-Received: by 2002:a17:90b:3ec7:b0:39b:5622:d645 with SMTP id 98e67ed59e1d1-3a4d164f196mr919901a91.0.1790777304200;
        Wed, 30 Sep 2026 07:08:24 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.08.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:23 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 08/12] mm/sparse-vmemmap: move vmemmap optimization helpers to a public header
Date: Wed, 30 Sep 2026 22:06:23 +0800
Message-ID: <20260930140627.57431-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wg4mfonf8mribw55xhn3fixwx7rnfsux
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D701F1C000C
X-HE-Tag: 1790777305-142449
X-HE-Meta: U2FsdGVkX1+erbSesXoOHbHWBtQ0KmYHPs5zvwjsUbiVVbj//5hUc3kicjtNfSfRqiCbLdFUKqjVxDtZUqkvawjrfkxDCF90lBKg9lgYPErRU1waRF5/KzoEZVR3pBAXwPCus+/LG17QDuVXTBo+qSDozsQOxmlbDAHwXBfGul4woGBjtPvwx1edIeTyOadhvUVigkKvJakOqTLj2v+R10zQo3tF75Ndf5IlBYfFM9SR9H9CjYEL5qObQWdJmGv7V674lYPsv496FFX+aqfx4gynixxXF6Du6XilGNI/tifCCJgwCsDKD59UkHsM9cCtwRhMqJ+YC6COiDk6VMfqOkm68aSTX60QUIjfWtzRy2N6I5lk5xCldMPshXaHfb4QPBneBpTYUx1QvR+keVQlJ/MN3N06TmqvpRSoEikmcVILCm5fEQSxvgWdSAURFg2oTpMHScphKTXGZOanHgixDFZHa7vXAiDmboBW6uOmPkE8j68j7oNRGJTIvIVgy4fpChUkwHI0qBF/O9JBgJRYmI/kKA/l9rraGPUZPawDtErFlj3C9biwrUiZ5kGZxOsvTCEfe/p9D6TWBmh+iOrwxtyN265aURjzwFooHHUZV5x4TuznpPBWjzZLk+m5gJB+p7mntSkhhCNZzvfN13oJjp7QJvdeuFQKG1/TrExtHKGY0SbYcGNT5F7ctYYvIN76bjdyIv+BX49NaZ0IzqRbspaONMx1QiZvoEZgBhd2SM8VsPoH3yavrIEUOcrg6b8tLxaFZKlsKakreD1XWmVvTStfRYvjjE52LiQ5bIkIKD4b+NFZRyCfUFAMPg7/WB+KxELLA/VJ3F3ZU/sKWJyUDSxw8j/pacfRj6KwEJuF8ypxWVW7leDSg/dQmmMTOXewnhmZ+zK11Q1oroXJzQdPH4OyYZkB9oHrXcioXq+vZDCc8JZzBhXT2hy5iS71rGhcOq9pJn7Kh7fhS8gyEPs
 PY71WKKZ
 bMYui1ZzY6Y9r/YmC6HrMABOsk9vjBeRSakZcCvPOR7TpeHax6t3IwDmvSeBSIteYZOY5hbAX27fAraa0SgllVM4grw8AAcOu3Lkl90bBtpoMQp7k90DWMrj+Vpr398fHBrvCmnyN6nKc47zX5W/xTR0hozfGhKe5Pyce12AB2teetcJxXF3FMQf+H6MlNUHYMY7k2w+6bpdUnRR1CSYlHPPmq8X3ai+u9VjTSTKyF3IE8V3IczyB3VBjitAWnpDWgGPh438kD0IirBUrEMEemKuFsL+WdCuo/hOzN0hDNUyeKO7oj6zv9KSFulPyTOjwX3AU48naAd32ZKGkQsxg+ALTnqYpglIcXTnYcyEI08Y/d8lh7bjeeGfDYvGsPt4kMCrMGKaN+mP7Y3D2LkolbAohhyANYhdTWo4M
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

Move the declarations and inline helpers to vmemmap-optimization.h.
This is a preparatory change for powerpc, which has its own vmemmap
optimization implementation and needs to use the common vmemmap
optimization interfaces from architecture code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

v5:
- Move the VMEMMAP_OPTIMIZATION_* macros and MAX_FOLIO_VMEMMAP_ALIGN to
  vmemmap-optimization.h

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
 MAINTAINERS                          |   1 +
 arch/loongarch/include/asm/pgtable.h |   1 +
 arch/riscv/mm/init.c                 |   1 +
 include/linux/mmzone.h               |  17 -----
 include/linux/vmemmap-optimization.h | 109 +++++++++++++++++++++++++++
 mm/hugetlb.c                         |   2 +-
 mm/hugetlb_vmemmap.c                 |   2 +-
 mm/sparse.h                          |  78 +------------------
 8 files changed, 115 insertions(+), 96 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fe1d70ed5100..4689a0210060 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12097,6 +12097,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
+F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index cf29a4c8ac59..f87603135131 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -72,6 +72,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/mmzone.h>
+#include <linux/vmemmap-optimization.h>
 #include <asm/fixmap.h>
 #include <asm/sparsemem.h>
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fb37b0b67efe..857f9a55039c 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/hugetlb.h>
 #include <linux/kfence.h>
 #include <linux/execmem.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/alternative.h>
 #include <asm/fixmap.h>
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index cd68c1904c91..65de3bb13eb3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -96,23 +96,6 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
-/*
- * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
- * be naturally aligned with regard to the folio size.
- *
- * HVO which is only active if the size of struct page is a power of 2.
- */
-#define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
-	 is_power_of_2(sizeof(struct page)) ?			\
-	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
-
-/* The number of retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
-#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
-
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
new file mode 100644
index 000000000000..bd0974b262a4
--- /dev/null
+++ b/include/linux/vmemmap-optimization.h
@@ -0,0 +1,109 @@
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
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
+	 is_power_of_2(sizeof(struct page)) ?			\
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
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
+
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
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
index 76765c97ff68..0057fa2a16a8 100644
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
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
diff --git a/mm/sparse.h b/mm/sparse.h
index 326ad43bb5c3..a5111087ee3a 100644
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
@@ -142,9 +69,6 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#ifdef CONFIG_VMEMMAP_OPTIMIZATION
-struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
-#endif
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


