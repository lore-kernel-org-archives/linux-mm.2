Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AFDCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216FA6B0088; Wed,  3 Jun 2026 08:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF416B008A; Wed,  3 Jun 2026 08:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BF16B008C; Wed,  3 Jun 2026 08:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 033686B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1DF2161FEB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:03:12 +0000 (UTC)
X-FDA: 84838465824.07.2E4C6C3
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA39E1C000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:03:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HUtNH7w0;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCpohelG7l6LyhUQ07RSrgnLyItsWmnms5P59P39ZIU=;
	b=ltAKZZKuP0OIGuHOGWq80Db5r9ZopWH7GEuYohuO+E/sgMhXiH9YY/WtfjofAkBac5Iu/l
	J1p7wrlJNVYYLkivG8NMBjP64iNEvsfh/x93lriFkwWJnK4Jx7yDa0PtlxWBvc2Q0sQjri
	5bycslJyKsm7wOlt0JCvKRVXuNXNhGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488191;
	b=FDtazDPT23rZ87YnbhvC010RstBpFDu44zYqiA6ULtjOXPC13bpWfgxpAQJeoWuLlEwvaR
	en0NVv9aDLeoS5eBNC1phrInuf/78gry+fwnMVsfr+IX/cJiPlke3fPKfD2srRtRRxNoVl
	kZmHoT1dywmD1S/w5OVHhlvVQgbBvdI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HUtNH7w0;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780488188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SCpohelG7l6LyhUQ07RSrgnLyItsWmnms5P59P39ZIU=;
	b=HUtNH7w0NlcTlfK4uJ5OKX2uFNebPH93cM5pZOWhpnZySBJtVcuEW78fCaVP5wlFo2YTPS
	FzgVSj5+2TsKi/D7szWfqoeoAE83hINvRXcZTwLthMkqQE8GhtxUARv8KkMAgKoXnr9pQ/
	NOTwiKwWI8Yqcwb84dOy/Z2/iKlCkHI=
From: Usama Arif <usama.arif@linux.dev>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v3 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to early init
Date: Wed,  3 Jun 2026 05:02:44 -0700
Message-ID: <20260603120246.1572177-1-usama.arif@linux.dev>
In-Reply-To: <20260602101039.1867613-16-songmuchun@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA39E1C000B
X-Stat-Signature: b7cjgmg58j17bfbt9h8bexkqeghwu9g8
X-HE-Tag: 1780488190-713720
X-HE-Meta: U2FsdGVkX1/APOUooOcZaAeIqfwX8RfvXcf3H+8K8HgwUQLY6aN0oCpONEQr+nMuL6Tgi54lq79HoPy52zFmdBJETgfc95o5EQ2cin50M2Z6SSp9cAvgJmalTtxSC2mvmaaqnf7ASl1WiJQjjCfdOp+iem/j2Ln0hsnYY6mN+55gIz2b621eXBRD24QbsWAbkRvKPyetEU4G3iG/4yT8BQKQ7uKR2P9eIafYx+hrAjl1GnkLd8o8toLFrPRPRQja5LJ43KpdUy2kU4ypGS9WxeDyWHc0MVCXLYMPN7zxxfFMdXC5AzGhqRyWY+mUp3EZthnnZPvffxoqg4VSCHjDDi5nbktsZ5kTqFupGgc+EHipy0MNzPupphPj3lPC8DCQIbgdx3daKJBiM6gRrm/FwF6guLVW3lgHKnHWOQ3GjmHicrQhw2nZJo3O9yR9yPyrhk+uFo2O8Y4KWqD9zkM/Ycg67q5qe0QXMnho3fO1Z5WYFP2dL4V6edgAJjNGxsC+q382n5oDbphq4oRrmLIbOGkbWdRtkoOFpar4PHLVCvDYrriGzQlzhWuCMl10CFmwAXZOVxxLTFNVv5Qt0CqPhrVUSIT9XNFzHI2cDSSR/7Aux/sA7VAam7dO+ih7CsjaLNycuXflXGmSfjxwobYKqMnMxd9Yk+d2WLpPbaZCUYnN8Yf1rJPUXfp6U2G0RyNCibjWurSwzjlDOGDugmS45qN0hvDlj5ZZLtQKLj3GzfciyIaZ7VE8csLWWMyuhSJtRpgPDZ5iRhEuB/wr9XgcZqhcwQ1l6BqG7DLay/dORKMv07R/5mZaPYCMW7SbSxLr5XlD2bVRjvHXOJlDhR+APyhpjePO0qEq33Fa+9NPM3mAnTJ0PlrkQquG7QUBfeHiTGRLz0j/kb4tVxcOz8eJ6ZFUTWwpcuj34OskV4Vhfwm6dSsHnnvvZ9PFaPGUPXHQbyH6Z+lKiMOA6s5bkG5
 buywCDuK
 BVPFBM2gBLDE1I12ybFoafrWXSz0rAhWuJXJBClv47hP2Mq88sE1GarXAHqi2QeIC2NllMIp2/OfTHypxUY5zGcTnTv/P1nIJRlWiuW/lldzxt/S1qISCgwZ6OPJBQhlHXF3HjicGFHF9s81sZASB3IY0rta8w7eqLSaKbZpdKQLkSXxfN6OjX98WAlCFdESxvk0Ksop50kEzp9tx2bfgvAx6KTasAtnJoqwpbX37wIJCC8bhtLTRp5io7kg53E2Julr1Vrq8b5/8L1EBmcgEbOWjddDztIVFCjVjnbYYRjbW5UGKepm5SzqjwdQaRP5gUnz8pBOwqboOPU3nKvd1H9r9DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 18:10:35 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> Bootmem HugeTLB pages currently defer HVO setup to
