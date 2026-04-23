Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E7DF99340
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A306B0093; Thu, 23 Apr 2026 03:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D39F6B0095; Thu, 23 Apr 2026 03:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B7B6B0096; Thu, 23 Apr 2026 03:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 063C36B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72E031C022F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:40 +0000 (UTC)
X-FDA: 84688970520.24.73CE338
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 90B1240003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eyeoHHnf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928778; a=rsa-sha256;
	cv=none;
	b=2gUqkndgMwRVMWiWez8sjWJP1ERfNp/zCW4JuFgZG0Hf7yLL7bxpIQ+qYVBe06JLZRDUXx
	BIMB3fdwjIPgXFQPYj7yq3Ia5j2EINvVjZRwSBTxEYd6HWwFK43a9gZGfPRbyELqS5HFYf
	QnQeoU6bj4ONHDkn4D5w48rrEwrrOkQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eyeoHHnf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tVvEy0n8Q8boUwkyPz7NIWKrGY6MN5PZ12u/TRimec=;
	b=FzIWZEx0HdRfzlkJCAMZL3AHKGpB9b3299hnoojw5ZyipRjoRceps2UVr1xdg1GkpVpKuC
	XbzyLhYl6Vbam2i3nLZwPDw+cFvImbjDfHbjpTLYvlpCzn+bjwRMIzVZsT971KhQfpTxQC
	NOwDiivL2iUAV/G2WgCnEyW/evXb/k8=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so4049093a91.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928777; x=1777533577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tVvEy0n8Q8boUwkyPz7NIWKrGY6MN5PZ12u/TRimec=;
        b=eyeoHHnf372mDJpk4kiRePMY/vAx19stpAahi206A1fSX8RCy6emMoolwvQ6lZXXAr
         z+R6nUhWlUKQNlyGT1OcGxmTlK9EZC0EvLyFW05ysSil4FqF0TNpw4kGmkM0ccDCXX54
         RWey/mSNeMwwbVJeEm8rqY2ufIsR6DWzVQBo8qDPHOz3Rs4hdVg95hicnYfZEya1g4a3
         Mwom+rdfq8xobYnaQyejLxAhEVdXJv3f3hveWqkWeKbtwhLF0PxZLqeFgTPqQjN0vED5
         DCMjN/s3cL9lforcLDMkOWB5VJjwhbq9dj+o1NowhIswjlYGXcCast7SY2o+kOqZv7E/
         JfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928777; x=1777533577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4tVvEy0n8Q8boUwkyPz7NIWKrGY6MN5PZ12u/TRimec=;
        b=Rp9ct/uKYgqxS7g427iB2/RVVgKV1Yuiwx2Gy+XMMMlnW6LdIOx9U5PJ4KLmgXWHqB
         e7QuNV/dcJ2PSdhNe8QcXPjD3i0HO+HTTSuNqBhp36PfyqHUbsBMREZiyuWQtI7vHmhd
         tBhEHlVUq40KYpXfFSUByMXTn6v3iMLL+iTy+mOXP03MH947n9LagojOCpG4vsWHHxPD
         zY+2UbyUjnbPWMoh7ZjfBTtRXVm/X10LtjFqBKL+IWM5JEHztkseE6jGM8MkwpKOJvoA
         WqqSdFtMdDfejrWUH6+4daNMd4uHloyMHU34hEVLrBmM1vCbl6apB6+yxW5I//BdBm91
         o0Dw==
X-Forwarded-Encrypted: i=1; AFNElJ+OvsYkWxE5Tw0Xj4XCcqvy+noq9YWPnYPqg1VQ/HUbxnGoH9RNObUrDBhgxrYcoSOsjZFd+JhL2g==@kvack.org
X-Gm-Message-State: AOJu0YzAgcKc7qdxaVVb7Km69XB+J2AEHciXuPosnhEqwm1ZPwaZJWWE
	3mYYxhot542T/wGVem9mRugHKX4x7KjNox/2q7YKteUgMGiuhK75fadEYGpcg7Escto=
