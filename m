Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04962C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34A76B0095; Wed, 23 Sep 2026 03:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5A06B009B; Wed, 23 Sep 2026 03:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB09E6B009D; Wed, 23 Sep 2026 03:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98BAD6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:14:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DFDDA61CF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:14:28 +0000 (UTC)
X-FDA: 85244163816.10.8B19B1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CB721C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:14:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LGAn7A/u";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUbT4b8cpuhzpeO+5wvLG35IoWThWdBXchOpscPEUbo=;
	b=cB3bqHvzhZs9k0lsG8A8STRghLB1wFkQCRCKitlrNzpeaQMrDN90CY77fxiremQDFmMrtx
	YWOG397zKbmWtZj9ne/AEnhrtAW2M/f0EpAchFV6deHUq8qeU1UJlIhNxTJ0wdB4S9E4b6
	N6lVaktafdNEf29d+KBtwg6itf+qrgo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LGAn7A/u";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147666;
	b=LqzkLd/kWQHjJt1FqXlAySaBpNlrGRWdzEGmN47ZsZVCd/0skxQtsHp18/Fi4JfJOh5crU
	pYM8tirBQY7qAWfN6aHBva5b57hbDBAHVCUsl7ATWMU662bQlaJ6wxtPLd68e9bYJwmPNY
	kOjR/tUbrtx7uGdcTCCLcMMcp7CdcE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C12B4478B;
	Wed, 23 Sep 2026 07:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5D21F000FF;
	Wed, 23 Sep 2026 07:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147665;
	bh=eUbT4b8cpuhzpeO+5wvLG35IoWThWdBXchOpscPEUbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LGAn7A/ufhqitMqo1pvJejNQDWdQFSBFm9O5wWGXBsgPApH8MsQd8GanjDi0vOklx
	 JPgYDPGv92XgtwBRRfIxcfedlZc7mxw6avAAAZiYZAWCHR0kQGLCUYDlXWnt5v+Nih
	 LrsMIAfrHao5oCPNM8rjGlCjqcZeY2jbCE7wVS3dd2Ur8Oq8OWK2URPvFmzGjgOGlU
	 OE2f62zMcsXZqAtjnJkDBOw0xEMR4mVQwmtvwLDo9CW309HQIhS1xawhMcaQlXkyHd
	 FYSeV6pMmios7JXgGp6FMQd67u3MhQvT3u9olACCz7hTHq7EBKXHgWba+J4ldFKNuc
	 H9C4as6GwzkRg==
Date: Wed, 23 Sep 2026 08:14:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
Message-ID: <arN7q5nHz7iebA_e@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CB721C0003
X-Rspam-User: 
X-Stat-Signature: yeyr3m9hdfz7hakgdtyp1c4ye7unduso
X-HE-Tag: 1790147666-992192
X-HE-Meta: U2FsdGVkX1+cpNRRWrxJaIZfoMbkHvWWlbZLZRtoHmSgNgKjJf2dJ5rmaIiZOLHyv7Usf/b+8zlXxdcGeiZQIIiThTv7JDfPipbUvP37afC6vYYo97WAaq80/uwx3st4zPYz35W1D3nhyS3F2PUdM14rMQ2fyMjr3zfLe2IRrwoRbyk7h9ZWKx8nfbdHZs122JBZiG/iwdz8XFkIew8K5fYd9h9tUukyS7AqGox6IaCuKtipJXGMLFeWcS54PcNUoHHa58h9xsoZQsCaDNXBlPNsykuqMEwEoelMfVy2gTCHMMfjj6SPrmjjvth/ifouxfLaW/0MidLvw1uHBQH9PMoR0vjmDy6M0c5mTnW1pZxFZAUICTjo4hRezfZZtbBUOcGl6WRUi+53amEg5wuJodRp+XuOds1aZKCwjbH0QfdJyf2Yq2cs004YC+8nuHNpxKnvMqHBzlph9vtZ//YH0B7MEmiHI76Zo7npSGD7AIKlSEmbqg/TNwmDD6z+Xk7PDu+6Y/G4aUHhaxqwbxVxkRP3FpdwRwFhDtxHOcwfRG1Pup+SS/w7cE2k0nb4DDqiaTO3TxBVL2WmIxw4FZR1eZ2cPGy06vW9OLgJw6x5q46icimWv4r+1lJXCj6YRcnt+ngSoM3aTWLUsagIzSS2/JV7voc9LPc21cBysIE8d9Jy5gg40XKDP7p4/IVRP/od4HUNwwDoKVtkBftN9Bddft4jYbY4jg5JRNtunhAcDiTA5nu92qqwB9M85385NfdPZF/1NZMAQXnaYKuAph2XD8NVfxj13tTObKaxGCts0JyQcgkPNnjAlZ2chmYlAo3NOyhBOBg5AdTlQIG2Z7zK2x3ps1968y2ySPDPaz6lo/RFqs9W63DLVtQ3cdg3xn+0l0BCOJWt2hCWU46AeNPrXAixNgNVnH9TfHeikEui8hONFM1MDWMWbLKk+AdZ+ip3oDmaYho9paoHczk4PN7
 C60x+qJL
 k/OzGopnbRfLEQv8w8EObOS/GT9hiO4WojwxuLmBXD3e41z2GQ0sobGBeFwDifoCe1pCBrXjZX7BQynIwWKi2WuWUE13gtmY4RrINSgfHKVt0CZVpPpGMHHM8esLfpya/viSuWF9jffsCKxyQ7wd2Ze8ypYtPJstLA5bgaGBYt+0voSo+FzWqe9QOSVDQ0PXD1sXcGAXmhgbiFNKuBEw0W0YANaLvdZNkVA9Tv6ql0OFfR7K7hn3dARbqcHya8jTcTWZSiX+nYgbjng8UOTcvtH/pt5OU5atmV+Y+7pYFeOTOl/BlB0pFWksW/nM7su7iyNS34SxGG0gXylwPGj6ZXLVaRsyG923WYVle
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - would it be possible to make one quick fix up below?

