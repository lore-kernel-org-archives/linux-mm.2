Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF56FCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395E26B00B0; Tue, 26 May 2026 07:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D4C6B00B2; Tue, 26 May 2026 07:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283FF6B00B3; Tue, 26 May 2026 07:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 178CE6B00B0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D987A1C0222
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:12 +0000 (UTC)
X-FDA: 84809322024.15.569703B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DAB7140018
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tot9zraT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psIx14i0HOMPTcNRbiuxKnGv1CcOZrRyO12qfssHmzA=;
	b=h8jFRPhamSIDBsle17+WGRnI4Q1ibR8RxpRcJ5eJmZhcM0vPzSstK0TdgwoIncsrolkT4/
	TVDJX9A1XcykCFhXwQ630y9D7XnVcAhnqZ0PAMObAR1CkWwH8PlGjpY/4G4GGEIKOhmjij
	eFknFzQxeydZl0bqV3nhLw2OiH0pWqw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tot9zraT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794291; a=rsa-sha256;
	cv=none;
	b=ENFXHW2THPtGGygEHFrDkOTM/XLVSdLaKMCxFhFiBvYNku50QMxXbIwMUxoXuWrBtLex9R
	+qc7QY/nibZAcIs+Ng7fHlHS7eJPuhwJ/3LJ5EuFWjyUUlEZKSQWXRLqwfw+rYZpk17Zhv
	fRNfmiRHWVz4SzMxG2V3tZEuk1J9N8I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 578DC169C;
	Tue, 26 May 2026 04:18:05 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89ACC3F86F;
	Tue, 26 May 2026 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794290; bh=3MEEK8v1bfnLhoM5ox+LZlMLIGtsmSp29MPld+CwMKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Tot9zraTJURJnw5N2IUpFuIBwE+z/e64lle88HA7J+VCC3fLS1BZsjDjPje3s9gtx
	 mhTd1/9PtqQp6F5DyId7iaMHMzccT2G30lSwCXvU+hx3AoGw59oDHndFiNxg82f2NJ
	 PBPHY/gxutAfOHhSVJwJeGW8CS/lQd8p5NIFzRfY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:03 +0100
Subject: [PATCH RFC v8 14/24] mm: kpkeys: Protect vmemmap page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-14-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=4833;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=3MEEK8v1bfnLhoM5ox+LZlMLIGtsmSp29MPld+CwMKk=;
 b=vBG5Zuv3HOVHNsnoNF+3P4kSpu/6WZh/D0smiFfnmmsLBMtBrJLanxEpANJIXWhoUNDd6RFd4
 54dbwGJva/GDdEXzjpQlmcIJ6UIJcQ3zlP9Q8bFLYiyDlIdC7SVJ/N8
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1DAB7140018
X-Stat-Signature: bjzmn4wy4taccdxu7hmqx9kmhkzymxgw
X-Rspam-User: 
X-HE-Tag: 1779794290-406013
X-HE-Meta: U2FsdGVkX1/yNnhFhjT3zeLb/zgrUYK/WHomAxNd698d0gO76QfcSdsmvzBDEqTPTA6LMHXprcbPThiLY6JOqvvZ9YQG7L1xHmLMX9L13/dfIyxzAswk0aNdKr255DBoXcu4363XoWcuJHwYAtirNuKsrgvBtFYM/UPpn/4IvJ3wL3wa5eXJlKxIQARswPlBimOyyWCxXYkUFGwEwcEJ+sNESMsEJ/5wyc6R/Bu+B0JweFIFx5Ns7El8cLA7TkVRfPhSY2VLjHTNOuWHFSRIBoQ5XYEADL88U2P1V90iJSgGchMnRyy9HueqSBuTxRmJSJl7fNlO+Ggb8ArYh5GwSy14G10AZZxSVcPIOuQ7sIFU08FSwdeLymeQyPe06dY2EvrivOlH+ZsOQN8LSrSqEOFGvL3GqSzQdDMjn0DtcxMVSxVmj9ha1VRKPqtcsXaIkNYm4CAtCF9yT2rg+4I7KRmesgRY/Jh3429ptSd58DGmfJJcvvzZdnAXslWH9p3sr99A5rk0eCj8aSq1cCe4AoQ5w5EUKETCV2gyhPNgGSo2nuqxk/z39VDG1vPHfaDJ1kcqmFmbpLYdJ0H4KhEc70LkYbY1Zkw+rX308rMh3uuhwasHfnLY4/K1cfgo4eL4CGgOs4CzbmaIgHDJm24WxMUSDsQvfB2U12qGhSVnYOAXRvCjUBQE2v2t4GAfTG7sw5aNYGUsvbf26eNSYJqFbcYsYW8Yu2XjgU6gBYdbWfFLoTHkj7ATVAm64U33G2i7ptNswfvudO207DxQQCD1XBxllw5YZgVCdV3an38UU8pWqwLqV3TUSxAF8s+6mtGG7BgjiSjMwzwHFvSPOT0yuqSNYYnsZZR3FWYGht7x1+c1W7mUCgdd7eFbIxLewLeCnYxAIjX2uKgkdf2ivukhU2cUWxHz8Y7JxLT55Q6Mvcwb2WNivux57NjS3WFTcXzxAvNtUGvJWIamznkIdK3
 fqIQMv7G
 8TKcL37Ls2feDiHvaobyhg+lgYrWWlnxXhTAcAldGTHpbGCnL8ya2TECNWyxWGNk4fYD6hKaMr8qRCTMjf3ACbEJ2I1sCF0/YiwVkgbFYxAhh7UIXzd7+OlGYrq5PLHW4FhP/FFEaeaJG83nEkJEULJSPqlYyp7EUd7TbphNwdDv8URaskRnvpm9QYlskrcVpCvW1Bfoj0LTRF6dRU8i5Q+1yx38B2gZidD2Zsth+FHxGQdEe5C3zInfVYDosU1sohywy+M0B0MPJ4VZ0Yrcr2/Bw/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the kpkeys_hardened_pgtables feature is enabled, make sure that
