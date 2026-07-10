Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63439C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6263E6B008A; Fri, 10 Jul 2026 01:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFC96B008C; Fri, 10 Jul 2026 01:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EE56B0092; Fri, 10 Jul 2026 01:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24D0D6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:18:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A37008D78B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:18:28 +0000 (UTC)
X-FDA: 84971711496.13.66D24FB
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id DC2A41A0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:18:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1q9pxij;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783660707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhKD875aUeJrB1VfoaFiq3+jQv2LC7XAlpRGxkj4Sxg=;
	b=s9a9u+soGbv0TXVNp1OdmfE1rRPEW7rI60EYb9u4IRWk7pIqQ3YPj3RuJXdYEsd6qlhdNM
	boesuapCVD6TkO3bZIDpUXuUjW4q8akIzdYl3ybNZGnzgyStBQhKmvgD3vsDAWF2578yqM
	BZBIfgnWo4oPPhw6v43hkdRxvjQw2Xw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1q9pxij;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783660707;
	b=KPKyiKgTi+mJTjHUK5moIqigmcCNtu1aDz6IZ0LJ9tSMKxpd8sP4UkuSlUNtfYDaXtw2gl
	R/a5xjtYcIuYIOAvaJSy7DwuUB9fKvWIUEUZl76Wivbo35DkuS9pnLgEmgdGr3ze+9J8AA
	oohbZ8HQHppmAUepOx8ExbqB2ugKm6M=
Date: Fri, 10 Jul 2026 13:18:16 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783660705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhKD875aUeJrB1VfoaFiq3+jQv2LC7XAlpRGxkj4Sxg=;
	b=R1q9pxij0lYyjsgLHagWWARkOhYP2VklVTrV5AT+tVG6+/9jGFhprKn+6kQFDOgFtbktTe
	IH6T1MuVwoCtL0hP9Ix2PiLFGPY1PGcdqlm6rmaa++M05WaET8MJPXD+N1FyVjBKzngeQy
	EuS1TX9NJHrLjoXyWDa2nIy+MTkQzyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shengming Hu <hu.shengming@zte.com.cn>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
Message-ID: <alB_hIJFVgFM3HxM@fedora>
References: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC2A41A0002
X-Stat-Signature: txm3kkte3k1f16wu4z93b7c7nh5wrheo
X-HE-Tag: 1783660706-949009
X-HE-Meta: U2FsdGVkX19MliuvlRxZPFq72jmG78IvjK4G2FOn2hVLqxXKYA+7bwwt02FfpQqHDgMK2NZaAIqwLNGfQDc3/RTZeceri96cLoSvcur9whUf9ubv2vqJsUpYYE+hk3MfaoaM260g4UANvOTOOILutrXyiESeHIJlWB/OJE3oI/qw6PtcNz1I+wOGcNjjbhZwz14RDoOUhOmMFFwdFD8+8pQIPmR2BCeInEdraclHQ8D/h4o1VE+76L6hiQd5C2ndzpKSd8DPKYbwHrXaIihqaMM6eU2lsPeho20aEEWeZBd+U81x/u0TOT/86tx4+v2wmpljX1D7DK9x1ZZi/v5Sf2MmJLlp28NKixvP3+FdXFJ32e/r9hUkT8eT3udzsusqgynfmaCS+WuE+mvClnbwsj/JK6F1W4msEBFNg4SeP55KsAma83p96xl8G1SlBMMjyl5+OdFzLEg8DjKPIt/pm7fluqOats/fOvGIbuuHqDfAPftsrecetfVNsLcRdfK5ssxrAuRTegnlIb4eAA+mS6VbjzaajcA1XCVnf2MJiRe7w3Vweu3fVcyAF0SUU0Klec18W/pY9WpIfKof4j2NBjUc3x9BQdQual83d9URsZA8GzeYEuvHuY9NgPtMlmS1Mm79uZkAmJ7LssqffNf/BWJxwcRi/AqOsYoYDGODxgcqr+Ka5o2G3suFiSTYWM//Nd0jp3LQzfI9nIbS8xyg5fM3H44sWXtJw7xd1tZcmKsdAEaeKhtOosYNaCC4oHhst2FFcv4hiluedsgxHBczHTXWDLdbRRRjH8HUZtBaF2/6HBLl5ntFH9FBmMhWFueIr2NufaTJNxNEKte9/F8H8Cjr2rucJrFr1Zc4RXk7c5YLJRPC+NjQsJ1TGkTLfQB9aEASW/gihqkGidZLnJ3ziLfe7yE8rKGYnRM6glt6rVsYh7nWixvsy/bOoHtr9mJVm1F9JTIS4eQ/pHPBI41
 g3+NunpA
 wPO/zDkTjf2EQ31EJ674O+EBLRnq8l72Pvl0eWSvMR5JZdgeSJyS+5x2erZXNrKne5bTS/us5bJrpsVDRBOvSS17SlQuVHZG+gCjxy+1vwRU/biqBL+X2PsGKlFJTGFMOHExBUF8EdQzYJWb/CT7y8pHlz7IH4lO7NJMcdXIxEAIzkVS1fO976krf/qplmW9NviglA3kigyf0IKOk4UX5UBjZiAB0rk77y0OhyjmTGjP+TLsh8CPkW7UEDwnP/+FqlruiGqbbDqXsJyhJJhrPyEKiMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 02:16:00PM +0200, Vlastimil Babka (SUSE) wrote:
