Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA802CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CA56B0005; Wed, 17 Jun 2026 02:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA61C6B0088; Wed, 17 Jun 2026 02:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DBD6B008A; Wed, 17 Jun 2026 02:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66FE76B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:29:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEF6F8D2CE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:29:41 +0000 (UTC)
X-FDA: 84888428562.21.1FF96A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2CD8740005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:29:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jUM/P/lJ";
	spf=pass (imf17.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781677780;
	b=x2WkIeSYW8yq8Dk+W8ebBNZNimN0LcTkkfK3FXyuQW8clzN9ULB39LRu73eGmqlw5pGdL6
	5PtSCwPpT7TZNdliSe1aYUCQTHGsjOOkp7Rb9KVbwS3qqwWefFvGRk3QYKmm68ujHLuWJ/
	s5HUAapWRRuEcAoJwR5hAgJiEgGnZt0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jUM/P/lJ";
	spf=pass (imf17.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781677780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYfTT64KgZ64E56cDQTkTsPloeuusoGu/z8O/8d//+c=;
	b=YHNKzlza66AwoynBQ7mIkquLnG14uZhbVEGqU55c90Cu2oC6efcbrDsYCH5u75Hq4pJfTU
	uQ1w19/aQmgkE1Spt7EkMQaSO2KI0G9HgdDo1lCNLo6/VjGwI3qFJPFiSmKllO4XzqcNqT
	C0j6Rh/xRGkN0dcpGawnJxEtgL3+Kdk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54CE640ADE;
	Wed, 17 Jun 2026 06:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D597A1F000E9;
	Wed, 17 Jun 2026 06:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781677779;
	bh=kYfTT64KgZ64E56cDQTkTsPloeuusoGu/z8O/8d//+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jUM/P/lJU5KWnSAdMWichlM1ydsEDUo7xpCyimK2P+cspLmFK2h1JH9e2hz79fHR+
	 8p1otGzUGAzV+0KpXQKLEz5Yd7x+XaPc814gdWM0P7bhc0iA9IJlMNC9g0oyLum7nb
	 /GKYHBejsczgGzYEf8t99+bTwzLg+u0xAJ+g6FqSBB+hQRIsqfWIitbLiYXyUW+5zq
	 gn8bsyud4i0kvY9CqhHje07pQbQ2rQjfh+4Hg1wcQgrlQFdUwl7pvKgQiSvHPe3fN8
	 aVZAmN9ka6O7GaysU0/S6XBNbK5hjV8XlbmsK/nuCblITcn3QDXDQo8Gy3lvVc8mZS
	 5++35FI0bp4qg==
Date: Tue, 16 Jun 2026 23:29:37 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 2/3] mm/percpu: honor GFP constraints when populating
 chunks
Message-ID: <ajI-0ZMWVPPbZa33@palisades.local>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
 <20260612022648.13008-3-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612022648.13008-3-kaitao.cheng@linux.dev>
X-Rspamd-Queue-Id: 2CD8740005
X-Stat-Signature: ojt7o1qi3o3caxtgbatmwswp1rc41wb7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781677780-51275
X-HE-Meta: U2FsdGVkX1/KtG+osALK65qDjB/PU3XpneuUHWtwXg/8UdfQQty+XIgdviIzKKOSGJIX0Chh/3K28lh6Lu+2FUgkHY0G4fyFyOd4QO7nPENdkgCTF8sCp9JzW92vaBNOCKCYNqALop+C01jctFWVrQhWvZRUJaPRjGsr/4nXDnPu7kXBH45sdxdHoGzTyKT/W1U2DJ3/Hz9LvejzH0c1dFdzGaXdlT20EwaeTLXk4xwC7B58a8d7vAZYMi3jtBPRFccJixQA5drtq3yHjpJHqFto8qzeZ/iLfMsZS3161rwl/Ylx56feGEIBJa9m4GWj2wDdoDngwcREMVGi4zK/S8yTxhpNTj9taQyvEJ4KaXHIypqR08JtIcVxhbjqYg3mFUBSKbswDJadiK+blwzkt34RIOaV4SMTuWtIsNryxeaadP4dhusf8snmM5zQc5TYs79qtHvNRYT59vyoAuGk31YG6n4nhzzYOMr42D0qsNsbJFgX0ShIDpwdTSEzu21FuVhS8ZV08skxv9vhYpcgBjxxDa8CDmTEOuOHgx+DyKXeI4tBEkaVsgsHJbbTJ2UwlMvy6caYRKNkarxJVBDhCC8KsTNaF260KyAWOqGbago61aOUHus6gHzLaTgU/8keqTqts2pSQUTXCAgX1RywybcbzmmSOsC5Am0kgWmqOVomTJJfQ7ySdz6b0xPNH7TnLTjFBx/gITaByGrwu+PCLTzB1D7RwDCw6CxVs65XtTVLAIeDTB7GqIHHZ2B7z/4OYtfA8LFfn14JYKgq6Ow4Jnfr/GRDJWgqCbOj+SzoZrhdwfZ2Wp2r3GgOR+49tnqKXkupOzr77NRB9/LUgQeV8W1lVhqIouenjMU/D4k86JtbbTxycDd2SvvszkPzebHWjojF05iim/pZfa6HisdKLd5hK81qK+vWtyYWOip6f7leQQfYf/7YArX3Xfz9XFQQ+e80b11RtY8jF66fmgE
 epDtY/w1
 3ixQRD1WIt5NroH1nz89ZlJT2cImJX2RtzJLyznmG6ANLNci+8IioEu+BLJn+BYzhbFpVPHVSneGu3gj00kKy4obThxinUSfPjoJxRgh0JBEWiSdnCOdUmZPGZVVsISdc5xrNS67O6KoGBaSNfjTVgLbAwMWENcFRv191hdm0/6mBUj74L8RrRdjE9lzIWyrGQ6pgzX28E7+oA2PfUAo9FVuiMHMXyfnMqifBBiFWcgPUzlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 10:26:47AM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
> passes it down to pcpu_populate_chunk().  pcpu_alloc_pages() already uses
> that mask for backing page allocation.
> 
> However, the populate slow path still has internal allocations and page
> table allocations which can lose the caller's allocation context.  The
> temporary pages array is allocated by pcpu_get_pages() with GFP_KERNEL,
> and pcpu_map_pages() maps the backing pages through
> vmap_pages_range_noflush() using GFP_KERNEL.  The latter can allocate
> vmalloc page tables implicitly, so a caller which deliberately uses
> GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while populating
> a percpu chunk.
> 
> This has the same concern as chunk creation: callers such as blk-cgroup
> may use GFP_NOIO because they hold locks which can be involved in queue
> freeze or IO reclaim dependencies.  If an allocation reaches the percpu
> slow path and needs to populate previously unbacked pages, the internal
> GFP_KERNEL allocations can defeat that context.
> 
> One possible case is blk-cgroup after commit 5d726c4dbeed
> ("blk-cgroup: fix possible deadlock while configuring policy").
> blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
> q->blkcg_mutex, and blkg_alloc() was changed to GFP_NOIO for that reason:
> 
>   CPU0: blkg_conf_prep()
>     mutex_lock(q->blkcg_mutex)
>     blkg_alloc(..., GFP_NOIO)
>       alloc_percpu_gfp(..., GFP_NOIO)
>         pcpu_alloc_noprof(..., GFP_NOIO)
>           pcpu_populate_chunk(GFP_NOIO)
>             pcpu_get_pages()
> 	    pcpu_map_pages()
>               -> if the selected percpu chunk has unpopulated pages,
> 	         chunk population may do internal GFP_KERNEL allocations
>               -> direct reclaim / writeback can issue IO to this queue
>               -> IO waits because the queue is frozen
> 
>   CPU1: blkcg_deactivate_policy()
>     blk_mq_freeze_queue(q)
>     mutex_lock(q->blkcg_mutex)
>       -> waits for CPU0
>     ... unfreeze only happens after q->blkcg_mutex is acquired/released
> 
> So the concern is that the caller deliberately uses GFP_NOIO because it
> may hold a lock which can be acquired after queue freeze, but the percpu
> slow path can temporarily lose that allocation context.
> 

Maybe others have different takes on this, but I don't think this needs
a full duplicate explanation in each patch.

> Pass pcpu_gfp through pcpu_get_pages(), pcpu_map_pages() and
> __pcpu_map_pages().  Apply the corresponding memalloc scope around
> vmap_pages_range_noflush(), because vmalloc page table allocation does not
> pass the GFP mask down explicitly.  Keep the first chunk setup path using
> GFP_KERNEL, matching the previous early-init behavior.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/percpu-vm.c | 38 ++++++++++++++++++++++++++------------
>  mm/percpu.c    |  2 +-
>  2 files changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 69b00741dc68..ccd03cc152d4 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -21,6 +21,7 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
>  
>  /**
>   * pcpu_get_pages - get temp pages array
> + * @gfp: allocation flags passed to the underlying allocator
>   *
>   * Returns pointer to array of pointers to struct page which can be indexed
>   * with pcpu_page_idx().  Note that there is only one array and accesses
> @@ -29,7 +30,7 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
>   * RETURNS:
>   * Pointer to temp pages array on success.
>   */
> -static struct page **pcpu_get_pages(void)
> +static struct page **pcpu_get_pages(gfp_t gfp)
>  {
>  	static struct page **pages;
>  	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
> @@ -37,7 +38,7 @@ static struct page **pcpu_get_pages(void)
>  	lockdep_assert_held(&pcpu_alloc_mutex);
>  
>  	if (!pages)
> -		pages = pcpu_mem_zalloc(pages_size, GFP_KERNEL);
> +		pages = pcpu_mem_zalloc(pages_size, gfp);
>  	return pages;
>  }
>  
> @@ -191,10 +192,22 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
>  }
>  
>  static int __pcpu_map_pages(unsigned long addr, struct page **pages,
> -			    int nr_pages)
> +			    int nr_pages, gfp_t gfp)
>  {
> -	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
> -			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
> +	unsigned int flags;
> +	int ret;
> +
> +	/*
> +	 * The vmalloc page table allocation path does not pass @gfp down
> +	 * explicitly.  Apply the corresponding memalloc scope so implicit
> +	 * page table allocations preserve NOFS/NOIO constraints.
> +	 */
> +	flags = memalloc_apply_gfp_scope(gfp);
> +	ret = vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
> +				       PAGE_KERNEL, pages, PAGE_SHIFT, gfp);
> +	memalloc_restore_scope(flags);
> +
> +	return ret;
>  }
>  
>  /**
> @@ -203,6 +216,7 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
>   * @pages: pages array containing pages to be mapped
>   * @page_start: page index of the first page to map
>   * @page_end: page index of the last page to map + 1
> + * @gfp: allocation flags passed to the underlying allocator
>   *
>   * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
>   * caller is responsible for calling pcpu_post_map_flush() after all
> @@ -211,8 +225,8 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
>   * This function is responsible for setting up whatever is necessary for
>   * reverse lookup (addr -> chunk).
>   */
> -static int pcpu_map_pages(struct pcpu_chunk *chunk,
> -			  struct page **pages, int page_start, int page_end)
> +static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
> +			  int page_start, int page_end, gfp_t gfp)
>  {
>  	unsigned int cpu, tcpu;
>  	int i, err;
> @@ -220,7 +234,7 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
>  	for_each_possible_cpu(cpu) {
>  		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
>  				       &pages[pcpu_page_idx(cpu, page_start)],
> -				       page_end - page_start);
> +				       page_end - page_start, gfp);
>  		if (err < 0)
>  			goto err;
>  
> @@ -271,21 +285,21 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
>   * @chunk.
>   *
>   * CONTEXT:
> - * pcpu_alloc_mutex, does GFP_KERNEL allocation.
> + * pcpu_alloc_mutex, does @gfp allocation.
>   */
>  static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
>  			       int page_start, int page_end, gfp_t gfp)
>  {
>  	struct page **pages;
>  
> -	pages = pcpu_get_pages();
> +	pages = pcpu_get_pages(gfp);
>  	if (!pages)
>  		return -ENOMEM;
>  
>  	if (pcpu_alloc_pages(chunk, pages, page_start, page_end, gfp))
>  		return -ENOMEM;
>  
> -	if (pcpu_map_pages(chunk, pages, page_start, page_end)) {
> +	if (pcpu_map_pages(chunk, pages, page_start, page_end, gfp)) {
>  		pcpu_free_pages(chunk, pages, page_start, page_end);
>  		return -ENOMEM;
>  	}
> @@ -319,7 +333,7 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
>  	 * successful population attempt so the temp pages array must
>  	 * be available now.
>  	 */
> -	pages = pcpu_get_pages();
> +	pages = pcpu_get_pages(GFP_KERNEL);
>  	BUG_ON(!pages);
>  

nit: it's a little misleading to pass GFP_KERNEL here because this is
the deallocation path and we expect the pages array to be already
allocated and cached in the static variable.

A little terse might be just passing 0 and checking gfp != 0 to allocate
pages.

A little more verbose could be introducing pcpu_get_pages_cached() to
get to that static variable.

>  	/* unmap and free */
> diff --git a/mm/percpu.c b/mm/percpu.c
> index b0676b8054ed..4d89965cba16 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -3256,7 +3256,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
>  
>  		/* pte already populated, the following shouldn't fail */
>  		rc = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
> -				      unit_pages);
> +				      unit_pages, GFP_KERNEL);
>  		if (rc < 0)
>  			panic("failed to map percpu area, err=%d\n", rc);
>  
> -- 
> 2.43.0
> 

I think this is correct regardless of the nit.

Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis

