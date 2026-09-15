Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4489C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75806B0093; Tue, 15 Sep 2026 04:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E2A6B0096; Tue, 15 Sep 2026 04:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A8C6B0099; Tue, 15 Sep 2026 04:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A51736B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:47:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20E73C037B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:47:07 +0000 (UTC)
X-FDA: 85215366894.20.83A150A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70889C000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:47:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L6RIYB4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L6RIYB4t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789462025;
	b=E/3x/UuD+WliN/I4P35jNXKve8CH5mDgEeKaI4b1AogN13W2mZLnr5kqAn8/0blE5fUt+i
	zH8mNS6gEQdCPfQhGoYWgfl7pk/FNSfzNWXx/OpRUGW2XcMzAbbKWilj1E1k21DD5PT6lw
	X50Y8ygGj2m1CL9N0iGmihc7OXtZZJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789462025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wK2W2uongp7wJVjy1t0+DLgCG6nyVaTFIPWkinS9neo=;
	b=qe1L31lffJ32vGam80r1lIZXbXYNrBiyI3WTsMcfUx5wzAChvkJBSPqJirDpl9vcUQ1N3a
	gBZKhYkGz4iHkmzsImpMyXG5dUIAoiYj0GxtC9YFeEmbsNj65XGA8BIOxW7lQL+7+zqOtv
	CQ9mXga3ljXevRlNFLnAOmZks278H7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 607DA43884;
	Tue, 15 Sep 2026 08:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A91F000FF;
	Tue, 15 Sep 2026 08:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789462024;
	bh=wK2W2uongp7wJVjy1t0+DLgCG6nyVaTFIPWkinS9neo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L6RIYB4texZzX1ZlecKG1L7F0lnZLSfxBR8u1qDQiw//ny+5kmvpADTbQdQjgzLzx
	 xy507JtPyIXGrPhNV6FUzmKHApBnbzfj187VPQ+HF4bvttEby3CskFbaFHeW+gD0cW
	 MWtyeTmRr+AJw90AFI6KKVTgXOIENOGrRgyJ/JZx5Oo48qRwHtN5a/xlVSzdHtrzlZ
	 /nkn/JCrT3gX0g7j3rLkQ/BPejg7dwL/UAI4GMpVNs46aTZMBVFsSFx1aP8arO+RE+
	 W62J32O5vH4w3Zqz9HxXXr0r4ixe6fUc+1k4T3rNPR5vRCARNo+07JQt3TWjt9GJzm
	 K3O/oq+zYtJIg==
Date: Tue, 15 Sep 2026 09:46:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm: Remove unused exact_nid parameter from memmap_alloc()
Message-ID: <aqkE4DhNFWIzgHHo@gremlin>
References: <20260914055130.44543-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914055130.44543-1-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 70889C000B
X-Stat-Signature: e4m5f3e1w3xypzicbs84yoj7tnmm6e1d
X-Rspamd-Server: rspam01
X-HE-Tag: 1789462025-717676
X-HE-Meta: U2FsdGVkX19PiNMxk6Va/wQ2JbSLC/Q+mLBoLyTA6wT96k9Re/NzqIqVMLa61hu5dBTd8BQNGO12jRwaIoWdhhULOghSN3HX1MZMMrh8LdQWW0DNwVuPwFFJF4lWaZ/WJ2ODAgOrz9coha8Ye2SVXal99A6LunLmC4Fs/4tIrnqb69mTPXyKPHShi0Z0IPNf7lzGdYmOEswlwuEH/5TdXkUILINhrSWJ3h2Fo72vQv+FP1UcUrug+U5m7wfrq7kTem9fkhkb/dmtbOpSXvDSP8lWuTTeRXkgLpegI6/jdN0wYe/baUx/oePn1Vy+Sg7AM668R613B+ARZhmmnGwUWSlPYpB5F8wapDZl8BTaSp8YDTXzTYpzIQRnzzIsGbGZMZmy7Uqwp40hqPbcNaBZaierbz7mlywIEx1waqbIXQ21d2J1DpVGrmDIS/Qtj2oc9wP3Qt8jJmywrp9Fr2zwWIMJ09r2FGRTtoQyKqtW9/G6PDqMsT8gNUlaXXieCrw03Rxfu4qWeQ+pdWGG3qf1fxbmmqQWWoL5+JPUwkVhr4TEYRfvcVyhTvWWpMOKxcf7nys/CXDmRF7SvqG5CYaiaQJ6Hr03bzCh6V0ESdk9ZI/5CC3n/wfJERlKndW3Is/zIv7VH6TmHq9eIwwAC9EDKFJpQnJ9ZVNGLV6fn4tM6DkPUs8PULB9s6lh/vJonWnzKY7lhJm+OfALxizO2EMYz6prUdbFAA59dsneeK4SMSOLkgGs9tGHzZfrBiCulDmlmQ8/yjQtLrmIZcTLAKFJgqJeGXevKnb2qUht3MQPwlQ18sFnNmgD3TYQ90mPLhl/GIhe86syHEn4fbf/cG3A6ewqKft1YEM+eDnWANfaP/KBtBd37jj58xq1E380GvwvtqsAlHnX6UjjDQzCxfaYJGb71nutMBvC/ldP1KfuJzn0PQTsF9A/MMazR+pu5pUHnttf9FQ7s2PmmGyEfKV
 i8BU0R7y
 ojzyIlW0J8NR7vJiW5mLA43P9TFLFnx843guUTmXCJCMATDqi6l4zNu6Gz4vAnPOZ9a8Wh0nFPwxJr0C+Nbm+2mnp/SvM371a+E4LFABWw+XzNAOQwgW6Ph41+o/hK+YBvYyQVp4KhOyKRLpAGVcJhqJUeKm7oueha6XbfsJeLkNqfTND05YPZNHricN/nn7FD+DHIoGqTUZ7Cb89i1kp1C3b5yIHgHoVKszs/cV4ZbzjHOSH4lX4+WiWXX5ferajL7rDVqjYMV9jikhoTiRFDgoy72T0o0vH3sScckRbKuHVrQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 01:51:30PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
