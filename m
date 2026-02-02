Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 597ADE73153
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC6C6B0093; Mon,  2 Feb 2026 05:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A046B0096; Mon,  2 Feb 2026 05:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920B16B0098; Mon,  2 Feb 2026 05:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8CB6B0093
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:45:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22F408CDE7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:45:08 +0000 (UTC)
X-FDA: 84399184296.05.EB3A573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7AD5160005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:45:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PTmhn1QM;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770029106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0YoxKuMWEcnddPqONpuyD/hago//RxUMi3DCOyKIXk=;
	b=folHq537FyEDw+pBhwvaOeGhwcZcX9iKyq6BvkUgWMJkJ0T68JTAtFKnfydSpf6Mb8KJmq
	uLYk6ieNcZwDnsJBtc1IOART4xXEXCEQDJcS11XgwFVjVpiUWrZEzAEOk/ZBs9nmhC9gzi
	tQ+t6FiiiwFKeljHrFjOjdpcpv1qSDU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PTmhn1QM;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770029106; a=rsa-sha256;
	cv=none;
	b=g7lLR9m0Xa3/UTyNLDtX6pvC4qe79MtHKbii+Kby1BaiWIiFFpWzqEPCT0+Rdo5qWlRrEe
	YrIZxcyJ6TCOIrRQTR8c7H28HEUamhRccQ+SrP99k36BGqdqCOESJFuUcrTY53/h9kuBPF
	KoB67Jpr/r1HUOHOLRuP0saI3rfRsro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC623442D2;
	Mon,  2 Feb 2026 10:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08076C2BC86;
	Mon,  2 Feb 2026 10:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770029104;
	bh=mrWQQULk/bw9eyy/yWVZip3TlN/bFU6wKm3IsysqkLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PTmhn1QM/kDIZwUAp7IKwDeSBz966RniiZnNCnNKy5OQVaClTP5oTVolqF56NndHB
	 /IbOBs1GQzkQfJC4rsBsC1jAIkEMryuqKc/f0bh39XObKGPitQN4BlDf6RMgFJuA+U
	 IAfieoPtC7CYNtPlEa0uoxN9/Ded+S2VW+bTIhzDASAP1o15wrB9lwSkaQy3unabkD
	 8XNtXcte+opBRVa70/qqFjF1GGbhMd2c/rXv6lQA2Qavl+uy+NtMp902NbPd7LgHgH
	 4KKlIXDma4Y/j+GQ9jj6ITFW41We2OmKCVaUHQYJwcCnB/qz+wvySKla1I26bFcfLP
	 Nw8fFMFGyGoxA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1A33FF4008C;
	Mon,  2 Feb 2026 05:45:03 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 02 Feb 2026 05:45:03 -0500
X-ME-Sender: <xms:L4CAaRrsJuOFDskFGkgFGypkFuvMrWRQGHvLlXXJGWGK1sQQWiGLXg>
    <xme:L4CAafAB6QH3TkfXAmzUTPZSSONckHQR02VHtjBapLU2uJxt-S_FLciwY2dvnnO9R
    eYXTXXJjw2mCuGfzAaAE5LtsP40kWSwzGH1fyFNMr4wMmQIrm9k86c>
X-ME-Received: <xmr:L4CAaXl55D3qu2dfA_RbBQJs64NdGsEyTkGODkvGWkiBIaiiZJWcOlRq5hE0hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeejgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhopeiiih
    ihsehnvhhiughirgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhn
    uggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhr
    tghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohephhgrnh
    hnvghssegtmhhpgigthhhgrdhorhhgpdhrtghpthhtoheprhhivghlsehsuhhrrhhivghl
    rdgtohhmpdhrtghpthhtohepshhhrghkvggvlhdrsghuthhtsehlihhnuhigrdguvghv
X-ME-Proxy: <xmx:L4CAaUq2Yfy2-DBiMszJ9N1tb3rtulBeKnhiCkTHh6-R7HNiFxmUcA>
    <xmx:L4CAaccEQn3i6T3bIXFR5a4_Q1wddHsuLTj5CcOaY0_URI3tA15jow>
    <xmx:L4CAaa_8Pz1AlTwpiOoplo7cVTGqnsD34uqggP8kU0A_g9htaAuBiQ>
    <xmx:L4CAadGauQxlc7XWmQlXANPXZ_0BQBgG3tj82vFOlnYjRYyOmBhesw>
    <xmx:L4CAaakLL_YsVE9io_twMbAobMsP6OGWqNju84Bk8AYLAdmgV6WA_ih2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 05:45:00 -0500 (EST)
Date: Mon, 2 Feb 2026 10:44:54 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com, linux-mm@kvack.org, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Message-ID: <aYB75cWO2nnTx2ch@thinkstation>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202005451.774496-2-usamaarif642@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: biy1rkqfskp8j9gqbo36m3763eakmb3i
X-Rspam-User: 
X-Rspamd-Queue-Id: E7AD5160005
X-HE-Tag: 1770029105-720662
X-HE-Meta: U2FsdGVkX19uvoIvdW6OoMNyqKrsEfRQzNmulL3gifSqvBqco6G4SghbGd2Iwo5A2TtjcFJWziekYqQUgdutXhRQCQz3pTfxF01L+0rBxrK6S1tkfSGB2Azoh8wEPjcUjXy7SsXe8aN9h9ivw1tTfxy+7JONbxUCAYXJKlFTugozqaZRaZ38yMtsDDHnGPpwQyNbErXUdT4v7J3fcHe/ATIejg+EKx5z5jSLOOnr5eXvlfr1EMteK0VybT12uSUGrRcrR1x0c7MZmDi2Ahn8Rgqia9xu8KLFioeEiy0pVL4MDzq35EFvNnkjWE+LaBtPxMkHVl8MPZ4OM/8jFBjQlr27rsJPGH030VxfTc/+3vzM5HGyUMPS2pGR6uDRn26NDUCevWavznBunI1jm/ZMyjbVahJhQjYJdrP+9HDY4dVDdQxy2+3kkEdT9JHcOWuI1C7uFF9TublfjacGqdnF8onvDlsyM5t/URjfmnRMrcMsgO1kqZ5ZN6Hp2FtvUTq/hWheOlQLmh16x0ypuBEa7i8LLsu6h0mHSjx/OJGCB1I/vmlBzO5KRNZDTKTzDIRU8ku1F+CDzcItj0V0i2b7r4u7MeisVkCM80cDA6lyA/vBIFAnLVoaRScsjOS/Tiu1EFjn5epgfssl6W/6s/LoMzlPl4UyGmqTl2OGZCTTX9wH1yuaNA6k75wWtDKYlKt9PYGHrehwsfTYlPIf6zRYDSYPia/ogyecS70pi0sxKIqHCWU/CRJU8ezkACpqcI0muC2BetuWhhV4YIytFAhb/NMriNsHEiUCo736/vpKDZReJUHLoFhqQcB2de9Eq54G6d8S9OqV8yp9d3BPR8w1r9x9GTQNdPtAbr8hF71bTWJfyZL3Og59mB4RG/icVDvxoOy69qz3CbWbmEqEz8zzG6z/6nkxj1nQdPo9w70gMeVhQ7Bu+K+hHbBX+5XiNoVNX6XpnEt2Uist30n08D6
 JOJTE+Sr
 FZfmyESMvPk7uHXixZioHdS38fuXDwdfCL9gJ+vXEmDu+EOoSKNDyxvdMeUBDXVk/YnoxZVk6vvzr/nz254mzCNtiCAn1ORcYzKNx8tKN/WQmQZeOUBY/0fw/Nj5YE98C0lm7mC+JPd5R3cd6jeoNxsEa2LzcjXW4XmKykajJK5vNdkYgbBA0uGy+GPhHs8HoVafpW6n89dS2WYCECgP9Xi7ozPl1YrU6+xzC3AtyIYaKdj24HN9Dw4jOM6IwuSKOBrL0HLw9zr5W46lqFs61PVfnUTCICiV+o51mnxpaQ42+oazZc+W+X85FePPHVc8HClXfvoTj0xLcsuA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 01, 2026 at 04:50:18PM -0800, Usama Arif wrote:
> For page table management, PUD THPs need to pre-deposit page tables
> that will be used when the huge page is later split. When a PUD THP
> is allocated, we cannot know in advance when or why it might need to
> be split (COW, partial unmap, reclaim), but we need page tables ready
> for that eventuality. Similar to how PMD THPs deposit a single PTE
> table, PUD THPs deposit a PMD table which itself contains deposited
> PTE tables - a two-level deposit. This commit adds the deposit/withdraw
> infrastructure and a new pud_huge_pmd field in ptdesc to store the
> deposited PMD.
> 
> The deposited PMD tables are stored as a singly-linked stack using only
> page->lru.next as the link pointer. A doubly-linked list using the
> standard list_head mechanism would cause memory corruption: list_del()
> poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.prev
> overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
> tables have their own deposited PTE tables stored in pmd_huge_pte,
> poisoning lru.prev would corrupt the PTE table list and cause crashes
> when withdrawing PTE tables during split. PMD THPs don't have this
> problem because their deposited PTE tables don't have sub-deposits.
> Using only lru.next avoids the overlap entirely.
> 
> For reverse mapping, PUD THPs need the same rmap support that PMD THPs
> have. The page_vma_mapped_walk() function is extended to recognize and
> handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_PUD
> flag tells the unmap path to split PUD THPs before proceeding, since
> there is no PUD-level migration entry format - the split converts the
> single PUD mapping into individual PTE mappings that can be migrated
> or swapped normally.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  include/linux/huge_mm.h  |  5 +++
>  include/linux/mm.h       | 19 ++++++++
>  include/linux/mm_types.h |  5 ++-
>  include/linux/pgtable.h  |  8 ++++
>  include/linux/rmap.h     |  7 ++-
>  mm/huge_memory.c         |  8 ++++
>  mm/internal.h            |  3 ++
>  mm/page_vma_mapped.c     | 35 +++++++++++++++
>  mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
>  mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++---
>  10 files changed, 260 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a4d9f964dfdea..e672e45bb9cc7 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -463,10 +463,15 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>  		unsigned long address);
>  
>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> +			   unsigned long address);
>  int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
>  		    unsigned long cp_flags);
>  #else
> +static inline void
> +split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> +		      unsigned long address) {}
>  static inline int
>  change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		pud_t *pudp, unsigned long addr, pgprot_t newprot,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ab2e7e30aef96..a15e18df0f771 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3455,6 +3455,22 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
>   * considered ready to switch to split PUD locks yet; there may be places
>   * which need to be converted from page_table_lock.
>   */
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +static inline struct page *pud_pgtable_page(pud_t *pud)
> +{
> +	unsigned long mask = ~(PTRS_PER_PUD * sizeof(pud_t) - 1);
> +
> +	return virt_to_page((void *)((unsigned long)pud & mask));
> +}
> +
> +static inline struct ptdesc *pud_ptdesc(pud_t *pud)
> +{
> +	return page_ptdesc(pud_pgtable_page(pud));
> +}
> +
> +#define pud_huge_pmd(pud) (pud_ptdesc(pud)->pud_huge_pmd)
> +#endif
> +
>  static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)
>  {
>  	return &mm->page_table_lock;
> @@ -3471,6 +3487,9 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
>  static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
>  {
>  	__pagetable_ctor(ptdesc);
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +	ptdesc->pud_huge_pmd = NULL;
> +#endif
>  }
>  
>  static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 78950eb8926dc..26a38490ae2e1 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -577,7 +577,10 @@ struct ptdesc {
>  		struct list_head pt_list;
>  		struct {
>  			unsigned long _pt_pad_1;
> -			pgtable_t pmd_huge_pte;
> +			union {
> +				pgtable_t pmd_huge_pte;  /* For PMD tables: deposited PTE */
> +				pgtable_t pud_huge_pmd;  /* For PUD tables: deposited PMD list */
> +			};
>  		};
>  	};
>  	unsigned long __page_mapping;
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 2f0dd3a4ace1a..3ce733c1d71a2 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1168,6 +1168,14 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>  #define arch_needs_pgtable_deposit() (false)
>  #endif
>  
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +extern void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
> +					   pmd_t *pmd_table);
> +extern pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp);
> +extern void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable);
> +extern pgtable_t pud_withdraw_pte(pmd_t *pmd_table);
> +#endif
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  /*
>   * This is an implementation of pmdp_establish() that is only suitable for an
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d9..08cd0a0eb8763 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -101,6 +101,7 @@ enum ttu_flags {
>  					 * do a final flush if necessary */
>  	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
>  					 * caller holds it */
> +	TTU_SPLIT_HUGE_PUD	= 0x100, /* split huge PUD if any */
>  };
>  
>  #ifdef CONFIG_MMU
> @@ -473,6 +474,8 @@ void folio_add_anon_rmap_ptes(struct folio *, struct page *, int nr_pages,
>  	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
>  void folio_add_anon_rmap_pmd(struct folio *, struct page *,
>  		struct vm_area_struct *, unsigned long address, rmap_t flags);
> +void folio_add_anon_rmap_pud(struct folio *, struct page *,
> +		struct vm_area_struct *, unsigned long address, rmap_t flags);
>  void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
>  		unsigned long address, rmap_t flags);
>  void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
> @@ -933,6 +936,7 @@ struct page_vma_mapped_walk {
>  	pgoff_t pgoff;
>  	struct vm_area_struct *vma;
>  	unsigned long address;
> +	pud_t *pud;
>  	pmd_t *pmd;
>  	pte_t *pte;
>  	spinlock_t *ptl;
> @@ -970,7 +974,7 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
>  static inline void
>  page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
>  {
> -	WARN_ON_ONCE(!pvmw->pmd && !pvmw->pte);
> +	WARN_ON_ONCE(!pvmw->pud && !pvmw->pmd && !pvmw->pte);
>  
>  	if (likely(pvmw->ptl))
>  		spin_unlock(pvmw->ptl);
> @@ -978,6 +982,7 @@ page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
>  		WARN_ON_ONCE(1);
>  
>  	pvmw->ptl = NULL;
> +	pvmw->pud = NULL;
>  	pvmw->pmd = NULL;
>  	pvmw->pte = NULL;
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21a..3128b3beedb0a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2933,6 +2933,14 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>  	spin_unlock(ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  }
> +
> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> +			   unsigned long address)
> +{
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PUD_SIZE));
> +	if (pud_trans_huge(*pud))
> +		__split_huge_pud_locked(vma, pud, address);
> +}
>  #else
>  void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>  		unsigned long address)
> diff --git a/mm/internal.h b/mm/internal.h
> index 9ee336aa03656..21d5c00f638dc 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -545,6 +545,9 @@ int user_proactive_reclaim(char *buf,
>   * in mm/rmap.c:
>   */
>  pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address);
> +#endif
>  
>  /*
>   * in mm/page_alloc.c
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971b..d31eafba38041 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -146,6 +146,18 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>  	return true;
>  }
>  
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/* Returns true if the two ranges overlap.  Careful to not overflow. */
> +static bool check_pud(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> +{
> +	if ((pfn + HPAGE_PUD_NR - 1) < pvmw->pfn)
> +		return false;
> +	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
> +		return false;
> +	return true;
> +}
> +#endif
> +
>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
>  {
>  	pvmw->address = (pvmw->address + size) & ~(size - 1);
> @@ -188,6 +200,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  	pud_t *pud;
>  	pmd_t pmde;
>  
> +	/* The only possible pud mapping has been handled on last iteration */
> +	if (pvmw->pud && !pvmw->pmd)
> +		return not_found(pvmw);
> +
>  	/* The only possible pmd mapping has been handled on last iteration */
>  	if (pvmw->pmd && !pvmw->pte)
>  		return not_found(pvmw);
> @@ -234,6 +250,25 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			continue;
>  		}
>  
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +		/* Check for PUD-mapped THP */
> +		if (pud_trans_huge(*pud)) {
> +			pvmw->pud = pud;
> +			pvmw->ptl = pud_lock(mm, pud);
> +			if (likely(pud_trans_huge(*pud))) {
> +				if (pvmw->flags & PVMW_MIGRATION)
> +					return not_found(pvmw);
> +				if (!check_pud(pud_pfn(*pud), pvmw))
> +					return not_found(pvmw);
> +				return true;
> +			}
> +			/* PUD was split under us, retry at PMD level */
> +			spin_unlock(pvmw->ptl);
> +			pvmw->ptl = NULL;
> +			pvmw->pud = NULL;
> +		}
> +#endif
> +
>  		pvmw->pmd = pmd_offset(pud, pvmw->address);
>  		/*
>  		 * Make sure the pmd value isn't cached in a register by the
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index d3aec7a9926ad..2047558ddcd79 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
>  }
>  #endif
>  
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/*
> + * Deposit page tables for PUD THP.
> + * Called with PUD lock held. Stores PMD tables in a singly-linked stack
> + * via pud_huge_pmd, using only pmd_page->lru.next as the link pointer.
> + *
> + * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the full
> + * list_head. This is because lru.prev (offset 16) overlaps with
> + * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE tables.
> + * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.

This is ugly.

Sounds like you want to use llist_node/head instead of list_head for this.

You might able to avoid taking the lock in some cases. Note that
pud_lockptr() is mm->page_table_lock as of now.

> + *
> + * PTE tables should be deposited into the PMD using pud_deposit_pte().
> + */
> +void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
> +				    pmd_t *pmd_table)
> +{
> +	pgtable_t pmd_page = virt_to_page(pmd_table);
> +
> +	assert_spin_locked(pud_lockptr(mm, pudp));
> +
> +	/* Push onto stack using only lru.next as the link */
> +	pmd_page->lru.next = (struct list_head *)pud_huge_pmd(pudp);
> +	pud_huge_pmd(pudp) = pmd_page;
> +}
> +
> +/*
> + * Withdraw the deposited PMD table for PUD THP split or zap.
> + * Called with PUD lock held.
> + * Returns NULL if no more PMD tables are deposited.
> + */
> +pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp)
> +{
> +	pgtable_t pmd_page;
> +
> +	assert_spin_locked(pud_lockptr(mm, pudp));
> +
> +	pmd_page = pud_huge_pmd(pudp);
> +	if (!pmd_page)
> +		return NULL;
> +
> +	/* Pop from stack - lru.next points to next PMD page (or NULL) */
> +	pud_huge_pmd(pudp) = (pgtable_t)pmd_page->lru.next;
> +
> +	return page_address(pmd_page);
> +}
> +
> +/*
> + * Deposit a PTE table into a standalone PMD table (not yet in page table hierarchy).
> + * Used for PUD THP pre-deposit. The PMD table's pmd_huge_pte stores a linked list.
> + * No lock assertion since the PMD isn't visible yet.
> + */
> +void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable)
> +{
> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
> +
> +	/* FIFO - add to front of list */
> +	if (!ptdesc->pmd_huge_pte)
> +		INIT_LIST_HEAD(&pgtable->lru);
> +	else
> +		list_add(&pgtable->lru, &ptdesc->pmd_huge_pte->lru);
> +	ptdesc->pmd_huge_pte = pgtable;
> +}
> +
> +/*
> + * Withdraw a PTE table from a standalone PMD table.
> + * Returns NULL if no more PTE tables are deposited.
> + */
> +pgtable_t pud_withdraw_pte(pmd_t *pmd_table)
> +{
> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
> +	pgtable_t pgtable;
> +
> +	pgtable = ptdesc->pmd_huge_pte;
> +	if (!pgtable)
> +		return NULL;
> +	ptdesc->pmd_huge_pte = list_first_entry_or_null(&pgtable->lru,
> +							struct page, lru);
> +	if (ptdesc->pmd_huge_pte)
> +		list_del(&pgtable->lru);
> +	return pgtable;
> +}
> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> +
>  #ifndef __HAVE_ARCH_PMDP_INVALIDATE
>  pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
>  		     pmd_t *pmdp)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 7b9879ef442d9..69acabd763da4 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -811,6 +811,32 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
>  	return pmd;
>  }
>  
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/*
> + * Returns the actual pud_t* where we expect 'address' to be mapped from, or
> + * NULL if it doesn't exist.  No guarantees / checks on what the pud_t*
> + * represents.
> + */
> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address)

