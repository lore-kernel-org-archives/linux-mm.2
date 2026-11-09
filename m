Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EC9606EEBB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EsUYUXdr
Received: by kanga.kvack.org (Postfix)
	id 99EDE6B05C9; Mon,  9 Nov 2026 11:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EDD6B05CA; Mon,  9 Nov 2026 11:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0316B05CB; Mon,  9 Nov 2026 11:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5756B05C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE67DC0721
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:50 +0000 (UTC)
X-FDA: 85416046380.22.961B998
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA047C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EsUYUXdr;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240109;
	b=KtPGC7MKeG2lvplSmP/dRUayotZeDHhJEPyzMEsMpZtHpyywx43tnDuI+gPWce207Z0RBC
	/akwn520K0SLA1dCtTsBeJkGryy9OB6y0xH5gDVZ/0Kx2E344yuAdXxKQ7598TRL9Y26Kb
	e4qvWOi6ytDQ1coneAMyFel/nKFFoBM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EsUYUXdr;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwD9lqFi3lP5XHrWQt/AOW6SRyYfneOldinY0XtaIdA=;
	b=JW40Sd4iRYOf/WloLaSfUehY3hmPjNfTU6G1DS6y/1m+S1NDcxdZzx/7AHQrH+DEP1B6H4
	WLzfmyuS4qRWnz76BYwtnWhxnVepgBvEWOOGvw/Qa3ulxdgkK0gcHr2dAuRjvjVtCGVnJe
	46sbOk3mxWwxw4iNykKH7bVoC1xzk8I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D783814BF;
	Mon,  9 Nov 2026 08:01:44 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07F7D3F632;
	Mon,  9 Nov 2026 08:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240107; bh=LL3TBpqLpKZH6lBVyCZn6T3Prq9VMXDK4K5G18uGAf8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EsUYUXdrXAen2v49OhDgKotRMKa6Qb8c1Z3+90GW6GbfrYjTYC1rEvsnnmUH+t+v4
	 W+GMn8L5sssE0Gm6pvLJIXFhKGZStMWkreLuGLf33FzjZRtj1em84Gy5t5l5etCECj
	 gly7xgxXHWBFCoVjR8S8g2uFifzTm0NR2CmRLRLY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:39 +0000