On Tue, Sep 22, 2026 at 04:35:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> collapse_huge_page() deposits a PTE page table on PMD collapse in order
> that it can be utilised for subsequent split operations, meaning that those
> operations do not need to perform an allocation (as they are in a context
> where it might be unwise).
>
> However the PTE page table which is deposited is the one which is currently
> mapped by the PMD entry that is in the process of being collapsed.
>
> Once deposited, the PTE page table may be used in a split of any other
> unrelated PMD entry.
>
> This is currently not an issue as this operation is performed with VMA/mmap
> write lock + anon rmap locks held, so ordinary page table walkers will
> never accidentally end up walking the wrong thing, and GUP-fast is
> protected by an IPI via tlb_remove_table_sync_one().
>
> However, the series to which this commit belongs implements RCU-safe page
> table traversal, at which point this becomes problematic.
>
> This can be resolved by using pte_offset_map_lock() which gates on a PTE
> PTL and a pmd_same() check, but lockless walks are unsafe as things stand.
>
> Resolve this by simply allocating a new, zeroed, PTE page table to deposit
> at the point of collapse.
>
> This path is already costly and an allocation has already been performed
> for the huge folio, so this allocation is statistical noise in terms of
> performance and memory usage at this point.
>
> With this PTE page table deposited, RCU-free the existing PTE page table
> so it is safe for page table walkers to traverse within a grace period.
>
> This also brings this deposit case in line with all other page table
> deposit logic which deposit a fresh page table.
>
> Additionally, this was the only place in the kernel that displaced a page
> table like this, so eliminating it also helps consistency.
>
> An edge case for deposit exists for powerpc and its hash-based MMU - it
> stores hash slot data in deposited page tables and zeroes them on withdraw,
> so a zeroed deposited page table works correctly for it.
>
> Since khugepaged runs as a kernel thread, do a little dance in
> alloc_deposit_pte() to correctly charge the allocation.
>
> This is already done for the folio allocation via alloc_charge_folio() but
> no such wrapper exists for a page table allocation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f49a6710933b..dab421f8233e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>
> +static pgtable_t alloc_deposit_pte(struct mm_struct *mm)
> +{
> +	/*
> +	 * khugepaged is run from a kernel thread, so need to manually set the
> +	 * correct memcg so the allocation gets charged correctly.
> +	 */
> +	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
> +	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
> +	pgtable_t pgtable;
> +
> +	pgtable = pte_alloc_one(mm);
> +
> +	set_active_memcg(old_memcg);
> +	mem_cgroup_put(memcg);
> +	return pgtable;
> +}
> +
>  /*
>   * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
>   * will always return with the lock unlocked, to avoid holding the mmap_lock
> @@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
>  	pte_t *pte = NULL;
> -	pgtable_t pgtable;
> +	pgtable_t pgtable = NULL;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
> @@ -1310,6 +1327,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  		goto out_nolock;
>  	}
>
> +	if (is_pmd_order(order)) {
> +		pgtable = alloc_deposit_pte(mm);
> +		if (!pgtable)
> +			goto out_nolock;

Fixup is here:

-		if (!pgtable)
-			goto out_nolock;
+		if (!pgtable) {
+			result = SCAN_ALLOC_HUGE_PAGE_FAIL;
+			goto out_nolock;
+		}

Thanks!

> +	}
> +
>  	mmap_read_lock(mm);
>  	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
>  					 &vma, cc, order);
> @@ -1433,8 +1456,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	spin_lock(pmd_ptl);
>  	VM_WARN_ON_ONCE(!pmd_none(*pmd));
>  	if (is_pmd_order(order)) {
> -		pgtable = pmd_pgtable(_pmd);
>  		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		pgtable = NULL;
>  		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>  	} else {
>  		/*
> @@ -1453,6 +1476,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  	}
>  	spin_unlock(pmd_ptl);
>
> +	if (is_pmd_order(order))
> +		pte_free_defer(mm, pmd_pgtable(_pmd));
> +
>  	folio = NULL;
>
>  	result = SCAN_SUCCEED;
> @@ -1463,6 +1489,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>  		anon_vma_unlock_write(vma->anon_vma);
>  	mmap_write_unlock(mm);
>  out_nolock:
> +	if (pgtable)
> +		pte_free(mm, pgtable);
>  	if (folio)
>  		folio_put(folio);
>  	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

