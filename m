Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3514BC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7916B0098; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB7A6B009D; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963416B00A1; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56A306B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC549A1072
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.25.F24F9C3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9354E8000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wtbL8sbN;
	spf=pass (imf30.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=ZycqDTWN3MqZLeJXy3Pefzet8qvtn+/f+YyYvxxMwLq1ySEpYkuk7tjtPsh9oshF4XJXMp
	VqqeYPDitmj9YTLWwjIXJmHkNd8V3eKcx5aq+zMHD3uP2aNU8pyglDgX6/H0uDeISm/+Dz
	h/oQ3fkEnwLSxvgY6IN/QJ51Z0f0zsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOTDgBkjYJFHvNQbfBQWTD/6fFe89tZAtGOjlb0y990=;
	b=4YwcyLq8vUG0E3hq6fbh0Y7LLOxTzJ8FLgxHfkZLyBef7/eCz2xwZs4un7D9g4arkelZEq
	PzHCca7PnaMqLA8wAvgE7Xq/tIJM1yzi2oa39jwSinJMtE0HpABYu6uA5cht+r9Ir86HQ+
	Zo72H6qitRDhQV7R40/hrZJ8zoJJjbc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wtbL8sbN;
	spf=pass (imf30.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uOTDgBkjYJFHvNQbfBQWTD/6fFe89tZAtGOjlb0y990=;
	b=wtbL8sbN6tNfhYL36YDbdr/ivXINVqVkk90pUmq92rN8cLBL20/oYfcOC+UfURGULymSn/Yf1
	u0XqUbwXc5kYu2UuEba9a35jtyCNeRQF9KydgYEbxyPLIDONF88jLBvoo555mEitZA4/pudQ3PI
	/DPolqoyPJU9gC8IkMbs54k=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KF1XKkzHnH5S;
	Fri, 28 Aug 2026 00:24:01 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 3ACEA4058E;
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
Subject: [RFC PATCH 11/18] mm: enable per-NUMA node kernel text and rodata replication
Date: Fri, 28 Aug 2026 00:11:51 +0800
Message-ID: <20260827161158.3618409-12-panov.nikita@huawei.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9354E8000F
X-Stat-Signature: ztkr6wnphxrkiiw4bco95jonfkry1pe6
X-HE-Tag: 1787847880-603589
X-HE-Meta: U2FsdGVkX187kXUgrqYkkYdNRx5hmK6FhSkXJ83GOeZe17TBEV7HrNxaHmF4UY58Wz4Ca/LBjzdDUt3a1/bYdBBfuCp9BUVHY6oLHNKo1GbHGct1YlgF/01CVA9PkK09wU3u3e7qORevkMUyaBfQ/f9aMnhC10i2HQAhUkVx6CtgOV1LSbiZcKnybJT+sLVge3PFgRAzodSosfB/IQbvdQmo0HrclPs1uE+f3rgjrohC3KH4JAWuM5jooSg0kNY2t7HffzaPnwW3y6GBKHkSH5Xubu7ympMbhDaKew6IdBwtb2giKPxslTPzZJ4eYavmJinTtR27H2eP7Umde333n6VOgUOjbfuKh8PVXDoNos2ELcEcLQ2I7Aw95yTncudDOUGu3X7eICyYms1j272H2yMdmHu4Mb4mNFB769+z5C2yxoh4a+X1UyiNuhpwqoW9VA1fHDZ3aG+Bz9WX9gVLLki5WWACTcB3El9YSiykNkuqVMGTANvOlf0T2UQw3MLfoLOF3yK0pDkJBTXiO9uAWAPUcQR1WIjQukT9t6btWFWU60iR0b/LU/7I31DMi6B8Y0YjNvx9/HUfnSW3Rql3TRtTbqOrDFLOo0haDtbUwgrfMkdQI8HR77bybHdESxPGnatYFrLm/T5qaI6uqoaprKrH6x03+6qftYhuOv65+pNGApFkZwlZXQS+MpcCQ4csi6HNumj1SUq46zq2LcosV0ebHygrLp7bTKJEv0VUVLk79WyBhFDGyybpAdWEBmofyXmbLCXvGlQ2m5V42Ku0GuHmbPajrlIUWE4dnuVTSFvO7P95kCkBEn8/aXPaOOTWe8+JjT73wsOmtVz7lEVeyswZ/KqDfjVLkT3AqxeDhCB20ABFz4mTT7IJTeV/LTUE15B3LLNecLKgtDBhjQlzMyfQbl8TZB01dp2NmMFYkgvs7IIy8BfUl/3I4qaVrmL/nuAIPctHq2rfP+AwiLd
 ibOO6Bep
 1ygvkKi02JkOmOKfFd7vUDxCwAoZE0ySnNkHRDk3tmgGRmj+XB1NEkcmjarrGxB4dyvlYTsjaFwzPxhe3+bfSiQXXHVR/KIkSFRLEH/tu0WjexBkdQzO9mCzRW7Vme+urhbyawtc40njU6mmoW6nyN2K+SQ5/PIxBvFQPTHGCR2PgA4DNlxrVRKA5m2ZoUt+Q34WAK1Uy/iRHKdKf3rJP09mnnIC6pIVuDliOfhc3en3pNTTx6DLe8+AOgtX+z7XESpQ4IOJsBdoJPNaozeDn3c9eOeuJ/g1FM1PrNTZUtrNeF+YNCim7NYWCnx0SFiRm8Z8wOkiF0nhTpBrrGl5dOpQ8JWvMi/OLnLvVcs8saPvOV/7hEG63Fgua1aRZ0Z9Y8IcnpS44//bOEk2mJCfq2tLOXRmAkNJVfU8j4P0BqFJ/yayWJCZ+Y6l77st8q868FlQhoBJOR82Vn8aLFrWBoz6vsYtuUvc+68Jz9SHWqdRV6I14uclrzrmHOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/mm/context.c |  1 -
 arch/arm64/mm/mmu.c     |  8 ++++++--
 include/linux/mm.h      |  3 +++
 init/main.c             | 17 +++++++++++++++++
 mm/mm_init.c            |  3 +++
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 3afdae62784e..0f4a28b87469 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/numa_kernel_replication.h>
 
 #include <asm/cpufeature.h>
 #include <asm/mmu_context.h>
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index fa12461c0d8e..4bc8b748e303 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1040,10 +1040,10 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 				 pgd_pgtable_alloc_special_mm, flags);
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
 static void populate_mappings_prot(phys_addr_t phys, unsigned long virt,
 				   phys_addr_t size, pgprot_t prot)
 {
-#ifdef CONFIG_KERNEL_REPLICATION
 	int nid;
 
 	for_each_memory_node(nid) {
@@ -1051,10 +1051,14 @@ static void populate_mappings_prot(phys_addr_t phys, unsigned long virt,
 			page_to_phys(walk_to_page_node(nid, (void *)virt)),
 			virt, size, prot, NULL, 0);
 	}
+}
 #else
+static void populate_mappings_prot(phys_addr_t phys, unsigned long virt,
+				   phys_addr_t size, pgprot_t prot)
+{
 	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
-#endif /* CONFIG_KERNEL_REPLICATION */
 }
+#endif /* CONFIG_KERNEL_REPLICATION */
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 				phys_addr_t size, pgprot_t prot)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8a7083c02203..0f3592038823 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4240,6 +4240,9 @@ extern int __meminit early_pfn_to_nid(unsigned long pfn);
 #endif
 
 extern void mem_init(void);
