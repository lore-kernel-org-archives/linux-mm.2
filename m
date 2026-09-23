Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE748C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D296B0088; Tue, 22 Sep 2026 22:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D050C6B008A; Tue, 22 Sep 2026 22:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD3C6B008C; Tue, 22 Sep 2026 22:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 944DD6B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:24:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CECA40679
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:24:48 +0000 (UTC)
X-FDA: 85243433856.16.8A02E70
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7BEA4140003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:24:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sDgJie3T;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89+U8KAEwLqIX9mpcp+eoIG3lsJI+yoRSssy/pmscRA=;
	b=U7tsiJICjo/woZcAkdvLXrjai0MHNWy2durxYfZmjVnkTIf5+AeV4nTvVGbgA2Gc+WcNdo
	EKZquiUbfY9KrmalmdAff0Dph7IkcJ2Qqhg6uptZ1mZT1YAVMNsi/Q34mGZ2gyn/voWNbv
	iJ+fWRLFZdB8z+3X+59CIdPwv7JbK3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130286;
	b=BpSq/99tr8AKUWRrkuUYLZHX4sYArpLbDIdMmTtNKoqBCWqoHDKxMFhrGA3sHFsAcL+SsY
	lQ6AWX3wnIZ6uPTU546gu8pN5s0mH8lAwP4bSESh+xKCWSZXvMtxQik74Nkp/LGZAW2mF3
	vqVEzeYXLaDCYAwdI30nQOXR+FlFUa4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sDgJie3T;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=d3FVAdMqEDWFoCMHxuxCTxk+fOdRBfvFdCrMB1cIOo0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790130285; v=1; x=1790735085;
 b=sDgJie3TWH+fdw4bP6AFL2R01tqn+weltrhVYfbvKl/ZicGlcDHYgmQQA1cpzDCeEmLO6ipb
 iqxgjthgdfUmW4p8oo/f9rSxjGHmq7xg/niFAEbe0seoUnYPui5S0vth/9PAMtGIEyB/QXMx88W
 Z6r0R3UbMASmsfgCjk3a01GM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b86f8e4163d69484;
	Wed, 23 Sep 2026 02:24:43 +0000
X-Mizu-Trace-ID: b86f8e4163d69484
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	guoren@kernel.org,
	bcain@kernel.org,
	geert@linux-m68k.org,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	shorne@gmail.com,
	dalias@libc.org,
	glaubitz@physik.fu-berlin.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux@armlinux.org.uk,
	vgupta@kernel.org,
	monstr@monstr.eu,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	davem@davemloft.net,
	andreas@gaisler.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	ysato@users.sourceforge.jp,
	shakeel.butt@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org,
	linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	hughd@google.com,
	qi.zheng@linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page table on collapse
Date: Wed, 23 Sep 2026 10:24:36 +0800
Message-ID: <20260923022436.61930-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7BEA4140003
X-Stat-Signature: 6xdkr7oyyu68ys3r7bid83wsqauf9rff
X-Rspam-User: 
X-HE-Tag: 1790130286-501720
X-HE-Meta: U2FsdGVkX183cFeSkT8dg/Bc0Zj1R5E0mzLPHtx1PG5/AZ50QLCrOacWxmH/fUiK5r68ZGvU1y1INGRTW/SEXbiXRpdDsmRcsovK+oNjytNnwREJEXLWCSHaMAoW8VwBFPqkvLNpDOdRmv9Zdj3/HXmI5NF24mK4846PDNYttz/yn+lgKl8s80XiquNllL55Ie9LbmNCAgIDE2Koq51tGUgIpueyKFi2r9+05pBbKSZik41UFSN2zARvY+t/2Eli+zryRycaOEHzKHOoF7YJJb0vlpnFBxyGkv1EchvQTpvztd6nK69hOHLTzvzdZ9UlhQhEY1WLBzMWzyfNlBU3KPOZJnUR0fz9YNYCcu0yJjUKKG7rKxKDiYvKODH7kAbnAgeLfPsbWDqUIev2u2kXuq3WRNYVxjFl0t5g+ZoznE231h44hso9/UbKH8asda78ICgrG0T0WgXlrGZriJ/tkRp5YhMP1LDeRv0QzvRu3ZVc9rlrj8dMbeMzn68pfwpwtE8l0Wim0XcjC1gt0p3dm7DVYFr2QmR1PB61nBsnwKePUJz1lkmA5mTHPk1jiRKd+nGtnkupKmKpeX4V00YKWvcv65+Hjvsa1OSfDH3z/dz8z3l94kXCFfE+itNr1hCkYl3RxDgbPtGSNp6au/MI+kPIbe5GmvnWQ0f833qkv9de2IY8KTuZP128mZyrWESkmXK/wVzvDscr+FYs92bEGzy8j5GIMYOhfFeRNuKHGIf9I+R9P7jcyULhBGcqS1ZN0ylgeOiB4uvrF5pn20NKcEIw6Fbw2Ocv5ma5iV9Ouz50/MwYHeBCx0ImGQdHY7lSEp738QKSnU7W3wV/tunjI+LpXiNAEqDh6rhxLWyMuk86xpEhT80LpYA/VW5JyWVF5MlDRGO9uuX5Gx2Zo3kX4ZVSCWyaNqA3V7OeGd/ZI7d9aCd7Y3lCsLo0aNTn8Rn4PCnvi3YpX+lRjQUdziu
 fXUAODGb
 MD42EDPnQ3FtHSetwiiCBfjSmW+VYBM8EsOnPnAbCwLVIoGOl1LJtiKbugBHZsr+df/iHgGuZOiNloMBsk/eHQpQpbtDSbuk5wwD1FBCWi3B9zY/9U50H0YjzgPcYu/CZfwI6fb1N/aPbutL0ilWPy0kPbaijBas7nm+w/4oAM9+mJeJLoYfnKUsC7nDqVqWIFNw3Y4K33iQwj7RCkeetrYD4kavU/nPHA8iWt7//aKsAMV+IXZmlo95LNdlRG6MydtSNHbXG7DtbTBDsjeb00BqqO9/+Cv+EbPQtfb1JEgYKl1qFu2poTo6qugPbO9oJJFdoVA4MSgz65cE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:32PM +0100, Lorenzo Stoakes (ARM) wrote:
>collapse_huge_page() deposits a PTE page table on PMD collapse in order
>that it can be utilised for subsequent split operations, meaning that those
>operations do not need to perform an allocation (as they are in a context
>where it might be unwise).
>
>However the PTE page table which is deposited is the one which is currently
>mapped by the PMD entry that is in the process of being collapsed.
>
>Once deposited, the PTE page table may be used in a split of any other
>unrelated PMD entry.
>
>This is currently not an issue as this operation is performed with VMA/mmap
>write lock + anon rmap locks held, so ordinary page table walkers will
>never accidentally end up walking the wrong thing, and GUP-fast is
>protected by an IPI via tlb_remove_table_sync_one().
>
>However, the series to which this commit belongs implements RCU-safe page
>table traversal, at which point this becomes problematic.
>
>This can be resolved by using pte_offset_map_lock() which gates on a PTE
>PTL and a pmd_same() check, but lockless walks are unsafe as things stand.
>
>Resolve this by simply allocating a new, zeroed, PTE page table to deposit
>at the point of collapse.
>
>This path is already costly and an allocation has already been performed
>for the huge folio, so this allocation is statistical noise in terms of
>performance and memory usage at this point.
>
>With this PTE page table deposited, RCU-free the existing PTE page table
>so it is safe for page table walkers to traverse within a grace period.
>
>This also brings this deposit case in line with all other page table
>deposit logic which deposit a fresh page table.
>
>Additionally, this was the only place in the kernel that displaced a page
>table like this, so eliminating it also helps consistency.
>
>An edge case for deposit exists for powerpc and its hash-based MMU - it
>stores hash slot data in deposited page tables and zeroes them on withdraw,
>so a zeroed deposited page table works correctly for it.
>
>Since khugepaged runs as a kernel thread, do a little dance in
>alloc_deposit_pte() to correctly charge the allocation.
>
>This is already done for the folio allocation via alloc_charge_folio() but
>no such wrapper exists for a page table allocation.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---
> mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
> 1 file changed, 30 insertions(+), 2 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index f49a6710933b..dab421f8233e 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> 	return SCAN_SUCCEED;
> }
> 
>+static pgtable_t alloc_deposit_pte(struct mm_struct *mm)
>+{
>+	/*
>+	 * khugepaged is run from a kernel thread, so need to manually set the
>+	 * correct memcg so the allocation gets charged correctly.
>+	 */
>+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
>+	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
>+	pgtable_t pgtable;
>+
>+	pgtable = pte_alloc_one(mm);
>+
>+	set_active_memcg(old_memcg);
>+	mem_cgroup_put(memcg);
>+	return pgtable;
>+}
>+
> /*
>  * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
>  * will always return with the lock unlocked, to avoid holding the mmap_lock
>@@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
> 	LIST_HEAD(compound_pagelist);
> 	pmd_t *pmd, _pmd;
> 	pte_t *pte = NULL;
>-	pgtable_t pgtable;
>+	pgtable_t pgtable = NULL;
> 	struct folio *folio;
> 	spinlock_t *pmd_ptl, *pte_ptl;
> 	enum scan_result result = SCAN_FAIL;
>@@ -1310,6 +1327,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
> 		goto out_nolock;
> 	}
> 
>+	if (is_pmd_order(order)) {
>+		pgtable = alloc_deposit_pte(mm);
>+		if (!pgtable)
>+			goto out_nolock;

One small thing: result is still SCAN_SUCCEED after alloc_charge_folio(),

	result = alloc_charge_folio(&folio, mm, cc, order);
	if (result != SCAN_SUCCEED)
		goto out_nolock;

	if (folio_memcg_alloc_deferred(folio)) {
		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
		goto out_nolock;
	}

	if (is_pmd_order(order)) {
		pgtable = alloc_deposit_pte(mm);
		if (!pgtable)
			goto out_nolock;
	}

so if alloc_deposit_pte() fails, collapse_huge_page() returns success
without installing a PMD.

I see sashiko pointed that out too :)

Cheers, Lance

