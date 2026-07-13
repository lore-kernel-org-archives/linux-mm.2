Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0FD2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076556B00A5; Mon, 13 Jul 2026 12:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41FD6B00A6; Mon, 13 Jul 2026 12:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A3F6B00A7; Mon, 13 Jul 2026 12:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2F836B00A5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:14:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91453A01F7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:37:26 +0000 (UTC)
X-FDA: 84984157692.06.FA5BC0C
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD8AF140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:37:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pnn30cGg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxekClyKbeHq/SQiPEb23NUzyXNjRVHW+tL/dlhnD+0=;
	b=U/RJu60w94iwIPjSTwhP8HRVkVGMJdYnqzqz7QCYtLsewYVVwM2IM4Ud1b2Sq1sSnuJzFF
	totkANV3D/A6IEEELoGEedn028muKNt8LC758CugyuFsY+lbCIQ+Vr7UilNhCmDxmvI/54
	ca0gJd5HZRS2A+4PumK9Tj3nbCb9zU0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pnn30cGg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783957044;
	b=6oMbNQaMMjqZ2J+4c2IIYYsAInNQxSeh4UsLvz92fUlW/tS38DMSZcrgOPGMXStRInwBEF
	D0r1iFuseqZWsC6ccYz5OIPbphKtoJqjPvp4KtmEihSyOxO3Sg9JOQJLPel0fHxmeceJng
	hYshlXvcajs8jLtdYL3bJbEFFZOncpM=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c01c79467so537431cf.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:37:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783957044; cv=none;
        d=google.com; s=arc-20260327;
        b=mjrGoD02hD9Ml+A0mwhWYBhvVsuK2+6wVmw91CSSKsGEqj9gi9iWi9nhPLOQEXS3oz
         d2SUws3NfLptqTVzq5TW41WIuX8SIJ0d/VFuXWXu7GkoQm+4SyTnOj9uT2s3Wgns9xbF
         K1sa4AFRw7kvCiZH+AWin5mhRnuC24De3eIov5Y/3EHuQ4OykXGYuCQLusxczwQVe8+Q
         ozgAD4vUNw2afY4PYxZ1nDl9Z25sS6syosa2iAXSoaaX9IAtq96Gb6YZRbdHJ0nQYGxS
         4Vop+gFc8axjg+Bcq8u5K6xaaqWg4aWUKjXhVrpqLoM9KsVNcjTDrPJMP3ValgbHEvsg
         BHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CxekClyKbeHq/SQiPEb23NUzyXNjRVHW+tL/dlhnD+0=;
        fh=7gf3uq1qCECRGnqhj89zY8a7lmYMRKfrf49zuY8Y1yM=;
        b=InyCzIpSPsDKGp03vipmfvDEQygE9TRuL9TchFdlNJDLEqfQ/073AOzTuDlRp5GJhJ
         IMLXSzbe7MucIYqocR40DTbHCOG6N5u2XzGcKMz/dkuMkWiaBGqIBj7fLuP1vN3t3pg+
         v8P2/8WOn2b/J6RXKXYETLh+7FHxhUi/qDoHf6tnAFSh3YTlY5w83I0Q20sBiYA9ykE/
         DKsABqFxHse41figefL4kaClHUJ8aa6UAeaXBGXiF0uY8JStfu2CcKziiZvEcMBsJq9J
         Yni79fA7FDwQBlUaJ9GHnYxwQin0pyf5IvXy2GWN+NQqjR8TmnR0ZbVpJErpHRte38Rt
         QjUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783957044; x=1784561844; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CxekClyKbeHq/SQiPEb23NUzyXNjRVHW+tL/dlhnD+0=;
        b=pnn30cGgmG7XQhlBCfVTh9cD0aM74eSISowG0dAbQK3BAk7odWU97428z51+K5NHzo
         OLWvDnZrRmHL28/FM39P3qfj6CU0AbseivDi5mROqUPDBSQhQSjk8sV+hW5tJncILxRn
         CcA8msPUnMuj2qVBFWoU+Ak30kgC6LtcB0U/rAvuhSkHAu3pePbmEUswNqqIb/q71bYS
         BvK2kEn7W5K84ZcKgAkbotltG6GjDfPpAJIbKpATC4NyWYb1RTE2uQQ7HIU7L5BoYaDY
         NLZx0Mf9GZ0+NVGnpGslxkaPvnxYIdblcOcTdsTFkoOQGqVwc51mtkjvA7yvRJqeUoN4
         IJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783957044; x=1784561844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CxekClyKbeHq/SQiPEb23NUzyXNjRVHW+tL/dlhnD+0=;
        b=hBDmxwOdA3mlSzbcKfTaFB+rXyyJ54pmolu+HMMBoUr8hfQAMwA2i8GyFJ5sefuvfE
         ZOaQF5Gocgt0JzHqrIZ8nAiLc5irTVCFad4G5nvE8OSzoFi9M+1WtNz5Qp3FembP082R
         BSooe87ClA7lrJ+ODzNIt89iIhPvDYjnUYJjbBPR52Y5wSgg7UMTX8UrgSv7TUAh/flC
         9dwRUp6LzDDqdeNAFEeFM+yfjGZxpg1FQMfHt2ty6PUtxtDWAbsXGhxFJVMt3FC/ZDVJ
         LVGimQD8Vc2l5TefL0HSmG9k/pUD7Y3rUPfKTwtvs72wAR1FSCrO6ZlTHjflazzDoRzw
         e/3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr2KdUZ6ImlydIfFRcSVG5JqiV61jvkKynhG4munqtL1OX0R/ZdrAMmi3tmS0lWWaDgOPDcS7V+Eg==@kvack.org
