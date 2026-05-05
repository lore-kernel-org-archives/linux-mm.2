Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FB4FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D206B00D3; Tue,  5 May 2026 12:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DFD6B00D4; Tue,  5 May 2026 12:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D196B00D5; Tue,  5 May 2026 12:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F03E6B00D3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DC3C1604B5
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:10 +0000 (UTC)
X-FDA: 84733847940.02.ED7A5E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 35145180005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pJt30ocT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Xyn5XoOjkjqDQ4VGLdzhPurEWJfnoMvIWNd53Fbzx8=;
	b=2uP93x7HVN/f6H9fU8ofmzGVIAlp1KcwTB5yj8Lavkhx+YJZE/zlBx75KMfLYFs0Ci/9iO
	8OUE3mWxHk454Cn0rPaaOYyC6+E/Pm2GvMMXlbOYywHsiL03xNyxg1mhGgBqLeyahIH5/k
	F26onQFOwDvZy1WMruVomOlZx/PB43c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997288; a=rsa-sha256;
	cv=none;
	b=zQ2QiducJ0FE9bcip2WLdck6CSa3cp5FDbR8E0HV1UddqpBv83Hg3GxFsJfQQ6Lo/8XFa1
	/oVMQizUy3uqg7/aTLtQUaq+9uGTIfCRp8l5kMcyMcocQU45wDt8x6Ne3RWDbe4Ch6pEEl
	OCYrU0I9UFnrxObFO3adGQ1Ff2ODsaM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pJt30ocT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E294E2681;
	Tue,  5 May 2026 09:08:01 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29F193F905;
	Tue,  5 May 2026 09:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997287; bh=PHibZSTZ+M49JBQ4ek0CSdAJ2no6ww2ow8catbJRkbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pJt30ocTXb7hE3yyXbYT/nSgcR9UGUgOhCrLw1N3ELE9tv7VKn9yqPIGkenp5OBxD
	 lj0a0EN2vzEyemi5amPKyxEWoByxWzuAMzvvvnb+vE2s+djQKhWqcy4M5gk+WT+l6y
	 KErmv1Lg62LAOWaupMVBcFI2wyMSxZAv2SJS9BaA=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:03 +0100
Subject: [PATCH RFC v7 14/24] mm: kpkeys: Protect vmemmap page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-14-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=3365;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=PHibZSTZ+M49JBQ4ek0CSdAJ2no6ww2ow8catbJRkbA=;
 b=tgzTvZYCgZKHtLvh8bIbz88J3Sv+Gfhv63Gz+41QPPK0ecs+LDqfcfVQJszRcWPf09gQS/R2H
 Qy0ZIBKMqBXAfXZvmpbDux3ogpELrzjrv18rcm/SClO23PGIj/3dmFA
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 35145180005
X-Rspamd-Server: rspam04
X-Stat-Signature: bkoqsj43awbdn871mfumb3cya8qhpqwq
X-HE-Tag: 1777997287-808771
X-HE-Meta: U2FsdGVkX1+G2Yrz7DqeZiW2rMGQwJ/qnO7K+mjFYLQoqOejsC1q+WYr6jhMo+yOHDpsca38O6+u84Ate85sri6ukeoUF3756mKIbUi/BLhijYtPUENjvdZr3+mfoR0h8GCPZ+2Pq/hKTfwMfHF+wT3L3o1Z5+ApRFLYDcjoVp47ThEZbd/QU+rMo4cO7tUAEaFlgLNgxZo4D3nRxT3iJbbJ8LbyTHKR3XeL0GuxI6CDtUnKUcyLfbKaBkcTljTn0QGGDLY4eOPGOT/3oYkbkNhCmDxKyzoczl2Lv22x+QVn9FdiCpeiJDFaUg32Zh4LhwnGzV9LWOGJhduHyTxSFXfCKPnHxNjxcBrb1mUhxFq9xPoPGI0CoDYCnYpydqlZTNk+ehrNbqULHE/mOv53y/DEThM2yxXJlZ3EsnyB43aH2jKHQVA9Ol0G3ibVkBIHEZvJ+1by79/5zEQBBZOaW5KxYCCTY4Qswooz3AZ531ZakoumSuycWbb3G1eJR2xRnziZxJ4uBCo40PZRO9VWOL/uK2q0erdnXJDMX2V1gdQRkfmS7yOJdOItLgTAz8RIYp919W8ukSDyE1exPniYTl1+iTUBf8vm93qpaxCqDunTJXBa5vRdX0918kZgXh/X8dtepkHY8S+Wk9pSbHNh4Jss2rCUaFBOErMotpsJGlKfOC1ccmFypnn7PxCFDRomiXgHkx1cxn2iq95910YBEXoMNqOXv1i83H0TetR5aTKViBqUEHSPkfVzVrWOLgXXdETmBgwlexILc/2ehaOQy6JyV/jKjxsiqxtvPKW3H2UrHRcQ7Iwsx434XZflZ1PrAuBVCaWf+zD80HqRYkz5uYnKNyHjZ60VR6PMPeyA0L91dReASSmqKF3IUJZjfGHFTaCdR3sjWAXq+blxGZEAftid6CyOZ43SyjVdHKRuVYTkbnbuOx5ENntq6GIfEzmDjrgjDox6dmF92x18zQo
 Ho/H7MkE
 VqkiHAAHREHeOUmrzYInBVeuB+u7N1kjw/22n0waYMbopPYy3Pzq4whF/BP7OGm/DI/pXlVAX5dwKMSAhWxE4l5V7M5PalcZMvHsn8l7mpuWjqUindv/qjzM/UoLf9sLsQOL/+PTHofhyJjL+C+WBd6mRUAPLZvzRcmjtBofuKpfWKO6281dlGJuCPAXyVR332XTQLHZ4aItzUwK8+NhRMSmxxqru/OG+hwyAfi5Sfx8SR0UU+xJ410cYHCfEqxMt25dx
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

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

This is a minimal patch to protect vmemmmap page tables. More work
may be needed here:

* Restoring NUMA awareness

* General refactoring of how these page tables are allocated: since
  we are not using the standard per-level functions (e.g.
  pmd_alloc()), we are not calling pagetable_*_ctor() or
  ptdesc_set_kernel(). [Maybe that doesn't matter because these page
  tables can only be freed via vmemmap_free()?]
---
 mm/sparse-vmemmap.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..0c0d3b1e356c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -184,13 +184,28 @@ pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+static void * __meminit vmemmap_alloc_pgtable(int node)
 {
-	void *p = vmemmap_alloc_block(size, node);
+	void *p;
+
+	if (slab_is_available()) {
+		struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL, 0);
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
@@ -199,7 +214,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		kernel_pte_init(p);
@@ -212,7 +227,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pmd_init(p);
@@ -225,7 +240,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pud_init(p);
@@ -238,7 +253,7 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pgd_populate_kernel(addr, pgd, p);

-- 
2.51.2