+#ifdef CONFIG_KERNEL_REPLICATION
+extern void preallocate_vmalloc_pages(void);
+#endif
 extern void __init mmap_init(void);
 
 extern void __show_mem(unsigned int flags, const nodemask_t *nodemask, int max_zone_idx);
diff --git a/init/main.c b/init/main.c
index d9d936707c19..249307e46818 100644
--- a/init/main.c
+++ b/init/main.c
@@ -109,6 +109,7 @@
 #include <linux/unaligned.h>
 #include <linux/vdso_datastore.h>
 #include <linux/hazptr.h>
+#include <linux/numa_kernel_replication.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1038,12 +1039,20 @@ void start_kernel(void)
 	 * These use large bootmem allocations and must precede
 	 * initalization of page allocator
 	 */
+	numa_replication_init();
 	setup_log_buf(0);
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
 	mm_core_init();
 	maple_tree_init();
+	/*
+	 * Kernel text replication should be done before
+	 * alloc/init first mm struct, due to it is necessary
+	 * to setup per-NUMA node translation tables and kernel
+	 * instances properly.
+	 */
+	numa_replicate_kernel_text();
 	poking_init();
 	ftrace_init();
 
@@ -1571,6 +1580,14 @@ static int __ref kernel_init(void *unused)
 	free_initmem();
 	mark_readonly();
 
+	/*
+	 * RODATA replication is done here due to
+	 * it is necessary to finalize the kernel
+	 * and modules initialization before
+	 */
+	numa_replicate_kernel_rodata();
+	numa_replication_fini();
+
 	/*
 	 * Kernel mappings are now finalized - update the userspace page-table
 	 * to finalize PTI.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..d2b13d8887c8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2679,6 +2679,9 @@ void __init mm_core_init(void)
 	ptlock_cache_init();
 	pgtable_cache_init();
 	debug_objects_mem_init();
+#ifdef CONFIG_KERNEL_REPLICATION
+	preallocate_vmalloc_pages();
+#endif
 	vmalloc_init();
 	/* If no deferred init page_ext now, as vmap is fully initialized */
 	if (!deferred_struct_pages)
-- 
2.34.1


