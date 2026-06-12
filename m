Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197A6CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547786B0092; Fri, 12 Jun 2026 02:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DA36B0093; Fri, 12 Jun 2026 02:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B5F6B0095; Fri, 12 Jun 2026 02:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3461A6B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:55:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9E83A0357
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:55:16 +0000 (UTC)
X-FDA: 84870349032.23.1B5B292
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id EDEAF180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:55:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J5qGq0ob;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781247315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ga/qG53jDKmdbFEuotEjjh7oQ1inxc+YZUHlh+EbeyA=;
	b=raKqbvevtfk5M8/YnimaC84mEmoRSO0tNKcdB97rQSUg35jI3glJcWmnO4LEQVvrzcsNKi
	LpfvyKo2IRiE5g7QN1PBUOP6CuVJKPON1/FSrI1Nexk6zKmDZlPgtllBzl8F1Yhw5vM9xd
	9X/qZB8nyEiWaQ3iEsQRluIm7VxsT9Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J5qGq0ob;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781247315;
	b=yx6cy+AqJgFbd9ACJ7urKqDHsmtYUZM/rlBEcViO5dpx3Om0gs2+CcQq4b0a5EEwfZCPgi
	pX8f9wTRXm48yJHAuTCAKJlf2YQNr4mnOqLfsDDxNej7KKpwmPenuMnK+Sk2cZRRKkWjc0
	0XSi9YPWj9ES7DPDJI6YyPjNveas1QM=
Date: Fri, 12 Jun 2026 14:54:45 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781247312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ga/qG53jDKmdbFEuotEjjh7oQ1inxc+YZUHlh+EbeyA=;
	b=J5qGq0obUfG14W+dmvKRK38JpU42W+ijyJa++tjLUurzUqqDAGzDMUcwjhtLn8BLzcniAA
	DuqHlDintm7neZNv7+mSmng9HoE7JsJK0fkPKHDxaprpChdl5lhuaidtkGK5ZA7zOaOviR
	TB7+Qg3G6qxnIrsLbHN/Q0AF9cGnoi4=
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
Message-ID: <aiurbPx1SISBarBy@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EDEAF180002
X-Stat-Signature: 86uiw9faywstde9itrtoqh7cg8uni57b
X-Rspam-User: 
X-HE-Tag: 1781247314-466850
X-HE-Meta: U2FsdGVkX196QP00TB2lkvqmlpXohUYH4RTojvPkX72qB5Ey/H0jgXtTAHED3ONPZFVVSP9XJSYm0fAXj6+ms3edpMdOZi5ZRvLgTcHu7iD9qYI/hd5RTbxAjBte604IoHWM1PPW14qWVayV4zUJaNYMuRAbuTmwnYYkQSuA4s7h/abwrZyizr4XteZKivJdvLNOLyC2onnMHOkRB/1uEz+8uaJ+UmHigfz+t+OOIeeljiAdgCQm5KU24z4NC9Mx6y4oy4xRMSS1TdNKW6evT6TBb5u54GbEbl9irRVjwDtLRJWjOoaFq6w5eU0LoougYL0CfeHGVpRnSynxl1z6ep3MHsRMGIpVqLFjPh/ybalxKuLphjz09+koNWz6lqHLNzJ3bocuCNnhYE3oSLD8GAYTL4XB8oYXf8HJoqSGrqpNMEn5Z5rHHQmxed6sRmc4gxo5PzLhHaBqJQxjRmkxTRheZeAIfOlLkKX/k0mUEsGQGWEd01Hy6QwMbyPrXv0Njwtoqtv5u6/usrCZ3qqlcolbLHabVJUaTN9KVhomX0BZkqiivk99LURncQNtKIA0lJQlZhFn28lQ4MHnwVKafzFCM78NV1G/h94Jxu7kUz1fBwVhykomhNp59Hmn516R7pGZvdQOSl2G1Bh3aCIXl60h6LH0jiNSj+22wNCh+EdPcZFy4uAP8G60dk4hh/zguy5LMGtox4BouLmBMWWWOvauTR6FdvCAlaJx8uyYCknbBwjju++W7ZkDmTmBgNfDNfNnUY0CXZWEsl+dDgYHJB82TpTZfSCXD+q6f8ZpNC/Bb7eJJ3/eNr+5N5L4ZvRpPLWMskjuFpKedu7vdankNGdjvnOvZnUs9PCuZPgGeaiuSIJw3an+H6UqYlLiprbFx0Avcrh5JmRONrhGKdtTK3Alth7ELmN2eG8ZzNaK36B0IMNtx6GzD2E5Q1ByZxafDL93QLQDpdoKxLiQjzs
 dcguqKjm
 Z6NtRXdgtZUY1Qp3lKoTz2A/pUgLLRDxOB5JYerZxAbzqSZ6zhnAg4jT2uQkFXpYHEuzqgRSLIVO4a0I4wc1aOEN3DPqaOXr7Xu2aiDXpGXqGou4OF2JMrmtsjC7ZktxRseSvKeG0OCWON9mG8b3PZjBtR3mFOSb81DXgVn1zcTrg1Ar4XuddBj1f4JaVb6xkjuB9ljMulebebACa2+UDkgpGm0Lpb4jz1Dr8/4qRTv8OZqW+nWTZjx7Zd7S7PjvlVxSSoQCVvcUuBe68zuDc0V5MhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:17PM +0200, Vlastimil Babka (SUSE) wrote:
> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
> gfp flags are a scarce resource, unlike slab's alloc_flags.
> 
> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> family function should not recurse into another kmalloc*() for the
> purposes of allocating auxiliary structures (obj_ext arrays or sheaves).
> 
> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> added. This will also pass through SLAB_ALLOC_TRYLOCK so we don't need
> to special case kmalloc_nolock() anymore.
> 
> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> alloc_flags contain SLAB_ALLOC_TRYLOCK, the incoming gfp flags have to
> be also compatible with it.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slab.h |  1 +
>  mm/slub.c | 13 +++++--------
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 45bfcfb35a9c..509f330654b8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -21,6 +21,7 @@
>  #define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
>  #define SLAB_ALLOC_TRYLOCK	0x01 /* a kmalloc_nolock() allocation */
>  #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
> +#define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
>  
>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
>  {
> diff --git a/mm/slub.c b/mm/slub.c
> index cbb38bd01e46..7dfbd0251aa2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2167,15 +2167,12 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
>  	/* Prevent recursive extension vector allocation */
> -	gfp |= __GFP_NO_OBJ_EXT;
> +	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
>  
>  	sz = obj_exts_alloc_size(s, slab, gfp);
>  

For the original calls to kmalloc_nolock and kmalloc_node, I notice a difference:

> -	if (unlikely(!allow_spin))
> -		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
> -				     slab_nid(slab));

kmalloc_nolock completely discarded `gfp` flags.

> -	else
> -		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));

while kmalloc_node preserved and passed it along.

> +	/* This will use kmalloc_nolock() if alloc_flags say so */
> +	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));

Now both paths are merged into kmalloc_flags, the gfp flags are
unconditionally carried through. It seems this might carry some unwanted flags.

I traced the call path and found that ___slab_alloc sets the __GFP_THISNODE
for trynode_flags. If this flag propagates all the way into
kmalloc_flags->...->__kmalloc_nolock_noprof, it will trigger the
VM_WARN_ON_ONCE warning. Maybe we need to strip the original gfp if
`!allow_spin`.

-- 
Thanks,
Hao

