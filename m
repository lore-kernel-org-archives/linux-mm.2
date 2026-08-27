Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8908CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5536B009D; Thu, 27 Aug 2026 03:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95E06B009E; Thu, 27 Aug 2026 03:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5AB6B009F; Thu, 27 Aug 2026 03:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 754606B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:36:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AACFA034B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:36:29 +0000 (UTC)
X-FDA: 85146241698.19.3DBE3A1
Received: from out28-195.mail.aliyun.com (out28-195.mail.aliyun.com [115.124.28.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17FE7120006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:36:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bosc.ac.cn header.s=default header.b=GCHT1g9G;
	spf=pass (imf29.hostedemail.com: domain of guoyaxing@bosc.ac.cn designates 115.124.28.195 as permitted sender) smtp.mailfrom=guoyaxing@bosc.ac.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zj1CGUu40u6mvDQVh2yoztBvTyR7+rnJQenMhLHVZow=;
	b=POP6eHhThmhQp2JKaIXMwvWiU+MWzH7BSDeJPf5HD2vG8nP1Aq+YnfR7PZ6Kc3qQBgG9Hr
	EfnJTx7XNG6/7e/W/wPDknqG1k3Islvl3MVt+ZfEqNN5ePW+beOuGIiLobtKAhZ+sVWuw5
	I/7w2DnA7VeiY6qcx/CHzprFryphwJg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bosc.ac.cn header.s=default header.b=GCHT1g9G;
	spf=pass (imf29.hostedemail.com: domain of guoyaxing@bosc.ac.cn designates 115.124.28.195 as permitted sender) smtp.mailfrom=guoyaxing@bosc.ac.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816187;
	b=hhfWclX/x6jFfA/oIixjmY29LG7tTElEZtarImj6C0o3H2J4CrgtJjQ/72Tq3+bTBXLBIM
	uZYVhDEaFukHTFpQnmil+OvytBGwqT/dTTEnYGruaQLlhK8VlubuaWul4wjbhl7FrhJfYA
	V9FUfQev6iIoCBexyocgBmUD8UM+bq4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bosc.ac.cn; s=default;
	t=1787816182; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Zj1CGUu40u6mvDQVh2yoztBvTyR7+rnJQenMhLHVZow=;
	b=GCHT1g9Gvkh/dKN3pad+EqdHxrGp6yQlJsvFd9KvJz8QcE7/k3a6SsUrXamIWQAuvfqb4Q8aeAuvHYFK/i9hWGwNo0goP5y7IMq5LNRjj4K6goQfkxNEsfeaiSNWmhTnJsNzBiepAM1ebHNwXwPwjliZhVa08DaZekj+EqIchNvwNR1K6RZLydQdAU1xGbGwy4CDlMVjRNVfoJsTMDYIZFL7yw1vd/bC4egmLiAgvd3zCg0YBtYS4fUALND63QjbozXBzyRdJpfvc6WCNrejOnIIX6jTg1qJjVQxmaVSqtLHhuKVn+CG3cZOePH60dgLZskwm9ZgLqJUUF0S8qStlw==
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07437934|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0491107-0.0354629-0.915426;FP=4643906214911627698|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037006180;MF=guoyaxing@bosc.ac.cn;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.izBQHpp_1787816170;
Received: from guoyaxing..(mailfrom:guoyaxing@bosc.ac.cn fp:SMTPD_---.izBQHpp_1787816170 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 15:36:19 +0800
From: Yaxing Guo <guoyaxing@bosc.ac.cn>
To: Paul Walmsley <pjw@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	guoyaxing@bosc.ac.cn,
	Zhizun Wang <anzoso@outlook.com>
Subject: [PATCH] riscv: mm: Flush vmemmap TLB after sparse_init()
Date: Thu, 27 Aug 2026 15:36:02 +0800
Message-ID: <20260827073603.141426-1-guoyaxing@bosc.ac.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3nhws4ctoaqx3q344fsybi8fmi5gd5g4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17FE7120006
X-Rspam-User: 
X-HE-Tag: 1787816185-792262
X-HE-Meta: U2FsdGVkX1+W93xX6l2HWfG2EdZthl5bWcBoxDz98WFgvUEQjFfAcWQoS9LTBWVWkWUED9nlWGoVJ5fV5tsWx2uTKT0EOj2NYSgONz0JTo109StmYKDLIgqoxBMNQP8dFw9SAF7ipPdpZiwmpxwi+gxWjUSBmuZNC2wDXbwvkrGtfe52h4QAwwQcIpIvsGaSDUGMjgmcA7NkAb1GvuflHfAac2P/qzDrTOHdrdgvXkyTGZPbSk0hhsdfrVPH3XIsQNzotNMtR/W1qpZdUmupDDbXqoKJ1Znfpe7VdAwqDELDYZkwBTDkD5syHEErYwtd0+9WTlA3IjjZV3yWPHBhjnNEgabHnCtpfkR/p3R9O98mqPnjIdbvnEXHs4Or1Ztjc1JXNdiSqHFmKUCqIOMYl0X8RUbrqvuXrO9FFacPJQcd+I9NJyTeK+MFbymW/MOJ1RYlX/9f/NeWJ2o6LE4Y2V9/htvqv/4rXEgIA2FfUzKqRPJNfQg3Bk60FFyHF46Bin1y2SQigVrna2Tv1de7tlGr3Qg/c/kakcTQQQPuWFvI6/FFiwgyy9eGfo4LxirE51uBKUQHYZAIZiBES1kkayc94YBVgLsQ6YXbkSszJZCIPLcxY6Rkix8T2aid7OSDHetfgYDL8zNr6olGs+J4tUqv0nkPEw+HadS+SA6hMweZC4423IUrbM19a7fFZ8YIJIGYGbxa0qk3xZThV3kMRbUlDcyNTCxJ4sPt9nXEHdaGLGoPIGpjK9X5ha0XlpLHcMoIekLV4X95OBl7vT0jhAIujB5B82MuJ27Z0JtmymgnJTdtQTVctCt8sFoXqLZzDgtDJBewB3VKu6N2T3eikHh4z8J+9R5Q0xfVx0WTzGsaPKjIfxsdpM4IGp+albtLzWOhpzPzFvBY3A5g0k6AEQ2jR5knL7BYRiREyBTofDgzkzP5tor6c0/dXiDhRKuyz132KGvaJUuG9JnuMmu
 i2/kgs9u
 Jt2W3mrDwtDJuk3KeVWiztoeTLL80/yNwfd66q7h7STaunF7FUyyUEcFmHFflpkc0+K00nG3e9+knkUYh1HAZII71FFXYeIKtVuCSFxO/raqXIOWh4l0noG9E1Xe8/LC2cV/o+cP3PNkwhI7YDZOVnvS2E9wVcEHlM8iylgZmPIgfLUsfxvySI/6FnTyeySXmDbAecxtX9F+t5Cy2gz550dGnSjUs7mvqqFbjz45el+JzF5yVCxmp5xzVobl4eFFvPZBa9MutOw2scUGhRvXFT85wFQvQJC0XKA1a+7F/9HtSvUuzh4mDsfonv6vxMTFHnjbtEG5IsSEL6seP8bOn86SV4/TRTwrcwDQYq3vd+DGkZRFCsJN9p+BHzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE
memory model") moved sparse_init() from RISC-V arch setup code into
free_area_init(), but left the RISC-V VMEMMAP TLB flush in
misc_mem_init(). RISC-V now flushes the VMEMMAP range before
sparse_init() populates the vmemmap page tables.

RISC-V supports caching non-present entries in the TLB. If a hart cached
a non-present translation for the VMEMMAP range, installing the vmemmap
page-table entries is not guaranteed to be observed until an sfence.vma
invalidates the stale entry. The first access to the corresponding
struct page during memmap initialization can then hit the old non-present
entry.

Call an arch hook at the end of sparse_init(), after the boot-time
vmemmap population has completed. On RISC-V, use flush_cache_vmap_early()
for the hook. Unlike flush_cache_vmap(), which can defer RISC-V
invalidation through the new_vmalloc lazy fault path,
flush_cache_vmap_early() maps to local_flush_tlb_kernel_range() and
performs the local sfence.vma needed before the boot hart accesses the
new mappings.

Observed boot failure:

  Unable to handle kernel paging request at virtual address ffffffd8002200038
  Current swapper pgtable: 4K pagesize, 48-bit VAs, pgdp=0000000083006000
  [ffff8d8002200038] pgd=0000000081a74401, p4d=0000000081a74401, pud=0000000081a74401, pmd=000000007fe800e7
  Oops [#1]
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.1.9-g3846b7652eb2-dirty #18 PREEMPTLAZY

  epc : __init_single_page+0x2a/0x128
  ra  : __init_single_page+0x26/0x128
  status: 0000000200000100 badaddr: ffffffd8002200038 cause: 000000000000000f
  [<ffffffff81621e04>] __init_single_page+0x2a/0x128
  [<ffffffff8162286c>] memmap_init_range+0x218/0x284
  [<ffffffff81624e68>] mm_core_init_early+0xe2c/0xf6e
  [<ffffffff81601188>] start_kernel+0x7a/0x612
  Code: 0385 3c23 fac4 8ab6 1097 feea 80e7 3580 8513 0304 (bc23) 0204
  Kernel panic - not syncing: Attempted to kill the idle task!

Fixes: 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memory model")
Link: https://lore.kernel.org/linux-riscv/7B0CB4ED-C190-4F49-97EE-E1F14F08DED2@linux.dev/
Co-developed-by: Zhizun Wang <anzoso@outlook.com>
Signed-off-by: Zhizun Wang <anzoso@outlook.com>
Signed-off-by: Yaxing Guo <guoyaxing@bosc.ac.cn>
---
 arch/riscv/mm/init.c | 13 +++++++++----
 include/linux/mm.h   |  1 +
 mm/sparse.c          |  5 +++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index decd7df40fa4..200a058e80ca 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -19,6 +19,7 @@
 #include <linux/set_memory.h>
 #include <linux/dma-map-ops.h>
 #include <linux/crash_dump.h>
+#include <linux/cacheflush.h>
 #include <linux/hugetlb.h>
 #include <linux/kfence.h>
 #include <linux/execmem.h>
@@ -1325,14 +1326,18 @@ void __init misc_mem_init(void)
 {
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
 	arch_numa_init();
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	/* The entire VMEMMAP region has been populated. Flush TLB for this region */
-	local_flush_tlb_kernel_range(VMEMMAP_START, VMEMMAP_END);
-#endif
 	arch_reserve_crashkernel();
 	memblock_dump_all();
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+void __init arch_post_sparse_init(void)
+{
+	/* The entire VMEMMAP region has been populated by sparse_init(). */
+	flush_cache_vmap_early(VMEMMAP_START, VMEMMAP_END);
+}
+#endif
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 			       unsigned long addr, unsigned long next)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..5a75b69296cd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -46,6 +46,7 @@ struct pt_regs;
 struct folio_batch;
 
 void arch_mm_preinit(void);
+void arch_post_sparse_init(void);
 void mm_core_init_early(void);
 void mm_core_init(void);
 void init_mm_internals(void);
diff --git a/mm/sparse.c b/mm/sparse.c
index effdac6b0ab1..ecf1b2510fb3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -309,6 +309,10 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
+void __weak __init arch_post_sparse_init(void)
+{
+}
+
 static void *sparse_usagebuf __meminitdata;
 static void *sparse_usagebuf_end __meminitdata;
 
@@ -446,4 +450,5 @@ void __init sparse_init(void)
 	/* cover the last node */
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
 	vmemmap_populate_print_last();
+	arch_post_sparse_init();
 }
-- 
2.43.0