> hugetlb_vmemmap_init_late(), because the optimization needs zone
> information.
> 
> Now that zone initialization is available earlier, the bootmem HVO setup
> can be done directly from hugetlb_vmemmap_init_early(). This lets
> gigantic HugeTLB pages apply HVO as soon as they are allocated.
> 
> Bootmem gigantic pages that span multiple zones are now filtered out
> when they are allocated, so the remaining bootmem gigantic pages seen by
> later hugetlb initialization are already zone-valid. As a result,
> hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/hugetlb_vmemmap.c | 67 +++++++++-----------------------------------
>  1 file changed, 13 insertions(+), 54 deletions(-)
> 
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ea6af85bfec1..464578ee246e 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -745,6 +745,8 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
>  	return true;
>  }
>  
> +static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
> +
>  /*
>   * Initialize memmap section for a gigantic page, HVO-style.
>   */
> @@ -752,6 +754,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
>  {
>  	unsigned long psize, paddr, section_size;
>  	unsigned long ns, i, pnum, pfn, nr_pages;
> +	unsigned long start, end;
>  	struct huge_bootmem_page *m = NULL;
>  	void *map;
>  
> @@ -761,6 +764,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
>  	section_size = (1UL << PA_SECTION_SHIFT);
>  
>  	list_for_each_entry(m, &huge_boot_pages[nid], list) {
> +		struct zone *zone;
> +
>  		if (!vmemmap_should_optimize_bootmem_page(m))
>  			continue;
>  
> @@ -769,6 +774,14 @@ void __init hugetlb_vmemmap_init_early(int nid)
>  		paddr = virt_to_phys(m);
>  		pfn = PHYS_PFN(paddr);
>  		map = pfn_to_page(pfn);
> +		start = (unsigned long)map;
> +		end = start + hugetlb_vmemmap_size(m->hstate);
> +		zone = pfn_to_zone(nid, pfn);
> +
> +		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
> +					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
> +			panic("Failed to allocate memmap for HugeTLB page\n");

The replaced hugetlb_vmemmap_init_late() path used to fall back to
vmemmap_populate() if vmemmap_populate_hvo() returned an error and
just lost the HVO optimization for that page.

The new path panics on any non-zero return.  Is the panic intended,
given that vmemmap_populate_hvo() returns -ENOMEM on allocation
failure and HVO is normally treated as an optimization rather than a
hard requirement?

> +		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
>  
>  		pnum = pfn_to_section_nr(pfn);
>  		ns = psize / section_size;
> @@ -800,60 +813,6 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
>  
>  void __init hugetlb_vmemmap_init_late(int nid)
>  {
> -	struct huge_bootmem_page *m, *tm;
> -	unsigned long phys, nr_pages, start, end;
> -	unsigned long pfn, nr_mmap;
> -	struct zone *zone = NULL;
> -	struct hstate *h;
> -	void *map;
> -
> -	if (!READ_ONCE(vmemmap_optimize_enabled))
> -		return;
> -
> -	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
> -		if (!(m->flags & HUGE_BOOTMEM_HVO))
> -			continue;
> -
> -		phys = virt_to_phys(m);
> -		h = m->hstate;
> -		pfn = PHYS_PFN(phys);
> -		nr_pages = pages_per_huge_page(h);
> -		map = pfn_to_page(pfn);
> -		start = (unsigned long)map;
> -		end = start + nr_pages * sizeof(struct page);
> -
> -		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
> -			/*
> -			 * Oops, the hugetlb page spans multiple zones.
> -			 * Remove it from the list, and populate it normally.
> -			 */
> -			list_del(&m->list);
> -
> -			vmemmap_populate(start, end, nid, NULL);
> -			nr_mmap = end - start;
> -			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
> -
> -			memblock_phys_free(phys, huge_page_size(h));
> -			continue;
> -		}
> -
> -		if (!zone || !zone_spans_pfn(zone, pfn))
> -			zone = pfn_to_zone(nid, pfn);
> -		if (WARN_ON_ONCE(!zone))
> -			continue;
> -
> -		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
> -					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
> -			/* Fallback if HVO population fails */
> -			vmemmap_populate(start, end, nid, NULL);
> -			nr_mmap = end - start;
> -		} else {
> -			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
> -			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
> -		}
> -
> -		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
> -	}
>  }
>  #endif
>  
> -- 
> 2.54.0
> 
> 

