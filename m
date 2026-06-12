Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A46CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7C86B0005; Fri, 12 Jun 2026 07:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFDC6B0088; Fri, 12 Jun 2026 07:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC3A6B008C; Fri, 12 Jun 2026 07:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5A96B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:30:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C77F71C2966
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:30:15 +0000 (UTC)
X-FDA: 84871041990.06.7591D6B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF9CE120007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:30:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQ6XTXPT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781263814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnE76kx6sJHPObcY3xV2Cf2cd1QfYlcVg52Ay7ZMWeQ=;
	b=wB3UySlv0E7stDwjQwLchPOtngYsPcFEuIZ7hSCc8KRckStwKRzF3Nv8H7OF0s19ZNkY48
	p5XbiKhTbW/KNgUyKbQmZ+LQnT0APiEzhgmBHUmVpTOFqbpTKoovpf+TAlo+4A/MEWXQNc
	lxtZpOXjKzApbeTSNhSC3eGWcH0C/Fk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQ6XTXPT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781263814;
	b=ZlN8+62OZQBrTQyg8FZ+j32B0PC/YCJ0KXTX8YQgxhXrJ04+uKFUxL7JGhVr3/+oVf9OjH
	O3OZxQGTX2OdH87mRF1Ll/5oF145g4kL1p38qjG8ysqR6PCRiYyqQoK36XK7dgFfuNw+iP
	FueiWApurnrTnU6F0NJju7RrxHVRBbI=
Date: Fri, 12 Jun 2026 19:29:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781263811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gnE76kx6sJHPObcY3xV2Cf2cd1QfYlcVg52Ay7ZMWeQ=;
	b=mQ6XTXPTqyo8DYGRO17jNXO1oaUsaQbgvh7wgElYYAOLo1NPZdxySPHZBJj6gST26n8jhW
	gKLRuBzRbgsGfenosc3DORszrEL7v8sUA02WF6feITnfb7RRTgkLEOndlUrsBSdP1IESFV
	snHja/j4piC9f4rYT0PTzP4dBLJQ/Mc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 15/16] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
Message-ID: <aivpob0Zgnbc4AG4@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
 <aiurbPx1SISBarBy@fedora>
 <49f1bf1e-fcaf-48fa-a7b1-f8ee78b19762@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49f1bf1e-fcaf-48fa-a7b1-f8ee78b19762@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rxmhckkhg1tq9fig8pft6n6m89kb8mdx
X-Rspamd-Queue-Id: CF9CE120007
X-HE-Tag: 1781263813-750882
X-HE-Meta: U2FsdGVkX1+1Z9LV0H+9RGHFYlLrKb7V7jaC9pCj2JmrwGVqYyeEABWon76C02XW7oalpdaO1VLpkS59Jw7z1kzb/RgP8y8sRx8DbdYwtay3YliXaLyf4Id1+GcjuK5YfO2ZpkmYzqzas6g/u5nPtFNvK4pCEhQ3qq6pH6BclCOlY+LgWugTR+CO6SeE5ya4vQUvBNUSRWs5dgUSEKsm1kEQxM/WXl7/C19JwPXZQwak/Zqx0F+VHYAQO+L5l813ThZTb+CzY5f8vIlILI0B99Bj0arSQ5siwffgXul46E0X792zQZT8rnId1XAHWJBe2czXjwVr3FWiVaGflBJbMlKefGCe1ElRPJ4Mtz+yfEkM2VEyQe3koce8mu+Waw1nwy+2W9jq1yx+edLRe8+4ejCcqMgOdB21ATdQjf3VgNLaMMrgIluWxM/JHDdpvRpQPZNS7te9PHTJvv9/ttFHXgzFn3t4l7kzxoeeB8vAXK1+jiEvgpNdPLihxHDpZlVlXDvM3xqMpvJYTXATmzFs9bL13nigyVRNbKWArDOH9dtL2cZz86v6XngmIJSNqq+i0pR6zIAR2WBdl5NVFT0/C0R3QoRDVsaOv8/BQfDPGUQ4PRTB5rrBpB8W1FvSSKPkJ13naDZi7nPOBFSwCkx4DISLqIxTVpoAkOHkKiLyRSakYji7pjr76NUUV7BSh0+iNjidez8Fhpkf1KWF/46Inb1S0Ug19Ry5N1Yj+a9mKu6jRUMNecp7Xkgi/l9ajv8Y+wKSq07VwF/QLYhs0nx+UX98OyWgRHNWMCwhwGpQ1jMvx8LWyml2uxyki+5v7M4Lfa5Y0Ff07IRej+4/CcB2QfmhrnDVKI2gvYoOknr4ReR5XVzzkWIpjsmGD//uL9rvkDyKzM388gP74DQ9BcMGutog09AK1VusFs0yekmmuOzWq9mA9WFjU3//JDmje1CeQ5BuJlXHwEWAsNScgWm
 84Ou5xq3
 bcYo8vJiNtagk5R5gQ5199Ir3vGbOLruvT51UUy9EZm4bcMHwqOZ5NpUxZP0JHab4HM4qXvCkTZYsSfUw3vzREg9IzKNb2rBCaGrC1sMyRt/nt6sapRNJaq2zxTQMsxGkPWxBUgoo3Nisw+SoauO2z0izOwrFU0eXcsCVNJNRoPdGG9qj+qgLqD3pfoY8tdJLLto2LB/+sJKGef7P837jqkSi1o8bYyommaVQadk+KmKZyLWkVreeo+Zr8+0l5h0lbXQnou/WCNwVi7LrPY4B1aa7w7YYdAfGUypHdyYa/uDiReZueM8W2FnCKbClREL+pfoe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 12:17:45PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/12/26 08:54, Hao Li wrote:
> > On Wed, Jun 10, 2026 at 05:40:17PM +0200, Vlastimil Babka (SUSE) wrote:
> >> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
> >> gfp flags are a scarce resource, unlike slab's alloc_flags.
> >> 
> >> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
> >> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> >> family function should not recurse into another kmalloc*() for the
> >> purposes of allocating auxiliary structures (obj_ext arrays or sheaves).
> >> 
> >> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> >> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> >> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> >> added. This will also pass through SLAB_ALLOC_TRYLOCK so we don't need
> >> to special case kmalloc_nolock() anymore.
> >> 
> >> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
> >> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
> >> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> >> alloc_flags contain SLAB_ALLOC_TRYLOCK, the incoming gfp flags have to
> >> be also compatible with it.
> >> 
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slab.h |  1 +
> >>  mm/slub.c | 13 +++++--------
> >>  2 files changed, 6 insertions(+), 8 deletions(-)
> >> 
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index 45bfcfb35a9c..509f330654b8 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -21,6 +21,7 @@
> >>  #define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
> >>  #define SLAB_ALLOC_TRYLOCK	0x01 /* a kmalloc_nolock() allocation */
> >>  #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
> >> +#define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
> >>  
> >>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
> >>  {
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index cbb38bd01e46..7dfbd0251aa2 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2167,15 +2167,12 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> >>  
> >>  	gfp &= ~OBJCGS_CLEAR_MASK;
> >>  	/* Prevent recursive extension vector allocation */
> >> -	gfp |= __GFP_NO_OBJ_EXT;
> >> +	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
> >>  
> >>  	sz = obj_exts_alloc_size(s, slab, gfp);
> >>  
> > 
> > For the original calls to kmalloc_nolock and kmalloc_node, I notice a difference:
> > 
> >> -	if (unlikely(!allow_spin))
> >> -		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
> >> -				     slab_nid(slab));
> > 
> > kmalloc_nolock completely discarded `gfp` flags.
> > 
> >> -	else
> >> -		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
> > 
> > while kmalloc_node preserved and passed it along.
> > 
> >> +	/* This will use kmalloc_nolock() if alloc_flags say so */
> >> +	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));
> > 
> > Now both paths are merged into kmalloc_flags, the gfp flags are
> > unconditionally carried through. It seems this might carry some unwanted flags.
> > 
> > I traced the call path and found that ___slab_alloc sets the __GFP_THISNODE
> > for trynode_flags. If this flag propagates all the way into
> > kmalloc_flags->...->__kmalloc_nolock_noprof, it will trigger the
> > VM_WARN_ON_ONCE warning. Maybe we need to strip the original gfp if
> > `!allow_spin`.
>  
> Thanks. This should do the job in a more generic way I hope?
> 

Yeah, this is more elegant.

> diff --git a/mm/slub.c b/mm/slub.c
> index f9b8dc56bb57..0bf53f70c9be 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2047,12 +2047,15 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
>  #endif /* CONFIG_SLUB_DEBUG */
>  
>  /*
> - * The allocated objcg pointers array is not accounted directly.
> + * The allocated objcg pointers array or sheaf is not accounted directly.
>   * Moreover, it should not come from DMA buffer and is not readily
> - * reclaimable. So those GFP bits should be masked off.
> + * reclaimable. Node restriction for the parent allocation also should
> + * not apply to the slab's internal objects.
> + * So those GFP bits should be masked off.
>   */
>  #define OBJCGS_CLEAR_MASK      (__GFP_DMA | __GFP_RECLAIMABLE | \
> -                               __GFP_ACCOUNT | __GFP_NOFAIL)
> +                               __GFP_ACCOUNT | __GFP_NOFAIL |
> +                               __GFP_THISNODE )

Good idea! Both code and comments make sense to me.

>  
>  #ifdef CONFIG_SLAB_OBJ_EXT
>  
> 

-- 
Thanks,
Hao

