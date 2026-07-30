Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A625C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA6F6B0095; Thu, 30 Jul 2026 07:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681B06B0096; Thu, 30 Jul 2026 07:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF066B009E; Thu, 30 Jul 2026 07:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2726C6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:58:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D85E80116
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:58:58 +0000 (UTC)
X-FDA: 85045296756.13.37CDB2A
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id BC30B180006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:58:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E3QVxGy8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSaWUAy8Hpb/nee2DyjGbYSGsIFid4w4mDuqKohoXCU=;
	b=6HQ0OAIAVVdb4W/0rLr0OC9muyMZiqCRYrBvUqJvH5Y+ELKBuUS3AJo9BAOnlBTFOuk7HR
	G3cKsQkhsgdbeJPduO83LlMongJJDf9ny2UsPMYI8dv9eHJPKwk0eJvxM/zlM0Ne8coM24
	Twr+46RJOqFzofcd5/07WsLxZ67M/4Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E3QVxGy8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412737;
	b=vbaxkA38rtq+HSVUMujxn22B+QGg2hV2KgD5UU3GJTBhWRVVytrASd+lvzus1FrrqjTBfp
	WdKAyjsc+z05AX4eOOb5f7PxGE7dksrHV6hTESHFbIfAkKlWyH+QhIcU39zA1oB6Ykrx0Q
	dcOvxFb5GSUwH33SIDVnA5fdWDwWT1U=
Date: Thu, 30 Jul 2026 19:58:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785412735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pSaWUAy8Hpb/nee2DyjGbYSGsIFid4w4mDuqKohoXCU=;
	b=E3QVxGy8yudhcFja0MKkdDMYzMnuhzcCSQSsdlE5e53wmdUdbFhHyolr+P668H4l+dajnE
	RSswuz1ykSxW/Jdp1N8nXe6gLq9YjlhSVQCyGTW/fPAWXJ5WHvzg4fzPzfTzSHDlRdDDxC
	EeV/MwBaUMd4HCo3dt0oeR49BEMi1Ug=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <ams72G2rTkobk5Qk@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC30B180006
X-Rspam-User: 
X-Stat-Signature: fnthnpqtdx1ckq5t13joyh3nmmuqnn1f
X-HE-Tag: 1785412736-748423
X-HE-Meta: U2FsdGVkX1/GAASf4iKSp51rPM36dDWSva2YOQHdQfQFd26eqbLb/frU1R5e2bY3uX+5Ixwe3bav+aiiNPcpt6DiD5R2giw9XiZRHR0J0bYMuER9FCLzQPM4YAo4mDRwgFcdb55NyXGKia3WCt9qhWFVza7ExAJg6+Ho7VUYXv+7CiQnBDYRmyCHp6C/iZ0fEX5I/e2FI9j9xSo7kvttipSf4hJNVo1PfgXA3W6dlqe6QjkM9m9NkKcXpDYwd/8MHnC0LxmYd2+qGNz0xLtPGF5hofJSdz7NNzORvq6Mh4DW7/AD63YfN5cEbE2odXXumTgEfQ/fIM2hDSQBcpbAUxBzzTGDlU1H7pe9cq5X1OY+WVft2XUVE6gglngk6/WQ85ik2BJx0cPObVVAGPXwY7Ye0v87ax5g8cw8Q38ZOqAODLIuS0Mqe65wb4axp3f+cTQprj5garMbYn/qNJcxOveZkwmL1RdOVdbvQmm78b2ygJV0L9+s9vsiIJN//kJV/20pXGyXlzKCOhI/KNaSaTFma6RG/Ut5QlKAytadA/psIUAR69B7OLIrgOjXxEqTTHhGH4exop6UQt5q5DW0vfG3iWOMbq7xUn9+n+F1EpYDXCSQVhzAQ+qYqMhBj6eZ19obm7fPu0RRpvumqySWxl4mbOrNMCJoWnKh7RvdkzgYrovo6mec2dNezu+GmnR3i6svmuPF+us9KqwgMMpXtadx2VzQbUruqKwvVeoanz8umZW1V1glQo8ELwqWpa2oUnfujoh3IvcQRepAlIuOJu/EMRO8S18n7z/XuFE6JkjQWT0nTkipiLFBk+4R813qhoo76xZ1dTEkfjqU8TmDkbBR//yLt/HSu220TlFkkR9hi/XQ7Ls11pQUmS4AOE6zlasziWoxgj4PoqTCkmf/vjBtW6ec4R/SU2HXLY62vNlXMlRZqCXUydTTyY7SiK+z2eP0Jy64I/BGjbBAG6a
 Biv0SYyT
 gAhmxn7bpk3QofUtp9ERBJRxeSTUPaard7vNzuwZMagzWrUaiEUWADC9bsSPy7CIZ/pqxGW0S5eUxJFb71BacTp7trypwoEnowVJfRapnquGZKQ8qBrQLij3SON8y2eju/a1yIntzqVBEch0j+LJr9dD5MdCcnZMI7kat4dbJGUPNS53bURlUO5sur2uyIEGz3tbXpUefV5qOKEiqVjOV53JLosrSUYCsdG514xBQVSaOkBJQ7Onel/YBSVXePUhRoKhQLfx1Q+dHjvlVxh8UcO9r98JXuOQP/A76U6XFYb7NPz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:54:02PM +0200, Vlastimil Babka (SUSE) wrote:
