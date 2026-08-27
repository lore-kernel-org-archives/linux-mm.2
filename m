Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E43C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49596B00A9; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4966B00AC; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B124D6B00A7; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 560576B00AB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B84FE80119
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.05.B893036
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9E7CC0010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F63kYZZR;
	spf=pass (imf10.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847883;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzG5ol8Yr6RKYwTAU+BAIanpIkNMA3tETIj6mvgS0RQ=;
	b=qTncD4up+JwFzO1eGclovOp4vG1pLI7fy56ypxDVmJRiB0fIqep32U5JFn81uqKK1S00E2
	TeV+WNtlYCgOnVmfPk/fJFcK0Woyg2MYcdyycuqat7nhaG/4UmBLvKJLXqALa+MNZVfkPq
	60T76npGva0fT4vsJ+fmhV/PyEVJ55s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847883;
	b=bXXhHAmbMlCiKuRZOK3qrVK7iOikQ/kBfoDfDkqW1LByDh+Pi84Xrx0Z8dy6dBgRwMNom7
	TPwApYx0vMtcpbcDbaX/+M8y8a0aE+7ylJvm/h9SUbxIT/yP/J/8LCATG59mCiAqbAL6sG
	eAbF5JbMfDke0VZxa+86NGPOBWsBrJM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F63kYZZR;
	spf=pass (imf10.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gzG5ol8Yr6RKYwTAU+BAIanpIkNMA3tETIj6mvgS0RQ=;
	b=F63kYZZRaWckjPUhtZOR2u+9xVDb4ayB+XJ7djeLCD8+HZj9Ituii5PFkTq09FW8YQWa/kROT
	427t61dwdHdiaK2yyzTeCLrtvj4uBWR5I3vJ1UmSPJ72M17crIgWvQ4lDFSBleLV0vCWWAvY/PI
	IwFkSVRGhZ2SPjPU+HD5Af8=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KW4D2GzJ46Yq;
	Fri, 28 Aug 2026 00:24:15 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 25DEC4058D;
	Fri, 28 Aug 2026 00:24:37 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:36 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 10/18] arm64: enable per-NUMA node kernel text and rodata replication
Date: Fri, 28 Aug 2026 00:11:50 +0800
Message-ID: <20260827161158.3618409-11-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9E7CC0010
X-Stat-Signature: o1b7cqcii1quf7c6fnshe334pwiuwgz7
X-HE-Tag: 1787847883-383841
X-HE-Meta: U2FsdGVkX1/mkR2h0t8xPv32ut95sw+3n+ROt4XZcswOmL11YQTsbKicC7HHr8A+tjzbwXed/a7Hr31eh+nYHAMGniJUb5nN1ZnLJEpeggymoK4ArMLxUll830633t6LV9UQ+Z9sTeTP+7LlKI0A0JJCtA0nl+pLhspYwfTNh7eXSLVuYPPelPJDMQmQJOXrDMCgR6jpiAIQY+/tMx/npcYkFqrRoGMsHYCv65QGxD6e60z/LfMTFRbT1jQfIu4GOaSP6WdZP5yNk/ou2DMVKC3ce3PXXEbkNP8r0jKdy9PRZJskQH9zFthKJ6r0mDM/XDZSqt7nertWzPNf99dvGX8+KqDh90ZNg7/Y4eplvJ4fpT/PE7tE025Cs5RLe7965pIvG4qE6xBJ1DnvudFSmE10dmY5DelmFrQQrKQA88MjYCtPpxoOfJ6SU9YkT0JzONbTxkZJVzRz6qr6xfPKSEJUS3Y+4UaeYXVREsvcTYZ8GqXdSi6iPoalQOBWuKkGLPy134SUf3EX7kuzn+uA576qXcKN1uHkz3wj9BW81SYB3/UJNXZDJTRTOOem5qdzg0DUTuH18usgsApaySg6HmE69GDuSDplmCWwxeYXd+BSmSWaGPtYqLfRy1n+gHbeJ+CY13NBMGOl4Sd6MS97I8hQhAR0x9VcVFr3KsdSx8j0ZE6TssJQKAQ2yeylBI0hPF68C3XrObuRgOlMWQ7/oRn80PY3SPH7H3fXjnYlJXkN2M+fRa1IiHlgt0Ky3TcYOuWPxmm/eDmLTp/4+AMVOTPFEXZAbE5uJ6e2LoaLSc5GylTSwWrh5Dh9xK3kAIaDve/5c+Djjp7j70prI69JMlmibJYw0gOcUNrmH0HsozYA8cN3te8xC1AfIW345gVpHB+RlKH5NyhaJu8+jq7Q8llN///WHBsXV9Gzi6iNJY4/ahyPcYry8pHZdJIWsEzHx3YS09a2No7gTDnVzkq
 lWyhQZ5k
 9ujE6Zj2j8JSbYiALlHOkCIl6MxTZCCg4qqPDhpdJJyMJGsHLRI9TjQlWMAeqJtdSPcZu3Ns/oZBh4GjFz0GpM2QmxAkE0PfINm8kB7ovjplPEjaOytFEgbmkGe9J5KXCWVrLxxU2sOnBq8bSEjEOF5Rlg6R8FCpmoc0Y6XkFBNMaFmPHXbwt50OP3AszW+1abTSghOBP7JhUwuBadHXfvMQA4eDwx0oIV/pZERyd+USARAu5nbacwt8Siel9z7oxk0vVagK2eRs+mNjIjXCcoxBPBB4LrkskJTwVzzM9LDYwhTTXh70exVeZTnk+m1bZfbbBuIswGwo0xoCUg0+miKiANxtlyZ+t1HPoeCpRLrBr/9Pe9aBzNYD+OIShvK3vEycv3Jf9IF9nVoc4cU6BexYBPc3fu0OuyiVztXvX2qe4huwyrMt67cWdcm1N2fA7GWG/u9x5pQnA+srvrCGoBpK0BQvYhA5k7r0qp2yzWBNdneO4HM842DcyeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During boot memory for replicas is allocated,
local translation tables are created,
original text and rodata are copied to replicas,
and replicas are mapped to local tables.
On startup of the secondary CPUs, after minimal initialization,
the local pgtable is loaded to ttbr1.

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/include/asm/pgtable.h |  4 +++
 arch/arm64/kernel/smp.c          |  8 ++++++
 arch/arm64/mm/context.c          |  1 +
 arch/arm64/mm/init.c             | 49 ++++++++++++++++++++++++++++++++
 arch/arm64/mm/kasan_init.c       |  2 ++
 arch/arm64/mm/mmu.c              | 38 ++++++++++++++++++++++++-
 6 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6000905a2e86..f11d77829890 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -20,7 +20,11 @@
  * VMALLOC_START: beginning of the kernel vmalloc space
  * VMALLOC_END: extends to the available space below vmemmap
  */
+#ifdef CONFIG_KERNEL_REPLICATION
+#define VMALLOC_START		((MODULES_END & PGDIR_MASK) + PGDIR_SIZE)
+#else /* !CONFIG_KERNEL_REPLICATION */
 #define VMALLOC_START		(MODULES_END)
+#endif /* CONFIG_KERNEL_REPLICATION */
 #if VA_BITS == VA_BITS_MIN
 #define VMALLOC_END		(VMEMMAP_START - SZ_8M)
 #else
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index a61dc3016a11..4832a89ba992 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -36,6 +36,7 @@
 #include <linux/kprobes.h>
 #include <linux/kvm_host.h>
 #include <linux/nmi.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/alternative.h>
 #include <asm/atomic.h>
@@ -208,6 +209,13 @@ asmlinkage notrace void secondary_start_kernel(void)
 	mmgrab(mm);
 	current->active_mm = mm;
 
+	/*
+	 * Setup per-NUMA node page table if kernel
+	 * replication is enabled. Option supported
+	 * only for 64-bit mode.
+	 */
+	numa_setup_pgd();
+
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it
 	 * point to zero page to avoid speculatively fetching new entries.
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 0f4a28b87469..3afdae62784e 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/cpufeature.h>
 #include <asm/mmu_context.h>
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index fbf215ecc7d0..3c2394b20c03 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -331,6 +331,47 @@ void __init bootmem_init(void)
 	memblock_dump_all();
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+/*
+ * It is necessary to preallocate vmalloc pages in advance,
+ * otherwise the replicated page-tables can be incomplete.
+ */
+void __init preallocate_vmalloc_pages(void)
+{
+	unsigned long addr;
+
+	for (addr = MODULES_VADDR; addr <= VMALLOC_END && addr != 0UL;
+			addr = ALIGN(addr + 1, PGDIR_SIZE)) {
+		pgd_t *pgd = pgd_offset_k(addr);
+		p4d_t *p4d;
+		pud_t *pud;
+		pmd_t *pmd;
+		int pte;
+
+		p4d = p4d_alloc(&init_mm, pgd, addr);
+		/*
+		 * No need to check p4d here due to
+		 * only 4-stage page table is possible
+		 */
+		pud = pud_alloc(&init_mm, p4d, addr);
+		if (!pud)
+			panic("Failed to pre-allocate pud pages for vmalloc area\n");
+		if (!mm_pud_folded(&init_mm))
+			continue;
+
+		pmd = pmd_alloc(&init_mm, pud, addr);
+		if (!pmd)
+			panic("Failed to pre-allocate pmd pages for vmalloc area\n");
+		if (!mm_pmd_folded(&init_mm))
+			continue;
+
+		pte = pte_alloc(&init_mm, pmd);
+		if (pte)
+			panic("Failed to pre-allocate pte pages for vmalloc area\n");
+	}
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 void __init arch_setup_zero_pages(void)
 {
 	__zero_page = phys_to_page(__pa_symbol(empty_zero_page));
@@ -401,7 +442,15 @@ void free_initmem(void)
 	 * prevents the region from being reused for kernel modules, which
 	 * is not supported by kallsyms.
 	 */
+#ifdef CONFIG_KERNEL_REPLICATION
+	/*
+	 * In case of replicated kernel the per-NUMA node vmalloc
+	 * memory should be released.
+	 */
+	vunmap_range_replicas((u64)__init_begin, (u64)__init_end);
+#else
 	vunmap_range((u64)__init_begin, (u64)__init_end);
+#endif /* CONFIG_KERNEL_REPLICATION */
 }
 
 void dump_mem_limit(void)
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 45fbdce684c8..37eb408830f0 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -345,7 +345,9 @@ static void __init kasan_init_shadow(void)
 	kasan_populate_early_shadow(kasan_mem_to_shadow((void *)PAGE_END),
 				   (void *)mod_shadow_start);
 
+#ifndef CONFIG_KERNEL_REPLICATION
 	BUILD_BUG_ON(VMALLOC_START != MODULES_END);
+#endif
 	kasan_populate_early_shadow((void *)vmalloc_shadow_end,
 				    (void *)KASAN_SHADOW_END);
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..fa12461c0d8e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pagewalk.h>
 #include <linux/stop_machine.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -1039,6 +1040,22 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 				 pgd_pgtable_alloc_special_mm, flags);
 }
 
+static void populate_mappings_prot(phys_addr_t phys, unsigned long virt,
+				   phys_addr_t size, pgprot_t prot)
+{
+#ifdef CONFIG_KERNEL_REPLICATION
+	int nid;
+
+	for_each_memory_node(nid) {
+		early_create_pgd_mapping(per_node_pgd(&init_mm, nid),
+			page_to_phys(walk_to_page_node(nid, (void *)virt)),
+			virt, size, prot, NULL, 0);
+	}
+#else
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
+#endif /* CONFIG_KERNEL_REPLICATION */
+}
+
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 				phys_addr_t size, pgprot_t prot)
 {
@@ -1048,7 +1065,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
+	populate_mappings_prot(phys, virt, size, prot);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -1390,6 +1407,21 @@ static pgprot_t __init kernel_exec_prot(void)
 	return rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void __init populate_trampoline_mappings(void)
+{
+	int nid;
+
+	/* Copy trampoline mappings in replicated tables */
+	for_each_memory_node(nid) {
+		memcpy(per_node_pgd(&init_mm, nid) - (PAGE_SIZE * 2 / sizeof(pgd_t)),
+				tramp_pg_dir, PGD_SIZE);
+	}
+	/* Be sure that replicated page table can be observed properly */
+	dsb(ishst);
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static int __init map_entry_trampoline(void)
 {
 	int i;
@@ -1418,6 +1450,10 @@ static int __init map_entry_trampoline(void)
 		__set_fixmap(FIX_ENTRY_TRAMP_TEXT1 - i,
 			     pa_start + i * PAGE_SIZE, PAGE_KERNEL_RO);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+	populate_trampoline_mappings();
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 	return 0;
 }
 core_initcall(map_entry_trampoline);
-- 
2.34.1


