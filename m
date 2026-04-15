Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B17C9F4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B256B009B; Wed, 15 Apr 2026 07:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231706B009D; Wed, 15 Apr 2026 07:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147C86B009E; Wed, 15 Apr 2026 07:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 065B66B009B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:14:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9757413AB74
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:50 +0000 (UTC)
X-FDA: 84660532740.08.08AEBB5
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1F721C000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ix0j+E6k;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Df1XnTLx+FlR5iv38FY01xmyEBUedrertPqH9E0HLA=;
	b=b8RN4YhsRSAYMDiJWFifsOCRpRkqdB3lhJBV9bLWp1jXokBIfxu6/uklxwP/fMIFL/AMSD
	O2i8nhzkGtGitr8NI3u3g6Orfa/fxTfRv9MQ3GbY9fQ2RbtM7+pf/GD9KSBV5eqxcGwcG4
	gUoXwa3WbM937thMr1zlsLdmTlTK7nk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ix0j+E6k;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251688; a=rsa-sha256;
	cv=none;
	b=ZzQ6UgtS7YvSrBT44PLvZ1nDMstVCmE3orPnL+dtm4ubBEdJeVNpYRdyUmyg0WYfFQXxYf
	sDuzfVDrMRpv6lGGcJupL19kSSN5Yv1YbZhKQwjasxoFo+Sr2KiZSP79z/ZWPDLKJ9cozh
	iPXOjwX93FXePKQZsm9nEZ4+K0n1vcc=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c76b9efc299so2547090a12.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251687; x=1776856487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Df1XnTLx+FlR5iv38FY01xmyEBUedrertPqH9E0HLA=;
        b=ix0j+E6kyNIEmSiXima96q1P2KkcgoXxZrXFNh2lQ135qW82YHTewkYObc8YXT6Zmb
         jpYtEjIhBKBHWkMtkj3W963ONAspmKRVag0IJl5mTwgCQhh6NOVUVfxVX4POEeQo5jj7
         wz+X1iVXVqm3gpT6D1df1whZwlGLTFEKxC7gKQd3pAxnkK3rV1KNET9aIOKA7pIPF0uz
         /8Wx3O7aHxEINkTcQzvYhp0ylB5mRVEfxSTPCN9/S4yM+0FcXwy1SEwAkTZen+RB69li
         xiBAhLfQW8BnB5g1rG62EsO3E/0+w3S67W0ZMHDHPTsyMJC44aJRqXOPPH5iTIfKzZ9k
         noaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251687; x=1776856487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Df1XnTLx+FlR5iv38FY01xmyEBUedrertPqH9E0HLA=;
        b=ntpBxZQot4X1ktqVL+IG98eWWTS5W1fI4XskSc5fzG9t5nD6Ni7cd0gZUySmTfZLeG
         8oqgm5cx7nlVUy1UGH8KuP6HowdzzjGZ4qv8kzkjzgHHDEAI+G6rt+lzk5OTCUj5/+XB
         O2AHoSTjqNKnc9HWe4cZB6/q5EI8BJkg16LEfopGyoYjzOGdG3D84bxTrebygtiLNxmm
         CWkRCnrp0qSmIRgFm/scz7RTBIMLL/xyX19hxRRsMAU/lowFKnrvXlnTO1l/j2uLZAFD
         OJn1UjPofzw156jlvNNwAhwc/Gq6fwZn2o9ncLjPQlBqBxnTJC/qNYZM8/5UlBmHpB9X
         LVhg==
X-Forwarded-Encrypted: i=1; AFNElJ/U5pBRVacoF9IqZ/7vxneTYOkNl9Hx3M/JGzZ9msFbmeYcevDvUHWhywRSj1f18Jvn87IOZBDEdw==@kvack.org
X-Gm-Message-State: AOJu0YyqvxsaGhVl4ykyRoKrbNZhQ8bczv9LatN6Kz05p0pA68Tl2ZAt
	eprsjORvmTJkirlidFGwwoMEYY6PP/WNMH37RxCbs4wqaEu0VYwr3qHujk+jKq9GmEI=
X-Gm-Gg: AeBDiesGpmXP21pxyZAmkJ11zcT4K3uQfWOz4x0gZDy6h6nuogjrSEgSHMzFcInPqAa
	vZucqkFuFmI0ZJMnnpOCUN95KOJQ5ckBlhOlcmd0iy833MJOAQgvDFgZ15F4zR8S9TGEZbZ+8BL
	19zdLCIKjwjVb8SCEwjgZAO/SB5JmtRD5ig+usmqUVu7ASfMHlRhG5cVRfi7sItWjXMYmOsjEB+
	NybF+xPBMGY2iiLq5SDXFBzwzXajHaxIUuCQdhlf8GOjUX5+/ivb5DBh62Vy4fVGIzufjfhEIM9
	FVVB2M+lyRLJEPxn6f04kw5JMIYz2l3t7FfPIgI6lfWOc7k+kmhRlgI2ear56SU7CR99WsHPx9D
	1WWL+6wAu7dUS0GHEDfKQ/GuzKGfwamY3GBgao0NCEPS8BFzPLZhOAzorAfWFbC3CUXgmYOeIwp
	sn1btcduHD4SytrSTiWyZFNj1HoOujsqR6A/b26rgZAac=
X-Received: by 2002:a17:902:db0f:b0:2b2:67ca:5ff1 with SMTP id d9443c01a7336-2b2d5a6a36cmr226277565ad.31.1776251685742;
        Wed, 15 Apr 2026 04:14:45 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:45 -0700 (PDT)
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
Subject: [PATCH v2 4/6] mm/sparse-vmemmap: Pass @pgmap argument to arch vmemmap_populate()
Date: Wed, 15 Apr 2026 19:14:10 +0800
Message-Id: <20260415111412.1003526-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260415111412.1003526-1-songmuchun@bytedance.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1F721C000D
X-Stat-Signature: cugizk5gzn9ajqtsu16u7rj584iohmk3
X-HE-Tag: 1776251688-889114
X-HE-Meta: U2FsdGVkX18DCbmRpdP2FOy3VLr1PHOSZjaTliObIGXcGyqyqKwrpnMyL5ec5rSgH+6arl5pOKRRIIgj+lXo2JKnPNQVTMFt95tlj5whPrlgMKPO3mJ6vfTUPs8tQdlQhN9EifcSUd0XAOqRMHtv4SWEQC+ttdhaj4Bj+lXl98mGrcuJP/tKu8I3vHtCJeaLtk1oTyt5TyKCNczOJPrni5scoeP7ssDlPv2wRSeLAnk/OhTPu5aDv1fLrsvtub1tKn/8ArNCO5HMMk+Eu/pCFiSzph3KrhmQdJavDN8OdrllbGkmHWRwVy7lZNqIQJ0NLTJVWTpNFL6QazRcmQrfBUmVAGsb7DiVcEWQzuwijwa0cgZ9Oo7E3fW8A78LvomsPTCBDdVEwgEoPGL2sGKGk+oI2muIWfabopNapOQ67l5h88llYkVqSjSkCEw1PFAVvBhsdHCsghJY4f4B0erT8PwyYdDWWpHbMcPlL0JLx0ujkO4nOxgjtPhSy4knxvYRjKouxZm0t1amoO8+xAdFcdNY0OsT4SwGCfyZEjVAp1EP67ElYVdMckQrVfqUPwSlx3/3F+1PqR9A52vWx614cws+0OlDG6PS8UkTc+Jsa1uNcEaYtsbDsWROG48mWNCV3xKTN/6pep9IVecmZpqEi7kkJ139DRhLnOkIp/IaAFkjYOZl8O1YeL2ay1tYcbCrk2+UmZHlQ5swBE/GIQcIHx+S/9vdbNJboP6HO6Vsml95m3lrPiZ23oUw+R+xS9LGmpob4UO4soFl++YDWrTiJS5ShH0EvICZSeKzf0i8Yme0SXe0e2U2jgEZJzg9oO3hyemtveuVQ1DRAisI2e6qSc3JPB7t44eHQ5LrTVPcJZI7voCmqJGw5GxVqS5dqLQSvZ7SYDv88brqk6S/z4MBoZfCthCLC+q+AXwfQYMcyk11fEtSpzPUXxnLFk3Tke3WwOMH38z/+3vin98lG7Y
 vfq83CJS
 foP0iDntbPLeq/KPaAyE42yx9H7OURy8O1ji0+W2SPi/ZU4o9eYcQDg2qIaJtDLs54e/8tSC3oNd5B0nKVtXVfhsEfUdHBqYXAbB++nWuB4A1Cbcu6bz4htWGVK+nMzTqo7cplsn0GyH5irttUnavhpoycWdEe1FR1Bbf0FFJsHU8rENDSAnqqbfp2FiSuhKU58wAYSO9hqNnbJgKLNe2ip9kK9gQnimu98NQuK2TrB1cTuiR6LpMcNuguTKbTUIfaNm18QjAwpuA99pE9VFH6yR/+O9+YHgSv1/Aqe5B/R0nd+Suz4Lhe5S3nkhvQMPeYGTcG7lxcxGbcidS2APLpQZGU8RLvdh+zWxiEVhbM4uDzHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the struct dev_pagemap pointer as a parameter to the architecture
