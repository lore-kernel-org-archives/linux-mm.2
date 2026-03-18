Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55781103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1A66B0180; Wed, 18 Mar 2026 07:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8C96B0182; Wed, 18 Mar 2026 07:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF426B0183; Wed, 18 Mar 2026 07:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB7D6B0180
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:00:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 624D859CC4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:00:03 +0000 (UTC)
X-FDA: 84558889086.06.17E101A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9649E1C0016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:00:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTXB8Ycy;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHf85tVMEYi9rlhoXXxt4mcEXtLR8IlZlS8Qi7xWCGc=;
	b=AUDggQRUhexQVcAOBKTgiadDL79bkjjMkpHFQlMP+D+oOj5R+sUgdS9IW+WfBZ3g5xfeHu
	U8shGsCTLjbKAIrgF5ALaUQxItOx9Ryjh4AtM99mQv2oQXjPpPorZyTAyNtqv+EMams4oA
	eybif9CcQa5vnujsxLj0krjlmBU4ifM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTXB8Ycy;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831601; a=rsa-sha256;
	cv=none;
	b=GxdAvVaHCZfZne/jNWiA2oke8xasnCVl5+DgqPZxmBgQAIcyxJ1nx2XQpPNlzxel/rLHSV
	TgFVEj+UZzQ3xV0J7SN4Uumzg08iGB5xYgZhSXdyNBg98SxhQak/lbvY5qAENWxVH8H953
	rCqfSKEmG1r3wSvVVKotobzA5OV+iVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B41E0417CB;
	Wed, 18 Mar 2026 10:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06980C2BC9E;
	Wed, 18 Mar 2026 10:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831598;
	bh=FTRK3/0nXEtQXRyfzRpw30jbNiRcIgHk2GMgT8LvG1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTXB8YcyfF3RWS4m9qTpXqanAT8IJs30doG4VwUkuU0JkztWElCKC82lKuc1DWODF
	 e0I/K0OWuk83nGvhL+VBuEChtEZv5S6WGnZN1EZFYUKYipk5jT0u4QenYTNPnYnyIl
	 HBhrEKPRKYZTUqZEY7mkYgi8Frd5wQ3bdM0DnV+Fm+0OJRlOjmRjTZbIhRB3QFcBdB
	 qLxuTVYGxDxN202kgDgkaykQDgOJUFYv8Jb1MrtEaa2JbjB+HfWTY4QcI32L92zmxu
	 KSKwDwA23mC+hVKTY8ary4pexsVOz2oi+zkgTn8f/rpwBV2Yn79ZEZ+CMDjuTe0xY2
	 Yvi30bw6Ks28Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 7/8] memblock, treewide: make memblock_free() handle late freeing
Date: Wed, 18 Mar 2026 12:58:26 +0200
Message-ID: <20260318105827.1358927-8-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9649E1C0016
X-Rspamd-Server: rspam07
X-Stat-Signature: 7sswysx66xin5igx5sxdj4a7hmfqsrsn
X-Rspam-User: 
X-HE-Tag: 1773831601-38906
X-HE-Meta: U2FsdGVkX19O867lgpqODgQ8M/UE+rBDOA3PsA68CIvCZkiXRSVc/n0zHD9N1zoe4fsstIGOXFxuwe9IW1KD9kNmY1qSyNurrzi4jVH4Vhv0kmHpThyFPSVE/P54mQsXcb6f71YX1sjZIGB0OwGDw5gDFYq70x6p9h84GIFxP7GM3LguPflynOFUnKqGDI3U+bqvXP3abMFVq0i//PrfRi3QrU7pqo7pBMlsOiM8+a50dQHva169kh523DsnSk3rbvaOQbNpilubiuWh8jcrAPUEw2VhVS32Qk+gsO0WE75uGa242ECqMOWH4elUcwDHlWy5fZX93n8eK5PnXaCczBIAsnTJPvl7ouCObHF2fN/Is/qdH56PBpdW6UXm2z14kak466EpZnB4mzqtIlbo8nKH97LiW/ay0HRHt8mOYUi9KoZfR2XlgI8pjV4UtpwYHl89alV2NDOkXkLAxAmQkw+uaXtWF2vmtSV84bO9Y+IYRiiHqV69f3PHhM6nESki+HAaAEkUwyF3s4yfgaxJLmSdMF+0nvf/K722GJZz0mayuWI3bSWMVDg9ItL32Clyz95CM1mYzH0LLrzYciLr937ePqAZQYlFpFxjZfCQ0X07vHjFkr5FmOCykYHG8FzHc7lX3z/UMX/RJOmzfjOfPGE37G99CBLc2CGZkhzGFAGat/QgsUtg1FlqwA4Grex+JEv22RIpPZwJyVcli5I59XslaKf4yRkhR4nl0rfH8Iu3RXeQncNNB4KLz3FPfOcJ+Qb4rqFZJBlDBNejqnoddb4diWyv8+cZ7XKW2GFDqNzm2x303RMC/LJzETqZ0k9dO44JHWSjvo4s/N3RzJQ5D5UbQ/GLlEhVG97gP5BDGwQpYfbeBNRTdDtAuS7tAstiWnag1esn7AWjok0+uuIv8KcaEF2OGnlje5vuWdGtDM1797xipcTqkvRsiFcbyyRG+bOvgx6TbHor+PD2dp4
 YhhAVrBA
 FwwvguLuS+iGohCRbYuc/Upyq9J1PeWFWtdK0tf2/Un/NNuCpK8fGGtJss3Wt1MsZgH8NGS2ai7FFJ8oTspjTuhCXu9RG2Ex6V4xMScQcJAU56mSCY1XgHJ62us1YbwEaEn9rKZLuCmi9+55C0yMp3GnlJptIuy2IfzSpOy6OKoKkrjd6c8UDkvUzIm0ZGBdFlXicfwC2r8HbV6N7VCvZ8R5NWLqnkAGQD+IMSYwHWBs3Kz1017GwJB/cQNX0Z2txgrJsYFR4TWI+/vznlPeUJmmHApvhF+RHkU/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

