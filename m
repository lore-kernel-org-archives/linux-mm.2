Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD67F606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEkoK3pY
Received: by kanga.kvack.org (Postfix)
	id BF0D96B05B1; Mon,  9 Nov 2026 15:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A6F6B05B2; Mon,  9 Nov 2026 15:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42416B05B3; Mon,  9 Nov 2026 15:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 789BF6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:56:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0961CC073F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:56:29 +0000 (UTC)
X-FDA: 85416788898.05.38F8A96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2923F180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:56:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEkoK3pY;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794257787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfwEzavV+xYJ/qlHoaoW30drhhxmWDviLHuBnnT384U=;
	b=sGM123BK3sWzH++x28F+8e51PSfk1pZjvxbAjiO1TB9SyWQJ7j2n7hFR2QlS3mbRuZQjhX
	A9YVUbc1EFYdH+NyNomYonXbfs5RP5ya0LkcX88ZWdRcA/1k9BywraeHU1MqyusLUbk5Ru
	D+BQnXshg6gyMmYKnpytUBE5cPPiAZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794257787;
	b=23QNinoB1z/c3DlyqM235ByytYNGBBLuGWRGThEht1SA+wBYeUFNjYhrw5DCHLV34YVTpa
	H/kwOp6ZMrrxfIl1wLKF3wzWKfViiWHXVeHtMH4amxctfaV0z0ZcytacnvtU5PdocC/ZRb
	m8A0/M4nSAXOjrrs+P7Tmq8Y2lidABg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YEkoK3pY;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64C7943957;
	Mon,  9 Nov 2026 20:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA531F0089F;
	Mon,  9 Nov 2026 20:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794257786;
	bh=ZfwEzavV+xYJ/qlHoaoW30drhhxmWDviLHuBnnT384U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YEkoK3pYgClUuurovjn4IRR4mD2Txlxhmoqa/G7rZ2+e5q79pDBdqXxcOJ7krJoLC
	 jU/pFUNYJBiw7JU7g2pDOSCZTuCE7qe+vtOQMrqMkhZ8UO1JaBM//NADZjubtzhhmv
	 zuX6rFq4/4dua65IihVrqaX+thOtlpxYZ1+vU5U16Nw6379xCIiI7EtKdCxTWwj0lQ
	 wBdd8qSxJu5v+k66EBIO4MvWDERzHQyBkSClYKFvY6K1ZrJoeW32j9b1/kJrUZTwPL
	 X/N5Z3sj/QnUEQLZPqIyMu63iQGqFk6bauZjiaSYlpVwUhpncuvIorL9DzZQo0nrCU
	 019r3x59lRrrw==
Message-ID: <4acf6df8-8cdf-4f71-830d-9233db151b2a@kernel.org>
Date: Mon, 9 Nov 2026 21:56:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: simplify cma_declare_contiguous_multi()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: z5nbc1f5gpdzfa7taubhzfx365smgmny
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 2923F180003
X-Rspam-User: 
X-HE-Tag: 1794257786-693771
X-HE-Meta: U2FsdGVkX19s5L13eomCqXnAMXUAHcpMIpGiZJETv0mnnStxx80fXMAfQpeOaadj8EdYp7mAYQ8jtLPE5nu7qaSg7dNkoEOTw260q+OvXP7qwMogkm79ghKxkvMiERBKMtzR8lRrdAe9UG5MyP3oXizZv9YrABibnPOmZzLXwMHmkANPztv95tPEPZgQw8hxiSuJTuHdEEeTkPAQrCJTcQHqb6I8JNcNWAykWeHDgSkEzQhpEGcUi1677nSYCvfYcw91YWHgkXqMYcpppUrMSg3U+4qe7HjoJ49RycYTXWfEA7c/jR69ur1kyIyy18RBBXXL3ckLfx0tLDIbU/Vmw2J8H0n45AYJUEUPsIL34Jg/9TCXBJ1XTA9ALJIZrlC7oojl1H+VS1wpEyQZr2z9Av7L3Hk+4RvnMdMPWGl+AMoigZbKyutT7w6rMDgfDvOZW89KwALsCWCEiLY8DTCca+XFVPXa6FIylhk+unUDsgcXvBTX55brxHj9FmlNBdp31nDPjU6WbLpf7qo/pOu5Hz7Duv54ahgfgcEk0/ptXAry2CZ2jKceuZKoX2vIkTNiWq0F7eJT4Gs5JG9JWwNCFBKFSK6KvNYY7JEbsIBEB0M3Ma8YR96Kb1dl/ogtgNFJotRlEZXS0iiZ88cYdg+0KlbGk4QI86Wsv9oy7TrYdkFN7Gr84x6FgjbdoeoR/mDOz18vRvRUY2LDUZVRJKOE/Fe6lqiXw80KBOC5bpsx6pL1QQnNEEnl7qmzgt8GJ+JcLljPCxzRfdq4BbKv2JMOX0XIvJbhgIPkGcQyvDM/pHhny/fpH1mOWIIgFwtTkkjTJU8LBG49Vcn74AkGXJjQVcpsHOMnZ2oPktBv9kMGbiDlrs+JzNV7544Bg4dYP8PpGb07QHz7tl2OmTnH1q4q2IH/fCcHzjIuJnIO+AkbdNHHSjRSeTISRN8q0pym7Swdwv4P0ljLSjPiZieaugd
 OPOpxuXF
 8obIcQ+LPZMXh+B0wGFz63eaXqmEUoHX4y0rF+7tUdAj0MdlhdpLR599KZ7QmMsxB7n2ZFyWi7N74UlEAvhYcrBvi/rpf0nOtmO+88PZ9xwyXaJHOEpmOFrgrBIuX5TpVj1zBwqbm/IDIOCnKCYOFM6u8sdQyP3R7MWuC7eIFFqLR2GsBLNfnTCjPf7ayFX10tR4rf+oSVA5GPfhTIghuSvUTEqsABNfW0nBuB/xCDPINFV5CMkLGT4i0RRlMfTUpZ/aoQn6KgGCvd1wbFg3PA2fFlU5fRyVcxXuQdovgw2gf21i+K2B4cz00UU+0fQrTndHD4aPOmBdwVfs9LFCGKgw+RKmqfHdgQfO+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 13:56, Mike Rapoport (Microsoft) wrote:
> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
> 
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
> 
> This implementation has two bugs:
> 
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
> 
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
> 
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
> 
> And overall it is a lot of list management and open coded range
> selection for no real gain.
> 
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
> 
> After successful alocation sort the cma->ranges by their base address.
> 
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Reported-by: Ivy Lopez <skunkolee@gmail.com>
> Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

[...]


Quite the simplification :)

>  int __init cma_declare_contiguous_multi(phys_addr_t total_size,
>  			phys_addr_t align, unsigned int order_per_bit,
>  			const char *name, struct cma **res_cma, int nid)
>  {
> -	phys_addr_t start = 0, end;
> -	phys_addr_t size, sizesum, sizeleft;
> -	struct cma_init_memrange *mrp, *mlp, *failed;
> +	unsigned long size_mb = (unsigned long)total_size / SZ_1M;

Nit: could be const.

> +	phys_addr_t size, remaining, size_align;
>  	struct cma_memrange *cmrp;
> -	LIST_HEAD(ranges);
> -	LIST_HEAD(final_ranges);
> -	struct list_head *mp, *next;
> -	int ret, nr = 1;
> -	u64 i;
> +	phys_addr_t start = 0;
>  	struct cma *cma;
> +	int nr = 0;
> +	int ret;
>  
>  	/*
>  	 * First, try it the normal way, producing just one range.
>  	 */
>  	ret = __cma_declare_contiguous_nid(&start, total_size, 0, align,
>  			order_per_bit, false, name, res_cma, nid);
> +	if (!ret) {
> +		pr_info("Reserved %lu MiB at %pa\n", size_mb, &start);
> +		return 0;
> +	}
>  	if (ret != -ENOMEM)
> -		goto out;
> +		goto err;
>  
>  	/*
>  	 * Couldn't find one range that fits our needs, so try multiple
> @@ -572,151 +556,56 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
>  	 * aligned to @align, and a size that is aligned to
>  	 * both @align and @order_to_bit, things will work out.
>  	 */
> -	nr = 0;
> -	sizesum = 0;
> -	failed = NULL;
> -
>  	ret = cma_new_area(name, total_size, order_per_bit, &cma);
> -	if (ret != 0)
> -		goto out;
> +	if (ret)
> +		goto err;
>  
>  	align = max_t(phys_addr_t, align, CMA_MIN_ALIGNMENT_BYTES);
> -	/*
> -	 * Create a list of ranges above 4G, largest range first.
> -	 */
> -	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
> -		if (upper_32_bits(start) == 0)
> -			continue;
> -
> -		start = ALIGN(start, align);
> -		if (start >= end)
> -			continue;
> -
> -		end = ALIGN_DOWN(end, align);
> -		if (end <= start)
> -			continue;
> +	size_align = max_t(phys_addr_t, align, PAGE_SIZE << order_per_bit);
>  
> -		size = end - start;
> -		size = ALIGN_DOWN(size, (PAGE_SIZE << order_per_bit));
> +	remaining = total_size;
> +	while (remaining && nr < CMA_MAX_RANGES) {
> +		size = cma_find_free_range(align, size_align, nid, &start);

That's more a memblock helper than a cma helper :)

[...]

> +	/* allocate from lower addresses first */
> +	sort(cma->ranges, nr, sizeof(cma->ranges[0]), cma_range_cmp, NULL);

That's nice.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

