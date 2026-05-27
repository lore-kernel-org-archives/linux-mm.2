Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18859CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FC76B0121; Wed, 27 May 2026 11:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566C76B0122; Wed, 27 May 2026 11:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D4A6B0123; Wed, 27 May 2026 11:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3908E6B0121
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:47:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1788120625
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:47:42 +0000 (UTC)
X-FDA: 84813629964.01.4DD292E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0580F180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:47:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2gGzh0u;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896861; a=rsa-sha256;
	cv=none;
	b=xO38j8giODoiPMsECwdYiYpqzTj+Hj6HHT0aAiNvKIByfhtrMF6XXPTk3MNY21TeS95b/C
	EXN4O6pao/K5smrtsLHJAXx2oPHmuJavEXC1HWp/zuQSQSIBPsU/tkCMjrkqvHF4dhwfQL
	riTBcA0wEFJUp3na6ZJpwqOZPTSZA6g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2gGzh0u;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1LehxyQXtk2uo55XzhchktGNtxckIshURQweL13HfQ=;
	b=KC49feyMKqh1sBhapEeSqPvn//aubdh4FfANO0u50D+FsoTb6banY+qekuxf39fhxw6D7h
	giKqxfsjotZXT2Ff3dvsl9Z74nzzhxdETvbq02oTUZsKAsYKH7xVuuzg9o2TjAhx8k5HBj
	2+t43th1cmVyKBWXBqQZB/r9gvPxydI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1D0C4015D;
	Wed, 27 May 2026 15:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8441F000E9;
	Wed, 27 May 2026 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779896859;
	bh=A1LehxyQXtk2uo55XzhchktGNtxckIshURQweL13HfQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U2gGzh0u9Qc22u2OKtAf7paVQHXrypMrIvhRvWgE31Xp+8iSb332QEX0GhjQevIPz
	 WJJendkr7hgEe2syxLHu6wYxyF9mZJ87SfdXQEk0xsYDun9HujLrQr1TT9gXLZsniG
	 4km/nd5J5+09uvDDE1bqEkk51N3EobmFefOOJXMX2pBYdomuSOkUIvFw59zeGvfiSG
	 /Tjqjg3sykk4liJMNl0q0A9OVxGy0ICosRnKSmVzBuL1LnqFOBXyqqbvCL5GVse+dq
	 XzH9au9rJsElTFsDIg78BAlGWNM18a2Df1k3MCfVHL5ygUBLm70J8JI0GNs7Pi7W2j
	 mPPu33g5XptDw==
Message-ID: <44b8ba46-a002-4668-ab99-4bf01f4b66e5@kernel.org>
Date: Wed, 27 May 2026 17:47:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/slub: use empty sheaf helpers for oversized sheaves
Content-Language: en-US
To: hu.shengming@zte.com.cn, Suren Baghdasaryan <surenb@google.com>
Cc: harry@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn,
 cai.qu@zte.com.cn
References: <20260527214840093l-oER8Ds4tJLCyI14we0S@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260527214840093l-oER8Ds4tJLCyI14we0S@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0580F180006
X-Stat-Signature: pjw5ek4pqszzhcnip35f5zjwja39yb3r
X-HE-Tag: 1779896860-347280
X-HE-Meta: U2FsdGVkX18fcYBAG4AQcuPfoEa51A9MK8NnTyOLZERRaznpftGgkqMuUV4xkXQ7ecMuZl0D3PHXcjS3QyK73FNfwhONPtaiZtg1BNjcldsOkitKcbT96r5I+GivW3lqNFnDztM9QzozqWYWa5L9nXExNdXaigmQgH56KxUIhrPjU73s+xB5pRLNhxnHYUJ4q1jstuQvhKhucaRglSWzc7joQWl4KK7oNPWlaLSk13sDumOxGuS1/gi3dtq54PYRRslBx6XPhfKvJkh4Tm+/N1kg3BXJXvGnJXlkBwqAKAfLhy+K6ZmKxVLKNlEceK40+OG7ZeK5XaPC003FWZmt1ZaTNAwcp1XxXtSZyB/9OTVAMKcHMni8yKiLSm/NjrxNp9B1ZRcqmrLwPNgo5OvD4BHKK23jR0F43+YHN+NqhzQUhTPQM65jQotdk9d1XPzRQuZVzer7Jtw+x6j5Eh/0zvA82AS1NPoYw+l0aaa8e3C75852YrMZlRQ+tXB0bFN0yWbn8CJ1ndQqVOfn46Dct5P68p9sNFYr8ymjcQNmzIStAF1NuEGHFPwYLsxcRPNOu7HVOVX5P48DKK02VpdXPWAOxjDrunahz8cQuIp9leCJw4uQDEkUfaVVJ2F47O+5hWA46BTfHC3pzkggrN2JDz5FKdxD2gx2dLkDzS+LHrXS3ZBAKm2XTyV2Zn/R79C0sXYkXWIif6+t8oGtlqNqvjzF7+urRYldTKHTjG5V6kX0mJQPnBhGGx9G1cSY32i0Whcf97Uducn5QpSuF/vN65//KmBEUW9lLizWBOgV0lnx1hfv0OnGUZ6eSjpO6Jk7anooEmKQGJhHu6y5xhVXo7WXrqgyzMAthavmgm6ydFZi4Zfx56FNgHuZGMGIjWdMj4kYcwIde+HyoHSizbMuIS6dkJEMzbXQWT9Gnxq+TD7A+Xs9mqBiojCM/1A2Aj30Gy81Wxom98z4pQwXjxp
 dj4QMkTY
 x1le5O2dSxuWj8wmDic0Hrg3iRIEUy9I/kjoz9r+mNvAyiFn0J+QssBUFaUjM+nPttX3GjkrGXcCBylBgKJeIyMnCfHD1r3fzsEjGhILSZZ/oOe6MNQLg9agbY+NEaT83/zrYtdJxkPY5AtjNiRzJZxfCB+rPtVdhM2PKr9GpAFLzSWyVaN9YLcTmMVjf/jAaQqpAkJVmOGmEpfclPktM/ceB8n+aYqx3LP1PbjeoQz/pstyP/MmPZzkjUFb8xM8NSgl2kjh7pjSY/jUpcLJ1zvapTo1loo6etWXMRPUx/fe+gaY0rLg05afnwWfUrNLT0z0vsy+e6QVwfaYQ6YGLfd0YxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 15:48, hu.shengming@zte.com.cn wrote:
> VlastimilBabka(SUSE)<vbabka@kernel.org> wrote:
>> On 5/26/26 17:24, hu.shengming@zte.com.cn wrote:
>> > From: Shengming Hu <hu.shengming@zte.com.cn>
>> > 
>> > Oversized prefilled sheaves are allocated separately, but after they are
>> > flushed they are empty sheaves as well. Release them through
>> > free_empty_sheaf() instead of calling kfree() directly.
>> > 
>> > Use __alloc_empty_sheaf() for oversized prefilled sheaves as well, so
>> > that they are allocated through the same helper as regular empty sheaves
>> > and released through the matching helper.
>> > 
>> > Since oversized sheaves are now allocated and freed through the empty
>> > sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
>> > sheaves. Update the stat comments accordingly.
>> > 
>> > This keeps the oversized and pfmemalloc prefill paths consistent after
>> > flushing.
>> > 
>> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>> 
>> Hmm, __alloc_empty_sheaf() does "gfp &= ~OBJCGS_CLEAR_MASK" which includes
>> __GFP_NOFAIL. A caller of kmem_cache_prefill_sheaf() with __GFP_NOFAIL might
>> not expect failure. The __GFP_NO_OBJ_EXT handling is also not necessary for
>> prefilled sheaves.
>> 
>> Well maybe all the gfp handling could be simply moved to
>> alloc_empty_sheaf()? The other caller of __alloc_empty_sheaf() is
>> bootstrap_cache_sheaves() and I think it doesn't need it either.
>> 
> 
> Thanks for the review!
> 
> I agree that clearing OBJCGS_CLEAR_MASK in __alloc_empty_sheaf()
> is not right for the oversized prefill path. In particular, it changes
> the caller-provided GFP flags and can drop __GFP_NOFAIL. I will move that
> part out of __alloc_empty_sheaf().
> 
> I am less sure about moving the __GFP_NO_OBJ_EXT handling out of
> __alloc_empty_sheaf() as well, because that seems to make the free side
> more complicated.
> 
> Currently free_empty_sheaf() assumes that sheaves for SLAB_KMALLOC caches
> were allocated with __GFP_NO_OBJ_EXT, and therefore calls
> mark_obj_codetag_empty() before kfree(). If __GFP_NO_OBJ_EXT is moved out
> of __alloc_empty_sheaf(), then oversized prefilled sheaves allocated by
> the raw helper would not have that flag anymore, while regular sheaves
> allocated through alloc_empty_sheaf() would still have it.
> 
> In that case, the return path could no longer use one free helper for both
> oversized and pfmemalloc sheaves after flushing. It would need to split
> the two cases, for example:
> 
>         if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
>                 sheaf_flush_unused(s, sheaf);
>                 __free_empty_sheaf(s, sheaf);
>                 return;
>         }
> 
>         if (unlikely(sheaf->pfmemalloc)) {
>                 sheaf_flush_unused(s, sheaf);
>                 free_empty_sheaf(s, sheaf);
>                 return;
>         }
> 
> There is also the bootstrap_cache_sheaves() case. The sheaves allocated
> there are regular-sized sheaves. If such a sheaf later reaches
> kmem_cache_return_sheaf(), it could not safely be released through
> free_empty_sheaf() unless it was also allocated with __GFP_NO_OBJ_EXT,
> because free_empty_sheaf() currently assumes that SLAB_KMALLOC sheaves
> were allocated with __GFP_NO_OBJ_EXT and calls mark_obj_codetag_empty().
> Unlike oversized sheaves, these bootstrap-created sheaves have the regular
> capacity, so the return path cannot distinguish them by
> sheaf->capacity != s->sheaf_capacity.
> 
> So I wonder if it would be better to move only the OBJCGS_CLEAR_MASK
> clearing out of __alloc_empty_sheaf(), but keep the __GFP_NO_OBJ_EXT
> handling there. That would fix the __GFP_NOFAIL issue for oversized
> prefilled sheaves, while still keeping the allocation/free assumptions
> consistent and allowing flushed oversized and pfmemalloc sheaves to use
> the same free_empty_sheaf() path.
> 
> Would this approach be acceptable, or did I misunderstand your suggestion?

I see, thanks. Could we perhaps move the mark_obj_codetag_empty() code to
alloc_empty_sheaf()? If not, then do as you suggest?

> 
> --
> With Best Regards,
> Shengming