X-Gm-Message-State: AOJu0YyMEwTMvhcpiHKTU7h+/WnrDPUuFZwiSPuUEd9NmfI+OS+0GOPB
	/PhmnyUv6H2a6UO11CNDpbxPnMcSQPwCfVlRVr1BSyxkAco4DW5UcO6i+pn5AIymRLz67aHn7IW
	+2u2znQTXpUEOk2S2hd002Jhp+Z/S0qSXfvhsR/jE
X-Gm-Gg: AfdE7cnMknUAnrjBBvEXarkT+qrWfR2FF7tKnCAeKXQnEqziCYKnQFdYTNID+3ctTfJ
	pzBFfcCQ299SEpC7nD9/App5gs1gr2loOjY0ofw1AhtKX+xyV59utrZglnGRP1PUN2G6/Bho7D8
	4c4hJUJgVRnDxdv+cO/oEx0ObMSM0mYkkc7do7NASygQT4nwkLP7ukgwMWCSt+ZkLuNZauL4XI2
	x3AMQkdn8YcWmEsNMoHm3IjN4bj8oV4W/oa8obFiFePs61qv8wEKdVo1J/f94C8aROaQxUzlt19
	iFdkoA==
X-Received: by 2002:a05:622a:5c12:b0:51c:7a8b:c400 with SMTP id
 d75a77b69052e-51d7bdba404mr4186721cf.25.1783957042548; Mon, 13 Jul 2026
 08:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org> <20260713-kmalloc-no-objext-v3-2-47c7bd138de7@kernel.org>
In-Reply-To: <20260713-kmalloc-no-objext-v3-2-47c7bd138de7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 08:37:10 -0700
X-Gm-Features: AUfX_mw5Gs4CVk5RU8y7AzBGaywixRe7-3wPnzztgiBH-H5S4ytW8k8wne8xUOM
Message-ID: <CAJuCfpH-_86bTBPFtq0MZbF_TvUGRpDoD7yaNPDDNA9nb2=V3Q@mail.gmail.com>
Subject: Re: [PATCH slab/for-next-fixes v3 2/4] mm/slab: decouple
 SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p5jixq4syoikp5bf7ekp6zbo48zdhbdz
X-Rspamd-Queue-Id: AD8AF140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783957044-848778
X-HE-Meta: U2FsdGVkX19BCxUQDoktEkeaWwxWZQbgrv1/wD0MzltHG/rbKqLnkJxjOHDaNk4DbZZJzaUABqGLC6SfjM4iE64MR3jLD+d+XWYMq9dciwjr+iZsTlA18GjeIPplFkfi60ZSKZaNp5FyErzpzcqllo1BjD2B+5YOlb7qtLMO1jQEmQUnUbkTgaOcdSxMbNZew/RLm0yixbVJ5rPfHB2t18CXWhkI0+wOeK0Dqbb3TgciNFCMZsrBDx5TIS0BnmtP/XQkpuWRBNFg3CCrQPsqXfhcomJ9Im0LcbUB+iFl2Qb1QDbApQxiudaihyZJBrI8OFt0rbX25ejSKZcb+tWqs9oJI4L7H2ZVponbJG/DZ4Tb+uvx2Pxv+DDOR1Jiwt9ygyBiSq5ZXtVCInP45YtfoZznNrkyp/eaVpmFxACmxtSURyRWhNhWJftsBFu0f4e+gmuMKotpHIDOx8WSLbxNTwP4PXll87PYvYh3I6ZTa1ARqHK3fk6XG2FXMa/9uJONaMjboDmQ0qW+fQtSODSs+fArRkagbVSlhkeZdcv+5B+n35hISanh0YdHNoznfVE1tieD/7IYwRQ0P2UU25LkX9Tj56BF5twqV3mppUlxgVpsALw6Ik0F2IwjSz5PgLr4yuVWQFVtIdDdwgP9lnI1CZAQbLRtQD9yo+PAQsF1H7J/1gKSm539qCaKK7QaMyFWJXXFNTLXNTfyxHD/M3aP/ie6EMTjx+wFqSr7Uu0LbOon2YI761Omq6BHaDVbNVqZKm2YLQDakDhX3o7BogAT/9f+P+UnP8MrF8MUgSzR+LQSr7efOW5didrlEix0Ztwp1oIyjJx7HbvSljq8itIkOH3OW/mqrHoGhvXWd4tO5vQ7WijYkfTIK0nmitBVoeeM5K1+4j92DXZGj1PcWAxujwevikWBtqwZmz/+kMRCjIBuBDhXB2vg8JDQVnpu5HipGpGf8zm/evXQN1/pcG7
 Ytb1Ye77
 vxcZU8LWkHWlfEWRwCFvuyJerlI/NXu4LiPHn3WwbPUWy7OVSvtIa+PAbzuyP1VKZjl1gy2hXeGoSKMHMEszf3X8MkTQIchWOxuGht4jdNo2PU/HhIZfJfbQYEo2ATeojMV2T6ursv3zwgOCqVr5mxAd0JP7prWHEXlCsC5EdSj6wUWxccim64ftqqZcjawMvKcEqQiXQcDkv506nqslhwiEfq6erC3EhSSfQwBcRyNUv55fVggzQuC5/+DZ8Y6SiGJNgEfu0XAitFArfsJZlqn6ccygML0l3JXd7QQsNAEkUzqlUSrYhdNezIjGWkCsHOLvJNvzOtsSx4W8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> Bootstrap caches are created with SLAB_NO_OBJ_EXT to disallow sheaves