X-Gm-Gg: AeBDiesyLsDcfXI3oFdQSYkFHac3EPadE54WdVBa4UJNmjVk6JgciJIPNBFERUCn6iO
	29H1yiiUA2wjUSJIcZkrUuVz2MU0G3OAaJaqYPif1/5GKz/VhUxu7sO4OkQfIBbchz9r/o+21qe
	8LDFJo8itS+tkrV89GPS4DBNuP6A1nP5/Nn/Fb+hv/xoHin64k2RIqiKAgZo62Yub4FwQk00iDt
	OXEd1p6q/Nx6Z8w/MB4+chXxJD1t7bLHVyLklh8/LDnWxLg43QK89VUGInHf+VfN/N2KfXByMNh
	4c7RWcZiV9sQSOcKEMwI2VGwZ5XxZTS/R4zu/bcJzAlKGnhmnb9jAFUQxdfYgzDF9AX7TNt8SMX
	2dNtfVjhlZFuk1q0c40Bf0urljmT6zEaoreTd+A/vmF43UzKwvfpy9l7vTKwel2UwYb8iZuKn9W
	2Qk9moc/bRGO4tlevMscveLMmn5pn2jcmDWX0QopSd6VGh+F/FrFwfZ/P1EeP0EOH7
X-Received: by 2002:a17:90b:270a:b0:35d:a8d9:3b4 with SMTP id 98e67ed59e1d1-361403c35b5mr25387912a91.4.1776928777199;
        Thu, 23 Apr 2026 00:19:37 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:36 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 v5 3/6] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Thu, 23 Apr 2026 15:19:08 +0800
Message-Id: <20260423071911.1962859-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260423071911.1962859-1-songmuchun@bytedance.com>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: k5u1yfqy9gijbrebdpys9pwuntmjwnpg
X-Rspam-User: 
X-Rspamd-Queue-Id: 90B1240003
X-HE-Tag: 1776928778-685952
X-HE-Meta: U2FsdGVkX18DRKI2YXAayAl0HIUoie4foSsa6XmdC9jpFpaL+v9QUxi+Az0+65O8opnnWhp2y2j0Sc7+vd91FgBBiENTLWjeKaPpnym9pohWOAwZarUQBMM/sm2ir/Do2jENBL/OrIybdL8iUMHSZF+mDe1QEOVw1d+6nai8/cRrcsxMBM4IzHK/flxcnqtQMbyt2oM/pxD6XaCQlKn/n7ibi8Y0L7bqDy09wXpmuoUS72LkDXsv2URnHt66LclxFwRKC58JCQVwLq3lFn7EE5oahhHc3bgJI4Zgo00ShfjjKhwx5G6smUZTk3sVQ8qrEf+o+92Us7KbhtfdKf5SYEN1wbYhXH5G5UzJFI2ZXCEubUBRpWrhTehFFXiDA2QKdozTChbBoimjcIulFLpKXnnrSOuyqg2PAfO10PhN/eHddQtwROOrxYnyPxhXHlzXGfey7dUpMyhq/qYiLXlLVJQSzBhV1kJ8piT7xQgTXqTb1vmHrHZ0bghl60kLEjlmNyQjgTSgey37fM+indnxL8WybwRdOPMBzsUBuVZBOHZWJgqN/UvtkFsO8YIylMBrHu1BW6dSB3iXrIA2SEeii8csofFpkSEWImljfUGXBOeEc1RwiiIUUd23CZJayYfSQHmFoYe8BZanYH/BuyjJaEc9/A4J/dOmdmnz4qxjIO41+ypBk/+xmIbmLx9gDIFztL1DolC7gk5ZdVeGZFliNIpz2fD7i8TgR+nq2bwMYNCCrdJBxfU8sdTarafVsca5iVBw3ErztrHNGe55WMBWx1ZGtwE3o+f6A6dKZgL6hF09c4LE+q2BIkg/JmiiJ+aghR6wUrgUNJnJYT7HGQ7zL2ucNCZCcXeMp25TbHJ27zJfx4/2vqhKKeXiJU0ApcaoyPCETfr7WnT8pFcFhRXsadkH2ik0MMD5m8EbavZt3kpkfhczDv1IVNp0x9h20cO4zbIQzSZPPhzV3CvUpWk
 JJOIYefg
 Up/7sNzlrLhv07hwOSdfPur6FS1NjJJdhsgBuV5AGs22PQ8arJQ1f5IejP8tg1KrBTftBNno5Ry31VECh04l/1CLL2xK05aCRdSuz7Ljk6/naRu/yhNM7Dbpej96fbhkWTmUDsyl/+ibxmDImYzIw7GY3h6uQR2/7aBCQbrTR4wu0Fy+/FC61g35RT1GoYHJUS/zF/2I8L26zORaF6emvj1mELst/R/4sQR0l/HrdH6TziThjNlu3hwOheqfTBufX6Bb22bFlNhfzdOS3cmjV3skOYowZQ7rMOTL9XWhIDFc2TxTEAqKCrRvms3fdZIk8pws+37CkaArBgFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the memory hot-remove call chain -- arch_remove_memory(),
