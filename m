Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58FC1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458556B0088; Fri, 10 Jul 2026 01:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4093D6B0092; Fri, 10 Jul 2026 01:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA9E6B0093; Fri, 10 Jul 2026 01:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 090F36B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:21:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7485DA0360
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:21:38 +0000 (UTC)
X-FDA: 84971719476.20.AA78E7A
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id A84A940002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:21:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WBis7U+m;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783660896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/41ri3xvxu3vsNe/Fvn4VJ+MCvfys4SQAyvquWjtKE=;
	b=5OqVezdda0tb1KkjbOTRX9X3vk/HPw9xEdbPyUqgIF9MjMDl1AnQZtzMd4bi6bGsaFSapg
	kjIXdN2ub5ZvWuF1m8hn1YFefXD2O7BmprvHla0KYNOMiDvOORdIbJ3kyUX6bqer5A9nWZ
	TWPUDkvfXJxIu6fdQ2Fzfk7QatOW+cE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WBis7U+m;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783660896;
	b=ZAWb2/4U4tEFXz0P39h2S3KNSd9b+U/urf0DYTa5EwBKS71tx5PeE+X0NF2JkXsNNi94so
	8KIUYo/IcmYIRJrrb3f3QWjDNJ652qHb0/0kABHY4XqqeCU9ixQLsUwERwEEZfL4YKNQiY
	/jFyCKE6+1ITOOL93+MN+XFcZhyM+zY=
Date: Fri, 10 Jul 2026 13:21:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783660894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/41ri3xvxu3vsNe/Fvn4VJ+MCvfys4SQAyvquWjtKE=;
	b=WBis7U+mrG+jKIVHHy7VOdGsiYMs8W1kD3FRqsNzcKblgGrsyqu8lkXT5S+3PJk6+ocl3Y
	14XG6CVzz32dolugPBP9M4+IGmX6/YMC5sZnk/e1LkumrE4imWr3sGPX9V8Td6mNwDQdlT
	rf/g6ySQ79tY2TnXF1ihz61A6FbUi7E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shengming Hu <hu.shengming@zte.com.cn>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
Message-ID: <alCAyjxEDM7PmsRy@fedora>
References: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
 <alB_hIJFVgFM3HxM@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alB_hIJFVgFM3HxM@fedora>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A84A940002
X-Stat-Signature: ouwu15ao1ooqfzzcopt5z6yocoir4smt
X-HE-Tag: 1783660896-911192
X-HE-Meta: U2FsdGVkX1/R7QhDHWOHSRUkhVzhb9GutDI+8IvrJ1nftd13H2+AbNepoJ2dp6DT+oRc9XHXyZKeOiT7l3Pef3wSJg1atIJZcYSx5CPtdljUb69ozXYzt1IBvZ24G6pWJV3g2d9XyWRbp4Raonri977IJgDAAlBgc0Ppqja6KgmTqY5QTLm/egXmaOdS3fPZt7zRW0r9kwm6910v6Imfmuf96TvYugFqMlVZl7xqH3a7DMYbU0JkbWRfsZCn+3Ly2ynzCT0ETFzg4VLUhg/fNUIVHG/jqyq0cP49lATGV7BqfF5ehofMVa7EeuZQ4ZNWlIK7GxlWdFnIPJwgNvNHUCKbetlj1ltoyGaq9UnMFtHxyb6cBfnm2j3cq0aBsWebOQYdH1xq2X0RQPPjshdJZw63AEK2WgFyqlrWKz+Xi1TL6uXhoY4Q3vxvRt437hE50H0XpfPrI4/v/E1krK5fy2OQd2hh1Pi/qgTd3GvlMWiT12dBHTfsaRBKUAzoPyekzc9thaJ/7t/I2Ywv4Ua7keXvkGNeSodDk1IM4IROtOcEPKl1GjlDXSvdgWSYLTabmwCEc6NX18at4zUgBlm7YguKH3EZ8uLlmwqPD/xvRbUfDFgXA2ND53o3nfHNKfBQKYXlUrY/CU2SZOViY6AR8aPcjFDvUlz3ou6+vPykY7unAzD9U10nxhU7VXrQ906KCYSCMCEH5mqXx3KWmeyISJQA/C3hezRmsTixpzf7KXuI+gsjgd9Xbgb2+p/+f6NFJZaWPO3TqgEv/qSJLmvPzJm1mkAnxNpj0zhMV9kPk4oiu1szKVVMRhS8gwXowEUAE+mEHEbtsYJ0+77QQgBPEA5Ue1OXdHenh61l0WWOK9nr2XGhiiPs3Rb5Yswtl+4tE9tfTzYocNtU32gf66laJquN9DjueDFhXl6KvRbjyCWRqpgP92+aQceMUGoc8u7GdwjV9EI/sy2nvcmbgf7
 A0cyKPWK
 1XuIWYkNsJNW1WPvyrTZbhh6L1TRFhFjlEHGnuzF/SxaEkLg/cSs5yqKnMQyEIrdFVPKw9dzKVknDPu8+GbPRBSAEpS8xHJDQVAWNziBIVg1/gJJdgt7gORU1vJbIyd+rXSZM1xJYbgtELpxSMAQV7BqmM2XJOyNav3zdDoYNAQfRHtLHuEw6wMVDnIT840y3vNi0DJD4cZY6UXayucSAJDPmhoBXMApzbuC+go/rPe0JPAxw5QaLaVfmswQgYgNrV1YKvD6hhVLZ02ynP9uZO29FZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:18:25PM +0800, Hao Li wrote:
> On Tue, Jul 07, 2026 at 02:16:00PM +0200, Vlastimil Babka (SUSE) wrote:
> > It has been noted that free_to_pcs_bulk() is difficult to follow, with a
> > number of goto labels, and this has contributed to two memory leak bugs
> > in there.
> > 
> > Extract part of the code to __free_to_pcs_batch(), which focuses only on
> > freeing free-hook-processed local objects to a percpu sheaf, and
> > returning how many were freed. Zero means a trylock failure or no empty
> > sheaf available, and thus the caller should fallback to
> > __kmem_cache_free_bulk().
> > 
> > Make free_to_pcs_bulk() call this in a while loop, removing all goto
> > labels from the function. __free_to_pcs_batch() retains two rather
> > straightforward ones.
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Nice simplification!
> 
> [...]
> > +/*
> > + * Bulk free objects to the percpu sheaves.
> > + * Unlike free_to_pcs() this includes the calls to all necessary hooks
> > + * and the fallback to freeing to slab pages.
> > + */
> > +static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
> > +{
> > +	bool init = slab_want_init_on_free(s);
> > +	void *remote_objects[PCS_BATCH_MAX];
> > +	unsigned int remote_nr = 0;
> > +
> > +	for (unsigned int i = 0; i < size;) {
> > +		struct slab *slab = virt_to_slab(p[i]);
> > +
> > +		memcg_slab_free_hook(s, slab, p + i, 1);
> > +		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
> > +
> > +		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> > +			p[i] = p[--size];
> > +			continue;
> > +		}
> > +
> > +		if (unlikely(!can_free_to_pcs(slab))) {
> > +			remote_objects[remote_nr] = p[i];
> > +			p[i] = p[--size];
> > +			if (++remote_nr >= PCS_BATCH_MAX) {
> > +				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> > +				stat_add(s, FREE_SLOWPATH, remote_nr);
> > +				remote_nr = 0;
> > +			}
> > +			continue;
> > +		}
> > +
> > +		i++;
> >  	}
> >  
> > -	if (remote_nr)
> > -		goto flush_remote;
> > +	while (size) {
> > +		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
> >  
> > -	return;
> > +		if (!batch_freed)
> > +			break;
> >  
> > -no_empty:
> > -	local_unlock(&s->cpu_sheaves->lock);
> > +		p += batch_freed;
> > +		size -= batch_freed;
> > +	}
> >  
> > -	/*
> > -	 * if we depleted all empty sheaves in the barn or there are too
> > -	 * many full sheaves, free the rest to slab pages
> > -	 */
> > -fallback:
> > -	__kmem_cache_free_bulk(s, size, p);
> > -	stat_add(s, FREE_SLOWPATH, size);
> > +	if (size) {
> > +		__kmem_cache_free_bulk(s, size, p);
> > +		stat_add(s, FREE_SLOWPATH, size);
> > +	}
> 
> By the way, could we move this directly into the loop inside the
> `if (!batch_freed)` block to make it a bit more concise? but it's totally fine
> to leave it as is! :)

oops, forgot to add the r-b tag just now :P

Reviewed-by: Hao Li <hao.li@linux.dev>

> 
> >  
> > -flush_remote:
> >  	if (remote_nr) {
> >  		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> >  		stat_add(s, FREE_SLOWPATH, remote_nr);
> > 
> > ---
> > base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
> > change-id: 20260707-slab-simplify-bulk-pcs-a8d0478feef6
> > 
> > Best regards,
> > --  
> > Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > 

-- 
Thanks,
Hao