vmemmap page tables are protected by using:

* The standard pagetable_alloc() if the buddy allocator is
  available, as it already allocates protected memory.

* The memblock-based kpkeys allocator for early allocations.

These allocators are not NUMA-aware, so the page tables may be
allocated on any node. This could potentially incur some overhead on
large NUMA systems.

The arm64 hotplug code is also amended to use a matching
pagetable_free(), ensuring that the pkey is reset when the page
tables are freed. x86 already uses pagetable_free() on that path.

Unlike in vmemmap_alloc_block(), __GFP_RETRY_MAYFAIL is not used as
it isn't justified for allocating page tables - this disables the
OOM and we do not have a fallback if we fail to allocate page
tables. See previous discussion linked below.

Link: https://lore.kernel.org/all/38d2a358-4146-bfc9-2a4f-68ce02f75c94@suse.cz/
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

This is a minimal patch to protect vmemmmap page tables. More work
may be needed here:

* Restoring NUMA awareness

* Moving the arm64 change to a separate commit?

* General refactoring of how these page tables are allocated: since
  we are not using the standard per-level functions (e.g.
  pmd_alloc()), we are not calling pagetable_*_ctor() or
  ptdesc_set_kernel(). [Maybe that doesn't matter because these page
  tables can only be freed via vmemmap_free()?]
---
 arch/arm64/mm/mmu.c |  2 +-
 mm/sparse-vmemmap.c | 33 +++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 493310cf0486..dc69553d6326 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1441,7 +1441,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	free_hotplug_page_range(page, PAGE_SIZE, NULL);
+	pagetable_free(page_ptdesc(page));
 }
 
 static bool pgtable_range_aligned(unsigned long start, unsigned long end,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..c93f5b9f4a26 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -184,13 +184,29 @@ pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+static void * __meminit vmemmap_alloc_pgtable(int node)
 {
-	void *p = vmemmap_alloc_block(size, node);
+	void *p;
+
+	if (slab_is_available()) {
+		gfp_t gfp = GFP_KERNEL | __GFP_ZERO;
+		struct ptdesc *ptdesc = pagetable_alloc(gfp, 0);
+
+		return ptdesc ? ptdesc_address(ptdesc) : NULL;
+	}
+
+	if (kpkeys_hardened_pgtables_early_enabled()) {
+		phys_addr_t phys = kpkeys_physmem_pgtable_alloc();
+
+		p = phys ? phys_to_virt(phys) : NULL;
+	} else {
+		p = __earlyonly_bootmem_alloc(node, PAGE_SIZE, PAGE_SIZE,
+					      __pa(MAX_DMA_ADDRESS));
+	}
 
 	if (!p)
 		return NULL;
-	memset(p, 0, size);
+	memset(p, 0, PAGE_SIZE);
 
 	return p;
 }
@@ -199,7 +215,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		kernel_pte_init(p);
@@ -212,7 +228,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pmd_init(p);
@@ -225,7 +241,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pud_init(p);
@@ -238,7 +254,7 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pgd_populate_kernel(addr, pgd, p);
@@ -351,10 +367,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	 * memmap_init().
 	 */
 
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	p = vmemmap_alloc_block(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
 
+	memset(p, 0, PAGE_SIZE);
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
 

-- 
2.51.2


