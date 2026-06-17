Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2BCCD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A176B0005; Wed, 17 Jun 2026 07:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAE86B0088; Wed, 17 Jun 2026 07:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DAC6B008A; Wed, 17 Jun 2026 07:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 778F86B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:53:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE78A4040F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:53:11 +0000 (UTC)
X-FDA: 84889243782.29.5312A02
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id D8994180009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:53:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AROIDs6K;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781697189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGlHWuGXeKrZx4UWzJ913wMAVSNzg6yu/EagxfeXFaY=;
	b=y83q6Jn8YALPlIH/nVLTj1pyCOI0TmtIktWdo2G473+nQci5ySKJIAR/LYHzPj3IV8XjGp
	611lSBNwEqn8fFtIflwMvQBfxWV+4/mwUpGPUKOqxDn0itfK0BCiP/jHl58GfWYaxwllvS
	ZAjnnGaSwb9FwlzM6uuJ4GGu2TV3dXo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781697189;
	b=WT9fw58RbssdcR9XFIEKzR8+fRt8byxgDjW00R7g2SUGkL93lLERCA+UX17D4ahNtscnor
	D3f73kaNUCwpQVPVrfhbw4V0sZUeHgqXgoCUu7stC/XcyUfbWr+X1wJZxKiTzUcRyzSack
	ghyKpZFziHnS8DtJEEpGB40Mno7o0dQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AROIDs6K;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13809223fd4so6127263c88.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:53:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781697188; cv=none;
        d=google.com; s=arc-20240605;
        b=M3s2Ei/YSCB8gLEr6jICORcyZgH4b82rEENteJpfsxfZzrbA+V1iFCrJ5hxdUAUc0o
         PJUfBsIsQuR6vk+5tdS/Sy+dyR97T4NdXGwkv9yvPZv0jGBN/kEavCqJIEuP2ohry3vG
         JHKzDkNnLfyajbUzaxfAGWFfyIpAwR1j1TQJcCWhqaozJ7hnk75lXyJU0b10gytg17vd
         XMRNDuiKZ/3DdDIbWz24t/vCH/1yWlrQin3khY1GWJ5Xuzp3EzjXsLkxMtJPjDETh8Ci
         X0PAx+mSaT4kLGefuwk3lxdeddim8sdaVcqF8IlCh/zy2XoiLeTgdzckI5jrelacAHty
         cHLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cGlHWuGXeKrZx4UWzJ913wMAVSNzg6yu/EagxfeXFaY=;
        fh=0lmjeQ6iMjohLLBuzP4sKvZv21ri7Rn/UJTJjHg16gU=;
        b=Ip2Kqtz8q+nkMMwCQM1X7zJDpoYW89QXKwf1yXZ0J3wZBDtkSGgj/jCkzRS5DssfdI
         ovJdHWir4sIAXhNoQYVbMypJzMHb0AWPNaPGZPlQPhQv7ZIhzEeh8wnkKtf1SXLwn0Xq
         bEve9ab+5tIgrcSxzeDlKSBIA0eo92Pt7kbmtmptv3gGCIg2oRX9wfrnu0pIngqsQsq1
         1rP3FVsFAuXo+GVEx54mnwwxzF/xL/uorOnubt4ZgFqpQIhYvGcKzLjB6zqHdx+YWZ8j
         awBmVdTcLUTL97Obg8+8L7NKDgOn2jBunQMBNiP26yyi2sjTwHcPr2U+j05ao480EI2X
         OhCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781697188; x=1782301988; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cGlHWuGXeKrZx4UWzJ913wMAVSNzg6yu/EagxfeXFaY=;
        b=AROIDs6K5X8Pg0giV0mQjfv+4Bh/HK6UoODEqUNhR6dpRsJ5RZc/4McLHoh/WLHyGv
         D5NuX+KFJy7sNGEM54XQU2+Hlo0wF2OfkUgbJyfhQ1M7purXjqSvcez6HUTJP2MNE0KH
         s6WEZx+P3q0b/bAyZ5UfbUzELcgt8mRGJ2ee4gKHdn3dIKD54d9idmy4Vb3uJNSKw8z5
         mbo+5U8uSYoZ2JGzuqlQHcIfNOEXg5lVcYgg8kXISC8KrVYUKCPUIRHFEXq6FprH4XFS
         JMLD22ChXSssCbSYUsxLpVcEj5+MIhsRIgbNZJ5K8anWvGeo87cI5qGoJJ16gkP3/oKd
         kvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781697188; x=1782301988;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cGlHWuGXeKrZx4UWzJ913wMAVSNzg6yu/EagxfeXFaY=;
        b=oiUVErNp95UN1V5ID61auzc5RYtW1D2YChGtUd20eQA/k7GTBNJ7tgH62udKUKHJAf
         hWCSf+ehmzJkA+x1zVRenoJNGjfcHZ9m3CiiYlrBQ1XR3ld0HX0WlfvUomLzMukCdZMC
         xtta5oKU4qdi5BtjAxsB9Wwp2/bmbs6aexj+WcnOrwXEJMsHfivRDWyM9pIGa4CDgh5F
         PMpWcWFBKRiupdUHYLyQunr7cLAQFS7TfWpmxXOmTZLeMBPBlBcbPQWfTZBylq+mZK8v
         7Nlj1WZ3cDBFsgnMHCgUG0sLeissB878oTQguHbGD8snPdGJ0gdBFyStmSQvW7JjykV8
         Ur1w==
X-Forwarded-Encrypted: i=1; AFNElJ9DCm3MpDYD8VaaDnUjioepPAtuohVlJTJ+QAVFq8c/7lCLK6BVBgs6Es9IPMnP5qG44JjtKCojmQ==@kvack.org
X-Gm-Message-State: AOJu0YwWa2H+33TjBJTA4rRN5CFxxllVW5wUrzG/mG1R9peFgpzZLqhe
	QhmEJt+PeBbVcZd4iZ1/e1UjUG8pj6dGOAxOOBTJ80Itaxyhvk4ju9/JAuW3w06u2RN5obiv13P
	udm01YkTJT9BoGP4e3LSMnL+jevh1eX1Jtjgt+4Bb
X-Gm-Gg: Acq92OEM/8daitmfl/h3tstidGpemuIscr/EwSTlQ9Xy41gR0AX9nRAvm8B7nLwAGDp
	Gw8Y8VccoI0YwFEhfkoIGwWk9I+oIgYZaajyE+ejHOc1xBnSW0yzUT+da4gfVpaMCMpBZTjyuvl
	LLGnNuiyYynl16oJ6TzqM8pfm1dTFYvZQZBJ1bBUSFRih1jja9HRYIrNdZo9dECSFMw/Ov1VD2s
	EJaj9BljYHeFmX6KWwff6WMCMqjbrd3RzxR28PCKt4U8sde6zXndrd9wVYavw8b8uqZgATduDk8
	Hh6TG9zMvdV9rIHsmlWa9AzHdw==
X-Received: by 2002:a05:7022:61b:b0:138:43a4:840a with SMTP id
 a92af1059eb24-1398f6de373mr1539573c88.28.1781697187613; Wed, 17 Jun 2026
 04:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org> <20260615-slab_alloc_flags-v3-1-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-1-ce1146d140fb@kernel.org>
From: Marco Elver <elver@google.com>
Date: Wed, 17 Jun 2026 13:52:30 +0200
X-Gm-Features: AVVi8CeSd8DwGdr5fwTjeMrcXBBqYNOxp4cbPTPDwCMkFfaEjjw7vXGVvvRGZ3o
Message-ID: <CANpmjNNm9jwAHDoNO_u156HEHhAYvSmpbD-rHs9OHdnHAWeKSA@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] mm/slab: do not init any kfence objects on allocation
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D8994180009
X-Rspam-User: 
X-Stat-Signature: q61uisr5ofscpdz3p6un9hpawmjxonnr
X-Rspamd-Server: rspam08
X-HE-Tag: 1781697189-223882
X-HE-Meta: U2FsdGVkX18gjAKaTFb+HsS78MRVvv9gsny1vI90d6O55tjs5qkLtdGAAMVlKAn1YIygxxQRIBtYsOMm+SeaWfguDJpu79BvWbW+En0JeFak5hy+nT6+yXzUHTL+EJJO3CWo7guzTOSV/gNPy6aXyJyTgZwwDsbdili5am81hdqX2mKf5hS8cfrv9snMryjSUkEzC0sNHOJz4CECXRNVs4lPw+dKKPwzjyhOfaaZxlPDcLaRygCZVyMnaSligSoCqeqXb7hevlf4BbjvZq+JKdy80dQBM7hbKgts8re75IzMzjhbVLIdHKlNq39nDIopU069y3oS1GXPss3Py3qQCyKnWnib05OyMfhKiplQ1/suH2QKfOQEYxrpKmdwREEgUiZDiEKBGYsXdRvyVI9VXuqhsyGCM19UrxKYyU67f4Tr5c5IVbe/TIHLZ+ip2+Cdvez7rcEZ+KtLZW3aUJ5JAsNarXdneBI6VGXxk7ozU6NgZ87uHD/LLqra77v/oyjqrLGOcIgYwt0ZAa7MTb9QLLAvyJaynV/ZswbnhzNw1uVgeQ7lO4Ti/kqCYvKCQN3vMinE/uuTZ3Bu9VFDeDq566MqjKtAlFDmBvtpPfze/abhWxsqI5F8rzNYydmV6gmXpTUuOMbqU0vkyKU0JbQucc6objN/rLTLkvd6LgSVYnjyk6Z1iBUtTS9Oh2UdV+/l3t1OuaMlr4MpXcHjHJfaAr2j8wiV/QTByRHggU584a23PqWR+8Js/Tsfdmfm2t8x7qRbb52ZoopSGKYDu1qJCU7BUjkFd2abQ8OIjh0deJpqBg5fW0bl8PitKAh4I5oHOwv/R9oQCi04Q/qpJG82mrTHYTveEus8G7BE4X2VS/zzQotroKITCMn7N3D9QQMtKDxAbTbFHpjxi7TyzgpT+8KbS9OrfvTMZGtnSWvPXlsPhlr8i3XBSZkrlvUr7u65n7ecEVYqYXS5oEMHAai
 9vjZoKth
 T1si/tsMfL5dvkksc64pU9OuXFyxIivgcfxFY1WM/ahcHKS/lGeKYvG5Kymft3ZgFDe+5FWmAOIGqtRiO1/pPuNZz4KSilJ5Wb+1jUcUAZjmlpaitlQfV+QiChuFpYgd1Zrs4bq8niezvyLNz9c27SgUoba39jj13cK1Ea2kUjMPc6LQ7RyaUsX2y0qn7euQRY8ry3mN1lMGMrcfJ4+qUZaV/TQ4e1m/NRzgMrNysqlzCw3C579EoC1lZSaJF9Gb4TLZtXPo8g3NAUKN1ri0Y1U5fPM1P+m3pcqQ3HCNJUwB3Y3I5OnyWMOM/qo8bWXE2iN3Qxtw9ZXYWoYrWi9o9YiQyb2XNDl/e3J0AIywtptTfI1AGFqkcYyVO4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Jun 2026 at 13:54, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>
