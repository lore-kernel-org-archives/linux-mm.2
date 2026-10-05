Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5219CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 13:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E8E6B0088; Mon,  5 Oct 2026 09:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EDF6B008C; Mon,  5 Oct 2026 09:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44536B0092; Mon,  5 Oct 2026 09:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC8D6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:24:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0752FA025C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 13:24:33 +0000 (UTC)
X-FDA: 85288642026.14.CA8323B
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8872C14000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 13:24:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="sx9I/9Qw";
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791206671;
	b=sDN1y+QsoVKiT1g/1j7ZP7u+dGn9+3h16460rS+ocUeIvAA7JbT+gzSOdo6UiyKFOYzHNq
	GgrMkQXGs5sTmWZpd0obZfLB3RwzxavgIDvEzVC9H54pP9m1linuZ4lhfVGzR4yxtMWOKw
	UX0rLTjbzdL6AD36bnYDPhJVzRQ+2o4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="sx9I/9Qw";
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791206671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsApw2S/DbZZ+Xn0zXV8BIb2V2dRdoz7xDCzcJK011o=;
	b=z6Vwb0aDQBHouddr9TL75kg7KVGezqmmUU7s6YCVdImc1EKNVqVZHQ6o5iM4Dp1f25DASq
	wS25bPV09bWN/s2EwDq1pViP8dTnfECWJiKPOzybYLazMmk8XCacvlf57Sefi+LK0L5jxd
	D2lpA9hMCwoO/WvRBJNN9GSKyjayhv0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791206663; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=LsApw2S/DbZZ+Xn0zXV8BIb2V2dRdoz7xDCzcJK011o=;
	b=sx9I/9Qw2hs6PrPDRaSTJQ+ZCuOpcGdciVfUJT23nYmJsZhPiBwmaavSaC0Ai5Y3qnwWt7qYHU5+BdOCBJzEDc/OzmbYG89fQwfA0/cv9GxF81w9YGefCKVdTJBflHfa6HEQA/AtpvIB25vrCL9Ynq5FaVIwbV55eS0pAY9oV2E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XCB2SCi_1791206648;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XCB2SCi_1791206648 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 05 Oct 2026 21:24:21 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: walk runs of consecutive pages in
 do_pages_stat_array()
In-Reply-To: <20261002-bug-mm-move-pages-stat-batch-v2-1-f73b5d20519f@gmail.com>
	(Qiliang Yuan's message of "Fri, 02 Oct 2026 09:25:26 +0800")
References: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
	<20261002-bug-mm-move-pages-stat-batch-v2-1-f73b5d20519f@gmail.com>
Date: Mon, 05 Oct 2026 21:24:07 +0800
Message-ID: <87v77ggu14.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8872C14000D
X-Rspam-User: 
X-Stat-Signature: 6hw4a6nawsoyduc1fk3pfpp8ocaoymzr
X-HE-Tag: 1791206666-936839
X-HE-Meta: U2FsdGVkX1+8fwJJXM/Op4BQStjYoCR4h6UZGy6MmLRx87kjKRtt/SHM2DwzwPc2qWyU4XJH6dAS3FISFF4gmifrePTIiij+tsmHVUY61m/6TAKCEiAUSCHhoNOEcdNpRfnw8tcT6NnXj5yKeCxbty2l8SreFAKwrYw8RJ1YkefBqYaMeQhqLGKVpWOAGmQzDsDbQbJO1s5UbRML7twJtmMGVEtcl4SpqtWgnmLfeLHmUPE01Ht34RPgEfwPO4xWT6SaOM0E9jXLJ8hgTJb5c12umoy6vUVnjUZLUcLEQ1MB/rIY5eJ52udw8Zv/zlZ7dYF+JG58Cp00YCC61iEQRZZKJh1QVYHrmu4hPmnjwaeC4j2oOpmcwOdnz6b9ZWd7cnDFZ6v7Uk+AO0b2gwh7FjruAVVBBZ+fsfaKAyD1XomdOgpoMwLMlK9Xd5rqLRvMXMT6q4tBpLM2kFxILzfUZJFNZSkpPue62lEQKfPpu0PO4Eaw7foSRSY+e4JygyZ5AivjDvSBQH8Y/h00TLkQyb9YB37axZqIJFLTfo7ED58vwcnqlv52vk4z9rg7tEiYkiF0MZSgFGFShH2A/st/bfFTR9MYePkJBOrlW8UaufVchwHILGP67rTaJs4nwkibmB1riNN5WIxQLiiRFEobbFH/OuzvUqlX6f5TuIi+0j8Z2tJaadBNXUiwJGN58GJOT+0Z7NWMYJaYoqL+MjxQkwUk+N4jwtby1r45K7ucDv+hMrsoZWMzSi5zUNaX49jfL78yUgIvXi27iriyWHRNn6OuJkqRRt9gD+lYaZvh3ywuBbYarf690knlMzdTnO4vDpl1j9A7rj6FK5TQlI8/CAc3XNpl5oNJkwEUz/XCl2acyMEOxv/wQPWV1rrXHuUKyQjLMb1nzwqZEaYZ5pSlAFPnK/P/w/jENUCPYhj4YVnZBR4JahcwSiI4q5CezNexts4dXHS4khEBKd2At0N
 ClDtp2qo
 REki/63sVcWqijLtJnh6DJuuf+F8ak9owDd1fYZuG61jrZPfgdh9Vp/KasmcLFrkTDbWs/MMhVdQ6vOcyPeQmClWYxqlNLl8FYbj30QClZcbl/45tpo01PQHf0cyaKKGkbde0ACqa5yBfyr44gCI5ae5HTd+isKUxbmsaN/91tjmNrODTrbURHpYB7gQBHlxYCxevxj5SvwQMtewI8qn0liBgm3j6ltIcbbmH2UXiwAZBXBjqccMZnZ2D+wRPHjteZ25J9V/yCVBXP0uZLBcqlTgkHCDpWMUs4+T9uVL29jaiBvXXH/91OZ462Y25xkHaGD7HEUg5uLjXURgxwki+dYrMzmyMQbgh8t/JqEc/S7F5g27Jb0JIMvY0XT3tPMnukmBbwnnv3E6CQLMpQyo6h3dYMdDmvDzsi9R8JqHtrQUQKaT53/xeyzW8r3oHIDTbFsd8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Qiliang,

Qiliang Yuan <odys.yuan@gmail.com> writes:

> move_pages() with a NULL node list reports the node of each page. RDMA
> and KV-cache transfer engines use it to find where large registered
> buffers live, querying every 4K page of buffers that span hundreds of
> gigabytes.
>
> do_pages_stat_array() looks up the VMA and walks the page tables from
> the top for every address, taking and dropping the PTE lock each time.
> That costs about 105 ns per page, so a 16 GiB buffer takes 486 ms.
>
> Callers almost always pass consecutive addresses. Group them into runs
> and walk each run with walk_page_range(), which looks up each VMA and
> PTE table once and answers every page under it while holding the lock.
> Report pages as folio_walk_start() with FW_ZEROPAGE found them: the node
> of a normal folio, -EFAULT for the zero page or an address outside any
> VMA, and -ENOENT otherwise. Handle PUD and hugetlb leaves in their own
> callbacks so that the walk never splits them.
>
> On 7.3-rc5 in a 16-vCPU VM, querying every page of a populated 4 GiB
> buffer:
>
>                 before    after
>   4K pages      105 ns    31.9 ns
>   THP           90 ns     23.1 ns

As pointed out by David, nanosecond-level optimization for a not-so-hot
path isn't very attractive.  I understand the target of your
optimization is not the performance of a single page but that of a large
number of pages (such as 16 GiB).  So, please describe more clearly why
your change is necessary, for example, by providing the performance
improvement of querying 16 GiB memory.

Additionally, the raw performance number depends on the system under
test.  Please provide a little more information about your testing
system, for example, the CPU architecture, generation, physical core
count, etc.  For comparison, the performance improvement percentage
would also be helpful.

---
Best Regards,
Huang, Ying

> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  mm/migrate.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 162 insertions(+), 26 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa7..f4d8bfb9b7b4a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2451,44 +2451,180 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  	return err;
>  }
>  
> +struct pages_stat_walk {
> +	unsigned long start;
> +	int *status;
> +};
> +
> +static void pages_stat_set(struct pages_stat_walk *psw, unsigned long addr,
> +			   unsigned long end, int stat)
> +{
> +	int *status = psw->status + ((addr - psw->start) >> PAGE_SHIFT);
> +
> +	/* end wraps to 0 for the last page of the address space */
> +	for (; addr != end; addr += PAGE_SIZE)
> +		*status++ = stat;
> +}
> +
> +static int folio_stat(struct folio *folio)
> +{
> +	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
> +		return -EFAULT;
> +	if (folio_is_zone_device(folio))
> +		return -ENOENT;
> +	return folio_nid(folio);
> +}
> +
> +/* Report pages the same way folio_walk_start() with FW_ZEROPAGE finds them. */
> +static int pages_stat_pud_entry(pud_t *pudp, unsigned long addr,
> +				unsigned long end, struct mm_walk *walk)
> +{
> +	struct page *page;
> +	spinlock_t *ptl;
> +	pud_t pud;
> +	int stat;
> +
> +	if (!IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES))
> +		return 0;
> +	pud = pudp_get(pudp);
> +	if (pud_present(pud) && !pud_leaf(pud))
> +		return 0;
> +
> +	ptl = pud_lock(walk->mm, pudp);
> +	pud = pudp_get(pudp);
> +	if (pud_present(pud) && !pud_leaf(pud)) {
> +		spin_unlock(ptl);
> +		return 0;
> +	}
> +	stat = -ENOENT;
> +	if (pud_present(pud)) {
> +		page = vm_normal_page_pud(walk->vma, addr, pud);
> +		if (page)
> +			stat = folio_stat(page_folio(page));
> +	}
> +	pages_stat_set(walk->private, addr, end, stat);
> +	spin_unlock(ptl);
> +	walk->action = ACTION_CONTINUE;
> +	return 0;
> +}
> +
> +static int pages_stat_pmd_entry(pmd_t *pmdp, unsigned long addr,
> +				unsigned long end, struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +	struct page *page;
> +	spinlock_t *ptl;
> +	pte_t *ptep;
> +	pmd_t pmd;
> +	int stat;
> +
> +	pmd = pmdp_get_lockless(pmdp);
> +	if (IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) &&
> +	    (!pmd_present(pmd) || pmd_leaf(pmd))) {
> +		ptl = pmd_lock(walk->mm, pmdp);
> +		pmd = pmdp_get(pmdp);
> +		if (pmd_present(pmd) && !pmd_leaf(pmd)) {
> +			spin_unlock(ptl);
> +			goto pte_table;
> +		}
> +		stat = -ENOENT;
> +		if (pmd_present(pmd)) {
> +			page = vm_normal_page_pmd(vma, addr, pmd);
> +			if (page)
> +				stat = folio_stat(page_folio(page));
> +			else if (is_huge_zero_pmd(pmd))
> +				stat = -EFAULT;
> +		}
> +		pages_stat_set(walk->private, addr, end, stat);
> +		spin_unlock(ptl);
> +		return 0;
> +	}
> +
> +pte_table:
> +	ptep = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
> +	if (!ptep) {
> +		walk->action = ACTION_AGAIN;
> +		return 0;
> +	}
> +	for (; addr < end; addr += PAGE_SIZE, ptep++) {
> +		pte_t pte = ptep_get(ptep);
> +
> +		stat = -ENOENT;
> +		if (pte_present(pte)) {
> +			page = vm_normal_page(vma, addr, pte);
> +			if (page)
> +				stat = folio_stat(page_folio(page));
> +			else if (is_zero_pfn(pte_pfn(pte)))
> +				stat = -EFAULT;
> +		}
> +		pages_stat_set(walk->private, addr, addr + PAGE_SIZE, stat);
> +	}
> +	pte_unmap_unlock(ptep - 1, ptl);
> +	return 0;
> +}
> +
> +static int pages_stat_hugetlb_entry(pte_t *ptep, unsigned long hmask,
> +				    unsigned long addr, unsigned long end,
> +				    struct mm_walk *walk)
> +{
> +#ifdef CONFIG_HUGETLB_PAGE
> +	spinlock_t *ptl;
> +	pte_t pte;
> +	int stat = -ENOENT;
> +
> +	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, ptep);
> +	pte = huge_ptep_get(walk->mm, addr, ptep);
> +	if (pte_present(pte))
> +		stat = folio_stat(pfn_folio(pte_pfn(pte)));
> +	pages_stat_set(walk->private, addr, end, stat);
> +	spin_unlock(ptl);
> +#endif
> +	return 0;
> +}
> +
> +static int pages_stat_pte_hole(unsigned long addr, unsigned long end,
> +			       int depth, struct mm_walk *walk)
> +{
> +	/* No VMA at all is -EFAULT, a VMA without the page is -ENOENT */
> +	pages_stat_set(walk->private, addr, end, walk->vma ? -ENOENT : -EFAULT);
> +	return 0;
> +}
> +
> +static const struct mm_walk_ops pages_stat_walk_ops = {
> +	.pud_entry	= pages_stat_pud_entry,
> +	.pmd_entry	= pages_stat_pmd_entry,
> +	.hugetlb_entry	= pages_stat_hugetlb_entry,
> +	.pte_hole	= pages_stat_pte_hole,
> +	.walk_lock	= PGWALK_RDLOCK,
> +};
> +
>  /*
>   * Determine the nodes of an array of pages and store it in an array of status.
>   */
>  static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
>  				const void __user **pages, int *status)
>  {
> -	unsigned long i;
> +	unsigned long i, n;
>  
>  	mmap_read_lock(mm);
>  
> -	for (i = 0; i < nr_pages; i++) {
> -		unsigned long addr = (unsigned long)(*pages);
> -		struct vm_area_struct *vma;
> -		struct folio_walk fw;
> -		struct folio *folio;
> -		int err = -EFAULT;
> +	for (i = 0; i < nr_pages; i += n) {
> +		unsigned long addr = (unsigned long)pages[i] & PAGE_MASK;
> +		struct pages_stat_walk psw = {
> +			.start = addr,
> +			.status = status + i,
> +		};
>  
> -		vma = vma_lookup(mm, addr);
> -		if (!vma)
> -			goto set_status;
> +		/* Walk runs of consecutive pages in one go */
> +		for (n = 1; i + n < nr_pages; n++) {
> +			unsigned long next = (unsigned long)pages[i + n] & PAGE_MASK;
>  
> -		folio = folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
> -		if (folio) {
> -			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
> -				err = -EFAULT;
> -			else if (folio_is_zone_device(folio))
> -				err = -ENOENT;
> -			else
> -				err = folio_nid(folio);
> -			folio_walk_end(&fw, vma);
> -		} else {
> -			err = -ENOENT;
> +			if (next != addr + n * PAGE_SIZE || next < addr)
> +				break;
>  		}
> -set_status:
> -		*status = err;
> -
> -		pages++;
> -		status++;
> +		if (walk_page_range(mm, addr, addr + n * PAGE_SIZE,
> +				    &pages_stat_walk_ops, &psw))
> +			pages_stat_set(&psw, addr, addr + n * PAGE_SIZE, -EFAULT);
>  	}
>  
>  	mmap_read_unlock(mm);