Remove the ifdef and make mm_find_pmd() call it.

And in general, try to avoid ifdeffery where possible.

> +{
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud = NULL;
> +
> +	pgd = pgd_offset(mm, address);
> +	if (!pgd_present(*pgd))
> +		goto out;
> +
> +	p4d = p4d_offset(pgd, address);
> +	if (!p4d_present(*p4d))
> +		goto out;
> +
> +	pud = pud_offset(p4d, address);
> +out:
> +	return pud;
> +}
> +#endif
> +
>  struct folio_referenced_arg {
>  	int mapcount;
>  	int referenced;
> @@ -1415,11 +1441,7 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>  			SetPageAnonExclusive(page);
>  			break;
>  		case PGTABLE_LEVEL_PUD:
> -			/*
> -			 * Keep the compiler happy, we don't support anonymous
> -			 * PUD mappings.
> -			 */
> -			WARN_ON_ONCE(1);
> +			SetPageAnonExclusive(page);
>  			break;
>  		default:
>  			BUILD_BUG();
> @@ -1503,6 +1525,31 @@ void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
>  #endif
>  }
>  
> +/**
> + * folio_add_anon_rmap_pud - add a PUD mapping to a page range of an anon folio
> + * @folio:	The folio to add the mapping to
> + * @page:	The first page to add
> + * @vma:	The vm area in which the mapping is added
> + * @address:	The user virtual address of the first page to map
> + * @flags:	The rmap flags
> + *
> + * The page range of folio is defined by [first_page, first_page + HPAGE_PUD_NR)
> + *
> + * The caller needs to hold the page table lock, and the page must be locked in
> + * the anon_vma case: to serialize mapping,index checking after setting.
> + */
> +void folio_add_anon_rmap_pud(struct folio *folio, struct page *page,
> +		struct vm_area_struct *vma, unsigned long address, rmap_t flags)
> +{
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
> +	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> +	__folio_add_anon_rmap(folio, page, HPAGE_PUD_NR, vma, address, flags,
> +			      PGTABLE_LEVEL_PUD);
> +#else
> +	WARN_ON_ONCE(true);
> +#endif
> +}
> +
>  /**
>   * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
>   * @folio:	The folio to add the mapping to.
> @@ -1934,6 +1981,20 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>  
>  		if (!pvmw.pte) {
> +			/*
> +			 * Check for PUD-mapped THP first.
> +			 * If we have a PUD mapping and TTU_SPLIT_HUGE_PUD is set,
> +			 * split the PUD to PMD level and restart the walk.
> +			 */
> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
> +				if (flags & TTU_SPLIT_HUGE_PUD) {
> +					split_huge_pud_locked(vma, pvmw.pud, pvmw.address);
> +					flags &= ~TTU_SPLIT_HUGE_PUD;
> +					page_vma_mapped_walk_restart(&pvmw);
> +					continue;
> +				}
> +			}
> +
>  			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
>  				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>  					goto walk_done;
> @@ -2325,6 +2386,27 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
> +		/* Handle PUD-mapped THP first */
> +		if (!pvmw.pte && !pvmw.pmd) {
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +			/*
> +			 * PUD-mapped THP: skip migration to preserve the huge
> +			 * page. Splitting would defeat the purpose of PUD THPs.
> +			 * Return false to indicate migration failure, which
> +			 * will cause alloc_contig_range() to try a different
> +			 * memory region.
> +			 */
> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
> +				page_vma_mapped_walk_done(&pvmw);
> +				ret = false;
> +				break;
> +			}
> +#endif
> +			/* Unexpected state: !pte && !pmd but not a PUD THP */
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
> +
>  		/* PMD-mapped THP migration entry */
>  		if (!pvmw.pte) {
>  			__maybe_unused unsigned long pfn;
> @@ -2607,10 +2689,10 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
>  
>  	/*
>  	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
> -	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
> +	 * TTU_SPLIT_HUGE_PMD, TTU_SPLIT_HUGE_PUD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
>  	 */
>  	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
> -					TTU_SYNC | TTU_BATCH_FLUSH)))
> +					TTU_SPLIT_HUGE_PUD | TTU_SYNC | TTU_BATCH_FLUSH)))
>  		return;
>  
>  	if (folio_is_zone_device(folio) &&
> -- 
> 2.47.3
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