It shouldn't be responsibility of memblock users to detect if they free
memory allocated from memblock late and should use memblock_free_late().

Make memblock_free() and memblock_phys_free() take care of late memory
freeing and drop memblock_free_late().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sparc/kernel/mdesc.c               |  4 +--
 arch/x86/kernel/setup.c                 |  2 +-
 arch/x86/platform/efi/memmap.c          |  5 +---
 arch/x86/platform/efi/quirks.c          |  2 +-
 drivers/firmware/efi/apple-properties.c |  2 +-
 drivers/of/kexec.c                      |  2 +-
 include/linux/memblock.h                |  2 --
 kernel/dma/swiotlb.c                    |  6 ++--
 lib/bootconfig.c                        |  2 +-
 mm/kfence/core.c                        |  4 +--
 mm/memblock.c                           | 37 +++++++------------------
 11 files changed, 22 insertions(+), 46 deletions(-)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 30f171b7b00c..ecd6c8ae49c7 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -183,14 +183,12 @@ static struct mdesc_handle * __init mdesc_memblock_alloc(unsigned int mdesc_size
 static void __init mdesc_memblock_free(struct mdesc_handle *hp)
 {
 	unsigned int alloc_size;
-	unsigned long start;
 
 	BUG_ON(refcount_read(&hp->refcnt) != 0);
 	BUG_ON(!list_empty(&hp->list));
 
 	alloc_size = PAGE_ALIGN(hp->handle_size);
-	start = __pa(hp);
-	memblock_free_late(start, alloc_size);
+	memblock_free(hp, alloc_size);
 }
 
 static struct mdesc_mem_ops memblock_mdesc_ops = {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index eebcc9db1a1b..46882ce79c3a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -426,7 +426,7 @@ int __init ima_free_kexec_buffer(void)
 	if (!ima_kexec_buffer_size)
 		return -ENOENT;
 
-	memblock_free_late(ima_kexec_buffer_phys,
+	memblock_phys_free(ima_kexec_buffer_phys,
 			   ima_kexec_buffer_size);
 
 	ima_kexec_buffer_phys = 0;
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 023697c88910..697a9a26a005 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -34,10 +34,7 @@ static
 void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
 {
 	if (flags & EFI_MEMMAP_MEMBLOCK) {
-		if (slab_is_available())
-			memblock_free_late(phys, size);
-		else
-			memblock_phys_free(phys, size);
+		memblock_phys_free(phys, size);
 	} else if (flags & EFI_MEMMAP_SLAB) {
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 35caa5746115..a560bbcaa006 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -372,7 +372,7 @@ void __init efi_reserve_boot_services(void)
 		 * doesn't make sense as far as the firmware is
 		 * concerned, but it does provide us with a way to tag
 		 * those regions that must not be paired with
-		 * memblock_free_late().
+		 * memblock_phys_free().
 		 */
 		md->attribute |= EFI_MEMORY_RUNTIME;
 	}
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 13ac28754c03..2e525e17fba7 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -226,7 +226,7 @@ static int __init map_properties(void)
 		 */
 		data->len = 0;
 		memunmap(data);
-		memblock_free_late(pa_data + sizeof(*data), data_len);
+		memblock_phys_free(pa_data + sizeof(*data), data_len);
 
 		return ret;
 	}
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index c4cf3552c018..512d9be9d513 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -175,7 +175,7 @@ int __init ima_free_kexec_buffer(void)
 	if (ret)
 		return ret;
 
-	memblock_free_late(addr, size);
+	memblock_phys_free(addr, size);
 	return 0;
 }
 #endif
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..6f6c5b5c4a4b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -172,8 +172,6 @@ void __next_mem_range_rev(u64 *idx, int nid, enum memblock_flags flags,
 			  struct memblock_type *type_b, phys_addr_t *out_start,
 			  phys_addr_t *out_end, int *out_nid);
 
-void memblock_free_late(phys_addr_t base, phys_addr_t size);
-
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 static inline void __next_physmem_range(u64 *idx, struct memblock_type *type,
 					phys_addr_t *out_start,
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index d8e6f1d889d5..e44e039e00d3 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -546,10 +546,10 @@ void __init swiotlb_exit(void)
 		free_pages(tbl_vaddr, get_order(tbl_size));
 		free_pages((unsigned long)mem->slots, get_order(slots_size));
 	} else {
-		memblock_free_late(__pa(mem->areas),
+		memblock_free(mem->areas,
 			array_size(sizeof(*mem->areas), mem->nareas));
-		memblock_free_late(mem->start, tbl_size);
-		memblock_free_late(__pa(mem->slots), slots_size);
+		memblock_phys_free(mem->start, tbl_size);
+		memblock_free(mem->slots, slots_size);
 	}
 
 	memset(mem, 0, sizeof(*mem));
diff --git a/lib/bootconfig.c b/lib/bootconfig.c
index 449369a60846..86a75bf636bc 100644
--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -64,7 +64,7 @@ static inline void __init xbc_free_mem(void *addr, size_t size, bool early)
 	if (early)
 		memblock_free(addr, size);
 	else if (addr)
-		memblock_free_late(__pa(addr), size);
+		memblock_free(addr, size);
 }
 
 #else /* !__KERNEL__ */
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 7393957f9a20..5c8268af533e 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -731,10 +731,10 @@ static bool __init kfence_init_pool_early(void)
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
-	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
+	memblock_free((void *)addr, KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 
-	memblock_free_late(__pa(kfence_metadata_init), KFENCE_METADATA_SIZE);
+	memblock_free(kfence_metadata_init, KFENCE_METADATA_SIZE);
 	kfence_metadata_init = NULL;
 
 	return false;
diff --git a/mm/memblock.c b/mm/memblock.c
index 9f372a8e82f7..bd5758ff07f2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -384,26 +384,24 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
  */
 void __init memblock_discard(void)
 {
-	phys_addr_t addr, size;
+	phys_addr_t size;
 
 	if (memblock.reserved.regions != memblock_reserved_init_regions) {
-		addr = __pa(memblock.reserved.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
 		if (memblock_reserved_in_slab)
 			kfree(memblock.reserved.regions);
 		else
-			memblock_free_late(addr, size);
+			memblock_free(memblock.reserved.regions, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
-		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
 		if (memblock_memory_in_slab)
 			kfree(memblock.memory.regions);
 		else
-			memblock_free_late(addr, size);
+			memblock_free(memblock.memory.regions, size);
 	}
 
 	memblock_memory = NULL;
@@ -961,7 +959,8 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
  * @size: size of the boot memory block in bytes
  *
  * Free boot memory block previously allocated by memblock_alloc_xx() API.
- * The freeing memory will not be released to the buddy allocator.
+ * If called after the buddy allocator is available, the memory is released to
+ * the buddy allocator.
  */
 void __init_memblock memblock_free(void *ptr, size_t size)
 {
@@ -975,7 +974,8 @@ void __init_memblock memblock_free(void *ptr, size_t size)
  * @size: size of the boot memory block in bytes
  *
  * Free boot memory block previously allocated by memblock_phys_alloc_xx() API.
- * The freeing memory will not be released to the buddy allocator.
+ * If called after the buddy allocator is available, the memory is released to
+ * the buddy allocator.
  */
 int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
 {
@@ -985,6 +985,9 @@ int __init_memblock memblock_phys_free(phys_addr_t base, phys_addr_t size)
 		     &base, &end, (void *)_RET_IP_);
 
 	kmemleak_free_part_phys(base, size);
+	if (slab_is_available())
+		__free_reserved_area(base, base + size, -1);
+
 	return memblock_remove_range(&memblock.reserved, base, size);
 }
 
@@ -1813,26 +1816,6 @@ void *__init __memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
 	return addr;
 }
 
-/**
- * memblock_free_late - free pages directly to buddy allocator
- * @base: phys starting address of the  boot memory block
- * @size: size of the boot memory block in bytes
- *
- * This is only useful when the memblock allocator has already been torn
- * down, but we are still initializing the system.  Pages are released directly
- * to the buddy allocator.
- */
-void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
-{
-	phys_addr_t end = base + size - 1;
-
-	memblock_dbg("%s: [%pa-%pa] %pS\n",
-		     __func__, &base, &end, (void *)_RET_IP_);
-
-	kmemleak_free_part_phys(base, size);
-	__free_reserved_area(base, base + size, -1);
-}
-
 /*
  * Remaining API functions
  */
-- 
2.51.0


