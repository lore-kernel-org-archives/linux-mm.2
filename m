Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527B1C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7433B6B00F6; Thu, 22 Jan 2026 02:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71ADB6B00F7; Thu, 22 Jan 2026 02:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CF26B00F8; Thu, 22 Jan 2026 02:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6FC6B00F6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:00:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE6DC1A012B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:00:28 +0000 (UTC)
X-FDA: 84358701336.06.CF7142A
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id A25D140006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:00:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LmIDw8CW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769065227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWzueiUJw9HETpu/7Ypk9rQy7qbGLonTsV0zluVOExk=;
	b=1QMZELUVdHTbQyveP7FokM+0BBNoqt0Qm9xUjAa+7loSr6WoVyPPoP8q83iHX7qnzHxtAR
	8ZhIwdXNJwo72FHbNo+pPdT4DOeGatEATIANqYSJYIlRNuvuV51IBiU4nN6otG2IPS5W8x
	Ung1sfKl2OFWJWOO+0PBDxKVEI1rpkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769065227; a=rsa-sha256;
	cv=none;
	b=hesNhSVixqUrHBaByblyO6jOdFKoBQ/jQaKGUhQEObXQpvFvNVnLxZczWUbfM9P0Dz44Fv
	sCsb/DIPJuqGt0Kysx0ZMz1vV9D8QXCTxQvLKxhMeAI/sQv07EKxst/d+LDouTSQsIvc/O
	QJl2JT12XoKklD+aLtcLMvsuR4Ky1mw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LmIDw8CW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Message-ID: <ffe9811b-d7f8-4924-9ad6-96057a16b693@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769065224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWzueiUJw9HETpu/7Ypk9rQy7qbGLonTsV0zluVOExk=;
	b=LmIDw8CWKmZw1QG3bwNlCdBxrxLABeCa/eS7tWyNDeGi2/YAfWZ7G+GmPyn2U2GYBAnYAv
	lg0yflbbgm5ybTDth3qQvT4ozALH9yiFoNEYtxNiRdqvli0M55JSuI1EIqv7K2DhPl/HgS
	dOCx3Avm8JEnihr3Fbsus1xvQQPgXRs=