> Currently, struct slabobj_ext can hold both objcg pointer and
> codetag_ref (when both are compile-enabled) and there is an array of as
> many slabobj_ext instances as there are objects in a slab.
> 
> This makes the layout fixed so even if codetag_ref is unused (because
> memory allocation profiling is disabled), the space for them is
> allocated and wasted. Similarly, some caches (currently kmalloc_normal)
> do not ever need objcg pointers, leading to wasted memory with memory
> allocation profiling enabled.
> 
> To make this more flexible, change the layout so that struct slabobj_ext
> becomes a union of objcg pointer and codetag_ref (to ensure uniform
> size; in practice both are the same size anyway). The slabobj_ext array
> then can have twice as many elements as before. For cache locality
> purposes, the effective memory layout is unchanged, so objcg and codetag
> ref for a given object are still adjacent.
> 
> cache_obj_ext_size() returns the effective size of (0-2) struct
> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
> both return a constant value derived from the config options, but will
> be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.
> 
> No functional change intended, the layout is still effectively static.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
>  mm/slub.c | 19 +++++++++++--------
>  2 files changed, 50 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 79c758001f98..3f8144b9b9d8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
>  }
>  
>  /*
> - * Extended information for slab objects stored as an array in page->memcg_data
> - * if MEMCG_DATA_OBJEXTS is set.
> + * Extended information for slab objects stored as a pointer to an array in
> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
>   */
>  struct slabobj_ext {
> +	/*
> +	 * All elements of the union should be pointer-sized to avoid memory
> +	 * waste
> +	 */
> +	union {
>  #ifdef CONFIG_MEMCG
> -	struct obj_cgroup *_objcg;
> +		struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	union codetag_ref _ctref;
> +		union codetag_ref _ctref;
>  #endif
> +	};
>  } __aligned(8);
>  
> +static inline size_t cache_obj_ext_size(struct kmem_cache *s)
> +{
> +	size_t sz = 0;
> +
> +	if (IS_ENABLED(CONFIG_MEMCG))
> +		sz += 1;
> +
> +	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
> +		sz += 1;
> +
> +	return sizeof(struct slabobj_ext) * sz;
> +}
> +
> +static inline size_t slab_obj_ext_size(struct slab *slab)
> +{
> +	return cache_obj_ext_size(slab->slab_cache);
> +}
> +
>  #ifdef CONFIG_SLAB_OBJ_EXT
>  
>  /*
> @@ -651,18 +675,18 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>  {
>  	struct slabobj_ext *obj_ext;
>  	unsigned int index;
> +	unsigned int stride;
>  
>  	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
>  
>  	index = obj_to_index(s, slab, obj);
>  
> -	if (!obj_exts_in_object(slab)) {
> -		obj_ext = ((struct slabobj_ext *)obj_exts) + index;
> -	} else {
> -		unsigned int stride = s->size;
> +	if (!obj_exts_in_object(slab))
> +		stride = slab_obj_ext_size(slab);
> +	else
> +		stride = s->size;
>  
> -		obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
> -	}
> +	obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
>  
>  	return kasan_reset_tag(obj_ext);
>  }
> @@ -670,12 +694,14 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>  #ifdef CONFIG_MEMCG
>  static inline struct obj_cgroup *slab_obj_ext_objcg(struct slabobj_ext *obj_ext)
>  {
> +	/* if objcg exists, it comes first, so we don't need to do anything */
>  	return obj_ext->_objcg;
>  }
>  
>  static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>  					  struct obj_cgroup *objcg)
>  {
> +	/* if objcg exists, it comes first, so we don't need to do anything */
>  	obj_ext->_objcg = objcg;
>  }
>  #endif
> @@ -684,6 +710,9 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>  static inline union codetag_ref *
>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>  {
> +	if (IS_ENABLED(CONFIG_MEMCG))
> +		obj_ext += 1;
> +
>  	return &obj_ext->_ctref;
>  }
>  #endif
> diff --git a/mm/slub.c b/mm/slub.c
> index f6ec3618dd1c..9079aaab3235 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -803,7 +803,7 @@ static inline bool need_slab_obj_exts(struct kmem_cache *s)
>  
>  static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
>  {
> -	return sizeof(struct slabobj_ext) * slab->objects;
> +	return slab_obj_ext_size(slab) * slab->objects;
>  }
>  
>  static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
> @@ -1199,7 +1199,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>  	off += kasan_metadata_size(s, false);
>  
>  	if (obj_exts_in_object(slab))
> -		off += sizeof(struct slabobj_ext);
> +		off += slab_obj_ext_size(slab);
>  
>  	if (off != size_from_object(s))
>  		/* Beginning of the filler is the free pointer */
> @@ -1404,7 +1404,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
>  	off += kasan_metadata_size(s, false);
>  
>  	if (obj_exts_in_object(slab))
> -		off += sizeof(struct slabobj_ext);
> +		off += slab_obj_ext_size(slab);
>  
>  	if (size_from_object(s) == off)
>  		return 1;
> @@ -2092,6 +2092,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
>  static inline void handle_failed_objexts_alloc(struct slab *slab,
>  		unsigned long obj_exts, struct slabobj_ext *vec)
>  {
> +	unsigned int stride;
> +
>  	/*
>  	 * If vector previously failed to allocate then we have live
>  	 * objects with no tag reference. Mark all references in this
> @@ -2100,11 +2102,13 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
>  	if (obj_exts != OBJEXTS_ALLOC_FAIL)
>  		return;
>  
> +	stride = slab_obj_ext_size(slab) / sizeof(*vec);
> +
>  	for (unsigned int i = 0; i < slab->objects; i++) {
>  		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
>  
>  		set_codetag_empty(ref);
> -		vec++;
> +		vec += stride;
>  	}
>  }
>  
> @@ -2130,7 +2134,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	unsigned long new_exts;
>  	unsigned long old_exts;
>  	struct slabobj_ext *vec;
> -	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
> +	size_t sz = slab_obj_ext_size(slab) * slab->objects;
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
>  	/*
> @@ -2273,8 +2277,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>  
>  		get_slab_obj_exts(obj_exts);
>  		for_each_object(addr, s, slab_address(slab), slab->objects)
> -			memset(kasan_reset_tag(addr) + offset, 0,
> -			       sizeof(struct slabobj_ext));
> +			memset(kasan_reset_tag(addr) + offset, 0, slab_obj_ext_size(slab));
>  		put_slab_obj_exts(obj_exts);
>  
>  #ifdef CONFIG_MEMCG
> @@ -7933,7 +7936,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  	aligned_size = ALIGN(size, s->align);
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>  	if (slab_args_unmergeable(args, s->flags) &&
> -			(aligned_size - size >= sizeof(struct slabobj_ext)))
> +			(aligned_size - size >= cache_obj_ext_size(s)))

Nit: cache_obj_ext_size() could return 0, and the checking will always be true.
But I think this is harmless.

>  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
>  #endif
>  	size = aligned_size;
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao

