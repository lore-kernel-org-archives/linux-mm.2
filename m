Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29CAC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8D56B008A; Thu, 30 Jul 2026 07:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79846B0093; Thu, 30 Jul 2026 07:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F596B0095; Thu, 30 Jul 2026 07:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 786416B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:17:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0507E1C12C7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:17:18 +0000 (UTC)
X-FDA: 85045191798.10.57DD9A9
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE9E3C0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:17:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YaPbCgjo;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O62DfahAFLdgUNQd+mEROE3kc1IiFSoToX+T1c6EMNs=;
	b=qWMFNVPgOsMJkQ7f/KYRDAtcnYmsFlr4Q+4DAsTvyjUbVNvvpu6eNwfM+RMjrX9LRdYAoa
	cI61qZtvLW5DxbwKhuLOJzcwfVFiul0js+PDPE6r59z3m35L5WhaY4dUwKapjwf+Uxuw/I
	PrCNizvpmcQ3gpRAF31vLZxS7NkH1tg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YaPbCgjo;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785410237;
	b=ZhWN6+0B3lfO/7vNWexrnipPgOSDumq/NkIWGBjzZP8CSRYR+2Or1idvtCizV+T8vd7Tsi
	Tt8JpxWZslYyVbaYP9bQw+z68k1O86ajD0dcG4xv5L/WrvC5uSp1R+iu2sxiWiacYX8/4I
	HM7TMercpc4NBPzdvEh7cT26QxUcNWU=
Date: Thu, 30 Jul 2026 19:16:47 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785410234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O62DfahAFLdgUNQd+mEROE3kc1IiFSoToX+T1c6EMNs=;
	b=YaPbCgjoftbhSR29RzI9Advqe32g7LQ+h0mgAHtNfh88j26Di9HQPwtfZ2qZL8RShRsfg+
	X9u9qjJROPUyXbjGsv9JAAGTvz08KdUC6F2SlIH/17UBk2C6BLlkTOvFewXBx3wMSD3Rkj
	jWoAh/y38URdus2BcU5fMHYXHePLsaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 01/13] mm/slab: skip kfence objects in allocation
 profiling
Message-ID: <amsxmCmsUTYM26Fh@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CE9E3C0009
X-Rspam-User: 
X-Stat-Signature: uia8c856irxwcyzgjn3gcicxyfdrjziq
X-Rspamd-Server: rspam04
X-HE-Tag: 1785410236-20537
X-HE-Meta: U2FsdGVkX18k+EtjGrHQGEW6q70hLzX6iWKTWzRJTqvKSkC2twYho2c99B/z6gdU8UOY+ikxJFKruVplAyZfbt1Q2cmMtl+OogDK7R0m2kUBCLZvdCPVhaPf2id7uiYS6snLPuS4drmNw+1Y24Rl7Gcxf6MN6rw9n8Ao+YaOmtqgSoB6rMt/zfe+gNVQqcBNvCssiC3juxFhfrmMSsHTonAEOiGGIr9e4gmlFSeo0hENy7JiU2RuyGvfMdcKe/bT/Bd+Eg76hm0pXfRDJ/KYhSFn5VkqEoM3oaJHQYVcsQMETGSI2SpPe6VKwClwhGXlsoH+IV9u6HKtyg8SvUTxz953RxWM/FhcLMW2sDO44gShoizidhd9no68liZuZdpAXVk37GGlCgs7tvpK5q59V7yEDKfgoTfdN3iEUL/Zzqk3YRos67vSIXdNXUFcfgljCsxT3Xvvron4ZrVQ93y8FRonmMBKRmnfLIP/7ZonIX1CNpFSr3W/Qg2oeZAu66uyiUeIaG1NH9tf8yhjK/n4wCjDTuOC4x7exKo9ASJBajBRjNlD6TPWvjLB3sWyelodW+IZJlY+Gsu8nNn2vfNZrhA5Zff65aq2G7Hb8Dk3278R6yUJgYKHKqUPTH9UVolP0UrkbtGVYmFpPxYWIzH2Ojcx+Dy2Ev6xdt3Bz6EB6/6w1hA50NdDMbQdtLmU4Djgjh0LX13gg5yYujYehAZrZR6d3sILPzvbr6CXcD3CxDttLSBJxNzMLnOumVCim9cGSm//w+bJ+3Pv2X+5GlZnJRqDqdYvFI+3Mv8IRSx3DYcTqnDVeKAhGaTnadpxB4rsepXSmDOrr3EPfGZQOu3+kwaLWD5zGb4DOZgdlQfdugH5x9l1OxYan4gOioqc7B8+LCexW0WgAgHF4jzvZh9kxcFpMxwmoHfR5EIRF1ngJkh0D1FfpVkzLhoreeNvS54p1NTI3Mjbth2QamB8VvI
 o0bXlEdl
 9b1L4CQyLm2Y5E5BAHjqpvH7dtfzeN1p4sCNSTtNwX2iVZsb2WHPB12NLvXVQKELF1IJGBgbVIEg4louwTn2mCgQIFejwOS/xGCay8gpw8diJjAjOaAbVvFQPQJF1ET2IhykWGG6aTSDXo01iIvpiEsh81zoaIvsLeWHGZm+QjOjFa4ktR6wjCZoS4xSWVPolH6QdHOSLOMFyPFpDUxW6xyobbTiSsPC2c63yJJYEWR+4V24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:53:55PM +0200, Vlastimil Babka (SUSE) wrote:
> struct kfence_metadata only contains struct slabobj_ext with
> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> enabled, it will end up allocating its obj_exts via
> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
> These will probably then never be freed.
> 
> So things sorta work, but not always in the intended and optimal way.
> The upcoming changes to slabobj_ext layout would additionally need a
> proper refactoring to keep working.
> 
> However, there's little benefit in accounting KFENCE objects. KFENCE
> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> (default to 255) outstanding ones at any time. For any callsite
> prominent enough in the memory allocation profiling stats, allocations
> served from KFENCE will be lost in the noise.
> 
> Thus let's not complicate things and simply stop accounting KFENCE
> objects in allocation profiling and skip them in the related slab hooks.
> 
> We also need to skip kfence objects in mark_obj_codetag_empty() in case
> a sheaf is allocated from kfence, per earlier sashiko review.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  Documentation/mm/allocation-profiling.rst | 7 +++++++
>  mm/slub.c                                 | 9 +++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> index 5389d241176a..d02eb54ee8f2 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -112,3 +112,10 @@ break it out by rhashtable type.
>  
>  - Then, use the following form for your allocations:
>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> +
> +Notes
> +=====
> +
> +- When a slab object is allocated from KFENCE, its accounting is skipped.

should this be 'allocation profiling is skipped' instead?

Otherwise, looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

> +  KFENCE allocations are rare and limited to a small number, so this omission
> +  is negligible.
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..d702d273253c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2067,6 +2067,9 @@ static inline void mark_obj_codetag_empty(const void *obj)
>  	struct slab *obj_slab;
>  	unsigned long slab_exts;
>  
> +	if (is_kfence_address(obj))
> +		return;
> +
>  	obj_slab = virt_to_slab(obj);
>  	slab_exts = slab_obj_exts(obj_slab);
>  	if (slab_exts) {
> @@ -2352,6 +2355,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>  		return;
>  
> +	if (is_kfence_address(object))
> +		return;
> +
>  	slab = virt_to_slab(object);
>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>  	/*
> @@ -2399,6 +2405,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>  	for (i = 0; i < objects; i++) {
>  		unsigned int off = obj_to_index(s, slab, p[i]);
>  
> +		if (is_kfence_address(p[i]))
> +			continue;
> +
>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>  	}
>  	put_slab_obj_exts(obj_exts);
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao

