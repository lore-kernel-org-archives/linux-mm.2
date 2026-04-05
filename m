Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6EDE6401A
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18A26B00EA; Sun,  5 Apr 2026 08:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8826B00EC; Sun,  5 Apr 2026 08:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69136B00ED; Sun,  5 Apr 2026 08:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF1B6B00EA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C82A5BF97
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:30 +0000 (UTC)
X-FDA: 84624505980.02.281C7FD
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 77C2940007
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Crx8aX0t;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J13vgUIT6r3ooj2ZXZFUt9fRLd85j+bHxFhjbMlfMio=;
	b=CZMyqh3hqKHAl9m6CABtmBUIc9cLSBqbefRMoR5a+mqFpxFgMSc5trwe48+le62+w8QkUn
	x0LsI0UsqGNrXaza+Qt/3FNUGcOBo8JvFsUekpG5xf7fa1Gu4qQ+pwW2jtmBieePhQdrYr
	Ssgjwmat2eBQM0wDqQvY6bPtXLZkc5s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Crx8aX0t;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393908; a=rsa-sha256;
	cv=none;
	b=eTchiJqvi1bBVfqqmv5/IL9CpV0efnwCTHSDJhoJyvwX2gK01nbZdarql2XRuHgYWMDcYZ
	QEaThpQYHknjxl2QhFSbBLENTFza6TT7INH/M37jcJ789AMlD+SPX57QCggFhrJXMZua0X
	KFSFO8a48UPyonX4ObT6UJorysN0LLA=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35d9749c26dso2358735a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393907; x=1775998707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J13vgUIT6r3ooj2ZXZFUt9fRLd85j+bHxFhjbMlfMio=;
        b=Crx8aX0tp1fL/5/aU1KbVW5z3ynEBIqCYW/JwZ0x7hX3dico4Wj2S8o7NXbZz22cbw
         wQqU1CWqv78b2mXlTQUTheRskfq1pJbjDasIlqInaLgI3qUEWGkTBpCr1fwCRwVtD7m2
         Wr5F324SD84sxL4Xs/06FwSI3JUaFIw96KFwukHktVn2pp5PlLivGWZJ6PDvMfcx6zOi
         9yGTrfuI6AwT8d5ffI9IJKcCBrQyakz9+b2Z7BOrtgr/cwm6SD/rhGScoCMZ9wwVt9m5
         piLX7Bqcipk25tngGNlGZM9TDMfOHKmr5NTrBs6bzA06fRN4P8Q9KrYf3S097JQKhlUv
         0dbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393907; x=1775998707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J13vgUIT6r3ooj2ZXZFUt9fRLd85j+bHxFhjbMlfMio=;
        b=Oy/X0YNQuuOGbrDkZIa4O5dED2k37kiRabCly8hFIdZA39xThqzoW6W4TGWkItGBGz
         xtJURcef9UOvS8zzKvGdohrnezhMihm9MH7tHay7evbwkBBVDrRIIy622X8WGxzieEf/
         bcpatjB8LcjYkfTX3Lh3WV5/OywDwktm4h/ea5lRxx+vApYWSMX0b8HK01ssPb4N6F7p
         76p9vMR4tTGqR6ojsS6vVMHkI7YPtYl5KeYIjl6V4ESEuPvtKdPTzSDy8g5dWhCaDolM
         pNIv1wpy/drti9mkzymbnLHsdmODtGLMijxBrePky+ZOVFr5KI/F3uAEJ9MwKvNuHQbh
         8SLg==
X-Forwarded-Encrypted: i=1; AJvYcCVa8SRqGG/cIYDnx3lb5nbnZEtt9BBaYF1Pq1GrYaP/3IXRK8eC1cfmOBOwUsJO3L9doDWOdY/Wng==@kvack.org
X-Gm-Message-State: AOJu0YwA4u4LprkXOX8WrFlro02diX5HKdGbABXIz1io8ByPOrcLpiaJ
	72E9HGT22R+L5Quo8Zk98e16t/yKtHAXwcD7FOXvUjUtHHc1Ck/NQiXdkCJ9n1/pBQs=
X-Gm-Gg: AeBDievyukAZExqQo6GHtsJGwx8nUqkSAzPXOMWGCCB9SYTcBOVCEo78fHnncgtYglv
	jBx7xPtaeBcgS+C36NmnHlW9LCcXA0g37RVGOEej3s+P++dyg1Xt2MuSCcM5iT02LWbAEsiObRP
	cynW3ApZ2s6T7GFmuaxk/RmfzN14TMgSHyw6SBziwurX/Q2mv1Q6s4P07svR5lW26XjmOsHpcqr
	wjXNXn9Nm+KIs9hAxk9u5w7v/0aRXoU8DlVXxQmT3p5joXKNLjASuyPFV9hQENm69dQVWGyZzrK
	aYinayBYc8tLS673sEMS/OyIKBz7GkvzOjl9XK+Hr113nZ3RNY47CQsReyuTz25uxAOBiBgYIqq
	r1cu3WDukzy7isPsACUa3hYwsBZnLQ6gdUjhkXFtZ+zVtzpEME0ko2GStqXSOzStYNQzoWdsBzK
	AoGZAhO/nlGJJiPkoWwYPrE976pe5HqW8p6tM1UatbPVA=
X-Received: by 2002:a17:90b:314d:b0:359:f43d:4a6e with SMTP id 98e67ed59e1d1-35de662f67fmr9299980a91.0.1775393907102;
        Sun, 05 Apr 2026 05:58:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:26 -0700 (PDT)
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
Subject: [PATCH 45/49] mm/sparse-vmemmap: drop @pgmap parameter from vmemmap populate APIs
Date: Sun,  5 Apr 2026 20:52:36 +0800
Message-Id: <20260405125240.2558577-46-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: azr8y8uift3hikaat5fy6g4rskfmiyqw
X-Rspamd-Queue-Id: 77C2940007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393908-391497
X-HE-Meta: U2FsdGVkX1/TM6BzutMot3IgrRKttbOpnO7/shMVndRIWdhX+/OhUQggi2A9tcBL627Il1fmp9Fgy+evBEwXwY1fTNYwiIWq0ohAEoR/cjWRl2U1RBJ9ZnfI2BzvVw8cN6aRUvlqu7L5NT21Ut6SNJPLbhJr4BiqchQmQYw1D9eKcpHzBgXY2uTpRVzWYAcq2ShaFuO7wLmIaGjkETNmv4OmUfX96JmfNGHv1dZGuEDuQKbrPURixxNegovB0g1+lYQ3iKaoYmn0Xh/ucpXhWgDOrKeBwA5FnQv4aoQJjm9svmLeKO3Vw0OKZjKl/qcBIAd9PS2MheJiCmfvV1Vmq8DaqrVRHmrIihAH0dXrOwAKLp8pCRrWEj/Z23WVqJBKr6+n+3MxO3gyQQyAbWyfm6nsouMpr4KiDszSKk5dC8kD2ve+hwOOoCtHAemFAweAc2kTECeMZr7A1gi1J4q53LkoOOalKLK2DF9O9w4vHR4bwcLpClCxHULMDi+K48IrldqQdcYHAPhptvnBYlaU3MEltj0tpFZJB1Hz+T5+fwMiSszn4E2+zTLrvhpuPep5ivc8dThAFAnZdo6IMeXy67gG1AZ83aHgRIP9A6/ZCuswNudnIKGzqC/pbxKzBTcWjjvEaRxiQ/3pxKeLQPvfH09FLSEygdLy9/SE0zrBJjHwjvwQcb7QVXZpDdtV5o6uhRNNCuMQZxTuk7gDZQcwZxr6nsAOZr8FkVlOMTd+r5aWplejr1v50UjS9q0Q3ZmaP/QClA4RZSk4fiSJfDvf5OPmRt+FrHAF0ToqnNQ2IgEIbk2BYXVb9UfnLANYMmQKPOhJt66+EP/09k9fkgr1yz8tUuOFqxaY9TnCxxDP5la3TOa4AYLGlHxSwKzXf7CGHlyKPDj58IORUOQANx0hzvycHyhasUiRQ1W53rC7mpHl7IlNkDO2dW1QoXmxXkTXnHTvfMmvD0Wz7/vmClO
 Xb3OF6mB
 TknVSJZ1RjMIOfpHSsRynxp5DK25vcSd0wM2/2kXPxlY+1RY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since architecture-specific choices about vmemmap optimization are now
handled directly inside the vmemmap_populate() implementations, the
@pgmap is no longer needed in the core memory hotplug APIs and most
sparse section routines.

Remove the pgmap parameter entirely from:
- sparse_remove_section()
- __remove_pages()
- arch_remove_memory()
- vmemmap_populate() and related functions

This simplifies the API a little.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c                        | 11 ++++----
 arch/loongarch/mm/init.c                   | 12 ++++----
 arch/powerpc/include/asm/book3s/64/radix.h |  4 +--
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 10 +++----
 arch/powerpc/mm/init_64.c                  |  4 +--
 arch/powerpc/mm/mem.c                      |  5 ++--
 arch/riscv/mm/init.c                       |  9 +++---
 arch/s390/mm/init.c                        |  5 ++--
 arch/s390/mm/vmem.c                        |  2 +-
 arch/sparc/mm/init_64.c                    |  5 ++--
 arch/x86/mm/init_64.c                      | 13 ++++-----
 include/linux/memory_hotplug.h             |  8 ++----
 include/linux/mm.h                         | 11 +++-----
 mm/memory_hotplug.c                        | 12 ++++----
 mm/memremap.c                              |  4 +--
 mm/sparse-vmemmap.c                        | 33 +++++++++-------------
 mm/sparse.c                                |  6 ++--
 17 files changed, 65 insertions(+), 89 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 86162aab5185..ec1c6971a561 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1760,7 +1760,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
 	/* [start, end] should be within one section */
@@ -1768,9 +1768,9 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 
 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
 	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
-		return vmemmap_populate_basepages(start, end, node, altmap, pgmap);
+		return vmemmap_populate_basepages(start, end, node, altmap);
 	else
-		return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
+		return vmemmap_populate_hugepages(start, end, node, altmap);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -1994,13 +1994,12 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index d61c2e09caae..00f3822b6e47 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -86,8 +86,7 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -96,7 +95,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 }
 #endif
 
@@ -123,13 +122,12 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap)
+			       int node, struct vmem_altmap *altmap)
 {
 #if CONFIG_PGTABLE_LEVELS == 2
-	return vmemmap_populate_basepages(start, end, node, NULL, pgmap);
+	return vmemmap_populate_basepages(start, end, node, NULL);
 #else
-	return vmemmap_populate_hugepages(start, end, node, NULL, pgmap);
+	return vmemmap_populate_hugepages(start, end, node, NULL);
 #endif
 }
 
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 18e28deba255..0c9195dd50c9 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -316,13 +316,11 @@ static inline int radix__has_transparent_pud_hugepage(void)
 #endif
 
 struct vmem_altmap;
-struct dev_pagemap;
 extern int __meminit radix__vmemmap_create_mapping(unsigned long start,
 					     unsigned long page_size,
 					     unsigned long phys);
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end,
-				      int node, struct vmem_altmap *altmap,
-				      struct dev_pagemap *pgmap);
+				      int node, struct vmem_altmap *altmap);
 void __ref radix__vmemmap_free(unsigned long start, unsigned long end,
 			       struct vmem_altmap *altmap);
 extern void radix__vmemmap_remove_mapping(unsigned long start,
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 36a69589fae4..190448a17119 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1101,11 +1101,10 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						    unsigned long start,
-						    unsigned long end, int node,
-						    struct dev_pagemap *pgmap);
+						    unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
-				      struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+				      struct vmem_altmap *altmap)
 {
 	unsigned long addr;
 	unsigned long next;
@@ -1117,7 +1116,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, pgmap);
+		return vmemmap_populate_compound_pages(pfn, start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1248,8 +1247,7 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
-						     unsigned long end, int node,
-						     struct dev_pagemap *pgmap)
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 56cbea89d304..8e18ed427fdd 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -275,12 +275,12 @@ static int __meminit __vmemmap_populate(unsigned long start, unsigned long end,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+			       struct vmem_altmap *altmap)
 {
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (radix_enabled())
-		return radix__vmemmap_populate(start, end, node, altmap, pgmap);
+		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
 
 	section_set_order(__pfn_to_section(page_to_pfn((struct page *)start)), 0);
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 4c1afab91996..648d0c5602ec 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -158,13 +158,12 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 277c89661dff..5142ca80be6f 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1443,7 +1443,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+			       struct vmem_altmap *altmap)
 {
 	/*
 	 * Note that SPARSEMEM_VMEMMAP is only selected for rv64 and that we
@@ -1451,7 +1451,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	 * memory hotplug, we are not able to update all the page tables with
 	 * the new PMDs.
 	 */
-	return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
+	return vmemmap_populate_hugepages(start, end, node, altmap);
 }
 #endif
 
@@ -1810,10 +1810,9 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 11a689423440..1f72efc2a579 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -276,13 +276,12 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			struct dev_pagemap *pgmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index a7bf8d3d5601..eeadff45e0e1 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -506,7 +506,7 @@ static void vmem_remove_range(unsigned long start, unsigned long size)
  * Add a backed mem_map array to the virtual mem_map array.
  */
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+			       struct vmem_altmap *altmap)
 {
 	int ret;
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index f870ca330f9e..367c269305e5 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2591,10 +2591,9 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap)
+			       int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_hugepages(vstart, vend, node, NULL, pgmap);
+	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e18cc81a30b4..df2261fa4f98 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1288,13 +1288,12 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			      struct dev_pagemap *pgmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
+	__remove_pages(start_pfn, nr_pages, altmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
@@ -1557,7 +1556,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	int err;
 
@@ -1565,15 +1564,15 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	VM_BUG_ON(!PAGE_ALIGNED(end));
 
 	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
-		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
+		err = vmemmap_populate_basepages(start, end, node, NULL);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
-		err = vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
+		err = vmemmap_populate_hugepages(start, end, node, altmap);
 	else if (altmap) {
 		pr_err_once("%s: no cpu support for altmap allocations\n",
 				__func__);
 		err = -ENOMEM;
 	} else
-		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
+		err = vmemmap_populate_basepages(start, end, node, NULL);
 	if (!err)
 		sync_global_pgds(start, end - 1);
 	return err;
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..815e908c4135 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -135,10 +135,9 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+			   struct vmem_altmap *altmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -308,8 +307,7 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap,
-				  struct dev_pagemap *pgmap);
+				  struct vmem_altmap *altmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8baa224444be..adca19a4b2c7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4858,8 +4858,7 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 void *sparse_buffer_alloc(unsigned long size);
 unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
@@ -4870,13 +4869,11 @@ void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 int vmemmap_check_pmd(pmd_t *pmd, int node,
 		      unsigned long addr, unsigned long next);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap);
+			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap,
-			       struct dev_pagemap *pgmap);
+			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+		struct vmem_altmap *altmap);
 void vmemmap_populate_print_last(void);
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 28306196c0fe..68dd56dd9f74 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -584,7 +584,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		    struct vmem_altmap *altmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -599,7 +599,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap);
 	}
 }
 
@@ -1419,7 +1419,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
+		arch_remove_memory(cur_start, memblock_size, altmap);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1462,7 +1462,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL, NULL);
+			arch_remove_memory(cur_start, memblock_size, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1548,7 +1548,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap, NULL);
+			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
@@ -2247,7 +2247,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL, NULL);
+		arch_remove_memory(start, size, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index c45b90f334ea..ac7be07e3361 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL, pgmap);
+			       PHYS_PFN(range_len(range)), NULL);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap), pgmap);
+				pgmap_altmap(pgmap));
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 752a48112504..68dcc52591d5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -281,8 +281,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 }
 
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap,
-					 struct dev_pagemap *pgmap)
+					 int node, struct vmem_altmap *altmap)
 {
 	unsigned long addr = start;
 	pte_t *pte;
@@ -342,8 +341,7 @@ int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap,
-					 struct dev_pagemap *pgmap)
+					 int node, struct vmem_altmap *altmap)
 {
 	unsigned long addr;
 	unsigned long next;
@@ -393,15 +391,14 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			VM_BUG_ON(section_vmemmap_optimizable(ms));
 			continue;
 		}
-		if (vmemmap_populate_basepages(addr, next, node, altmap, pgmap))
+		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
 	return 0;
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -410,7 +407,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap, pgmap))
+	if (vmemmap_populate(start, end, nid, altmap))
 		return NULL;
 
 	return pfn_to_page(pfn);
@@ -486,10 +483,9 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 }
 
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	return __populate_section_memmap(pfn, nr_pages, nid, altmap);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -570,7 +566,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -622,8 +618,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
@@ -655,10 +650,10 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
 	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages));
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap, pgmap);
+		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -704,7 +699,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 		section_set_zone(ms, ZONE_DEVICE);
 #endif
 	}
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
+	memmap = section_activate(nid, start_pfn, nr_pages, altmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
@@ -726,13 +721,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+			   struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap, pgmap);
+	section_deactivate(pfn, nr_pages, altmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/mm/sparse.c b/mm/sparse.c
index 400542302ad4..77bb0113bac5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -237,8 +237,7 @@ unsigned long __init section_map_size(void)
 }
 
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
 	unsigned long size = section_map_size();
 	struct page *map = sparse_buffer_alloc(size);
@@ -386,8 +385,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		if (pnum >= pnum_end)
 			break;
 
-		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-						nid, NULL, NULL);
+		map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid, NULL);
 		if (!map)
 			panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
 		memmap_boot_pages_add(section_vmemmap_pages(pfn, PAGES_PER_SECTION));
-- 
2.20.1