Date: Thu, 22 Jan 2026 15:00:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv4 09/14] mm/hugetlb: Remove fake head pages
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-10-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260121162253.2216580-10-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A25D140006
X-Stat-Signature: abw8rhbc73x5hyhmdezw4148hzyu51ee
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769065226-993182
X-HE-Meta: U2FsdGVkX19rcfgQDteYWqunfOXcHTyqD+79DMrWU1BkoE8WAhnfuSxWgs/JUDQFUpfM5UWjo6WbU4/QGMsuQsvTVZ8qZv5JkmeMTNVOIMKI8Axf6KhVNbbdhVusjGAZv/A5D9QiZa941Fie0wKfOhZgKH+LlaQw9Rgt19CpoPZ8psVVMe7oq9wu5nbf32WC2E5mOPck4/fmCTx4FoL0AkCmoiM4lcw/yaT84CAwt1xjzLiaYxQIVA5GA62ZJ6U3rCCGGlTI8D7w6b0qTBhNqRQxPW3nq7jTlFBTCWGYRa283iFfZyII/JXm9YhaThAMmIxvXMGRj+zCwOWQO7YgbcAgU2Fy/MltQRqcf33XW02wtoEZn6VI1UlG2vFFVl3GOVO4l1+jHN/eCN3qGPV3Db7M71vGEmjpRULGEy5cIVEArikVP2Ocx8yTUmkoO1/HQdlaWIHl8pStwG19YPXngyGLaRacnd90cXQQi66S0nRmCXRuRr94e5kMdO+pbUs2HeWlRHGJiR1N34egkFm0ykznuh30o3Fg/QWWG8Kp2LtBvWa9ygC/D6oHDYqvzM7w5hvYktd9AQbyYtCIsxwOnAhX6i5joBnynawLdRIRL1CjS6F9q0smBzNGV1aL+JZSN4C9AvQd5CPF4N4YBl/AIWKzsn8JxoKmhQEm+nqIsKrgIall1ScvilvOzZzeQUmWlXdxyBoeVIDU8vGKWwF3wlT6JWz0JrOFxSAYo+D42s7Eyh6RfsxHrxAhz3umhdKyf7+vZg0z2TFQJ+RQ5CYF+xwgCVkt8tPc4I44FOAmaz7tERqqkMhrvNP/WNVsNbU/uFPOeZxHRRT7+4oKktnILyQbjEZpd0HcdVmKNuAGFDKj0MH/XLob7zfjFmg5mGUerpt0UThItoCuCBlluZkpm90FKWnHcqZyQDvWlWVb6q3SMgnm9NXJ2elm/ELaYnY1Ce7NZVkgmgX0JHjerM+
 fz80QNyO
 KEIRKa0qw1wuXzOYFxVpQfK0iV0Dx/hjrGTghp2OtH5aKb2wUjccf8Xvq3hbBQf+IMimPhqj0JsAojMiWPsMx2NNlrWthqy3ZOY1xUwfCb281wHogk1/OCw1lWuyXd4gquj0f4ozne1Rs+Y1Eh9g4B0aurjRPKQlpgRbQwbi28M1KAZkOMHr4CzVw5qoUOF0tCJxd9GN2YsEMrQUQX+3m/dvqJrIM5nPz0WM1twqxqUVNR9w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/22 00:22, Kiryl Shutsemau wrote:
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
>
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
>
> Allocate a single page of initialized tail struct pages per NUMA node
> per order in the vmemmap_tails[] array in pglist_data. All huge pages of
> that order on the node share this tail page, mapped read-only into their
> vmemmap. The head page remains unique per huge page.
>
> Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
> compile-constant as it is used to specify vmemmap_tail array size.
> For some reason, compiler is not able to solve get_order() at
> compile-time, but ilog2() works.
>
> Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
> <linux/pgtable.h> which generates hard-to-break include loop.
>
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   include/linux/mmzone.h | 18 ++++++++--
>   mm/hugetlb_vmemmap.c   | 80 ++++++++++++++++++++++++++++--------------
>   mm/sparse-vmemmap.c    | 44 ++++++++++++++++++-----
>   3 files changed, 106 insertions(+), 36 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7e4f69b9d760..7e6beeca4d40 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -81,13 +81,17 @@
>    * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
>    * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>    */
> -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> +#ifdef CONFIG_64BIT
> +#define MAX_FOLIO_ORDER		(ilog2(SZ_16G) - PAGE_SHIFT)
> +#else
> +#define MAX_FOLIO_ORDER		(ilog2(SZ_1G) - PAGE_SHIFT)
> +#endif
>   #else
>   /*
>    * Without hugetlb, gigantic folios that are bigger than a single PUD are
>    * currently impossible.
>    */
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> +#define MAX_FOLIO_ORDER		(PUD_SHIFT - PAGE_SHIFT)
>   #endif
>   
>   #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> @@ -1407,6 +1411,13 @@ struct memory_failure_stats {
>   };
>   #endif
>   
> +/*
> + * vmemmap optimization (like HVO) is only possible for page orders that fill
> + * two or more pages with struct pages.
> + */
> +#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
> +#define NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
> +
>   /*
>    * On NUMA machines, each NUMA node would have a pg_data_t to describe
>    * it's memory layout. On UMA machines there is a single pglist_data which
> @@ -1555,6 +1566,9 @@ typedef struct pglist_data {
>   #ifdef CONFIG_MEMORY_FAILURE
>   	struct memory_failure_stats mf_stats;
>   #endif
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];
> +#endif
>   } pg_data_t;
>   
>   #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index a51c0e293175..51bb6c73db92 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -18,6 +18,7 @@
>   #include <asm/pgalloc.h>
>   #include <asm/tlbflush.h>
>   #include "hugetlb_vmemmap.h"
> +#include "internal.h"
>   
>   /**
>    * struct vmemmap_remap_walk - walk vmemmap page table
> @@ -231,36 +232,25 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
>   	set_pte_at(&init_mm, addr, pte, entry);
>   }
>   
> -/*
> - * How many struct page structs need to be reset. When we reuse the head
> - * struct page, the special metadata (e.g. page->flags or page->mapping)
> - * cannot copy to the tail struct page structs. The invalid value will be
> - * checked in the free_tail_page_prepare(). In order to avoid the message
> - * of "corrupted mapping in tail page". We need to reset at least 4 (one
> - * head struct page struct and three tail struct page structs) struct page
> - * structs.
> - */
> -#define NR_RESET_STRUCT_PAGE		4
> -
> -static inline void reset_struct_pages(struct page *start)
> -{
> -	struct page *from = start + NR_RESET_STRUCT_PAGE;
> -
> -	BUILD_BUG_ON(NR_RESET_STRUCT_PAGE * 2 > PAGE_SIZE / sizeof(struct page));
> -	memcpy(start, from, sizeof(*from) * NR_RESET_STRUCT_PAGE);
> -}
> -
>   static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
>   				struct vmemmap_remap_walk *walk)
>   {
>   	struct page *page;
> -	void *to;
> +	struct page *from, *to;
>   
>   	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
>   	list_del(&page->lru);
> +
> +	/*
> +	 * Initialize all tail pages with the value of the first non-special
> +	 * tail pages. The first 4 tail pages of the hugetlb folio contain
> +	 * special metadata.
> +	 */
> +	from = compound_head((struct page *)addr) + 4;

If we can eliminate the hard-coded number 4 as much as possible,
we should do so. This is to avoid issues like the commit 274fe92de2c4.
Therefore, I suggest copying data from the last struct page. Something like:

from = compound_head((struct page *)addr) + PAGE_SIZE / sizeof(struct 
page) - 1;

>   	to = page_to_virt(page);
> -	copy_page(to, (void *)walk->vmemmap_start);
> -	reset_struct_pages(to);
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++) {
> +		*to = *from;
> +	}

 From the code style, "{}" is not necessary for one-line-code block.

>   
>   	/*
>   	 * Makes sure that preceding stores to the page contents become visible
> @@ -425,8 +415,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>   
>   	vmemmap_start	= (unsigned long)&folio->page;
>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> -
> -	vmemmap_start += HUGETLB_VMEMMAP_RESERVE_SIZE;
> +	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;

Those two-line changes should go into patch 8.

>   
>   	/*
>   	 * The pages which the vmemmap virtual address range [@vmemmap_start,
> @@ -517,6 +506,41 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
>   	return true;
>   }
>   
> +static struct page *vmemmap_get_tail(unsigned int order, int node)
> +{
> +	unsigned long pfn;
> +	unsigned int idx;
> +	struct page *tail, *p;
> +
> +	idx = order - VMEMMAP_TAIL_MIN_ORDER;
> +	pfn =  NODE_DATA(node)->vmemmap_tails[idx];

READ_ONCE() for access of NODE_DATA(node)->vmemmap_tails[idx].

> +	if (pfn)
> +		return pfn_to_page(pfn);
> +
> +	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> +	if (!tail)
> +		return NULL;
> +
> +	p = page_to_virt(tail);
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, NULL, order);
> +
> +	spin_lock(&hugetlb_lock);

hugetlb_lock is considered a contended lock, better not to abuse it.
cmpxchg() is enought in this case.

> +	if (!NODE_DATA(node)->vmemmap_tails[idx]) {
> +		pfn = PHYS_PFN(virt_to_phys(p));
> +		NODE_DATA(node)->vmemmap_tails[idx] = pfn;
> +		tail = NULL;
> +	} else {
> +		pfn = NODE_DATA(node)->vmemmap_tails[idx];
> +	}
> +	spin_unlock(&hugetlb_lock);
> +
> +	if (tail)
> +		__free_page(tail);
> +
> +	return pfn_to_page(pfn);
> +}
> +
>   static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   					    struct folio *folio,
>   					    struct list_head *vmemmap_pages,
> @@ -532,6 +556,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	if (!vmemmap_should_optimize_folio(h, folio))
>   		return ret;
>   
> +	nid = folio_nid(folio);
> +

Do not add a new line here.

> +	vmemmap_tail = vmemmap_get_tail(h->order, nid);
> +	if (!vmemmap_tail)
> +		return -ENOMEM;
> +
>   	static_branch_inc(&hugetlb_optimize_vmemmap_key);
>   
>   	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
> @@ -549,7 +579,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	 */
>   	folio_set_hugetlb_vmemmap_optimized(folio);
>   
> -	nid = folio_nid(folio);
>   	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
>   
>   	if (!vmemmap_head) {
> @@ -561,7 +590,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   	list_add(&vmemmap_head->lru, vmemmap_pages);
>   	memmap_pages_add(1);
>   
> -	vmemmap_tail	= vmemmap_head;
>   	vmemmap_start	= (unsigned long)&folio->page;
>   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
>   
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index dbd8daccade2..94b4e90fa00f 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -378,16 +378,45 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
>   	}
>   }
>   
> -/*
> - * Populate vmemmap pages HVO-style. The first page contains the head
> - * page and needed tail pages, the other ones are mirrors of the first
> - * page.
> - */
> +static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
> +{
> +	unsigned long pfn;
> +	unsigned int idx;
> +	struct page *p;
> +
> +	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
> +	BUG_ON(order > MAX_FOLIO_ORDER);
> +
> +	idx = order - VMEMMAP_TAIL_MIN_ORDER;
> +	pfn =  NODE_DATA(node)->vmemmap_tails[idx];
> +	if (pfn)
> +		return pfn;
> +
> +	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +	if (!p)
> +		return 0;
> +
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, NULL, order);
> +
> +	pfn = PHYS_PFN(virt_to_phys(p));
> +	NODE_DATA(node)->vmemmap_tails[idx] = pfn;
> +
> +	return pfn;
> +}
> +
>   int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>   				       int node, unsigned long headsize)
>   {
> +	unsigned long maddr, len, tail_pfn;
> +	unsigned int order;
>   	pte_t *pte;
> -	unsigned long maddr;
> +
> +	len = end - addr;
> +	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);
> +	tail_pfn = vmemmap_get_tail(order, node);
> +	if (!tail_pfn)
> +		return -ENOMEM;
>   
>   	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
>   		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
> @@ -398,8 +427,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>   	/*
>   	 * Reuse the last page struct page mapped above for the rest.
>   	 */
> -	return vmemmap_populate_range(maddr, end, node, NULL,
> -					pte_pfn(ptep_get(pte)), 0);
> +	return vmemmap_populate_range(maddr, end, node, NULL, tail_pfn, 0);
>   }
>   
>   void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,