> It has been noted that free_to_pcs_bulk() is difficult to follow, with a
> number of goto labels, and this has contributed to two memory leak bugs
> in there.
> 
> Extract part of the code to __free_to_pcs_batch(), which focuses only on
> freeing free-hook-processed local objects to a percpu sheaf, and
> returning how many were freed. Zero means a trylock failure or no empty
> sheaf available, and thus the caller should fallback to
> __kmem_cache_free_bulk().
> 
> Make free_to_pcs_bulk() call this in a while loop, removing all goto
> labels from the function. __free_to_pcs_batch() retains two rather
> straightforward ones.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nice simplification!

[...]
> +/*
> + * Bulk free objects to the percpu sheaves.
> + * Unlike free_to_pcs() this includes the calls to all necessary hooks
> + * and the fallback to freeing to slab pages.
> + */
> +static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> +{
> +	bool init = slab_want_init_on_free(s);
> +	void *remote_objects[PCS_BATCH_MAX];
> +	unsigned int remote_nr = 0;
> +
> +	for (unsigned int i = 0; i < size;) {
> +		struct slab *slab = virt_to_slab(p[i]);
> +
> +		memcg_slab_free_hook(s, slab, p + i, 1);
> +		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
> +
> +		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> +			p[i] = p[--size];
> +			continue;
> +		}
> +
> +		if (unlikely(!can_free_to_pcs(slab))) {
> +			remote_objects[remote_nr] = p[i];
> +			p[i] = p[--size];
> +			if (++remote_nr >= PCS_BATCH_MAX) {
> +				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +				stat_add(s, FREE_SLOWPATH, remote_nr);
> +				remote_nr = 0;
> +			}
> +			continue;
> +		}
> +
> +		i++;
>  	}
>  
> -	if (remote_nr)
> -		goto flush_remote;
> +	while (size) {
> +		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
>  
> -	return;
> +		if (!batch_freed)
> +			break;
>  
> -no_empty:
> -	local_unlock(&s->cpu_sheaves->lock);
> +		p += batch_freed;
> +		size -= batch_freed;
> +	}
>  
> -	/*
> -	 * if we depleted all empty sheaves in the barn or there are too
> -	 * many full sheaves, free the rest to slab pages
> -	 */
> -fallback:
> -	__kmem_cache_free_bulk(s, size, p);
> -	stat_add(s, FREE_SLOWPATH, size);
> +	if (size) {
> +		__kmem_cache_free_bulk(s, size, p);
> +		stat_add(s, FREE_SLOWPATH, size);
> +	}

By the way, could we move this directly into the loop inside the
`if (!batch_freed)` block to make it a bit more concise? but it's totally fine
to leave it as is! :)

>  
> -flush_remote:
>  	if (remote_nr) {
>  		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
>  		stat_add(s, FREE_SLOWPATH, remote_nr);
> 
> ---
> base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
> change-id: 20260707-slab-simplify-bulk-pcs-a8d0478feef6
> 
> Best regards,
> --  
> Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 

-- 
Thanks,
Hao