> and obj_exts.
>
> To allow disabling obj_exts while allowing sheaves, decouple
> SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT. Bootstrap caches now have both
> SLAB_NO_SHEAVES and SLAB_NO_OBJ_EXT.
>
> No functional change intended.
>
> Cc: stable@vger.kernel.org
> Fixes: e47c897a2949 ("slab: add sheaves to most caches")
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/slab.h | 13 +++++++++++--
>  mm/slub.c            | 10 ++++++----
>  2 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 51f03f18c9a7..08d7b6c9c4d6 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -58,10 +58,13 @@ enum _slab_flag_bits {
>  #endif
>         _SLAB_OBJECT_POISON,
>         _SLAB_CMPXCHG_DOUBLE,
> +#ifdef CONFIG_SLAB_OBJ_EXT
>         _SLAB_NO_OBJ_EXT,
> -#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +#ifdef CONFIG_64BIT
>         _SLAB_OBJ_EXT_IN_OBJ,
>  #endif
> +#endif
> +       _SLAB_NO_SHEAVES,
>         _SLAB_FLAGS_LAST_BIT
>  };
>
> @@ -239,8 +242,14 @@ enum _slab_flag_bits {
>  #endif
>  #define SLAB_TEMPORARY         SLAB_RECLAIM_ACCOUNT    /* Objects are sh=
ort-lived */
>
> -/* Slab created using create_boot_cache */
> +/* Slab caches without obj_exts array */
> +#ifdef CONFIG_SLAB_OBJ_EXT
>  #define SLAB_NO_OBJ_EXT                __SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
> +#else
> +#define SLAB_NO_OBJ_EXT                __SLAB_FLAG_UNUSED
> +#endif
> +
> +#define SLAB_NO_SHEAVES                __SLAB_FLAG_BIT(_SLAB_NO_SHEAVES)
>
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>  #define SLAB_OBJ_EXT_IN_OBJ    __SLAB_FLAG_BIT(_SLAB_OBJ_EXT_IN_OBJ)
> diff --git a/mm/slub.c b/mm/slub.c
> index f9461a0c47d3..abe748b7dddb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7799,12 +7799,12 @@ static unsigned int calculate_sheaf_capacity(stru=
ct kmem_cache *s,
>                 return 0;
>
>         /*
> -        * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
> +        * Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES).
>          * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must n=
ot
>          * have sheaves to avoid recursion when sheaf allocation triggers
>          * kmemleak tracking.
>          */
> -       if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> +       if (s->flags & (SLAB_NO_SHEAVES | SLAB_NOLEAKTRACE))
>                 return 0;
>
>         /*
> @@ -8586,7 +8586,8 @@ void __init kmem_cache_init(void)
>
>         create_boot_cache(kmem_cache_node, "kmem_cache_node",
>                         sizeof(struct kmem_cache_node),
> -                       SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
> +                       SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OB=
J_EXT,
> +                       0, 0);
>
>         hotplug_node_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
>
> @@ -8596,7 +8597,8 @@ void __init kmem_cache_init(void)
>         create_boot_cache(kmem_cache, "kmem_cache",
>                         offsetof(struct kmem_cache, per_node) +
>                                 nr_node_ids * sizeof(struct kmem_cache_pe=
r_node_ptrs),
> -                       SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
> +                       SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OB=
J_EXT,
> +                       0, 0);
>
>         kmem_cache =3D bootstrap(&boot_kmem_cache);
>         kmem_cache_node =3D bootstrap(&boot_kmem_cache_node);
>
> --
> 2.53.0
>