__remove_pages(), sparse_remove_section() and section_deactivate() --
does not carry the struct dev_pagemap pointer. This prevents the lower
levels from knowing whether the section was originally populated with
vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).

Without this information, we cannot call vmemmap_can_optimize() to
determine if the vmemmap pages were optimized. As a result, the vmemmap
page accounting during teardown will mistakenly assume a non-optimized
allocation, leading to incorrect memmap statistics.

To lay the groundwork for fixing the vmemmap page accounting, we need
to pass the @pgmap pointer down to the deactivation location. Plumb the
@pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
and sparse_remove_section(), mirroring the corresponding *_activate()
paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/mm/mmu.c            |  5 +++--
 arch/loongarch/mm/init.c       |  5 +++--
 arch/powerpc/mm/mem.c          |  5 +++--
 arch/riscv/mm/init.c           |  5 +++--
 arch/s390/mm/init.c            |  5 +++--
 arch/x86/mm/init_64.c          |  5 +++--
 include/linux/memory_hotplug.h |  8 +++++---
 mm/memory_hotplug.c            | 13 +++++++------
 mm/memremap.c                  |  4 ++--
 mm/sparse-vmemmap.c            | 12 ++++++------
 10 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..e5a42b7a0160 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2024,12 +2024,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 00f3822b6e47..c9c57f08fa2c 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -86,7 +86,8 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -95,7 +96,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 }
 #endif
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 648d0c5602ec..4c1afab91996 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -158,12 +158,13 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index decd7df40fa4..b0092fb842a3 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1717,9 +1717,10 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 1f72efc2a579..11a689423440 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -276,12 +276,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..77b889b71cf3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1288,12 +1288,13 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 815e908c4135..7c9d66729c60 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -135,9 +135,10 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap);
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -307,7 +308,8 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap);
+				  struct vmem_altmap *altmap,
+				  struct dev_pagemap *pgmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0bad2aed2bde..7bfdc3a99688 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -576,6 +576,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
+ * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -583,7 +584,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -598,7 +599,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
 	}
 }
 
@@ -1425,7 +1426,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1468,7 +1469,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, params.altmap);
+			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1554,7 +1555,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2266,7 +2267,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..81766d822400 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL);
+			       PHYS_PFN(range_len(range)), NULL, pgmap);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap));
+				pgmap_altmap(pgmap), pgmap);
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a7b11248b989..3340f6d30b01 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -665,7 +665,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -746,7 +746,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -784,7 +784,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -828,7 +828,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -889,13 +889,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap);
+	section_deactivate(pfn, nr_pages, altmap, pgmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
2.20.1


