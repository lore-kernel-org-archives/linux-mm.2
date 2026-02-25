Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDA3FD45F5
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA6D6B0088; Wed, 25 Feb 2026 16:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798046B0089; Wed, 25 Feb 2026 16:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679E76B008A; Wed, 25 Feb 2026 16:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53EA86B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:23:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABECE160567
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:23:54 +0000 (UTC)
X-FDA: 84484256388.09.1CBD2B7
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 80F5520010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:23:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="M/MoMFjN";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772054632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlMLp45NDj7DYd86qZChbWO6ROjDFlUvzJJvPaO91OI=;
	b=lbTSDEzkVKcsLW2s9MoAWbsnKN4vTRyHNMDZigEH5h6Rebh7eFmAYYCzcygbTTFeZO2eCU
	xy+es9vY8tbZeMozMRtOwWJBFneTH5QeWnw2Yum6xs61G+mihjsse7ntJvCbaJLgPPDBIb
	bvieBnzdcBevTvX1aC1oWADVRSGy3u4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772054632; a=rsa-sha256;
	cv=none;
	b=w58wOoFmRF20SK3yv+R+Yhqc2fhurXD1XaqpJYZHYgkgQ7dm4JnWupNPBK97VkbGgUVVdP
	t/jTsYJskx1HdkcDyJBlpn0Vt3Z9dqE7y8xPv6w4WcrlUp3nMZTgBXBHaxbHC70e+mbW43
	9XVfHiPKDBm1TV4MH+a7P6aROmgQQk8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="M/MoMFjN";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so262815e9.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772054631; x=1772659431; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IlMLp45NDj7DYd86qZChbWO6ROjDFlUvzJJvPaO91OI=;
        b=M/MoMFjNKhS2xdmqsryX223TqXHhbrc1z1fpaHsyU8dFLWxb98Yl4eKURBbAVsgdzQ
         2leg16PhL7Ejuvtj4cGuUwdEhefjKjkwo0CdD+LVA+7FlXfcjBEWIZv4y9m3nE2pw2ar
         tNit7RSxit89s53qafHpUYCHsEfY4UKz1Wpju3Qd9BArE5HUY9yc8CIv1K/wjQvPT7mU
         LSUzSbX3HCiLIXg4WeF97YTVmnvw2Ua2Gr0AVkK7aSiTOmYk8JZ1fr+PbxUpF5PrhPa8
         KzxWeL0Rg6QPnSf2cClljnPkidWz0LApqXhsw8xapj65SNRpoqjQOrSDVHhoB+elvF5w
         pqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772054631; x=1772659431;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlMLp45NDj7DYd86qZChbWO6ROjDFlUvzJJvPaO91OI=;
        b=hfvf7lZG3kdrtMlMgjt6GDWQtWD4TVQV8WS19yQ+dy0WxnfR3S6K6DplPmHnt+chgT
         wC5uHwCWQHKAJ1PqmjVYv631OAEJSJKaFTaKV8dlJThDnVMtSv71ndOlBhFihHDe3o3X
         ikpepcSGcN6yKt+14CH8o0+wtGkHhVYidD6rL16EjqAKzvzfxXvMXVM2mnLuvKI4lAp4
         akbpxRtzuiTK5eTU6bcyLw9jTm2xFw+C0eWJemZaNRu6dKoJeRCbrNOlDRdnkB1Thju/
         bfmIwpmMh22jSkjfqZdxrkSjCL/czv9ccu7dWUip75GaQyS8ZyjTuLm+jPr0AKasWweP
         /Bjg==
X-Forwarded-Encrypted: i=1; AJvYcCVeou7sN2givfuiCmQ+XGhN0GfDecF81lM4Uzg3zDzEJ8XeWB+Mj7sUV6kB7VWAZaEN5P/csJijOw==@kvack.org
X-Gm-Message-State: AOJu0Yyj+1johIfCovStyhnhCV0b6tZ1xOOyLchdh0601JFPqAFNoG36
	102CjTqbz4baT0jWhp5L4EOgGpQtQddPvzqUCc8hDquRIl35s4i55LwO4k+9iHNuGw0=