> When init (zeroing) on allocation is requested, for kmalloc() we
> generally have to zero the full object size even if a smaller size is
> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
>
> When we end up allocating a kfence object, kfence performs the zeroing
> on its own because it has its own redzone beyond the requested size.
> Thus slab_post_alloc_hook() has an 'init' parameter which has to be
> evaluated in all callers (via slab_want_init_on_alloc()) and should be
> false for kfence allocations.
>
> For kfence allocations in slab_alloc_node() this is achieved by subtly
> skipping over the slab_want_init_on_alloc() call. Other callers (i.e.
> kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally even
> if they do end up with a kfence allocation. This is only subtly not a
> problem, as those are not kmalloc allocations and thus the "requested
> size" equals s->object_size and thus it cannot interfere with kfence's
> redzone. There's just a unnecessary double zeroing (in both kfence and
> slab_post_alloc_hook()), but it's all very fragile and contradicts the
> comment in kfence_guarded_alloc().
>
> Remove this subtlety and simplify the code by eliminating the init
> parameter from slab_post_alloc_hook() and make it call
> slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
> check before performing the memset, which will start doing the right
> thing for all callers of slab_post_alloc_hook().
>
> This potentially adds overhead of the is_kfence_address() check to
> allocation hotpath, but that one is designed to be as small as possible,
> and it's only evaluated if zeroing is about to happen. This means (aside
> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
> zeroing itself comes with an overhead likely larger than the added
> check.
>
> While at it, refactor the handling of evaluating when KASAN does the
> init instead of SLUB, with no intended functional changes. A
> non-functional change is that we don't pass kasan_init as true to
> kasan_slab_alloc() if kasan has no integrated init, but then the value
> is ignored anyway, so it's theoretically more correct.
>
> Thanks to Harry Yoo for the initial refactoring attempt, and for updated
> comments that are used here.
>
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kfence/core.c |  2 +-
>  mm/slub.c        | 60 ++++++++++++++++++++++++++------------------------------
>  2 files changed, 29 insertions(+), 33 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 655dc5ce3240..5e0b406924e9 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -500,7 +500,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
>
>         /*
>          * We check slab_want_init_on_alloc() ourselves, rather than letting
> -        * SL*B do the initialization, as otherwise we might overwrite KFENCE's
> +        * slab do the initialization, as otherwise it might overwrite KFENCE's
>          * redzone.
>          */
>         if (unlikely(slab_want_init_on_alloc(gfp, cache)))
> diff --git a/mm/slub.c b/mm/slub.c
> index e2ee8f1aaccf..d762cbe5d040 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4565,13 +4565,13 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
>
>  static __fastpath_inline
>  bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
> -                         gfp_t flags, size_t size, void **p, bool init,
> +                         gfp_t flags, size_t size, void **p,
>                           unsigned int orig_size)
>  {
> +       bool init = slab_want_init_on_alloc(flags, s);
>         unsigned int zero_size = s->object_size;
> -       bool kasan_init = init;
> -       size_t i;
>         gfp_t init_flags = flags & gfp_allowed_mask;
> +       bool kasan_init = false;
>
>         /*
>          * For kmalloc object, the allocated size (object_size) can be larger
> @@ -4588,28 +4588,33 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>                 zero_size = orig_size;
>
>         /*
> -        * When slab_debug is enabled, avoid memory initialization integrated
> -        * into KASAN and instead zero out the memory via the memset below with
> -        * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
> -        * cause false-positive reports. This does not lead to a performance
> +        * ARM64 can set memory tags and zero the memory using a single
> +        * instruction. Since HW_TAGS KASAN uses that while tagging the object,
> +        * separate zeroing is unnecessary.
> +        *
> +        * However, KASAN never zeroes memory when slab_debug is enabled to
> +        * avoid overwriting SLUB redzones. This does not lead to a performance
>          * penalty on production builds, as slab_debug is not intended to be
>          * enabled there.
>          */
> -       if (__slub_debug_enabled())
> -               kasan_init = false;
> +       if (kasan_has_integrated_init() && !__slub_debug_enabled()) {
> +               kasan_init = init;
> +               init = false;
> +       }
>
> -       /*
> -        * As memory initialization might be integrated into KASAN,
> -        * kasan_slab_alloc and initialization memset must be
> -        * kept together to avoid discrepancies in behavior.
> -        *
> -        * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
> -        */
> -       for (i = 0; i < size; i++) {
> +       for (size_t i = 0; i < size; i++) {
>                 p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
> -               if (p[i] && init && (!kasan_init ||
> -                                    !kasan_has_integrated_init()))
> +
> +               /*
> +                * memset and hooks come after KASAN as p[i] might get tagged
> +                *
> +                * kfence zeroes the object instead of SLUB to avoid overwriting
> +                * its own redzone starting at orig_size, which could happen
> +                * with SLUB zeroing full s->object_size
> +                */
> +               if (init && p[i] && !is_kfence_address(p[i]))
>                         memset(p[i], 0, zero_size);
> +
>                 if (gfpflags_allow_spinning(flags))
>                         kmemleak_alloc_recursive(p[i], s->object_size, 1,
>                                                  s->flags, init_flags);
> @@ -4910,7 +4915,6 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>                 gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
>  {
>         void *object;
> -       bool init = false;
>
>         s = slab_pre_alloc_hook(s, gfpflags);
>         if (unlikely(!s))
> @@ -4926,16 +4930,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>                 object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
>
>         maybe_wipe_obj_freeptr(s, object);
> -       init = slab_want_init_on_alloc(gfpflags, s);
>
>  out:
>         /*
> -        * When init equals 'true', like for kzalloc() family, only
> -        * @orig_size bytes might be zeroed instead of s->object_size
>          * In case this fails due to memcg_slab_post_alloc_hook(),
>          * object is set to NULL
>          */
> -       slab_post_alloc_hook(s, lru, gfpflags, 1, &object, init, orig_size);
> +       slab_post_alloc_hook(s, lru, gfpflags, 1, &object, orig_size);
>
>         return object;
>  }
> @@ -5230,7 +5231,6 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
>                                    struct slab_sheaf *sheaf)
>  {
>         void *ret = NULL;
> -       bool init;
>
>         if (sheaf->size == 0)
>                 goto out;
> @@ -5240,10 +5240,8 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
>         if (likely(!ret))
>                 ret = sheaf->objects[--sheaf->size];
>
> -       init = slab_want_init_on_alloc(gfp, s);
> -
>         /* add __GFP_NOFAIL to force successful memcg charging */
> -       slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
> +       slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
>  out:
>         trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
>
> @@ -5423,8 +5421,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>
>  success:
>         maybe_wipe_obj_freeptr(s, ret);
> -       slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
> -                            slab_want_init_on_alloc(alloc_gfp, s), orig_size);
> +       slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
>
>         ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
>         return ret;
> @@ -7339,8 +7336,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
>
>  out:
>         /* memcg and kmem_cache debug support and memory initialization */
> -       return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
> -                       slab_want_init_on_alloc(flags, s), s->object_size));
> +       return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
>
>
> --
> 2.54.0
>