Subject: [PATCH RFC v10 14/22] mm: kpkeys: Protect vmemmap page tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-14-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=4616;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=LL3TBpqLpKZH6lBVyCZn6T3Prq9VMXDK4K5G18uGAf8=;
 b=i4ynNlUXMktda2i2JO5mNT9NsUhl50VMi2aYOXHiXBUN5YsbKykwex+lk5I3ZNHSnDyK1GmSV
 C/YDQMmuIbwDEO4xzjKcFip2uUBetbYzO93iBKDkWbO8RTL8gy9DNq1
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: j8r17f8dr36ppcfiwixn1bc74g3k48e6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA047C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240108-203959
X-HE-Meta: U2FsdGVkX18mEpHoQo6zuV+m4j81ABVwlycgCKS2siOmwZ++O/s4wHMSEqJyvi4XgVQ7bhB26aa+szbilbzTu/Uiz/YiXVmClwT63czWqrHCGYUYyw1Bky0MIELhRNrO/2JRjQqEKIsl8l7xJY9qekhpng0nVPmMVDroYVW7bHQJgyaOPePJT+lYm95jmjPjHj7mjlgi9omPVFUqPTRpdz0ksyuqLuQo1FN/+oo4LMhb1+lOArWa+q0Ap4DYb5NZKS8AcMoZbgjm1OiidXjrdEmYAPZPfiEPPuU5QvD0i5tGK1M+dhqttH2oafH6/gHX9Go+vfs/zYRHDpq5KMFP3H4iw+YtZV6A6O9um+C+Y3Op8AJ7yuzQ5I+wQfMkc1GbVUZ6lkFzCjWVLQifN6tRByU3T+mIVgsjqvrns55ldyO3WiDLDYc3uKnyj0j5Y7gpDYi2tZZxAyKimI+mvVZWc7agA/IW7/jsD5b5+u1S9GrvlWSiwQf4T1vBhMmebZoYP5GSwP3q3ZGozGn2dgUc9WaUh/uVVxURXhJZYJ9z0nvb2zup+lgfNkeW5DyFadqA0O6+psny9BMvtyX2NGe1j8AYuAmhK4wXMmvQM/wBZzTQVthCB/Ow6axG6yTbZEJ2Pkmi5OPOtPgoiSbDOw1e6+tznn5lnbaa8cAXGioykI/i5IUDo4rUcojaEpNH9X/BbIO5dE3emh1F/mEs/lbHiZM0u+RKSUKEEH30gg6TN4qHAdqGLzaLcbeaI+xlo5IAk3XDVGmQ/bAEsPVcUC9i1Qm8C0qXoQ4hax16Iyrn7ptZQlHXpkobcHuXfisVww+js9BXDDZyKwukiNLKq2RLOrBd08W+ad2OiXrburSOena6Co24Hpo2YnTT2Lue5th92iKhlnwvbULe7uGUU+N2oiwp1/1GWf1BMZYd6p54jJFGNHUI6r/D7HqlInR3R6fxrV2uU1M3HbIDfUMhbkF
 FBee49m0
 tpWnQq7OyVu8clO9Z6kNQ50r2Zo7scPkgOsUDT+UTea9sRVODUO5xtJKOUjzFd/j/xVpVtERr1iYju8qxwUgd5J89KEUU3vem/u9DRenidxhV9SNeNQbTa5WQ8lRl0JW99KO9g6SvoAvVwsT+EgXhNz7PzAKxATPMewZCEgd8RR0IDuEN+IDFEcwBrLkS3cCAhsKOzeNHFzD7eekhM3szGXM21nSyLObOCS1UfiYbZgrQja4hI/2uiaYMFSpJoQtGh/L3hNph43PAhtvVWqwvQYyiK3M5hKh5RV+0bg+TgrcgOZdomi81Bw4zs32vsRFDq/bcedCLFxlLo+hjRWsDQ8dsdkyxtvKIs/0v8crjXjB5pZXKF9Bi7SukL7GmipA5CwmKl7HzB6mZG3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kpkeys_hardened_pgtables feature automatically protect early
vmemmap page tables (covering standard boot memory) when it is
enabled.

In order to protect late vmemmap page tables  as well, allocate them
like regular page tables using pagetable_alloc().

pagetable_alloc() does the right thing to protect the backing pages
using kpkeys, but isn't NUMA-aware, so the pages may be allocated on
any node. This could potentially incur some overhead on large NUMA
systems that make heavy use of memory hotplug.

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
  ptdesc_set_kernel(). I sent a separate series [1] that partially
  addresses this, but more work is still needed.

* x86 allows boot memory to be hot-removed in some circumstances.
  free_pagetable() should handle this situation by resetting the
  direct map pkey of reserved pages.

[1] https://lore.kernel.org/all/20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com/
---
 arch/arm64/mm/mmu.c |  2 +-
 mm/sparse-vmemmap.c | 23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6a2155db3d05..a61ea65bd496 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1496,7 +1496,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 static void free_hotplug_pgtable_page(struct page *page)
 {
 	pagetable_dtor(page_ptdesc(page));
-	free_hotplug_page_range(page, PAGE_SIZE, NULL);
+	pagetable_free(page_ptdesc(page));
 }
 
 static bool pgtable_range_aligned(unsigned long start, unsigned long end,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5d7e982f94d0..c47d3a016891 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -150,13 +150,22 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 	return 0;
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
+	p = vmemmap_alloc_block(PAGE_SIZE, node);
 
 	if (!p)
 		return NULL;
-	memset(p, 0, size);
+	memset(p, 0, PAGE_SIZE);
 
 	return p;
 }
@@ -305,7 +314,7 @@ static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, in
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		kernel_pte_init(p);
@@ -318,7 +327,7 @@ static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, in
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pmd_init(p);
@@ -331,7 +340,7 @@ static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, in
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pud_init(p);
@@ -344,7 +353,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_pgtable(node);
 		if (!p)
 			return NULL;
 		pgd_populate_kernel(addr, pgd, p);

-- 
2.56.0