> mechanism") removed sparse_buffer_init(), which was the only caller of
> memmap_alloc() that passed true for exact_nid.
>
> All remaining callers pass false, leaving the exact-node allocation
> branch unreachable. Remove the exact_nid parameter and unconditionally
> use memblock_alloc_try_nid_raw().
>
> This has no functional impact.
>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/mm_init.c        | 14 ++++----------
>  mm/mm_init.h        |  4 ++--
>  mm/sparse-vmemmap.c |  2 +-
>  mm/sparse.c         |  2 +-
>  4 files changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index beeeed4688c1..6af5cabf3e75 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1601,7 +1601,7 @@ static void __init free_area_init_core(struct pglist_data *pgdat)
>  }
>
>  void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
> -			  phys_addr_t min_addr, int nid, bool exact_nid)
> +			  phys_addr_t min_addr, int nid)
>  {
>  	void *ptr;
>
> @@ -1609,14 +1609,8 @@ void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
>  	 * Kmemleak will explicitly scan mem_map by traversing all valid
>  	 * `struct *page`,so memblock does not need to be added to the scan list.
>  	 */
> -	if (exact_nid)
> -		ptr = memblock_alloc_exact_nid_raw(size, align, min_addr,
> -						   MEMBLOCK_ALLOC_NOLEAKTRACE,
> -						   nid);

I don't see anything else _in the kernel_ reference
memblock_alloc_exact_nid_raw(), though I do see some stuff in
tools/testing/memblock/tests/alloc_exact_nid_api.c.

So I suggest removing memblock_alloc_exact_nid_raw() and
tools/testing/memblock/tests/alloc_exact_nid_api.c (and updating the testing to
account for it as necessary) too.

Also I see both memblock_alloc_try_nid_raw(), memblock_alloc_exact_nid_raw() and
memblock_alloc_try_nid() call memblock_alloc_internal() with an exact_nid last
parameter too.

Only memblock_alloc_exact_nid_raw(), which you should delete, passes this
parameter as true, so you should drop this parameter too.

AND THEN :) it passes exact_nid to memblock_alloc_range_nid() and... I leave it
to you to go investigate if that ever has exact_nid=true passed there.

Let's clean this up all the way please!

> -	else
> -		ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
> -						 MEMBLOCK_ALLOC_NOLEAKTRACE,
> -						 nid);
> +	ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
> +					 MEMBLOCK_ALLOC_NOLEAKTRACE, nid);
>
>  	if (ptr && size > 0)
>  		page_init_poison(ptr, size);
> @@ -1644,7 +1638,7 @@ static void __init alloc_node_mem_map(struct pglist_data *pgdat)
>  	end = ALIGN(pgdat_end_pfn(pgdat), MAX_ORDER_NR_PAGES);
>  	size =  (end - start) * sizeof(struct page);
>  	map = memmap_alloc(size, SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
> -			   pgdat->node_id, false);
> +			   pgdat->node_id);
>  	if (!map)
>  		panic("Failed to allocate %ld bytes for node %d memory map\n",
>  		      size, pgdat->node_id);
> diff --git a/mm/mm_init.h b/mm/mm_init.h
> index c9fc35e7e9f1..a8ed5c20851b 100644
> --- a/mm/mm_init.h
> +++ b/mm/mm_init.h
> @@ -31,8 +31,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
>
>  void memblock_free_pages(unsigned long pfn, unsigned int order);
>
> -void *memmap_alloc(phys_addr_t size, phys_addr_t align, phys_addr_t min_addr,
> -		int nid, bool exact_nid);
> +void *memmap_alloc(phys_addr_t size, phys_addr_t align,
> +		   phys_addr_t min_addr, int nid);
>
>  void memmap_init_range(unsigned long size, int nid, unsigned long zone,
>  		unsigned long start_pfn, unsigned long zone_end_pfn,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index f22d815d7af0..c2fa5fbf0972 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -53,7 +53,7 @@ static void * __ref __earlyonly_bootmem_alloc(int node,
>  				unsigned long align,
>  				unsigned long goal)
>  {
> -	return memmap_alloc(size, align, goal, node, false);
> +	return memmap_alloc(size, align, goal, node);
>  }
>
>  void * __meminit vmemmap_alloc_block(unsigned long size, int node)
> diff --git a/mm/sparse.c b/mm/sparse.c
> index cc28bb41fdb1..f032c98b92d9 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -215,7 +215,7 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
>  {
>  	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
>
> -	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
> +	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid);
>  }
>  #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
>
> --
> 2.54.0 (Apple Git-157)
>

--
Cheers, Lorenzo

