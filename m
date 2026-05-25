Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616A4CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A4D6B0093; Mon, 25 May 2026 02:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972176B0095; Mon, 25 May 2026 02:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE9B6B0096; Mon, 25 May 2026 02:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7927E6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:47:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0549CC0637
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:47:51 +0000 (UTC)
X-FDA: 84805011984.12.7D303F7
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52BC180013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:47:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CiU6boug;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779691670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mh98cAxeer4vCdrfU3hRmg/uMD1K/2JuDcp8hnX2/hs=;
	b=RmHAp3O0Ow+43pb+CTyvMz4v4UqXgFjKXQPc/fqFsS0U7Oqi6xz7oJC7/kdl7s78voMx4p
	WxDtiT/UZxVT192fwIQ5I4SAEi5XMnLNDlgcZW8r+jt+87/cYDyinj9F8EoAkCSHJ7giAn
	bNj1Iq1z+wZ0wx/cyuFW2ss2Vkq3hLA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CiU6boug;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779691670; a=rsa-sha256;
	cv=none;
	b=Wj1cTlbFoJkS9AVI0E3y/pRkzE0o1mS2M4XnZ19vabPYdDhYfr4wXeJQsXD1MecuQ975sx
	3QrkvTonj7ClUZcB/IUmUGNNJXAzaZolhe38nKLyKJ5bju4raqVGxnahpQmz5EH1+kJMAN
	bUjXM/IwKQryV2MEJQT3wQybJzxlFFM=
Date: Mon, 25 May 2026 14:47:34 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779691668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mh98cAxeer4vCdrfU3hRmg/uMD1K/2JuDcp8hnX2/hs=;
	b=CiU6bougXvLS+0AVwos1EB1/2nRQxwgUiglmHsy9dnNoopV1KFRKIihhy9DeRO2QTE1FfH
	tPsbNwZJ0+lKQgPaRIjFMC+P3JoJZ9ovcSh/lLvThW8pmWr9irUAjdn1Fdl/tRgXfOtzdG
	YoMHoRDhRo/gwPUjFrTiVMbF9vVwRQg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	hu.shengming@zte.com.cn, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH v3 2/2] mm, slab: simplify returning slab in
 __refill_objects_node()
Message-ID: <ahPucZOXNmJc04nZ@fedora>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
 <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52BC180013
X-Stat-Signature: 8df3ag7pm9oaq1sauiy75syyusbtm7ep
X-HE-Tag: 1779691670-345471
X-HE-Meta: U2FsdGVkX1/tmPePVOgMcWCibtCt2/qGIJM4g8+dLFggmlmemyVdK2bmnX5w3Ag1nvfTiB1ijOxgEPyDOgRKOA3EOz/4ZStp9xWV4EkMho467o2fLd4Gg0TYIaAVEVhuN6qh4lBV7di91RWdgwA+JdM5zaEhT+C+4QSL7pYeiw3CuMOvFxokYNn+Vuc0Yg1lSHDXAUNdRqskKb3a6uUaGQmQbNTaHdBdyZiRTVUFY3jo/C14CrwLXdfeD2hG5Z4JZ9rXdf1xaHpf3708JXsJeWvkxZqQuY1I31XwMSlhhFeQKizVRd0fTZUXg9D70ShUzKBdzSlMIf5LkLqjel6cnAmmc7rVI4ys6EI5t6tiplsLMmjXtYa4FW2kLg1kMTqcjv74RLakdFed5Qq4eOVdbUxNwBaqKVLDCIwm9IBkgQvf2XelBhJECs2+/sbgB3LAKYb4MhZOH9I1vMkOjEooy9aRgLLqpmtOMiA0k7AvjneXdEYI+1PD6ftRzTVaY7M+nVItqdbXG+EGpOXYAz0rpD77j1LM4qevuS6Sc6OE+x++ft3OX2DutZYJWeyYZHg4vzepkHX43ILwakw+nGWBTt9GWvvRRvJpQ6qO0k3ymiZy8ofcdEJTXfuTX+BddSXniTvGkPloJKmAn+PtN8VYyHblte9qUFQtvvcFXfB+9sLiUxmOl/0D6RD4iiK+fufbhKHri2ryyH3X+99RhfK3VxiD+fV1FyxW002oRa9rIzGzjZiISRsxyMcvNpz4QyecNlSe3IM/eb+BEspivJJvO6mH/JDNA/0oBz53Vh8cAF4jGxsLamHdBAsws47LvpWuAWgqV1bgoBRYB8+ZRKf4K5AQnaXy0yu2YBtw43V0wHJaQc0ekTsSa1nQLVTvJanuEaqA4JhDMENvY4KgdoOn+5uli0Nd+EfqAyr7EhCThGxrwmOfM/ahzSCyQDmPKv+syBnBPy77/dbvCGAzZUD
 DncwGUl+
 aajlzMbh6O/pzni5SLWBIXWEqqjP3E4bl4OBXRIyv4Kicpa5s42EkaUOgiOdwSUAZ1IGMso38D3yHKmgZpxVeyhxNOwfdbzOeY6dHfa1A1EHpxJHaa7i5t/vLHJrKE21mV4fBeucP0DRZjy5lHt+iRn8JvceEcJUkbWN2aR2hGnB6MQZJ8SuSo565mkYYRwxJHXKp191gMgTIVbU7YOXnc11B0A5+YrfcyU4tPedL8h0IFpDoIbJWzf0x1jSHU2J1a7ZPTHHUD8Wt0AmF+pxT47Njhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 04:23:21PM +0200, Vlastimil Babka (SUSE) wrote:
> When we return slabs to the partial list because we didn't fully refill
> from them, we observe the min_partial limit when the returned slab is
> empty, and discard it when over the limit. But it's unlikely for the
> limit to be reached while we were refilling, and the worst outcome is to
> have temporarily more free slabs on the list than necessary.

Just wondering if the empty slabs temporarily exceed the limit and then some
objects get allocated from them, would this lead to more fragmented slabs in
the node partial list?

> So just
> drop that code and simplify the function.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 5816fcfc7a90..074d57c0390b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7196,21 +7196,11 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  
>  		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>  
> -			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> -				continue;
> -
>  			list_del(&slab->slab_list);
>  			add_partial(n, slab, ADD_TO_TAIL);
>  		}
>  
>  		spin_unlock_irqrestore(&n->list_lock, flags);
> -
> -		/* any slabs left are completely free and for discard */
> -		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> -
> -			list_del(&slab->slab_list);
> -			discard_slab(s, slab);
> -		}
>  	}
>  
>  	return refilled;
> 
> -- 
> 2.54.0
> 

-- 
Thanks,
Hao

