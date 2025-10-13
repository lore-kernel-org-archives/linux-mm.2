Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84435CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAAD8E008A; Mon, 13 Oct 2025 17:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2BC8E0031; Mon, 13 Oct 2025 17:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEF78E008A; Mon, 13 Oct 2025 17:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE9468E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:35:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 329CF16064C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:35:41 +0000 (UTC)
X-FDA: 83994398082.27.500C716
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 167C12000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:35:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iuiHMEGI;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760391339; a=rsa-sha256;
	cv=none;
	b=0gm3thIN/R1g8vR8ZYlS+2P4lo9GJeH1XE+4Q4WShVt6V/2e0W+KxZxkfhc6bfMi5DPN5Y
	OCcsAJavskpE1h5kN/wNoSX4E6PwL0avaQ/vaHaKT68VQeDVcir1V3DDE3RI6kRSpGxhZ5
	1tjxy9X2qSkwTcLrTCPu6g1nuvFJUfU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iuiHMEGI;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760391339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPYBsz9pGkaccZ8zsTc8dJhQOz3Z69EhCvUXsfnXcEw=;
	b=EVA7L4RRzn+qW5WTbM+6Rk+/vIK/8I8JkMefDKB0lwPoZPJ7kw2I7Mo22gnMDS/yjOTH+W
	JWHOgHvXUXbLvfFyZDY0U/QvteF81HvEU+i4uSmJ0KLzwInA+yJ4Z4ogMgkB7Ydfr13jAn
	T46b2MMRNcnPm/2FBEwjL1A4keR2tPY=
Date: Mon, 13 Oct 2025 14:35:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760391336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPYBsz9pGkaccZ8zsTc8dJhQOz3Z69EhCvUXsfnXcEw=;
	b=iuiHMEGIr7qkZSeMQxTocOUmuJoL5V6SAxdiC/mkgSEnLO13/XyNWsDjIL5aO/NABfVdmM
	sR9PlyajnkGBvkhbHlCOkLasA30uo8fMIDqpstbEdlm6aKyk2pCFeecAKGU6WqGTMh9UGu
	NxoDle17IfphqPCP6oz4WG36+11j/3k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Barry Song <21cnbao@gmail.com>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Yunsheng Lin <linyunsheng@huawei.com>, 
	Huacai Zhou <zhouhuacai@oppo.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Harry Yoo <harry.yoo@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <dhmafwxu2jj4lu6acoqdhqh46k33sbsj5jvepcfzly4c7dn2t7@ln5dgubll4ac>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: uwqpjd8xou19k3ead7eog1f9jr4b3kbf
X-Rspamd-Queue-Id: 167C12000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760391338-103843
X-HE-Meta: U2FsdGVkX19mBZd/F2NUZeWJDnRK0EOYWHzplSC9ZRHYAPR+0V866V7vpzd8XhyOifKag5QZalokZ6SchS42YHwHv6Qy7x6XFXp86jCGpXXJJOQtiFvH/X0MHFuc4N7ipu/KhFITAiupLbEH3+0+9NP+vxlAvPKeocBIfTabys2SC9SaqC+bBPaXzQcVOz8skDaSZS/2XBG/KKgvHHlA2X+e1l3gJN7tcxn+aHiAThNxBJXP5aC9luwZKclchqHgNqFPZ/B2HFA6X5V80rcag7F42j93AhJz5hinkXVac7m4w3HwQXTRVQzpaOfsCYv1jgPls3Tbbn886CHGlDmqnWBKqKkKKvaRdfXzun1Fv28slZ1QayYQFZkIVfCxnWmBqtqa7Gmnsy2pbW7JnpOy0cuAlPnVqDGNSETo7V82wssdPICmKo4KJ0YwCmAA5TFxXf9ZtNPzawJqSP+saOtBqAF2FRBMTYq0pnDnaIUwgk/jb9Uem6wq4v8jnOUMAZkjNlkVrFR9fbsqlnrYs8Q+G2uFAqdKc4rTIhzSZyBvocT3qsfAdrUrV5KiNfanktG5NW8YZ3/dh3+NGLc5s1F6Ef7UN7pyVK5K4057Ha5j9t63xLtN5z0O1QRl79+jTvmyA0cn8EfzHCOJedubrf8DuEauQGjoE89JKn37Hp/yzJZ7d48SBWK8BN4pHj0ckChjCojB9wcV0F8mbZlXSz7Kmx2xCn4blHqBP+TMDvBjAS5NZxyMO2gsSfUdRbvb+ExphhKAC3ZmgVTXi/d3ZdMUCLI8clAlgmnocaY0rlWde+JUk2UYhQqreeNO2XNji4g0q4k1p114fnBQrRQ0enxibxlnamDY9Lg6ePWnTXzgyAG6hBQ5ucs+cGn7vb3J2OB8GRy871udTWUURmvBlb8a1dLXYYzALiq7hJKMh5SB0IRNLROs99Bpwv0zGysc5etkX3vppLx9WNOMQiEFYmO
 jEIyLIim
 pdYmIKWHSqzzlqTKBeT7gLyiwp7w/C+nm34YXB8oy2H8XWgbx+RJv6/7X0u9uq3tZxS8BT7fGBbFpVROTaF5aClSDWQwijGT2gmRRDefzUooZhGzVBkDWr+g9c1tq1uJKdMWbHJnTRHE8Z8zA9qfEv/IHV4NBZLejRBJ6iHH0sr8dMOcl3aWupR0qOZJSoXOQeJNWCIJD64i+yRix/zvu+mYEizeRHSM8D5JKc+nSHjmMWzGNZtYhfozm4I2ppSqRtAxcL7bwaHILk8i4t8dKV04Cyg6lGU1K+qHSKehPL/4yGicFpQC/URwqDD/KZ4gQSPZltvb2OYpTMhpoKAc5v9mHfyhdmdE0POpolsIzMgqW9L0INuaz0aJiD4qm0oeHJrvwMCc5b7tW9jTYsHaITx3+bALpxJPysTp6Ccwjr92KLE7x8aHDslAWUbolY/7hHS7c+a13V0YwmC/4PArAl717wCG+FOLGmC8WQqIWdDrErIRGNv4o4ZkumJiK7hNQxQRhDhdHVYNeKIUCjnzMpYW0Q4TsmRnHRauNoQCJzNyT+JGYQwZTfAJt+Ig0/1lcccCdOdg0blLQx2X9Dg/4scpAFGzHwspk7aReibuF1cXZsJLxXh/VK2bNnnULEYemVIawOnIh4CMGSTglXvrz274GUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 08:30:13PM +0200, Vlastimil Babka wrote:
> On 10/13/25 12:16, Barry Song wrote:
> > From: Barry Song <v-songbaohua@oppo.com>
> > 
> > On phones, we have observed significant phone heating when running apps
> > with high network bandwidth. This is caused by the network stack frequently
> > waking kswapd for order-3 allocations. As a result, memory reclamation becomes
> > constantly active, even though plenty of memory is still available for network
> > allocations which can fall back to order-0.
> > 
> > Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static key")
> > introduced high_order_alloc_disable for the transmit (TX) path
> > (skb_page_frag_refill()) to mitigate some memory reclamation issues,
> > allowing the TX path to fall back to order-0 immediately, while leaving the
> > receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
> > generally unaware of the sysctl and cannot easily adjust it for specific use
> > cases. Enabling high_order_alloc_disable also completely disables the
> > benefit of order-3 allocations. Additionally, the sysctl does not apply to the
> > RX path.
> > 
> > An alternative approach is to disable kswapd for these frequent
> > allocations and provide best-effort order-3 service for both TX and RX paths,
> > while removing the sysctl entirely.
> > 
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Kuniyuki Iwashima <kuniyu@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Simon Horman <horms@kernel.org>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Brendan Jackman <jackmanb@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Yunsheng Lin <linyunsheng@huawei.com>
> > Cc: Huacai Zhou <zhouhuacai@oppo.com>
> > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > ---
> >  Documentation/admin-guide/sysctl/net.rst | 12 ------------
> >  include/net/sock.h                       |  1 -
> >  mm/page_frag_cache.c                     |  2 +-
> >  net/core/sock.c                          |  8 ++------
> >  net/core/sysctl_net_core.c               |  7 -------
> >  5 files changed, 3 insertions(+), 27 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> > index 2ef50828aff1..b903bbae239c 100644
> > --- a/Documentation/admin-guide/sysctl/net.rst
> > +++ b/Documentation/admin-guide/sysctl/net.rst
> > @@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
> >  list is then passed to the stack when the number of segments reaches the
> >  gro_normal_batch limit.
> >  
> > -high_order_alloc_disable
> > -------------------------
> > -
> > -By default the allocator for page frags tries to use high order pages (order-3
> > -on x86). While the default behavior gives good results in most cases, some users
> > -might have hit a contention in page allocations/freeing. This was especially
> > -true on older kernels (< 5.14) when high-order pages were not stored on per-cpu
> > -lists. This allows to opt-in for order-0 allocation instead but is now mostly of
> > -historical importance.
> > -
> > -Default: 0
> > -
> >  2. /proc/sys/net/unix - Parameters for Unix domain sockets
> >  ----------------------------------------------------------
> >  
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 60bcb13f045c..62306c1095d5 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -3011,7 +3011,6 @@ extern __u32 sysctl_wmem_default;
> >  extern __u32 sysctl_rmem_default;
> >  
> >  #define SKB_FRAG_PAGE_ORDER	get_order(32768)
> > -DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
> >  
> >  static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
> >  {
> > diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> > index d2423f30577e..dd36114dd16f 100644
> > --- a/mm/page_frag_cache.c
> > +++ b/mm/page_frag_cache.c
> > @@ -54,7 +54,7 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
> >  	gfp_t gfp = gfp_mask;
> >  
> >  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
> > -	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
> > +	gfp_mask = (gfp_mask & ~__GFP_RECLAIM) |  __GFP_COMP |
> >  		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
> 
> I'm a bit worried about proliferating "~__GFP_RECLAIM" allocations now that
> we introduced alloc_pages_nolock() and kmalloc_nolock() where it's
> interpreted as "cannot spin" - see gfpflags_allow_spinning(). Currently it's
> fine for the page allocator itself where we have a different entry point
> that uses ALLOC_TRYLOCK, but it can affect nested allocations of all kinds
> of debugging and accounting metadata (page_owner, memcg, alloc tags for slab
> objects etc). kmalloc_nolock() relies on gfpflags_allow_spinning() fully
> 
> I wonder if we should either:
> 
> 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> determine it precisely.
> 
> 2) keep __GFP_KSWAPD_RECLAIM for allocations that remove it for purposes of
> not being disturbing (like proposed here), but that can in fact allow
> spinning. Instead, decide to not wake up kswapd by those when other
> information indicates it's an opportunistic allocation
> (~__GFP_DIRECT_RECLAIM, _GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC,
> order > 0...)
> 
> 3) something better?
> 

For the !allow_spin allocations, I think we should just add a new __GFP
flag instead of adding more complexity to other allocators which may or
may not want kswapd wakeup for many different reasons.




