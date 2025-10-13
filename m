Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EA2CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 18:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420808E0056; Mon, 13 Oct 2025 14:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F80A8E0009; Mon, 13 Oct 2025 14:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6738E0056; Mon, 13 Oct 2025 14:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1FB8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:30:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6FF847065
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:30:18 +0000 (UTC)
X-FDA: 83993930916.08.DF88FAF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D0631C0014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:30:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/BfMoyN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EJD4haWl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/BfMoyN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EJD4haWl;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760380216; a=rsa-sha256;
	cv=none;
	b=ASrs6e5qIN/OpjncNcCyncNfmLv8fqjni6f9A4Lrne59zrfW8sqcy1PeR29ZWqKTXsfXIf
	1M8vdfuHzw8ojjDrfNJuyUq8g0rOALzwZZrwKgeMwwlTD+7we2cMIaWGhMA05YV6SnwxR5
	+tX0DfwsrCF55HKOjWB14K6ERgXqSxw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/BfMoyN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EJD4haWl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/BfMoyN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EJD4haWl;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760380216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCORyVE8664QNw67kIxLlSqS7K6mwn4csjydy4owqs0=;
	b=m6G/qznC3S8qeZzd9AghQRGwhUbe0/5C3BPhfV2CF9UGBrlAolUav2GHBpswE6inSQqAvV
	CVQwreSlXqAhWo3sgtTh/7JLpz+Ir7R79eBRf/OZpg+YwJDfUrLSzFLoVJcvAiJtvTTxi8
	B2pn0AceiLxYiOy3Q8htlPRoy1jwXN0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68D291F393;
	Mon, 13 Oct 2025 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760380214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eCORyVE8664QNw67kIxLlSqS7K6mwn4csjydy4owqs0=;
	b=v/BfMoyNDRNDuZGCYnH+/tqK+u0nj83QSa39ZpyNVSj65vevA/GUDXF6YnzaBgh5o+l6nk
	mZp9EBxCsS96CjzPiGqp5Ubk8X10sYVAy1S8VL3g8+zHyu6UHkQrItqAKOts3RWx/guv9X
	8vqI0kefX0z3sT+VvXmM6tIfS86gMoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760380214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eCORyVE8664QNw67kIxLlSqS7K6mwn4csjydy4owqs0=;
	b=EJD4haWl7bR71UAmKZvmtuez6jRUvd7ngtpn/qHmgijW+fgp3FIRsVrz8z04AKYfKMMGF7
	AmbNU1NsMBHeOFDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760380214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eCORyVE8664QNw67kIxLlSqS7K6mwn4csjydy4owqs0=;
	b=v/BfMoyNDRNDuZGCYnH+/tqK+u0nj83QSa39ZpyNVSj65vevA/GUDXF6YnzaBgh5o+l6nk
	mZp9EBxCsS96CjzPiGqp5Ubk8X10sYVAy1S8VL3g8+zHyu6UHkQrItqAKOts3RWx/guv9X
	8vqI0kefX0z3sT+VvXmM6tIfS86gMoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760380214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eCORyVE8664QNw67kIxLlSqS7K6mwn4csjydy4owqs0=;
	b=EJD4haWl7bR71UAmKZvmtuez6jRUvd7ngtpn/qHmgijW+fgp3FIRsVrz8z04AKYfKMMGF7
	AmbNU1NsMBHeOFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39E9613874;
	Mon, 13 Oct 2025 18:30:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IAy4DTZF7WiVBQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 13 Oct 2025 18:30:14 +0000
Message-ID: <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
Date: Mon, 13 Oct 2025 20:30:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer
 allocation
Content-Language: en-US
To: Barry Song <21cnbao@gmail.com>, netdev@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 Jonathan Corbet <corbet@lwn.net>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry.yoo@oracle.com>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20251013101636.69220-1-21cnbao@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251013101636.69220-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 96ssfr64yawu6fbedwsgqyjghrdszj3q
X-Rspamd-Queue-Id: 2D0631C0014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760380215-528231
X-HE-Meta: U2FsdGVkX1+WyUg1mBPDqz6TEAp1NV0XjhYRksE58ACfF+/QDfzS1guxR1/1F+h3KLHT99UFvnKnfKU//QcOynPEVsLUkCQh6DjQl+on9d+f2jqF03wvF2scDdapNFPBwwYcHt7t3U0Mb2sa7MC3KHREcVR2nuwTdSjxQjHLKKONifrL6mfwAF9Ky8hS3K/rx7WmWgocx5sa3VbeLk+nC3owWsnLM6TRnxEELqFNF9hayv7xBR1mUu2c3Yqbq9N2DVCgjrikmDYOsOyHJX+VPVT23UHsi3P+2p2bjXY8htY/TzW3J4gTnrFlcWhUDKiOUwKz33952PGJcQ3vvhdXGn4bBth0uHw8xrqDzS/hHWH1dFXOHZ9sHWyLBsPgfS+bY5iRQ5nJEnZ3ZMK7hgnuiX1UUJxnPmOBJsGNB5jbckVQCumBGmwCQdaUYHYoJDHnBEyUfWfL6MwjoMH4oYNfAt76m/b39Oz+GyY684rUMYdze3wkZ+mRHr5g2iyyhajp0EanV/mO8FHdFQTvEi33evOCmcoi2ENIXAqbhKO5dosIHzQzSgFbMWt/q1CtO00cPhwYQa+A+nMkpZoiiIxkO1PfoTqWlyLtkD5xDxz3fCxoqd2yO6mCwDnuZnRrjXyInGg71tCMIzeQxfWmYjgVhegz4Rq9hElxRUkk249hpd8apnJ6prPcaVRYrssaeqgIJaBcVCEmCMzWtez3QIjo4wY3KpD0EwwWztgIDfSh/uO9ztAkBV2Vqzz9BhomAM2nDPDeC5glKBRW2IQHIPuq0DQFC0eZYyF8vN+567M67fAYQn/ZXV9mVLZD87svtSEDd7hY3t6DCboJcwHQUjQPEu5mm2y6P+FecP1B29c5w8eHlLfj6wO48kvSMkYWRE44vlx/xCMSGPmHsWqX8v4hOLKXzdPEF4zVFsv2sgfTKKB//CKJN9mryzRdBiMgfc4GUbzT9KFkHAAFdsw6PC6
 FV0ET8de
 Lut+9CoMHkT+Qvct+oQ4lmro7omLQRJSBKlqpiRL9JRPDvG997CbSQydnM/XSgVVk3tlzUP83eQ4d07dt4mSDSvoMpnD5m3yIe31tL5dvPtwYTgl6I65XVV3mh2Fmg6Q24Z6yzN3FewelPBO6YuSTSzwaFDDBZkpLFz6yWfRf+k7PSulKfPpudqOSNW5DI/vpZrZ9a6mEY9ge0ZtkW4w9VfClxoPfYvLs86cgQcrVjNX+vPiK6rSQhUy0Wy43CymYsy2RPYY85Es7ukCuewJCGtQ2ANzliOIgglRASMrE/mmPM73hAUsgNCt0Yghe5qSRSc/OVx1V4qFbBca4X1shmtYtTqGEIG2P7lFTJnOdrWW3/Vhc040vWT0qBdOCi75XEfxUZ/pHfqz5e8h16j6AuzUVzptynL8ppw9xwpj6/uDQGw63BKxPTaMM2blF8LbD+p3A8kdYgFtJNZ9o1BwykfZQ1PpKCoSsWVEYYYeMdVK4sqzPJ3/x3dFpa9RgdxS9wopcd8mop0szee+1NQjrJ2rEmgwi0ajWazkZO8fDe855Y61nm7rdaslXSKefeDpF8VrgzQKJt3mjARjW/B37oc+bV4kyOoSpR6i1JBx3kyaF2joOVIk/lE/coxI7zc3u32ljT9MHg2cfZ1OS7W+1/4cY2Jfzr2Gf9q9d1DEJn3vdGaND6JU2/bR2yYSU+t4hdCfaGYWFMUbhdCPMxFler3IREMNR3zNQ6j1en5lFssTCSkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 12:16, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> On phones, we have observed significant phone heating when running apps
> with high network bandwidth. This is caused by the network stack frequently
> waking kswapd for order-3 allocations. As a result, memory reclamation becomes
> constantly active, even though plenty of memory is still available for network
> allocations which can fall back to order-0.
> 
> Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static key")
> introduced high_order_alloc_disable for the transmit (TX) path
> (skb_page_frag_refill()) to mitigate some memory reclamation issues,
> allowing the TX path to fall back to order-0 immediately, while leaving the
> receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
> generally unaware of the sysctl and cannot easily adjust it for specific use
> cases. Enabling high_order_alloc_disable also completely disables the
> benefit of order-3 allocations. Additionally, the sysctl does not apply to the
> RX path.
> 
> An alternative approach is to disable kswapd for these frequent
> allocations and provide best-effort order-3 service for both TX and RX paths,
> while removing the sysctl entirely.
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Simon Horman <horms@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Yunsheng Lin <linyunsheng@huawei.com>
> Cc: Huacai Zhou <zhouhuacai@oppo.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 12 ------------
>  include/net/sock.h                       |  1 -
>  mm/page_frag_cache.c                     |  2 +-
>  net/core/sock.c                          |  8 ++------
>  net/core/sysctl_net_core.c               |  7 -------
>  5 files changed, 3 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index 2ef50828aff1..b903bbae239c 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
>  list is then passed to the stack when the number of segments reaches the
>  gro_normal_batch limit.
>  
> -high_order_alloc_disable
> -------------------------
> -
> -By default the allocator for page frags tries to use high order pages (order-3
> -on x86). While the default behavior gives good results in most cases, some users
> -might have hit a contention in page allocations/freeing. This was especially
> -true on older kernels (< 5.14) when high-order pages were not stored on per-cpu
> -lists. This allows to opt-in for order-0 allocation instead but is now mostly of
> -historical importance.
> -
> -Default: 0
> -
>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  ----------------------------------------------------------
>  
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 60bcb13f045c..62306c1095d5 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -3011,7 +3011,6 @@ extern __u32 sysctl_wmem_default;
>  extern __u32 sysctl_rmem_default;
>  
>  #define SKB_FRAG_PAGE_ORDER	get_order(32768)
> -DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
>  
>  static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
>  {
> diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> index d2423f30577e..dd36114dd16f 100644
> --- a/mm/page_frag_cache.c
> +++ b/mm/page_frag_cache.c
> @@ -54,7 +54,7 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
>  	gfp_t gfp = gfp_mask;
>  
>  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
> -	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
> +	gfp_mask = (gfp_mask & ~__GFP_RECLAIM) |  __GFP_COMP |
>  		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;

I'm a bit worried about proliferating "~__GFP_RECLAIM" allocations now that
we introduced alloc_pages_nolock() and kmalloc_nolock() where it's
interpreted as "cannot spin" - see gfpflags_allow_spinning(). Currently it's
fine for the page allocator itself where we have a different entry point
that uses ALLOC_TRYLOCK, but it can affect nested allocations of all kinds
of debugging and accounting metadata (page_owner, memcg, alloc tags for slab
objects etc). kmalloc_nolock() relies on gfpflags_allow_spinning() fully

I wonder if we should either:

1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
determine it precisely.

2) keep __GFP_KSWAPD_RECLAIM for allocations that remove it for purposes of
not being disturbing (like proposed here), but that can in fact allow
spinning. Instead, decide to not wake up kswapd by those when other
information indicates it's an opportunistic allocation
(~__GFP_DIRECT_RECLAIM, _GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC,
order > 0...)

3) something better?

Vlastimil

>  	page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
>  			     numa_mem_id(), NULL);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index dc03d4b5909a..1fa1e9177d86 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3085,8 +3085,6 @@ static void sk_leave_memory_pressure(struct sock *sk)
>  	}
>  }
>  
> -DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
> -
>  /**
>   * skb_page_frag_refill - check that a page_frag contains enough room
>   * @sz: minimum size of the fragment we want to get
> @@ -3110,10 +3108,8 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
>  	}
>  
>  	pfrag->offset = 0;
> -	if (SKB_FRAG_PAGE_ORDER &&
> -	    !static_branch_unlikely(&net_high_order_alloc_disable_key)) {
> -		/* Avoid direct reclaim but allow kswapd to wake */
> -		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
> +	if (SKB_FRAG_PAGE_ORDER) {
> +		pfrag->page = alloc_pages((gfp & ~__GFP_RECLAIM) |
>  					  __GFP_COMP | __GFP_NOWARN |
>  					  __GFP_NORETRY,
>  					  SKB_FRAG_PAGE_ORDER);
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 8cf04b57ade1..181f6532beb8 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -599,13 +599,6 @@ static struct ctl_table net_core_table[] = {
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_THREE,
>  	},
> -	{
> -		.procname	= "high_order_alloc_disable",
> -		.data		= &net_high_order_alloc_disable_key.key,
> -		.maxlen         = sizeof(net_high_order_alloc_disable_key),
> -		.mode		= 0644,
> -		.proc_handler	= proc_do_static_key,
> -	},
>  	{
>  		.procname	= "gro_normal_batch",
>  		.data		= &net_hotdata.gro_normal_batch,