X-Gm-Gg: ATEYQzx8fCfOVgqn9EXyA5ZVbezTBSkPty69NHjFxT1qkZ6rDUhr1KT9FfovjpEY6+w
	pJruyh2IeIhIP4oUexTuXD7u7L5msXYTbKFr1zfwoqf2I7PC91VPhh81Jwmn5QzT44f78UIytSu
	t4V7b5gDOLiUe0HplJK/e6U8VIPlO7grlh6p1TAtaMd0UGK2q17iqmIDh5Rd6Fg4SKI289UF/xo
	MIwbpc5Eqxbm/zPXP5Y3I+/pcCWDYcJV2SYiM5k63lflwmUXeLC77fnT2iwxrcQf1fWtVHH3xW6
	tLwglagRyH9rSd+oIa8VbvZIy9W98yJwA8kU5jRenScR6srIBh2miDwILG/dptNaGtg9z66u0T0
	NvKbTtCM7U/pGrpuo2Xje7tN4QhVi1gR8NJDF1Uk1tCLejZwSy2ZtfM/EXC27cyrwfW9o3YT1zp
	2VfAZl6oNwwT3sX5UlFKLQCxtGQevljoj6+17xPdq1QgOXAzFQ+TSe8NjAHoUqqg1u5w==
X-Received: by 2002:a05:600c:4e48:b0:47a:94fc:d063 with SMTP id 5b1f17b1804b1-483a95eb348mr178021595e9.1.1772054630728;
        Wed, 25 Feb 2026 13:23:50 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:654a:5c5e:479:172d? ([2001:1a48:8:903:654a:5c5e:479:172d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c982sm36365573f8f.31.2026.02.25.13.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 13:23:50 -0800 (PST)
Message-ID: <3ab53191-5aac-4b9f-a019-303d837ec517@suse.com>
Date: Wed, 25 Feb 2026 22:23:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm/slab: mark alloc tags empty for sheaves
 allocated with __GFP_NO_OBJ_EXT
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, 00107082@163.com, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260225163407.2218712-1-surenb@google.com>
 <CAJuCfpH-+trdZ=68v0FTj_yKn6+gmE10gKjmjrTyPvO2EaXdRQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.com>
Content-Language: en-US
In-Reply-To: <CAJuCfpH-+trdZ=68v0FTj_yKn6+gmE10gKjmjrTyPvO2EaXdRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: dtofo9ka9yhpr7obq64ntrpw7q5gs5ry
X-Rspamd-Queue-Id: 80F5520010
X-Rspam-User: 
X-HE-Tag: 1772054632-45201
X-HE-Meta: U2FsdGVkX1+TvDFzUOB0H+u+2GbWo65zNnSwPLExiiMEDAOK2YL/oeJuBXM/ZuaeteRZsyYge5JMLTmb7PMfFxofbGP8oQ6q+j+8Tk5F+fVdrpYsZqkaMjVC9djeKiTTifPpV9T3ST5NCUeyKx9eh1g70T1eCkM6N+Yem1yX90eIddlyMvug6x3IcT3XENdtQWTNYg0tRR+NzmftDjzJH7Ip+zbgVVhnKIhpE7/kI8YdC16jjmJSd/x1qaxy5lxIFYo48ug8awoDRIxZadkgf1B6Hbu7d3fa4Pne9is7rSux5FXzg3gGMPbel6rMeXPhAU9m+UqbqUBTNui4ldtjhg0vpZtogGMcUd3bUOMpMl3bt/ohMdHcJ6mQuCaXnWW3mZrqTU8iI/Uhq+y6iSPoLA+92XfJBjdja49ACkuD2bWQ5SdlcQMQ48IcEJRjupIgnon18LtW39jtVIIt1ePx/7MSudab6bsOm+lvma7odOuXRiQyOmyi5Mvzko727YNBFtdlcCb6DzKyDfd8voudneVNUJd6ASEM7CnESZhf1MjF3kqZgwfyRYLNfnZyiQvQdmfEc4DSpIR93iXDBmAlDw7vOXLrPep+MsD1+hoPvVuaIvtzA//ufh8QvDCwvR7O7+IPFlbNVDMBRRH+NYeqhaNJePXyIwWOo2qCPByt2Z1DVjZfCN/v1jeb+cwYci6O7Ld0m3Tbs7gLrinaZHX9uC1uVb7yXZqJZBgiJ+4V9M9BjrDREDnZ3qEB86qeOrMqsVAbJr7hKcXVLIwH268g1sS6136rV3CL+wGCb4zDrrJT76SZgXqj3/Dd/Y6W8lSaF8PohNf+mL2fTcIpXsCX6jfNmxD2Q7NMrNju4oWUv8jzMYrWQI0X00jYHQe3QOit2/mc6M4HKBMm00bdVlzahVBrxwkOf7q20+iYfvOhF4GJPOiT/Wld5sPv8gK1gRpYBLIzWz6jyMpSf9lyhSN
 UNBOpVLW
 lZ9OwrNcMm8703HzLGGpYNDGXDUEx+UR8MixgKMDwDTEMja6yTt4MvJwVx8zAh6LJBGXOImTf4X4FV1rsQNysg9Jwb9RgNGG8JupRMkTuceHvqblx4o37LQ4h/7SPWmNTHrSr3ZA7YeDVpYdXc0EX37G3AW2BV6QooCv9FmVdfl5rSZk+5j5TRDoshcn0VtsWw70a9Mw1GFjW3BjFvBiXmt43CrOr44iXzb0w+EDuWvdIEortvEWYmrbVYDYDuVsUrUxlNBrxoVqdDIIiq3CTQ5dQ+nWzIyxMPz2n6GLgvwkXjbBgOkSp3VZNxOp9FRcCLKHMh3X2FPtXBr1mf/7zpOKIxG5RfBTVz0vm1hHlRwArTefjttITn3XZlz2/IF/Si5jS7yaEzpl/6wynqFZat1TivuNt6U5BnfOw5aGuUMSxPxs1j+BndPfP79k7sKG1ol9mmES5i04GmlPKxLQRU4ht4TiAcitxTVO7oS8JeKJKRaw2U6Mh/TXl/E1rDetaNhk54n8CEjkP1QdjgRnlelhmtFu8J7qwXPR5TeWGZPX6xf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 8:08 PM, Suren Baghdasaryan wrote:
> On Wed, Feb 25, 2026 at 4:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> alloc_empty_sheaf() allocates sheaves from SLAB_KMALLOC caches using
>> __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
>> allocation tags empty before freeing, which results in a warning when
>> CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
>> tags for such sheaves as empty.
>>
> 
> I think this should also have:
> 
> Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_empty_sheaf()")
> 
> and CC to stable for inclusion into 6.19.
> Andrew, Vlastimil, should I post another version CC'ing stable or you
> can add that line and forward to stable?

I will add it. Note, they don't care about getting an actual email, but
seeing the Cc: line in the mainline commit.

>> Reported-by: David Wang <00107082@163.com>
>> Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.com/
>> Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Tested-by: Harry Yoo <harry.yoo@oracle.com>
>> Tested-by: David Wang <00107082@163.com>
>> ---
>>  include/linux/gfp_types.h |  2 ++
>>  mm/slab.h                 |  4 ++--
>>  mm/slub.c                 | 33 +++++++++++++++++++++++----------
>>  3 files changed, 27 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>> index 814bb2892f99..6c75df30a281 100644
>> --- a/include/linux/gfp_types.h
>> +++ b/include/linux/gfp_types.h
>> @@ -139,6 +139,8 @@ enum {
>>   * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
>>   *
>>   * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
>> + * mark_obj_codetag_empty() should be called upon freeing for objects allocated
>> + * with this flag to indicate that their NULL tags are expected and normal.
>>   */
>>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
>>  #define __GFP_WRITE    ((__force gfp_t)___GFP_WRITE)
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 71c7261bf822..f6ef862b60ef 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -290,14 +290,14 @@ static inline void *nearest_obj(struct kmem_cache *cache,
>>
>>  /* Determine object index from a given position */
>>  static inline unsigned int __obj_to_index(const struct kmem_cache *cache,
>> -                                         void *addr, void *obj)
>> +                                         void *addr, const void *obj)
>>  {
>>         return reciprocal_divide(kasan_reset_tag(obj) - addr,
>>                                  cache->reciprocal_size);
>>  }
>>
>>  static inline unsigned int obj_to_index(const struct kmem_cache *cache,
>> -                                       const struct slab *slab, void *obj)
>> +                                       const struct slab *slab, const void *obj)
>>  {
>>         if (is_kfence_address(obj))
>>                 return 0;
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 862642c165ed..34c32749f091 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2041,18 +2041,18 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
>>
>>  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>>
>> -static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>> +static inline void mark_obj_codetag_empty(const void *obj)
>>  {
>> -       struct slab *obj_exts_slab;
>> +       struct slab *obj_slab;
>>         unsigned long slab_exts;
>>
>> -       obj_exts_slab = virt_to_slab(obj_exts);
>> -       slab_exts = slab_obj_exts(obj_exts_slab);
>> +       obj_slab = virt_to_slab(obj);
>> +       slab_exts = slab_obj_exts(obj_slab);
>>         if (slab_exts) {
>>                 get_slab_obj_exts(slab_exts);
>> -               unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
>> -                                                obj_exts_slab, obj_exts);
>> -               struct slabobj_ext *ext = slab_obj_ext(obj_exts_slab,
>> +               unsigned int offs = obj_to_index(obj_slab->slab_cache,
>> +                                                obj_slab, obj);
>> +               struct slabobj_ext *ext = slab_obj_ext(obj_slab,
>>                                                        slab_exts, offs);
>>
>>                 if (unlikely(is_codetag_empty(&ext->ref))) {
>> @@ -2090,7 +2090,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>
>>  #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>
>> -static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
>> +static inline void mark_obj_codetag_empty(const void *obj) {}
>>  static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
>>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>                         struct slabobj_ext *vec, unsigned int objects) {}
>> @@ -2211,7 +2211,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>                  * assign slabobj_exts in parallel. In this case the existing
>>                  * objcg vector should be reused.
>>                  */
>> -               mark_objexts_empty(vec);
>> +               mark_obj_codetag_empty(vec);
>>                 if (unlikely(!allow_spin))
>>                         kfree_nolock(vec);
>>                 else
>> @@ -2254,7 +2254,7 @@ static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
>>          * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
>>          * the extension for obj_exts is expected to be NULL.
>>          */
>> -       mark_objexts_empty(obj_exts);
>> +       mark_obj_codetag_empty(obj_exts);
>>         if (allow_spin)
>>                 kfree(obj_exts);
>>         else
>> @@ -2312,6 +2312,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>>
>>  #else /* CONFIG_SLAB_OBJ_EXT */
>>
>> +static inline void mark_obj_codetag_empty(const void *obj)
>> +{
>> +}
>> +
>>  static inline void init_slab_obj_exts(struct slab *slab)
>>  {
>>  }
>> @@ -2783,6 +2787,15 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
>>
>>  static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>>  {
>> +       /*
>> +        * If the sheaf was created with __GFP_NO_OBJ_EXT flag then its
>> +        * corresponding extension is NULL and alloc_tag_sub() will throw a
>> +        * warning, therefore replace NULL with CODETAG_EMPTY to indicate
>> +        * that the extension for this sheaf is expected to be NULL.
>> +        */
>> +       if (s->flags & SLAB_KMALLOC)
>> +               mark_obj_codetag_empty(sheaf);
>> +
>>         kfree(sheaf);
>>
>>         stat(s, SHEAF_FREE);
>>
>> base-commit: 7dff99b354601dd01829e1511711846e04340a69
>> --
>> 2.53.0.414.gf7e9f6c205-goog
>>


