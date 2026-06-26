Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B7BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CD46B00B1; Fri, 26 Jun 2026 10:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4126B00B4; Fri, 26 Jun 2026 10:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAAA6B00B5; Fri, 26 Jun 2026 10:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E18B96B00B1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:57:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 671A38E31D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:57:13 +0000 (UTC)
X-FDA: 84922366746.02.A564577
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AE8F7A0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:57:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ju6I4k07;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485831;
	b=Kndq2rurlp05N7UHMaupSM2fZHhXvVREBSQMxcsnYXIMtNM7xQCsYrsw2ZLWmRKtvgeBEj
	JqzV63Tp/CBkdBdi1w6gy00hE8f8TM7pDa/DSsFBOWX6a7aGUYw0vOr3Wie9B4DqJdCKkw
	3ZwsS4vqH35ydTOgEtWL4gCNbHgmbCo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4dEsq7eT0U+sy2EuGGNHMB1wu+Xu3EYpNjubxVfLcc=;
	b=pMKCeTbVleDDWNbVubzTna8IKuvN0ODZSeP2iL7I4Rmmgh4pccA1SKd9X3Hs48nch2n0ns
	RnfDFaZSWKRWf+/Lub5aBpdXzqxW8VXm9+t37HlhxX2rptsKCVyi1q9KTXXsTyEDr6dUXh
	/OX7zuptsyZeBC/vmbl+7ZnWERE9s+E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ju6I4k07;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F7A6600C8;
	Fri, 26 Jun 2026 14:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E031F00A3E;
	Fri, 26 Jun 2026 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485831;
	bh=h4dEsq7eT0U+sy2EuGGNHMB1wu+Xu3EYpNjubxVfLcc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ju6I4k07BJu2QU8MLzI4HFyVkm9JoCqL1MLjMne2NwFtUbN4pZqAK+duO/sguQ1Sm
	 o6SovK2IKQM3F0Un8rewjt0ONXKYPlLEAEE/1Wd3ZmFOZ+Zbwzftm5xGyH9XzqRdRh
	 L87MqYw9nlXGrMJUC2kOD3DCKNhfOI1vxTAW9f7sLsM7xhwUv01IUOWLlzWZ16W0cV
	 AJKwS5fFWuvFPdi5r0qsrkvnNGslW1TXo8gt1tIf7Ds5powFNti/f3BwFEc/rwGh3v
	 rrpok0p8p7P0gG8wWjkKWCW5TzlA8seaPoYHzGbhYd2t4uySesCQye9OQtKfYyKhe1
	 0nrd4AekvsyQQ==
Message-ID: <56b3e774-8866-4e0f-9746-b646a4b58fef@kernel.org>
Date: Fri, 26 Jun 2026 16:57:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-3-fdf4d17351dd@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-3-fdf4d17351dd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE8F7A0005
X-Stat-Signature: zf3rdhmzmq8tipbfg3wugxmstc8hxsth
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782485831-396320
X-HE-Meta: U2FsdGVkX18xYzears1xu+lzGSbFSd0pttEiHm3JPO3XDld3ECCScP+OGFXAijigpeegjwfNz7Q7tAmWS8/s/OhcHeDkvM8DyoAaRDGRYU23SdfZFiP5p8rq7hyt+0xbDMKBckTMAbAR6AhHYU5bF+6BRRjxOAtpYY1/TJVPzHVNkV4ZI2tRbSRJlyZgnGIhfwR+e9tFwberVn+VkoqKzFUaCi8ZjpSX1wRVckUBIFQxHxY8vDAx3K2Y92w8VdSO+tYTT6/fGw3Gt0YGTdIz3dwP2P41U22m+3eoc0/NiYcn2MxYsi3QiaUcQG91rZPl3t37CrxbYXjAX7Sf0CK00UVmOJRCzGFQmkB/9wUXaJQB8SfrUtUN5Dc3h/xfuXj2GU2yeb32zZEAoh+srt8Q+vXBqOTrzhJOS7JCWo4gHXzdPW/LO3XbTYrMkMalZHXpXUWcm8gg3eNyrCzADzdQUqFhKhW3AzUQD2xIGSYoOsz/soey3pq8vo8ogHKKM0gQLYfwAe0tox5l4vCNgwfHum57DLS7EXCMXjcO+HdAExYXecW9COKCeNuPKMj5OA4kQUDtsdwFIiu0rPiHpMdnYjw9r9v+GecTVAwa1T3FwlTdmEX2wLH6R7IgP0bTni9avficXnbbivWBM/NFk5Lskq/D8I/1z9TDioK5mjuhNRRMoU5YdRreoWXHcglZqHJPqu9wnPMbAGs3wJlwAkVJGjIC332FdkrygbB6/yhLPdmfSLajTH1b+KszHTdOGx9SYxrOJuYntg0W0R+JRoEcCYplbXAHcL4zjhkq1A+B4oRXpmpHvSfarP4ThKZHspSFPisPDQXiEVssYo2w5HhZyLfg1OP/C0QbYHTuE5bx5UOCI9W+AXeMEuFVdED0q/VqxkGxOWJwCbnK54AU8nNGh5smgYkUHW1GZ0J6ZAiVuo2utcBQv5Jb8iZQAR8mkKiZ0Hg6PfFbrxA49iQAbio
 16uWZQs2
 82FVOHoRU46sV3P0+bqIvkCRW2Yw8BVYLftqPZ4uaPOvK2Q5VshacNfoL+MP1hy//EfpfuRmsVP7LpuZV/pvi7D9358Tn5c51lGqqipCipF/0DjD5hd4sL1E9e092U90bpMjb/PSLO6o292ZdNhnEQ8E1PjH6OVomN7LhYhjJwJQEuVz3r5/FcUpyNv0lhA2EhVWAfDg02OIqyc2OWrr46k04wQ94MFl1Kx9QdVYy6CvvhPNyMLs4radnGTVAY9UK20gkyhfT1fYm3eLhXcjQgjnW/9TGCfi0ok9Z+1Pc7Wn+24o97wtAivZMOLtWvWnpYKgzzdjNlG+04ac3aB1x0vEZcJM4cqB09dC8wInVHjvatXWgxFdmtTZ645dzfUXLNPggGnWgyM2x6XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> When kmalloc_nolock() successfully grabs a slab object but memcg aborts
> the allocation, the object is freed via __slab_free(). Calling
> __slab_free() in unknown context is not allowed and can lead to a
> deadlock.
> 
> Free the object via defer_free() when spinning is not allowed.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slub.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 85760c8ff2e2..4a3618e3967e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2459,7 +2459,8 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
>  
>  #ifdef CONFIG_MEMCG
>  
> -static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
> +static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
> +				     bool allow_spin);
>  
>  static __fastpath_inline
>  bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
> @@ -2477,7 +2478,9 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
>  
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
> +
> +		memcg_alloc_abort_single(s, *p, allow_spin);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);
> @@ -6436,16 +6439,20 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  #ifdef CONFIG_MEMCG
>  /* Do not inline the rare memcg charging failed path into the allocation path */
>  static noinline
> -void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
> +void memcg_alloc_abort_single(struct kmem_cache *s, void *object, bool allow_spin)
>  {
>  	struct slab *slab = virt_to_slab(object);
>  	bool init = slab_want_init_on_free(s);
> -	bool allow_spin = true;
>  
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
> +	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
> +		return;
> +
> +	if (likely(allow_spin))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> +	else
> +		defer_free(s, object);
>  }
>  #endif
>  
> 