specific vmemmap_populate(), vmemmap_populate_hugepages() and
vmemmap_populate_basepages() functions.

Currently, the vmemmap optimization for DAX is handled mostly in an
architecture-agnostic way via vmemmap_populate_compound_pages().
However, this approach skips crucial architecture-specific initialization
steps. For example, the x86 path must call sync_global_pgds() after
populating the vmemmap, which is currently being bypassed.

To lay the groundwork for fixing the vmemmap optimization in the arch
level, we need to pass the @pgmap pointer down to the arch specific
vmemmap_populate() location. Plumb the @pgmap argument through the APIs
of vmemmap_populate(), vmemmap_populate_hugepages() and
vmemmap_populate_basepages().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c                        |  6 +++---
 arch/loongarch/mm/init.c                   |  7 ++++---
 arch/powerpc/include/asm/book3s/64/radix.h |  3 ++-
 arch/powerpc/mm/book3s64/radix_pgtable.c   |  2 +-
 arch/powerpc/mm/init_64.c                  |  4 ++--
 arch/riscv/mm/init.c                       |  4 ++--
 arch/s390/mm/vmem.c                        |  2 +-
 arch/sparc/mm/init_64.c                    |  5 +++--
 arch/x86/mm/init_64.c                      |  8 ++++----
 include/linux/mm.h                         |  8 +++++---
 mm/hugetlb_vmemmap.c                       |  4 ++--
 mm/sparse-vmemmap.c                        | 10 ++++++----
 12 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e5a42b7a0160..11227e104c48 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1790,7 +1790,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
 	/* [start, end] should be within one section */
@@ -1798,9 +1798,9 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 
 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
 	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
-		return vmemmap_populate_basepages(start, end, node, altmap);
+		return vmemmap_populate_basepages(start, end, node, altmap, pgmap);
 	else
-		return vmemmap_populate_hugepages(start, end, node, altmap);
+		return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index c9c57f08fa2c..d61c2e09caae 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -123,12 +123,13 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap)
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap)
 {
 #if CONFIG_PGTABLE_LEVELS == 2
-	return vmemmap_populate_basepages(start, end, node, NULL);
+	return vmemmap_populate_basepages(start, end, node, NULL, pgmap);
 #else
-	return vmemmap_populate_hugepages(start, end, node, NULL);
+	return vmemmap_populate_hugepages(start, end, node, NULL, pgmap);
 #endif
 }
 
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..bde07c6f900f 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -321,7 +321,8 @@ extern int __meminit radix__vmemmap_create_mapping(unsigned long start,
 					     unsigned long page_size,
 					     unsigned long phys);
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end,
-				      int node, struct vmem_altmap *altmap);
+				      int node, struct vmem_altmap *altmap,
+				      struct dev_pagemap *pgmap);
 void __ref radix__vmemmap_free(unsigned long start, unsigned long end,
 			       struct vmem_altmap *altmap);
 extern void radix__vmemmap_remove_mapping(unsigned long start,
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 10aced261cff..568500343e5f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1112,7 +1112,7 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
-				      struct vmem_altmap *altmap)
+				      struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long addr;
 	unsigned long next;
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index b6f3ae03ca9e..8f4aa5b32186 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -275,12 +275,12 @@ static int __meminit __vmemmap_populate(unsigned long start, unsigned long end,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap)
+			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (radix_enabled())
-		return radix__vmemmap_populate(start, end, node, altmap);
+		return radix__vmemmap_populate(start, end, node, altmap, pgmap);
 #endif
 
 	return __vmemmap_populate(start, end, node, altmap);
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index b0092fb842a3..a04ae9727cbe 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1348,7 +1348,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap)
+			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
 
@@ -1358,7 +1358,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	 * memory hotplug, we are not able to update all the page tables with
 	 * the new PMDs.
 	 */
-	return vmemmap_populate_hugepages(start, end, node, altmap);
+	return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
 }
 #endif
 
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index eeadff45e0e1..a7bf8d3d5601 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -506,7 +506,7 @@ static void vmem_remove_range(unsigned long start, unsigned long size)
  * Add a backed mem_map array to the virtual mem_map array.
  */
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap)
+			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	int ret;
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 367c269305e5..f870ca330f9e 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2591,9 +2591,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap)
 {
-	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
+	return vmemmap_populate_hugepages(vstart, vend, node, NULL, pgmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 77b889b71cf3..e18cc81a30b4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1557,7 +1557,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	int err;
 
@@ -1565,15 +1565,15 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	VM_BUG_ON(!PAGE_ALIGNED(end));
 
 	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
-		err = vmemmap_populate_basepages(start, end, node, NULL);
+		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
-		err = vmemmap_populate_hugepages(start, end, node, altmap);
+		err = vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
 	else if (altmap) {
 		pr_err_once("%s: no cpu support for altmap allocations\n",
 				__func__);
 		err = -ENOMEM;
 	} else
-		err = vmemmap_populate_basepages(start, end, node, NULL);
+		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
 	if (!err)
 		sync_global_pgds(start, end - 1);
 	return err;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..bebc5f892f81 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4877,11 +4877,13 @@ void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 int vmemmap_check_pmd(pmd_t *pmd, int node,
 		      unsigned long addr, unsigned long next);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap);
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap);
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap);
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 int vmemmap_populate_hvo(unsigned long start, unsigned long end,
 			 unsigned int order, struct zone *zone,
 			 unsigned long headsize);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4a077d231d3a..50b7123f3bdd 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -829,7 +829,7 @@ void __init hugetlb_vmemmap_init_late(int nid)
 			 */
 			list_del(&m->list);
 
-			vmemmap_populate(start, end, nid, NULL);
+			vmemmap_populate(start, end, nid, NULL, NULL);
 			nr_mmap = end - start;
 			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
 
@@ -845,7 +845,7 @@ void __init hugetlb_vmemmap_init_late(int nid)
 		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
 					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
 			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL);
+			vmemmap_populate(start, end, nid, NULL, NULL);
 			nr_mmap = end - start;
 		} else {
 			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 05e3e2b94e32..f5245647afee 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -297,7 +297,8 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 }
 
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
+					 int node, struct vmem_altmap *altmap,
+					 struct dev_pagemap *pgmap)
 {
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
@@ -400,7 +401,8 @@ int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
+					 int node, struct vmem_altmap *altmap,
+					 struct dev_pagemap *pgmap)
 {
 	unsigned long addr;
 	unsigned long next;
@@ -445,7 +447,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			}
 		} else if (vmemmap_check_pmd(pmd, node, addr, next))
 			continue;
-		if (vmemmap_populate_basepages(addr, next, node, altmap))
+		if (vmemmap_populate_basepages(addr, next, node, altmap, pgmap))
 			return -ENOMEM;
 	}
 	return 0;
@@ -559,7 +561,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	if (vmemmap_can_optimize(altmap, pgmap))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
-		r = vmemmap_populate(start, end, nid, altmap);
+		r = vmemmap_populate(start, end, nid, altmap, pgmap);
 
 	if (r < 0)
 		return NULL;
-- 
2.20.1


